//Instruction-1 andn: anding after negating the content in second register

function Bit#(XLEN) fn_andn(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs1 & ~rs2;   //and of rs1 with ~rs2
endfunction

//Instruction-14 clz: count leading zero bits

function Bit#(XLEN) fn_clz(Bit#(XLEN) rs1);
  Bool check = False; //check condition to stop counting after encountering 1
  Bit#(XLEN) count = fromInteger(valueof(XLEN));//Initialising to XLEN for rs1 =0 case as don't have any 1's
  for(Bit#(XLEN) i = fromInteger(valueof(XLEN))-1; i > 0; i = i-1)//checking for '1' starting from MSB
    if(rs1[i] == 1) begin //If 1 is found ->
       if(check == False) begin
         count = fromInteger(valueof(XLEN))-i-1;//count of no. of zeros
         check = True;//stop counting
       end
    end
  if(rs1==1) begin//as rs1[0]==1 case is not covered
    count = fromInteger(valueof(XLEN))-1;
  end
  return count;
endfunction

//Instruction-15 clzw: count leading zero bits in least signifcant word

function Bit#(XLEN) fn_clzw(Bit#(XLEN) rs1);
  Bool check = False;
  Bit#(XLEN) count = 32;//Initialising to 32 for rs1 =0 case as don't have any 1's
  for(Bit#(XLEN) i = 31; i > 0; i = i-1)//checking for '1' starting from MSB of lsw
    if(rs1[i] == 1) begin
       if(check == False) begin
         count = 31-i;//count of no. of zeros
         check = True;//stop counting
       end
    end
  if(rs1==1) begin//as rs1[0]==1 case is not covered
    count = 31;
  end
  return count;
endfunction

//Instruction-16 cpop: count set bits

function Bit#(XLEN) fn_cpop(Bit#(XLEN) rs1);
  Bit#(XLEN) count = 0;
  for(int i = 0; i < fromInteger(valueof(XLEN)); i = i+1)//going from LSB to 63rd index
    if(rs1[i] == 1) begin
         count = count + 1;//add 1 if bit is 1
    end
  return count;
endfunction

//Instruction-17 cpopw: count set bits in least significant word

function Bit#(XLEN) fn_cpopw(Bit#(XLEN) rs1);
  Bit#(XLEN) count = 0;
  for(int i = 0; i < 32; i = i+1)//going from LSB to 31 index
    if(rs1[i] == 1) begin
         count = count + 1;//add 1 if bit is 1
    end
  return count;
endfunction

//Instruction-18 ctz: count trailing zeros

function Bit#(XLEN) fn_ctz(Bit#(XLEN) rs1);
  Bool check = False;
  Bit#(XLEN) count = 0;
  for(int i = 0; i < fromInteger(valueof(XLEN)); i = i+1) begin//going from LSB to left
    if(rs1[i] == 0 && check == False) begin
         count = count + 1;//add 1 if bit is 0
    end
    if(rs1[i] == 1 && check == False) begin
         check = True;//stop counting when u encounter 1
    end
  end
  return count;
endfunction

//Instruction-19 ctzw: count trailing zeros in least significant word

function Bit#(XLEN) fn_ctzw(Bit#(XLEN) rs1);
  Bool check = False;
  Bit#(XLEN) count = 0;
  for(int i = 0; i < 32; i = i+1) begin//going from LSB to left on lsw
    if(rs1[i] == 0 && check == False) begin
         count = count + 1;//add 1 if bit is 0
    end
    if(rs1[i] == 1 && check == False) begin
         check = True;//stop counting when u encounter 1
    end
  end
  return count;
endfunction


/* Performing comparison for signed integers in 2's complement form:
when both numbers have same sign:

Eg: 
Same sign
(i) 0000(=0), 0111(=7) max(0000, 0111) will be 0111 (same as max from normal comparison)
(ii)1000(-8), 1111(-1) max(1000, 1111) = 1111 (same as max from normal comparison)
Opposite sign
(iii) when 0111, 1000 is given max will be positive number
*/


//Instruction-20 max: X(rd) = max_signed(X(rs1), X(rs2));
function Bit#(XLEN) fn_max(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(1) s1 = rs1[valueof(XLEN)-1];
  Bit#(1) s2 = rs2[valueof(XLEN)-1];
  Bit#(XLEN) out = rs1;
  if ((s1 == s2 && rs2>rs1) || ((s1+s2 == 1) && (s2 == 0)))//Doing the above operation
      out = rs2;
  return out;
endfunction

//Instruction-21 maxu: X(rd) = max_unsigned(X(rs1), X(rs2));
function Bit#(XLEN) fn_maxu(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) out = rs1;
  if (rs1 < rs2)//performing normal comparison and take max
     out = rs2;
  return out;
endfunction

/* Performing comparison for signed integers in 2's complement form:
when both numbers have same sign:

Eg: 
Same sign
(i) 0000(=0), 0111(=7) min(0000, 0111) will be 0000 (same as min from normal comparison)
(ii)1000(-8), 1111(-1) min(1000, 1111) = 1000 (same as min from normal comparison)
Opposite sign
(iii) when 0111, 1000 is given min will be negative number
*/

//Instruction-22 min: X(rd) = min_signed(X(rs1), X(rs2));
function Bit#(XLEN) fn_min(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(1) s1 = rs1[valueof(XLEN)-1];
  Bit#(1) s2 = rs2[valueof(XLEN)-1];
  Bit#(XLEN) out = rs1;
  if ((s1 == s2 && rs2<rs1) || ((s1+s2 == 1) && (s2 == 1)))//Doing the above operation
      out = rs2;
  return out;
endfunction

//Instruction-23 minu: X(rd) = min_unsigned(X(rs1), X(rs2));
function Bit#(XLEN) fn_minu(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) out = rs1;
  if (rs1 > rs2)//performing normal comparison and take min
     out = rs2;
  return out;
endfunction

//Instruction-24 orc.b: bitwise or combine

function Bit#(XLEN) fn_orc_b(Bit#(XLEN) rs1);
  Bit#(8) num = 0;
  Bit#(XLEN) out = 0;
  for(Bit#(XLEN) i = 0; i < fromInteger(valueof(XLEN)); i = i+8) begin//getting a byte
    if(rs1[i+7:i] > num) //checking if atleast one bit is 1
        out = out + (255 << i);//if it is 1- replacing the byte with 11111111 (=255)
  end
  return out;
endfunction

//Instruction-25 orn: X(rd) = X(rs1) | ~X(rs2);

function Bit#(XLEN) fn_orn(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return rs1 | ~rs2;//performing rs1 or with negated rs2
endfunction

//Instruction-26 rev8: reversing bits of each byte
function Bit#(XLEN) fn_rev8(Bit#(XLEN) rs1);
  Bit#(XLEN) out = 0;
  for(Bit#(XLEN) i = 0; i < fromInteger(valueof(XLEN)); i = i+8) begin       
        for (Bit#(XLEN) j = 0; j< 8; j = j+1)//getting a byte
              out[i+j] = rs1[i+7-j];//reversing value by value in each byte taken
  end
  return out;
endfunction

//Instruction-27: rol:rotating left by log(xlen) bits in rs2
function Bit#(XLEN) fn_rol(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    int index =  0;
    `ifdef RV64//last log(xlen) bits of rs2
       index = unpack(zeroExtend(rs2[5:0]));
    `else 
       index = unpack(zeroExtend(rs2[4:0]));
    `endif
  return (rs1 << index | rs1 >> (fromInteger(valueof(XLEN)) - index));//rotating rs1 left by index
endfunction

//Instruction-28: rolw:rotating least significant word left by 5 bits in rs2
function Bit#(XLEN) fn_rolw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(32) rint = rs1[31:0];//lsw of rs1
    int index =  unpack(zeroExtend(rs2[4:0]));//last 5 bits of rs2
  return signExtend(rint << index | rint >> (32 - index));//rotating lsw left by index
endfunction

//Instruction-29: ror:rotating right by log(xlen) bits in rs2
function Bit#(XLEN) fn_ror(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    int index =  0;
    `ifdef RV64 //getting last log(xlen) bits of rs2
       index = unpack(zeroExtend(rs2[5:0]));
    `else 
       index = unpack(zeroExtend(rs2[4:0]));
    `endif
  return (rs1 >> index | rs1 << (fromInteger(valueof(XLEN)) - index));//rotating right by index
endfunction

//Instruction-30: rori:rotating rs1 right by shamt
function Bit#(XLEN) fn_rori(Bit#(XLEN) rs1, Bit#(32) instr);
  int shamt =  unpack(instr[19+valueof(XLEN_log):20]);//extracting shamt from instruction
  return (rs1 >> shamt | rs1 << (fromInteger(valueof(XLEN)) - shamt));//rotating right by shamt
endfunction

//Instruction-31: roriw:rotating least significant word right by shamt
function Bit#(XLEN) fn_roriw(Bit#(XLEN) rs1, Bit#(32) instr);
    int shamt =  unpack(zeroExtend(instr[25:20]));//extracting shamt from instruction
    Bit#(32) rint = rs1[31:0];//least significant word of rs1
  return signExtend(rint >> shamt | rint << (32 - shamt));//rotating lsw right by shamt
endfunction

//Instruction-32: rorw:rotating least significant word of rs1 right by last 5 bits of rs2
function Bit#(XLEN) fn_rorw(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
    Bit#(32) rint = rs1[31:0];//least significant word
    int index =  unpack(zeroExtend(rs2[4:0]));//last 5 bits of rs2
  return signExtend(rint >> index | rint << (32 - index));//rotating lsw right by index
endfunction


//Instruction-33: sext.b: signextension on least significant byte
function Bit#(XLEN) fn_sext_b(Bit#(XLEN) rs1);
  return signExtend(rs1[7:0]);//sign extension on least significant 8 bits
endfunction

//Instruction-34: sext.h: signextension on least significant halfword
function Bit#(XLEN) fn_sext_h(Bit#(XLEN) rs1);
  return signExtend(rs1[15:0]);//sign extension on least significant 16 bits
endfunction

//Instruction-41: xnor: ~(X(rs1) ^ X(rs2))
function Bit#(XLEN) fn_xnor(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  return ~(rs1 ^ rs2);//xnor operation 
endfunction

//Instruction-43: zext.h: zeroextension on least significant halfword
function Bit#(XLEN) fn_zext_h(Bit#(XLEN) rs1);
  return zeroExtend(rs1[15:0]);//zero extension on least signicant 16 bits
endfunction

