# IDE & Editor Guide

## Обзор

Milk Inside Lite Engine поставляется с встроенной IDE для полного разработки игр. IDE включает:

- **Scene Designer** - визуальное редактирование уровней
- **Property Inspector** - редактирование параметров объектов
- **Code Editor** - встроенный редактор Lua с подсветкой синтаксиса
- **8-bit Audio Tracker** - создание музыки и SFX
- **Tilemap Editor** - редактирование плиток
- **Android Builder** - One-Click экспорт APK

## 🚀 Запуск IDE

### Из исходников (CMake)

```bash
# Windows
mkdir build
cd build
cmake .. -G "Visual Studio 16 2019" -DBUILD_EDITOR=ON
cmake --build . --config Release
./Release/ascii_engine_editor.exe

# Linux
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_EDITOR=ON
cmake --build .
./ascii_engine_editor

# macOS
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_EDITOR=ON
cmake --build .
./ascii_engine_editor
```

### Параметры CMake

```bash
# Только игра (без редактора)
cmake .. -DBUILD_EDITOR=OFF

# Только редактор
cmake .. -DBUILD_GAME_ONLY=ON -DBUILD_EDITOR=ON
```

## 🎨 Scene Designer Panel

### Основные операции

1. **Создание объектов**
   - Кликнуть "+ Add Object"
   - Выбрать тип: Sprite, Tilemap, Empty
   - Объект появится в Scene Hierarchy

2. **Выбор объекта**
   - Кликнуть на объект в дереве
   - Объект подсвечивается зелёным
   - Его параметры показываются в Property Inspector

3. **Drag & Drop**
   - Перетащить объект в дереве для переупорядочивания
   - Объекты организуются иерархически

4. **Удаление**
   - Кликнуть правой кнопкой на объект
   - Выбрать "Delete"

## 🔧 Property Inspector

### Редактирование свойств

Для выбранного объекта доступны:

| Свойство | Тип | Описание |
|----------|-----|---------|
| Name | String | Имя объекта |
| Type | String | Тип (sprite, tilemap, etc) |
| X, Y | Float | Позиция в пиксел |
| Width, Height | Float | Размер |
| Scale X/Y | Float | Масштаб (0.1 - 10) |
| Color | RGB | Цвет отрисовки |
| Lua Script | Text | Код скрипта объекта |

### Изменение значений

- Кликнуть на поле для редактирования
- Введите значение или используйте слайдер
- Изменения применяются в реальном времени в Preview

## 💻 Code Editor

### Особенности

- **Синтаксис Lua** с подсветкой
- **Hot Reload** - нажать "Apply Changes" для немедленного обновления
- **Автодополнение** (для встроенных функций)
- **Линии номеров**

### Пример

```lua
-- Скрипт компонента игрока
function _ready()
    Engine.log("Player initialized")
end

function _process(delta)
    if Engine.isKeyPressed("left") then
        local x = Engine.getObjectProperty(this, "x")
        Engine.setObjectProperty(this, "x", x - 100 * delta)
    end
end
```

### Hot Reload

1. Отредактируйте код в Code Editor
2. Кликнуть "Apply Changes (Hot Reload)"
3. Скрипт немедленно перезагружается
4. Изменения видны в Preview панели

## 🎵 Audio Tracker

### 8-bit Sound Synthesizer

Встроенный синтезатор для создания музыки в ретро-стиле.

### Генерация звука

1. **Выбрать волновую форму:**
   - Square Wave (чистый звук)
   - Sine Wave (мягкий звук)
   - Triangle Wave (тёплый звук)
   - Noise (шум)

2. **Установить параметры:**
   - Frequency (20-4000 Hz)
   - Duration (0.1-5 сек)
   - Tempo (60-240 BPM)

3. **Нажать "Play Note"** для проверки

### ADSR Envelope

Каждая нота имеет огибающую (ADSR):

- **Attack** - время нарастания звука
- **Decay** - время падения до sustain level
- **Sustain** - уровень поддержания
- **Release** - время затухания после остановки

