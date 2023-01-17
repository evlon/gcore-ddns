:: --------------------------------------------------------------
::	��Ŀ: CloudflareSpeedTest �Զ���������������¼
::	�汾: 1.0.4
::	����: XIU2
::	��Ŀ: https://github.com/XIU2/CloudflareSpeedTest
:: --------------------------------------------------------------
::  ���ܣ���ȡ����9��IP�����µ� s1.example.com  ~~ s9.example.com
::  ���ߣ�evlon
::  ��Ŀ�� https://github.com/evlon/gcore-ddns
:: --------------------------------------------------------------

@echo off
Setlocal Enabledelayedexpansion

:: ��ȡ�����ļ�
for /f "delims=" %%i in ('type "gcore-config.ini"^| find /i "="') do set %%i

:: ���� Gcore cdn IP
::python gip.py
echo '���� Gcore cdn IP ���'

:: ��������Լ���ӡ��޸� CloudflareST �����в�����echo.| ���������Զ��س��˳����򣨲�����Ҫ���� -p 0 �����ˣ�
echo.|CloudflareST.exe -o "result_ddns.txt" -f gcore-cdn-ip.txt -tl %TTL%

:: �жϽ���ļ��Ƿ���ڣ����������˵�����Ϊ 0
if not exist result_ddns.txt (
    echo.
    echo CloudflareST ���ٽ�� IP ����Ϊ 0���������沽��...
    goto :END
)

set /a n=0,idx=1
for /f "tokens=1 delims=," %%i in (result_ddns.txt) do (
    Set /a n+=1 
    if "%%i"=="" (
        echo.
        echo CloudflareST ���ٽ�� IP ����Ϊ 0���������沽��...
        goto :END
    )
    If !n! geq 2 if !idx! leq 9 (
        :: ע�����
        python gdns.py --token .gcore-api-token --domain %ZONE% --sub %SUB%!idx! --value %%i --ttl 120
        set /a idx+=1
    )
    
)
:END
pause
