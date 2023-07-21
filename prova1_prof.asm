; comentarios

ORG 0x7C00
BITS 16
    jmp start

start:
  mov ah,0
  int 16h
  sub al,'0'
  cbw
  mov cx, ax
  push cx
  call factorial

factorial:
  push BP ; Para acessar parametros
  push BX ; salvando o valor de bx, pois vou usar esse reg.
  mov BP,SP ; melhor trabalhar com bp, inves de sp

  add BP,6 ;pula 3 end. de 2 bytes(bx,bp,ip) para acessar param
  mov BX,[BP] ; BX = Param
  cmp BX,0 ; Checar o caso base
  je base ; if (n == 0)
  dec BX ; Decrementa BX para empilhar se nao for caso base
  push BX ; Empilha (BX - 1)
  inc BX ; Restaura BX
  call factorial ; Calcula fatorial de (BX - 1)
  mul BX ; DX:AX = (AX * BX) = (BX - 1)! * BX
  pop BX ; Restaurando BX
  jmp endF
base: ; Caso base
  mov AX,1 ; Resultado eh 1

  endF:
  pop BX ; restaurando registradores
  pop BP ;
  ret
; assinatura de boot
times 510-($-$$) db 0
dw 0xAA55
