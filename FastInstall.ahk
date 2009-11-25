#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; This example downloads the latest AHK environment and stores
; the received binary data to a file.
#noenv
filename2 := "example.exe"
data     := ""
URL      := "http://www.autohotkey.net"
httpQueryOps := "updateSize"
SetTimer,showSize,10
length   := httpQuery(data,URL)
Tooltip
if (write_bin(data,filename2,length)!=1)
   MsgBox "There was an Error!"
else
   MsgBox AHK Source downloaded and saved as "ahk.zip"!
Return

showSize:
   Tooltip,% HttpQueryCurrentSize "/" HttpQueryFullSize
return

GuiClose:
GuiEscape:
   ExitApp

write_bin(byref bin,filename,size){
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
   result := DllCall("WriteFile","UInt",h,"Str",bin,"UInt"
               ,size,"UInt *",Written,"UInt",0)
   h := DllCall("CloseHandle", "Uint", h)
   return, 1
}

#include httpQuery.ahk