# Cross-Platform Export Guide

## 📦 Экспорт игры для разных платформ

Milk Inside IDE поддерживает экспорт для всех основных платформ.

## 🖥️ Windows Export

### Способ 1: Через IDE (Рекомендуется)

1. Откройте IDE: `./ascii_engine_editor.exe`
2. Создайте вашу игру в редакторе
3. В Build & Export Panel кликните "Export for Windows"
4. Выберите папку для экспорта
5. IDE создаст:
   ```
   MyGame_Windows/
   ├── ascii_engine.exe      # Компилированный движок
   ├── assets/               # Все ваши файлы игры
   │   ├── *.lua
   │   ├── *.ttf
   │   └── scenes/
   └── README.txt
   ```

### Способ 2: Вручную

```bash
mkdir MyGame_Windows
copy build/Release/ascii_engine.exe MyGame_Windows/
xcopy assets MyGame_Windows/assets /E /I

# Распаковать и поделиться
```

### Зависимости

Пользователю нужно установить:
- Visual C++ Redistributable (для MSVC версии)
- SDL2.dll (если динамически линкована)

### Размер дистрибутива

- Без зависимостей: ~4-5 МБ
- С SDL2.dll: ~6-7 МБ

## 🐧 Linux Export

### Способ 1: Через IDE

1. В Build & Export Panel выберите "Export for Linux"
2. Выберите архитектуру (x64, x86)
3. IDE создаст:
   ```
   MyGame_Linux_x64.tar.gz
   ├── ascii_engine        # ELF исполняемый файл
   ├── assets/
   └── install.sh          # Скрипт установки (опционально)
   ```

### Способ 2: Вручную

```bash
# На Linux машине
mkdir MyGame_Linux
cp build/ascii_engine MyGame_Linux/
cp -r assets MyGame_Linux/

# Создать tar.gz
tar -czf MyGame_Linux_x64.tar.gz MyGame_Linux/
```

### Установка пользователем

```bash
tar -xzf MyGame_Linux_x64.tar.gz
cd MyGame_Linux
./ascii_engine

# Или установить системно
sudo install -m 755 ascii_engine /usr/local/bin/
```

### Зависимости

Пользователю нужны:
```bash
sudo apt-get install libsdl2-2.0 liblua5.4

# Или через Arch
pacman -S sdl2 lua
```

### Размер дистрибутива

- Без зависимостей: ~4-5 МБ
- С проверкой зависимостей: скрипт автоматически проверит

## 🍎 macOS Export

### Способ 1: Через IDE

1. В Build & Export Panel выберите "Export for macOS"
2. Выберите архитектуру (Intel, Apple Silicon, Universal)
3. IDE создаст:
   ```
   MyGame.app/
   ├── Contents/
   │   ├── MacOS/
   │   │   └── ascii_engine
   │   ├── Resources/
   │   │   ├── assets/
   │   │   └── Info.plist
   │   └── Frameworks/  (если needed)
   ```

### Способ 2: Вручную (Universal Binary)

```bash
# Скомпилировать для Intel
cmake .. -DCMAKE_OSX_ARCHITECTURES="x86_64"
cmake --build . --config Release

# Скомпилировать для Apple Silicon
cmake .. -DCMAKE_OSX_ARCHITECTURES="arm64"
cmake --build . --config Release

# Объединить
lipo -create ascii_engine_x86_64 ascii_engine_arm64 -output ascii_engine_universal

# Создать .app bundle
mkdir -p MyGame.app/Contents/MacOS
mkdir -p MyGame.app/Contents/Resources
cp ascii_engine_universal MyGame.app/Contents/MacOS/ascii_engine
cp -r assets MyGame.app/Contents/Resources/
chmod +x MyGame.app/Contents/MacOS/ascii_engine

# Создать Info.plist
cat > MyGame.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleName</key>
    <string>My Game</string>
    <key>CFBundleExecutable</key>
    <string>ascii_engine</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
</dict>
</plist>
EOF
```

### Подписание и нотаризация

```bash
# Подписать приложение (требует сертификат Apple Developer)
codesign -s - MyGame.app

# Заметить на Apple Servers (опционально, для распространения через App Store)
xcrun altool --notarize-app -f MyGame.zip -t osx -u "email@example.com" -p "@keychain:password"
```

### Размер дистрибутива

- Intel только: ~4-5 МБ
- Apple Silicon только: ~4-5 МБ
- Universal Binary: ~8-9 МБ

### Зависимости

