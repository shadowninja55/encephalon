# encephalon
brainfuck interpreter in x86-64 nasm

### details:
- 30,000 byte memory tape
- 65,536 byte program length limit
- data pointer wrap-around
- cell value wrap-around
- program read through stdin

### compiling & linking:
`$ nasm -felf64 encephalon.s && ld encephalon.o -o encephalon`
