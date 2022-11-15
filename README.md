## Goal:

Goal of the project is to implement extended RISC-V architecure in bluespec

## Files:

In src folder:

we have:

1. bbox.defines - where we map name to encoding of the instruction
2. bbox_types.bsv - where we have instr declared as struct variable to handle multiple inputs - instr, rs1, rs2
3. compute.bsv - has all case statements, where we call relevant function for execution when instruction is provided
4. zbx.bsv files - this is where functions of all instructions are written in their respective files

x=a refers to address manipulation instructions
x=b refers to bit manipulation
x=c refers to carry less multiplication
x=s refers to single bit manipulation

Carry less multiplication is a special form of multiplication where carry is neglected at every stage.

## Example instruction in Zbx.bsv files

## 
