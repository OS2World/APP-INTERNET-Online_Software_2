/*
 * Filename: Software2.REX
 *   Author: JanErik
 *  Created: Tue Sep 18 2018
 *  Purpose: Display available software to the user for download
 *  Changes: Tue Sep 18 2018 - Complete rewrite
 */

main_Init:

   env = 'OS2ENVIRONMENT'

   IF \RxFuncQuery( 'SysDropFuncs' ) THEN
      CALL SysDropFuncs
   IF RxLoadLib( 'SysLoadFuncs', 'RexxUtil' ) THEN
   DO
      CALL VAL 'Abort', 1
      EXIT ModalFor( 'msgbox' )
   END

   CALL VAL 'HOME', VALUE( 'HOME',, env )'\.cache\eCSoft'
   CALL VAL 'INI', VAL( 'HOME' )'\eCSoft2.ini'

   CALL VAL 'downloads', SysIni( VAL( 'INI' ), 'OnlineSoftware', 'downloads' )
   IF 0 < POS( 'ERROR:', VAL( 'downloads' ) ) THEN
      CALL VAL 'downloads', 'C' /* ClipBoard */

   CALL VAL 'params', SysIni( VAL( 'INI' ), 'OnlineSoftware', 'params' )
   IF 0 < POS( 'ERROR:', VAL( 'params' ) ) | LENGTH( VAL( 'params' ) ) < 5 THEN
      CALL VAL 'params', Result( Start( 'RxChkParams' ) )

   CALL VAL 'wSize', SysIni( VAL( 'INI' ), 'OnlineSoftware', 'wSize' )
   IF \DATATYPE( SPACE( VAL( 'wSize' ), 0 ), 'W' ) THEN
      CALL VAL 'wSize', '640 480'

   CALL VAL 'xyPos', SysIni( VAL( 'INI' ), 'OnlineSoftware', 'xyPos' )
   CALL VAL 'sSize', ScreenSize()

   CALL VAL 'efield', SysIni( VAL( 'INI' ), 'OnlineSoftware', 'efield' )
   IF \DATATYPE( VAL( 'efield' ), 'W' ) THEN
      CALL VAL 'efield', 20
   
   CALL VAL 'isBusy', 0
   CALL VAL 'app0', 0
   CALL VAL 'sbar', 14
   CALL VAL 'wfield', 20
   CALL VAL 'timeguard', TIME( 'S' ) - 1
   CALL VAL 'rowheight', 126
   CALL VAL 'viewport.0', 0
   CALL VAL 'viewport_rows', 2
   CALL VAL 'wimg', ( VAL( 'rowheight' ) - 6 - VAL( 'wfield' ) ) * 1.42 % 1

   PARSE SOURCE . . !_this_!
   PARSE VALUE REVERSE( !_this_! ) WITH .'\'!_path_!
   CALL DIRECTORY REVERSE( !_path_! )
   
   IF \RxFuncQuery( 'DRCtrlDropFuncs' ) THEN
      CALL DRCtrlDropFuncs
   DO i = 20 TO 15 BY -1
      DLLVERSION = 'drctl0'i
      IF \RxLoadLib( 'DRCtrlLoadFuncs', DLLVERSION ) THEN
         IF \RxLoadLib( 'DRCtrlPickDirectory', DLLVERSION, 1 ) THEN
            IF RxLoadLib( 'DRCtrlSetParent', DLLVERSION, 1 ) THEN
            DO
               CALL DRCtrlDropFuncs
               EXIT RxMessageBox( 'This application need DrCtrl 0.1.7 by Chris Wolgemuth', 'Install DrCtrl 0.1.7', 'Cancel', 'Error' )
            END
            ELSE LEAVE
   END
   IF i < 15 THEN
      EXIT RxMessageBox( 'This application need DrCtrl 0.1.7 by Chris Wolgemuth', 'Install DrCtrl 0.1.7', 'Cancel', 'Error' )

   IF RxLoadLib( 'rxImgLoadFuncs', 'rxImgSze' ) THEN
      EXIT RxMessageBox( 'This application need rxImgSze 1.0.3 by Jan-Erik L„rka', 'Install rxImgSze 1.0.3', 'Cancel', 'Error' )
   !_GBM_OK_! = SysIni( VAL( 'INI' ), 'OnlineSoftware', 'GBM' )
   IF !_GBM_OK_! <> 1 THEN
      !_GBM_OK_! = ( 0 < POS( 'WAT', TRANSLATE( RxChkDLL( 'GBM.DLL', '(GBM,', ) ) ) )
   IF !_GBM_OK_! <> 1 THEN
   DO
      IF RxMessageBox( 'This application need GBM.DLL built with OpenWatcom. ',
         'You may experience instability and unresonably large images with the',
         'current version of GBM.DLL available on your system. ',
         '',
         'Do you want to continue anyway?', 'Install OpenWatcom GBM.DLL', 'YesNo', 'Query' ) = 7 THEN
         EXIT 5
   END
   CALL SysIni VAL( 'INI' ), 'OnlineSoftware', 'GBM', 1

   CALL VAL 'iDate', STRIP( SysIni( 'USER', 'PM_National', 'iDate' ), 'T', D2C(0) )
   CALL VAL 'sDate', STRIP( SysIni( 'USER', 'PM_National', 'sDate' ), 'T', D2C(0) )

RETURN 0

main_Open:
   DO WHILE VAL( 'sDate' ) = '' & VAL( 'iDate' ) = ''
      CALL Sleep 500
      IF VAL( 'Abort' ) = 1 THEN RETURN
   END
   CALL viewport.open
   PARSE VALUE VAL( 'wSize' ) WITH dw dh
   PARSE VALUE VAL( 'sSize' ) WITH sw sh
   IF \DATATYPE( SPACE( VAL( 'xyPos' ), 0 ), 'W' ) THEN
      CALL Position ( sw - dw ) / 2 % 1, ( sh - dh ) / 2 % 1, dw, dh
   ELSE DO
      PARSE VALUE VAL( 'xyPos' ) WITH x y
      CALL Position x, y, dw, dh
   END
   CALL main_Size
   CALL Show
   CALL category.open 'dropdown'
   CALL dropdown.Owner 'main'
   CALL dropdown.C502.View 'D'
   CALL category.open
   CALL category.Owner 'main'
   CALL category.C502.View 'D'
   CALL zoom.open
   CALL settings.open
   CALL tooltip.Open
   CALL Start 'RxCategories'
RETURN 0

