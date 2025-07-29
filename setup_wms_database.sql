-- WMS Database Setup Script
-- Run this as SYSTEM user after installing Oracle Database XE

-- Step 1: Create WMS User
CREATE USER wms_user IDENTIFIED BY wms_password2024;

-- Step 2: Grant necessary privileges
GRANT CONNECT, RESOURCE, CREATE SESSION TO wms_user;
GRANT CREATE TABLE, CREATE SEQUENCE, CREATE PROCEDURE, CREATE PACKAGE TO wms_user;
GRANT UNLIMITED TABLESPACE TO wms_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON wms_user.* TO wms_user;

-- Step 3: Grant system privileges for ODCINUMBERLIST
GRANT EXECUTE ON SYS.ODCINUMBERLIST TO wms_user;

-- Step 4: Create a tablespace for WMS data (optional but recommended)
CREATE TABLESPACE wms_data
DATAFILE 'wms_data.dbf'
SIZE 100M
AUTOEXTEND ON NEXT 10M MAXSIZE 1G;

-- Step 5: Set default tablespace for WMS user
ALTER USER wms_user DEFAULT TABLESPACE wms_data;

-- Step 6: Verify user creation
SELECT username, account_status, default_tablespace 
FROM dba_users 
WHERE username = 'WMS_USER';

-- Step 7: Show granted privileges
SELECT privilege FROM dba_sys_privs WHERE grantee = 'WMS_USER';

-- Connection string for SQL Developer:
-- Host: localhost
-- Port: 1521
-- SID: XE
-- Username: wms_user
-- Password: wms_password2024 