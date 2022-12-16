
@echo off

set ScriptPath=%~dp0
set ThisPCMAC=00-FF-5D-8F-A8-4B, C6-3E-6F-63-20-4C, 94-C6-91-93-B8-E5, 14-4F-8A-F5-1E-EF, 0A-00-27-00-00-08, 0A-00-27-00-00-03, 00-FF-B6-35-0E-F5
set FoundMAC=D6EEFCAA-6B10-4F8F-A0F9-EAD3686223ED, 486C4991-1977-40A7-B8C3-A1D719FF1FCB, 0B56E2D8-0004-4D46-B8DD-225CBA4036DD

echo.
echo ScriptPath = %ScriptPath%


for /f "tokens=3 delims=," %%a in ('"getmac /v /fo csv | findstr Ethernet"') do set ThisPCMAC=%%a
echo.
echo MAC address of this computer is %ThisPCMAC%

for /F "usebackq delims==" %%b in (`"type %ScriptPath%list.txt | findstr %ThisPCMAC%"`) do set FoundMAC=%%b

if DEFINED FoundMAC (
   goto :norestart
) else (
   goto :restart
)


:norestart
echo.
echo Found %FoundMAC% in %ScriptPath%list.txt: Nothing to do.
goto :end


:restart
echo.
echo %ThisPCMAC% not found in %ScriptPath%list.txt: Restarting...
echo.
echo shutdown /r /f /t 600 /d p:00:00
shutdown /r /f /t 600 /d p:00:00
echo.
echo Cancel restart with the following command:
echo    shutdown /a
goto :end


:end
echo.
echo %~fp0 ended.
pause





//@echo off for /f "tokens=3 delims=," %%a in ('"getmac /v /fo csv | findstr Ethernet"') 
//do set MAC=%%a echo MAC address of this computer is %MAC% for /f "delims=" %%c in ('findstr /I %MAC% "\\10.51.10.10\DDC-Configuration*"') 
//do set "var=%%~nc" set "var=%var:~0,-1%" echo "%var%" echo hey I am %var% echo Re-imageing is started at DDC with MAC address: %MAC% at time: %time% > %var%.txt 