main_Size:
   PARSE VALUE main.Position() WITH x y w h
   IF -32000 < x THEN
   DO
      PARSE VALUE main.Frame() WITH l b r t
      visible = main.c105.Visible()
      DO i = 101 TO 111
         CALL HideFor 'main', 'C'i
      END
      wpos = w - l - r - 3 * VAL( 'wfield' ) - 2 * VAL( 'efield' ) + 1
      ypos = h - t - VAL( 'efield' )
      ttl = t - b - 2
      CALL main.c101.Text '#'||( 117 + ( 20 < VAL( 'efield' ) ) )
      CALL main.c101.Position l, ypos - 1, VAL( 'efield' ), VAL( 'efield' )
      CALL main.c102.Position l + VAL( 'efield' ), ypos - 2, VAL( 'wfield' ), VAL( 'efield' ) + 2
      CALL main.c103.Position l + VAL( 'efield' ) + VAL( 'wfield' ), ypos - 1, wpos, VAL( 'efield' )
      CALL main.c104.Position l + VAL( 'efield' ) + VAL( 'wfield' ) + 2, ypos + 1, wpos - 4, VAL( 'efield' ) - 4
      CALL main.c105.Position l + ttl + 3, h - ttl - b - 1, w - l - r - 4 * ( ttl + 2 ) - 2, ttl
      CALL main.c106.Position l + VAL( 'efield' ) + VAL( 'wfield' ) + 2, ypos + 1, wpos - 4, VAL( 'efield' ) - 4
      CALL main.c107.Position w - r - 2 * VAL( 'wfield' ) - VAL( 'efield' ) + 1, ypos - 2, VAL( 'wfield' ), VAL( 'efield' ) + 2
      CALL main.c108.Position w - r - 1 * VAL( 'wfield' ) - VAL( 'efield' ), ypos - 2, VAL( 'wfield' ), VAL( 'efield' ) + 2
      CALL main.c109.Text '#'||( 120 + ( 20 < VAL( 'efield' ) ) )
      CALL main.c109.Position w - r - 1 * VAL( 'efield' ), ypos - 1, VAL( 'efield' ), VAL( 'efield' )
      CALL main.c110.Position l, b, w - l - r, h - t - b - VAL( 'efield' ) - 2
      CALL main.c111.Position w - r - VAL( 'sbar' ) - 1, b + 1, VAL( 'sbar' ), h - t - b - VAL( 'efield' ) - 4
      CALL main.c112.Position 0, 0, VAL( 'sbar' ), h - t - b - VAL( 'efield' ) - 2
      CALL main.c113.Position l + VAL( 'efield' ) + VAL( 'wfield' ), ypos - 1, wpos, VAL( 'efield' )
      CALL viewport.Position l + 2, b + 2, w - l - r - VAL( 'sbar' ) - 3, h - t - b - VAL( 'efield' ) - 6
      DO i = 101 TO 111
         IF isBetween( 103, i, 107 ) THEN ITERATE i
         CALL ShowFor 'main', 'C'i
      END
      IF visible THEN
         CALL ShowFor 'main', 'C105'
   END
   CALL main.c106.Visible ( 4 < LENGTH( VAL( 'params' ) ) )
   CALL main.c113.Visible \main.c106.Visible()
   CALL main.c113.Top
   CALL VAL 'isBusy', 0
   IF \main.Visible() THEN
      CALL Show
RETURN 0

viewport_Size:
   PARSE VALUE main.Position() WITH x y w h
   IF -32000 < x THEN
   DO
      PARSE VALUE main.Frame() WITH l b r t
      PARSE VALUE viewport.Position() WITH . . . ch
      PARSE VALUE VAL( 'sSize' ) WITH . dy
      apps = ( MAX( dy, h ) - t - b - VAL( 'efield' ) - 2 ) % VAL( 'rowheight' ) + 1
      CALL VAL 'viewport_rows', ch % VAL( 'rowheight' )
      IF DATATYPE( VAL( 'app0' ), 'W' ) & VAL( 'app0' ) < apps THEN
      DO
         DO i = 1 TO VAL( 'app0' )
            CALL CloseFor 'app'i
         END
         CALL viewport.close
      END
      CALL VAL 'app', 0
      IF VAL( 'app0' ) < apps THEN
      DO
         CALL viewport.open
         DO i = 1 TO apps
            IF \row.Open( 'app'i ) Then
            DO
               apps = i - 1
               LEAVE
            END
         END
         CALL VAL 'app0', apps
      END
      !_selected_! = main.c111.Select()
      CALL VAL 'viewport_range', MAX( 1, VAL( 'viewport.0' ) - VAL( 'viewport_rows' ) )
      CALL main.c111.Range 1, VAL( 'viewport_range' )
      CALL main.c111.Select MIN( VAL( 'viewport_range' ), !_selected_! )
      !_overflow_! = 0
      IF main.c111.Select() = VAL( 'viewport.0' ) - VAL( 'viewport_rows' ) THEN
         !_overflow_! = VAL( 'rowheight' ) - ch // VAL( 'rowheight' )
         IF 60 < w & 60 < h THEN
         DO i = 1 TO VAL( 'app0' )
            CALL PositionFor 'app'i,, 0, h - i * VAL( 'rowheight' ) - t - b - VAL( 'efield' ) - 6 + !_overflow_!, w - l - r - VAL( 'sbar' ), VAL( 'rowheight' )
         END
   END
RETURN 0

viewport_Attach:
   IF \viewport.Visible() THEN
   DO
      CALL DRCtrlSetParent 200, 100
      CALL viewport.Visible 1
   END
   DO i = 1 TO VAL( 'app0' )
      CALL VisibleFor 'app'i,, 1
   END
RETURN

row_Init:
   CALL Color '-', '#0'
   CALL c404.Font '9.WarpSans.Underscore'
   CALL c404.Color '+', '#0 0 200'
   CALL c405.Font '9.WarpSans'
   CALL c406.Font '9.WarpSans Bold'
   CALL c407.Font '9.WarpSans'
   CALL c408.Font '9.WarpSans'
RETURN 0

row_Open:
   CALL DRCtrlSetParent id(), 200
   CALL row_Size
RETURN 0

row_Size:
   PARSE VALUE Position() WITH . . w h
   CALL VAL 'wimg', ( VAL( 'rowheight' ) - 6 - VAL( 'wfield' ) ) * 1.42 % 1
   wdate = 75
   hrow = ( VAL( 'rowheight' ) - 6 - VAL( 'wfield' ) ) % 4 - 1
   CALL c401.Text '#103'
   CALL c401.Position 0, 0, w, h
   CALL c403.Position 0, VAL( 'wfield' ) + 6, VAL( 'wimg' ), h - 6 - VAL( 'wfield' )
   CALL c402.Position 0, VAL( 'wfield' ) + 6, VAL( 'wimg' ), h - 6 - VAL( 'wfield' )
   CALL c402.Top
   CALL c404.Position 0, 1, VAL( 'wimg' ) - VAL( 'wfield' ) - 1, hrow
   CALL c405.Position VAL( 'wimg' ) - VAL( 'wfield' ), 1, VAL( 'wfield' ), hrow
   CALL c406.Position VAL( 'wimg' ) + 1, h - hrow, w - VAL( 'wimg' ) - wdate - 3, hrow
   CALL c407.Position w - wdate - 1, h - hrow, wdate - 2, hrow
   CALL c408.Position VAL( 'wimg' ) + 1, 1, w - VAL( 'wimg' ) - 2, h - 6 - VAL( 'wfield' )
   CALL c409.Position 0, 1, VAL( 'wimg' ) - VAL( 'wfield' ) - 1, hrow
   CALL VAL 'app', VAL( 'app' ) + 1
   IF VAL( 'app' ) = VAL( 'app0' ) THEN CALL viewport_Attach
RETURN

