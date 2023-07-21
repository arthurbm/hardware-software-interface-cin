; comentarios

ORG 0x7C00
BITS 16
    jmp start

msg: db "hello world", 0x0D, 0x0A, 0
input: db 0

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; configurando a ivt para int 0x40 (print_string)
    push ds
    mov ax, 0
    mov ds, ax
    mov di, 0x100 ; Offset para int 40h
    mov word[di], print_string
    mov word[di+2], 0
    pop ds

    push msg
    call print_string

    call get_keyboard_input

    mov bx, input
    push bx
    int 0x40

end:
    jmp $ ; halt

get_keyboard_input:
    mov si, input
.loop:
    mov ah, 0x00
    int 0x16
    ;; char lido vai estar em al
    cmp al, 0x0D
    je .done
    mov ah, 0x0E
    int 0x10
    stosb ; Armazenar caractere em 'input'
    jmp .loop
.done:
    mov al, 0
    stosb ; Colocar terminador nulo
    ret

print_string:
    push bp    ;; salvar bp
    mov bp, sp ;; bp -> top da pilha
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

; assinatura de boot

    times 510-($-$$) db 0
    dw 0xAA55
