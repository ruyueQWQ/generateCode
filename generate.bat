@echo off
setlocal enabledelayedexpansion

:: ==============================================
:: CONFIGURATION - ONLY MODIFY THESE LINES!
:: ==============================================
set "PROTOC_EXE=D:\protobuf\bin\protoc.exe"       :: Path to protoc.exe
set "PROTO_DIR=D:\Myproject\proto"               :: Directory with your .proto files
set "PROTO_FILE=game.proto"                      :: Your proto file name (e.g., game.proto)
set "INCLUDE_DIR=D:\protobuf\include"            :: Protoc's include directory
set "CS_OUTPUT=D:\Myproject\src\C#"              :: C# output directory
set "JAVA_OUTPUT=C:\Users\karmas\Desktop\springbootWithVertx2\src\main\java"     :: Java output directory

:: ==============================================
:: DO NOT MODIFY BELOW THIS LINE
:: ==============================================
echo ==============================================
echo Simple Protobuf Generator (C# + Java)
echo Generate Time: %date% %time%
echo ==============================================
echo [Config Check]
echo Protoc:      !PROTOC_EXE!
echo Proto File:  !PROTO_DIR!\!PROTO_FILE!
echo Include:     !INCLUDE_DIR!
echo C# Output:   !CS_OUTPUT!
echo Java Output: !JAVA_OUTPUT!
echo ==============================================

:: Step 1: Verify all required files/directories
echo [1/4] Verifying dependencies...
if not exist "!PROTOC_EXE!" (
    echo ERROR: protoc.exe not found at !PROTOC_EXE!
    pause
    exit /b 1
)
if not exist "!PROTO_DIR!\!PROTO_FILE!" (
    echo ERROR: Proto file not found at !PROTO_DIR!\!PROTO_FILE!
    pause
    exit /b 1
)
if not exist "!INCLUDE_DIR!" (
    echo ERROR: Include directory not found at !INCLUDE_DIR!
    pause
    exit /b 1
)

:: Step 2: Create output directories if missing
echo [2/4] Preparing output directories...
if not exist "!CS_OUTPUT!" (
    md "!CS_OUTPUT!" >nul 2>&1
    echo Created C# output dir: !CS_OUTPUT!
)
if not exist "!JAVA_OUTPUT!" (
    md "!JAVA_OUTPUT!" >nul 2>&1
    echo Created Java output dir: !JAVA_OUTPUT!
)

:: Step 3: Generate C# code
echo [3/4] Generating C# code...
"!PROTOC_EXE!" --proto_path="!PROTO_DIR!" --proto_path="!INCLUDE_DIR!" --csharp_out="!CS_OUTPUT!" "!PROTO_DIR!\!PROTO_FILE!"
if %errorlevel% equ 0 (
    echo C# Code Generated Successfully!
) else (
    echo ERROR: Failed to generate C# code!
    pause
    exit /b 1
)

:: Step 4: Generate Java code
echo [4/4] Generating Java code...
"!PROTOC_EXE!" --proto_path="!PROTO_DIR!" --proto_path="!INCLUDE_DIR!" --java_out="!JAVA_OUTPUT!" "!PROTO_DIR!\!PROTO_FILE!"
if %errorlevel% equ 0 (
    echo Java Code Generated Successfully!
) else (
    echo ERROR: Failed to generate Java code!
    pause
    exit /b 1
)

:: Final success message
echo ==============================================
echo ALL CODE GENERATED SUCCESSFULLY!
echo Check output directories:
echo - C#: !CS_OUTPUT!
echo - Java: !JAVA_OUTPUT!
echo ==============================================
pause
endlocal