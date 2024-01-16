;   NAME:			Justyce Countryman
;	
;   Due Date:		Friday April 29, 2022
;
;   Project Name:	Laboratory 07
;
;   Program Description: This program will produce sales reciepts. 
;   The program will accept from the keyboard the customer name, 
;   address, city/state/zip, and tax rate. Then, the program will 
;   ask for a quantity for each item purchased from the keyboard. 
;   The three product names and prices will be built directly 
;   into the program. Lastly, the program will display a bill. 
;   The screen will be cleared between inputs and outputs.
;
;   Project Number:	Project 07

include Irvine32.inc

.386
;.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data

     customerName            byte 80 DUP(?)
     customerAddress         byte 80 DUP(?)
     customerCityStateZip    byte 80 DUP(?)
     taxRate                 dword ?
     firstItemQuantity       dword ?
     secondItemQuantity      dword ?
     thirdItemQuantity       dword ?
     firstItemName           byte "Franklin Doors: ", 0
     secondItemName          byte "Window Kits: ", 0
     thirdItemName           byte "Hatch Kits: ", 0
     firstItemPrice          dword 8500
     secondItemPrice         dword 14500
     thirdItemPrice          dword 80000
     firstItemSubtotal       dword ?
     secondItemSubtotal      dword ?
     thirdItemSubtotal       dword ?
     subtotal                dword ?
     taxTotal                dword ?
     total                   dword ?
     customerNamePmp         byte "Enter the customer's name: ", 0
     customerAddressPmp      byte "Enter the customer's address: ", 0
     customerCityStateZipPmp byte "Enter the customer's city/state/zip: ", 0
     taxRatePmp              byte "Enter the tax rate percentage (AS A WHOLE NUMBER): ", 0
     firstItemQuantityPmp    byte "Enter the POSITIVE quantity of Franklin Doors: ", 0
     secondItemQuantityPmp   byte "Enter the POSITIVE quantity of Window Kits: ", 0
     thirdItemQuantityPmp    byte "Enter the POSITIVE quantity of Hatch Kits: ", 0
     lumberPmp               byte "Lindsay Lumber Inc.", 0
     soldPmp                 byte "Sold to:", 0
     atPmp                   byte " at $", 0
     dollarPmp               byte "$", 0
     taxPmp                  byte "Tax:  ", 0
     totalPmp                byte "Total:  $", 0

.code
main proc
    
    ;Get Customer Name
    mov    esi, OFFSET customerName
    mov    edx, OFFSET customerNamePmp
    mov    ecx, 80
    call   GetCustomerInfo
    
    ;Get Customer Address
    mov    esi, OFFSET customerAddress
    mov    edx, OFFSET customerAddressPmp
    mov    ecx, 80
    call   GetCustomerInfo

    ;Get Customer City/State/Zip
    mov    esi, OFFSET customerCityStateZip
    mov    edx, OFFSET customerCityStateZipPmp
    mov    ecx, 80
    call   GetCustomerInfo

    ;Get Tax Rate
    mov    esi, OFFSET taxRate
    mov    edx, OFFSET taxRatePmp
    call   GetTaxRate

    ;Get Quantity of First Item
    mov    esi, OFFSET firstItemQuantity
    mov    edx, OFFSET firstItemQuantityPmp
    call   GetItemQuantities

    ;Get Quantity of Second Item
    mov    esi, OFFSET secondItemQuantity
    mov    edx, OFFSET secondItemQuantityPmp
    call   GetItemQuantities

    ;Get Quantity of Third Item
    mov    esi, OFFSET thirdItemQuantity
    mov    edx, OFFSET thirdItemQuantityPmp
    call   GetItemQuantities

    ;Compute First Item Extended Cost
    push    OFFSET firstItemSubtotal ;[ebp + 16]
    push    firstItemQuantity ;[ebp + 12]
    push    firstItemPrice    ;[ebp + 8]
    call    ComputeExtendedCosts ;[ebp + 4]

    ;Compute Second Item Extended Cost
    push    OFFSET secondItemSubtotal ;[ebp + 16]
    push    secondItemQuantity ;[ebp + 12]
    push    secondItemPrice    ;[ebp + 8]
    call    ComputeExtendedCosts ;[ebp + 4]

    ;Compute Third Item Extended Cost
    push    OFFSET thirdItemSubtotal ;[ebp + 16]
    push    thirdItemQuantity ;[ebp + 12]
    push    thirdItemPrice    ;[ebp + 8]
    call    ComputeExtendedCosts ;[ebp + 4]

    ;Compute Subtotal
    mov     eax, firstItemSubtotal
    mov     ebx, secondItemSubtotal
    mov     ecx, thirdItemSubtotal
    call    ComputeSubtotal

    ;Calculate Tax
    mov     eax, subtotal
    mov     ebx, taxRate
    call    ComputeTax

    ;Compute Total
    mov     eax, subtotal
    mov     ebx, taxTotal
    call    ComputeTotal

    ;Display Sales Summary
    mov     edx, OFFSET lumberPmp
    call   WriteString
    call   Crlf
    call   Crlf
    mov    edx, OFFSET soldPmp
    call   WriteString
    call   Crlf
    mov    edx, OFFSET customerName
    call   WriteString
    call   Crlf
    mov    edx, OFFSET customerAddress
    call   WriteString
    call   Crlf
    mov    edx, OFFSET customerCityStateZip
    call   WriteString
    call   Crlf
    call   Crlf
    mov    edx, OFFSET firstItemName
    call   WriteString
    mov    eax, [firstItemQuantity]
    mov    ecx, [firstItemPrice]
    mov    esi, [firstItemSubtotal]
    call   DisplaySalesSummary
    mov    edx, OFFSET secondItemName
    call   WriteString
    mov    eax, [secondItemQuantity]
    mov    ecx, [secondItemPrice]
    mov    esi, [secondItemSubtotal]
    call   DisplaySalesSummary
    mov    edx, OFFSET thirdItemName
    call   WriteString
    mov    eax, [thirdItemQuantity]
    mov    ecx, [thirdItemPrice]
    mov    esi, [thirdItemSubtotal]
    call   DisplaySalesSummary
    mov    esi, [taxRate]
    mov    edi, [taxTotal]
    mov    edx, OFFSET taxPmp
    call   WriteString
    mov    al, '('
    call   WriteChar
    mov    eax, esi
    .if(eax >= 100)
        
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

    .elseif(eax < 100 && eax >= 10)
        
        mov    al, '0'
        call   WriteChar
        mov    al, '.'
        call   WriteChar
        mov    eax, esi
        call   WriteDec

     .else
         
        mov    al, '0'
        call   WriteChar
        mov    al, '.'
        call   WriteChar
        mov    al, '0'
        call   WriteChar
        mov    eax, esi
        call   WriteDec

    .endif
    mov    al, ')'
    call   WriteChar
    mov    al, ' '
    call   WriteChar
    mov    al, ' '
    call   WriteChar
    mov    al, '$'
    call   WriteChar
    mov    eax, edi
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
    mov    esi, [total]
    mov    edx, OFFSET totalPmp
    call   WriteString
    mov    eax, esi
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

        invoke ExitProcess,0
