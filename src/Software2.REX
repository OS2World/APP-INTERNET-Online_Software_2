/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  REXX source code listing for DrRexx application:                            |
 |    D:\Programs\DrDialog\Market\Software2.RES                                 |
 |                                                                              |
 |  File last modified on: 04/17/18 at: 08:56pm                                 |
 |  Listing produced on:   04/17/18 at: 09:00pm                                 |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

SIGNAL ON SYNTAX
SIGNAL ON HALT
SIGNAL INIT

RETURN:
   SIGNAL VALUE DrRexxEvent()

L1:
   EXIT -1

L2:
   INTERPRET DrRexxInterpret()
   SIGNAL RETURN

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Event handlers for dialog: main                                             |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

/* Event handlers for: main (DIALOG) */

main_Init:
   CALL VAL 'downloads', SysIni( 'USER', 'OnlineSoftware', 'downloads' )
   IF VAL( 'downloads' ) = 'ERROR:' THEN
      CALL VAL 'downloads', 'C'
   CALL VAL 'params', SysIni( 'USER', 'OnlineSoftware', 'params' )
   IF VAL( 'params' ) = 'ERROR:' THEN
      CALL VAL 'params', ''
   CALL VAL 'efield', SysIni( 'USER', 'OnlineSoftware', 'efield' )

   CALL VAL 'isBusy', 0
   CALL VAL 'sbar', 14
   CALL VAL 'wfield', 20
   IF \DATATYPE( VAL( 'efield' ), 'W' ) THEN
      CALL VAL 'efield', 20
   CALL VAL 'timeguard', TIME( 'S' ) - 1
   CALL VAL 'rowheight', 126
   CALL VAL 'viewport.0', 0
   CALL VAL 'viewport_rows', 2
   CALL VAL 'wimg', ( VAL( 'rowheight' ) - 6 - VAL( 'wfield' ) ) * 1.42 % 1
   DLLVERSION = 'drctl017'

   parse source . . sourceFile

   thedir = FILESPEC( 'drive', sourcefile )||FILESPEC( 'path', sourcefile )
   theDir = LEFT( theDir, LENGTH( theDir ) - 1 )
   oldDir = DIRECTORY( theDir )
/* Register percent bar */
   rc = RxFuncAdd( 'DRCtrlRegister', DLLVERSION , 'DRCtrlRegister' )
   call DRCtrlRegister
   rc = RxFuncAdd( 'DRCtrlVersion', DLLVERSION , 'DRCtrlVersion' )
   rc = RxFuncAdd( 'DRCtrlPickDirectory', DLLVERSION , 'DRCtrlPickDirectory' )
   rc = RxFuncAdd( 'DRCtrlSetParent', DLLVERSION , 'DRCtrlSetParent' )

   /* Load RexxUtil Library */
   IF RxFuncQuery('SysLoadFuncs') THEN
   DO
      CALL RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
      CALL SysLoadFuncs
   END

   CALL VAL 'wSize', SysIni( 'USER', 'OnlineSoftware', 'wSize' )
   IF 0 < POS( 'ERROR', VAL( 'wSize' ) ) THEN
      CALL VAL 'wSize', '640 480'
   CALL VAL 'xyPos', SysIni( 'USER', 'OnlineSoftware', 'xyPos' )
   CALL VAL 'sSize', ScreenSize()

/* initialize socket package */
   IF RxFuncQuery( "SockLoadFuncs" ) THEN
   DO
      rc = RxFuncAdd( "SockLoadFuncs", "RxSock", "SockLoadFuncs" )
      rc = SockLoadFuncs()
   END

   CALL RxFuncAdd 'rxImgLoadFuncs' , 'rxImgSze' , 'rxImgLoadFuncs'
   CALL rxImgLoadFuncs

   CALL VAL 'iDate', STRIP( SysIni( 'USER', 'PM_National', 'iDate' ), 'T', D2C(0) )
   CALL VAL 'sDate', STRIP( SysIni( 'USER', 'PM_National', 'sDate' ), 'T', D2C(0) )
   CALL VAL 'HOME', VALUE( 'HOME',,'OS2ENVIRONMENT' )'\.cache\eCSoft'

   CALL Start 'RxCategories', 'http://www.ecsoft2.org/export/categories-export.xml'
RETURN

