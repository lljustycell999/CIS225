;   NAME:			Justyce Countryman
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
		
		person1Dates    byte 80 DUP(80 DUP(?))
		person1Spending dword 80 DUP(?)
		person2Dates    byte 80 DUP(80 DUP(?))
		person2Spending dword 80 DUP(?)
		entrySizes      dword 2 DUP(?)
		totals          dword 2 DUP(?)
		names           byte  2 DUP(40 DUP(?))
		done            byte  ?
		namePmp         byte "Enter the spender's name: ", 0
		donePmp         byte "Are you done (Y/N): ", 0 
		datePmp         byte "Enter the date of the spending entry: ", 0
		spendingPmp     byte "Enter the amount of the spending entry (IN PENNIES): ", 0

.code
main proc

        ;Get First Name
		mov    edx, OFFSET namePmp
		call   WriteString
		mov    ecx, 40
		mov    edx, OFFSET names
		call   GetName
		
		mov    done, 'Q'
		.while(done != 'Y')

			;Get Spending Entries for First Person 
			mov     edx, OFFSET datePmp
			call    WriteString
			mov     ecx, 80
			mov     esi, OFFSET person1Dates
			call    GetEntryInformation

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

		;Get Second Name
		mov    edx, OFFSET namePmp
		call   WriteString
		mov    ecx, 40
		mov    edx, OFFSET names
		add    edx, 40
		call   GetName

		mov    done, 'Q'
		.while(done != 'Y')

			;Get Spending Entries for Second Person
			mov     edx, OFFSET datePmp
			call    WriteString
			mov     ecx, 80
			mov     esi, OFFSET person2Dates
			call    GetEntryInformation

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
		        mov     done, al

		    .endw

        .endw

		;Display Summary
		mov    esi, OFFSET names
		mov    edx, [esi]
		call   WriteString
		
		call   Crlf

		add    esi, 1
		mov    edx, [esi]
		call   WriteString

		invoke ExitProcess,0
main endp


GetName proc uses edx esi eax

		call    ReadString
		call    Crlf
		call    WriteString
		call    Crlf

        ret
GetName endp

GetEntryInformation proc
		
		call    ReadString
		call    Crlf
		mov     edx, OFFSET spendingPmp
		call    WriteString
		call    ReadDec
		call    Crlf

		ret
GetEntryInformation endp

DisplaySummary proc


		ret
DisplaySummary endp

end main