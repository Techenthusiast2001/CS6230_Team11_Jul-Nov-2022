//Instruction-1 andn: anding after negating the content in second register

function Bit#(XLEN) fn_andn(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs1 & ~rs2;
endfunction

//Instruction-14 clz: count leading zero bits

function Bit#(XLEN) fn_clz(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 0;
  int check = 0;
  `ifdef RV64
    lim = 64;
  `else 
    lim = 32;
  `endif
  Bit#(XLEN) count = lim;
  for(Bit#(XLEN) i = lim-1; i > 0; i = i-1)
    if(rs1[i] == 1) begin
       if(check == 0) begin
         count = lim-i-1;
         check = 1;
       end
    end
  return count;
endfunction

//Instruction-15 clzw: count leading zero bits in least signifcant word

function Bit#(XLEN) fn_clzw(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 32;
  int check = 0;
  Bit#(XLEN) count = lim;
  for(Bit#(XLEN) i = lim-1; i > 0; i = i-1)
    if(rs1[i] == 1) begin
       if(check == 0) begin
         count = lim-i-1;
         check = 1;
       end
    end
  return count;
endfunction

//Instruction-16 cpop: count set bits

function Bit#(XLEN) fn_cpop(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 0;
  `ifdef RV64
    lim = 64;
  `else 
    lim = 32;
  `endif
  Bit#(XLEN) count = 0;
  for(Bit#(XLEN) i = 0; i < lim; i = i+1)
    if(rs1[i] == 1) begin
         count = count + 1;
    end
  return count;
endfunction

//Instruction-17 cpopw: count set bits in least significant word

function Bit#(XLEN) fn_cpopw(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 32;
  Bit#(XLEN) count = 0;
  for(Bit#(XLEN) i = 0; i < lim; i = i+1)
    if(rs1[i] == 1) begin
         count = count + 1;
    end
  return count;
endfunction

//Instruction-18 ctz: count trailing zeros

function Bit#(XLEN) fn_ctz(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 0;
  int check = 0;
  `ifdef RV64
    lim = 64;
  `else 
    lim = 32;
  `endif
  Bit#(XLEN) count = 0;
  for(Bit#(XLEN) i = 0; i < lim; i = i+1) begin
    if(rs1[i] == 0 && check == 0) begin
         count = count + 1;
    end
    if(rs1[i] == 1 && check == 0) begin
         check = 1;
    end
  end
  return count;
endfunction

//Instruction-19 ctzw: count trailing zeros in least significant word

function Bit#(XLEN) fn_ctzw(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 32;
  int check = 0;
  Bit#(XLEN) count = 0;
  for(Bit#(XLEN) i = 0; i < lim; i = i+1) begin
    if(rs1[i] == 0 && check == 0) begin
         count = count + 1;
    end
    if(rs1[i] == 1 && check == 0) begin
         check = 1;
    end
  end
  return count;
endfunction

//Instruction-20 max: X(rd) = max_signed(X(rs1), X(rs2));
function Bit#(XLEN) fn_max(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(1) s1 = rs1[valueof(XLEN)-1];
  Bit#(1) s2 = rs2[valueof(XLEN)-1];
  Bit#(XLEN) out = rs1;
  if ((s1 == s2 && rs2>rs1) || ((s1+s2 == 1) && (s2 == 0)))
      out = rs2;
  return out;
endfunction

//Instruction-21 maxu: X(rd) = max_unsigned(X(rs1), X(rs2));
function Bit#(XLEN) fn_maxu(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) out = rs1;
  if (rs1 < rs2)
     out = rs2;
  return out;
endfunction

//Instruction-22 min: X(rd) = min_signed(X(rs1), X(rs2));
function Bit#(XLEN) fn_min(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(1) s1 = rs1[valueof(XLEN)-1];
  Bit#(1) s2 = rs2[valueof(XLEN)-1];
  Bit#(XLEN) out = rs1;
  if ((s1 == s2 && rs2<rs1) || ((s1+s2 == 1) && (s2 == 1)))
      out = rs2;
  return out;
endfunction

//Instruction-23 minu: X(rd) = min_unsigned(X(rs1), X(rs2));
function Bit#(XLEN) fn_minu(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) out = rs1;
  if (rs1 > rs2)
     out = rs2;
  return out;
endfunction

//Instruction-24 orc.b: bitwise or combine

function Bit#(XLEN) fn_orc_b(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 0;
  Bit#(8) num = 0;
  `ifdef RV64
    lim = 64;
  `else 
    lim = 32;
  `endif
  Bit#(XLEN) out = 0;
  for(Bit#(XLEN) i = 0; i < lim; i = i+8) begin
    if(rs1[i+7:i] > num) 
        out = out + (255 << i);
  end
  return out;
endfunction

//Instruction-25 orn: X(rd) = X(rs1) | ~X(rs2);

function Bit#(XLEN) fn_orn(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs1 | ~rs2;
endfunction

//Instruction-26 rev8:
function Bit#(XLEN) fn_rev8(Bit#(XLEN) rs1);
  Bit#(XLEN) lim = 0;
  `ifdef RV64
    lim = 64;
  `else 
    lim = 32;
  `endif
  Bit#(XLEN) out = 0;
  for(Bit#(XLEN) i = 0; i < lim; i = i+8) begin       
        for (Bit#(XLEN) j = 0; j< 8; j = j+1)
              out[i+j] = rs1[i+7-j];
  end
  return out;
endfunction

//Instruction-27: rol:
function Bit#(XLEN) fn_rol(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) index =  0;
    Bit#(XLEN) lim =  0;
    `ifdef RV64
       index = zeroExtend(rs2[5:0]);
       lim = 64;
    `else 
       index = zeroExtend(rs2[4:0]);
       lim = 32;
    `endif
  return (rs1 << index | rs1 >> (lim - index));
endfunction

//Instruction-28: rolw:
function Bit#(XLEN) fn_rolw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(32) rint = rs1[31:0];
    Bit#(XLEN) index =  zeroExtend(rs2[4:0]);
    Bit#(XLEN) lim =  32;
  return signExtend(rint << index | rint >> (lim - index));
endfunction

//Instruction-29: ror:
function Bit#(XLEN) fn_ror(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(XLEN) index =  0;
    Bit#(XLEN) lim =  0;
    `ifdef RV64
       index = zeroExtend(rs2[5:0]);
       lim = 64;
    `else 
       index = zeroExtend(rs2[4:0]);
       lim = 32;
    `endif
  return (rs1 >> index | rs1 << (lim - index));
endfunction

//Instruction-30: rori:
function Bit#(XLEN) fn_rori(Bit#(XLEN) rs1, Bit#(32) instr);
    int lim =  0;
    `ifdef RV64
       lim = 64;
    `else 
       lim = 32;
    `endif
  int shamt =  unpack(instr[19+valueof(XLEN_log):20]);
  return (rs1 >> shamt | rs1 << (lim - shamt));
endfunction

//Instruction-31: roriw:
function Bit#(XLEN) fn_roriw(Bit#(XLEN) rs1, Bit#(32) instr);
    int shamt =  unpack(zeroExtend(instr[25:20]));
    Bit#(32) rint = rs1[31:0];
    int lim =  32;
  return signExtend(rint >> shamt | rint << (lim - shamt));
endfunction

//Instruction-32: rorw:
function Bit#(XLEN) fn_rorw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(32) rint = rs1[31:0];
    Bit#(XLEN) lim = 32;
    Bit#(XLEN) shamt =  zeroExtend(rs2[4:0]);
  return signExtend(rint >> shamt | rint << (lim - shamt));
endfunction


//Instruction-33: sext.b
function Bit#(XLEN) fn_sext_b(Bit#(XLEN) rs1);
  return signExtend(rs1[7:0]);
endfunction

//Instruction-34: sext.h
function Bit#(XLEN) fn_sext_h(Bit#(XLEN) rs1);
  return signExtend(rs1[15:0]);
endfunction

//Instruction-41: xnor:
function Bit#(XLEN) fn_xnor(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return ~(rs1 ^ rs2);
endfunction

//Instruction-43: zext.h
function Bit#(XLEN) fn_zext_h(Bit#(XLEN) rs1);
  return zeroExtend(rs1[15:0]);
endfunction

