@ECHO OFF
ECHO Adding counter "1C_bat_file" ...
logman create counter 1C_counter -f bincirc -c "\Processor(_Total)\Interrupts/sec" "\Processor(_Total)\%% Idle Time" "\Processor(_Total)\%% Processor Time" ^

"\Processor(*)\%% Processor Time" "\Processor(_Total)\%% Privileged Time" "\Processor(_Total)\%% C1 Time" "\Processor(_Total)\%% C2 Time" ^

"\Processor(_Total)\%% C3 Time" "\Processor(_Total)\%% User Time" ^

"\System\Context Switches/sec" "\System\File Read Bytes/sec" "\System\File Write Bytes/sec" "\System\Processes" "\System\Processor Queue Length" ^

"\System\Threads" ^

"\PhysicalDisk(*)\%% Disk Time" "\PhysicalDisk(*)\Avg. Disk Queue Length" "\PhysicalDisk(*)\Avg. Disk Read Queue Length" "\PhysicalDisk(*)\Avg. Disk Write Queue Length" ^

"\PhysicalDisk(*)\Avg. Disk Sec/Transfer" "\PhysicalDisk(*)\Avg. Disk Sec/Read" "\PhysicalDisk(*)\Avg. Disk Sec/Write" ^

"\Memory\Available Mbytes" ^

"\LogicalDisk(_Total)\% Free Space" ^

"\Network Adapter(*)\Bytes Total/sec" ^

-si 15 -v mmddhhmm
::logman start 1C_bat_file
ECHO Complete