main_Size:
   PARSE VALUE main.Frame() WITH l b r t
   PARSE VALUE main.Position() WITH x y w h
   DO i = 101 TO 111
      CALL HideFor 'main', 'C'i
   END
   wpos = w - l - r - 3 * VAL( 'wfield' ) - 2 * VAL( 'efield' ) + 1
   ypos = h - t - VAL( 'efield' )
   CALL main.c101.Text '#'||( 117 + ( 20 < VAL( 'efield' ) ) )
   CALL main.c101.Position l, ypos - 1, VAL( 'efield' ), VAL( 'efield' )
   CALL main.c102.Position l + VAL( 'efield' ), ypos - 2, VAL( 'wfield' ), VAL( 'efield' ) + 2
   CALL main.c103.Position l + VAL( 'efield' ) + VAL( 'wfield' ), ypos - 1, wpos, VAL( 'efield' )
   CALL main.c104.Position l + VAL( 'efield' ) + VAL( 'wfield' ) + 2, ypos + 1, wpos - 4, VAL( 'efield' ) - 4
   CALL main.c105.Text '#127'
   CALL main.c105.Position l + VAL( 'efield' ) + VAL( 'wfield' ) + 2, ypos + 1, 0, 16
   CALL main.c106.Position l + VAL( 'efield' ) + VAL( 'wfield' ) + 2, ypos + 1, wpos - 4, VAL( 'efield' ) - 4
   CALL main.c107.Position w - r - 2 * VAL( 'wfield' ) - VAL( 'efield' ) + 1, ypos - 2, VAL( 'wfield' ), VAL( 'efield' ) + 2
   CALL main.c108.Position w - r - 1 * VAL( 'wfield' ) - VAL( 'efield' ), ypos - 2, VAL( 'wfield' ), VAL( 'efield' ) + 2
   CALL main.c109.Text '#'||( 120 + ( 20 < VAL( 'efield' ) ) )
   CALL main.c109.Position w - r - 1 * VAL( 'efield' ), ypos - 1, VAL( 'efield' ), VAL( 'efield' )
   CALL main.c110.Position l, b, w - l - r, h - t - b - VAL( 'efield' ) - 2
   CALL main.c111.Position w - r - VAL( 'sbar' ) - 1, b + 1, VAL( 'sbar' ), h - t - b - VAL( 'efield' ) - 4
   CALL main.c112.Position 0, 0, VAL( 'sbar' ), h - t - b - VAL( 'efield' ) - 2
   CALL viewport.Position l + 2, b + 2, w - l - r - VAL( 'sbar' ) - 3, h - t - b - VAL( 'efield' ) - 6
   DO i = 101 TO 111
      IF i = 104 THEN ITERATE
      CALL ShowFor 'main', 'C'i
   END
   CALL VAL 'isBusy', 0
RETURN

main_Open:
   CALL viewport.open
   PARSE VALUE VAL( 'wSize' ) WITH dw dh
   PARSE VALUE VAL( 'sSize' ) WITH sw sh
   IF VAL( 'xyPos' ) = 'ERROR:' THEN
      CALL Position ( sw - dw ) / 2 % 1, ( sh - dh ) / 2 % 1, dw, dh
   ELSE DO
      PARSE VALUE VAL( 'xyPos') WITH x y
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
RETURN

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Event handlers for dialog: viewport                                         |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

/* Event handlers for: viewport (DIALOG) */
viewport_Size:
   PARSE VALUE main.Frame() WITH l b r t
   PARSE VALUE main.Position() WITH x y w h
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
         CALL row.open 'app'i
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
   DO i = 1 TO VAL( 'app0' )
      CALL PositionFor 'app'i,, 0, h - i * VAL( 'rowheight' ) - t - b - VAL( 'efield' ) - 6 + !_overflow_!, w - l - r - VAL( 'sbar' ), VAL( 'rowheight' )
   END
RETURN

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Event handlers for dialog: row                                              |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

/* Event handlers for: row (DIALOG) */

