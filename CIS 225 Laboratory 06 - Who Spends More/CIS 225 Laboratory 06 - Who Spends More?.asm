;   NAME:		Justyce Countryman
;	
;   Due Date:		Friday April 15, 2022
;
;   Project Name:	Laboratory 06
;
;   Program Description: This program will determine spending totals for two different people.
;   The program will first ask for a name and then as many spending entries as wanted by the 
;   user. A spending entry will include a date and an amount. The name will be up to 40 
;   characters and the user may input up to 80 different spending entries. The program will 
;   display the name of the person prior to asking for the spending entries of that person. 
;   After all user input is provided, the program will have a total amount spent for both 
;   people. With this, the program will then display a summary that includes the names, 
;   spending entries, and totals for both people.
;
;   Project Number:	Project 06

include Irvine32.inc

.386
;.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
		
	person1Dates    byte  80 DUP(80 DUP(?))
	person1Spending dword 80 DUP(?)
	person2Dates    byte  80 DUP(80 DUP(?))
	person2Spending dword 80 DUP(?)
	entrySizes      dword 2 DUP(?)
	totals          dword 2 DUP(?)
	names           byte  2 DUP(40 DUP(?))
	done            byte  ?
	namePmp         byte  "Enter the spender's name: ", 0
	donePmp         byte  "Are you done (Y/N): ", 0 
	datePmp         byte  "Enter the date of the spending entry: ", 0
	spendingPmp     byte  "Enter the amount of the spending entry (IN PENNIES): ", 0
	totalPmp        byte  "Your total spent is: ", 0

.code
main proc

        ;Get First Name
	mov    esi, OFFSET names
	mov    edx, OFFSET namePmp
	mov    ecx, 40
	call   GetName
	
	;Get Second Name
	mov    esi, OFFSET names
	add    esi, 40
	mov    edx, OFFSET namePmp
	mov    ecx, 40
	call   GetName

	;Confirmation (may remove later)
	mov    [entrySizes], 0
	mov    [entrySizes + 4], 0
	mov    [totals], 0
	mov    [totals + 4], 0

	;Process First Person
	mov    done, 'Q'
	mov    esi, OFFSET person1Dates
	mov    edi, OFFSET person1Spending
	.while(done != 'Y')

		;Get Spending Entries for First Person 
		mov     edx, OFFSET datePmp
		call    WriteString
		mov     ecx, 80
		call    GetEntryInformation
		add     [entrySizes], 1
		add     esi, 80
		add     edi, 4

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

	;Calculate Total for First Person
	mov     esi, OFFSET totals
	mov     edi, OFFSET person1Spending
	mov     ecx, [entrySizes]
	.while(ecx != 0)
		call    ComputeTotal
		dec     ecx
	.endw

	;Process Second Person
	mov     done, 'Q'
	mov     esi, OFFSET person2Dates
	mov     edi, OFFSET person2Spending
	.while(done != 'Y')

		;Get Spending Entries for Second Person
		mov     edx, OFFSET datePmp
		call    WriteString
		mov     edx, OFFSET person2Dates
		mov     ecx, 80
		call    GetEntryInformation
		add     [entrySizes + 4], 1
            	add     esi, 80
		add     edi, 4

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
	call    Crlf

	;Calculate Total for Second Person
	mov     esi, OFFSET totals
	add     esi, 4
	mov     edi, OFFSET person2Spending
	mov     ecx, [entrySizes + 4]
	.while(ecx != 0)
		call    ComputeTotal
		dec	ecx
	.endw

	;Display Summary
	mov    esi, OFFSET names
	mov    ecx, [entrySizes]
	mov    edx, esi
	call   WriteString
	call   Crlf
	mov    esi, OFFSET person1Dates
	mov    edi, OFFSET person1Spending
	call   DisplaySummary
	mov    edx, OFFSET totalPmp
	call   WriteString
	mov    eax, [totals]
	mov    ebx, 100
	mov    edx, 0
	div    ebx
	call   WriteDec
	mov    al, '.'
	call   WriteChar
	mov    eax, edx
	.if(eax >= 10)
		call   WriteDec
	.else

		mov    al, '0'
		call   WriteChar
		mov    eax, edx
		call   WriteDec

	.endif
	call   Crlf
	call   Crlf

	mov    esi, OFFSET names
	add    esi, 40
	mov    ecx, [entrySizes + 4]
	mov    edx, esi
	call   WriteString
	call   Crlf
	mov    esi, OFFSET person2Dates
	mov    edi, OFFSET person2Spending
	mov    ebx, [totals + 4]
	call   DisplaySummary
	mov    edx, OFFSET totalPmp
	call   WriteString
	mov    eax, [totals + 4]
	mov    ebx, 100
	mov    edx, 0
	div    ebx
	call   WriteDec
	mov    al, '.'
	call   WriteChar
	mov    eax, edx
	.if(eax >= 10)
		call   WriteDec
	.else

		mov    al, '0'
		call   WriteChar
		mov    eax, edx
		call   WriteDec

	.endif

	invoke ExitProcess,0
main endp


GetName proc uses edx esi eax

	call    WriteString
	mov     edx, esi
	call    ReadString
	call    Crlf
	call    WriteString
	call    Crlf

        ret
GetName endp

GetEntryInformation proc uses edi eax
		
	mov     edx, esi
	call    ReadString
	call    Crlf
	mov     edx, OFFSET spendingPmp
	call    WriteString
	call    ReadDec
	mov     [edi], eax
	call    Crlf

	ret
GetEntryInformation endp

ComputeTotal proc uses esi
		
	mov    eax, [edi]
	add    [esi], eax
	add    edi, 4

	ret
ComputeTotal endp

DisplaySummary proc uses eax ebx ecx edx esi edi

	.while(ecx != 0)

	    mov    edx, esi
	    call   WriteString
	    mov    al, ' '
	    call   WriteChar
	    mov    eax, [edi]
	    mov    ebx, 100
	    mov    edx, 0
	    div    ebx
	    call   WriteDec
	    mov    al, '.'
	    call   WriteChar
	    mov    eax, edx
	    .if(eax >= 10)
		call   WriteDec
	    .else

		mov    al, '0'
		call   WriteChar
		mov    eax, edx
		call   WriteDec

	    .endif
	    call   Crlf
	    add    esi, 80
	    add    edi, 4
	    dec    ecx

	.endw

	ret
DisplaySummary endp

end main
