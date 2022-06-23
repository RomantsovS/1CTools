select 
_UserId,
_ObjectKey,
_settingskey
from _SystemSettings
where _UserId = 'Лебедев Павел'
order by _UserId, _ObjectKey