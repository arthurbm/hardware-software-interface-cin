bits 16
org 0x7C00

jmp main

; n: dw 0 ; Se precisar passar &n como um parâmetro pra scanf, não acho que ele queira mas só pra ter como exemplo

main:

  ; push n
  ; call scanfd

  ; mov ax, [n]

  get_n:

  mov ah, 0x00
  int 16h
  mov ah, 0

  sub al, '0'

  push ax
  call fat

  push ax
  call print_number

  jmp end

fat:               ; Vamos considerar o retorno dessa rotina pelo ax
  push bp
  mov bp, sp          ; Criando um novo "contexto" na pilha para essa chamada de fat

  push bx             ; Lembrem de salvar na pilha os registradores que forem ser usados na recursão (menos o de retorno), 
                      ; para que os preservemos em diferentes níveis de recursão quando retornarmos com ret

  mov ax, [bp+4]      ; ax = n
  or ax, ax           ; cmp ax, 0
  jnz out1            ; jneq out1

  out0:              ; Saída se n == 0
  mov ax, 1           ; Retorno de fat(0) = 1
  pop bx              ; Desempilha na ordem inversa do empilhamento
  pop bp
  ret 2               ; Lembrar de remover o parâmetro da pilha

  out1:              ; Saída se n == 1
  mov bx, ax          ; bx = n
  sub ax, 1           ; ax = n-1

  push ax
  call fat            ; Recursão de fat(n-1) retornando em ax

  mul bx              ; Retorno de fat(n) = n * fat(n-1)
  pop bx
  pop bp
  ret 2               ; Lembrar de remover o parâmetro da pilha


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