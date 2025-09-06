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
```bash
# Запуск в режиме разработки
flutter run

# Или запуск в браузере (веб-версия)
flutter run -d chrome

# Горячая перезагрузка - нажмите 'r' в терминале
# Полная перезагрузка - нажмите 'R'
# Выход - нажмите 'q'
```

**5. Соберите APK для установки:**
```bash
# Debug версия (быстро, для тестирования)
flutter build apk --debug

# Release версия (медленно, для продакшена)
flutter build apk --release


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