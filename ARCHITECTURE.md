# Architecture Documentation

## Обзор системы

```
┌─────────────────────────────────────────────┐
│          SDL Event Loop (main.cpp)          │
├─────────────────────────────────────────────┤
│  handleEvents() → update(delta) → render()  │
├─────────────────────────────────────────────┤
│         Engine (Core Game Manager)          │
├───────────────────┬─────────────────────────┤
│  Lua Interpreter  │   Renderer System      │
│  (LuaAPI)         │   (SDL + Dithering)    │
├───────────────────┴─────────────────────────┤
│    GameObject Collection (std::unordered_map)│
└─────────────────────────────────────────────┘
```

## Компоненты

### 1. Engine (src/Engine.cpp)

**Ответственность:**
- Управление жизненным циклом приложения
- Хранение всех игровых объектов
- Координация между Renderer и Lua

**Ключевые методы:**
```cpp
bool initialize(int width, int height);  // Инициализация SDL + Lua
void update(float deltaTime);             // Обновить логику (через Lua)
void render();                            // Рендеринг объектов
GameObject* createObject(...);            // Создать новый объект
```

**Жизненный цикл:**
1. `SDL_Init()` - инициализация видео/событий
2. Создание Renderer (SDL window, texture)
3. Создание Lua state и загрузка main.lua
4. Вызов `_ready()` функции Lua
5. Основной цикл: handleEvents → update → render
6. При выходе: shutdown() → lua_close() → SDL_Quit()

### 2. Renderer (src/Renderer.cpp)

**Ответственность:**
- Управление SDL окном и текстурами
- Рисование примитивов (пиксели, линии, прямоугольники, круги)
- Применение эффектов (дизеринг, палитра)

**Пиксельный буфер:**
```cpp
std::vector<uint32_t> pixelBuffer;  // 320 * 240 = 76,800 пиксел
```

**Процесс рендеринга:**
1. `clear()` - заполнить буфер цветом фона
2. Вызовы `drawRect()`, `drawCircle()` и т.д. - запись в pixelBuffer
3. `applyDitheringFilter()` - применить Bayer dithering
4. `SDL_UpdateTexture()` - копировать буфер в GPU texture
5. `SDL_RenderCopy()` - масштабировать с 2x
6. `SDL_RenderPresent()` - показать на экране

**Дизеринг (Bayer):**
```
Матрица 4x4:
0   8   2  10
12  4  14   6
3  11  1   9
15  7  13  5

Каждый пиксель сравнивается с порогом, основанным на его позиции,
что создает иллюзию большего числа цветов из ограниченной палитры.
```

### 3. LuaAPI (src/LuaAPI.cpp)

**Ответственность:**
- Регистрация C++ функций для Lua
- Управление Lua state
- Преобразование данных между C++ и Lua

**Регистрируемые функции:**

| Функция Lua | C++ реализация | Описание |
|-------------|---|---|
| `Engine.createObject(name, x, y)` | `lua_createObject()` | Создать GameObject |
| `Engine.setObjectProperty(obj, prop, val)` | `lua_setObjectProperty()` | Установить свойство |
| `Engine.getObjectProperty(obj, prop)` | `lua_getObjectProperty()` | Получить свойство |
| `Engine.drawRect(x, y, w, h, r, g, b)` | `lua_drawRect()` | Рисовать прямоугольник |
| `Engine.drawCircle(x, y, r, col, g, b)` | `lua_drawCircle()` | Рисовать круг |
| `Engine.isKeyPressed(key)` | `lua_isKeyPressed()` | Проверить клавишу |
| `Engine.log(msg)` | `lua_log()` | Вывести сообщение |

**Обработка Lua ошибок:**
```cpp
if (luaL_loadfile(L, path) || lua_pcall(L, 0, 0, 0)) {
    std::cerr << lua_tostring(L, -1);  // Получить сообщение об ошибке
    lua_pop(L, 1);                      // Удалить со стека
}
```

### 4. GameObject (Engine.hpp)

