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
    jle no_swap               ; Si ya está en orden, no intercambia

    ; Intercambiar valores usando temp
    mov [temp], al            ; Guardar AL en temp
    mov al, ah                ; Mover AH a AL
    mov [edi], al             ; Almacenar en EDI

