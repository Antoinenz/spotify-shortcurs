; --- Configuration ---
; Path to your Python interpreter.
; This might vary depending on your Python installation.
; Try "python.exe" or "py.exe" first. If that doesn't work, find the full path.
PythonExePath := "python.exe" ; or "py.exe" or "C:\Path\To\Your\Python\python.exe"

; Full path to your Python script (ensure this is correct!)
SpotifyScriptPath := "spotify_volume_control.py" ; Assumes python script is in the same directory

; --- Hotkeys ---
PgUp::
    PythonResult := RunPythonAndGetOutput(PythonExePath, SpotifyScriptPath, "up")
    ShowResultInToolTip(PythonResult, "Spotify Vol Up (No specific output from script)")
return

PgDn::
    PythonResult := RunPythonAndGetOutput(PythonExePath, SpotifyScriptPath, "down")
    ShowResultInToolTip(PythonResult, "Spotify Vol Down (No specific output from script)")
return

; --- Functions ---
RunPythonAndGetOutput(PythonExe, ScriptPath, Arg) {
    Static WshShell := "" ; Initialize statically for persistence
    If (!WshShell) ; Create WScript.Shell object only once
        WshShell := ComObjCreate("WScript.Shell")
    
    FullCommand := """" . PythonExe . """ """ . A_ScriptDir . "\" . ScriptPath . """ """ . Arg . """"
    Try {
        Exec := WshShell.Exec(FullCommand)
        
        StdOut := ""
        While !Exec.StdOut.AtEndOfStream
            StdOut .= Exec.StdOut.Read(1024)

        StdErr := ""
        While !Exec.StdErr.AtEndOfStream
            StdErr .= Exec.StdErr.Read(1024)

        While (Exec.Status = 0) { 
            Sleep, 50 
        }
        ExitCode := Exec.ExitCode

        Output := ""
        If (StdErr) {
            Output .= "Error: `n" . Trim(StdErr, "`r`n `t")
        }
        If (StdOut) {
            If (Output) 
                Output .= "`n`nOutput:`n"
            Output .= Trim(StdOut, "`r`n `t")
        }
        
        If (!Output && ExitCode != 0) {
            Output := "Python script failed with exit code: " . ExitCode . ". No output captured."
        }
        Return Output
    } Catch e {
        Return "AutoHotkey Error: Failed to execute Python script.`nDetails: " . e.Message
    }
}

ShowResultInToolTip(ResultText, DefaultSuccessText) {
    Static ToolTipDisplayTime := 3000 
    
    If (ResultText) {
        ToolTip, % ResultText
        If InStr(ResultText, "Error") || InStr(ResultText, "failed") || InStr(ResultText, "Missing") || InStr(ResultText, "not found")
            SetTimer, RemoveToolTip, -5000 
        Else
            SetTimer, RemoveToolTip, -3000 
    } Else {
        ToolTip, % DefaultSuccessText
        SetTimer, RemoveToolTip, -2000 
    }
}

RemoveToolTip:
    ToolTip
return