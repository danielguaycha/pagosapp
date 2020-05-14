read -p "Ingresa la ip del servidor : " ip

rm -rf lib/env.dart
rm -rf run.bat
rm -rf ../../Laravel/paycserver/run.bat

echo "const server = '$ip';" >> lib/env.dart
echo "cd ../pagoserver && php artisan serve --port=80 --host=$ip" >> run.bat
cd ../pagoserver && echo "php artisan serve --port=80 --host=$ip" >> run.bat