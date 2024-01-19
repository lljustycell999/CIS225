;   NAME:		Justyce Countryman
;	
;   Due Date:		Wednesday March 2, 2022
;
;   Project Name:	Laboratory 02
;
;   Program Description: This program will determine the number of boxes (of varying sizes) to be filled along with 
;   the costs associated with each box size (total shipping and product costs for each box size), assuming the
;   number of reams of paper that the customer wants is given. At the end of the program, the total cost of the
;   order will be calculated. The sizes of the boxes, the shipping costs for each box size, the price for each ream
;   of paper, and the number of reams of paper that is wanted by the customer will be set with predetermined values.   
;
;   Project Number:	Project 02

.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	boxSizes          word 10, 5, 2, 1
	shippingCosts     word 1275, 675, 260, 195
	pricePerReam      word 490
	numReams          byte 52

	totBoxes          byte ?, ?, ?, ?
	totShippingCosts  word ?, ?, ?, ?
	totProductCosts   word ?, ?, ?, ?
	totCost           word ?
		
.code
main proc
		
	;Calculate the number of each box size to ship, their total shipping costs, and their total product costs

	;Box 1 (Holds 10 reams)
	movzx   ax, numReams
	mov     bx, 0
	mov     esi, OFFSET boxSizes
	add     bx, [esi]
	mov     dx, 0
	div     bx
	mov     totBoxes, al
	mov     cx, dx
	mov     bx, 0
	mov     edx, OFFSET shippingCosts
	add     bx, [edx]
	mul     bx
	mov     totShippingCosts, ax
	mov     totCost, ax
	movzx   ax, totBoxes
	mov     bx, 10
	mul     bx
	mov     bx, pricePerReam
	mul     bx
	mov     totProductCosts, ax
	add     totCost, ax

	;Box 2 (Holds 5 reams)
	mov     ax, cx
	add     esi, TYPE boxSizes
	mov     bx, 0
	add     bx, [esi]
	mov     dx, 0
	div     bx
	mov     totBoxes, al
	mov     cx, dx
	mov     edx, OFFSET shippingCosts
	add     edx, TYPE shippingCosts
	mov     bx, 0
	add     bx, [edx]
	mul     bx
	mov     totShippingCosts, ax
	add     totCost, ax
	movzx   ax, totBoxes
	mov     bx, 5
	mul     bx
	mov     bx, pricePerReam
	mul     bx
	mov     totProductCosts, ax
	add     totCost, ax

	;Box 3 (Holds 2 reams)
	mov     ax, cx
	add     esi, TYPE boxSizes
	mov     bx, 0
	add     bx, [esi]
	mov     dx, 0
	div     bx
	mov     totBoxes, al
	mov     cx, dx
	mov     edx, OFFSET shippingCosts
	add     edx, TYPE shippingCosts
	add     edx, TYPE shippingCosts
	mov     bx, 0
	add     bx, [edx]
	mul     bx
	mov     totShippingCosts, ax
	add     totCost, ax
	movzx   ax, totBoxes
	mov     bx, 2
	mul     bx
	mov     bx, pricePerReam
	mul     bx
	mov     totProductCosts, ax
	add     totCost, ax

	;Box 4 (Holds 1 ream)
	mov     ax, cx
	add     esi, TYPE boxSizes
	mov     bx, 0
	add     bx, [esi]
	mov     dx, 0
	div     bx
	mov     totBoxes, al
	mov     edx, OFFSET shippingCosts
	add     edx, TYPE shippingCosts
	add     edx, TYPE shippingCosts
	add     edx, TYPE shippingCosts
	mov     bx, 0
	add     bx, [edx]
	mul     bx
	mov     totShippingCosts, ax
	add     totCost, ax
	movzx   ax, totBoxes
	mov     bx, 1
	mul     bx
	mov     bx, pricePerReam
	mul     bx
	mov     totProductCosts, ax
	add     totCost, ax

	invoke ExitProcess,0
main endp
end main
