@echo off

set pwd=%cd%
echo set pwd = %pwd%

set args=0
for %%x in (%*) do (
    set /A args+=1
)

if %args% Geq 1 goto :SET_TOP_MODULE_BY_ARG

for %%A in ("%pwd%") do (
    set top_module=%%~nxA
)
goto :SET_TOP_MODULE_OK

:SET_TOP_MODULE_BY_ARG
set top_module=%1
if "%top_module:~-2%" == ".v" (
    set top_module=%top_module:~0,-2%
)

:SET_TOP_MODULE_OK
echo set top module = %top_module%

set src_file=%top_module%.v
set src_out_file=%top_module%.out
set tb_file=tb_%top_module%.v
set tb_out_file=tb_%top_module%.out
set wave_out_file=tb_%top_module%.vcd

if Not Exist %src_file% goto :ERROR_SRC_FILE

echo compile %src_file% -^> %src_out_file% ...
iverilog -y . -s %top_module% -o %src_out_file% %src_file%
if ERRORLEVEL 1 goto :END

If Not Exist %tb_file% goto :NO_TESTBENCH

echo compile %tb_file% -^> %tb_out_file% ...
iverilog -y . -s tb_%top_module% -o %tb_out_file% %src_file% %tb_file%
if ERRORLEVEL 1 goto :END

echo simulate %tb_out_file ...
vvp %tb_out_file%
if ERRORLEVEL 1 goto :END

echo open gtkwave for %wave_out_file% ...
start gtkwave %wave_out_file%

goto :END

:NO_TESTBENCH
echo [WARNING] testbench file %tb_file% not found.
goto :END

:ERROR_SRC_FILE
echo source file %src_file% not found.
goto :END

:END
