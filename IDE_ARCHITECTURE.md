# IDE Architecture & Implementation Details

## 🏗️ Архитектура IDE

```
┌─────────────────────────────────────────────────────────────┐
│                      Main Application                       │
│                  (ApplicationController)                    │
└────┬─────────────────────────┬──────────────────┬───────────┘
     │                         │                  │
     ▼                         ▼                  ▼
┌─────────────┐      ┌──────────────────┐   ┌──────────────┐
│  EditorUI   │      │ GameEngine       │   │ Audio/Fonts  │
│ (ImGui)     │      │ (Render loop)    │   │ (Synthesis)  │
└────┬────────┘      └──────────────────┘   └──────────────┘
     │
     ├─→ SceneManager (объекты, JSON сериализация)
     ├─→ AudioSynthesizer (8-bit звук)
     ├─→ FontManager (TTF шрифты)
     └─→ AndroidBuilder (Gradle интеграция)
```

## 📂 Новая структура проекта

```
ascii_engine/
├── include/                      # Основные заголовки движка
│   ├── Engine.hpp
│   ├── Renderer.hpp
│   ├── LuaAPI.hpp
│   └── font/
│       └── FontManager.hpp
│
├── src/                          # Основной код движка
│   ├── main.cpp                  # Оригинальная точка входа (только игра)
│   ├── main_ide.cpp              # Новая точка входа (IDE + игра)
│   ├── Engine.cpp
│   ├── Renderer.cpp
│   └── LuaAPI.cpp
│
├── audio/                        # Аудио компоненты
│   ├── AudioSynthesizer.hpp
│   └── AudioSynthesizer.cpp      # 8-bit синтезатор
│
├── editor/                       # Компоненты IDE
│   ├── include/
│   │   ├── EditorUI.hpp          # Главный UI (ImGui)
│   │   ├── SceneManager.hpp      # Управление объектами сцены
│   │   └── (другие компоненты)
│   └── src/
│       ├── EditorUI.cpp          # Реализация UI панелей
│       └── SceneManager.cpp      # Сохранение/загрузка сцен
│
├── build_system/                 # Android export
│   ├── AndroidBuilder.hpp        # Gradle интеграция
│   └── AndroidBuilder.cpp        # Логика сборки APK
│
├── assets/                       # Игровые ресурсы
│   ├── main.lua
│   ├── advanced_example.lua
│   └── scenes/                   # Сохранённые сцены (JSON)
│
├── android/                      # Android проект
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── java/             # Java код (SDLActivity)
│   │   │   ├── cpp/              # Встраиваемый C++ код
│   │   │   └── assets/           # Копируется из assets/
│   │   ├── build.gradle
│   │   └── AndroidManifest.xml   # Генерируется IDE
│   ├── build.gradle
│   ├── settings.gradle
│   └── gradlew / gradlew.bat     # Gradle wrapper
│
├── external/                     # Внешние зависимости
│   └── imgui/                    # ImGui (requires download)
│       ├── imgui.h/cpp
│       ├── imgui_*.cpp
│       └── backends/
│           ├── imgui_impl_sdl2.h/cpp
│           └── imgui_impl_opengl3.h/cpp
│
├── CMakeLists.txt                # Оригинальная сборка
├── CMakeLists_IDE.txt            # Сборка с IDE
├── build.sh / build.bat          # Скрипты сборки
│
└── Documentation/
    ├── README.md
    ├── QUICKSTART.md
    ├── IDE_GUIDE.md              # ✨ Новый (использование IDE)
    ├── ANDROID_SDK_CONFIG.md     # ✨ Новый (конфиг SDK/NDK)
    ├── IDE_ARCHITECTURE.md       # ✨ Этот файл
    └── BUILD_EXPORT.md           # ✨ Новый (экспорт на разные платформы)
```

## 🔧 Компоненты EditorUI

### Scene Panel
```cpp
// editor/src/EditorUI.cpp -> drawScenePanel()
- Tree view всех объектов
- Кнопка "+ Add Object"
- Drag-and-drop переупорядочивание
- Выделение объектов (ImGui::TreeNodeEx с флагом Selected)
```

### Property Inspector
```cpp
// drawPropertyPanel()
- Текстовые поля (Name, Type)
- Слайдеры (X, Y, Width, Height)
- Drag controls (Scale X/Y)
- Color picker (ImGui::ColorEdit3)
- Ссылка на Lua-скрипт объекта
```

