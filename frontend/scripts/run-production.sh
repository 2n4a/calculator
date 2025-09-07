#!/bin/bash
# Запуск приложения с продакшн бекендом

if [ -z "$1" ]; then
  echo "❌ Укажите адрес продакшн сервера!"
  echo "Использование: ./run-production.sh https://your-backend.com"
  exit 1
fi

BACKEND_URL=$1
echo "🚀 Запуск с продакшн бекендом ($BACKEND_URL)..."
flutter run --dart-define=BACKEND_URL=$BACKEND_URL
