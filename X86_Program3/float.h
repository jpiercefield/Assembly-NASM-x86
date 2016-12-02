.NOLIST      ; turn off listing
.386

EXTRN ftoaproc : Near32
EXTRN atofproc : Near32

ftoa	MACRO float, places, field, str, xtra

                  IFB <float>
                     .ERR <missing "float" operand in ftoa>
                  ELSEIFB <str>
                     .ERR <missing "string" operand in ftoa>
                  ELSEIFB <places>
                     .ERR <missing "places" operand in ftoa>
                  ELSEIFB <field>
                     .ERR <missing "field" operand in ftoa>
                  ELSEIFNB <xtra>
                     .ERR <extra operand(s) in ftoa>
                  ELSE

                      push ebx

                         pushd float
                         pushw places
                         pushw field
                         lea ebx, str
                         push ebx
                         call ftoaproc

                      pop ebx

                  ENDIF

	ENDM

atof	MACRO str, float, xtra

                   IFB <str>
                      .ERR <missing "string" operand in atof>
                   ELSEIFB <float>
                      .ERR <missing "float" operand in atof>
                   ELSEIFNB <xtra>
                      .ERR <extra operand(s) in atof>
                   ELSE

                      push ebx

                         lea ebx, str
                         push ebx
                         call atofproc

                      pop ebx

                      fstp float 

                   ENDIF

	ENDM


.NOLISTMACRO ; suppress macro expansion listings
.LIST        ; begin listing