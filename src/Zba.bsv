//Instruction-2 add.uw: X(rd) = X(rs2) + EXTZ(X(rs1)[31..0])
//Function to add 2 unsigned word rs1,rs2
function Bit#(XLEN) fn_add_uw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + zeroExtend(rs1[31:0]);//LSB word of rs1 is zeroExtended and then added with rs2
endfunction
   

//Instruction-35: sh1add:
//Function to shiftleft by 1 and ADD
function Bit#(XLEN) fn_sh1add(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (rs1 << 1);//rs1 is shifted left by 1 position and then added with rs2
endfunction

//Instruction-36: sh1add_uw:
//Function to shift unsigned word left by 1 and ADD
function Bit#(XLEN) fn_sh1add_uw(Bit#(XLEN) rs1, Bit#(XLEN) rs2); // LSB word of rs1 is zeroExtended, left shifted by 1 position and then added with rs2
  return rs2 + (zeroExtend(rs1[31:0]) << 1);
endfunction

//Instruction-37: sh2add:
//Function to shiftleft by 2 and ADD
function Bit#(XLEN) fn_sh2add(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (rs1 << 2);//rs1 is shifted left by 2 position and then added with rs2
endfunction

//Instruction-38: sh2add_uw:
//Function to shift unsigned word left by 2 and ADD
function Bit#(XLEN) fn_sh2add_uw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (zeroExtend(rs1[31:0]) << 2);// LSB word of rs1 is zeroExtended, left shifted by 2 position and then added with rs2
endfunction

//Instruction-39: sh3add:
//Function to shiftleft by 3 and ADD
function Bit#(XLEN) fn_sh3add(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (rs1 << 3);//rs1 is shifted left by 3 position and then added with rs2
endfunction

//Instruction-40: sh3add_uw:
//Function to shift unsigned word left by 3 and ADD
function Bit#(XLEN) fn_sh3add_uw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs2 + (zeroExtend(rs1[31:0]) << 3);// LSB word of rs1 is zeroExtended, left shifted by 3 position and then added with rs2
endfunction

//Instruction-41: slli_uw:
//Function to shift left unsigned word(Immediate)
function Bit#(XLEN) fn_slli_uw(Bit#(XLEN) rs1, Bit#(32) instr);
  int shamt = unpack(zeroExtend(instr[26:20]));//ZeroExtending the shift amount given in instruction and converting to integer
  return (zeroExtend(rs1[31:0]) << shamt);//LSB word of rs1 is zeroExtended and then leftshifted by the value specified by shift amount
endfunction
