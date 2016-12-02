@echo off
cls

set EXE_NAME=interpolate_driver
del %EXE_NAME%.exe
del %EXE_NAME%.obj
del %EXE_NAME%.lst
del %EXE_NAME%.ilk
del %EXE_NAME%.pdb

set DRIVE_LETTER=%1:
set PATH=%DRIVE_LETTER%\Assembly\bin;c:\Windows;c:\Windows\system32
set INCLUDE=%DRIVE_LETTER%\Assembly\include
set LIB_DIRS=%DRIVE_LETTER%\Assembly\lib
set LIBS=

ml -c -coff %EXE_NAME%.asm
ml -c -coff interpolate.asm
ml -c -coff compute_bs.asm
ml -c -coff evaluatePolynomial.asm

link /libpath:%LIB_DIRS% %EXE_NAME%.obj interpolate_sort.obj interpolate.obj compute_bs.obj evaluatePolynomial.obj compare_floats.obj ftoaproc.obj atofproc.obj %LIBS% io.obj kernel32.lib /debug /out:%EXE_NAME%.exe /subsystem:console /entry:start
%EXE_NAME% <points.txt
