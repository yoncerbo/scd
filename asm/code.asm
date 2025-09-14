ldi x1, 10
ldi x2, 11
sub x0, x1, x2
bzs 12
ldi x3, 255
stb x0, x3, x1

; TODO: add pseudo instruction
; TODO: add labels
