@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: No admin elevation required - HKCU registry removal is user-scoped

cls
echo.
echo   ================================================================
echo.
echo       _      _      __  __        ____  _      ___     ____   ____ 
echo      ^| ^|    ^| ^|    ^|  \/  ^|_____ / ___^|^| ^|    ^|_ _^|   ^|  _ \ / ___^|
echo      ^| ^|    ^| ^|    ^| ^|\/^| ^|_____^| ^|    ^| ^|     ^| ^|    ^| ^|_) ^| ^|    
echo      ^| ^|___ ^| ^|___ ^| ^|  ^| ^|     ^| ^|___ ^| ^|___  ^| ^|    ^|  _ ^<^| ^|___ 
echo      ^|_____^|^|_____^|^|_^|  ^|_^|      \____^|^|_____^|^|___^|   ^|_^| \_\\____^|
echo.
echo           Context Menu Uninstaller for Windows
echo.
echo   ================================================================
echo.

echo   UNINSTALL
echo   ----------------------------------------------------------------
echo.
echo   ^! Warning: This will remove the RightClick CLI context menu
echo     and all associated files from your system.
echo.

choice /C YN /N /M "   Are you sure you want to uninstall? [Y/N]: "
if errorlevel 2 (
    echo.
    echo   Uninstallation cancelled.
    echo.
    pause
    exit /b 0
)

echo.
echo   ----------------------------------------------------------------
echo.
echo   REMOVING
echo.

echo   [Step 1/3] Removing registry entries...
regedit /s "%~dp0registry\LLM_CLI_REMOVER.reg"
echo              ^> Registry entries removed
echo.

echo   [Step 2/3] Removing files...
if exist "%USERPROFILE%\.llm-cli" rd /s /q "%USERPROFILE%\.llm-cli"
echo              ^> Files removed
echo.

:: Remove %USERPROFILE%\.llm-cli from the user PATH (added by the installer so
:: the ccc launcher can be called from any terminal). Rebuilds the value
:: without that single segment, preserving every other entry verbatim.
echo   [Step 3/3] Removing "ccc" terminal command...
set "LLM_CLI_DIR=%USERPROFILE%\.llm-cli"
set "USER_PATH="
for /f "usebackq tokens=2,*" %%A in (`reg query "HKCU\Environment" /v Path 2^>nul ^| findstr /i "Path"`) do set "USER_PATH=%%B"
if defined USER_PATH (
    echo("!USER_PATH!" | findstr /i /c:".llm-cli" >nul
    if errorlevel 1 (
        echo              ^> Not on PATH - nothing to do
    ) else (
        :: Rebuild PATH segment by segment, skipping the .llm-cli entry.
        :: Done this way because nested substring replacement on a value
        :: containing "%" and "!" chars is unreliable in batch.
        set "NEW_PATH="
        for %%S in ("!USER_PATH:;=" "!") do (
            set "SEG=%%~S"
            if not "!SEG!"=="" if /i not "!SEG!"=="!LLM_CLI_DIR!" (
                if defined NEW_PATH (
                    set "NEW_PATH=!NEW_PATH!;!SEG!"
                ) else (
                    set "NEW_PATH=!SEG!"
                )
            )
        )
        reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!NEW_PATH!" /f >nul
        echo              ^> Removed "!LLM_CLI_DIR!" from PATH
    )
) else (
    echo              ^> Not on PATH - nothing to do
)
echo.

echo   ================================================================
echo.
echo                  UNINSTALLATION COMPLETE!
echo.
echo   ================================================================
echo.
echo   The RightClick CLI context menu has been removed from your system.
echo   To reinstall, run: install.bat
echo.
pause
