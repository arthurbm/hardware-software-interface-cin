ORG 0x7C00
BITS 16
    jmp start

msg: db "hello world", 0x0D, 0x0A, 0

buffer: db 100 dup(0) ; buffer para armazenar a string lida do teclado

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

;; configurando a ivt
    mov di, 0x100 ; posicao para a int 0x40 na ivt
    mov word[di], print_string
    mov word[di+2], 0x0

    push msg
    call print_string

    call get_keyboard_input

    push buffer
    int 0x40

end:
    jmp $ ; halt


get_keyboard_input:
    mov di, buffer
.loop:
    mov ah, 0x00
    int 0x16
    ;; char lido vai estar em al
    cmp al, 0x0D
    je .done
    mov ah, 0x0E
    int 0x10
    stosb
    jmp .loop
.done:
    mov al, 0
    stosb
    ret


print_string:
    push bp    ;; salvar bp
    mov bp, sp ;; bp -> top da pilha
    ;; bp+0 -> bp antigo
    ;; bp+2 -> offset retorno
    ;; bp+4 -> primeiro parametro
    mov si, [bp+4]
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    pop bp ;; devolver bp
    ret 2  ;; n_parametros * 2 (modo real)

print_number:
    push bp
    mov bp, sp
    ;; bp+0 -> bp antigo
    ;; bp+2 -> flags
    ;; bp+4 -> cs
    ;; bp+6 -> ip
    ;; bp+8 -> primeiro parametro
    mov ax, [bp+8]    

    mov bx, 10
    mov cx, 0
.loop1:
    mov dx, 0
    div bx
    ; resposta vai ta no ax, resto no dx
    add dx, 48
    push dx
    inc cx
    cmp ax, 0
    jne .loop1
.loop2:
    pop ax
    mov ah, 0x0E
    int 0x10
    loop .loop2
.done:
    pop bp
    iret

; assinatura de boot

    times 510-($-$$) db 0
    dw 0xAA55
