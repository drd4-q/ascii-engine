/* Milk Inside Lite Engine - Complete API Reference */

// ============================================================================
// ENGINE API (доступно из Lua как Engine.* функции)
// ============================================================================

// СОЗДАНИЕ ОБЪЕКТОВ
// ============================================================================

/**
 * Engine.createObject(name, x, y) -> obj
 * Создать новый игровой объект
 * @param name - имя объекта (строка)
 * @param x - начальная X позиция
 * @param y - начальная Y позиция
 * @return объект (передается как lightuserdata)
 * 
 * Пример:
 *   player = Engine.createObject("player", 100, 150)
 */

/**
 * Engine.destroyObject(obj_id) -> nil
 * Удалить объект из сцены
 * @param obj_id - ID объекта
 * 
 * Пример:
 *   Engine.destroyObject(1)
 */

/**
 * Engine.getObject(obj_id) -> obj
 * Получить объект по ID
 * @param obj_id - ID объекта
 * @return объект или nil если не найден
 */

// УПРАВЛЕНИЕ СВОЙСТВАМИ ОБЪЕКТОВ
// ============================================================================

/**
 * Engine.setObjectProperty(obj, property_name, value) -> nil
 * Установить свойство объекта
 * @param obj - объект
 * @param property_name - имя свойства (строка)
 * @param value - новое значение (число)
 * 
 * Встроенные свойства:
 *   - "x", "y" - позиция
 *   - "width", "height" - размер
 *   - "vx", "vy" - скорость
 *   - "active" - активен ли объект
 * 
 * Пользовательские свойства:
 *   - Любое имя - сохраняется в std::unordered_map
 * 
 * Примеры:
 *   Engine.setObjectProperty(player, "x", 160)
 *   Engine.setObjectProperty(player, "vx", 100)
 *   Engine.setObjectProperty(enemy, "health", 100)
 */

/**
 * Engine.getObjectProperty(obj, property_name) -> value
 * Получить свойство объекта
 * @param obj - объект
 * @param property_name - имя свойства
 * @return значение свойства (число)
 * 
 * Примеры:
 *   local x = Engine.getObjectProperty(player, "x")
 *   local health = Engine.getObjectProperty(enemy, "health")
 */

// РИСОВАНИЕ
// ============================================================================

/**
 * Engine.drawRect(x, y, width, height, r, g, b) -> nil
 * Рисовать заполненный прямоугольник
 * @param x, y - верхний левый угол
 * @param width, height - размер
 * @param r, g, b - цвет RGB (0-255)
 * 
 * Пример:
 *   Engine.drawRect(100, 50, 20, 20, 255, 0, 0)  -- Красный квадрат
 */

/**
 * Engine.drawCircle(x, y, radius, r, g, b) -> nil
 * Рисовать заполненный круг
 * @param x, y - центр
 * @param radius - радиус
 * @param r, g, b - цвет RGB
 * 
 * Пример:
 *   Engine.drawCircle(160, 120, 10, 0, 255, 0)  -- Зелёный круг
 */

/**
 * Engine.drawText(x, y, text, r, g, b) -> nil
 * Рисовать текст (простой 3x4 шрифт)
 * @param x, y - позиция
 * @param text - текстовая строка
 * @param r, g, b - цвет текста
 * 
 * Примечание: поддерживаются только цифры (0-9)
 * 
 * Пример:
 *   Engine.drawText(10, 10, "Score: 123", 255, 255, 255)
 */

// ВВОД
// ============================================================================

/**
 * Engine.isKeyPressed(key_name) -> boolean
 * Проверить, нажата ли клавиша
 * @param key_name - имя клавиши (строка)
 * @return true если нажата, false иначе
 * 
 * Поддерживаемые клавиши:
 *   "left", "right", "up", "down" - стрелки
 *   "space" - пробел
 *   "enter" - Enter
 * 
 * Пример:
 *   if Engine.isKeyPressed("left") then
 *       x = x - speed * delta
 *   end
 */

// УТИЛИТЫ
// ============================================================================

/**
 * Engine.log(message) -> nil
 * Вывести сообщение в консоль
 * @param message - сообщение (строка)
 * 
 * Пример:
 *   Engine.log("Player spawned at " .. x .. ", " .. y)
 */

// ============================================================================
// LIFECYCLE FUNCTIONS (в main.lua)
// ============================================================================

/**
 * function _ready()
 * Вызывается один раз при инициализации игры
 * Используется для:
 *   - Создания начальных объектов
 *   - Инициализации переменных
 *   - Загрузки ресурсов
 * 
 * Пример:
 *   function _ready()
 *       player = Engine.createObject("player", 160, 120)
 *       score = 0
 *   end
 */

/**
 * function _process(delta)
 * Вызывается каждый кадр для обновления логики
 * @param delta - время прошедшее с последнего кадра (секунды)
 * 
 * Используется для:
 *   - Обновления позиций объектов
 *   - Проверки столкновений
 *   - Обработки ввода
 *   - Рисования сцены
 * 
 * Примечание: все вызовы Engine.draw* должны быть в этой функции
 * 
 * Пример:
 *   function _process(delta)
 *       if Engine.isKeyPressed("left") then
 *           x = x - 100 * delta
 *       end
 *       Engine.drawRect(x, y, 20, 20, 255, 0, 0)
 *   end
 */

// ============================================================================
// СТРУКТУРА GAMEOBJECT
// ============================================================================

/*
struct GameObject {
    int id;                          // Уникальный ID (автоматический)
    string name;                     // Имя объекта
    float x, y;                      // Позиция в пиксел
    float width, height;             // Размер в пиксел
    float vx, vy;                    // Скорость (пиксел/сек)
    bool active;                     // Активен ли объект
    map<string, float> properties;   // Пользовательские свойства
};

// Физика: в Engine::update()
// x += vx * deltaTime
// y += vy * deltaTime
// (затем применяются границы экрана)
*/

// ============================================================================
// ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ
// ============================================================================

// ДВИЖУЩИЙСЯ КВАДРАТ
function _ready()
    box = Engine.createObject("box", 150, 110)
end

function _process(delta)
    local x = Engine.getObjectProperty(box, "x")
    local y = Engine.getObjectProperty(box, "y")
    
    if Engine.isKeyPressed("left") then
        Engine.setObjectProperty(box, "x", x - 150 * delta)
    end
    if Engine.isKeyPressed("right") then
        Engine.setObjectProperty(box, "x", x + 150 * delta)
    end
    
    Engine.drawRect(x, y, 20, 20, 100, 200, 255)
end

// СЧЁТЧИК
function _ready()
    counter = 0
end

function _process(delta)
    if Engine.isKeyPressed("space") then
        counter = counter + 1
    end
    Engine.drawText(150, 115, "Count: " .. counter, 255, 255, 255)
end

// СЛУЧАЙНЫЕ ОБЪЕКТЫ
function _ready()
    math.randomseed(os.time())
    for i = 1, 5 do
        local x = math.random(0, 300)
        local y = math.random(0, 220)
        Engine.createObject("item_" .. i, x, y)
    end
end

---

**Справочник API v1.0 - Milk Inside Lite Engine**
Используйте для разработки игр на Lua
