## �📱 Установка

#### 🚀 Быстрый старт (с нуля)

**1. Установите Flutter:**

<details>
<summary><strong>📱 macOS</strong></summary>

```bash
# Установите Homebrew (если еще не установлен)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Установите Flutter
brew install --cask flutter

# Проверьте установку
flutter doctor
```
</details>

<details>
<summary><strong>🪟 Windows</strong></summary>

1. Скачайте Flutter SDK: https://flutter.dev/docs/get-started/install/windows
2. Распакуйте в `C:\flutter`
3. Добавьте `C:\flutter\bin` в PATH:
   - **Панель управления** → **Система** → **Дополнительные параметры** → **Переменные среды**
   - Добавьте `C:\flutter\bin` в PATH
4. Перезапустите командную строку
5. Проверьте: `flutter doctor`
</details>

<details>
<summary><strong>🐧 Linux</strong></summary>

```bash
# Скачайте Flutter
cd ~/
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.35.3-stable.tar.xz

# Распакуйте
tar xf flutter_linux_3.35.3-stable.tar.xz

# Добавьте в PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Проверьте
flutter doctor
```
</details>

#### 🔧 Работа с проектом

**1. Клонируйте репозиторий:**
```bash
# Если у вас есть Git
git clone https://github.com/2n4a/calculator.git
cd calculator

# Если Git нет - скачайте ZIP:
# https://github.com/2n4a/calculator/archive/refs/heads/main.zip
# Распакуйте и откройте папку в терминале
```

**2. Установите зависимости:**
```bash
flutter pub get
```

**3. Подключите устройство или эмулятор:**
```bash
# Проверьте доступные устройства
flutter devices

# Если ничего нет - создайте эмулятор:
flutter emulators --create

# Или подключите Android телефон с включенной отладкой USB
```

**4. Запустите приложение:**

<details>
<summary><strong>🏠 Локальная разработка (по умолчанию)</strong></summary>

```bash
# Обычный запуск с локальным бекендом (127.0.0.1:8000)
flutter run

# Или используйте готовый скрипт
./scripts/run-local.sh
```
</details>

<details>
<summary><strong>🌐 С кастомным бекендом</strong></summary>

```bash
# Указать адрес бекенда через параметр
flutter run --dart-define=BACKEND_URL=https://your-backend.com

# Или использовать скрипт для продакшена
./scripts/run-production.sh https://your-backend.com

# Примеры разных бекендов:
flutter run --dart-define=BACKEND_URL=http://192.168.1.100:8000  # Локальная сеть
flutter run --dart-define=BACKEND_URL=https://api.myapp.com      # Продакшн
flutter run --dart-define=BACKEND_URL=http://localhost:3000      # Другой порт
```
</details>

<details>
<summary><strong>💡 Дополнительные параметры запуска</strong></summary>

```bash
# Запуск в браузере (веб-версия)
flutter run -d chrome --dart-define=BACKEND_URL=https://api.myapp.com

# Горячая перезагрузка - нажмите 'r' в терминале
# Полная перезагрузка - нажмите 'R'  
# Выход - нажмите 'q'
```
</details>

**5. Соберите APK для установки:**
```bash
# Debug версия (быстро, для тестирования)
flutter build apk --debug

# Release версия (медленно, для продакшена)
flutter build apk --release
```

## ⚙️ Конфигурация бекенда

Приложение поддерживает настройку адреса бекенда через переменные окружения:

### 🛠️ Переменные окружения

- **`BACKEND_URL`** - адрес API сервера
  - **По умолчанию:** `http://127.0.0.1:8000`
  - **Примеры:** 
    - `http://localhost:3000`
    - `http://192.168.1.100:8000` 
    - `https://api.myapp.com`

### 📝 Примеры использования

```bash
# Локальная разработка
flutter run

# Продакшн сервер  
flutter run --dart-define=BACKEND_URL=https://api.myapp.com

# Локальная сеть
flutter run --dart-define=BACKEND_URL=http://192.168.1.100:8000

# Docker контейнер
flutter run --dart-define=BACKEND_URL=http://host.docker.internal:8000
```

### 🚀 Готовые скрипты

```bash
# Локальная разработка
./scripts/run-local.sh

# Продакшн (укажите свой URL)
./scripts/run-production.sh https://your-backend.com
```


#### 📚 Полезные команды

```bash
# Проверка состояния окружения
flutter doctor -v

# Обновление Flutter
flutter upgrade

# Очистка кэша (если что-то сломалось)
flutter clean && flutter pub get

# Анализ кода
flutter analyze

# Запуск тестов
flutter test

# Список доступных устройств
flutter devices

# Список эмуляторов
flutter emulators
```