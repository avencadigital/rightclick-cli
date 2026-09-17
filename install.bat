@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

:: No admin elevation required - HKCU registry writes are user-scoped

set "DEST=%USERPROFILE%\.llm-cli\assets"

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
echo            Context Menu Installer for Windows
echo.
echo   ================================================================
echo.

:: Initialize CLI selections
set "INSTALL_CLAUDE=0"
set "INSTALL_CLAUDE_CUSTOM=0"
set "INSTALL_ANTIGRAVITY=0"
set "INSTALL_QWEN=0"
set "INSTALL_DROID=0"
set "INSTALL_OPENCODE=0"
set "INSTALL_CODEBUFF=0"
set "INSTALL_KILO=0"
set "INSTALL_CODEX=0"

echo   SELECT CLI TOOLS
echo   ----------------------------------------------------------------
echo.

:: Claude Code
echo   [1/9] Claude Code
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_CLAUDE=1"
    echo         [+] Selected
)
echo.

:: Claude Code (Custom)
echo   [2/9] Claude Code (Custom)
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_CLAUDE_CUSTOM=1"
    echo         [+] Selected
    echo.
    echo         Custom Configuration:
    echo         Runs Claude Code against any Anthropic-compatible API.
    echo         Defaults below point to GLM - press Enter to keep them.
    echo.
    set "CUSTOM_NAME="
    set /p "CUSTOM_NAME=         Display name ^(Press Enter => Custom^): "
    if "!CUSTOM_NAME!"=="" set "CUSTOM_NAME=Custom"
    :: Strip characters that would break the registry label or the .cmd file
    set "CUSTOM_NAME=!CUSTOM_NAME:"=!"
    set "CUSTOM_NAME=!CUSTOM_NAME:%%=!"
    echo         ^> Menu entry: Claude Code ^(!CUSTOM_NAME!^)
    echo.
:custom_token_prompt
    set "CUSTOM_TOKEN="
    set /p "CUSTOM_TOKEN=         API Token (required): "
    if "!CUSTOM_TOKEN!"=="" (
        echo         ^! API Token cannot be empty. Please try again.
        goto custom_token_prompt
    )
    set "CUSTOM_BASE_URL="
    set /p "CUSTOM_BASE_URL=         Base URL -> https://api.z.ai/api/anthropic (Press Enter to keep default): "
    if "!CUSTOM_BASE_URL!"=="" set "CUSTOM_BASE_URL=https://api.z.ai/api/anthropic"
    set "CUSTOM_MODEL="
    set /p "CUSTOM_MODEL=         Model (Press Enter => glm-5.2): "
    if "!CUSTOM_MODEL!"=="" set "CUSTOM_MODEL=glm-5.2"
    set "CUSTOM_TIMEOUT=3000000"
    echo.
    echo         [OK] Claude Code ^(!CUSTOM_NAME!^) configured
)
echo.

:: Antigravity CLI
echo   [3/9] Antigravity CLI
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_ANTIGRAVITY=1"
    echo         [+] Selected
)
echo.

:: Qwen
echo   [4/9] Qwen
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_QWEN=1"
    echo         [+] Selected
)
echo.

:: Droid
echo   [5/9] Droid
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_DROID=1"
    echo         [+] Selected
)
echo.

:: Opencode
echo   [6/9] Opencode
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_OPENCODE=1"
    echo         [+] Selected
)
echo.

:: Codebuff
echo   [7/9] Codebuff
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_CODEBUFF=1"
    echo         [+] Selected
)
echo.

:: Kilo
echo   [8/9] Kilo
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_KILO=1"
    echo         [+] Selected
)
echo.

:: Codex CLI
echo   [9/9] Codex CLI
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_CODEX=1"
    echo         [+] Selected
)
echo.

:: Check if at least one CLI is selected
set /a "TOTAL=INSTALL_CLAUDE+INSTALL_CLAUDE_CUSTOM+INSTALL_ANTIGRAVITY+INSTALL_QWEN+INSTALL_DROID+INSTALL_OPENCODE+INSTALL_CODEBUFF+INSTALL_KILO+INSTALL_CODEX"
if %TOTAL%==0 (
    echo   ----------------------------------------------------------------
    echo.
    echo   ^! No CLI tools selected. Installation cancelled.
    echo.
    pause
    exit /b 0
)

