chcp 65001
oscript t:\RomantsovSS\1CTools\OneScript\run_ib_release_update\run_ib_release_update.os -platform "8.3.20.1789" ^
-server1c "hm-1c-dev" -cluster1c_port "1540" -base_name "itilium_test_release" -admin_1c_name "Администратор" ^
-admin_1c_pwd "AwEmnksdzp7JLv7hIWkt" -rac_port "1545" -cluster1c_name "Локальный кластер" ^
-storage_path "tcp://hm-1c-dev/ITIL/Release_SBL_ext" -storage_login "itilium_test_release" -storage_password "" ^
-extension_name "СберЛогистика" -wait_before_lock "30" -lock_time "7200" -wait_deferred_handler "0" -verbose "true"