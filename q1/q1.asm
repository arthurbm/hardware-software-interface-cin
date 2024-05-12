; Contar Vogais

ORG 0x7C00
BITS 16
    jmp start

msg: db "hello world", 0x0D, 0x0A, 0

start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    ; Inicializa a contagem de vogais em CX
    xor cx, cx

    ; Apontar para a mensagem
    mov si, msg
    call count_vowels

    ; Mostrar a string
    mov si, msg
    call print_string

    ; Mostrar o número de vogais
    mov ax, cx
    call print_number

end:
    jmp $ ; halt

count_vowels:
.loop:
    lodsb
    or al, al
    jz .done
    call is_vowel
    add cx, ax
    jmp .loop
.done:
    ret

is_vowel:
    ; Verificar se o caractere em AL é uma vogal
    mov ah, al
    or al, 20h ; Converter para minúsculo
    sub al, 'a'
    cmp al, 5
    je .is_vowel
    sub al, 6
    cmp al, 8
    je .is_vowel
    sub al, 4
    cmp al, 2
    je .is_vowel
    xor ax, ax
    ret
.is_vowel:
    mov ax, 1
    ret

print_string:
.loop:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp .loop
.done:
    ret

print_number:
    mov bx, 10
    mov dx, 0
    mov cx, 0
.loop1:
    xor dx, dx
    div bx
    add dx, '0'
    push dx
    inc cx
    cmp ax, 0
    jne .loop1
.loop2:
    pop ax
    mov ah, 0x0E
    int 0x10
    loop .loop2
    ret

; assinatura de boot
    times 510-($-$$) db 0
    dw 0xAA55