## 🗂️ Tilemap Editor

### Редактирование плиток

1. **Установить размер плитки:**
   - Tile Width (8-32 px)
   - Tile Height (8-32 px)

2. **Выбрать плитку из палитры** (0-7)

3. **Кликнуть на сетку** для расстановки плиток

4. **Сохранить уровень** в меню File > Save Scene

### Параметры

```
Grid Size: 320 / Tile Width × 240 / Tile Height
Palette: 8 доступных плиток

Например:
- 16x16 tiles: 20×15 = 300 плиток
- 8x8 tiles: 40×30 = 1200 плиток
```

## 📦 Build & Export Panel

### One-Click Export APK

#### Подготовка

1. **Ввести Package Name**
   ```
   com.mycompany.mygame
   ```

2. **Ввести App Name**
   ```
   My Awesome Game
   ```

3. **Указать пути SDK/NDK**
   ```
   Android SDK: C:\Android\sdk
   Android NDK: C:\Android\ndk\r21
   ```

#### Процесс экспорта

1. Кликнуть "Configure Build"
2. Кликнуть "Export APK (One-Click)"
3. IDE выполнит:
   - ✅ Сгенерирует AndroidManifest.xml
   - ✅ Скопирует assets в android/app/src/main/assets/
   - ✅ Запустит Gradle: `./gradlew assembleDebug`
   - ✅ Создаст APK

4. APK будет в: `app/build/outputs/apk/debug/app-debug.apk`

### Логирование

Все логи сборки отображаются в панели "Build Logs".

Примеры:
```
Gradle build succeeded: ...
AndroidManifest.xml generated successfully
Assets packaged successfully
```

### Установка на устройство

```bash
adb install -r build/outputs/apk/debug/app-debug.apk
```

## ⌨️ Горячие клавиши

| Комбинация | Действие |
|-----------|----------|
| Ctrl+S | Сохранить сцену |
| Ctrl+N | Новая сцена |
| Ctrl+E | Переключиться в Game Mode |
| ESC | Выход |
| Ctrl+Z | Undo |
| Ctrl+Y | Redo |
| F5 | Hot Reload |

## 📁 Структура проекта в IDE

```
Project Root/
├── assets/
│   ├── *.lua (Lua скрипты)
│   ├── *.ttf (Шрифты)
│   └── scenes/ (Сохранённые сцены)
├── src/ (C++ код)
├── editor/ (Компоненты IDE)
├── build_system/ (Android builder)
└── android/ (Android проект)
```

## 🎮 Переключение между режимами

### Editor Mode → Game Mode

Нажать **Ctrl+E** в редакторе для запуска игры.

Игра будет использовать текущую загруженную сцену.

### Game Mode → Editor Mode

Выход из игры (ESC) вернёт вас в IDE.

## 🔍 Preview Panel

Справа от Code Editor:

- Показывает текущую сцену
- Обновляется в реальном времени
- Показывает позиции объектов
- Отображает выбранный объект выделенным

## 💾 Сохранение и загрузка

### Сохранить сцену

```
File > Save Scene
Скцена сохраняется как JSON в assets/scenes/
```

### Загрузить сцену

```
File > Open Scene
Выбрать сцену из списка
```

## 🐛 Отладка

### Логирование из Lua

```lua
Engine.log("Debug message")
```

Логи выводятся в консоль IDE.

### Точки останова (Coming Soon)

В будущей версии:
- Установка breakpoints в коде
- Пошаговое выполнение (step over/into)
- Инспекция переменных

## 📊 Performance Hints

### Оптимизация сцены

- Избегайте слишком больших объектов
- Используйте Tilemap для больших площадей
- Максимум 1000 объектов на сцену

### Audio performance

- 8-bit синтез требует ~1% CPU
- Максимум 16 одновременно играющих нот
- Sample rate: 44100 Hz (стандарт)

---

**IDE готова к использованию! Начните разрабатывать вашу игру.**

Для вопросов см. README.md или ARCHITECTURE.md
