@Echo Off

Reg.exe add "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\Key_Folder_Here" /v "NetworkAddress" /t REG_SZ /d "1E-63-9A-D4-8C-ED" /f

netsh interface set interface name="Your_Network_adapter_Name_Here" admin="disabled"
netsh interface set interface name="Your_Network_adapter_Name_Here" admin="enabled"


Exit

