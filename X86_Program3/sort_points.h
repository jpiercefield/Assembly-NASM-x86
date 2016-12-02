.NOLIST
.386

EXTRN sort_points_proc : Near32
EXTRN print_points_proc : Near32

; points_array is the array name, not the address, num_points is a WORD
print_points	   MACRO points_array, num_points, xtra

                   IFB <points_array>
                      .ERR <missing "points_array_addr" operand in print_points>
                   ELSEIFB <num_points>
                      .ERR <missing "num_points" operand in print_points>
                   ELSEIFNB <xtra>
                      .ERR <extra operand(s) in print_points>
                   ELSE

                         push ebx
                            lea ebx, points_array
                            push ebx
                            push num_points
                            call print_points_proc
                         pop ebx

                   ENDIF

		ENDM

sort_points	   MACRO points_array, x_comp, tol, num_points, xtra

                   IFB <points_array>
                      .ERR <missing "points_array_addr" operand in sort_points>
                   ELSEIFB <x_comp>
                      .ERR <missing "x_comp" operand in sort_points>
                   ELSEIFB <tol>
                      .ERR <missing "tol" operand in sort_points>
                   ELSEIFB <num_points>
                      .ERR <missing "num_points" operand in sort_points>
                   ELSEIFNB <xtra>
                      .ERR <extra operand(s) in sort_points>
                   ELSE

                         push ebx
                            lea ebx, points_array
                            push ebx
                            push x_comp
                            push tol
                            push num_points
                            call sort_points_proc
                         pop ebx

                   ENDIF

		ENDM

.NOLISTMACRO
.LIST