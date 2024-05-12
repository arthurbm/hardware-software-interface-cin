bits 16
org 0x7C00

jmp main

main:
  get_x:

  mov ah, 0x00
  int 16h

  mov ah, 0
  sub al, '0'

  push ax

  get_y:

  mov ah, 0x00
  int 16h

  mov ah, 0
  sub al, '0'

  push ax

  call mdc

  push ax
  call print_number

  jmp end

mdc:               ; Vamos considerar o retorno dessa rotina pelo ax
  push bp
  mov bp, sp          ; Criando um novo "contexto" na pilha para essa chamada de mdc

  mov ax, [bp+6]      ; ax = x
  div byte[bp+4]      ; ah = x % y, al = x / y
  or ah, ah           ; cmp ah, 0
  jnz out1            ; jneq out1

  out0:              ; Saída se n == 0
  mov ax, [bp+4]      ; Retorno = y
  pop bp
  ret 4               ; Lembrar de remover o parâmetro da pilha

  out1:              ; Saída se n != 0
                      ; Passando os parâmetros para a chamada de mdc(y, x%y)
  push word[bp+4]     ; push y
  mov al, ah          ; al = x%y
  mov ah, 0           ; ah = 0 -> ax = x%y
  push ax             ; push x%y

  call mdc            ; Recursão de mdc(y, x%y) que retorna o resultado em ax, que é retornado para a chamada anterior
  pop bp
  ret 4               ; Lembrar de remover o parâmetro da pilha


print_number:      ; Print number pra testar
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