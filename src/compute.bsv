//See LICENSE.iitm for license details
/*

Author : Mouna Krishna
Email id : mounakrishna@mindgrovetech.in
Details: The top function which calls the required function depending 
         on the instruction.

--------------------------------------------------------------------------------------------------
*/

/****** Imports *******/
`include "bbox.defines"
import bbox_types :: *;
`include "Zba.bsv"
`include "Zbb.bsv"
`include "Zbc.bsv"
`include "Zbs.bsv"
/*********************/


/*doc: function: The top function where depending on the instruction the 
  required function is called, get the result and return it.
  The input argument and return type should not be changed. 
  Other than this, all the other code can be changed as per needs.

  As an example the instruction ANDN of the Zbb group has been implemented.
  NOTE: The value of ANDN in bbox.defines is a temp value, it needed to be 
  changed according to spec.
  The complete Zbb group and all the other groups is expected to be implemented 
  and verified.
*/
function BBoxOutput fn_compute(BBoxInput inp);
  Bit#(XLEN) result = 0;
  Bool valid = False;
  case(inp.instr) matches
   `BCLR: begin
      result = fn_bclr(inp.rs1, inp.rs2);
      valid = True;
    end
    `BEXT: begin
      result = fn_bext(inp.rs1, inp.rs2);
      valid = True;
    end
    `BINV: begin
      result = fn_binv(inp.rs1, inp.rs2);
      valid = True;
    end
    `BSET: begin
      result = fn_bset(inp.rs1, inp.rs2);
      valid = True;
    end
    `CLMUL: begin
      result = fn_clmul(inp.rs1, inp.rs2);//Function call to clmul with inputs rs1, rs2; output stored in result
      valid = True;
    end
    `CLMULH: begin
      result = fn_clmulh(inp.rs1, inp.rs2);//Function call to clmuh with inputs rs1, rs2; output stored in result
      valid = True;
    end
    `CLMULR: begin
      result = fn_clmulr(inp.rs1, inp.rs2);//Function call to clmulr with inputs rs1, rs2; output stored in result
      valid = True;
    end

    `SH1ADD: begin
      result = fn_sh1add(inp.rs1, inp.rs2);//Function call to sh1add with inputs rs1, rs2; output stored in result
      valid = True;
    end
    `SH2ADD: begin
      result = fn_sh2add(inp.rs1, inp.rs2);//Function call to sh2add with inputs rs1, rs2; output stored in result
      valid = True;
    end
    `SH3ADD: begin
      result = fn_sh3add(inp.rs1, inp.rs2);//Function call to sh3add with inputs rs1, rs2; output stored in result
      valid = True;
    end
    default: begin
      result = 0;
      valid = False;
    end
  endcase
  
  case(valueof(XLEN)) matches
    64: begin
       case(inp.instr) matches
           `ADD_UW: begin
              result = fn_add_uw(inp.rs1, inp.rs2);//Function call to and_uw with inputs rs1, rs2; output stored in result
              valid = True;
           end
           end
           `SH1ADD_UW: begin
               result = fn_sh1add_uw(inp.rs1, inp.rs2);//Function call to sh1add_uw with inputs rs1, rs2; output stored in result
               valid = True;   
           end
           `SH2ADD_UW: begin
               result = fn_sh2add_uw(inp.rs1, inp.rs2);//Function call to sh2add_uw with inputs rs1, rs2; output stored in result
               valid = True;   
           end
           `SH3ADD_UW: begin
               result = fn_sh3add_uw(inp.rs1, inp.rs2);//Function call to sh3add_uw with inputs rs1, rs2; output stored in result
               valid = True;   
           end
           `SLLI_UW: begin
               result = fn_slli_uw(inp.rs1, inp.instr);//Function call to slli_uw with inputs rs1, shamt; output stored in result
               valid = True;   
           end           
           end
       endcase
    end
  endcase       
  return BBoxOutput{valid: valid, data: result};
endfunction
