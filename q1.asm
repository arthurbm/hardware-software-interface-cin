ORG 0x7C00
BITS 16

jmp start

msg: db 'hello world', 0
vogais: db 'aeiouAEIOU', 0
count: db 0

start:
    ; inicializa si com o início da mensagem e di com o início da lista de vogais
    mov si, msg
    mov bx, vogais

next_char:
    ; verifica se alcançamos o final da string
    mov al, byte [si]
    or al, al
    jz done
    inc si

    ; reseta o contador de vogais para este caractere
    mov byte [count], 0

next_vowel:
    ; verifica se alcançamos o final da lista de vogais
    mov bl, byte [bx]
    or bl, bl
    jz next_char
    inc bx

    ; se o caractere atual é uma vogal, incrementa o contador
    cmp al, bl
    jne next_vowel
    inc byte [count]

    jmp next_vowel

done:
    ; imprime o contador de vogais
    mov dx, byte [count]
    mov ah, 0x0E ; BIOS teletype
    int 0x10

end:
    jmp $ ; halt

; assinatura de boot
times 510-($-$$) db 0
dw 0xAA55
