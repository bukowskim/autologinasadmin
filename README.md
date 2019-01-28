# autologinasadmin

Scripts for envrionment where user has non-administrator account with ability to login to an administrator account to perform some action (something like sudo in linux). When doing so (depending on configuration) user has to type login and password every time he needs to make a higher-permission action. This instruction shows you how to avoid all of the typing.

1. Copy profile.ps1 to ```C:\Windows\System32\WindowsPowerShell\v1.0\```.

2. Open powershell as **non-admin** user.

3. Invoke ```New-OrUpdateWindowsCredential``` and type admin login and password (you have to type ***login with your domain name***, like `CORPORATE\USERNAME`).

4. Now you can use ```Start-WithAdmin``` function from powershell, which elevates your permissions to admin account.

    ```powershell
    Start-WithAdmin "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.exe"
    ```

5. You also can create your own functions (see ```Start-VisualStudio``` in profile.ps1 ).

6. What can come in handy is ```Set-AdminShortcut``` function. It creates a windows shortcut that launch application as admin. Usage:

    ```powershell
    Set-AdminShortcut 'C:\Windows\System32\Taskmgr.exe' 'C:\ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools\Task Manager.lnk'


    Set-AdminShortcut 'C:\Program Files (
    x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\devenv.exe' 'PATH-TO-USER\Desktop\Visual Studio 2017.lnk' 'Start-VisualStudio'
    ```

    Please, see implementation in profile.ps1.

Drawbacks of this solution:

1. Applications can start slower.