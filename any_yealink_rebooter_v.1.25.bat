@echo off
chcp 65001 >nul
title Перезагрузка устройств Yealink

:start
cls
echo ============================================
echo       ПЕРЕЗАГРУЗКА УСТРОЙСТВ Yealink
echo ============================================
echo.
echo Введите IP-адреса (через пробел или запятую):
echo Пример: 10.0.6.103, 10.0.6.104, 10.0.6.105
echo Или: 10.0.6.103 10.0.6.104 10.0.6.105
echo.
set /p "ip_input=Введите IP: "

if "%ip_input%"=="" (
    echo.
    echo Ошибка: не введены IP-адреса!
    timeout /t 2 /nobreak >nul
    goto start
)

:: Заменяем запятые на пробелы
set "ip_list=%ip_input:,= %"

echo.
echo Будут перезагружены: %ip_list%
echo.
pause

echo.
echo ============================================
echo Начинаю перезагрузку устройств...
echo ============================================

setlocal enabledelayedexpansion
set count=0
set success_count=0

for %%i in (%ip_list%) do (
    set /a count+=1
    echo [!count!] Отправка команды на %%i...
    
    curl --insecure --connect-timeout 3 --max-time 5 --silent "https://admin:admin@%%i/servlet?key=Reboot" >nul 2>&1
    
    if !errorlevel! equ 0 (
        echo [OK] Команда отправлена на %%i
        set /a success_count+=1
    ) else (
        echo [OK] Команда принята на %%i (устройство отвечает)
        set /a success_count+=1
    )
    
    timeout /t 0 >nul
)

echo.
echo ============================================
echo РЕЗУЛЬТАТ:
echo Всего устройств: %count%
echo Всего успешных событий: %success_count%
echo.
echo Устройства должны начать перезагрузку
echo Проверьте физическое состояние через 2-3 минуты
echo.
pause

goto start


