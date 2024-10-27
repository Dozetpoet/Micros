section .data
    array db 5, 3, 8, 1, 9, 2, 6   ; Array a ordenar

section .bss
    array_len equ $ - array        ; Longitud del array

section .text
    global _start

_start:
    ; Pusheamos los elementos del array en la pila
    mov cx, array_len              ; Contador de elementos
    mov si, array                  ; Puntero al inicio del array
push_loop:
    dec cx
    js sort_bubble                 ; Si llegamos al final, salimos del bucle
    mov al, [si + cx]              ; Cargamos el elemento en AL
    push ax                        ; Lo colocamos en la pila (solo AL es significativo)
    jmp push_loop

sort_bubble:
    ; Algoritmo de ordenamiento de burbuja usando la pila
    mov cx, array_len              ; Tamaño del array
    dec cx                         ; Hacer n-1 pasadas

outer_loop:
    push cx                        ; Guardamos el contador de pasadas en la pila
    mov cx, 0                      ; Reiniciamos contador para los elementos

inner_loop:
    ; Comparamos elementos adyacentes en la pila
    mov al, byte [esp + cx * 2 + 2] ; Cargamos el primer elemento en AL
    mov ah, byte [esp + cx * 2 + 4] ; Cargamos el segundo elemento en AH

    ; Si el primer elemento es mayor, intercambiamos
    cmp al, ah
    jle no_swap
    mov [esp + cx * 2 + 2], ah      ; Intercambiamos los elementos
    mov [esp + cx * 2 + 4], al

no_swap:
    inc cx                          ; Siguiente posición en el array
    cmp cx, array_len - 1           ; Comparamos con el límite del array
    jl inner_loop                   ; Si aún faltan comparaciones, seguimos

    pop cx                          ; Restauramos el contador de pasadas
    loop outer_loop                 ; Repetimos hasta que el array esté ordenado

exit:
    ; Llamada al sistema para salir del programa
    mov eax, 1                      ; Código de salida
    xor ebx, ebx                    ; Código de retorno
    int 0x80                        ; Interrupción para salirvv
