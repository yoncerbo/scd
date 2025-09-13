ldi x1, 10
ldi x2, 2

jli x15, 10
ldi x2, 255
stb x0, x2, x1

; add(x1, x2)
add x1, x1, x2
jlr x0, x15, x0

; TODO: add branches
; TODO: add pseudo instruction
; TODO: add labels
