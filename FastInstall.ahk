#SingleInstance force
#MaxMem 256
#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; This example downloads the latest AHK environment and stores
; the received binary data to a file.

download1("http://ftp.opera.com/pub/opera/win/1010b1/int/Opera_int_b1_Setup.msi","Opera_int_b1_Setup.msi")
download1("http://ftp.snt.utwente.nl/pub/software/openoffice/stable/3.1.1/OOo_3.1.1_Win32Intel_install_wJRE_en-US.exe","OOo_3.1.1_Win32Intel_install_wJRE_en-US.exe") ;Somehow this download never finishes.
download1(URL,Filename2)
{
global
data     := ""
httpQueryOps := "updateSize"
SetTimer,showSize,10
length   := httpQuery(data,URL)
Progress, off
SetTimer,showSize,off
if (write_bin(data,filename2,length)!=1)
   MsgBox "There was an Error!"
else
   MsgBox File downloaded and saved as "%filename2%"!
Return

showSize:
   percentageDone := HttpQueryCurrentSize / HttpQueryFullSize * 100 -0.000001
   StringSplit,done,percentagedone,.
   progress, %done1%,If the download stalls then just wait`,it does still continue.,%percentagedone%`% done,Downloading %filename2%
   winmove,Downloading %filename2%,,0,0
return
}

GuiClose:
GuiEscape:
   ExitApp

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
   result := DllCall("WriteFile","UInt",h,"Str",bin,"UInt"
               ,size,"UInt *",Written,"UInt",0)
   h := DllCall("CloseHandle", "Uint", h)
   return, 1
}

#include httpQuery.ahk