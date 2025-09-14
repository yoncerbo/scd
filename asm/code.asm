ldi x1, 10
ldi x2, 2
csi 12

ldi x3, 255
stb x0, x3, x1
jmi 200

; add(x1, x2)
add x1, x1, x2
ret

; TODO: add labels
