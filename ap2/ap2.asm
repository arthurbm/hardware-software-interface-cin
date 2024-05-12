; comentarios

ORG 0x7C00
BITS 16
    jmp start

msgInicial: db "Digite seu texto abaixo:", 0x0D, 0x0A, 0 
msg: times 50 db 0
msgFinal: db "FIM",0x0D, 0x0A, 0 

start:

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

;; configurando a ivt
    push ds
    xor ax, ax
    mov ds, ax

    mov di, 0x100 ;; 40h x 4 bytes por cada
    mov word[di], print_string
    mov word[di+2], 0

    pop ds

    mov ax, msgInicial
    push ax
    int 0x40
    call get_keyboard_input 
    ; pular linha
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10

    mov ax, msg
    push ax
    int 0x40
    ; pular linha
    mov ah, 0x0E
    mov al, 0x0D
    int 0x10
    mov al, 0x0A
    int 0x10

    mov ax, msgFinal
    push ax
    int 0x40

end:
    jmp $ ; halt


get_keyboard_input:
    pusha
    mov si, msg ; usar msg como ponteiro para a string
    xor cx, cx ; contador para tamanho máximo da string
.loop:
    mov ah, 0x00
    int 0x16
    ;; char lido vai estar em al
    cmp al, 0x0D
    je .done
    mov ah, 0x0E
    int 0x10
    mov [si], al ; salvar o caractere na variável msg
    inc si ; avançar para o próximo byte na variável msg
    inc cx ; incrementar o contador
    cmp cx, 50 ; verificar se alcançou o tamanho máximo da string
    je .done
    jmp .loop
.done:
    popa
    ret


print_string:
    pusha ; salvar todos os registradores

    mov si, ax ; usar ax como ponteiro para a string
    mov ah, 0x0E

.loop:
    lodsb
    or al, al
    jz .done
    int 0x10
    jmp .loop

.done:
    popa ; restaurar todos os registradores
    retf ; retornar da interrupção


; assinatura de boot

    times 510-($-$$) db 0
    dw 0xAA55
