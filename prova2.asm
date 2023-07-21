bits 16
org 0x7C00

jmp main

main:

  get_n1:

  mov ah, 0x00
  int 16h
  mov ah, 0

  sub al, '0'
  
  mov bx, ax ; Armazena o primeiro número em bx

  get_n2:

  mov ah, 0x00
  int 16h
  mov ah, 0

  sub al, '0'

  mov ax, bx ; Move o primeiro número para ax
  xor dx, dx ; Limpa o dx para a próxima divisão

  div ax      ; Divide o segundo número pelo primeiro

  mov ax, dx  ; Move o resto para ax

  cmp ax, 0
  je done     ; Se o resto é zero, bx é o MDC
  
  mov bx, ax  ; Move o resto para bx
  jmp get_n2  ; Começa o loop novamente

done:

  push bx
  call print_number

  jmp end

print_number:
    push bp
    mov bp, sp
    mov ax, [bp+4]    

    mov bx, 10
    mov cx, 0
.loop1:
    mov dx, 0
    div bx
    
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
    ret 2

end:
jmp $

times 510-($-$$) db 0
dw 0xAA55
