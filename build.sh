#!/bin/bash

# Build script for Linux/macOS

set -e

echo "=== Milk Inside Lite Engine - Build Script ==="

# Проверка CMake
if ! command -v cmake &> /dev/null; then
    echo "ERROR: CMake not found. Please install CMake 3.10+"
    exit 1
fi

# Проверка зависимостей
if ! pkg-config --exists sdl2; then
    echo "ERROR: SDL2 not found. Install with:"
    echo "  Ubuntu/Debian: sudo apt-get install libsdl2-dev"
    echo "  macOS: brew install sdl2"
    exit 1
fi

# Создание директории сборки
if [ ! -d "build" ]; then
    mkdir build
fi

cd build

# Сборка
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . -j$(nproc)

cd ..

# Вывод информации
echo ""
echo "=== Build Complete ==="
echo "Executable: ./build/ascii_engine"
echo "Assets: ./assets/"
echo ""
echo "To run: ./build/ascii_engine"
