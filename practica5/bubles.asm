section .data
    array db 5, 3, 8, 1, 9, 2, 6   ; Array a ordenar
    array_len equ $ - array         ; Longitud del array

section .text
    global _start

_start:
    ; Pusheamos los elementos del array en la pila
    mov ecx, array_len             ; Contador de elementos
    mov esi, array                 ; Puntero al inicio del array

push_loop:
    dec ecx
    js sort_bubble                 ; Si llegamos al final, salimos del bucle
    movzx eax, byte [esi + ecx]    ; Cargamos el elemento en EAX (extendiéndolo a 32 bits)
    push eax                       ; Colocamos el valor en la pila
    jmp push_loop

sort_bubble:
    ; Algoritmo de ordenamiento de burbuja usando la pila
    mov ecx, array_len             ; Tamaño del array
    dec ecx                        ; Hacer n-1 pasadas

outer_loop:
    push ecx                       ; Guardamos el contador de pasadas en la pila
    mov edx, 0                     ; Reiniciamos desplazamiento de elementos en la pila

inner_loop:
    ; Comparamos elementos adyacentes en la pila
    mov eax, [esp + edx + 4]       ; Cargamos el primer elemento en EAX
    mov ebx, [esp + edx + 8]       ; Cargamos el segundo elemento en EBX

    ; Si el primer elemento es mayor, intercambiamos
    cmp eax, ebx
    jle no_swap
    mov [esp + edx + 4], ebx       ; Intercambiamos los elementos
    mov [esp + edx + 8], eax

no_swap:
    add edx, 4                     ; Avanzamos a la siguiente posición en la pila (en palabras de 4 bytes)
    cmp edx, (array_len - 1) * 4   ; Comparamos con el límite del array en pila
    jl inner_loop                  ; Si aún faltan comparaciones, seguimos

    pop ecx                        ; Restauramos el contador de pasadas
    loop outer_loop                ; Repetimos hasta que el array esté ordenado

exit:
    ; Llamada al sistema para salir del programa
    mov eax, 1                     ; Código de salida
    xor ebx, ebx                   ; Código de retorno
    int 0x80                       ; Interrupción para salir
