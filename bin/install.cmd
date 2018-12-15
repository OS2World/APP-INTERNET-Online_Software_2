/*
 * Filename: install.cmd
 *   Author: JanErik
 *  Created: Sat Dec 15 2018
 *  Purpose: Create Desktop Objects for Online Software / 2
 *  Changes: 
 */

/* Load RexxUtil Library */
If RxFuncQuery('SysLoadFuncs') Then
Do
   Call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
   Call SysLoadFuncs
End

Obj.1.ID =    '<WP_APPSFOLDER>'

Obj.2.ID =    '<WP_ONLINESOFTWARE2FLD>'
Obj.2.Title = 'Download new software'
Obj.2.Setup = ''
Obj.2.Type =  'WPFolder'
Obj.2.ref =   1

Obj.3.ID =    '<WP_ONLINESOFTWARE2>'
Obj.3.Title = 'Online Software / 2'
Obj.3.Setup = 'EXENAME='||DIRECTORY()||'\SOFTWARE2.EXE;'
Obj.3.Type =  'WPProgram'
Obj.3.ref =   2

Obj.4.ID =    '<WP_ONLINESOFTWARE2_HLP>'
Obj.4.Title = 'Online Software / 2 Help'
Obj.4.Setup = 'EXENAME=VIEW.EXE;PARAMETERS='||DIRECTORY()||'\Online_Software_2.inf;'
Obj.4.Type =  'WPProgram'
Obj.4.ref =   2

Obj.0 = 4

DO i = 2 TO Obj.0
   tgt = Obj.i.ref
   tempRC = SysCreateObject( Obj.i.Type,,
   Obj.i.Title,,
   Obj.tgt.ID,,
   'OBJECTID='||Obj.i.ID||';'||Obj.i.Setup,,
   'Update' )
END