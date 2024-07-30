section .text
global calc_cone_volume

calc_cone_volume:
    ; Criar novo stack frame
    push ebp
    mov ebp, esp

    ; Inicializar a FPU
    finit

    ; Carregar os parâmetros (raio e altura)
    fld dword [ebp + 8]  ; raio em st0
    fld dword [ebp + 12] ; altura em st0, raio em st1

    ; Calcular o volume: V = (1/3) * π * r^2 * h
    fldpi               ; π em st0, altura em st1, raio em st2
    fmul st0, st2       ; π * r em st0
    fmul st0, st2       ; π * r^2 em st0
    fmul st0, st1       ; π * r^2 * h em st0
    fld1                ; 1 em st0, π * r^2 * h em st1
    fld1                ; 1 em st0, 1 em st1, π * r^2 * h em st2
    fadd st0, st1       ; 2 em st0, 1 em st1, π * r^2 * h em st2
    fadd st0, st1       ; 3 em st0, 1 em st1, π * r^2 * h em st2
    fdivp st1, st0      ; 1/3 em st0, π * r^2 * h em st1
    fmulp st1, st0      ; (1/3) * π * r^2 * h em st0

    ; Destruir stack frame
    mov esp, ebp
    pop ebp

    ; Retornar (resultado já está em st0)
    ret