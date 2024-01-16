;   NAME:			Justyce Countryman
;	
;   Due Date:		Friday April 8, 2022
;
;   Project Name:	Laboratory 05
;
;   Program Description: This program will repeatedly ask the user for a base and an exponent to convert. 
;   The base needs to be between 2 and 16. The program will then process the conversion and display the
;   result.
;
;   Project Number:	Project 05

include Irvine32.inc

.386
;.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	
	;Input
	basePmp	        byte "Enter a base number between 2 and 16: ", 0
	base            word ?
	exponentPmp     byte "Enter an exponent that is positive (Negative values will result in incorrect conversions): ", 0
	exponent        word ?
	donePmp         byte "Are you done (Y/N)? ", 0
	done            byte ?

	;Output
	numRemainders   word ?
	remainders      byte 50 DUP(?)
	conversionPmp   byte "Based on your base 10 number and desired base, the converted value is: ", 0
	zeroPmp         byte "The base 10 number of 0 is the same as 0 in any other base! Try another number", 0

.code
main proc
		
		mov     done, 'Q'
		.while(done != 'Y')

		    ;Get Exponent
		    call    GetExponentNumber

		    ;Get Base
		    mov     edx, OFFSET basePmp
		    call    GetBase

		    ;Perform Conversion
		    call    PerformConversion

		    ;Display Result
		    mov     edx, OFFSET conversionPmp
		    mov     esi, OFFSET remainders
		    mov     cx, numRemainders
		    call    DisplayResult

		    ;Check If Done
		    mov     edx, OFFSET donePmp
		    .if(done == 'N')
		        mov     done, 'Q'
		    .endif
		    .while(done != 'Y' && done != 'N')

		        call    WriteString
		        call    ReadChar
		        call    WriteChar
		        call    Crlf
		        call    Crlf
		        mov     done, al

		    .endw

		.endw

		invoke ExitProcess,0
main endp

GetExponentNumber proc
		
        mov     ax, 0
        .while(ax <= 0)

            mov     edx, OFFSET exponentPmp
            call    WriteString
            call    ReadDec
            mov     exponent, ax
            .if(ax == 0)
			
                mov     edx, OFFSET zeroPmp
                call    WriteString
                call    Crlf
                call    Crlf

            .endif

        .endw

            ret
GetExponentNumber endp

GetBase proc

		mov     ax, -1
		.while(ax < 2 || ax > 16)

		    call    WriteString
		    call    ReadDec

		.endw
		call    Crlf
		mov     base, ax

            ret
GetBase endp

PerformConversion proc
		
		mov     numRemainders, 0
		mov     ax, exponent
		mov     bx, base
		.while(ax != 0)

		    mov     dx, 0
		    div     bx
		    push    dx
		    inc     numRemainders

		.endw
		mov     esi, OFFSET remainders
		mov     cx, numRemainders
		.while(cx != 0)

		    pop     ax
		    .if(ax == 10)
		        mov     al, 'A'
		    .elseif(ax == 11)
		        mov     al, 'B'
		    .elseif(ax == 12)
		        mov     al, 'C'
		    .elseif(ax == 13)
		        mov     al, 'D'
		    .elseif(ax == 14)
		        mov     al, 'E'
		    .elseif(ax == 15)
		        mov     al, 'F'
		    .endif
		    dec     cx
		    mov     [esi], al
		    add     esi, 1

		.endw

            ret
PerformConversion endp

DisplayResult proc
		
        call    WriteString
        .while(cx != 0)

            mov     al, [esi]
            .if(al >= 10)

                call    WriteChar
                add     esi, 1
                dec     cx

            .else

                call    WriteDec
                add     esi, 1
                dec     cx

            .endif

        .endw
        call    Crlf

            ret
DisplayResult endp

end main