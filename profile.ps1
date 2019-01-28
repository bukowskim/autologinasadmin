function Test-IslocalAdministrator() {
	$currentwindowsidentity = [system.security.principal.windowsidentity]::getcurrent()
	$currentwindowsprincipal = new-object system.security.principal.windowsprincipal($currentwindowsidentity)
	$isinwindowsbuiltinadministratorrole = $currentwindowsprincipal.isinrole([system.security.principal.windowsbuiltinrole]::administrator)
	return $isinwindowsbuiltinadministratorrole;
}

function New-OrUpdateWindowsCredential() {
	$fileName = (Join-Path $env:userprofile "credentials.xml");
	if (Test-Path $fileName) 
	{
	  Remove-Item $fileName
	}

	$credentials = Get-Credential
	$credentials | Export-Clixml $fileName
}

function Start-WithAdmin {
	Param(
         [Parameter(Mandatory=$true, Position=0)]
         [string] $filePath
    )
	
	if(!(Test-IslocalAdministrator)){
		$credentials = Import-CliXml -Path (Join-Path $env:userprofile "credentials.xml")
		$command = "Start-Process -FilePath '$filePath' -verb runas";
		Start-Process -PassThru powershell -WindowStyle Hidden -WorkingDirectory $env:userprofile -Credential ($credentials) -ArgumentList "-noprofile -command ""$command""" | Out-Null
	}
	else{
		Start-Process -FilePath $filePath
	}
}

function Start-VisualStudio {
	Start-WithAdmin "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.exe"
}

function Start-Notepad {
	Start-WithAdmin -FilePath "C:\Program Files\Notepad++\notepad++.exe"
}
function Start-Powershell {
	Start-WithAdmin -FilePath "powershell"
}

function Set-AdminShortcut {
	param ( 
		[Parameter(Mandatory=$true)][string]$sourceExe, 
		[Parameter(Mandatory=$true)][string]$destShortcut,
		[Parameter(Mandatory=$false)][string]$command = "Start-WithAdmin '"+ $sourceExe + "';pause"
	)
	
	$WshShell = New-Object -comObject WScript.Shell
	$Shortcut = $WshShell.CreateShortcut($destShortcut);
	$Shortcut.TargetPath = "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe";
	$Shortcut.Arguments = "-Command " + $command;
	$Shortcut.IconLocation = $sourceExe;
	$Shortcut.WindowStyle = 7;
	$Shortcut.Save();
}
