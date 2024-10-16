# General build instructions
# For Visual Studio proff 2022:
# ==============================
#   Create makefiles: cmake -S . -B build -G "Visual Studio 17 2022" -A x64
# --------------------------------------------------------------------------
#     A = Architecture
#
#   Build:
# --------------------------------------------------------------------------
#   cmake --build build --config Release
#
#
# Form within WSL (In VSC, open with: remote wsl new)
# =================
# Create makefiles:
# --------------------------------------------------------------------------
#   cmd.exe /c "call "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/VsDevCmd.bat"     && cmake -S . -B build  -G "Visual Studio 17 2022" -A x64 "
#
# Build:
# --------------------------------------------------------------------------
#   cmd.exe /c "call "C:/Program Files/Microsoft Visual Studio/2022/Professional/Common7/Tools/VsDevCmd.bat" && cmake --build build --config Release "
#

# Version and project name
# ==========================================================================================
cmake_minimum_required(VERSION 3.28)
project(Win32Project)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Debug)
 endif()

if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(CMAKE_CXX_FLAGS_DEBUG "/Zi")  # Debug information
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Od") 
endif()

# Define UNICODE and _UNICODE (1e for Win23 API, 2e for C library)
add_definitions(-DUNICODE -D_UNICODE)


# Set the compiler and tools used to compile and build artifacts
# ==========================================================================================
set(CMAKE_CXX_STANDARD 17)


# Set the output directories for the compiled binary and objects
# ==========================================================================================
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
# ------------------------------------------------------------------------------------------


# Define the base directories for headers and sources
# ==========================================================================================
#
set(HEADER_DIR ${CMAKE_SOURCE_DIR}/headers)
include_directories(${HEADER_DIR})
# To support a hierarchy of directories like: headers/views, headers/models, headers/database,
# we need to recursively traverse the base header directory. This is handled below.
file(GLOB_RECURSE HEADER_DIRS LIST_DIRECTORIES true "${CMAKE_SOURCE_DIR}/headers/*")
include_directories(${HEADER_DIRS})
#
# Set the source variable (SOURCE_DIR) with all C source files, recursively in all 
# sub-directories 
set(SOURCE_DIR ${CMAKE_SOURCE_DIR}/src)
file(GLOB_RECURSE SOURCES "${SOURCE_DIR}/*.cpp")
# ------------------------------------------------------------------------------------------


# RESOURCES
# ==========================================================================================
##	Set the resource directory (RESOURCE_DIR)
set(RESOURCE_DIR ${CMAKE_SOURCE_DIR}/resource)
##	Set the location of the .rc file to compile
set(RC_FILE "${RESOURCE_DIR}/App.rc")


# COMPILE & BUILD 
# ==========================================================================================
# Define the executable (outapp), its sources, and build dependencies.
#	Note: We link the resource file via target_link_libraries (see below), 
#	instead of adding it directly to the executable with add_executable(), 
#	which failed.
add_executable(outapp ${SOURCES} ${RC_FILE})
#
# Let known to expect a: wWinMain(...)
set_target_properties(outapp PROPERTIES WIN32_EXECUTABLE TRUE)
#
#
#	Link Windows libraries
# Other common libraries: comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib
# Other specific:         ws2_32.lib (network) winmm.lib(multimedia) d3d11.lib (Direct 3D) 
#                         dxguid.lib (DirectX) dwmapi.lib (Windowing effects) 
#                         shlwapi.lib(path manipulation)
# Other rare:             uuid.lib msimg32.lib setupapi.lib bcrypt.lib crypt32.lib
target_link_libraries(outapp PRIVATE user32 kernel32 gdi32)

# ------------------------------------------------------------------------------------------


# Clean up targets
# ==========================================================================================
set_property(DIRECTORY APPEND PROPERTY ADDITIONAL_MAKE_CLEAN_FILES ${RES_FILE})
