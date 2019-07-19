Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" -Name "IsInstalled" -Value 0
Stop-Process -Name Explorer

Add-Content 'c:\demo.ahk' '#NoEnv
#Warn
#SingleInstance forces

Run, calc.exe
WinWaitActive, Calculator
Send, 1{NumpadAdd}1=
Send, ^C
WinClose, Calculator
Fileappend,%clipboard%,c:\output.txt'

C:\"Program Files"\AutoHotkey\AutoHotkey.exe c:\demo.ahk

aws s3 cp c:\output.txt s3://rpademo/

Stop-Computer