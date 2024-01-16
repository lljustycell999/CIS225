;   NAME:		Justyce Countryman
;	
;   Due Date:		Monday May 9, 2022
;
;   Project Name:	Laboratory 08
;
;   Program Description: This program will repeatedly ask the user for a base and an exponent to convert. 
;   The base needs to be between 2 and 16. The program will then process the conversion and display the
;   result.
;
;   Project Number:	Project 08

include Irvine32.inc

.386
;.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	
	;Input
	basePmp	        byte "Enter a base number between 2 and 16: ", 0
	base            word ?
	exponentPmp     byte "Enter an exponent that is positive (Negative values will result in a conversion of 0): ", 0
	exponent        word ?
	donePmp         byte "Are you done (Y/N)? ", 0
	done            byte ?

	;Output
	numRemainders   word ?
	conversionPmp   byte "Based on your base 10 number and desired base, the converted value is: ", 0
	zeroPmp         byte "The base 10 number of 0 is the same as 0 in any other base! Try another number", 0

.code
main proc
		
	mov     done, 'Q'
	.while(done != 'Y')

		;Get Exponent
		push    OFFSET exponent 	; [ebp + 16]
		push    OFFSET exponentPmp 	; [ebp + 12]
		push    OFFSET zeroPmp 		; [ebp + 8]
	    	call    GetExponentNumber

		;Get Base
		push    OFFSET base 		; [ebp + 12]
		push    OFFSET basePmp 		; [ebp + 8]
		call    GetBase

		;Perform Conversion
		push    base 			; [ebp + 14]
		push    exponent 		; [ebp + 12]
		push    OFFSET numRemainders 	; [ebp + 8]
		call    PerformConversion

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
		
		enter  0, 0
		pushad

		mov    ax, 0
        .while(ax == 0)
		    
			mov     edx, [ebp + 12]
            call    WriteString
            call    ReadDec

            .if(ax == 0)
			
                mov     edx, [ebp + 8]
                call    WriteString
                call    Crlf
                call    Crlf

			.endif
			      
        .endw
		mov     ebx, [ebp + 16]
        mov     [ebx], ax
		popad
		leave

            ret    12
GetExponentNumber endp

GetBase proc
        
		enter   0, 0
		pushad

		mov     ax, -1
		.while(ax < 2 || ax > 16)
		    
			mov     edx, [ebp + 8]
		    call    WriteString
		    call    ReadDec

		.endw
		call    Crlf
		mov     ebx, [ebp + 12]
		mov     [ebx], ax
		popad
		leave

            ret    8
GetBase endp

PerformConversion proc
		
		enter   4, 0 ;[EBP - 4]
		;pushad

		;mov     cx, 0
		mov     ax, WORD PTR[ebp + 12]
		mov     bx, WORD PTR[ebp + 14]
		.if(ax != 0)

		    mov     edx, 0
		    div     bx
		    mov		[ebp - 4], edx
			
			push    WORD PTR[ebp + 14]
			push    ax
			push    DWORD PTR[ebp + 8]
		    call    PerformConversion

		    mov	    ebx, [ebp - 4]
			;mov	    ebx, [esi]
		    .if(bx == 10)
		        mov     al, 'A'
				call    WriteChar
		    .elseif(bx == 11)
				mov     al, 'B'
		        call    WriteChar
		    .elseif(bx == 12)
		        mov     al, 'C'
				call    WriteChar
		    .elseif(bx == 13)
		        mov     al, 'D'
				call	WriteChar
		    .elseif(bx == 14)
		        mov     al, 'E'
				call    WriteChar
		    .elseif(bx == 15)
		        mov     al, 'F'
				call    WriteChar
			.else
			    movzx     eax, bl
				call    WriteDec

		    .endif
		    
		.endif
		;popad
		leave

            ret    10
PerformConversion endp

end main
