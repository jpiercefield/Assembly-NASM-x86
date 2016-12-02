.NOLIST      ; turn off listing
.386

EXTRN compare_floats_proc : Near32

compare_floats	   MACRO f1, f2, tol, xtra

                   IFB <f1>
                      .ERR <missing "f1" operand in compare_floats>
                   ELSEIFB <f2>
                      .ERR <missing "f2" operand in compare_floats>
                   ELSEIFB <tol>
                      .ERR <missing "tol" operand in compare_floats>
                   ELSEIFNB <xtra>
                      .ERR <extra operand(s) in compare_floats>
                   ELSE

                         push f1
                         push f2
                         push tol
                         call compare_floats_proc

                   ENDIF

		ENDM

.NOLISTMACRO ; suppress macro expansion listings
.LIST        ; begin listing