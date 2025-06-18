# CPU_Conditions_Flags

ASDB file was created in location /home/runner/dataset.asdb
# KERNEL: ----------------------------------------------------------------------------------------
# KERNEL: Instruction: 00010001010000100001000000000000
# KERNEL: Sign: 0, Zero: 1, Overflow: 0, Carry: 1
# KERNEL: 
# KERNEL: ADD 1--------------rdst :0,  rsrc1 :1,  rsrc2 :65535
# KERNEL: -----------------------------------------------------------------------------------------
# KERNEL: Instruction: 00010001010001100001100000000000
# KERNEL: Sign: 1, Zero: 0, Overflow: 1, Carry: 0
# KERNEL: 
# KERNEL: ADD 2--------------rdst :65534,  rsrc1 :32767,  rsrc2 :32767
# KERNEL: -----------------------------------------------------------------------------------------
# KERNEL: Instruction: 00010001010001100010000000000000
# KERNEL: Sign: 1, Zero: 0, Overflow: 0, Carry: 0
# KERNEL: 
# KERNEL: ADD 3--------------rdst :65535,  rsrc1 :32767,  rsrc2 :32768
# KERNEL: -----------------------------------------------------------------------------------------
# KERNEL: Instruction: 00011001010001100010000000000000
# KERNEL: Sign: 1, Zero: 0, Overflow: 1, Carry: 0
# KERNEL: 
# KERNEL: SUB  4--------------rdst :65535,  rsrc1 :32767,  rsrc2:32768
# KERNEL: -----------------------------------------------------------------------------------------
# KERNEL: Instruction: 00100001010001000001000000000000
# KERNEL: Sign: 1, Zero: 0, Overflow: 0, Carry: 0
# KERNEL: 
# KERNEL: MUL  5--------------rdst :1,  rsrc1 :65535,  rsrc2 :65535
# KERNEL: -----------------------------------------------------------------------------------------
# KERNEL: Instruction: 00100001010000100001000000000000
# KERNEL: Sign: 0, Zero: 0, Overflow: 0, Carry: 0
# KERNEL: 
# KERNEL: MUL  6--------------rdst :65534,  rsrc1 :65535,  rsrc2 :2
# RUNTIME: Info: RUNTIME_0068 testbench.sv (64): $finish called.
