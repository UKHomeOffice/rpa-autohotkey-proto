#NoEnv
#Warn
#SingleInstance forces

Run, calc.exe
WinWaitActive, Calculator
Send, 1{NumpadAdd}1=
Send, ^C
WinClose, Calculator
Fileappend,%clipboard%,c:\output.txt