echo   ----------------------------------------------------------------
echo.
echo   INSTALLING
echo   Selected: %TOTAL% tool(s)
echo.

:: Create directory
echo   [Step 1/4] Creating directories...
if not exist "%USERPROFILE%\.llm-cli" mkdir "%USERPROFILE%\.llm-cli"
if not exist "%DEST%" mkdir "%DEST%"
echo              ^> %DEST%
echo.

:: Copy icons
echo   [Step 2/4] Copying icons...
copy /Y "%~dp0assets\cli.ico" "%DEST%\" >nul
if %INSTALL_CLAUDE%==1 copy /Y "%~dp0assets\claude.ico" "%DEST%\" >nul
if %INSTALL_CLAUDE_CUSTOM%==1 (
    copy /Y "%~dp0assets\claudecustom.ico" "%DEST%\" >nul
    :: Remove a legacy GLM-named script so only the current one remains
    if exist "%USERPROFILE%\.llm-cli\claude-glm.cmd" del /q "%USERPROFILE%\.llm-cli\claude-glm.cmd"
    :: Generate claude-custom.cmd with the user's credentials
    (
        echo @echo off
        echo set ANTHROPIC_AUTH_TOKEN=!CUSTOM_TOKEN!
        echo set ANTHROPIC_BASE_URL=!CUSTOM_BASE_URL!
        echo set API_TIMEOUT_MS=!CUSTOM_TIMEOUT!
        echo set ANTHROPIC_DEFAULT_OPUS_MODEL=!CUSTOM_MODEL!
        echo set ANTHROPIC_DEFAULT_HAIKU_MODEL=!CUSTOM_MODEL!
        echo set ANTHROPIC_DEFAULT_SONNET_MODEL=!CUSTOM_MODEL!
        echo claude %%*
    ) > "%USERPROFILE%\.llm-cli\claude-custom.cmd"
    :: Create ccc.cmd launcher so Claude Code (Custom) can be started from any
    :: terminal - it just delegates to claude-custom.cmd (single source of
    :: truth for credentials) and forwards any extra arguments.
    (
        echo @echo off
        echo "%%USERPROFILE%%\.llm-cli\claude-custom.cmd" %%*
    ) > "%USERPROFILE%\.llm-cli\ccc.cmd"
)
if %INSTALL_ANTIGRAVITY%==1 copy /Y "%~dp0assets\antigravity.ico" "%DEST%\" >nul
if %INSTALL_QWEN%==1 copy /Y "%~dp0assets\qwen.ico" "%DEST%\" >nul
if %INSTALL_DROID%==1 copy /Y "%~dp0assets\droid.ico" "%DEST%\" >nul
if %INSTALL_OPENCODE%==1 copy /Y "%~dp0assets\opencode.ico" "%DEST%\" >nul
if %INSTALL_CODEBUFF%==1 copy /Y "%~dp0assets\codebuff.ico" "%DEST%\" >nul
if %INSTALL_KILO%==1 copy /Y "%~dp0assets\kilo.ico" "%DEST%\" >nul
if %INSTALL_CODEX%==1 copy /Y "%~dp0assets\codex.ico" "%DEST%\" >nul
echo              ^> Icons copied successfully
echo.

:: Apply registry entries
echo   [Step 3/4] Applying registry entries...

:: Create main menu structure
reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI" /v "MUIVerb" /t REG_SZ /d "Open with AI CLI" /f >nul
reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI" /v "Icon" /t REG_SZ /d "%DEST%\cli.ico" /f >nul
reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI" /v "SubCommands" /t REG_SZ /d "" /f >nul

reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI" /v "MUIVerb" /t REG_SZ /d "Open with AI CLI" /f >nul
reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI" /v "Icon" /t REG_SZ /d "%DEST%\cli.ico" /f >nul
reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI" /v "SubCommands" /t REG_SZ /d "" /f >nul