Встроены в приложение или установлены через Homebrew:
```bash
brew install sdl2 lua
```

## 📱 Android Export (One-Click в IDE)

### Через IDE

1. Откройте Build & Export Panel в IDE
2. Введите:
   - Package Name: `com.mycompany.mygame`
   - App Name: `My Game`
   - Android SDK Path
   - Android NDK Path
3. Кликните "Export APK (One-Click)"
4. IDE создаст: `android/app/build/outputs/apk/debug/app-debug.apk`

### Распространение

**Debug APK (для тестирования):**
```bash
adb install -r app-debug.apk
```

**Release APK (для Google Play):**
```bash
# Подписать ключом
jarsigner -verbose -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore my-release-key.keystore \
  app-release.apk alias_name

# Оптимизировать
zipalign -v 4 app-release-unsigned.apk app-release.apk

# Загрузить в Google Play Console
```

### Размер APK

- Debug: ~5-6 МБ
- Release (оптимизированный): ~3-4 МБ

### Платформы поддержки

- armeabi-v7a (32-bit ARM)
- arm64-v8a (64-bit ARM) - рекомендуется
- x86 (для эмулятора)
- x86_64 (для эмулятора)

## 🎯 Полный процесс экспорта

### Из IDE (Рекомендуется)

```
1. Откройте IDE
   └─ ./ascii_engine_editor
   
2. Создайте сцену в Scene Designer
   
3. Напишите код в Code Editor
   
4. Протестируйте (Ctrl+E для Game Mode)
   
5. В Build & Export Panel выберите платформу:
   ├─ Export for Windows
   ├─ Export for Linux
   ├─ Export for macOS
   ├─ Export APK (Android)
   └─ Export to All Platforms
   
6. IDE выполнит:
   ├─ Компиляцию
   ├─ Упаковку assets
   ├─ Оптимизацию размера
   └─ Создание дистрибутива
   
7. Скачайте готовый файл
```

### Вручную (для опытных разработчиков)

```bash
# 1. Собрать основной движок
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .

# 2. Переместить исполняемый файл и assets
mkdir ../dist
cp ascii_engine ../dist/
cp -r ../assets ../dist/

# 3. Создать архив
cd ..
zip -r MyGame.zip dist/

# 4. Для Android - использовать gradlew
cd android
./gradlew assembleDebug
# APK в app/build/outputs/apk/debug/
```

## 📋 Контрольный список перед экспортом

- [ ] Все сцены сохранены (File > Save Scene)
- [ ] Все Lua-скрипты проверены (Applied in Editor)
- [ ] Музыка и SFX экспортированы
- [ ] Шрифты (TTF) добавлены в assets/
- [ ] Assets сжаты/оптимизированы
- [ ] Версия приложения обновлена
- [ ] Package name корректен (для Android)
- [ ] Все ресурсы включены в архив

## 🚨 Решение проблем при экспорте

### "Assets not found"

Убедитесь, что папка `assets/` находится рядом с исполняемым файлом:
```
MyGame/
├── ascii_engine       # или .exe
├── assets/            # ЗДЕСЬ!
│   ├── main.lua
│   └── scenes/
```

### "SDL2 library not found"

Windows:
- Установить SDL2 через vcpkg или скачать DLL
- Поместить DLL рядом с .exe

Linux:
```bash
sudo apt-get install libsdl2-2.0
```

macOS:
```bash
brew install sdl2
```

### APK не устанавливается

```bash
# Проверить подпись
keytool -list -v -keystore app-debug.keystore

# Переустановить
adb uninstall com.example.game
adb install app-debug.apk
```

## 📊 Размеры дистрибутивов

| Платформа | Размер | Зависимости |
|-----------|--------|------------|
| Windows | 4-7 МБ | SDL2, Lua |
| Linux | 4-5 МБ | libsdl2, lua |
| macOS | 4-9 МБ | SDL2, lua |
| Android | 3-6 МБ | NDK libraries |

**Итого: все платформы < 10 МБ с оптимизацией**

## 🔐 Безопасность при распространении

### Для Windows

- Подписать исполняемый файл сертификатом
- Включить антивирус сканирование

### Для macOS

- Code signing (требует Apple Developer Account)
- Notarization (рекомендуется для App Store)

### Для Android

- Использовать release keystore для подписания
- Включить ProGuard обфускацию
- Компресс ресурсы в APK

---

**Игра готова к экспорту и распространению на любой платформе!**

Для более подробных инструкций см. конкретные разделы выше.
