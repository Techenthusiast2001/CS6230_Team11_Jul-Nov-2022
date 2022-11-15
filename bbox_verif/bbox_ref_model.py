#See LICENSE.iitm for license details
'''

Author   : Santhosh Pavan
Email id : santhosh@mindgrovetech.in
Details  : This file consists reference model which is used in verifying the bbox design (DUT).

--------------------------------------------------------------------------------------------------
'''
'''
TODO:
Task Description: Add logic for all instructions. One instruction is implemented as an example. 
                  Note - The value of instr (ANDN) is a temp value, it needed to be changed according to spec.

Note - if instr has single operand, take rs1 as an operand
'''

import math
#Reference model
def bbox_rm(instr, rs1, rs2, XLEN):
    XLEN_log = int(math.log2(XLEN))
    if instr == 0b01000000000000000111000000110011:
        res = rs1 & ~rs2
        valid = '1'
    ## logic for all other instr starts # ADD.UW
    elif (instr == 0b00001000000000000000000000111011 and XLEN ==64):
       res = (rs2 + rs1 % 2**32) % 2**XLEN#Unsigned word of rs1 is added to rs2
       valid = '1'
    elif instr == 0b01001000000000000001000000110011:#BCLR
       res = rs1 & ~(1 << (rs2 % 2**XLEN_log))
       valid = '1'
    elif ((bin(instr)[-31:-26] == '10010') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BCLRI
       shamt = int(bin(instr)[-26:-20], 2)
       res = rs1 & ~(1 << shamt)
       valid = '1'
    elif ((bin(instr)[-31:-25] == '100100') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==32):
       shamt = int(bin(instr)[-25:-20], 2)
       res = rs1 & ~(1 << shamt)
       valid = '1'   
    elif instr == 0b01001000000000000101000000110011: #BEXT
       res = (rs1 >> (rs2 % 2**XLEN_log)) & 1
       valid = '1'
    elif ((bin(instr)[-31:-26] == '10010') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BEXTI
       shamt = int(bin(instr)[-26:-20], 2)
       res = (rs1 >> shamt) & 1
       valid = '1'
    elif ((bin(instr)[-31:-25] == '100100') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0010011') and XLEN==32):
       shamt = int(bin(instr)[-25:-20], 2)
       res = (rs1 >> shamt) & 1
       valid = '1'
    ## logic for all other instr ends
    elif instr == 0b01101000000000000001000000110011:#BINV
       res = rs1 ^ (1 << (rs2 % 2**XLEN_log))
       valid = '1'
    elif ((bin(instr)[-31:-26] == '11010') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BINVI
       shamt = int(bin(instr)[-26:-20], 2)
       res = rs1 ^ (1 << (shamt))
       valid = '1'
    elif ((bin(instr)[-31:-25] == '110100') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==32):#BINVI
       shamt = int(bin(instr)[-25:-20], 2)
       res = rs1 ^ (1 << (shamt))
       valid = '1'
    elif instr == 0b00101000000000000001000000110011:
       res = rs1 | (1 << (rs2 % 2**XLEN_log));
       valid = '1'
    elif ((bin(instr)[-30:-26] == '1010') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BSETI
       shamt = int(bin(instr)[-26:-20], 2)
       res = rs1 | (1 << (shamt))
       valid = '1'
    elif ((bin(instr)[-30:-25] == '10100') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==32):#BSETI
       shamt = int(bin(instr)[-25:-20], 2)
       res = rs1 | (1 << (shamt))
       valid = '1'

    elif instr == 0b00001010000000000001000000110011:#clmul
       res = 0; i = 0
       while (rs1>>i) > 0:
            if rs1 & (1<<i):#In each iteration, if rs2 rightshifted(by i) value is 1, then the leftshifted(by i) value of rs1 is added to the output.
                res ^= rs2<<i
            i += 1
       res = res % 2**XLEN
       valid = '1'
    elif instr == 0b00001010000000000011000000110011:#clmuh
       res = 0; i = 0
       while (rs1>>i) > 0:
            if rs1 & (1<<i):#In each iteration, if rs2 rightshifted(by i) value is 1, then the rightshifted(by xlen-i) value of rs1 is added to the output.
                res ^= rs2<<i
            i += 1
       res = res // 2**XLEN
       valid = '1'
    elif instr == 0b00001010000000000010000000110011:#clmur
       res = 0; i = 0
       while (rs1>>i) > 0:
            if rs1 & (1<<i):#In each iteration, if rs2 rightshifted(by i) value is 1, then the rightshifted(by xlen-1-i) value of rs1 is added to the output.
                res ^= rs2<<i
            i += 1
       res = (res // 2**(XLEN-1)) % 2**XLEN
       valid = '1'
    elif instr == 0b00100000000000000010000000110011:#SH1ADD
       res = (rs2 + (rs1 << 1)) % 2**XLEN#rs1 is shifted left by 1 position and then added with rs2
       valid = '1'
    elif instr == 0b00100000000000000010000000111011:#SH1ADD_UW
       res = (rs2 + ((rs1 % 2**32) << 1)) % 2**XLEN# unsigned word of rs1 left shifted by 1 position and then added with rs2
       valid = '1'
    elif instr == 0b00100000000000000100000000110011:#SH2ADD
       res = (rs2 + (rs1 << 2)) % 2**XLEN#rs1 is shifted left by 2 position and then added with rs2
       valid = '1'
    elif instr == 0b00100000000000000100000000111011:#SH2ADD_UW
       res = (rs2 + ((rs1 % 2**32) << 2)) % 2**XLEN# unsigned word of rs1 left shifted by 2 position and then added with rs2
       valid = '1'
    elif instr == 0b00100000000000000110000000110011:#SH3ADD
       res = (rs2 + (rs1 << 3)) % 2**XLEN#rs1 is shifted left by 3 position and then added with rs2
       valid = '1'
    elif instr == 0b00100000000000000110000000111011:#SH3ADD_UW
       res = (rs2 + ((rs1 % 2**32) << 3)) % 2**XLEN# unsigned word of rs1 left shifted by 3 position and then added with rs2
       valid = '1'
    elif ((bin(instr)[-31:-26] == '0b10') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0011011') and XLEN==64):#SLLI_UW
       shamt = int(bin(instr)[-26:-20], 2)#shift amount extraction
       res = ((rs1 % 2**32) << shamt) % 2**XLEN#rs1 left shifted by the shift amount
       valid = '1'
        
    ## logic for all other instr ends
    else:
        res = 0
        valid = '0'

    if XLEN == 32:
        result = '{:032b}'.format(res)
    elif XLEN == 64:
        result = '{:064b}'.format(res)

    return valid+result