row_Size:
   PARSE VALUE Position() WITH . . w h
   CALL VAL 'wimg', ( VAL( 'rowheight' ) - 6 - VAL( 'wfield' ) ) * 1.42 % 1
   wdate = 75
   hrow = ( VAL( 'rowheight' ) - 6 - VAL( 'wfield' ) ) % 4 - 1
   CALL c401.Text '#9999'
   CALL c401.Position 0, 0, w, h
   CALL c403.Position 0, VAL( 'wfield' ) + 6, VAL( 'wimg' ), h - 6 - VAL( 'wfield' )
   CALL c402.Position 0, VAL( 'wfield' ) + 6, VAL( 'wimg' ), h - 6 - VAL( 'wfield' )
   CALL c402.Top
   CALL c404.Position 0, 1, VAL( 'wimg' ) - VAL( 'wfield' ) - 1, hrow
   CALL c405.Position VAL( 'wimg' ) - VAL( 'wfield' ), 1, VAL( 'wfield' ), hrow
   CALL c406.Position VAL( 'wimg' ) + 2, h - hrow, w - VAL( 'wimg' ) - wdate - 3, hrow
   CALL c407.Position w - wdate, h - hrow, wdate - 2, hrow
   CALL c408.Position VAL( 'wimg' ) + 2, 1, w - VAL( 'wimg' ) - 2, h - 6 - VAL( 'wfield' )
   CALL c409.Position 0, 1, VAL( 'wimg' ) - VAL( 'wfield' ) - 1, hrow
   /*CALL c409.Position 2, 3, 1, 16*/
   CALL VAL 'app', VAL( 'app' ) + 1
   IF VAL( 'app' ) = VAL( 'app0' ) THEN CALL RxPlaceViewport
RETURN

row_Init:
   CALL Color '-', '#0'
   CALL c404.Font '9.WarpSans.Underscore'
   CALL c404.Color '+', '#0 0 200'
   CALL c405.Font '9.WarpSans'
   CALL c406.Font '9.WarpSans Bold'
   CALL c407.Font '9.WarpSans'
   CALL c408.Font '9.WarpSans'
RETURN

row_Open:
   CALL DRCtrlSetParent id(), 200
   CALL row_Size
RETURN

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Event handlers for dialog: zoom                                             |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

/* Event handlers for: zoom (DIALOG) */

zoom_Size:
   PARSE VALUE Position() WITH x y cw ch
   PARSE VALUE zoom.Frame() WITH l b r t
   CALL zoom.c601.Position l, b, cw - l - r, ch - t - b
   CALL zoom.c602.Position l, b, cw - l - r, ch - t - b
   CALL zoom.c601.Top
RETURN

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Global procedures:                                                          |
 |                                                                              |
 +-----------------------------------------------------------------------------*/
RxShowZoom:
   IF 2 < LENGTH( c401.Hint() ) THEN
   DO
      !_j_! = HintFor( c401.Hint() )
      IF !_j_! <> '' THEN
      DO
         PARSE VALUE zoom.Position() WITH visible . . .
         DO !_k_! = 1 TO VAL( 'viewport.'!_j_!'.sshot.0' )
            !_image_! = RxDownloadImage( VAL( 'viewport.'!_j_!'.sshot.'!_k_!'.href' ) )
         END
         PARSE VALUE rxImgReSize( !_image_! ) WITH iw ih id
         CALL zoom.c601.Hint !_image_!
         CALL zoom.c602.Text !_image_!
         PARSE VALUE main.Position() WITH x y . .
         PARSE VALUE PositionFor( c401.Hint() ) WITH dx dy . .
         PARSE VALUE c402.Position() WITH cx cy cw ch
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
   END
RETURN

