#!/bin/bash
# Запуск приложения с локальным бекендом

echo "🚀 Запуск с локальным бекендом (http://127.0.0.1:8000)..."
flutter run --dart-define=BACKEND_URL=http://127.0.0.1:8000
