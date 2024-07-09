global _start

section .bss
  mem: resb 30000
  ins: resb 65536
  put: resb 1
  get: resb 1

section .text
exit:
  mov eax, 60
  xor edi, edi
  syscall
_start:
  xor eax, eax  ; read program
  xor edi, edi
  mov rsi, ins
  mov edx, 65536
  syscall
  mov r8, ins   ; instruction pointer
  mov r9, mem   ; data pointer
  exec:
    mov al, [r8]  ; instruction
    test al, al
    jz exit       ; null instruction is eof
    cmp al, '>'
    je right
    cmp al, '<'
    je left
    cmp al, '+'
    je inc
    cmp al, '-'
    je dec
    cmp al, '.'
    je _put
    cmp al, ','
    je _get
    cmp al, '['
    je begin
    cmp al, ']'
    je end
  cont:
    inc r8
    jmp exec
right:
  cmp r9, mem + 29999
  je .wrap
  inc r9 
  jmp cont
  .wrap:
    mov r9, mem
    jmp cont
left:
  cmp r9, mem
  je .wrap
  dec r9
  jmp cont
  .wrap:
    lea r9, [mem + 29999]
    jmp cont
inc:
  inc byte [r9]
  jmp cont
dec:
  dec byte [r9]
  jmp cont
_put:
  mov al, [r9]
  mov [put], al
  mov eax, 1
  mov edi, 1
  mov rsi, put
  mov edx, 1
  syscall
  jmp cont
_get:
  xor eax, eax
  xor edi, edi
  mov rsi, get
  mov edx, 1
  syscall
  mov al, [get]
  mov [r9], al
  jmp cont
begin:
  mov al, [r9]  ; cell byte
  test al, al
  jnz cont
  mov rcx, 1    ; loop depth
  .inner:
    test rcx, rcx
    jz cont
    inc r8
    mov al, [r8]
    cmp al, '['
    je .inc
    cmp al, ']'
    je .dec
    jmp .inner
  .inc:
    inc rcx
    jmp .inner
  .dec:
    dec rcx
    jmp .inner
end:
  mov al, [r9]  ; cell byte
  test al, al
  jz cont
  mov rcx, 1    ; loop depth
  .inner:
    test rcx, rcx
    jz cont
    dec r8
    mov al, [r8]
    cmp al, '['
    je .dec
    cmp al, ']'
    je .inc
    jmp .inner
  .inc:
    inc rcx
    jmp .inner
  .dec:
    dec rcx
    jmp .inner
