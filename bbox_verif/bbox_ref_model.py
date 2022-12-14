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
    if instr == 0b01000000000000000111000000110011:#ANDN
        res = rs1 & ~rs2#anding with negated 2nd operand
        valid = '1'
    ## logic for all other instr starts 
    elif (instr == 0b00001000000000000000000000111011 and XLEN ==64):# ADD.UW
       res = (rs2 + rs1 % 2**32) % 2**XLEN#Unsigned word of rs1 is added to rs2
       valid = '1'
    elif instr == 0b01001000000000000001000000110011:#BCLR
       res = rs1 & ~(1 << (rs2 % 2**XLEN_log))#clearing bit of rs1 using log(XLEN) bits of rs2
       valid = '1'
    ##Uniquely identifying instructions by comparing the fixed part for all immediate instructions that follow
    elif ((bin(instr)[-31:-26] == '10010') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BCLRI_64
       shamt = int(bin(instr)[-26:-20], 2)#Extracting shamt
       res = rs1 & ~(1 << shamt)#Clearing bit at shamt loc in rs1
       valid = '1'
    elif ((bin(instr)[-31:-25] == '100100') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==32):#BCLRI_32
       shamt = int(bin(instr)[-25:-20], 2)#Extracting shamt from instr
       res = rs1 & ~(1 << shamt) #Clearing bit at shamt loc in rs1
       valid = '1'  
    elif instr == 0b01001000000000000101000000110011: #BEXT
       res = (rs1 >> (rs2 % 2**XLEN_log)) & 1#Extracting bit of rs1 using log(xlen) bits of rs2
       valid = '1'
    elif ((bin(instr)[-31:-26] == '10010') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BEXTI_64 -
       shamt = int(bin(instr)[-26:-20], 2)#Extracting shamt from instr
       res = (rs1 >> shamt) & 1#Extracting bit of rs1 at shamt
       valid = '1'
    elif ((bin(instr)[-31:-25] == '100100') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0010011') and XLEN==32):#BEXTI_32
       shamt = int(bin(instr)[-25:-20], 2)#Extracting shamt from instr
       res = (rs1 >> shamt) & 1#Extracting bit of rs1 at shamt
       valid = '1'
    elif instr == 0b01101000000000000001000000110011:#BINV
       res = rs1 ^ (1 << (rs2 % 2**XLEN_log))#Inverting bit of rs1 using log(xlen) bits of rs2
       valid = '1'
    elif ((bin(instr)[-31:-26] == '11010') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BINVI_64
       shamt = int(bin(instr)[-26:-20], 2)#Extracting shamt from instr
       res = rs1 ^ (1 << (shamt))#inverting bit of rs1 at shamt
       valid = '1'
    elif ((bin(instr)[-31:-25] == '110100') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==32):#BINVI_32
       shamt = int(bin(instr)[-25:-20], 2)#Extracting shamt from instr
       res = rs1 ^ (1 << (shamt))#inverting bit of rs1 at shamt
       valid = '1'
    elif instr == 0b00101000000000000001000000110011:#BSET
       res = rs1 | (1 << (rs2 % 2**XLEN_log));#setting bit of rs1 using log(xlen) bits of rs2
       valid = '1'
    elif ((bin(instr)[-30:-26] == '1010') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==64):#BSETI_64
       shamt = int(bin(instr)[-26:-20], 2)#extracting shamt from instr
       res = rs1 | (1 << (shamt))#setting bit of rs1 at shamt
       valid = '1'
    elif ((bin(instr)[-30:-25] == '10100') and (bin(instr)[-15:-12] == '001') and (bin(instr)[-7:] == '0010011') and XLEN==32):#BSETI_32
       shamt = int(bin(instr)[-25:-20], 2)#extracting shamt from instr
       res = rs1 | (1 << (shamt))#setting bit of rs1 at shamt
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
    elif instr == 0b01100000000000000001000000010011:#clz
       res = 0
       for k in range(XLEN-1, -1, -1):
           if(rs1 >= 2**k):#comparing with 2 power k to find if value at kth index=1
                res = XLEN-k-1 #no of zeros
                break #stop count after encountering first 1
       valid = '1'
    elif instr == 0b01100000000000000001000000011011:#clzw
        res = 0
        for k in range(31, -1, -1):#same as above only on lsw
          if(rs1 % 2**32 >= 2**k):
             res = 31-k
             break
        valid = '1'
    elif instr == 0b01100000001000000001000000010011:#cpop
      rs1 = str(bin(rs1))#converts into string
      res = 0
      for i in rs1:
         if i == "1"#checks if a bit is 1/not
            res+=1#if it is '1' add 1 to count no. of 1's in rs1
      valid = '1'
    elif instr == 0b01100000001000000001000000011011:#cpopw
      rs1 = str(bin(rs1 % 2**32))#same as above only on lsw
      res = 0
      for i in rs1:
         if i == "1":
            res+=1
      valid = '1'
    elif instr == 0b01100000000100000001000000010011:#ctz
        res = 0
        for k in range(XLEN-1, -1, -1):#count trailing zeros
          if(rs1 % 2**k == 0):#checks for highest 2 power k divisor
             res = k 
             break
        valid = '1'
    elif instr == 0b01100000000100000001000000011011:#ctzw
        res = 0
        for k in range(31, -1, -1):#same as above on lsw
          if(rs1 % 2**k == 0):
             res = k 
             break
        valid = '1'
    elif instr == 0b00001010000000000110000000110011:#MAX
        sign1 = 0; sign2 = 0; res = rs1
        if(rs1 > 2**(XLEN-1)):
           sign1 = 1
        if(rs2 > 2**(XLEN-1)):
           sign2 = 1    
        if(sign1==sign2):#checking if signs are equal
            res = max(rs1, rs2)#if equal result same as normal max
        else:
            res = min(rs1, rs2)#else take +ve no
        valid = '1'
    elif instr == 0b00001010000000000111000000110011:#maxu
        res = max(rs1, rs2);#normal max from unsigned comparison
        valid = '1'
    elif instr == 0b00001010000000000100000000110011:#min
        sign1 = 0; sign2 = 0; res = 0
        if(rs1 > 2** (XLEN-1)):
           sign1 = 1
        if(rs2 > 2** (XLEN-1)):
           sign2 = 1
        if(sign1==sign2):#checking if signs are equal
            res = min(rs1, rs2)#normal min from unsigned comparison
        else:
            res = max(rs1, rs2)#else take -ve no
        valid = '1'
    elif instr == 0b00001010000000000101000000110011:#MINU
        res = min(rs1, rs2);#normal min from unsigned comparison
        valid = '1'     
    elif instr == 0b00101000011100000101000000010011:#ORC_B
        res = 0
        for i in range(0, XLEN, 8):#goes byte wise
          if (rs1 // 2**i) % 2**8 > 0:#checks if the byte has atleast one 1 i.e value >0
              res = res + 2**i *255#if value >0 then replace byte with all 1's i.e 255
        valid = '1'
    elif instr == 0b01000000000000000110000000110011:#orn
        res = (rs1 | ~rs2) % 2**XLEN#or with negated rs2
        valid = '1'
    elif((instr == 0b01101011100000000101000000010011) and XLEN==64):#REV8_64
        out =''
        rs1_new = '{:064b}'.format(rs1)#making it fixed 64 bit
        for i in range(0, XLEN, 8):#going byte wise
           if(i==0):
               out = out + rs1_new[-8:]
           else:
               out = out + rs1_new[-(i+8):-i]#concatenating in reverse order
        res = int('0b'+out, 2)#converting strint into integer
        valid = '1'
    elif ((instr == 0b01101001100000000101000000010011) and XLEN ==32):#REV8_32
        out =''
        rs1_new = '{:032b}'.format(rs1)#making it fixed 32 bit
        for i in range(0, XLEN, 8):#going byte wise
           if(i==0):
               out = out + rs1_new[-8:]
           else:
               out = out + rs1_new[-(i+8):-i]#concatenating in reverse order
        res = int('0b'+out, 2)#converting strint into integer
        valid = '1'   
    elif instr == 0b01100000000000000001000000110011:#ROL
        shamt = rs2 % 2**XLEN_log#log(xlen) bits of rs2
        res1 = (rs1 // 2**(XLEN-shamt)) #upper shamt bits into lsb
        res2 = (rs1 % 2**(XLEN-shamt)) * 2**shamt#lower xlen-shamt bits shifted left
        res = res1 + res2#total
        valid = '1'
    elif (instr == 0b01100000000000000001000000111011 and XLEN==64):#ROLW
        rs1 = rs1 % 2**32#lsw of rs1
        shamt = rs2 % 2**5#log(xlen) bits of rs2
        res1 = (rs1 // 2**(32-shamt)) #upper shamt bits into lsb
        res2 = (rs1 % 2**(32-shamt)) * 2**shamt#lower 32-shamt bits shifted left
        res = res1 + res2 #total
        if(res >= 2**31):#sign extension
            res += (2**XLEN-2**32)
        valid = '1'
    elif instr == 0b01100000000000000101000000110011: #ROR
        shamt = rs2 % 2**XLEN_log
        res1 = (rs1 % 2**(shamt))* 2**(XLEN-shamt)#lower part shifted up
        res2 = rs1 // 2**shamt#upper part shifted right
        res = res1 + res2#total
        valid = '1'
    elif ((bin(instr)[-31:-26] == '11000') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0010011') and XLEN==64):#RORI-64
        shamt = int(bin(instr)[-26:-20], 2)#extracting shamt from instr
        res1 = (rs1 % 2**(shamt))* 2**(XLEN-shamt)#lower part shifted up
        res2 = rs1 // 2**shamt#upper part shifted right
        res = res1 + res2#total
        valid = '1'
    elif ((bin(instr)[-31:-25] == '110000') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0010011') and XLEN==32):#RORI-32
        shamt = int(bin(instr)[-25:-20], 2)#extracting shamt from instr
        res1 = (rs1 % 2**(shamt))* 2**(XLEN-shamt)#lower part shifted up
        res2 = rs1 // 2**shamt#upper part shifted right
        res = res1 + res2#total
        valid = '1'
    elif ((bin(instr)[-31:-25] == '110000') and (bin(instr)[-15:-12] == '101') and (bin(instr)[-7:] == '0011011') and XLEN==64):#RORIW 
        shamt = int(bin(instr)[-25:-20], 2)
        rs1 = rs1 % 2**32#lsw of rs1
        res1 = (rs1 % 2**(shamt))* 2**(32-shamt)#lower shamt bits shifted up
        res2 = rs1 // 2**shamt#upper bits shifted right by shamt
        res = res1 + res2#final result
        if(res >= 2**31):#sign extending it
          res += (2**XLEN - 2**32)
        valid = '1'
    elif (instr == 0b01100000000000000101000000111011 and XLEN==64): #RORW
        rs1 = rs1 % 2**32 #lsw of rs1
        shamt = rs2 % 2**5 #getting log(xlen) bits of rs2
        res1 = (rs1 % 2**(shamt))* 2**(32-shamt)#lower bits shifted up
        res2 = rs1 // 2**shamt #upper bits shifted right by shamt
        res = (res1 + res2)#final result
        if(res >= 2**31):#signextending it
           res+= (2**XLEN - 2**32)
        valid = '1'
    elif instr == 0b01100000010000000001000000010011:#SEXT_B
       res = rs1 % 2**8#Getting last 8 bits
       if (res >= 2**7):#Identifying MSB of it
          res+=(2**XLEN -1 - 255)#Sign extending it
       valid = '1'
    elif instr == 0b01100000010100000001000000010011:#SEXT_H
       res = rs1 % 2**16#Getting last 16 bits
       if(res >= 2**15):#Identifying MSB if it
          res+=(2**XLEN - 2**16)#Sign extending it
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
    elif instr == 0b01000000000000000100000000110011:#XNOR
       res = ~(rs1 ^ rs2) % 2**XLEN #not of xor
       valid = '1'
    elif (instr == 0b00001000000000000100000000111011 and XLEN==64):#ZEXT_H
       res = rs1 % 2**16#Getting last 16 bits
       valid = '1'
    elif (instr == 0b00001000000000000100000000110011 and XLEN==32):#ZEXT_H
       res = rs1 % 2**16 #Getting last 16 bits
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