### Code Editor
```cpp
// drawCodeEditor()
- ImGui::InputTextMultiline для Lua кода
- Кнопка "Apply Changes (Hot Reload)"
- Синхронизация с SceneManager::SceneObject::luaScript
```

### Audio Tracker
```cpp
// drawAudioTracker()
- Radio buttons для выбора волновой формы
- Слайдер частоты (20-4000 Hz)
- Слайдер длительности
- Кнопки Play/Stop
- Вызывает AudioSynthesizer::playNote()
```

### Tilemap Editor
```cpp
// drawTilemapEditor()
- Слайдеры для размера плитки (8-32 px)
- Палитра 8 плиток (4x2 сетка)
- Текст с размером сетки (320/16 x 240/16 = 20x15)
```

### Build Exporter
```cpp
// drawBuildExporter()
- InputText для Package Name, App Name
- InputText для путей SDK/NDK
- Кнопка "Configure Build"
- Кнопка "Export APK (One-Click)"
  ├─ androidBuilder->generateManifest()
  ├─ androidBuilder->packageAssets()
  ├─ androidBuilder->buildAPK()
  └─ Popup с результатом
- TextWrapped для логов сборки
```

## 🎛️ SceneManager (JSON сериализация)

```cpp
// editor/include/SceneManager.hpp
struct SceneObject {
    int id;                                    // Уникальный ID
    string name, type;                         // Имя и тип
    float x, y, width, height;                 // Трансформация
    float scaleX, scaleY;                      // Масштаб
    int colorR, colorG, colorB;                // Цвет
    string luaScript;                          // Код скрипта
    map<string, string> properties;            // Пользовательские свойства
};

vector<SceneObject> sceneObjects;

// Методы:
SceneObject* createSceneObject(name, type, x, y);
void deleteSceneObject(int id);
bool saveScene(const string& path);   // → JSON
bool loadScene(const string& path);   // ← JSON
```

### Пример JSON сцены

```json
{
  "objects": [
    {
      "id": 1,
      "name": "Player",
      "type": "sprite",
      "x": 100,
      "y": 150,
      "width": 20,
      "height": 20,
      "scaleX": 1.0,
      "scaleY": 1.0,
      "colorR": 255,
      "colorG": 0,
      "colorB": 0,
      "luaScript": "function _process(delta) ... end"
    },
    {
      "id": 2,
      "name": "Tilemap",
      "type": "tilemap",
      ...
    }
  ]
}
```

## 📡 AndroidBuilder (Gradle интеграция)

```cpp
// build_system/AndroidBuilder.hpp
struct BuildConfig {
    string packageName;           // com.example.game
    string appName;               // My Game
    string androidSdkPath;        // /path/to/SDK
    string androidNdkPath;        // /path/to/NDK
    string gradlePath;            // ./gradlew
    string projectRoot;           // ./android
};

// Методы:
void setConfig(const BuildConfig& config);
bool generateManifest();          // Создать AndroidManifest.xml
bool packageAssets(sourceDir);    // Копировать в android/app/src/main/assets
bool buildAPK(bool debugMode);    // Запустить: ./gradlew assembleDebug
bool replacePackageNameInCode();  // Заменить package в Java коде
string getOutputAPKPath();        // Путь к скомпилированному APK
```

### Процесс экспорта (Ctrl-Click в UI)

```
1. androidBuilder->generateManifest()
   └─ Создаёт XML с пользовательским package name

2. androidBuilder->packageAssets("assets/")
   └─ fs::copy_directory(assets/ → android/app/src/main/assets/)

3. androidBuilder->buildAPK(true)
   └─ popen("./gradlew -p ./android assembleDebug")
   └─ Gradle загружает зависимости
   └─ NDK компилирует C++ код
   └─ Собирает APK в android/app/build/outputs/apk/debug/

4. Результат в Build Logs:
   ✅ APK built: app/build/outputs/apk/debug/app-debug.apk
```

## 🔊 AudioSynthesizer (8-bit синтез)

```cpp
// audio/AudioSynthesizer.hpp
class AudioSynthesizer {
public:
    enum WaveType { SQUARE, SINE, TRIANGLE, NOISE };
    
    struct ADSREnvelope {
        float attackTime;    // Нарастание
        float decayTime;     // Падение
        float sustainLevel;  // Уровень поддержи
        float releaseTime;   // Затухание
    };
    
    struct Note {
        int frequency;       // Hz
        float duration;      // сек
        float velocity;      // 0-1
        WaveType waveType;
        ADSREnvelope envelope;
    };
    
    // Публичные методы:
    void initialize(int sampleRate = 44100, int channels = 1);
    void playNote(int freq, float duration, WaveType type, const ADSREnvelope& env);
    void generateAudio(float* buffer, int numSamples);
};
```

