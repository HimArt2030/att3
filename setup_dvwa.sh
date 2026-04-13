#!/bin/bash
# سكريبت تثبيت DVWA على ARM64

# إيقاف أي container قديم
docker rm -f dvwa dvwa-db 2>/dev/null

# تشغيل MySQL أولاً
docker run -d \
  --name dvwa-db \
  --platform linux/arm64 \
  -e MYSQL_ROOT_PASSWORD=rootpass \
  -e MYSQL_DATABASE=dvwa \
  -e MYSQL_USER=dvwa \
  -e MYSQL_PASSWORD=p@ssw0rd \
  mysql:8.0

echo "[*] انتظر 30 ثانية لبدء MySQL..."
sleep 30

# تشغيل DVWA
docker run -d \
  --name dvwa \
  --platform linux/arm64 \
  --link dvwa-db:db \
  -p 8888:80 \
  -e DB_SERVER=db \
  -e DB_PORT=3306 \
  -e DB_DATABASE=dvwa \
  -e DB_USERNAME=dvwa \
  -e DB_PASSWORD=p@ssw0rd \
  ghcr.io/digininja/dvwa:latest

echo "[*] انتظر 10 ثوانٍ لبدء DVWA..."
sleep 10

docker ps | grep -E "dvwa|db"
echo ""
echo "✓ افتح المتصفح على: http://localhost:8888/setup.php"
echo "✓ اضغط: Create / Reset Database"
echo "✓ ثم سجّل دخول: admin / password"
