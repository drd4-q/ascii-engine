# Android SDK/NDK Configuration Guide

## 📋 Требования

- Android SDK API 21+ (для целевой платформы)
- Android NDK r21 или выше
- Gradle 6.0+
- Java Development Kit (JDK) 8+

## 🔧 Установка

### Windows

#### 1. Android Studio (рекомендуется)

1. Скачать [Android Studio](https://developer.android.com/studio)
2. Установить Android Studio
3. При первом запуске выбрать "Standard Setup"
4. Будут установлены SDK tools и NDK

#### 2. Command Line Tools Only

```powershell
# Скачать из https://developer.android.com/studio/command-line-tools-only
# Распаковать в папку (например, C:\Android\cmdline-tools)

# Переменные окружения (добавить в System Environment Variables)
ANDROID_SDK_ROOT=C:\Users\<YourUsername>\AppData\Local\Android\Sdk
ANDROID_NDK_ROOT=C:\Users\<YourUsername>\AppData\Local\Android\Sdk\ndk\21.4.7075529
```

#### 3. Установить компоненты SDK

```powershell
# Открыть SDK Manager
$ANDROID_SDK\tools\bin\sdkmanager.bat --list

# Установить нужные версии
$ANDROID_SDK\tools\bin\sdkmanager.bat "platforms;android-33" "build-tools;33.0.2" "ndk;21.4.7075529"
```

### Linux

```bash
# Ubuntu/Debian
sudo apt-get install android-sdk android-sdk-build-tools

# Или вручную:
# 1. Скачать Android Studio с https://developer.android.com/studio
# 2. Распаковать и запустить

# Переменные окружения добавить в ~/.bashrc
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/21.4.7075529
export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools
```

### macOS

```bash
# Homebrew (рекомендуется)
brew install --cask android-studio
brew install android-sdk android-ndk

# Или вручную:
# 1. Скачать Android Studio
# 2. Распаковать в ~/Library/Android/sdk

# Переменные окружения в ~/.zshrc или ~/.bash_profile
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/21.4.7075529
export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools
```

## 🛠️ Конфигурирование IDE Editor

### 1. Откройте IDE

```bash
./ascii_engine_editor
```

### 2. Перейдите в Build & Export Panel

В нижней части экрана найдите "Build & Export" секцию.

### 3. Введите пути

| Поле | Значение | Пример |
|------|----------|---------|
| Android SDK Path | Путь к SDK | `C:\Users\User\AppData\Local\Android\Sdk` |
| Android NDK Path | Путь к NDK | `C:\Users\User\AppData\Local\Android\Sdk\ndk\21.4.7075529` |
| Package Name | Название приложения | `com.mycompany.mygame` |
| App Name | Отображаемое имя | `My Game` |

### 4. Нажмите "Configure Build"

IDE сохранит конфиги.

### 5. Кликните "Export APK (One-Click)"

IDE выполнит:
- Генерацию AndroidManifest.xml с вашим package name
- Копирование assets
- Вызов Gradle assembleDebug
- Создание APK

## 📍 Поиск путей SDK/NDK

### Windows

```powershell
# Проверить установки через Android Studio Settings:
# File > Settings > Appearance & Behavior > System Settings > Android SDK

# Или найти вручную:
Get-ChildItem "C:\Users\$env:USERNAME\AppData\Local\Android\Sdk"

# Результат примерно:
# Directory: C:\Users\User\AppData\Local\Android\Sdk
#
#     Mode                 LastWriteTime         Length Name
#     ----                 ------------- ----------  ----
#     d-----            01.01.2024     build-tools
#     d-----            01.01.2024     emulator
#     d-----            01.01.2024     ndk
#     d-----            01.01.2024     platforms
#     d-----            01.01.2024     tools
```

Тогда пути:
- SDK: `C:\Users\User\AppData\Local\Android\Sdk`
- NDK: `C:\Users\User\AppData\Local\Android\Sdk\ndk\21.4.7075529`

### Linux

```bash
# Проверить установки
ls -la ~/Android/Sdk/
ls -la ~/Android/Sdk/ndk/

# Результат:
# build-tools/
# ndk/
#   ├─ 21.4.7075529/
#   ├─ 23.2.8568313/
#   └─ ...
# platforms/
# tools/
```

Тогда пути:
- SDK: `/home/user/Android/Sdk`
- NDK: `/home/user/Android/Sdk/ndk/21.4.7075529`

### macOS

```bash
# Проверить установки
ls -la ~/Library/Android/sdk/
ls -la ~/Library/Android/sdk/ndk/

# Результат:
# build-tools/
# ndk/
#   ├─ 21.4.7075529/
#   └─ ...
# platforms/
```

Тогда пути:
- SDK: `$HOME/Library/Android/sdk`
- NDK: `$HOME/Library/Android/sdk/ndk/21.4.7075529`

## ✅ Проверка установки

### Через IDE

В IDE нажмите "Export APK" - если всё настроено корректно, сборка начнётся.

### Через команду

```bash
# Windows
$ANDROID_SDK\tools\bin\sdkmanager.bat --list_installed

# Linux/macOS
$ANDROID_SDK/tools/bin/sdkmanager --list_installed

# Результат должен содержать:
# build-tools;33.0.2
# platforms;android-33
# ndk;21.4.7075529
```

## 🔐 Переменные окружения

### Windows (PowerShell)

Добавить в профиль (`$PROFILE`):

```powershell
$env:ANDROID_SDK_ROOT = "C:\Users\<YourUsername>\AppData\Local\Android\Sdk"
$env:ANDROID_NDK_ROOT = "C:\Users\<YourUsername>\AppData\Local\Android\Sdk\ndk\21.4.7075529"
```

Или через System Environment Variables (GUI):
1. Win+X > Settings
2. System > About > Advanced system settings
3. Environment Variables
4. Добавить `ANDROID_SDK_ROOT` и `ANDROID_NDK_ROOT`

### Linux/macOS

Добавить в `~/.bashrc` или `~/.zshrc`:

```bash
export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export ANDROID_NDK_ROOT=$ANDROID_SDK_ROOT/ndk/21.4.7075529
export PATH=$PATH:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools
```

Затем:
```bash
source ~/.bashrc
# или
source ~/.zshrc
```

## 🚨 Решение проблем

### Ошибка: "Android SDK not found"

**Решение:**
1. Убедитесь, что Android SDK установлен
2. Проверьте правильность пути
3. Перезагрузите IDE
4. Попробуйте явно указать пути в Build & Export Panel

### Ошибка: "NDK r21 or higher required"

**Решение:**
1. Проверьте версию NDK: `ndk-build --version`
2. Скачайте NDK r21+ из [Android Developer](https://developer.android.com/ndk/downloads)
3. Распаковайте в папку sdk/ndk/
4. Обновите путь `ANDROID_NDK_ROOT`

### Ошибка: "Gradle not found"

**Решение:**
IDE использует gradle wrapper из Android проекта.
```bash
cd ascii_engine/android
./gradlew wrapper --gradle-version 7.0
```

### APK не строится

**Решение:**
1. Проверьте логи в Build Logs панели IDE
2. Убедитесь, что все пути указаны правильно
3. Проверьте интернет (нужен для скачивания зависимостей)
4. Попробуйте вручную:
```bash
cd android
./gradlew assembleDebug
```

## 📱 Создание project.properties

В папке `android/` создать или обновить `local.properties`:

```properties
# Windows
sdk.dir=C:\\Users\\YourName\\AppData\\Local\\Android\\Sdk
ndk.dir=C:\\Users\\YourName\\AppData\\Local\\Android\\Sdk\\ndk\\21.4.7075529

# Linux/macOS
sdk.dir=/home/user/Android/Sdk
ndk.dir=/home/user/Android/Sdk/ndk/21.4.7075529
```

## 🎯 Package Name Rules

- Должен быть уникален в Google Play
- Обратный порядок доменов (например: `com.mycompany.mygame`)
- Только буквы, цифры, точки
- Минимум 2 сегмента (точки)

Примеры:
```
✅ com.example.mygame
✅ org.myorg.game
❌ my.game (слишком коротко)
❌ my-game (недопустимые символы)
❌ my_game (недопустимые символы)
```

## 📦 APK Output

После успешной сборки:

```
ascii_engine/android/
└── app/build/outputs/apk/debug/
    └── app-debug.apk
```

### Установить на устройство

```bash
adb install -r app/build/outputs/apk/debug/app-debug.apk
```

### Запустить на устройстве

```bash
adb shell am start -n com.example.mygame/.MainActivity
```

## 🔗 Полезные ссылки

- [Android SDK Download](https://developer.android.com/studio)
- [NDK Downloads](https://developer.android.com/ndk/downloads)
- [Android Documentation](https://developer.android.com/docs)
- [Gradle Plugin for Android](https://developer.android.com/studio/releases/gradle-plugin)

---

**Готово! Теперь IDE может собирать APK с одного клика.**

Для экспорта для Windows/Linux см. BUILD_EXPORT.md
