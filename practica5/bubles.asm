section .data
    numbers db 3, 8, 6, 4, 1   ; Lista de 5 números desordenados
    newline db 10              ; Carácter de nueva línea
    space db ' ', 0            ; Espacio entre números

section .bss
    temp resb 1                ; Variable temporal para intercambio
    sorted resb 5              ; Área para almacenar la lista ordenada

section .text
global _start

_start:
    ; Cargar los números en el área temporal "sorted"
    mov ecx, 5                 ; Número de elementos a cargar
    lea esi, [numbers]         ; Dirección de la lista de números
    lea edi, [sorted]          ; Dirección del área temporal para la lista ordenada

load_numbers:
    lodsb                      ; Cargar el siguiente byte de [numbers] en AL
    stosb                      ; Almacenar AL en la lista "sorted"
    loop load_numbers          ; Repetir hasta que ECX sea cero

    ; Ordenamiento burbuja usando el área temporal en memoria
    mov ecx, 5                 ; Número de elementos en la lista
bubble_sort:
    dec ecx                    ; Cada pasada reduce el rango a verificar
    mov ebx, ecx               ; EBX será el índice interno del bucle

    ; Bucle interno de comparación
    lea edi, [sorted]          ; Apuntar EDI al inicio de la lista "sorted"
compare_loop:
    mov al, byte [edi]         ; AL = valor en EDI
    mov ah, byte [edi + 1]     ; AH = valor en EDI+1 (siguiente elemento)

    ; Comparar y, si es necesario, intercambiar
    cmp al, ah
    jle skip_swap              ; Si ya está en orden, no intercambia

    ; Intercambiar valores usando temp
    mov [temp], al             ; Guardar AL en temp
    mov al, ah                 ; Mover AH a AL
    mov [edi], al              ; Almacenar en EDI
    mov al, byte [temp]        ; Recuperar el valor original de AL
    mov [edi + 1], al          ; Almacenar en EDI+1

    ; Imprimir el arreglo después de cada intercambio
    call print_array

skip_swap:
    inc edi                    ; Mover al siguiente par en la lista
    dec ebx                    ; Disminuir el índice interno
    jnz compare_loop           ; Repetir hasta ordenar todos los pares

    cmp ecx, 1
    jg bubble_sort             ; Repetir el bucle hasta ordenar toda la lista

    ; Imprimir el arreglo final
    call print_array

    ; Salir del programa
    mov eax, 1                 ; syscall número para salir
    xor ebx, ebx               ; Código de salida 0
    int 0x80

;-------------------------------------
; print_array
; Imprime el estado actual del arreglo "sorted"
print_array:
    mov ecx, 5                 ; Número de elementos a imprimir
    lea edi, [sorted]          ; Apuntar EDI al inicio de "sorted"

print_numbers:
    mov al, byte [edi]         ; Obtener el valor en "sorted"
    add al, '0'                ; Convertir a carácter ASCII
    mov [temp], al             ; Guardar el carácter en temp

    ; Llamada al sistema para escribir en la salida estándar
    mov eax, 4                 ; syscall número para escribir
    mov ebx, 1                 ; descriptor de archivo para salida estándar
    lea ecx, [temp]            ; Dirección del carácter a imprimir
    mov edx, 1                 ; Número de bytes a escribir
    int 0x80                   ; Interrupción para la salida

    ; Imprimir un espacio entre los números
    mov eax, 4
    mov ebx, 1
    lea ecx, [space]
    mov edx, 1
    int 0x80

    inc edi                    ; Mover al siguiente número en "sorted"
    loop print_numbers         ; Repetir hasta que se hayan imprimido 5 números

    ; Imprimir nueva línea después del arreglo completo
    mov eax, 4
    mov ebx, 1
    lea ecx, [newline]
    mov edx, 1
    int 0x80

    ret