row_Visible:
IF STRIP( Text() ) <> '' THEN
DO
   !_j_! = RxGetRow()
   IF !_j_! = '' THEN
      RETURN 1
   IF DATATYPE( !_j_!, 'W' ) THEN
   DO
      IF RxFileExists( VAL( 'viewport.'!_j_!'.dwnld' ) ) THEN
      DO
         CALL SysSetObjectData  VAL( 'viewport.'!_j_!'.dwnld.hdd' ), 'OPEN=DEFAULT'
         CALL VAL 'viewport.'!_j_!'.dwnld.clr', '#200 0 200'
      END
      ELSE IF VAL( 'downloads' ) = 'C' THEN
      DO
         retval = Clipboard( VAL( 'viewport.'!_j_!'.dwnld' ) )
         CALL VAL 'viewport.'!_j_!'.dwnld.txt', 'Copied to clipboard'
         CALL VAL 'viewport.'!_j_!'.dwnld.clr', '#200 0 200'
      END
      ELSE IF VAL( 'downloads' ) = 'D' THEN
      DO
         retval = RxCreateURL( VAL( 'viewport.'!_j_!'.dwnld' ), '<WP_DESKTOP>', '<WP_'||H2C( C406.Text() )||'>', C406.Text() )
         CALL VAL 'viewport.'!_j_!'.dwnld.txt', 'Desktop URL created'
         CALL VAL 'viewport.'!_j_!'.dwnld.clr', '#200 0 200'
      END
      ELSE
      DO 
         IF VAL( 'downloads' ) = 'A' THEN
         DO
            !_temp_! = DRCtrlPickDirectory( VAL( 'HOME' ), 'Save to directory' )
            IF LENGTH( !_temp_! ) < 4 THEN
               RETURN 1
         END
            ELSE IF LENGTH( STRIP( VAL( 'downloads' ) ) ) < 4 THEN
               RETURN 2
            ELSE DO
               old_dir = DIRECTORY()
               !_temp_! = DIRECTORY( VAL( 'downloads' ) )
               CALL DIRECTORY old_dir
               IF !_temp_! = '' THEN RETURN 3
            END
         CALL C409.Show
         CALL C404.Hide
         CALL VAL 'viewport.'!_j_!'.0', 0
         CALL Start 'RxDownload', VAL( 'viewport.'!_j_!'.dwnld' )||D2C(9)||!_temp_!||D2C(9)||!_j_!
         DROP !_temp_!
      END
      CALL row_Populate
   END
END
RETURN 0

row_Populate:
   IF DATATYPE( ARG(1), 'W' ) THEN
   DO
      !_start_! = MAX( MIN( ARG(1), VAL( 'viewport.0' ), VAL( 'app0' ), VAL( 'viewport_rows' ) ), 1 )
      !_j_! = !_start_! - 1
      !_rows_! = !_start_!
      !_stop_! =  !_rows_!
   END
   ELSE DO
      !_start_! = 1
      !_j_! = MAX( main.c111.Select(), 1 ) - 1
      !_rows_! = MIN( VAL( 'viewport.0' ), VAL( 'app0' ), VAL( 'viewport_rows' ) + 1 )
      !_stop_! = MAX( !_rows_!, VAL( 'viewport_rows' ) + 1 )
   END
   DO !_i_! = !_start_! TO !_stop_!
      !_j_! = !_j_! + 1
      IF !_rows_! < !_i_! THEN
      DO !_k_! = 2 TO 8
         CALL TextFor 'app'!_i_!, 'C40'!_k_!, ' '
         CALL HintFor 'app'!_i_!,, ''
      END
      ELSE IF 0 < !_i_! THEN DO
         CALL HintFor 'app'!_i_!,, !_j_!
         CALL HintFor 'app'!_i_!, 'C401', 'app'!_i_!
         CALL TextFor 'app'!_i_!, 'C406', VAL( 'viewport.'!_j_!'.name.a' )
         CALL TextFor 'app'!_i_!, 'C407', D2L( VAL( 'viewport.'!_j_!'.updated_date' ) )
         
         !_val_! = ''
         IF DATATYPE( VAL( 'viewport.'!_j_!'.developer.0' ), 'W' ) THEN
         DO !_k_! = 1 TO VAL( 'viewport.'!_j_!'.developer.0' )
            !_val_! = !_val_!||VAL( 'viewport.'!_j_!'.developer.'!_k_! )||' '
         END
         ELSE !_val_! = VAL( 'viewport.'!_j_!'.developer.a' )
         
         !_val_! = ''
         IF DATATYPE( VAL( 'viewport.'!_j_!'.sshot.0' ), 'W' ) THEN
         DO !_k_! = 1 TO VAL( 'viewport.'!_j_!'.sshot.0' )
            !_val_! = RxLoadImage( 'viewport.'!_j_!'.sshot.'!_k_!'.img.src' )
            CALL VAL 'viewport.'!_j_!'.sshot.'!_k_!'.img.src', !_val_!
            CALL VAL 'viewport.'!_j_!'.sshot.'!_k_!'.href', RxLoadImage( 'viewport.'!_j_!'.sshot.'!_k_!'.href' )
         END
         ELSE DO
            !_val_! = RxLoadImage( 'viewport.'!_j_!'.sshot.a.img.src' )
            CALL VAL 'viewport.'!_j_!'.sshot.a.img.src', !_val_!
            CALL VAL 'viewport.'!_j_!'.sshot.a.href', RxLoadImage( 'viewport.'!_j_!'.sshot.a.href' )
         END
         CALL TextFor 'app'!_i_!, 'C403', STRIP( !_val_! )        
         CALL VAL 'viewport.'!_j_!'.dwnld', STRIP( VAL( 'viewport.'!_j_!'.dwnld' ) )
         IF isBetween( -1, VAL( 'viewport.'!_j_!'.0' ), 100 ) THEN
         DO
            CALL HideFor 'app'!_i_!, 'C404'
            CALL ShowFor 'app'!_i_!, 'C409'
            CALL SelectFor 'app'!_i_!, 'C409', MIN( 100, VAL( 'viewport.'!_j_!'.0' ) )
         END
         ELSE DO
            IF RxFileExists( VAL( 'viewport.'!_j_!'.dwnld' ) ) THEN
            DO
               CALL VAL 'viewport.'!_j_!'.dwnld.hdd', !_hdd_!
               CALL VAL 'viewport.'!_j_!'.dwnld.txt', 'Install/Open'
            END
            ELSE IF 1 < LENGTH( VAL( 'downloads' ) ) THEN
               CALL VAL 'viewport.'!_j_!'.dwnld.clr', '#0 0 200'

            CALL ShowFor 'app'!_i_!, 'C404'
            CALL HideFor 'app'!_i_!, 'C409'
         END
         CALL TextFor 'app'!_i_!, 'C404', VAL( 'viewport.'!_j_!'.dwnld.txt' )
         CALL ColorFor 'app'!_i_!, 'C404', '+', VAL( 'viewport.'!_j_!'.dwnld.clr' )
         !_val_! = ''
         IF DATATYPE( VAL( 'viewport.'!_j_!'.category.0' ), 'W' ) THEN
         DO !_k_! = 1 TO VAL( 'viewport.'!_j_!'.category.0' )
            !_val_! = !_val_!||VAL( 'viewport.'!_j_!'.category.'!_k_! )||' '
         END
         ELSE !_val_! = VAL( 'viewport.'!_j_!'.category.a' )
         CALL TextFor 'app'!_i_!, 'C408', VAL( 'viewport.'!_j_!'.desc' )
      END
      IF 0 < !_i_! THEN
         CALL TopFor 'app'!_i_!, 'C402'
   END
RETURN 0

zoom_Size:
   PARSE VALUE Position() WITH x y cw ch
   IF -32000 < x THEN
   DO
      PARSE VALUE zoom.Frame() WITH l b r t
      CALL zoom.c601.Position l, b, cw - l - r, ch - t - b
      CALL zoom.c602.Position l, b, cw - l - r, ch - t - b
      CALL zoom.c601.Top
   END
RETURN 0

