; Close a running SQLcraftr before install or uninstall replaces its files.
; The page cancels beforeunload, so a gentle close can leave the process
; holding SQLcraftr.exe and icudtl.dat. Force-kill that image name.

!macro customCheckAppRunning
  StrCpy $R1 0
  sqlj_close_loop:
    nsExec::Exec `"$SYSDIR\taskkill.exe" /F /T /IM "SQLcraftr.exe"`
    Pop $0
    ${if} $0 == 0
      Sleep 1200
    ${endIf}
    nsExec::Exec `"$SYSDIR\cmd.exe" /C tasklist /FI "IMAGENAME eq SQLcraftr.exe" /FO CSV /NH | "$SYSDIR\findstr.exe" /B /I /C:"\"SQLcraftr.exe\""`
    Pop $0
    ${if} $0 == 0
      IntOp $R1 $R1 + 1
      ${if} $R1 > 4
        MessageBox MB_RETRYCANCEL|MB_ICONEXCLAMATION "$(appCannotBeClosed)" /SD IDCANCEL IDRETRY sqlj_close_loop
        Quit
      ${else}
        Sleep 1000
        Goto sqlj_close_loop
      ${endIf}
    ${endIf}
!macroend
