# Quick Start Guide

## 📥 Быстрый старт

### За 5 минут

1. **Установка зависимостей**
   ```bash
   # Windows (с vcpkg)
   vcpkg install sdl2:x64-windows lua:x64-windows
   
   # Linux
   sudo apt-get install libsdl2-dev liblua5.4-dev cmake
   
   # macOS
   brew install sdl2 lua cmake
   ```

2. **Сборка**
   ```bash
   mkdir build && cd build
   cmake ..
   cmake --build .
   ```

3. **Запуск**
   ```bash
   ./ascii_engine
   ```

## 🎮 Создание первой игры

### Шаг 1: Создать `assets/my_game.lua`

```lua
function _ready()
    Engine.log("My game started!")
    hero = Engine.createObject("hero", 160, 100)
    Engine.setObjectProperty(hero, "width", 20)
    Engine.setObjectProperty(hero, "height", 20)
end

function _process(delta)
    -- Получить текущую позицию
    local x = Engine.getObjectProperty(hero, "x")
    
    -- Движение влево/вправо
    if Engine.isKeyPressed("left") then
        Engine.setObjectProperty(hero, "x", x - 100 * delta)
    elseif Engine.isKeyPressed("right") then
        Engine.setObjectProperty(hero, "x", x + 100 * delta)
    end
    
    -- Рисование игрока
    Engine.drawRect(x, 100, 20, 20, 255, 100, 100)
end
```

### Шаг 2: Отредактировать `assets/main.lua`

Скопировать содержимое `my_game.lua` в `main.lua` или изменить путь в коде.

### Шаг 3: Запустить

```bash
./ascii_engine
```

Используйте стрелки влево/вправо для управления игроком.

## 🎨 Примеры кода

### Создание нескольких объектов

```lua
function _ready()
    -- Создать массив врагов
    enemies = {}
    for i = 1, 10 do
        local enemy = Engine.createObject("enemy_" .. i, 30 * i, 50)
        Engine.setObjectProperty(enemy, "width", 12)
        Engine.setObjectProperty(enemy, "height", 12)
        table.insert(enemies, enemy)
    end
end
```

### Обработка столкновений

```lua
function checkCollisionAABB(obj1, obj2)
    local x1 = Engine.getObjectProperty(obj1, "x")
    local y1 = Engine.getObjectProperty(obj1, "y")
    local w1 = Engine.getObjectProperty(obj1, "width")
    local h1 = Engine.getObjectProperty(obj1, "height")
    
    local x2 = Engine.getObjectProperty(obj2, "x")
    local y2 = Engine.getObjectProperty(obj2, "y")
    local w2 = Engine.getObjectProperty(obj2, "width")
    local h2 = Engine.getObjectProperty(obj2, "height")
    
    return (x1 < x2 + w2 and x1 + w1 > x2 and
            y1 < y2 + h2 and y1 + h1 > y2)
end

function _process(delta)
    -- Проверить столкновение с каждым врагом
    for _, enemy in ipairs(enemies) do
        if checkCollisionAABB(player, enemy) then
            Engine.log("Collision!")
            score = score + 10
        end
    end
end
```

### Рисование UI

```lua
function _process(delta)
    -- Основной мир
    Engine.drawRect(player_x, player_y, 16, 16, 255, 0, 0)
    
    -- HUD поверх всего
    Engine.drawText(5, 5, "Score: " .. score, 100, 255, 0)
    Engine.drawText(5, 220, "FPS: " .. fps, 200, 200, 200)
end
```

### Случайные числа

```lua
math.randomseed(os.time())

function _ready()
    -- Случайная позиция
    local x = math.random(0, 300)
    local y = math.random(0, 220)
    obj = Engine.createObject("obj", x, y)
end
```

## 🔧 Полезные ссылки

- **SDL2 документация**: https://wiki.libsdl.org/
- **Lua документация**: https://www.lua.org/manual/5.4/
- **CMake гайд**: https://cmake.org/cmake/help/latest/

## ❓ Частые вопросы

**Q: Как изменить разрешение?**
A: Отредактируйте `main.cpp` линию `engine.initialize(320, 240)` на нужное значение.

**Q: Почему нет спрайтов?**
A: Текущая версия использует только примитивы. Спрайты - в плане расширения.

**Q: Как добавить звуки?**
A: Использовать SDL_mixer. Нужно добавить поддержку в Engine.

**Q: Работает ли на мобильных?**
A: Да! Смотрите ANDROID.md для интеграции.

**Q: Есть ли поддержка сетей?**
A: Нет в базовой версии. Можно добавить через Lua sockets.

---

**Готовы разрабатывать? Отредактируйте `assets/main.lua` и запустите!**
