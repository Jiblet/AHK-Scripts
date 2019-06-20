#SingleInstance Force
#NoEnv
SendMode Input
SetWorkingDir c:\  ; Ensures a consistent starting directory.

#c::Run cmd

#f::Run mstsc /admin

#w::Run cmd

#v::
bak = %clipboard%
clipboard = %bak%
Send ^v
return

#1::Send ^{Ins}
#2::Send {AppsKey}{NumpadMult}
#3::Send {AppsKey}{NumpadSub}