**Структура:**
```cpp
struct GameObject {
    int id;                                  // Уникальный ID
    std::string name;                        // Имя объекта
    float x, y;                              // Позиция
    float width, height;                     // Размер
    float vx, vy;                            // Скорость
    bool active;                             // Активен ли
    std::unordered_map<string, float> properties;  // Пользовательские свойства
};
```

**Интеграция с Lua:**
- Объекты передаются как `lightuserdata` (простой указатель)
- Lua может устанавливать/получать свойства через API
- Физика (позиция += скорость * delta) обновляется в Engine::update()

## Поток данных

### Создание объекта

```
Lua скрипт:
player = Engine.createObject("player", 100, 150)
    ↓
lua_createObject() (LuaAPI.cpp)
    ↓
Engine::createObject(name, x, y)
    ↓
std::make_unique<GameObject>(...)
    ↓
Вернуть GameObject* как lightuserdata в Lua
```

### Цикл обновления

```
main.cpp: while(running)
    ↓
engine.handleEvents()  → проверить SDL_QUIT, SDL_KEYDOWN
    ↓
engine.update(deltaTime)
    ├→ LuaAPI::callProcess(deltaTime)
    │  └→ Lua _process() функция
    │     ├→ Engine.setObjectProperty() - обновить позиции
    │     └→ Engine.drawRect() - вызовы рисования
    ├→ Обновить позиции объектов (x += vx * delta)
    └→ Проверить границы экрана
    ↓
engine.render()
    ├→ Renderer::clear()
    ├→ Renderer::drawRect() (для каждого активного объекта)
    ├→ Renderer::applyDithering()
    └→ Renderer::present()
```

### Рендеринг текстуры

```
pixelBuffer[320x240]
    ↓ (SDL_UpdateTexture)
GPU Texture (SDL_PIXELFORMAT_ARGB8888)
    ↓ (SDL_RenderCopy с масштабированием 2x)
SDL Window (640x480)
    ↓ (SDL_RenderPresent)
Монитор
```

## Оптимизации

### Размер бинарника

- **Компиляция**: `-O2 -Os` (оптимизация размера)
- **Stripping**: Удаление символов отладки
- **SDL2**: Статическая линковка (при возможности)
- **Lua**: Встроенный интерпретатор (~600 КБ)
- **Итого**: 3-4 МБ без зависимостей

### Производительность

- **Vsync**: Включен (60 FPS max)
- **Pixelbuffer**: Прямой доступ вместо API вызовов
- **Lua**: JIT может быть интегрирован для скриптов
- **Дизеринг**: Применяется один раз перед present() (не per-frame)

### Память

- **Pixelbuffer**: 320 * 240 * 4 = 307 КБ
- **GameObject storage**: ~100 объектов * 100 байт = 10 КБ
- **Lua stack**: ~1 МБ (по умолчанию)
- **Total**: ~2 МБ на базовую игру

## Расширение

### Добавление нового Lua API

1. Добавить функцию в `LuaAPI.hpp`:
```cpp
static int lua_myFunction(lua_State* L);
```

2. Реализовать в `LuaAPI.cpp`:
```cpp
int LuaAPI::lua_myFunction(lua_State* L) {
    // Получить аргументы из Lua стека
    // Выполнить C++ логику
    // Вернуть результат
}
```

3. Зарегистрировать в `registerEngineAPI()`:
```cpp
luaL_Reg functions[] = {
    {"myFunction", lua_myFunction},
    {nullptr, nullptr}
};
```

### Добавление новых примитивов

В `Renderer.cpp` добавить:
```cpp
void Renderer::drawTriangle(int x1, int y1, int x2, int y2, int x3, int y3, const Color& color) {
    drawLine(x1, y1, x2, y2, color);
    drawLine(x2, y2, x3, y3, color);
    drawLine(x3, y3, x1, y1, color);
}
```

---

**Архитектура спроектирована для минимальности, скорости разработки и кроссплатформенности.**
