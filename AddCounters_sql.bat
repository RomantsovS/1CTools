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

"\Process("sqlservr")\%% Processor Time" "\SQLServer:Buffer Manager\Buffer cache hit ratio" "\SQLServer:Buffer Manager\Page life expectancy" ^

"\SQLServer:Plan Cache(_Total)\Cache hit ratio" "\SQLServer:Buffer Manager\Checkpoint pages/sec" "\SQLServer:Buffer Manager\Lazy writes/sec" ^

"\SQLServer:Buffer Manager\Page reads/sec" "\SQLServer:Buffer Manager\Page writes/sec" ^

"\SQLServer:SQL Statistics\Batch Requests/sec" "\SQLServer:SQL Statistics\SQL Compilations/sec" "\SQLServer:SQL Statistics\SQL Re-Compilations/sec" ^

"\SQLServer:General Statistics\Transactions" "\SQLServer:General Statistics\User Connections" "\SQLServer:Transactions\Longest Transaction Running Time" ^
"\SQLServer:Transactions\Free space in TempDB" ^

"\SQLServer:Latches\Average Latch Wait Time (ms)" ^

"\SQLServer:Locks\Average Wait Time (ms)" "\SQLServer:Locks\Lock Timeouts(timeout>0)/sec" "\SQLServer:Locks\Number of Deadlocks/sec" -si 15 -v mmddhhmm
::logman start 1C_bat_file
ECHO Complete