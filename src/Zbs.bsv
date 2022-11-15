//Instruction-3 bclr:  X(rd) = X(rs1) & ~(1 << (X(rs2) & (XLEN - 1)))

function Bit#(XLEN) fn_bclr(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) index =  0;
    `ifdef RV64
       index = zeroExtend(rs2[5:0]);
    `else 
       index = zeroExtend(rs2[4:0]);
    `endif
  return rs1 & ~(1 << index );
endfunction

//Instruction-4 bclri:  X(rd) = X(rs1) & ~(1 << (shamt & (XLEN - 1)))

function Bit#(XLEN) fn_bclri(Bit#(XLEN) rs1, Bit#(32) instr);
   Bit#(XLEN_log) shamt =  instr[19+valueof(XLEN_log):20];
  return rs1 & ~(1 << shamt);
endfunction

//Instruction-5 bext: X(rd) = (X(rs1) >> (X(rs2) & (XLEN - 1))) & 1

function Bit#(XLEN) fn_bext(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) index =  0;
    `ifdef RV64
       index = zeroExtend(rs2[5:0]);
    `else 
       index = zeroExtend(rs2[4:0]);
    `endif
  return rs1 >> index & 1;
endfunction

//Instruction-6 bexti:  

function Bit#(XLEN) fn_bexti(Bit#(XLEN) rs1, Bit#(32) instr);
   Bit#(XLEN_log) shamt =  instr[19+valueof(XLEN_log):20];
  return rs1>>shamt & 1;
endfunction

//Instruction-7 binv: rs1 ^ (1 << (rs2 & (#(XLEN) -1)))

function Bit#(XLEN) fn_binv(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) index =  0;
    `ifdef RV64
       index = zeroExtend(rs2[5:0]);
    `else 
       index = zeroExtend(rs2[4:0]);
    `endif
  return rs1 ^ (1 << index);
endfunction

//Instruction-8 binvi:  

function Bit#(XLEN) fn_binvi(Bit#(XLEN) rs1, Bit#(32) instr);
   Bit#(XLEN_log) shamt =  instr[19+valueof(XLEN_log):20];
  return rs1 ^ (1 <<shamt);
endfunction


//Instruction-9 bset: rs1 | (1 << (rs2 & (#(XLEN) -1)))

function Bit#(XLEN) fn_bset(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) index =  0;
    `ifdef RV64
       index = zeroExtend(rs2[5:0]);
    `else 
       index = zeroExtend(rs2[4:0]);
    `endif
  return rs1 | (1 << (index));
endfunction

//Instruction-10 bseti:  

function Bit#(XLEN) fn_bseti(Bit#(XLEN) rs1, Bit#(32) instr);
   Bit#(XLEN_log) shamt =  instr[19+valueof(XLEN_log):20];
  return rs1 | (1 <<shamt);
endfunction