RxRows:
   !_tags_! = 'name category updated_date developer desc url sshot dwnld'
   CALL RxMkDir VAL( 'HOME' )
   DO WHILE VAL( 'Fill' ) = 0
      CALL SysSleep 1
   END
   !_counter_! = 0
   DO FOREVER
      old_trace = TRACE( 'O' )
      CALL Use 'QUEUE', 1
      !_qd_! = QUEUED()
      IF 0 < !_qd_! THEN !_str_! = LINEIN( 'QUEUE:' )
      ELSE !_str_! = ''
      CALL Use 'QUEUE', 0
      IF !_str_! = '' THEN
      DO
         IF VAL( 'Fill' ) = 0 THEN LEAVE
         CALL SysSleep 0.2
         ITERATE
      END
      !_counter_! = !_counter_! + 1
      CALL Notify 'main', 'progressbar', !_counter_! / ( !_qd_! + !_counter_! )
      IF VAL( 'Fill' ) = 2 THEN LEAVE
      !_str_! = RxHTML2C( !_str_! )
      CALL TRACE old_trace
      DO i = 1 TO WORDS( !_tags_! )
         !_tag_! = SUBWORD( !_tags_!, i, 1 )
         IF 0 < POS( '<'||!_tag_!||'/>', !_str_! ) THEN
            !_val_! = ''
         ELSE
            PARSE VALUE !_str_! WITH '<'(!_tag_!)'>'!_val_!'</'(!_tag_!)'>'
         !_links_! = 0
         DO WHILE 0 < POS( '<a ', !_val_! )
            !_links_! = !_links_! + 1
            PARSE VALUE !_val_! WITH '<a href="'!_tgt_!'"'.'>'!_val_!'</a>'!_rest_!
            IF 0 < POS( '<img', !_val_! ) THEN
            DO
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.href', !_tgt_!

               PARSE VALUE !_val_! WITH '<img src="'!_tgt_!'"'!_rest_!'>'!_val_!
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.src', RxDownloadImage( !_tgt_! )
               PARSE VALUE !_rest_! WITH 'width="'!_tgt_!'"'
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.width', !_tgt_!
               PARSE VALUE !_rest_! WITH 'height="'!_tgt_!'"'
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.height', !_tgt_!
               PARSE VALUE !_rest_! WITH 'title="'!_tgt_!'"'
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.title', RxDecode( !_tgt_! )
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.0', 3
            END
            ELSE DO
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.0', 2
               CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.href', STRIP( !_tgt_!,, !_tab_! )
            END
            CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!, RxDecode( STRIP( !_val_!,, !_tab_! ) )
         END
         IF !_links_! = 0 THEN
         DO
            !_links_! = 1
            CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!'.0', !_links_!
            CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.'!_links_!, RxDecode( STRIP( !_val_!,, !_tab_! ) )
         END
         CALL VAL 'viewport.'!_counter_!'.'!_tag_!'.0', !_links_!
         CALL VAL 'viewport.0', !_counter_!
      END
      CALL VAL 'viewport.'!_counter_!'.dwnlded.1', -1
      IF 0 < POS( ':', VAL( 'downloads' ) ) THEN
         IF STREAM( VAL( 'downloads' )||'\'||FILESPEC( 'N', VAL( 'viewport.'!_counter_!'.dwnld.1' ) ), 'C', 'QUERY EXISTS' ) <> '' THEN
            CALL VAL 'viewport.'!_counter_!'.dwnlded.1', 100
      IF !_counter_! < VAL( 'app0' ) + 1 THEN
         CALL Notify 'viewport', 'load', !_counter_!
   END
   CALL Notify 'main', 'progressbar', 1
   CALL Notify 'viewport', 'range'
   CALL Notify 'main', 'progressbar', 'hide'

   DO !_i_! = 1 TO !_counter_!
      DO !_j_! = 1 TO VAL( 'viewport.'!_i_!'.sshot.0' )
         CALL RxDownloadImage VAL( 'viewport.'!_i_!'.sshot.'!_j_!'.href' )
      END
   END
RETURN 0

Search:
   IF !_searching_! = 1 THEN RETURN 0
   IF LENGTH( STRIP( ARG(1) ) ) < 3 THEN RETURN 0
   !_searching_! = 1
   CALL main.C107.Text ''
   CALL dropdown.C502.Delete
   CALL RxDropDown 1
   !_srch4_! = SysMapCase( ARG(1) )
   !_tags_! = 'name category updated_date desc sshot dwnld'
   !_type_! = 'Title Category Updated Description Screenshot URL'
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
      END
   END
   !_searching_! = 0
RETURN 0

RxDownloadImage:
   PARSE VALUE REVERSE( ARG(1) ) WITH !_fname_!'/'!_subfolder_!'/'!_folder_!'/'.
   !_fpath_! = REVERSE( !_subfolder_!'\'!_folder_! )
   PARSE VALUE REVERSE( !_fname_! ) WITH !_fname_!'?'.
   IF 3 < LENGTH( !_fpath_! ) THEN
      !_fname_! = VAL( 'HOME' )'\'!_fpath_!'\'!_fname_!
   ELSE RETURN ''
   IF ARG() < 2 THEN
      IF STREAM( !_fname_!, 'C', 'QUERY SIZE' ) < 10 THEN
      DO
         CALL RxMkDir VAL( 'HOME' )'\'!_fpath_!
         CALL RxGetURLComponents ARG(1)
         IF 0 = RxURLConnect() THEN
            CALL CHAROUT !_fname_!, RxFetchURL()
         CALL STREAM !_fname_!, 'C', 'CLOSE'
      END
RETURN !_fname_!

RxMKDir:
   PROCEDURE
   curr_path = ARG(1)
   IF DIRECTORY( curr_path ) = '' & LENGTH( curr_path ) > 2 THEN
      IF RxMkDir( STRIP( FILESPEC( 'D', curr_path )||FILESPEC( 'P', curr_path ), 'T', '\' ) ) = 0 THEN
         RETURN SysMKDir( curr_path )
      ELSE
         RETURN 1
RETURN 0

RxGetURLComponents:
   PROCEDURE EXPOSE host.
   IF 0< pos( 'seam', ARG(1) ) then call trace 'O'
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
   host.file = REVERSE( host.file )
   host.path = REVERSE( host.path )
   host.family = 'AF_INET'
RETURN

RxURLConnect:
   PROCEDURE EXPOSE host.
/* get dot address of host */
   IF 1 <> SockGetHostByName( host.location, 'host.' ) THEN
      RETURN 1

/* Close the connection if already open but not closed */
   IF SYMBOL( host.socket ) = 'VAR' THEN
      rc = SockClose( host.socket )

/* create socket */
   host.socket  = SockSocket( host.family, "SOCK_STREAM", 0 )
   IF host.socket < 0 THEN
      RETURN host.socket

/* connect it to the server */
   rc = SockConnect( host.socket, 'host.' )
RETURN rc

RxFetchURL:
   PROCEDURE EXPOSE host. text
   crlf = D2C(13)||D2C(10)
   t.1 = ' /'||host.path||'/'||host.file||' HTTP/1.1'||crlf
   t.2 = 'Host: '||host.location||crlf
   t.3 = 'Cookie: '||host.cookie||crlf
   t.4 = 'User-Agent: eCSoft/2 (OS/2; Warp 4.x; rv:1.0) DrDlg/20180407 OnlineSoftware/1.0'||crlf||crlf
   t.0 = 4

/* send message across ... loop in case entire message can't be sent in one SockSend() */
   IF LENGTH( ARG(1) ) > 0 THEN
      !_msg_! = 'POST'||t.1
   ELSE
      !_msg_! = 'GET'||t.1
   !_msg_! = !_msg_!||t.2
   IF SYMBOL( 'host.cookie' ) = 'VAR' THEN
      !_msg_! = !_msg_!||t.3
   IF LENGTH( ARG(1) ) > 0 THEN
      !_msg_! = !_msg_!||ARG(2)||crlf
   !_msg_! = !_msg_!||t.4
   DO WHILE !_msg_! <> ''
      bytes = SockSend( host.socket, !_msg_! )
      !_msg_! = SUBSTR( !_msg_!, bytes + 1 )
   END
   !_txt_! = ''
   IF TRANSLATE( ARG(1) ) <> 'QUIT' THEN
   DO WHILE 0 < rc
      rc = SockRecv( host.socket, '!_chnk_!', 1000 )
      !_txt_! = !_txt_!||!_chnk_!
      IF 0 < POS( '</node>', !_txt_! ) THEN
      DO
         PARSE VALUE !_txt_! WITH !_pre_!'<node>'!_tags_!'</node>'!_txt_!
         CALL CHAROUT VAL( 'HOME' )'\latest.xml', !_pre_!'<node>'!_tags_!'</node>'
         QUEUE !_tags_!
         CALL VAL 'Fill', 1
      END
   END
   CALL CHAROUT VAL( 'HOME' )'\latest.xml', !_txt_!
/* wait for server to close the connection, then close our end */
/*   rc = SockClose( host.socket )
 DROP host.socket*/
   DO WHILE 0 < POS( '</node>', !_txt_! )
      PARSE VALUE !_txt_! WITH '<node>'!_tags_!'</node>'!_txt_!
      CALL Use 'QUEUE', 1
      QUEUE !_tags_!
      CALL Use 'QUEUE', 0
   END
   crlf2 = crlf||crlf
   IF 0 < POS( 'Content-Length', !_txt_! ) THEN
      PARSE VALUE !_txt_! WITH .(crlf2)!_txt_!
   ELSE
      PARSE VALUE !_txt_! WITH .(crlf2)!_strlen_!(crlf)!_txt_!
RETURN !_txt_!

RxPlaceViewport:
   PARSE VALUE main.Frame() WITH l b r t
   PARSE VALUE main.Position() WITH x y w h
   DO i = 1 TO VAL( 'app0' )
      CALL VisibleFor 'app'i,, 1
   END
   IF \viewport.Visible() THEN
   DO
      CALL DRCtrlSetParent 200, 100
      CALL viewport.Visible 1
   END
RETURN

RxViewport:
   IF DATATYPE( ARG(1), 'W' ) THEN
   DO
      !_start_! = MAX( ARG(1), 1 )
      j = !_start_! - 1
      !_rows_! = !_start_!
      !_stop_! =  !_rows_!
   END
   ELSE DO
      !_start_! = 1
      j = MAX( main.c111.Select(), 1 ) - 1
      !_rows_! = MIN( VAL( 'viewport.0' ), VAL( 'app0' ), VAL( 'viewport_rows' ) + 1 )
      !_stop_! = MAX( !_rows_!, VAL( 'viewport_rows' ) + 1 )
   END
   DO i = !_start_! TO !_stop_!
      j = j + 1
      IF !_rows_! < i THEN
      DO k = 2 TO 8
         CALL TextFor 'app'i, 'C40'k, ' '
         CALL HintFor 'app'i,, ''
      END
      ELSE DO
         CALL HintFor 'app'i,, j
         CALL HintFor 'app'i, 'C401', 'app'i
         CALL TextFor 'app'i, 'C406', VAL( 'viewport.'j'.name.1' )
         CALL TextFor 'app'i, 'C407', Rx2LocalDateFormat( VAL( 'viewport.'j'.updated_date.1' ) )
         !_val_! = ''
         DO k = 1 TO VAL( 'viewport.'j'.developer.0' )
            !_val_! = !_val_!||VAL( 'viewport.'j'.developer.'k )||' '
         END
         /*CALL HintFor 'app'i, 'C406', VAL( 'viewport.'j'.name.1.href' )*/
         !_val_! = ''
         DO k = 1 TO VAL( 'viewport.'j'.sshot.0' )
            !_val_! = !_val_!||VAL( 'viewport.'j'.sshot.'k'.src' )||' '
         END
         IF STRIP( !_val_! ) = '' THEN
            CALL TextFor 'app'i, 'C403', 'Blank.png'
         ELSE
            CALL TextFor 'app'i, 'C403', STRIP( !_val_! )
         /*CALL HintFor 'app'i, 'C403', 'app'i*/
         !_val_! = ''
         DO k = 1 TO VAL( 'viewport.'j'.sshot.0' )
            !_val_! = !_val_!||VAL( 'viewport.'j'.sshot.'k'.href' )||' '
         END
         /*CALL HintFor 'app'i, 'C402', STRIP( !_val_! )*/
         /*CALL PositionFor 'app'i, 'C409', 4, 5, ( ( VAL( 'wimg' ) - VAL( 'wfield' ) - 9 ) * MAX( 0, MIN( 100, VAL( 'viewport.'j'.dwnlded.1' ) ) ) ) % 1, 16*/
         IF 0 < LENGTH( STRIP( VAL( 'viewport.'j'.dwnld.1' ) ) ) THEN
            CALL TextFor 'app'i, 'C404', 'Download'
         ELSE
            CALL TextFor 'app'i, 'C404', ''

         IF isBetween( -1, VAL( 'viewport.'j'.dwnlded.1' ), 100 ) THEN
         DO
            CALL HideFor 'app'i, 'C404'
            CALL ShowFor 'app'i, 'C409'
         END
         ELSE DO
            IF 0 < VAL( 'viewport.'j'.dwnlded.1' ) THEN
               CALL TextFor 'app'i, 'C404', 'Downloaded'
            CALL ShowFor 'app'i, 'C404'
            CALL HideFor 'app'i, 'C409'
         END
         /*CALL HintFor 'app'i, 'C404', STRIP( VAL( 'viewport.'j'.dwnld.1' ) )*/
         !_val_! = ''
         DO k = 1 TO VAL( 'viewport.'j'.category.0' )
            !_val_! = !_val_!||VAL( 'viewport.'j'.category.'k )||' '
         END
         CALL TextFor 'app'i, 'C408', VAL( 'viewport.'j'.desc.1' )
      END
      CALL TopFor 'app'i, 'C402'
   END
RETURN

Rx2LocalDateFormat:
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

RxRetrieve:
   CALL Notify 'main', 'progressbar', 'hide'
   DO WHILE 0 < QUEUED()
      PARSE PULL
   END
   rc = DIRECTORY( oldDir )

   CALL Notify 'main', 'progressbar', 0
   IF 0 < ARG() THEN
      CALL VAL 'URL', ARG(1)
   CALL RxGetURLComponents VAL( 'URL' )
   IF 0 <> RxURLConnect() THEN
   DO
      CALL VAL 'Fill', 0
      CALL Start 'RxRows', 1208
      !_fname_! = VAL( 'HOME' )'\latest.xml'
      IF STREAM( !_fname_!, 'C', 'QUERY EXISTS' ) <> '' THEN
      DO
         !_fsize_! = STREAM( !_fname_!, 'C', 'QUERY SIZE' )
         IF 10 < !_fsize_! THEN
         DO
            !_input_! = CHARIN( !_fname_!, 1, !_fsize_! )
            CALL STREAM !_fname_!, 'C', 'CLOSE'
            DO WHILE 0 < POS( '</node>', !_input_! )
               PARSE VALUE !_input_! WITH '<node>'!_tags_!'</node>'!_input_!
               QUEUE !_tags_!
               CALL VAL 'Fill', 1
            END
         END
      END
   END
   ELSE DO
      CALL SysFileDelete VAL( 'HOME' )'\latest.xml'
      CALL VAL 'Fill', 0
      CALL Start 'RxRows', 1208
      CALL RxFetchURL
   END
   CALL STREAM VAL( 'HOME' )'\latest.xml', 'C', 'CLOSE'
   CALL VAL 'Fill', 0
   CALL Notify 'main', 'progressbar', 'show'
RETURN

RxDropDown:
   dd = 'category dropdown'
   dd_arrow = ' '
   PARSE VALUE main.Frame() WITH l b r t
   PARSE VALUE main.Position() WITH x y w h
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
RETURN

RxDownload:
   PARSE ARG !_j_! !_path_!
   CALL VAL 'Downloading', 1
   CALL VAL 'viewport.'!_j_!'.dwnlded.1', 0
   newq = RXQUEUE( 'Create', 'NewQ' )
   monitor_ok = Start( 'RxMonitor', !_j_! newq )
   tab = D2C(9)
   lock = DIRECTORY()'\'ARG(2)'.lck'
   CALL RxGetURLComponents VAL( 'viewport.'!_j_!'.dwnld.1' )
   IF !_path_! = '' THEN
      !_path_! = VAL( 'downloads' )
   dwnld = CHANGESTR( '%p', CHANGESTR( '%f', CHANGESTR( '%h', CHANGESTR( '%u', VAL( 'params' ), VAL( 'viewport.'!_j_!'.dwnld.1' ) ), VAL( 'referer' ) ), host.file ), !_path_! )
   '@'dwnld' 3>'lock' 2>>&1|RXQUEUE 'newq
   DO WHILE STREAM( lock, 'C', 'QUERY EXIST' ) = ''
      CALL SysSleep 0.5
   END
   DO UNTIL STREAM( lock, 'C', 'OPEN READ' ) = 'READY:'
      CALL SysSleep 0.5
   END
   CALL STREAM lock, 'C', 'CLOSE'
   CALL SysFileDelete lock
   CALL VAL 'Downloading', 0
RETURN Result( monitor_ok )

RxMonitor:
   PARSE ARG !_j_! qName
   tab = D2C(9)
   count = 0
   oldq = RXQUEUE( 'Set', qName )
   CALL TIME 'R'
   qd = 0
   found = 0
   cfound = 0
   DO FOREVER
      CALL Use 'QUEUE', 1
      qd = QUEUED()
      IF 0 < qd THEN
         status = LINEIN( 'QUEUE:' )
      ELSE status = ''
      CALL Use 'QUEUE', 0
      IF status = '' THEN
      DO
         CALL SysSleep 0.5
         IF qd < 1 & VAL( 'Downloading' ) < 1 THEN
            LEAVE
      END
      ELSE IF 0 < POS( '%', status ) THEN
      DO
         PARSE VALUE status WITH . percent'%'.
         percent = TRANSLATE( percent, '.', ',' )
         IF DATATYPE( percent, 'N' ) THEN
            CALL VAL 'viewport.'!_j_!'.dwnlded.1', MIN( 100, percent )
         CALL Notify 'viewport', 'progress', !_j_!
      END
   END
   CALL VAL 'viewport.'!_j_!'.dwnlded.1', 100
RETURN

RxChkParams:
   IF 0 < LENGTH( rxChkApp( 'wget.exe', ' --version --quiet', 'GNU WGET' ) ) THEN
      dwnld = 'WGet -c -t 10 -w 30 --referer=%h --progress=bar:force -P "%p" "%u"'
   ELSE IF 0 < LENGTH( rxChkApp( 'curl.exe', ' --version', 'CURL' ) ) THEN
      dwnld = 'cURL -y 300 -Y 1 -v -C - -# -L -o "%p/%f" "%u"'
   ELSE
      dwnld = ''
RETURN dwnld

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
         PARSE VALUE REVERSE( SysSearchPath( 'PATH', ARG(1) ) ) WITH .'\'fpath
         RETURN REVERSE( fpath )
      END
   END
RETURN ''

RxCategories:
   CALL RxGetURLComponents ARG(1)
   !_input_! = ''
   IF 0 = RxURLConnect() THEN
      !_input_! = RxFetchURL( )
   ELSE CALL SysSleep 2
   !_input_! = RxHTML2C( !_input_! )
   CALL Notify 'category', 'add', 'New software: Latest'||!_tab_!||'http://ecsoft2.org/xml-export'
   DO WHILE 0 < POS( 'HREF=', TRANSLATE( !_input_! ) )
      PARSE VALUE !_input_! WITH .'<term>'.'<a href="'!_tgt_!'"'.'>'!_val_!'</a>'.'</term>'!_input_!
      CALL Notify 'category', 'add', !_val_!||!_tab_!||!_tgt_!
   END
RETURN 0

RxDecodeURL: PROCEDURE
PARSE ARG url
DO WHILE POS( '%', url ) > 0
   i = POS( '%', url );
   url = SUBSTR( url, 1, i - 1 ) ||,
   X2C( SUBSTR( url, i + 1, 2 ) ) ||,
   SUBSTR( url, i + 3 )
END
RETURN url

RxDecode: PROCEDURE
PARSE ARG url
DO WHILE 0 < POS( '&#', url )
   i = POS( '&#', url );
   j = POS( ';', url, i )
   IF isBetween( 0, i - j, 5 ) THEN
   url = SUBSTR( url, 1, i - 2 ) ||,
   X2C( SUBSTR( url, i + 2, j - i - 2 ) ) ||,
   SUBSTR( url, j + 1 )
   ELSE
      url = SUBSTR( url, 1, i - 2 ) ||,
   SUBSTR( url, j + 1 )
END
RETURN url

RxHTML2C: PROCEDURE EXPOSE f. t. r. !_tab_! !_crlf_! !_lf_!
   IF \DATATYPE( f.0, 'W' ) THEN DO
      !_lf_! = D2C(10); !_crlf_! = D2C(13)||!_lf_!; !_tab_! = D2C(9); f.1 = ' <'; t.1 = '<'; f.2 = '> ';
      t.2 = '>'; f.3 = '&lt;'; t.3 = '<'; f.4 = '&gt;'; t.4 = '>'; f.5 = '&amp;'
      t.5 = '&'; f.6 = '&nbsp;'; t.6 = ' '; f.0 = 6; r.1 = '  '; r.2 = !_tab_!;
      r.3 = !_lf_!; r.0 = 3;
   END
   !_str_! = TRANSLATE( ARG(1), !_tab_!, !_crlf_! )
   DO i = 1 TO r.0
      !_str_! = CHANGESTR( r.i, !_str_! )
   END
   DO i = 1 TO f.0
      !_str_! = CHANGESTR( f.i, !_str_!, t.i )
   END
   !_str_! = RxDecode( !_str_! )
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
      CALL RxCreateURL( ARG(1), '<WP_DESKTOP>', '<WP_ONLINESOFT>', ARG(2) )
   CALL SysSetObjectData  '<WP_ONLINESOFT>', 'OPEN=DEFAULT';
RETURN retval

/* Delete part (needle) of string (haystack) */
DELETESTR: PROCEDURE /* needle, haystack */
   IF TRACE() = '?I' THEN CALL TRACE 'O'
   PARSE ARG needle, haystack
   i = 0
   start = TIME( 'S' )
   h_len = LENGTH( haystack )
   n_len = LENGTH( needle )
   str_pos = POS( needle, haystack )
   DO WHILE strpos > 0
      haystack = DELSTR( haystack, str_pos, n_len )
      IF start + 1 < TIME( 'S' ) THEN
      DO
         i = ( i + 1 ) // 3
         start = TIME( 'S' )
      END
      str_pos = POS( needle, haystack )
   END
RETURN haystack

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

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Default initialization:                                                     |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

INIT:
   SIGNAL RETURN

/*-----------------------------------------------------------------------------+
 |                                                                              |
 |  Default error handlers:                                                     |
 |                                                                              |
 +-----------------------------------------------------------------------------*/

SYNTAX:
   SAY 'SYNTAX ERROR:' errortext( rc ) 'in:'
   SAY sourceline( sigl )
   SIGNAL ON SYNTAX
   SIGNAL RETURN

HALT:
   SAY 'HALT occurred in:'
   SAY sourceline( sigl )
   SIGNAL ON HALT
  SIGNAL RETURN
   
BLDLVL:
RETURN @#Jan-Erik Laerka:1.00.00#@##1## 2018-07-08               SONYVAIO::::0::@@Show software listed online with eCSoft/2