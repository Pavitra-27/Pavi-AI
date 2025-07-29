@echo off
echo ========================================
echo Oracle Database XE Installation Helper
echo ========================================
echo.

echo This script will help you set up Oracle Database XE for your WMS PL/SQL project.
echo.

echo Step 1: Download Oracle Database XE
echo -----------------------------------
echo Opening Oracle download page...
start https://www.oracle.com/database/technologies/xe-downloads.html
echo.
echo Please download "Oracle Database 21c Express Edition" for Windows x64
echo You will need to create a free Oracle account if you don't have one.
echo.
pause

echo.
echo Step 2: Download Oracle SQL Developer
echo -------------------------------------
echo Opening SQL Developer download page...
start https://www.oracle.com/database/sqldeveloper/technologies/download/
echo.
echo Please download "Oracle SQL Developer" (ZIP file)
echo.
pause

echo.
echo Step 3: Installation Instructions
echo --------------------------------
echo.
echo After downloading:
echo 1. Run Oracle Database XE installer as Administrator
echo 2. Use default installation directory
echo 3. Set password: WmsAdmin2024!
echo 4. Use default port: 1521
echo 5. Complete installation (10-15 minutes)
echo.
echo For SQL Developer:
echo 1. Extract ZIP file to C:\sqldeveloper
echo 2. Run sqldeveloper.exe
echo 3. Set Java Home if prompted
echo.
pause

echo.
echo Step 4: Database Setup
echo ----------------------
echo.
echo After installation, you need to:
echo 1. Open SQL Developer
echo 2. Connect as SYSTEM user with your password
echo 3. Run setup_wms_database.sql to create WMS user
echo 4. Connect as WMS user
echo 5. Run your order mangement script
echo 6. Run test_wms_installation.sql to verify everything works
echo.
echo Connection details for WMS user:
echo - Host: localhost
echo - Port: 1521
echo - SID: XE
echo - Username: wms_user
echo - Password: wms_password2024
echo.
pause

echo.
echo Step 5: Useful Commands
echo -----------------------
echo.
echo To start Oracle service manually:
echo net start OracleServiceXE
echo.
echo To check if Oracle is running:
echo sc query OracleServiceXE
echo.
echo To connect via SQL*Plus:
echo sqlplus wms_user/wms_password2024@localhost:1521/XE
echo.
pause

echo.
echo ========================================
echo Setup instructions completed!
echo ========================================
echo.
echo Next steps:
echo 1. Install Oracle Database XE
echo 2. Install SQL Developer
echo 3. Run the setup scripts
echo 4. Test your WMS system
echo.
echo For detailed instructions, see Oracle_Database_Setup_Guide.md
echo.
pause 