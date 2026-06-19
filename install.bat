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
set "INSTALL_CLAUDE_GLM=0"
set "INSTALL_GEMINI=0"
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

:: Claude Code (GLM)
echo   [2/9] Claude Code (GLM)
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_CLAUDE_GLM=1"
    echo         [+] Selected
    echo.
    echo         GLM Configuration:
    echo         Press Enter to keep defaults
    echo.
:glm_token_prompt
    set /p "GLM_TOKEN=         API Token (required): "
    if "!GLM_TOKEN!"=="" (
        echo         ^! API Token cannot be empty. Please try again.
        goto glm_token_prompt
    )
    set "GLM_BASE_URL="
    set /p "GLM_BASE_URL=         Base URL -> https://api.z.ai/api/anthropic (Press Enter to keep default): "
    if "!GLM_BASE_URL!"=="" set "GLM_BASE_URL=https://api.z.ai/api/anthropic"
    set "GLM_MODEL="
    set /p "GLM_MODEL=         Model (Press Enter => glm-5.2): "
    if "!GLM_MODEL!"=="" set "GLM_MODEL=glm-5.2"
    set "GLM_TIMEOUT=3000000"
    echo.
    echo         [OK] GLM configured
)
echo.

:: Gemini CLI
echo   [3/9] Gemini CLI
choice /C YN /N /M "         Install? [Y/N]: "
if errorlevel 2 (
    echo         [-] Skipped
) else (
    set "INSTALL_GEMINI=1"
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
set /a "TOTAL=INSTALL_CLAUDE+INSTALL_CLAUDE_GLM+INSTALL_GEMINI+INSTALL_QWEN+INSTALL_DROID+INSTALL_OPENCODE+INSTALL_CODEBUFF+INSTALL_KILO+INSTALL_CODEX"
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
echo   [Step 1/3] Creating directories...
if not exist "%USERPROFILE%\.llm-cli" mkdir "%USERPROFILE%\.llm-cli"
if not exist "%DEST%" mkdir "%DEST%"
echo              ^> %DEST%
echo.

:: Copy icons
echo   [Step 2/3] Copying icons...
copy /Y "%~dp0assets\cli.ico" "%DEST%\" >nul
if %INSTALL_CLAUDE%==1 copy /Y "%~dp0assets\claude.ico" "%DEST%\" >nul
if %INSTALL_CLAUDE_GLM%==1 (
    copy /Y "%~dp0assets\claudeglm.ico" "%DEST%\" >nul
    :: Generate claude-glm.cmd with user's credentials
    (
        echo @echo off
        echo set ANTHROPIC_AUTH_TOKEN=!GLM_TOKEN!
        echo set ANTHROPIC_BASE_URL=!GLM_BASE_URL!
        echo set API_TIMEOUT_MS=!GLM_TIMEOUT!
        echo set ANTHROPIC_DEFAULT_OPUS_MODEL=!GLM_MODEL!
        echo set ANTHROPIC_DEFAULT_HAIKU_MODEL=!GLM_MODEL!
        echo set ANTHROPIC_DEFAULT_SONNET_MODEL=!GLM_MODEL!
        echo claude
    ) > "%USERPROFILE%\.llm-cli\claude-glm.cmd"
)
if %INSTALL_GEMINI%==1 copy /Y "%~dp0assets\gemini.ico" "%DEST%\" >nul
if %INSTALL_QWEN%==1 copy /Y "%~dp0assets\qwen.ico" "%DEST%\" >nul
if %INSTALL_DROID%==1 copy /Y "%~dp0assets\droid.ico" "%DEST%\" >nul
if %INSTALL_OPENCODE%==1 copy /Y "%~dp0assets\opencode.ico" "%DEST%\" >nul
if %INSTALL_CODEBUFF%==1 copy /Y "%~dp0assets\codebuff.ico" "%DEST%\" >nul
if %INSTALL_KILO%==1 copy /Y "%~dp0assets\kilo.ico" "%DEST%\" >nul
if %INSTALL_CODEX%==1 copy /Y "%~dp0assets\codex.ico" "%DEST%\" >nul
echo              ^> Icons copied successfully
echo.

:: Apply registry entries
echo   [Step 3/3] Applying registry entries...

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

:: Add Claude GLM if selected
if %INSTALL_CLAUDE_GLM%==1 (
    :: Claude Code (GLM) - uses helper script to set env vars per session
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeGLM" /v "MUIVerb" /t REG_SZ /d "Claude Code (GLM)" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeGLM" /v "Icon" /t REG_SZ /d "%DEST%\claudeglm.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\ClaudeGLM\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k \"%USERPROFILE%\.llm-cli\claude-glm.cmd\"" /f >nul

    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeGLM" /v "MUIVerb" /t REG_SZ /d "Claude Code (GLM)" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeGLM" /v "Icon" /t REG_SZ /d "%DEST%\claudeglm.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\ClaudeGLM\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k \"%USERPROFILE%\.llm-cli\claude-glm.cmd\"" /f >nul
)

:: Add Gemini if selected
if %INSTALL_GEMINI%==1 (
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Gemini" /v "MUIVerb" /t REG_SZ /d "Gemini" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Gemini" /v "Icon" /t REG_SZ /d "%DEST%\gemini.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\shell\LLMCLI\shell\Gemini\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k gemini" /f >nul
    
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Gemini" /v "MUIVerb" /t REG_SZ /d "Gemini" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Gemini" /v "Icon" /t REG_SZ /d "%DEST%\gemini.ico" /f >nul
    reg add "HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\LLMCLI\shell\Gemini\command" /ve /t REG_SZ /d "wt.exe -d \"%%V\" cmd /k gemini" /f >nul
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

echo   ================================================================
echo.
echo                    INSTALLATION COMPLETE!
echo.
echo   ================================================================
echo.
echo   Installed tools:
echo.
if %INSTALL_CLAUDE%==1 echo       [+] Claude Code / Claude Code (Yolo)
if %INSTALL_CLAUDE_GLM%==1 echo       [+] Claude Code (GLM)
if %INSTALL_GEMINI%==1 echo       [+] Gemini CLI
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
echo   To uninstall, run: uninstall.bat
echo.
pause
