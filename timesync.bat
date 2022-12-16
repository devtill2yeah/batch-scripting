

@echo off
w32tm /query /peers
sc config w32time start= auto
w32tm /config /syncfromflags:manual /manualpeerlist:"0.us.pool.ntp.org,1.us.pool.ntp.org,2.us.pool.ntp.org,3.us.pool.ntp.org"
w32tm /config /reliable:yes
net stop w32time
net start w32time
w32tm /resync /nowait


