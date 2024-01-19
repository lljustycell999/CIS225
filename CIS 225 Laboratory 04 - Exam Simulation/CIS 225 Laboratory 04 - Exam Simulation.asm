;   NAME:		Justyce Countryman
;	
;   Due Date:		Monday March 21, 2022
;
;   Project Name:	Laboratory 04
;
;   Program Description: This program will process a multiple choice test. The program 
;   will allow the user to enter their name and their valid answers to the questions.
;   Finally, the program will display a grade summary report that includes the 
;   percentage and letter grade. The answer key will hold 12 answers that are between
;   'A' and 'D' inclusive. The valid student answers must also be between 'A' and 'D' 
;   inclusive  
;
;   Project Number:	Project 04

include Irvine32.inc

.386
;.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	
	;Inputs
	namePmp			byte	"Enter your name: ", 0
	studentName		word	80 DUP(?)
	ansPmp			byte	"Enter your capitalized answer (A, B, C, or D): ", 0
	studentAns		word	?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?
	ansKey			word	'A', 'B', 'C', 'A', 'A', 'D', 'B', 'C', 'A', 'A', 'D', 'D'
	nmUnits			word	[($ - OFFSET namePmp) / 2]

	;Outputs
	ansError		byte	"You entered an invalid answer, try again!", 0
	numCorrect		word	?
	numWrong		word	?
	percentScore		word	?
	letterGrade		byte	?
	percentPmp		byte	"Your grade for this test (as a percentage) is: ", 0
	letterPmp		byte	"Your grade for this test (as a letter) is: ", 0

.code
main proc
		
	;Get Student Name
	mov     ecx, 18
	mov	edx, OFFSET namePmp
	call	GetStudentName
	
	;Get Valid Answers
	mov	ecx, 12
	mov	esi, OFFSET studentAns
	call	GetValidAnswers

	;Grade Each Answer
	mov	ecx, 12
	mov	esi, OFFSET studentAns
	mov     edx, OFFSET ansKey
	mov	al, [edx]
	mov     bl, [esi]
	call	GradeEachAnswer

	;Calculate Percent
	mov	ax, numCorrect
	call	CalculatePercent

	;Determine Letter Grade
	call	DetermineLetterGrade

	;Display Grade Summary
	mov	esi, OFFSET studentName
	call	DisplayGradeSummary

	invoke ExitProcess,0
main endp

GetStudentName proc
		
	;Displays only a limited number of characters
	call	WriteString
	mov	edx, OFFSET studentName
	call	ReadString
	;mov	studentName, ax

	ret
GetStudentName endp

GetValidAnswers proc
		
	lp1:	mov	edx, OFFSET ansPmp
		call	WriteString
		call	ReadChar
		call	WriteChar
		call	Crlf
		cmp	al, 'A'
		jb	error
		cmp	al, 'D'
		ja	error
		mov	[esi], ax
		add     esi, 2
		cmp     ecx, 1
		je	finished
		loop	lp1

	error:  mov	edx, OFFSET ansError
		call	WriteString
		call	Crlf
		jmp	lp1
		
	finished:       ret
GetValidAnswers endp

GradeEachAnswer proc
		
	lp2: 	 cmp	al, bl
	 	 je	correct
	 	 jne	wrong

	correct: add	numCorrect, 1
		 cmp	ecx, 1
		 je	graded
		 add    esi, 2
		 add    edx, 2
		 mov    al, [edx]
		 mov    bl, [esi]
		 loop	lp2

	wrong:	 add	numWrong, 1
		 cmp	ecx, 1
		 je	graded
		 add	esi, 2
		 add	edx, 2
		 mov	al, [edx]
		 mov	bl, [esi]
		 loop	lp2

	graded:	 ret
GradeEachAnswer endp

CalculatePercent proc
		
	mov	bx, 100
	mul	bx
	mov	bx, 12
	mov	dx, 0
	div	bx
	mov	percentScore, ax

	ret
CalculatePercent endp

DetermineLetterGrade proc
		
	cmp	ax, 90
	jae	gradeA
	cmp	ax, 80
	jae	gradeB
	cmp	ax, 70
	jae	gradeC
	cmp	ax, 60
	jae	gradeD
	mov	letterGrade, 'F'
	jmp	gradeReady
		
	gradeA: mov	letterGrade, 'A'
		jmp	gradeReady
	
	gradeB: mov	letterGrade, 'B'
		jmp	gradeReady
	
	gradeC: mov	letterGrade, 'C'
		jmp	gradeReady
	
	gradeD: mov	letterGrade, 'D'
		jmp	gradeReady
	
	gradeReady:	ret
DetermineLetterGrade endp

DisplayGradeSummary proc
		
	mov	edx, OFFSET studentName
	call	WriteString
	call	Crlf
	mov	edx, OFFSET percentPmp
	call	WriteString
	mov	ax, percentScore
	call	WriteDec
	call	Crlf
	mov	edx, OFFSET letterPmp
	call	WriteString
	mov	al, letterGrade
	call	WriteChar
	call	Crlf

	ret
DisplayGradeSummary endp
end main
