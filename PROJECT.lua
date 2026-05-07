project_name = "Milk Inside Lite Engine"
version = "1.0.0"
description = "Lightweight 2D game engine with Lua scripting and retro aesthetics"

-- Engine specifications
engine = {
    resolution = "320x240",
    display_scale = "2x",
    fps_cap = 60,
    palette_colors = 8,
    binary_target_size = "< 5 MB"
}

-- Dependencies
dependencies = {
    "SDL2 (graphics/input)",
    "Lua 5.4 (scripting)",
    "CMake 3.10+ (build)"
}

-- Supported platforms
platforms = {
    "Windows (MSVC, MinGW)",
    "Linux (GCC, Clang)",
    "macOS (Clang)",
    "Android (NDK API 21+)"
}

-- Language specification
language = "C++17"
build_system = "CMake"

-- Project status
status = "Core Complete"

-- Features implemented
features = {
    "✓ SDL2 rendering (320x240)",
    "✓ Bayer dithering filter",
    "✓ Lua scripting integration",
    "✓ GameObject system",
    "✓ Keyboard input handling",
    "✓ Primitive drawing (rect, circle, text)",
    "✓ Cross-platform support",
    "✓ CMake build configuration"
}

-- Future roadmap
roadmap = {
    "Sprite rendering",
    "Animation system",
    "Collision detection (AABB, Circle)",
    "Sound support (SDL_mixer)",
    "Scene/Level system",
    "Particle effects",
    "UI framework",
    "Lua bytecode compilation"
}

-- Build commands
build = {
    windows = "mkdir build && cd build && cmake .. && cmake --build . --config Release",
    linux = "mkdir build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && cmake --build .",
    macos = "mkdir build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release && cmake --build .",
    android = "cd android && ndk-build NDK_PROJECT_PATH=."
}

-- File structure
file_structure = {
    "CMakeLists.txt - Main build configuration",
    "include/ - Header files",
    "  ├─ Engine.hpp - Core engine",
    "  ├─ Renderer.hpp - Graphics system",
    "  └─ LuaAPI.hpp - Lua bindings",
    "src/ - Implementation files",
    "  ├─ main.cpp - Entry point",
    "  ├─ Engine.cpp",
    "  ├─ Renderer.cpp",
    "  └─ LuaAPI.cpp",
    "assets/ - Game data",
    "  └─ main.lua - Main game script",
    "android/ - Android NDK integration",
    "  ├─ jni/",
    "  │  ├─ Android.mk",
    "  │  └─ Application.mk",
    "  └─ AndroidManifest.xml",
    "Documentation/",
    "  ├─ README.md - Getting started",
    "  ├─ QUICKSTART.md - Quick reference",
    "  ├─ API_REFERENCE.md - Complete API docs",
    "  ├─ ARCHITECTURE.md - Technical architecture",
    "  └─ ANDROID.md - Mobile development guide"
}

-- Author notes
notes = {
    "Created 2026 - Optimized for minimal size and performance",
    "Inspired by 'Milk inside of a bag...' visual style",
    "Designed for indie game developers and hobbyists"
}