:: Add Claude if selected (both safe and yolo modes)
if %INSTALL_CLAUDE%==1 (
    :: Claude Code (Safe mode)
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Claude" /v "MUIVerb" /t REG_SZ /d "Claude Code" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Claude" /v "Icon" /t REG_SZ /d "%DEST%\claude.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Claude\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k claude" /f >nul

    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Claude" /v "MUIVerb" /t REG_SZ /d "Claude Code" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Claude" /v "Icon" /t REG_SZ /d "%DEST%\claude.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Claude\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k claude" /f >nul

    :: Claude Code (Yolo mode - skip permissions)
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeYolo" /v "MUIVerb" /t REG_SZ /d "Claude Code (Yolo)" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeYolo" /v "Icon" /t REG_SZ /d "%DEST%\claude.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeYolo\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k claude --dangerously-skip-permissions" /f >nul

    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeYolo" /v "MUIVerb" /t REG_SZ /d "Claude Code (Yolo)" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeYolo" /v "Icon" /t REG_SZ /d "%DEST%\claude.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeYolo\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k claude --dangerously-skip-permissions" /f >nul
)

:: Add Claude Code (Custom) if selected
if %INSTALL_CLAUDE_CUSTOM%==1 (
    :: Registry key name is fixed (stable across renames and easy to clean up);
    :: only the displayed label is driven by the user's chosen name.
    :: Remove a legacy GLM-named entry so it does not linger in the menu.
    reg delete "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeGLM" /f >nul 2>&1
    reg delete "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeGLM" /f >nul 2>&1

    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeCustom" /v "MUIVerb" /t REG_SZ /d "Claude Code (!CUSTOM_NAME!)" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeCustom" /v "Icon" /t REG_SZ /d "%DEST%\claudecustom.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeCustom\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k \"%USERPROFILE%\.llm-cli\claude-custom.cmd\"" /f >nul

    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeCustom" /v "MUIVerb" /t REG_SZ /d "Claude Code (!CUSTOM_NAME!)" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeCustom" /v "Icon" /t REG_SZ /d "%DEST%\claudecustom.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeCustom\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k \"%USERPROFILE%\.llm-cli\claude-custom.cmd\"" /f >nul
)

:: Add Antigravity CLI if selected
if %INSTALL_ANTIGRAVITY%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Antigravity" /v "MUIVerb" /t REG_SZ /d "Antigravity CLI" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Antigravity" /v "Icon" /t REG_SZ /d "%DEST%\antigravity.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Antigravity\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k agy" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Antigravity" /v "MUIVerb" /t REG_SZ /d "Antigravity CLI" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Antigravity" /v "Icon" /t REG_SZ /d "%DEST%\antigravity.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Antigravity\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k agy" /f >nul
)

:: Add Qwen if selected
if %INSTALL_QWEN%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Qwen" /v "MUIVerb" /t REG_SZ /d "Qwen" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Qwen" /v "Icon" /t REG_SZ /d "%DEST%\qwen.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Qwen\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k qwen" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Qwen" /v "MUIVerb" /t REG_SZ /d "Qwen" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Qwen" /v "Icon" /t REG_SZ /d "%DEST%\qwen.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Qwen\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k qwen" /f >nul
)

:: Add Droid if selected
if %INSTALL_DROID%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Droid" /v "MUIVerb" /t REG_SZ /d "Droid" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Droid" /v "Icon" /t REG_SZ /d "%DEST%\droid.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Droid\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k droid" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Droid" /v "MUIVerb" /t REG_SZ /d "Droid" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Droid" /v "Icon" /t REG_SZ /d "%DEST%\droid.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Droid\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k droid" /f >nul
)

:: Add Opencode if selected
if %INSTALL_OPENCODE%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Opencode" /v "MUIVerb" /t REG_SZ /d "Opencode" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Opencode" /v "Icon" /t REG_SZ /d "%DEST%\opencode.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Opencode\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k opencode" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Opencode" /v "MUIVerb" /t REG_SZ /d "Opencode" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Opencode" /v "Icon" /t REG_SZ /d "%DEST%\opencode.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Opencode\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k opencode" /f >nul
)