### Волновые формы

```cpp
// Примеры генерации:

// Square Wave (чистый звук 8-bit)
normalizedPhase < 0.5f ? 1.0f : -1.0f

// Triangle Wave (тёплый, органичный)
if (phase < 0.25f) return 4 * phase;
else if (phase < 0.75f) return 2 - 4 * phase;
else return -4 + 4 * phase;

// Sine Wave (мягкий звук)
sin(phase)

// Noise (белый шум)
random(-1.0f, 1.0f)
```

### ADSR Envelope

```
Амплитуда
    │     ___
 1.0│    /   \___
    │   /         \___
 0.7│  /   Sustain   \
    │ /               \
    │/________________ \___
 0  └────────────────────→ время
    Attack  Decay Release
```

## 🎨 ImGui Integration

### Инициализация

```cpp
// editor/src/EditorUI.cpp -> initialize()
IMGUI_CHECKVERSION();
ImGuiContext* imguiContext = ImGui::CreateContext();
ImGui::GetIO().ConfigFlags |= ImGuiConfigFlags_DockingEnable;

// Backend
ImGui_ImplSDL2_InitForOpenGL(window, glContext);
ImGui_ImplOpenGL3_Init("#version 150");
```

### Главный цикл

```cpp
while (running) {
    // Frame prep
    editorUI->beginFrame();  // ImGui::NewFrame()
    
    // Render UI
    editorUI->render();      // Draw all panels
    
    // End frame
    editorUI->endFrame();    // ImGui::Render()
    
    // OpenGL rendering
    glClear(GL_COLOR_BUFFER_BIT);
    ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());
    SDL_GL_SwapWindow(g_window);
}
```

### ImGui Docking

```cpp
ImGuiID dockspaceId = ImGui::GetID("EditorDockspace");
ImGui::DockSpace(dockspaceId);  // Основной контейнер

// Для каждой панели:
ImGui::SetNextWindowDockID(dockspaceId, ImGuiCond_FirstUseEver);
drawScenePanel();
```

Пользователь может перетаскивать панели мышью.

## 🎮 Переключение между режимами

### main_ide.cpp (новая точка входа)

```cpp
class ApplicationController {
    RunMode runMode;
    Engine gameEngine;
    EditorUI* editorUI;
    
    void run() {
        while (running) {
            if (runMode == EDITOR_MODE) {
                updateEditor();    // ImGui рендер + логика
            } else {
                updateGame();      // Стандартный цикл игры
            }
        }
    }
    
    void handleEditorEvents() {
        // Ctrl+E - переключиться в Game Mode
        if (isKeyPressed(Ctrl+E)) {
            shutdown();
            initialize(GAME_MODE);
            run();
        }
        // ESC в игре - вернуться в редактор
        if (isKeyPressed(ESC)) {
            shutdown();
            initialize(EDITOR_MODE);
        }
    }
};
```

## 🔗 Зависимости IDE

| Библиотека | Версия | Использование |
|-----------|--------|---------------|
| ImGui | Latest | UI фреймворк |
| ImGui SDL2 Backend | Latest | Интеграция SDL2 |
| ImGui OpenGL3 Backend | Latest | Рендеринг |
| OpenGL | 3.0+ | 3D рендеринг ImGui |
| SDL2_ttf | 2.20+ | Загрузка TTF шрифтов |
| Lua | 5.4 | Скриптинг (как раньше) |

## ⚡ Производительность

### IDE Frame Rate
- Целевое: 60 FPS
- ImGui обновляется полностью каждый кадр (~1-2ms)
- Большинство времени: рендеринг OpenGL

### Memory Usage
- EditorUI: ~20 МБ (ImGui контекст + все панели)
- SceneManager: ~10 МБ (макс 1000 объектов)
- AudioSynthesizer: ~5 МБ (активные ноты + буфер)
- Итого: ~40-50 МБ в режиме редактора

### Оптимизация
- Сцены сохраняются в JSON (легко парсить)
- Lazy loading для больших сцен
- Audio buffer лимит: 16 одновременно играющих нот

---

**IDE полностью интегрирована с основным движком!**

Для использования см. IDE_GUIDE.md
