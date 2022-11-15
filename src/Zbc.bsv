//Instruction-11 clmull: 
//Carry less Multiplication and returns the lower half of the product
function Bit#(XLEN) fn_clmul(Bit#(XLEN) rs1, Bit#(XLEN) rs2);//rs1=Multiplier, rs2 Multiplicand
  Bit#(XLEN) out = 0;
  Bit#(1) a = 0;
  for(Integer i=0; i< valueof(XLEN); i = i+1) begin//loop runs from 0 to xlen
      a = ((rs2>>i) & 1)[0]; //In each iteration, if the multiplicand's(rs2) rightshifted(by i) value is 1, then the leftshifted(by i) value of multiplier(rs1) is added to the output.
      if(a == 1)		
      out = out ^ (rs1 << i);
   end
 return out;
endfunction

//Instruction-12 clmulh: 
//Carry less Multiplication and returns the upper half of the product
function Bit#(XLEN) fn_clmulh(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) out = 0;
  Bit#(1) a = 0;
  for(Integer i=1; i<valueof(XLEN); i = i+1) begin//loop runs from 0 to xlen
      a = ((rs2>>i) & 1)[0];//In each iteration, if the multiplicand's(rs2) rightshifted(by i) value is 1, then the rightshifted(by xlen-i) value of multiplier(rs1) is added to the output.
      if(a == 1)
      out = out ^ (rs1 >> (valueof(XLEN)-i));
   end
 return out;
endfunction

//Instruction-13 clmulr: 
//Carry less Multiplication-reversed
function Bit#(XLEN) fn_clmulr(Bit#(XLEN) rs1, Bit#(XLEN) rs2);
  Bit#(XLEN) out = 0;
  Bit#(1) a = 0;
  for(Integer i=0; i<valueof(XLEN); i = i+1) begin//loop runs from 0 to xlen
      a = ((rs2>>i) & 1)[0];//In each iteration, if the multiplicand's(rs2) rightshifted(by i) value is 1, then the rightshifted(by xlen-i-1) value of multiplier(rs1) is added to the output.
      if(a == 1)
      out = out ^ (rs1 >> (valueof(XLEN)-i-1));
   end
 return out;
endfunction
