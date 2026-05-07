cmake_minimum_required(VERSION 3.10)
project(ascii_engine)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Оптимизация для минимального размера
if(MSVC)
    add_compile_options(/O1 /Os)
else()
    add_compile_options(-O2 -Os)
endif()

# Поиск библиотек
find_package(SDL2 REQUIRED)
find_package(Lua REQUIRED)

# Включаемые директории
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${SDL2_INCLUDE_DIRS}
    ${LUA_INCLUDE_DIR}
)

# Источники
set(SOURCES
    src/main.cpp
    src/Engine.cpp
    src/Renderer.cpp
    src/LuaAPI.cpp
)

# Создание исполняемого файла
add_executable(ascii_engine ${SOURCES})

# Линковка библиотек
target_link_libraries(ascii_engine
    ${SDL2_LIBRARIES}
    ${LUA_LIBRARIES}
)

# Копирование assets в директорию сборки
add_custom_command(TARGET ascii_engine POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
    ${CMAKE_CURRENT_SOURCE_DIR}/assets
    ${CMAKE_CURRENT_BINARY_DIR}/assets
    COMMENT "Copying assets to build directory"
)

# Windows специфичное (опционально)
if(WIN32)
    set_property(DIRECTORY APPEND PROPERTY VS_STARTUP_PROJECT ascii_engine)
endif()

# Вывод информации о сборке
message(STATUS "=== Ascii Engine Build Configuration ===")
message(STATUS "CMake Version: ${CMAKE_VERSION}")
message(STATUS "CXX Standard: ${CMAKE_CXX_STANDARD}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "SDL2: ${SDL2_INCLUDE_DIRS}")
message(STATUS "Lua: ${LUA_INCLUDE_DIR}")
