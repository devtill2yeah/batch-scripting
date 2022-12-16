
@Echo Off

Reg.exe delete "HKLM\SYSTEM\ControlSet001\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\Key_Folder_Here" /v "NetworkAddress" /f


netsh interface set interface name="Your_Network_adapter_Name_Here" admin="disabled"

netsh interface set interface name="Your_Network_adapter_Name_Here" admin="enabled"


Exit