zoom_Visible:
   !_j_! = RxGetRow()
   IF !_j_! <> '' & !_j_! <> 0 THEN
   DO
      PARSE VALUE zoom.Position() WITH visible . . .
      !_to_! = VAL( 'viewport.'!_j_!'.sshot.0' )
      IF \DATATYPE( !_to_!, 'W' ) THEN
         !_to_! = 1
      DO !_k_! = 1 TO !_to_!
         !_l_! = !_k_!
         IF !_to_! = 1 THEN !_l_! = 'a'
         !_image_! = RxLoadImage( 'viewport.'!_j_!'.sshot.'!_l_!'.href', !_j_! )
         PARSE VALUE rxImgReSize( !_image_! ) WITH iw ih id
         CALL zoom.c601.Hint !_image_!
         CALL zoom.c602.Text !_image_!
         PARSE VALUE main.Position() WITH x y . .
         IF RxChkAbort(0) THEN RETURN 0
         PARSE VALUE PositionFor( 'app'||( !_j_! // VAL( 'app0' ) + 1 ) ) WITH dx dy . .
         PARSE VALUE c402.Position() WITH cx cy cw ch
         IF -32000 < visible THEN
         DO
            PARSE VALUE zoom.Frame() WITH l b r t
            IF visible <> 0 THEN
            DO
               CALL zoom.Position 0, 0, 1, 1
               CALL zoom.Hide
            END
            ELSE IF ( cw <> iw | ch <> ih ) & DATATYPE( iw, 'W' ) & DATATYPE( ih, 'W' ) THEN
            DO
               CALL zoom.Position MAX( 1, ( sw - iw ) % 2 - l ), MAX( 1, ( sh - ih ) % 2 - b ), iw + l + r, ih + t + b
               CALL zoom.Show
               CALL zoom.c601.Top
            END
         END
         IF 1 < !_to_! THEN
            CALL Sleep 1000
      END
   END
RETURN 0

RxCategories:
   CALL Notify 'category', 'add', 'New software: Latest'||D2C(9)||'https://ecsoft2.org/xml-export'
   CALL RxDownload 'https://ecsoft2.org/export/categories-export.xml'||D2C(9)||'-'
RETURN

RxDropDown:
   dd = 'category dropdown'
   dd_arrow = ' '
   PARSE VALUE main.Position() WITH x y w h
   IF -32000 < x THEN
   DO
      PARSE VALUE main.Frame() WITH l b r t
      previous = ''
      DO i = 1 TO WORDS( dd )
         CALL PositionFor SUBWORD( dd, i, 1 ),, x + l + VAL( 'efield' ) + ( ARG(1) = 0 ) + ( ( ARG(1) = 1 ) * VAL( 'wfield' ) ), y + b + VAL( 'efield' ) - 2, MAX( w - l - r - 2 * VAL( 'efield' ) - 2 * VAL( 'wfield' ), VAL( 'efield' ) ), MAX( h - t - b - 2 * VAL( 'efield' ), VAL( 'efield' ) )
         CALL PositionFor SUBWORD( dd, i, 1 ), 'C501', 0, 0, MAX( w - l - r - 2 * VAL( 'efield' ) - 2 * VAL( 'wfield' ), VAL( 'efield' ) ), MAX( h - t - b - 2 * VAL( 'efield' ), VAL( 'efield' ) )
         CALL PositionFor SUBWORD( dd, i, 1 ), 'C502', 2, 2, MAX( w - l - r - 2 * VAL( 'efield' ) - 2 * VAL( 'wfield' ), VAL( 'efield' ) ) - 4, MAX( h - t - b - 2 * VAL( 'efield' ), VAL( 'efield' ) ) - 4
         previous = POS( TextFor( 'main', 'C10'||( 2 + ( i - 1 ) * 5 ) ), SUBWORD( dd_arrow, i, 1 ) )
         IF ARG(1) = ( i - 1 ) THEN
            previous = \( 1 < previous )
         ELSE
            previous = 0
         CALL TextFor 'main', 'C10'||( 2 + ( i - 1 ) * 5 ), SUBSTR( SUBWORD( dd_arrow, i, 1 ), 1 + previous, 1 )
         CALL VisibleFor SUBWORD( dd, i, 1 ),, previous
      END
   END
RETURN
   
RxFileExists: PROCEDURE EXPOSE !_hdd_!
   IF STRIP( ARG(1) ) = '' THEN RETURN 0
   CALL RxGetURLComponents ARG(1)
   !_hdd_! = VAL( 'HOME' )'\Downloads\'host.file
RETURN ( STREAM( !_hdd_!, 'C', 'QUERY EXIST' ) <> '' )

RxDownload:
   !_tab_! = D2C(9)
   PARSE VALUE ARG(1) WITH !_url_!(!_tab_!)!_path_!(!_tab_!)!_row_!
   DO WHILE ( !_row_! = '' | !_row_! = 0 ) & VAL( 'Downloading' ) = 1
      CALL Sleep 500
   END
   IF 1 < VAL( 'Sequence' ) & !_row_! <> '' THEN RETURN 0
   CALL VAL 'Downloading', 1
   IF \DATATYPE( !_row_!, 'W' ) THEN
   DO
      CALL VAL 'viewport.0', 0
      CALL Notify 'main', 'progressbar', 'hide'
   END
   ELSE
      CALL VAL 'viewport.'!_row_!, 0
   !_newq_! = RXQUEUE( 'Create', 'NewQ' )
   !_tid_! = Start( 'RxMonitor', !_row_!||!_tab_!||( !_path_! = '-' )||!_tab_!||!_newq_! )
   CALL RxGetURLComponents !_url_!
   !_lock_! = VAL( 'HOME' )'\'host.file'.lck'
   CALL SysFileDelete !_lock_!
   IF 0 = POS( '://', !_url_! ) THEN
      !_dwnld_! = 'yum -y install %u'
   ELSE
      !_dwnld_! = VAL( 'params' )||' 3>'!_lock_!
   IF !_path_! = '' THEN
      !_path_! = DIRECTORY( VAL( 'downloads' ) )
   ELSE IF ARG(2) = '' THEN
      !_dwnld_! = CHANGESTR( ' --progress=bar:force', CHANGESTR( ' --progress-bar', CHANGESTR( ' -#', !_dwnld_!, '' ), '' ), '' )
   IF !_path_! = '-' THEN
      !_dwnld_! = CHANGESTR( ' "%p\%f"', !_dwnld_!, '-' )
   ELSE DO
      CALL rxMKDir !_path_!
      !_dwnld_! = !_dwnld_!||' 2>>&1'
   END
   !_dwnld_! = !_dwnld_!||'|RXQUEUE '!_newq_!
   !_dwnld_! = CHANGESTR( '%p', CHANGESTR( '%f', CHANGESTR( '%h', CHANGESTR( '%u', !_dwnld_!, !_url_! ), VAL( 'referer' ) ), host.file ), !_path_! )
   '@'!_dwnld_!
   DO WHILE STREAM( !_lock_!, 'C', 'QUERY EXIST' ) = ''
      CALL SysSleep 0.5
   END
   DO UNTIL STREAM( !_lock_!, 'C', 'OPEN READ' ) = 'READY:'
      CALL SysSleep 0.5
   END
   CALL STREAM !_lock_!, 'C', 'CLOSE'
   CALL SysFileDelete !_lock_!
   IF DATATYPE( !_row_!, 'W' ) THEN
      IF 0 < !_row_! THEN
      DO
         CALL VAL 'viewport.'!_row_!, 101
         CALL VAL 'viewport.'!_row_!'.0', 101
         CALL Notify 'viewport', 'load'
      END
RETURN Result( !_tid_! )
   
RxChkAbort: PROCEDURE
   IF 1 < VAL( 'Sequence' ) THEN
   DO
      CALL VAL 'Sequence', ARG(1)
      RETURN 1
   END
RETURN 0

RxPrepareImages:
   CALL Notify 'main', 'progressbar', 'show'
   IF RxChkAbort(0) THEN RETURN 0
   CALL RxLoadImages 1, MIN( VAL( 'app0' ), VAL( 'viewport.0' ) )
   IF RxChkAbort(0) THEN RETURN 0
   DO !_j_! = MIN( VAL( 'app0' ), VAL( 'viewport.0' ) ) + 1 TO MAX( VAL( 'app0' ), VAL( 'viewport.0' ) )
      IF DATATYPE( VAL( 'viewport.'!_j_!'.sshot.0' ), 'W' ) THEN
      DO !_k_! = 1 TO VAL( 'viewport.'!_j_!'.sshot.0' )
         CALL VAL 'viewport.'!_j_!'.sshot.'!_k_!'.img.src', RxLoadImage( 'viewport.'!_j_!'.sshot.'!_k_!'.img.src' )
         IF RxChkAbort(0) THEN RETURN 0
         CALL VAL 'viewport.'!_j_!'.sshot.'!_k_!'.href', RxLoadImage( 'viewport.'!_j_!'.sshot.'!_k_!'.href' )
         IF RxChkAbort(0) THEN RETURN 0
      END
      ELSE DO
         CALL VAL 'viewport.'!_j_!'.sshot.a.img.src', RxLoadImage( 'viewport.'!_j_!'.sshot.a.img.src' )
         IF RxChkAbort(0) THEN RETURN 0
         CALL VAL 'viewport.'!_j_!'.sshot.a.href', RxLoadImage( 'viewport.'!_j_!'.sshot.a.href' )
         IF RxChkAbort(0) THEN RETURN 0
      END
   END
   CALL RxLoadImages MIN( VAL( 'app0' ), VAL( 'viewport.0' ) ) + 1, MAX( VAL( 'app0' ), VAL( 'viewport.0' ) )
   CALL VAL 'Sequence', 0
   CALL Notify 'main', 'progressbar', 'hide'
RETURN 0
   
RxLoadImages: PROCEDURE
   DO !_j_! = ARG(1) TO ARG(2)
      IF DATATYPE( VAL( 'viewport.'!_j_!'.sshot.0' ), 'W' ) THEN
      DO !_k_! = 1 TO VAL( 'viewport.'!_j_!'.sshot.0' )
         CALL RxLoadImage 'viewport.'!_j_!'.sshot.'!_k_!'.img.src', !_j_!
         IF RxChkAbort(0) THEN LEAVE
         CALL Notify 'main', 'progressbar', 100 * ( !_j_! - 1 ) / MAX( 1, VAL( 'viewport.0' ) ) + 50 * !_k_! / MAX( 1, VAL( 'viewport.0' ) + VAL( 'viewport.'!_j_!'.sshot.0' ) )
         CALL RxLoadImage 'viewport.'!_j_!'.sshot.'!_k_!'.href', !_j_!
         IF RxChkAbort(0) THEN LEAVE
         CALL Notify 'main', 'progressbar', 100 * ( !_j_! - 0.5 ) / MAX( 1, VAL( 'viewport.0' ) ) + 50 * !_k_! / MAX( 1, VAL( 'viewport.0' ) + VAL( 'viewport.'!_j_!'.sshot.0' ) )
      END
      ELSE DO
         CALL RxLoadImage 'viewport.'!_j_!'.sshot.a.img.src', !_j_!
         IF RxChkAbort(0) THEN LEAVE
         CALL Notify 'main', 'progressbar', 100 * ( !_j_! - 0.5 ) / MAX( 1, VAL( 'viewport.0' ) )
         CALL RxLoadImage 'viewport.'!_j_!'.sshot.a.href', !_j_!
      END
      IF !_j_! < VAL( 'app0' ) + 1 THEN
         CALL Notify 'viewport', 'load', !_j_!
      IF RxChkAbort(0) THEN LEAVE
      CALL Notify 'main', 'progressbar', 100 * !_j_! / MAX( 1, VAL( 'viewport.0' ) )
   END
RETURN 0
   
RxLoadImage: PROCEDURE
   !_tab_! = D2C(9)
   PARSE ARG !_val_!, !_row_!
   IF 0 = LENGTH( VAL( !_val_! ) ) THEN
      RETURN '#102'
   IF 0 = POS( '#10', VAL( !_val_! ) ) THEN
   DO
      IF STREAM( VAL( !_val_! ), 'C', 'QUERY EXISTS' ) <> '' THEN
         RETURN VAL( !_val_! )
      CALL RxGetURLComponents VAL( !_val_! )
      PARSE VALUE host.path WITH .'/default/'subfolder
      tgt = VAL( 'HOME' )'\'TRANSLATE( subfolder, '\', '/' )
      IF STREAM( tgt'\'host.basename'.bmp', 'C', 'QUERY EXISTS' ) <> '' THEN
         RETURN tgt'\'host.basename'.bmp'
      IF STREAM( tgt'\'host.file, 'C', 'QUERY EXISTS' ) <> '' THEN
      DO
         IF TRANSLATE( RIGHT( !_val_!, 4 ) ) = '.SRC' THEN
            !_rc_! = rxImgReSize( tgt'\'host.file, tgt'\'host.basename'.bmp', 142, 100 )
         ELSE
            !_rc_! = rxImgReSize( tgt'\'host.file, tgt'\'host.basename'.bmp' )
         CALL SysFileDelete tgt'\'host.file
         IF !_rc_! = 0 THEN
            RETURN tgt'\'host.basename'.bmp'

      END
   END
   IF 0 < !_row_! & VAL( !_val_!'.image' ) <> '' THEN
   DO
      CALL VAL !_val_!, VAL( !_val_!'.image' )
      IF STREAM( VAL( !_val_!'.image' ), 'C', 'QUERY EXISTS' ) <> '' THEN
         RETURN VAL( !_val_!'.image' )
      CALL RxGetURLComponents VAL( !_val_! )
      PARSE VALUE host.path WITH .'/default/'subfolder
      tgt = VAL( 'HOME' )'\'TRANSLATE( subfolder, '\', '/' )
      CALL RxDownload VAL( !_val_! )!_tab_!||tgt||!_tab_!||!_row_!
      !_ret_! = RxLoadImage( !_val_!, 0 )
      CALL VAL !_val_!, !_ret_!
      RETURN !_ret_!
   END
   ELSE IF 0 = POS( '#10', VAL( !_val_! ) ) THEN
      CALL VAL !_val_!||'.image', VAL( !_val_! )
RETURN '#101'
   
RxMonitor:
   !_tab_! = D2C(9)
   PARSE VALUE ARG(1) WITH !_row_!(!_tab_!)!_code_!(!_tab_!)!_qName_!
   CALL TIME 'R'
   !_qd_! = 0
   !_found_! = \!_code_!
   !_counter_! = 0
   CALL VALUE !_stem_!'0', 0
   !_status_! = ''
   DO FOREVER
      CALL Use 'QUEUE', 1
      CALL RXQUEUE 'Set', !_qName_!
      !_qd_! = QUEUED()
      IF 0 < !_qd_! THEN
         !_status_! = !_status_!||LINEIN( 'QUEUE:' )
      CALL Use 'QUEUE', 0
      IF !_status_! = '' THEN
      DO
         IF !_qd_! < 1 THEN
            IF 100 < VAL( 'viewport.'!_row_! ) | RxChkAbort(0) & !_row_! <> '' THEN
            LEAVE
         CALL Sleep 500
      END
      ELSE IF \!_found_! THEN DO
         PARSE VALUE !_status_! WITH '<?xml version="'!_found_!'.'.'" encoding="'!_encoding_!'"'.'?>'.'<'!_start_tag_!'s>'!_rest_!
         !_ends_tag_! = '</'!_start_tag_!'s>'
         !_end_tag_! = '</'!_start_tag_!'>'
         !_start_tag_! = '<'!_start_tag_!'>'
         IF LENGTH( !_rest_! ) = 0 THEN !_found_! = 0
         ELSE !_status_! = !_rest_!
         !_row_count_! = 0
      END
      ELSE IF !_code_! THEN
      DO
         IF !_ends_tag_! = !_status_! THEN
            LEAVE
         DO WHILE 0 < POS( !_end_tag_!, !_status_! )
            PARSE VALUE !_status_! WITH (!_start_tag_!)!_str_!(!_end_tag_!)!_status_!
            CALL RxTag !_start_tag_!||H2C( !_str_! )||!_end_tag_!, 'viewport.', 1
            !_counter_! = !_counter_! + 1
            CALL Notify 'main', 'progressbar', 100 * !_counter_! / ( !_qd_! + !_counter_! )
            IF !_row_! = '' THEN
               CALL Notify 'category', 'add', VAL( 'viewport.'!_counter_!'.term.a' )||!_tab_!||VAL( 'viewport.'!_counter_!'.term.a.href' )
            ELSE IF !_row_! = 0 THEN
            DO
               IF LENGTH( VAL( 'viewport.'!_counter_!'.dwnld' ) ) < 4 THEN
                  CALL VAL 'viewport.'!_counter_!'.dwnld.txt', ''
               ELSE IF VAL( 'downloads' ) = 'C' THEN
                  CALL VAL 'viewport.'!_counter_!'.dwnld.txt', 'URL to clipboard'
               ELSE IF VAL( 'downloads' ) = 'D' THEN
                  CALL VAL 'viewport.'!_counter_!'.dwnld.txt', 'Create Desktop URL'
               ELSE
                  CALL VAL 'viewport.'!_counter_!'.dwnld.txt', 'Download'
               CALL VAL 'viewport.'!_counter_!'.dwnld.clr', '#0 0 200'
               IF !_counter_! < VAL( 'app0' ) + 1 THEN
                  CALL Notify 'viewport', 'load', !_counter_!
            END
            CALL VAL 'viewport.0', !_counter_!
         END
      END
      ELSE IF 0 < POS( '%', !_status_! ) THEN
      DO
         PARSE VALUE !_status_! WITH . !_percent_!'%'.
         !_percent_! = STRIP( TRANSLATE( !_percent_!, '.', ',' ) )
         IF DATATYPE( !_percent_!, 'N' ) THEN
         DO
            CALL VAL 'viewport.'!_row_!'.0', MIN( 100, !_percent_! )
            CALL Notify 'viewport', 'load'
            IF 99 < VAL( 'viewport.'!_row_!'.0' ) THEN LEAVE
         END
/*            CALL SelectFor 'app'||( !_j_! // VAL( 'app0' ) + 1 ), 'C409', MIN( 100, !_percent_! )*/
/*            CALL Notify 'main', 'progressbar', MIN( 100, !_percent_! )*/
         !_status_! = ''
      END
      ELSE
         !_status_! = ''
   END
   IF !_row_! = 0 THEN
      CALL Notify 'viewport', 'range'
   ELSE IF !_row_! <> '' THEN
      CALL VAL 'viewport.'!_row_!, 101
   CALL VAL 'Downloading', 0
RETURN 0

RxKeyVal: PROCEDURE EXPOSE !_row_count_! stem. viewport.
   PARSE ARG !_str_!, !_stem_!
   !_keyval_! = 0
   DO WHILE 0 < POS( '=', !_str_! )
      !_keyval_! = !_keyval_! + 1
      PARSE VALUE !_str_! WITH !_key_!'="'!_val_!'"'!_str_!
      CALL VAL !_stem_!||STRIP( !_key_! ), STRIP( !_val_! )
      CALL VAL !_stem_!||!_keyval_!, !_stem_!||STRIP( !_key_! )
      !_row_count_! = !_row_count_! + 1
      CALL VAL 'stem.'!_row_count_!, !_stem_!||STRIP( !_key_! )
      CALL VAL 'stem.0', !_row_count_!
   END
   CALL VAL !_stem_!'0', !_keyval_!
RETURN 0
   
RxTag: PROCEDURE EXPOSE !_counter_! stem. viewport.
   PARSE ARG !_str_!, !_stem_!, !_nodes_!
   IF !_nodes_! = 1 THEN
      !_count_! = !_counter_!
   ELSE
      !_count_! = VALUE( !_stem_!'0' )
   IF \DATATYPE( !_count_!, 'W' ) THEN
      !_count_! = 0
   !_row_count_! = VALUE( 'stem.0' )
   IF \DATATYPE( !_row_count_!, 'W' ) THEN
      !_row_count_! = 0
   DO WHILE 0 < LENGTH( !_str_! )
      PARSE VALUE !_str_! WITH '<'!_tag_!'>'.
      !_t_tag_! = SUBWORD( !_tag_!, 1, 1 )
      CALL VAL !_stem_!||!_t_tag_!||'.a.href', ''
      CALL VAL !_stem_!||!_t_tag_!||'.a.img.src', ''
      IF 0 < POS( '=', !_tag_! ) THEN
         CALL RxKeyVal SUBWORD( !_tag_!, 2 ), !_stem_!||!_t_tag_!'.'
      !_start_tag_! = '<'!_tag_!'>'
      IF RIGHT( STRIP( !_tag_! ), 1 ) <> '/' THEN
      DO
         !_end_tag_! = '</'!_t_tag_!'>'
         PARSE VALUE !_str_! WITH (!_start_tag_!)!_tag_val_!(!_end_tag_!)!_str_!
         IF 0 < POS( '<'!_t_tag_!, !_str_! ) | !_nodes_! = 1 THEN
         DO
            !_count_! = !_count_! + 1
            CALL VAL !_stem_!||!_count_!||'.href', ''
            CALL VAL !_stem_!||!_count_!||'.img.src', ''
         END
         ELSE
            !_count_! = !_t_tag_!
         IF 0 < POS( '<', !_tag_val_! ) THEN
            CALL RxTag !_tag_val_!, !_stem_!||!_count_!'.'
         ELSE
            CALL VAL !_stem_!||!_count_!, STRIP( !_tag_val_! )
         IF DATATYPE( !_count_!, 'W' ) THEN
            CALL VAL !_stem_!'0', !_count_!
         !_row_count_! = !_row_count_! + 1
         stem.!_row_count_! = !_stem_!||!_count_!
         stem.0 = !_row_count_!
      END
      ELSE
         PARSE VALUE !_str_! WITH (!_start_tag_!).'>'!_str_!
      !_str_! = STRIP( !_str_! )
   END
RETURN 0
   
RxGetRow: PROCEDURE
   !_i_! = C401.Hint()
   IF 3 < LENGTH( !_i_! ) THEN
      RETURN HintFor( !_i_! )
RETURN 0

RxSearch:
   IF !_searching_! = 1 THEN RETURN 0
   IF LENGTH( STRIP( ARG(1) ) ) < 3 THEN RETURN 0
   !_searching_! = 1
   CALL main.C107.Text ''
   CALL dropdown.C502.Delete
   CALL RxDropDown 1
   !_srch4_! = SysMapCase( ARG(1) )
   !_tags_! = 'name category updated_date desc sshot.a.img.src sshot.a.href dwnld.a.href'
   !_type_! = 'Title Category Updated Description Preview Screenshot URL'
   DO !_counter_! = 1 TO VAL( 'viewport.0' )
      DO !_i_! = 1 TO WORDS( !_tags_! )
         !_tag_! = SUBWORD( !_tags_!, !_i_!, 1 )
         IF DATATYPE( VAL( 'viewport.'!_counter_!'.'!_tag_!'.0' ), 'W' ) THEN
         DO !_links_! = 1 TO VAL( 'viewport.'!_counter_!'.'!_tag_!'.0' )
            IF 0 < LENGTH( VAL( 'viewport.'!_counter_!'.'!_tag_!'.'!_links_! ) ) THEN
               IF 0 < POS( !_srch4_!, SysMapCase( VAL( 'viewport.'!_counter_!'.'!_tag_!'.'!_links_! ) ) ) THEN
               DO
                  !_val_!.1 =  SUBWORD( !_type_!, !_i_!, 1 )||': '||VAL( 'viewport.'!_counter_!'.'!_tag_!'.'!_links_! )
                  !_val_!.2 = !_counter_!
                  CALL dropdown.C502.SetStem '!_val_!', dropdown.C502.Add( !_val_!.1 )
               END
         END
         ELSE IF 0 < LENGTH( VAL( 'viewport.'!_counter_!'.'!_tag_! ) ) THEN
            IF 0 < POS( !_srch4_!, SysMapCase( VAL( 'viewport.'!_counter_!'.'!_tag_! ) ) ) THEN
            DO
               !_val_!.1 =  SUBWORD( !_type_!, !_i_!, 1 )||': '||VAL( 'viewport.'!_counter_!'.'!_tag_! )
               !_val_!.2 = !_counter_!
               CALL dropdown.C502.SetStem '!_val_!', dropdown.C502.Add( !_val_!.1 )
            END
      END
   END
   !_searching_! = 0
RETURN 0

RxGetURLComponents:
   PROCEDURE EXPOSE host.
   IF 0 < POS( 'seam', ARG(1) ) THEN CALL TRACE 'O'
/* URL syntax consists of these components:          */
/* <scheme>://<uid>:<pwd>@<location>:<port>/<path>;<params>?<query>#<target> */
   PARSE VALUE ARG( 1 ) WITH host.scheme '://' host.location '/' host.path
   host.location = strip( host.location, 'L', '/' ) /* in case of scheme like "file:///" */
   IF host.location = '' THEN
      PARSE VALUE ARG( 1 ) WITH host.location '/' host.path
   IF 0 < POS( '@', host.location ) THEN
      PARSE VALUE host.location WITH host.username ':' host.password '@' host.location
   PARSE VALUE host.location WITH host.location ':' host.port
   IF host.port = '' THEN
      IF TRANSLATE( host.scheme ) = 'HTTP' then
         host.port = 80
      ELSE IF TRANSLATE( host.scheme ) = 'FTP' then
         host.port = 21
      ELSE IF TRANSLATE( host.scheme ) = 'HTTPS' then
         host.port = 443
      ELSE IF TRANSLATE( host.scheme ) = 'SFTP' then
         host.port = 22
   PARSE VALUE host.path WITH host.file ';' host.params '?' host.query '#' host.target
   IF host.params = '' THEN
      PARSE VALUE host.path WITH host.file '?' host.query '#' host.target
   IF host.query = '' THEN
      PARSE VALUE host.path WITH host.file '#' host.target
   PARSE VALUE REVERSE( host.file ) WITH host.file'/'host.path
   PARSE VALUE host.file WITH host.ext'.'host.basename
   IF host.basename = '' THEN
   DO
      host.basename = host.file
      host.ext = ''
   END
   ELSE
      host.ext = REVERSE( host.ext )
   host.basename = REVERSE( host.basename )
   host.file = REVERSE( host.file )
   host.path = REVERSE( host.path )
   host.family = 'AF_INET'
RETURN

D2L:
   !_sep_! = VAL( 'sDate' )
   !_YYYY_! = LEFT( ARG(1), 4 )
   IF 0 < POS( '-', ARG(1) ) THEN
      PARSE VALUE ARG(1) WITH .'-'!_MM_!'-'!_DD_!
   ELSE IF 7 < LENGTH( ARG(1) ) THEN
   DO
      !_MM_! = SUBSTR( ARG(1), 5, 2 )
      !_DD_! = RIGHT( ARG(1), 2 )
   END
   ELSE IF LENGTH( ARG(1) ) < 7 THEN
   DO
      !_MM_! = SUBSTR( ARG(1), 5, 1 )
      !_DD_! = RIGHT( ARG(1), 1 )
   END
   ELSE RETURN !_YYYY_!
   IF VAL( 'iDate' ) = 0 THEN
      RETURN !_MM_!||!_sep_!||!_DD_!||!_sep_!||!_YYYY_!
   ELSE IF VAL( 'iDate' ) = 1 THEN
      RETURN !_DD_!||!_sep_!||!_MM_!||!_sep_!||!_YYYY_!
   ELSE IF VAL( 'iDate' ) = 2 THEN
      RETURN !_YYYY_!||!_sep_!||!_MM_!||!_sep_!||!_DD_!
RETURN !_YYYY_!||!_sep_!||!_DD_!||!_sep_!||!_MM_!
   
RxChkDLL: PROCEDURE
   !_env_! = 'OS2ENVIRONMENT'
   !_bd_! = SysBootDrive()
   IF !_bd_! == '' THEN
      !_bd_! = FILESPEC( 'DRIVE', VALUE( 'COMSPEC',, !_env_! ) )
   !_cfgsys_! = !_bd_!'\CONFIG.SYS'
   CALL SysFileSearch 'LIBPATH=', !_cfgsys_!, 'match.'
   DO i = 1 TO match.0
      IF LEFT( STRIP( match.i ), LENGTH( 'LIBPATH=' ) ) = 'LIBPATH=' THEN
      DO
         PARSE UPPER VALUE match.i WITH 'LIBPATH=' !_libpath_!
         IF !_libpath_! <> '' THEN LEAVE
      END
   END
   CALL SETLOCAL
   !_chk_! = 'CHK_LIBPATH_CHK'
   CALL VALUE !_chk_!, !_libpath_!, !_env_!
   !_path_! = STRIP( SysSearchPath( !_chk_!, ARG(1) ) )
   CALL ENDLOCAL
   IF 3 < LENGTH( !_path_! ) THEN
      RETURN RxChkApp( 'BLDLEVEL.EXE', ' '||!_path_!, ARG(2), ARG(3) )
RETURN ''
   
RxChkParams:
   IF 0 < LENGTH( rxChkApp( 'wget.exe', ' --version --quiet', 'GNU WGET' ) ) THEN
      RETURN 'WGet -c -t 10 -w 30 --referer=%h --progress=bar:force -O "%p\%f" "%u"'
   ELSE IF 0 < LENGTH( rxChkApp( 'curl.exe', ' --version', 'CURL' ) ) THEN
      RETURN 'cURL -y 300 -Y 1 -e %h -v -C - -# -L -o "%p\%f" "%u"'
   ELSE
RETURN ''

RxChkApp: PROCEDURE
   CALL TRACE 'O'
   DO WHILE QUEUED() > 0; PARSE PULL; END;
   '@'||ARG(1)||ARG(2)||' 2>>&1 | RXQUEUE'
   DO i = 1 TO 3
      IF 0 < QUEUED() THEN LEAVE i
      CALL SysSleep 1
   END
   DO WHILE 0 < QUEUED()
      retval = LINEIN( 'QUEUE:' )
      IF POS( TRANSLATE( ARG(3) ), TRANSLATE( retval ) ) > 0 THEN
      DO
         IF 3 < ARG() THEN
            IF 0 < LENGTH( ARG(4) ) THEN
               RETURN ARG(4)
            ELSE
               RETURN retval
         PARSE VALUE REVERSE( SysSearchPath( 'PATH', ARG(1) ) ) WITH .'\'fpath
         RETURN REVERSE( fpath )
      END
   END
RETURN ''

RxMKDir:
   PROCEDURE
   curr_path = ARG(1)
   IF DIRECTORY( curr_path ) = '' & LENGTH( curr_path ) > 2 THEN
      IF RxMkDir( STRIP( FILESPEC( 'D', curr_path )||FILESPEC( 'P', curr_path ), 'T', '\' ) ) = 0 THEN
         RETURN SysMKDir( curr_path )
      ELSE
         RETURN 1
RETURN 0

RxRmDir: PROCEDURE
    curr_path = ARG(1)
    ok = 0
    IF \SysFileTree( curr_path||'\*', 'folder', 'DO' ) THEN
    DO i = 1 TO folder.0
        ok = ok + RxRmDir( folder.i )
    END
    IF \SysFileTree( curr_path||'\*', 'file', 'FO',, '-----' ) THEN
    DO i = 1 TO file.0
        ok = ok + SysFileDelete( file.i )
    END
RETURN ok + SysRmDir( curr_path )

RxLoadLib: PROCEDURE
   SIGNAL ON SYNTAX NAME RxNoLib
   CALL RxFuncAdd ARG(1), ARG(2), ARG(1)
   IF ARG() < 3 THEN
      INTERPRET 'CALL '||ARG(1)
   SIGNAL OFF SYNTAX
RETURN RxFuncQuery( ARG(1) )

RxNoLib:
   SIGNAL OFF SYNTAX
RETURN 1

RxDecodeURL: PROCEDURE
PARSE ARG !_url_!
DO WHILE POS( '%', !_url_! ) > 0
   !_i_! = POS( '%', !_url_! );
   !_url_! = SUBSTR( !_url_!, 1, !_i_! - 1 ) ||,
   X2C( SUBSTR( !_url_!, !_i_! + 1, 2 ) ) ||,
   SUBSTR( !_url_!, !_i_! + 3 )
END
RETURN !_url_!

H2C: PROCEDURE EXPOSE f. t. r. !_tab_! !_crlf_! !_lf_!
   IF \DATATYPE( f.0, 'W' ) THEN DO
      !_lf_! = D2C(10); !_crlf_! = D2C(13)||!_lf_!; !_tab_! = D2C(9); f.1 = ' <'; t.1 = '<'; f.2 = '> ';
      t.2 = '>'; f.3 = '&lt;'; t.3 = '<'; f.4 = '&gt;'; t.4 = '>'; f.5 = '&amp;'
      t.5 = '&'; f.6 = '&nbsp;'; t.6 = ' '; f.0 = 6; r.1 = '  '; r.2 = !_tab_!;
      r.3 = !_lf_!; r.0 = 3;
   END
   !_str_! = TRANSLATE( ARG(1), !_tab_!, !_crlf_! )
   DO !_i_! = 1 TO r.0
      !_str_! = CHANGESTR( r.!_i_!, !_str_! )
   END
   DO !_i_! = 1 TO f.0
      !_str_! = CHANGESTR( f.!_i_!, !_str_!, t.!_i_! )
   END
   !_i_! = POS( '&#', !_str_! )
   DO WHILE 0 < !_i_!
      !_j_! = POS( ';', !_str_!, !_i_! )
      IF isBetween( 0, !_i_! - !_j_!, 5 ) THEN
         !_str_! = SUBSTR( !_str_!, 1, !_i_! - 2 ) ||,
      X2C( SUBSTR( !_str_!, !_i_! + 2, !_j_! - !_i_! - 2 ) ) ||,
      SUBSTR( !_str_!, !_j_! + 1 )
      ELSE
         !_str_! = SUBSTR( !_str_!, 1, !_i_! - 2 ) ||,
      SUBSTR( !_str_!, !_j_! + 1 )
      !_i_! = POS( '&#', !_str_! )
   END
RETURN !_str_!

isBetween: PROCEDURE
RETURN ARG(1) < ARG(2) & ARG(2) < ARG(3)

RxCreateURL: PROCEDURE EXPOSE host.
   !_remove_! = SPACE( TRANSLATE( XRANGE(),, XRANGE( 'a', 'z' )XRANGE( 'A', 'Z' )XRANGE( '0', '9' )'_?!<>' ), 0 )
   CALL RxGetURLComponents ARG(1)
   objid = ARG(3);
   object = SysTempFileName( 'add!????' );

   IF SysOs2Ver() > '2.30' THEN
      rc = SysCreateObject( 'WPUrl', object, ARG(2), 'OBJECTID='||SPACE( TRANSLATE( objid,, !_remove_! ), 0 )||';TITLE='||ARG(4)||';URL='||ARG(1), 'U');
   ELSE
      rc = SysCreateObject( 'WebExplorer_Url', ARG(4), url, 'OBJECTID='||SPACE( TRANSLATE( objid,, !_remove_! ), 0 )||';LOCATOR='||ARG(1)||';', 'U' );
RETURN rc

RxOpenURL: PROCEDURE
   IF \RxCreateURL( ARG(1), '<WP_FLD_ONLINESOFT>', '<WP_ONLINESOFT>', ARG(2) ) THEN
      IF \RxCreateURL( ARG(1), '<WP_COOLURLSFOLDER>', '<WP_ONLINESOFT>', ARG(2) ) THEN
         CALL RxCreateURL ARG(1), '<WP_DESKTOP>', '<WP_ONLINESOFT>', ARG(2)
   CALL SysSetObjectData  '<WP_ONLINESOFT>', 'OPEN=DEFAULT';
RETURN retval

/* Replace one string (needle) with another (newneedle) in text (haystack) */
CHANGESTR: PROCEDURE /* needle, haystack <, newneedle> */
   IF TRACE() = '?I' THEN CALL TRACE 'O'
   PARSE ARG needle, haystack, newneedle
   i = 0
   start = TIME( 'S' )
   new_haystack = ''
   str_len = LENGTH( haystack )
   DO WHILE POS( needle, haystack ) > 0
      PARSE VALUE haystack WITH pre(needle)haystack
      IF newneedle = '' & LENGTH( needle ) = 1 THEN
         haystack = STRIP( haystack,, needle )
      new_haystack = new_haystack||pre||newneedle
      IF start + 1 < TIME( 'S' ) THEN
      DO
         start = TIME( 'S' )
         i = ( i + 1 ) // 3
      END
   END
RETURN new_haystack||haystack
   
RxVersion:
RETURN @#Jan-Erik Laerka:1.01.05#@##1## 2018-10-05               SONYVAIO::::0::@@Online Software on eCSoft/2