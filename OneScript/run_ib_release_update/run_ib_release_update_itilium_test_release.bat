chcp 65001
oscript t:\RomantsovSS\1CTools\OneScript\run_ib_release_update\run_ib_release_update.os -platform "8.3.20.1789" ^
-server1c "" -cluster1c_port "1540" -base_name "" -admin_1c_name "Администратор" ^
-admin_1c_pwd "" -rac_port "1545" -cluster1c_name "Локальный кластер" ^
-storage_path "tcp://" -storage_login "" -storage_password "" ^
-extension_name "" -wait_before_lock "30" -lock_time "7200" -wait_deferred_handler "0" -verbose "true"
