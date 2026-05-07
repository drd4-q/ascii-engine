@echo off
REM Build script for Windows (MSVC)

echo === Milk Inside Lite Engine - Windows Build ===

REM Проверка CMake
where cmake >nul 2>nul
if errorlevel 1 (
    echo ERROR: CMake not found. Please install CMake 3.10+
    exit /b 1
)

REM Создание директории сборки
if not exist build (
    mkdir build
)

cd build

REM Сборка
echo Configuring...
cmake .. -G "Visual Studio 16 2019" -DCMAKE_CONFIGURATION_TYPES=Release

echo Building...
cmake --build . --config Release

cd ..

echo.
echo === Build Complete ===
echo Executable: build\Release\ascii_engine.exe
echo Assets: assets\
echo.
echo To run: build\Release\ascii_engine.exe
pause
