rake 'app:does_admin_exist?'
if [ $? -eq 0 ]; then
    echo OK
else
    echo FAIL
fi