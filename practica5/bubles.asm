section .data
    numbers db 5, 3, 8, 1, 2  ; Lista de 5 números desordenados
    newline db 10             ; Carácter de nueva línea

section .bss
    temp resb 1               ; Variable temporal para intercambio

section .text
global _start

_start:
    ; Cargar los números en la pila
    mov ecx, 5                ; Número de elementos a cargar
    lea esi, [numbers]        ; Dirección de la lista de números

load_numbers:
    lodsb                     ; Cargar el siguiente byte de [numbers] en AL
    push eax                  ; Empujar AL (el número) en la pila
    loop load_numbers         ; Repetir hasta que ECX sea cero

    ; Ordenamiento burbuja usando la pila
    mov ecx, 5                ; Número de elementos en la lista
bubble_sort:
    dec ecx                   ; Cada pasada reduce el rango a verificar
    mov ebx, ecx              ; EBX será el índice interno del bucle

    ; Bucle interno de comparación
    mov edi, esp              ; Apuntar EDI a la cima de la pila
compare_loop:
    mov al, byte [edi]        ; AL = valor en EDI
    mov ah, byte [edi + 4]    ; AH = valor en EDI+4 (siguiente elemento)

    ; Comparar y, si es necesario, intercambiar
    cmp al, ah
    jle skip_swap             ; Si ya está en orden, no intercambia

    ; Intercambiar valores usando temp
    mov [temp], al            ; Guardar AL en temp
    mov al, ah                ; Mover AH a AL
    mov [edi], al             ; Almacenar en EDI
    mov al, byte [temp]       ; Recuperar el valor original de AL
    mov [edi + 4], al         ; Almacenar en EDI+4

skip_swap:
    add edi, 4                ; Mover al siguiente par en la pila
    dec ebx                   ; Disminuir el índice interno
    jnz compare_loop          ; Repetir hasta ordenar todos los pares

    cmp ecx, 1
    jg bubble_sort            ; Repetir el bucle hasta ordenar toda la lista

    ; Imprimir los números ordenados sin sacar de la pila
    mov ecx, 5                ; Número de elementos a imprimir
    mov edi, esp              ; Apuntar EDI al tope de la pila

print_numbers:
    mov al, byte [edi]        ; Obtener el valor en el tope de la pila
    add al, '0'               ; Convertir a carácter ASCII
    mov [temp], al            ; Guardar el carácter en temp

    ; Llamada al sistema para escribir en la salida estándar
    mov eax, 4                ; syscall número para escribir
    mov ebx, 1                ; descriptor de archivo para salida estándar
    lea ecx, [temp]           ; Dirección del carácter a imprimir
    mov edx, 1                ; Número de bytes a escribir
    int 0x80                  ; Interrupción para la salida

    ; Imprimir nueva línea después de cada número
    mov eax, 4
    mov ebx, 1
    lea ecx, [newline]
    mov edx, 1
    int 0x80

    add edi, 4                ; Mover al siguiente número en la pila
    loop print_numbers        ; Repetir para cada número en la pila

    ; Salir del programa
    mov eax, 1                ; syscall número para salir
    xor ebx, ebx              ; Código de salida 0
    int 0x80