main endp

GetCustomerInfo proc uses edx esi eax
    
    call   WriteString
    mov    edx, esi
    call   ReadString
    call   Crlf ;Used before screen clear
    call   WriteString ;Used before screen clear
    call   Crlf ;Used before screen clear

        ret
GetCustomerInfo endp

GetTaxRate proc uses esi eax

    call   WriteString
    call   ReadDec
    mov    [esi], eax

        ret
GetTaxRate endp

GetItemQuantities proc
    
    ;Questionable validation...
    mov    al, -1
    .while(al >= 128 || al < 0)

        call   WriteString
        call   ReadInt

    .endw
    mov    [esi], al

        ret
GetItemQuantities endp

ComputeExtendedCosts proc
    
    ;Sends answer back as a REFERENCE PARAMETER
    push   ebp
    mov    ebp, esp ;Establishes in ebp the reference point for stuff in the stack
    sub    esp, 4 ;Creates a local variable for subtotal that will be 4 bytes [ebp - 4]
    push   ebx ;AFTER STACK FRAME IS SET, preserves registers - no USES
    push   ecx ;AFTER STACK FRAME IS SET, preserves registers - no USES
    push   eax ;AFTER STACK FRAME IS SET, preserves registers - no USES
    
    ;Multiply quantity times price
    mov    eax, 0
    mov    eax, [ebp + 12]
    mul    DWORD PTR[ebp + 8]
    
    ;Place answer in reference parameter
    mov    ebx, [ebp + 16] ;Gets the address from the stack
    mov    [ebx], eax

    pop    eax ;BEFORE removing STACK FRAME, reclaim registers
    pop    ecx ;BEFORE removing STACK FRAME, reclaim registers
    pop    ebx ;BEFORE removing STACK FRAME, reclaim registers
    add    esp, 4  ;Eliminates the local subtotal variable
    pop    ebp

        ret
ComputeExtendedCosts endp

ComputeSubtotal proc

    add    eax, ebx
    add    eax, ecx
    mov    [subtotal], eax

        ret
ComputeSubtotal endp

ComputeTax proc
 
    mul    ebx
    mov    ebx, 100
    mov    edx, 0
    div    ebx
    mov    [taxTotal], eax

        ret
ComputeTax endp

ComputeTotal proc

    add    eax, ebx
    mov    [total], eax

        ret
ComputeTotal endp

DisplaySalesSummary proc

    call   WriteDec
    mov    edx, OFFSET atPmp
    call   WriteString
    mov    eax, ecx
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
    mov    edx, OFFSET dollarPmp
    call   WriteString
    mov    eax, esi
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

        ret
DisplaySalesSummary endp
end main
