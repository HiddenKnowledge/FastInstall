#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#include httpQuery.ahk

DownloadFile( "ftp://ftp.snt.utwente.nl/pub/software/openoffice/stable/3.1.1/OOo_3.1.1_Win32Intel_install_wJRE_en-US.exe", "OpenOffice.exe" )

write_bin( byref bin, filename, size ) {
	global result
	h := DllCall("CreateFile","str",filename,"Uint",0x40000000
		,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
	if (ErrorLevel = 0 || h = -1)
		ExitApp ; couldn't create the file
	if !DllCall("SetFilePointerEx","Uint",h,"Int64",0,"UInt *",p,"Int",0)
		ErrorLevel := -3
	if (ErrorLevel != 0)
	{
		t := ErrorLevel                ; save ErrorLevel to be returned
		, DllCall("CloseHandle", "Uint", h)
		, ErrorLevel := t              ; return seek error
	}
	result := DllCall( "WriteFile"
		, "UInt"  , h
		, "Str"   , bin
		, "UInt"  , size
		, "UInt *", Written
		, "UInt"  , 0)
	DllCall("CloseHandle", "Uint", h)
	return, 1
}

DownloadFile(url, filename) {
	global httpQueryOps := "updateSize", HttpQueryCurrentSize, HttpQueryFullSize
	SetTimer, showSize, 10
	length   := httpQuery( data, URL )
	progress, off
	SetTimer, showSize, Off
	if (write_bin(data,filename,length)!=1)
	   MsgBox "There was an Error!"
	else
	   MsgBox File downloaded and saved.
	VarSetCapacity(data, 0) ;free the variable
	Return
;;;;;;;;;;

	showSize:
		progress, % Floor(HttpQueryCurrentSize / HttpQueryFullSize * 100)
	return
}