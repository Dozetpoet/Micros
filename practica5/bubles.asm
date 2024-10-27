section .data
    array db 5, 3, 8, 1, 9, 2, 6       ; Array a ordenar
    array_len equ $ - array            ; Longitud del array
    msg db 'Array ordenado: ', 0       ; Mensaje para imprimir
    msg_len equ $ - msg                ; Longitud del mensaje
    space db ' ', 0                    ; Espacio
    newline db 10                      ; Nueva línea

section .bss
    buffer resb 12                     ; Buffer para almacenar un número de 32 bits convertido a cadena

section .text
    global _start

_start:
    ; Pusheamos los elementos del array en la pila
    mov ecx, array_len                 ; Contador de elementos
    mov esi, array                     ; Puntero al inicio del array

push_loop:
    dec ecx
    js sort_bubble                     ; Si llegamos al final, salimos del bucle
    movzx eax, byte [esi + ecx]        ; Cargamos el elemento en EAX (extendiéndolo a 32 bits)
    push eax                           ; Colocamos el valor en la pila
    jmp push_loop

sort_bubble:
    ; Algoritmo de ordenamiento de burbuja usando la pila
    mov ecx, array_len                 ; Tamaño del array
    dec ecx                            ; Hacer n-1 pasadas

outer_loop:
    push ecx                           ; Guardamos el contador de pasadas en la pila
    mov edx, 0                         ; Reiniciamos desplazamiento de elementos en la pila

inner_loop:
    ; Comparamos elementos adyacentes en la pila
    mov eax, [esp + edx + 4]           ; Cargamos el primer elemento en EAX
    mov ebx, [esp + edx + 8]           ; Cargamos el segundo elemento en EBX

    ; Si el primer elemento es mayor, intercambiamos
    cmp eax, ebx
    jle no_swap
    mov [esp + edx + 4], ebx           ; Intercambiamos los elementos
    mov [esp + edx + 8], eax

no_swap:
    add edx, 4                         ; Avanzamos a la siguiente posición en la pila (en palabras de 4 bytes)
    cmp edx, (array_len - 1) * 4       ; Comparamos con el límite del array en pila
    jl inner_loop                      ; Si aún faltan comparaciones, seguimos

    pop ecx                            ; Restauramos el contador de pasadas
    loop outer_loop                    ; Repetimos hasta que el array esté ordenado

    ; Imprimir el mensaje
    mov eax, 4                         ; syscall para sys_write
    mov ebx, 1                         ; file descriptor 1 (stdout)
    mov ecx, msg                       ; puntero al mensaje
    mov edx, msg_len                   ; longitud del mensaje
    int 0x80                           ; llamada al sistema

    ; Imprimir los elementos ordenados
    mov ecx, array_len                 ; Contador de elementos

print_loop:
    ; Retrocedemos en la pila
    mov eax, [esp + 4 * ecx]           ; Cargamos el elemento en EAX
    call print_number                  ; Imprimimos el número en EAX

    ; Imprimir un espacio
    mov eax, 4                         ; syscall para sys_write
    mov ebx, 1                         ; file descriptor 1 (stdout)
    mov ecx, space                     ; puntero al espacio
    mov edx, 1                         ; longitud del espacio
    int 0x80                           ; llamada al sistema

    dec ecx                            ; Decrementamos el contador
    jnz print_loop                     ; Si hay más elementos, repetimos

    ; Imprimir nueva línea al final
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

exit:
    ; Llamada al sistema para salir del programa
    mov eax, 1                         ; Código de salida
    xor ebx, ebx                       ; Código de retorno
    int 0x80                           ; Interrupción para salir

; Procedimiento para imprimir un número en EAX
print_number:
    ; Convertir número en EAX a string
    mov edi, buffer + 11               ; Puntero al final del buffer
    mov ecx, 10                        ; Divisor para extraer dígitos (base 10)
    mov ebx, eax                       ; Guardamos EAX en EBX para restaurarlo después

    ; Convertimos el número a ASCII en el buffer
convert_loop:
    xor edx, edx                       ; Limpia edx para la división
    div ecx                            ; Divide EAX entre 10, resultado en EAX, residuo en EDX
    add dl, '0'                        ; Convierte el residuo a carácter ASCII
    dec edi                            ; Retrocede el buffer
    mov [edi], dl                      ; Almacena el dígito convertido
    test eax, eax                      ; Verifica si queda algún dígito
    jnz convert_loop                   ; Repite mientras queden dígitos

    ; Imprimir el número convertido
    mov eax, 4                         ; syscall para sys_write
    mov ebx, 1                         ; file descriptor 1 (stdout)
    mov ecx, edi                       ; Puntero al número convertido
    sub edx, edi                       ; Longitud del número
    int 0x80                           ; Llamada al sistema

    ret                                 ; Regresar del procedimiento
