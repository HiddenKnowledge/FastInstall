;
; AutoHotkey Version: Newest
; Language:       English
; Platform:       Win9x/NT
; Author:         Kevin@glazenburg.com
; 
; Script Function:
; An project that makes it easier to install programs after an clean computer install.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; exmpl.downloadBinary.httpQuery.ahk
; This example downloads the latest AHK environment and stores
; the received binary data to a file.
#noenv
#include httpQuery.ahk

downloadfile("ftp://ftp.snt.utwente.nl/pub/software/openoffice/stable/3.1.1/OOo_3.1.1_Win32Intel_install_wJRE_en-US.exe","OpenOffice.exe")



write_bin(byref bin,filename,size){
   global
   h := DllCall("CreateFile","str",filename,"Uint",0x40000000
            ,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,ExitApp ; couldn't create the file
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%              ; save ErrorLevel to be returned
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%              ; return seek error
   }
   global result
   result := DllCall("WriteFile","UInt",h,"Str",bin,"UInt"
               ,size,"UInt *",Written,"UInt",0)
   h := DllCall("CloseHandle", "Uint", h)
   return, 1
}

downloadfile(url, filename)
{
global
data     := ""
httpQueryOps := "updateSize"
firsttime = 0
SetTimer,showSize,10
length   := httpQuery(data,URL)
progress, off
SetTimer,showSize, off
if (write_bin(data,filename,length)!=1)
   MsgBox "There was an Error!"
else
   MsgBox File downloaded and saved.
Return

showSize:
percentageDone := HttpQueryCurrentSize / HttpQueryFullSize * 100
StringSplit,done,percentagedone,.
progress, %done1%
return

GuiClose:
GuiEscape:
   ExitApp
}
