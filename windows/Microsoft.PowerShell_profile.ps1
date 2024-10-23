# Location: $env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
$Env:KOMOREBI_CONFIG_HOME = 'C:\Users\nunix\.config\komorebi'
Invoke-Expression (&starship init powershell)
function Restart-Komorebic {
    komorebic stop --whkd --bar; komorebic start --whkd --bar --ffm
}
