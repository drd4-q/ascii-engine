# Milk Inside Lite Engine - 2D Game Engine

Легковесный кроссплатформенный 2D игровой движок на C++17, вдохновленный визуальным стилем игры "Milk inside of a bag...".

## 🎮 Особенности

- **Низкое разрешение**: 320x240 с масштабированием 2x (ретро-эстетика)
- **Дизеринг и ограниченная палитра**: 8-цветная палитра с алгоритмом Bayer dithering
- **Lua scripting**: Встроенный интерпретатор Lua для логики игр (похоже на Godot nodes)
- **SDL2**: Кроссплатформенная графика и ввод
- **Минимальный размер**: < 5 МБ (без зависимостей)
- **CMake**: Стандартная сборка для всех платформ

## 📋 Требования

### Windows
- MSVC 2019+ или MinGW с C++17 поддержкой
- CMake 3.10+
- SDL2 library
- Lua 5.4

### Linux
- GCC 9+ или Clang 10+ (C++17)
- CMake 3.10+
- SDL2 dev package: `libsdl2-dev`
- Lua dev package: `liblua5.4-dev`

### macOS
- Xcode Command Line Tools
- CMake 3.10+
- Homebrew (для зависимостей)

### Android
- Android NDK r21+
- Android SDK API 21+
- CMake 3.10+

## 🔧 Установка зависимостей

### Windows (vcpkg)
```bash
vcpkg install sdl2:x64-windows lua:x64-windows
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install libsdl2-dev liblua5.4-dev cmake
```

### macOS (Homebrew)
```bash
brew install sdl2 lua cmake
```

## 🏗️ Сборка

### Windows (MSVC)
```bash
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019"
cmake --build . --config Release
cd ..
./build/Release/ascii_engine.exe
```

### Windows (MinGW)
```bash
mkdir build
cd build
cmake .. -G "MinGW Makefiles"
cmake --build .
./ascii_engine.exe
```

### Linux
```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
./ascii_engine
```

### macOS
```bash
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build .
./ascii_engine
```

### Android (NDK)
```bash
# Поместить SDL2 и Lua исходники в android/jni/prebuilt/
cd android
ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=jni/Application.mk
# Использовать с Android Studio проектом
```

## 📁 Структура проекта

```
ascii_engine/
├── CMakeLists.txt          # Конфигурация сборки
├── include/
│   ├── Engine.hpp          # Ядро движка
│   ├── Renderer.hpp        # Система рендеринга
│   └── LuaAPI.hpp          # Lua интеграция
├── src/
│   ├── main.cpp            # Точка входа
│   ├── Engine.cpp
│   ├── Renderer.cpp
│   └── LuaAPI.cpp
├── assets/
│   └── main.lua            # Пример игрового скрипта
└── android/
    ├── jni/
    │   ├── Android.mk
    │   └── Application.mk
    └── AndroidManifest.xml
```

## 📝 Написание игры на Lua

### Структура скрипта

```lua
-- Вызывается один раз при инициализации
function _ready()
    Engine.log("Game started!")
    player = Engine.createObject("player", 160, 120)
end

-- Вызывается каждый кадр (delta - время с последнего кадра)
function _process(delta)
    -- Логика обновления
    if Engine.isKeyPressed("left") then
        Engine.setObjectProperty(player, "vx", -100)
    end
end
```

### Lua API

#### Создание и управление объектами
```lua
-- Создать объект
obj = Engine.createObject("name", x, y)

-- Удалить объект
Engine.destroyObject(obj_id)

-- Получить объект по ID
obj = Engine.getObject(obj_id)

-- Установить свойство объекта
Engine.setObjectProperty(obj, "x", 100)
Engine.setObjectProperty(obj, "vx", 50)

-- Получить свойство
x = Engine.getObjectProperty(obj, "x")
```

#### Рисование
```lua
-- Прямоугольник (x, y, width, height, r, g, b)
Engine.drawRect(10, 10, 20, 20, 255, 0, 0)

-- Круг (x, y, radius, r, g, b)
Engine.drawCircle(50, 50, 15, 0, 255, 0)

-- Текст (x, y, text, r, g, b)
Engine.drawText(5, 5, "Score: 100", 255, 255, 255)
```

#### Ввод
```lua
-- Проверить нажата ли клавиша
if Engine.isKeyPressed("left") then end
if Engine.isKeyPressed("right") then end
if Engine.isKeyPressed("up") then end
if Engine.isKeyPressed("down") then end
if Engine.isKeyPressed("space") then end
if Engine.isKeyPressed("enter") then end
```

#### Утилиты
```lua
-- Логирование
Engine.log("Debug message")
```

## 🎨 Палитра цветов

Палитра по умолчанию (8 цветов):
```
0: Чёрный (0, 0, 0)
1: Белый (255, 255, 255)
2: Пурпурный (150, 100, 150)
3: Светло-голубой (100, 200, 255)
4: Оранжевый (255, 150, 100)
5: Светло-зелёный (150, 255, 150)
6: Коричневый (200, 150, 100)
7: Серый (100, 100, 100)
```

## 🔍 Характеристики

- **Разрешение**: 320x240 пиксел (отображается как 640x480 на экране)
- **Цвета**: 32-bit ARGB с дизерингом до 8-цветной палитры
- **Производительность**: Vsync включен (60 FPS)
- **Размер бинарника**: ~3-4 МБ (без зависимостей)

## 🐛 Отладка

Создайте в папке с исполняемым файлом папку `assets/` с вашим `main.lua`.

Логирование выводится в консоль:
```
[LUA] Game started!
[Engine] Object created: player (ID: 1)
```

## 📄 Лицензия

MIT License - используйте свободно в коммерческих и личных проектах.

## 🚀 Дальнейшие расширения

- [ ] Спрайты и анимация
- [ ] Коллизии AABB
- [ ] Звуки (SDL_mixer)
- [ ] Уровни и сцены
- [ ] Частицы
- [ ] UI система

---
**Разработано как минималистичный 2D движок для ретро-игр.**