:: Add Codebuff if selected
if %INSTALL_CODEBUFF%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Codebuff" /v "MUIVerb" /t REG_SZ /d "Codebuff" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Codebuff" /v "Icon" /t REG_SZ /d "%DEST%\codebuff.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Codebuff\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k codebuff" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Codebuff" /v "MUIVerb" /t REG_SZ /d "Codebuff" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Codebuff" /v "Icon" /t REG_SZ /d "%DEST%\codebuff.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Codebuff\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k codebuff" /f >nul
)

:: Add Kilo if selected
if %INSTALL_KILO%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Kilo" /v "MUIVerb" /t REG_SZ /d "Kilo" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Kilo" /v "Icon" /t REG_SZ /d "%DEST%\kilo.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Kilo\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k kilo" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Kilo" /v "MUIVerb" /t REG_SZ /d "Kilo" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Kilo" /v "Icon" /t REG_SZ /d "%DEST%\kilo.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Kilo\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k kilo" /f >nul
)

:: Add Codex CLI if selected
if %INSTALL_CODEX%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Codex" /v "MUIVerb" /t REG_SZ /d "Codex CLI" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Codex" /v "Icon" /t REG_SZ /d "%DEST%\codex.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Codex\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k codex" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Codex" /v "MUIVerb" /t REG_SZ /d "Codex CLI" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Codex" /v "Icon" /t REG_SZ /d "%DEST%\codex.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Codex\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k codex" /f >nul
)

echo              ^> Registry updated successfully
echo.

:: Add %USERPROFILE%\.llm-cli to user PATH so the ccc launcher can be called
:: from any terminal (cmd, PowerShell, Windows Terminal). Idempotent: skips
:: when the folder is already there. Uses reg add instead of setx to avoid
:: setx's 1024-char truncation on long PATH values.
if %INSTALL_CLAUDE_CUSTOM%==1 (
    echo   [Step 4/4] Registering "ccc" terminal command...
    set "LLM_CLI_DIR=%USERPROFILE%\.llm-cli"
    set "USER_PATH="
    for /f "usebackq tokens=2,*" %%A in (`reg query "HKCU\Environment" /v Path 2^>nul ^| findstr /i "Path"`) do set "USER_PATH=%%B"
    if not defined USER_PATH (
        reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!LLM_CLI_DIR!" /f >nul
        echo              ^> Added "!LLM_CLI_DIR!" to PATH ^(new user PATH^)
    ) else (
        echo("!USER_PATH!" | findstr /i /c:".llm-cli" >nul
        if errorlevel 1 (
            if "!USER_PATH:~-1!"==";" (
                reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!USER_PATH!!LLM_CLI_DIR!" /f >nul
            ) else (
                reg add "HKCU\Environment" /v Path /t REG_EXPAND_SZ /d "!USER_PATH!;!LLM_CLI_DIR!" /f >nul
            )
            echo              ^> Added "!LLM_CLI_DIR!" to PATH
        ) else (
            echo              ^> "!LLM_CLI_DIR!" already on PATH - nothing to do
        )
    )
    echo              ^> Open a NEW terminal and type: ccc
    echo.
)

echo   ================================================================
echo.
echo                    INSTALLATION COMPLETE!
echo.
echo   ================================================================
echo.
echo   Installed tools:
echo.
if %INSTALL_CLAUDE%==1 echo       [+] Claude Code / Claude Code (Yolo)
if %INSTALL_CLAUDE_CUSTOM%==1 echo       [+] Claude Code ^(!CUSTOM_NAME!^)
if %INSTALL_ANTIGRAVITY%==1 echo       [+] Antigravity CLI
if %INSTALL_QWEN%==1 echo       [+] Qwen
if %INSTALL_DROID%==1 echo       [+] Droid
if %INSTALL_OPENCODE%==1 echo       [+] Opencode
if %INSTALL_CODEBUFF%==1 echo       [+] Codebuff
if %INSTALL_KILO%==1 echo       [+] Kilo
if %INSTALL_CODEX%==1 echo       [+] Codex CLI
echo.
echo   ----------------------------------------------------------------
echo.
echo   Right-click on any folder to see the "Open with AI CLI" menu.
if %INSTALL_CLAUDE_CUSTOM%==1 echo   Claude Code ^(!CUSTOM_NAME!^) is also available as a terminal command: ccc
echo   To uninstall, run: uninstall.bat
echo.
pause
