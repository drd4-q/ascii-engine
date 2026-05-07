# Android Integration Guide

## Подготовка среды

### 1. Установка NDK

Скачайте Android NDK версии r21 или выше:
```bash
# macOS с Homebrew
brew install android-ndk

# Или вручную
# https://developer.android.com/ndk/downloads
```

### 2. Установка зависимостей

Перед сборкой для Android, соберите SDL2 и Lua как shared libraries:

```bash
# Создать директорию для prebuilt библиотек
mkdir -p android/jni/prebuilt/{armeabi-v7a,arm64-v8a,x86,x86_64}

# Скачать SDL2 для Android
# https://github.com/libsdl-org/SDL/releases
# Распаковать в android/jni/SDL2

# Скачать Lua исходники
# http://www.lua.org/download.html
# Скомпилировать как shared library для каждой архитектуры
```

## Сборка для Android

### Вариант 1: Через NDK Build

```bash
cd ascii_engine/android
export ANDROID_NDK=/path/to/android-ndk-r21
$ANDROID_NDK/ndk-build \
    NDK_PROJECT_PATH=. \
    NDK_APPLICATION_MK=jni/Application.mk \
    APP_PLATFORM=android-21

# Результат будет в libs/
```

### Вариант 2: Через CMake (рекомендуется)

```bash
mkdir build-android
cd build-android

cmake .. \
    -DCMAKE_SYSTEM_NAME=Android \
    -DCMAKE_SYSTEM_VERSION=21 \
    -DCMAKE_ANDROID_ARCH_ABI=arm64-v8a \
    -DCMAKE_ANDROID_NDK=/path/to/android-ndk-r21 \
    -DCMAKE_BUILD_TYPE=Release

cmake --build .
```

## Интеграция с Android Studio

### 1. Создать проект

```bash
# Использовать native activity template
# File > New > New Project > Native C++
```

### 2. Скопировать исходники

```bash
# cp ascii_engine/src/* app/src/main/cpp/
# cp ascii_engine/include/* app/src/main/cpp/include/
# cp -r ascii_engine/assets app/src/main/assets/
```

### 3. Обновить CMakeLists.txt

В `app/build.gradle`:

```gradle
android {
    ...
    externalNativeBuild {
        cmake {
            path 'CMakeLists.txt'
        }
    }
}
```

### 4. JNI Layer (SDLActivity)

Основной класс уже предоставляется SDL2 из `org.libsdl.app.SDLActivity`.

При наличии пользовательской логики создайте:

```java
// MainActivity.java
package com.example.asciiengine;

import org.libsdl.app.SDLActivity;

public class MainActivity extends SDLActivity {
    // SDL автоматически загружает нашу shared library
    static {
        System.loadLibrary("ascii_engine");
    }
}
```

### 5. Файлы конфигурации

**AndroidManifest.xml** уже предоставлен в `android/AndroidManifest.xml`.

**Application.mk** указывает параметры сборки:
```makefile
APP_PLATFORM := android-21          # Минимальный SDK
APP_ABI := armeabi-v7a arm64-v8a    # Поддерживаемые архитектуры
APP_STL := c++_shared               # C++ standard library
APP_CPPFLAGS := -std=c++17 -Os      # Флаги оптимизации
```

## Запуск на эмуляторе/устройстве

```bash
# Установить приложение
adb install -r app/build/outputs/apk/debug/app-debug.apk

# Запустить
adb shell am start -n com.example.asciiengine/.MainActivity

# Просмотреть логи
adb logcat | grep "AsciiEngine"
```

## Оптимизация для Android

### Размер

- Используется `-Os` для минимизации
- Убрана отладочная информация: `strip` бинарик
- Lua компилируется как .so shared library

### Производительность

- Используется `c++_shared` STL (меньше размер, чем `c++_static`)
- SDL2 обрабатывает все системные вызовы
- Lua JIT может быть интегрирован для лучшей производительности

### Экран

- Ориентация: портретная (можно изменить в AndroidManifest.xml)
- Разрешение: 320x240 логических пиксел (масштабируется на физический размер)
- Touch input: автоматически перенаправляется в SDL_MOUSEMOTION события

## Решение проблем

### Ошибка: "Failed to load shared library"

```bash
# Убедиться, что библиотека собрана для правильной архитектуры
file build/libs/arm64-v8a/libascii_engine.so
# Должно показать: ELF 64-bit LSB shared object, ARM aarch64
```

### Ошибка: "SDL2 not found"

```bash
# Убедиться, что SDL2 скомпилирован как shared library
# И находится в android/jni/prebuilt/$(TARGET_ARCH_ABI)/
```

### Черный экран при запуске

- Убедиться, что `assets/main.lua` на устройстве в `/data/data/com.example.asciiengine/assets/`
- Проверить логи: `adb logcat`

## Размеры бинарников (примерно)

| Архитектура | Размер |
|-------------|--------|
| armeabi-v7a | 2.5 МБ |
| arm64-v8a   | 3.2 МБ |
| x86         | 2.8 МБ |
| x86_64      | 3.5 МБ |

Total APK (с ресурсами): 4-5 МБ

---

Для подробнее о Android NDK: https://developer.android.com/ndk
