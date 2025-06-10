@echo off
echo Downloading Jakarta Servlet API...

:: Create lib directory if not exists
if not exist "lib" mkdir lib

:: Download Jakarta Servlet API 6.0.0
echo Downloading jakarta.servlet-api-6.0.0.jar...
curl -L -o "lib/jakarta.servlet-api-6.0.0.jar" "https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar"

if %errorlevel% == 0 (
    echo Download completed successfully!
    echo File saved to: lib/jakarta.servlet-api-6.0.0.jar
) else (
    echo Download failed! Please download manually from:
    echo https://repo1.maven.org/maven2/jakarta/servlet/jakarta.servlet-api/6.0.0/jakarta.servlet-api-6.0.0.jar
)

pause 