#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
#Include gameFuncs.ahk
#Include miscFuncs.ahk
#Include sellToBlackLion.ahk
DetectHiddenWindows, On
CoordMode, Mouse, Screen
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

^esc::ExitApp
^r::Reload
^p::pause
^!o::doAllTheThing()
^o::sellRepetitively()
^!p::showMouseCoordinates()
