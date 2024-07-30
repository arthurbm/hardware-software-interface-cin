    section .text

global calc_circ_area

calc_circ_area:

;; criar novo stack frame
push ebp
mov ebp, esp

;; criar espaço para variaveis locais
;; se necessario, esp - (4 * qnt de local var)

;; inicia a FPU
finit

;; calula area
fldpi               ;; Pi em st0
fld dword[ebp + 8]  ;; R em st0 e Pi em st1
fmul st0, st0       ;; R^2 em st0 e Pi em st1
fmulp st1, st0      ;; Pi*R^2 em st0

;; destroi stack frame
mov esp, ebp
pop ebp

;; retorna. retorno em st0
ret

