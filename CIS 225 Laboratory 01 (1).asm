;	NAME:			Justyce Countryman
;	
;	Due Date:		Wednesday February 16, 2022
;
;	Project Name:	Laboratory 01
;
;	Program Description: This program will perform several calculations to determine useful information 
;	for a snowblowing business. The assembler will be given values for the length and width of the 
;	driveway to snow blow, the typical speed and width of the snowblower, the hourly rate for labor, 
;	and the total overhead cost for equipment use. With this data available, the program will compute 
;	the number of passes needed to completely snow blow the driveway, the time for one pass, the total
;	time needed, the cost of labor (time), and the total cost.
;
;	Project Number:	Project 01

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

;Data that begins with a value
dLength      word    180        ;Length of the driveway in feet
dWidth       word    90         ;Width of the driveway in feet
speed        word    3          ;Speed I typically use in the snowblower in feet per minute
sWidth       word    12         ;Width of the snowblower in feet
hRate        word    1000       ;Hourly rate in pennies
totOverhead  word    1500       ;Total overhead amount for equipment use in pennies

;Data that does not begin with a value
totPasses    word    ?          ;Total number of passes needed (dWidth / sWidth)
tPass        word    ?          ;Total time needed for one pass (dLength / speed)
totTime      word    ?          ;Total time needed (tPass * totPasses)
lCost        word    ?          ;Labor cost (hRate * totTime)
totCost      word    ?          ;Total cost (totOverhead + lCost)

.code
main proc

		;Compute number of passes needed
		mov ax, dWidth
		mov bx, sWidth
		mov dx, 0
		div bx
		mov totPasses, ax

		;Compute time needed for one pass
		mov ax, dLength
		mov bx, speed
		mov dx, 0
		div bx
		mov bx, 60
		mov dx, 0
		div bx
		mov tPass, ax

		;Compute total time needed
		mov ax, tPass
		mov bx, totPasses
		mul bx
		mov totTime, ax

		;Compute cost of labor (time)
		mov ax, hRate
		mov bx, totTime
		mul bx
		mov lCost, ax

		;Compute total cost (adding overhead amount)
		mov cx, totOverhead
		mov dx, lCost
		add cx, dx
		mov totCost, cx

	invoke ExitProcess,0
main endp
end main