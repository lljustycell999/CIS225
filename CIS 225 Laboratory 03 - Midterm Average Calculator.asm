;   NAME:		Justyce Countryman
;	
;   Due Date:		Friday March 11, 2022
;
;   Project Name:	Laboratory 03
;
;   Program Description: This program will calculate a midterm average that processes four 
;   laboratory grades, three quiz grades, two homework grades, and one examination grade. 
;   All grades are out of 100 points, except for the exam grade, which is out of 127 points.
;   This program will first calculate averages for labs, quizzes, and homeworks immediately 
;   once the program is given the necessary user input. The exam percentage will then be
;   calculated to determine an exam average once the program is given the necessary user 
;   input. Labs, quizzes, homeworks, and the exam are worth 35, 10, 10, and 25 percent 
;   respectively. Since these components only add up to 80 percent, the midterm average 
;   will be adjusted accordingly.
;
;   Project Number:	Project 03


Include Irvine32.inc

.386
;.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

	;Inputs
	labs        word ?, ?, ?, ?
	quizzes     word ?, ?, ?
	homeworks   word ?, ?
	exam        word ?
	labMsg      byte "Enter a lab grade: ", 0
	quizMsg     byte "Enter a quiz grade: ", 0
	homeworkMsg byte "Enter a homework grade: ", 0
	examMsg     byte "Enter an exam grade: ", 0
	nmUnits     word [($ - OFFSET labs) / 2]

	;Outputs
	labAvg      word ?
	quizAvg     word ?
	homeworkAvg word ?
	examAvg     word ?
	midtermAvg  word ?
	midtermMsg  byte "Your midterm average is: ", 0

.code
main proc

	mov    ecx, 4
	mov    esi, OFFSET labs
	mov    edx, OFFSET labMsg
	call   InputGrades

	mov    ecx, 3
	mov    esi, OFFSET quizzes
	mov    edx, OFFSET quizMsg
	call   InputGrades

	mov    ecx, 2
	mov    esi, OFFSET homeworks
	mov    edx, OFFSET homeworkMsg
	call   InputGrades

	mov    ecx, 1
	mov    esi, OFFSET exam
	mov    edx, OFFSET examMsg
	call   InputGrades

	mov    ecx, 4
	mov    esi, OFFSET labs
	call   ComputeAverages

	;Dump memory
	mov    esi, OFFSET labs
	movzx  ecx, nmUnits
	mov    ebx, 2
	call   DumpMem

	invoke ExitProcess,0
main endp

InputGrades proc

	        ;Input grades
	        mov    ax, 0
	lp1:    call   WriteString
        	call   ReadDec
	        mov    [esi], ax
	        add    esi, 2
	        loop   lp1		
	        ret

InputGrades endp

ComputeAverages proc

		;Total up each grade component and calculate their averages
	
		;Total lab points
		mov    ax, 0
	lp2:	add    ax, [esi]
		add    esi, 2
		loop   lp2
	
		;Calculate lab average
		mov    bx, 4
		mov    dx, 0
		div    bx
		mov    labAvg, ax
	
		;Total quiz points
		mov	 ax, 0
		mov    ecx, 3
		mov    esi, OFFSET quizzes
	lp3:	add    ax, [esi]
		add    esi, 2
		loop   lp3
		
		;Calculate quiz average
		mov    bx, 3
		mov    dx, 0
		div    bx
		mov    quizAvg, ax
	
		;Total homework points
		mov    ax, 0
		mov    ecx, 2
		mov    esi, OFFSET homeworks
	lp4:	add    ax, [esi]
		add    esi, 2
		loop   lp4
	
		;Calculate homework average
		mov    bx, 2
		mov    dx, 0
		div    bx
		mov    homeworkAvg, ax
	
		;Total exam points
		mov    ecx, 1
		mov    ax, exam
	
		;Calculate exam average
		mov    bx, 100
		mul    bx
		mov    bx, 127
		mov    dx, 0
		div    bx
		mov    examAvg, ax
	
		;Calculate midterm average
		mov    bx, 25
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		push   dx
		mov    midtermAvg, ax
	
		mov    ax, homeworkAvg
		mov    bx, 10
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		push   dx
		add    midtermAvg, ax
	
		mov    ax, quizAvg
		mov    bx, 10
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		push   dx
		add    midtermAvg, ax
	
		mov    ax, labAvg
		mov    bx, 35
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		push   dx
		add    midtermAvg, ax
	
		;Display output with midterm average rounded to two decimal places
		pop    ax
		mov    bx, 100
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		mov    cx, ax
	
		pop    ax
		mov    bx, 100
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		add    cx, ax
	
		pop    ax
		mov    bx, 100
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		add    cx, ax
	
		pop    ax
		mov    bx, 100
		mul    bx
		mov    bx, 80
		mov    dx, 0
		div    bx
		add    cx, ax
	
		mov    ax, cx
		mov    bx, 100
		mov    dx, 0
		div    bx
		push   dx
		add    midtermAvg, ax
	
		mov    edx, OFFSET midtermMsg
		call   WriteString
		mov    ax, midtermAvg
		call   WriteDec
		mov    al, '.'
		call   WriteChar
		pop    ax
		call   WriteDec
		call   Crlf
	
		ret 
ComputeAverages endp

end main
