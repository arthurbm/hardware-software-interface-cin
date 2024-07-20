; diretivas para o assembler
org 0x7C00
bits 16
jmp start

; Dados
buffer times 256 db 0   ; Buffer para armazenar a string digitada
prompt db "Digite uma string: ", 0
newline db 0x0D, 0x0A, 0

; inicio do programa
start:
    ; Configurar a interrupção 40h
    cli  ; Desabilita interrupções
    push ds
    xor ax, ax
    mov ds, ax
    mov word [40h*4], print_string  ; Offset da rotina
    mov word [40h*4+2], 0  ; Segmento (assumindo que estamos no segmento 0)
    pop ds
    sti  ; Habilita interrupções

    ; Imprimir prompt
    mov si, prompt
    call print_string

    ; Ler string do teclado
    mov di, buffer
    call get_keyboard_input

    ; Chamar a interrupção 40h para imprimir a string
    push buffer
    int 40h
    add sp, 2

    ; Fim do programa
    jmp $

; Funções
get_keyboard_input:
    xor cx, cx  ; Contador de caracteres
.loop:
    mov ah, 0
    int 16h  ; Espera por um caractere do teclado
    cmp al, 0x0D  ; Verifica se é Enter
    je .done
    mov [di], al  ; Armazena o caractere no buffer
    inc di
    inc cx
    mov ah, 0x0E
    int 10h  ; Exibe o caractere digitado
    jmp .loop
.done:
    mov byte [di], 0  ; Adiciona terminador nulo
    mov si, newline
    call print_string  ; Imprime nova linha
    ret

print_string:
    pusha
    mov ah, 0x0E
.loop:
    lodsb
    or al, al
    jz .done
    int 10h
    jmp .loop
.done:
    popa
    iret

; Assinatura do boot sector
times 510-($-$$) db 0
dw 0xAA55