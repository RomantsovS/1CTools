chcp 65001
c:
cd c:\Program Files\OneScript\bin\
oscript t:\RomantsovSS\1CTools\OneScript\run_ib_release_update\run_ib_release_update.os -platform "8.3.18.1616" ^
-server1c "hm-1c-dev" -cluster1c_port "1540" -base_name "itilium_dev_romantsov" -admin_1c_name "Администратор" ^
-admin_1c_pwd "AwEmnksdzp7JLv7hIWkt" -rac_port "1545" -cluster1c_name "Локальный кластер" ^
-storage_path "tcp://hm-1c-dev/ITIL/SBL_ext" -storage_login "romantsov.s.s@sblogistica.ru" -storage_password "" ^
-extension_name "СберЛогистика" -wait_deferred_handler "0" -verbose "true"