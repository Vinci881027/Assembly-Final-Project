TITLE Example of ASM              (helloword.ASM)

; This program locates the cursor and displays the
; system time. It uses two Win32 API structures.
; Last update: 6/30/2005
;C:\WINdbgFolder\helloword.exe

INCLUDE Irvine32.inc

wincondition PROTO,
boardptrr:PTR BYTE,
dott:BYTE

print PROTO

main  EQU start@0 ;
.data
    myboard1 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard2 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard3 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard4 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard5 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard6 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard7 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard8 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard9 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard10 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard11 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard12 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard13 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard14 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah
    myboard15 byte "+ + + + + + + + + + + + + + + ",0Dh,0Ah,0Ah
	errorMessage byte "error! please try another place ",0
	turnMessage1 byte "It is ",0
	turnMessage2 byte " turn.",0
	winMessage byte " WIN ! ",0
	xyPos COORD <0,2>
	IntxyPos COORD <0,2>
	border COORD <30,17>
	outputHandle DWORD ?
	cellsWritten DWORD ?
	attribute WORD 0ch
	attribute1 WORD 32 DUP(0e0h)
.code
main PROC

	INVOKE GetStdHandle,STD_OUTPUT_HANDLE
	mov outputHandle,eax
	call clrscr
	mov bl,"@"
L1:
    call Crlf
L2:
    INVOKE print
    mov edx,OFFSET turnMessage1
    call WriteString
    mov al,bl
    call WriteChar
    mov edx,OFFSET turnMessage2
    call WriteString
    call readChar
    call clrscr
    .IF ax == 1c0dh ;ENTER
        push ebx
        xor edx,edx
        xor eax,eax
        mov ax,xyPos.y
        sub ax,2
        mov bx,32	;calculate position
        mul bx
        mov dx,ax

        xor eax,eax
        xor ebx,ebx
        mov ax,xyPos.x
        add dx,ax
        mov esi,OFFSET myboard1
        add esi,edx
        pop ebx

        cmp byte ptr [esi],"+"
        jne errorM
        mov byte ptr [esi],bl
        jmp put
errorM:
        call clrscr
        mov edx,OFFSET errorMessage
        call WriteString
        call Crlf
        jmp L2
put:
        INVOKE wincondition, esi, bl
        cmp bl,"@"
        jne change
        mov bl,"O"
        jmp con
change:
        mov bl,"@"
	.ENDIF
	.IF ax == 4800h ;UP
		sub xyPos.y,1
	.ENDIF
	.IF ax == 5000h ;DOWN
		add xyPos.y,1
	.ENDIF
	.IF ax == 4b00h ;LEFT
		sub xyPos.x,2
	.ENDIF
	.IF ax == 4d00h ;RIGHT
		add xyPos.x,2
	.ENDIF
	.IF xyPos.x == -2
		add xyPos.x,2
	.ENDIF
	mov ax,border.x
	.IF xyPos.x == ax
		sub xyPos.x,2
	.ENDIF
	.IF xyPos.y == 1
		add xyPos.y,1
	.ENDIF
	mov ax,border.y
	.IF xyPos.y == ax
		sub xyPos.y,1
	.ENDIF
con:
	jmp L1

	call clrscr	;print tie message and stop the program
	call WaitMsg
exit

main ENDP

wincondition PROC uses ecx eax esi ebx,
	boardptrr:PTR BYTE,
	dott:BYTE

	mov bl, dott		;bl == dott
	mov ecx, 5
	mov eax, 0		;chess counter
	mov esi, boardptrr
L1:		;left
	sub esi, 2
	cmp BYTE PTR [esi], bl
	jnz L1END
	inc eax
	loop L1
L1END:
	mov ecx, 5
	mov esi, boardptrr
L2:		;right
	add esi, 2
	cmp BYTE PTR [esi], bl
	jnz L2END
	inc eax
	loop L2
L2END:
	cmp eax, 4
	jz win
	mov ecx, 5
	mov eax, 0
	mov esi, boardptrr
L3:		;up
	sub esi, 32
	cmp BYTE PTR [esi], bl
	jnz L3END
	inc eax
	loop L3
L3END:
	mov ecx, 5
	mov esi, boardptrr
L4:		;down
	add esi, 32
	cmp BYTE PTR [esi], bl
	jnz L4END
	inc eax
	loop L4
L4END:
	cmp eax, 4
	jz win
	mov ecx, 5
	mov eax, 0
	mov esi, boardptrr
L5:		;left-up
	sub esi, 34
	cmp BYTE PTR [esi], bl
	jnz L5END
	inc eax
	loop L5
L5END:
	mov ecx, 5
	mov esi, boardptrr
L6:		;right-down
	add esi, 34
	cmp BYTE PTR [esi], bl
	jnz L6END
	inc eax
	loop L6
L6END:
	cmp eax, 4
	jz win
	mov ecx, 5
	mov eax, 0
	mov esi, boardptrr
L7:		;right-up
	sub esi, 30
	cmp BYTE PTR [esi], bl
	jnz L7END
	inc eax
	loop L7
L7END:
	mov ecx, 5
	mov esi, boardptrr
L8:		;left-down
	add esi, 30
	cmp BYTE PTR [esi], bl
	jnz L8END
	inc eax
	loop L8
L8END:
	cmp eax, 4
	jz win
	mov ecx, 5
	mov eax, 0
	mov esi, boardptrr
	ret
win:
	mov al, dott
	call WriteChar
	mov edx, offset winMessage
	call WriteString
	call Crlf
	INVOKE print
	call WaitMsg
	exit
	ret
wincondition ENDP

print PROC
        INVOKE WriteConsoleOutputAttribute,
        outputHandle,
        ADDR attribute,
        1,
        xyPos,
        ADDR cellsWritten

        sub IntxyPos.y,2
        INVOKE WriteConsoleOutputAttribute,
        outputHandle,
        ADDR attribute1,
        LENGTHOF attribute1,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,2
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard1,
        LENGTHOF myboard1,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard2,
        LENGTHOF myboard2,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard3,
        LENGTHOF myboard3,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard4,
        LENGTHOF myboard4,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard5,
        LENGTHOF myboard5,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard6,
        LENGTHOF myboard6,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard7,
        LENGTHOF myboard7,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard8,
        LENGTHOF myboard8,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard9,
        LENGTHOF myboard9,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard10,
        LENGTHOF myboard10,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard11,
        LENGTHOF myboard11,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard12,
        LENGTHOF myboard12,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard13,
        LENGTHOF myboard13,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard14,
        LENGTHOF myboard14,
        IntxyPos,
        ADDR cellsWritten

        add IntxyPos.y,1
        INVOKE WriteConsoleOutputCharacter,
        outputHandle,
        ADDR myboard15,
        LENGTHOF myboard15,
        IntxyPos,
        ADDR cellsWritten

        sub IntxyPos.y,14
        ret
print ENDP
END main
