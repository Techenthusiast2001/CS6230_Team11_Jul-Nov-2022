## Goal:

Goal of the project is to implement extended RISC-V architecure in bluespec

## Files:

### In src folder:

we have:

1. bbox.defines - where we map name to encoding of the instruction
2. bbox_types.bsv - where we have instr declared as struct variable to handle multiple inputs - instr, rs1, rs2
3. compute.bsv - has all case statements, where we call relevant function for execution when instruction is provided
4. zbx.bsv files - this is where functions of all instructions are written in their respective files

x=a refers to address manipulation instructions <br />
x=b refers to bit manipulation <br />
x=c refers to carry less multiplication <br />
x=s refers to single bit manipulation <br />

Carry less multiplication is a special form of multiplication where carry is neglected at every stage.

### In bbox_verif folder:

we have:

1. bbox_ref_model.py - where we evaluate the same instructions in python (used for comparing the results)
2. test_bbox.py - the python file where instructions and values for rs1, rs2 inputs are given and results are compared and printed.

## Instructions

#### Variants in instructions <br />

1. instr_name rd, rs1, rs2
2. instr_name rd, rs
3. instr_name rd, rs1, shamt

#### Encoding of instruction

Encoding helps us uniquely identify the instruction as well get address of destination, input registers and also shift amount where necessary. <br />

## How to run?

1. Go to test_bbox.py:

   Add needed instructions using tf.add_option in the format: <br />

```
tf.add_option(('instr','instr_name','single_opd', 'immediate'), [(0b01000000000000000111000000110011, 'andn', 0, 0)]) <br />
```
where,<br />
  instr = encoding of instruction with proper shamt value <br />
  instr_name = name of instruction for priniting <br />
  single_opd = (1 if it is single operand instruction like zext.h rd, rs) else 0 <br />
  immediate =  (1 for immediate instructions where value of shift amount is taken from the instruction) else 0 <br />

2. You can also give custom input cases by replacing the values of rs1, rs2 from random.randint(0, 2**XLEN-1) to your custom value <br />

3. Now go to current folder location in terminal and activate virtual python environment using:
```
pyenv activate py36
```
4. Now convert bluespec code to verilog using:
```
make generate_verilog
```

5. To simulate and get comparison of results:
```
make clean_build (not needed for first run and few cases)
make simulate
```
6. To switch from RV32 toi RV64 (or viceversa):

```
1. Change BSCDEFINES in make file from RV32 to RV64
2. Change base in test_bbox.py to RV64
3. Perform make clean_build before simulation
```



