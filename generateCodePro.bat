@echo off
setlocal enabledelayedexpansion

:: ==============================================
:: ONLY CONFIGURATION TO MODIFY - ADJUST AS NEEDED!
:: ==============================================
set "PROTOC_EXE=D:\protobuf\bin\protoc.exe"       :: Path to protoc executable
set "PROTO_ROOT_DIR=D:\Myproject\proto"           :: Root directory for .proto files (scans subdirectories automatically)
set "INCLUDE_DIR=D:\protobuf\include"             :: Protoc's built-in include directory
set "CS_OUTPUT=C:\Users\karmas\Desktop\1"               :: Output directory for C# code
set "JAVA_OUTPUT=C:\Users\karmas\Desktop\springbootWithVertx2\src\main\java"      :: Output directory for Java code

:: ==============================================
:: DO NOT MODIFY BELOW THIS LINE - Stable Auto-scan + Batch Generation
:: ==============================================
echo ==============================================
echo Auto-Scan Protobuf Generator (Batch Mode)
echo Generate Time: %date% %time%
echo ==============================================
echo [Config Summary]
echo Protoc Path:    !PROTOC_EXE!
echo Proto Root Dir: !PROTO_ROOT_DIR!
echo Include Dir:    !INCLUDE_DIR!
echo C# Output:      !CS_OUTPUT!
echo Java Output:    !JAVA_OUTPUT!
echo ==============================================

:: Step 1: Verify dependencies (protoc, proto directory, include directory)
echo [1/4] Verifying dependencies...
if not exist "!PROTOC_EXE!" (
    echo ERROR: protoc.exe not found → Path: !PROTOC_EXE!
    pause
    exit /b 1
)
if not exist "!PROTO_ROOT_DIR!" (
    echo ERROR: Proto root directory not found → Path: !PROTO_ROOT_DIR!
    pause
    exit /b 1
)
if not exist "!INCLUDE_DIR!" (
    echo ERROR: Include directory not found → Path: !INCLUDE_DIR!
    pause
    exit /b 1
)

:: Step 2: Stable recursive scan (using dir /s - fixes compatibility issues)
echo [2/4] Scanning all .proto files...
set "PROTO_FILE_LIST="
set "FILE_COUNT=0"

:: Use dir /s to recursively find .proto files (more compatible than for /r)
for /f "delims=" %%f in ('dir /s /b "!PROTO_ROOT_DIR!\*.proto" 2^>nul') do (
    set "PROTO_FILE_LIST=!PROTO_FILE_LIST! "%%f""  :: Add quotes for space compatibility
    set /a FILE_COUNT+=1
)

:: Check if any .proto files were found
if !FILE_COUNT! equ 0 (
    echo ERROR: No .proto files found in !PROTO_ROOT_DIR! or its subdirectories!
    pause
    exit /b 1
)
echo Successfully found !FILE_COUNT! proto file(s): !PROTO_FILE_LIST!
echo ==============================================

:: Step 3: Create output directories if they don't exist
echo [3/4] Preparing output directories...
if not exist "!CS_OUTPUT!" (
    md "!CS_OUTPUT!" >nul 2>&1
    echo Created C# Output Directory: !CS_OUTPUT!
)
if not exist "!JAVA_OUTPUT!" (
    md "!JAVA_OUTPUT!" >nul 2>&1
    echo Created Java Output Directory: !JAVA_OUTPUT!
)

:: Step 4: Batch generate C# and Java code
echo [4/4] Generating code for all proto files...

:: Generate C# code
echo Generating C# code...
"!PROTOC_EXE!" --proto_path="!PROTO_ROOT_DIR!" --proto_path="!INCLUDE_DIR!" --csharp_out="!CS_OUTPUT!" !PROTO_FILE_LIST!
if %errorlevel% equ 0 (
    echo ✅ C# Code Generated Successfully! Output Directory: !CS_OUTPUT!
) else (
    echo ❌ Failed to generate C# code! Check proto file syntax or directory permissions.
    pause
    exit /b 1
)

:: Generate Java code
echo Generating Java code...
"!PROTOC_EXE!" --proto_path="!PROTO_ROOT_DIR!" --proto_path="!INCLUDE_DIR!" --java_out="!JAVA_OUTPUT!" !PROTO_FILE_LIST!
if %errorlevel% equ 0 (
    echo ✅ Java Code Generated Successfully! Output Directory: !JAVA_OUTPUT!
) else (
    echo ❌ Failed to generate Java code! Check proto file syntax or directory permissions.
    pause
    exit /b 1
)

:: Final success message
echo ==============================================
echo 🎉 All Code Generation Completed Successfully!
echo Total Proto Files Processed: !FILE_COUNT!
echo C# Code Path: !CS_OUTPUT!
echo Java Code Path: !JAVA_OUTPUT!
echo ==============================================
pause
endlocal