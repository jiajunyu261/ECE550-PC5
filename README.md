## ECE550 Checkpoint 5 - Full Processor

**Jiajun Yu (jy261)**

**Runya Liu (rl235)**

**Ruizi Han (rh328)**


- The processor is made by a PC block and ALU. 
Normally, the PC block is added by 1 for each instruction. According to different instruction, PC will jump to different instruction.
- The processor is connected to the Regfile, Instruction memory, and Data memory. 
Specifically, the [21:17] bits  of the instruciton goes to readRegA port of Regfile. While the instruction is bex, it is set as 30.
- A mux of [26:22] or [16:12]bits of the instruction goes to readRegB port of Regfile, and the selector is whether the instruction is store word.
- A mux of [26:22] of the instruction or specific register (30 or 31) goes to writeReg port of Regfile, and the selector is whether there's an overflow or instruction jal.
- Then, the respective port of Regfile sends the relative data to ALU to compute the address of dmem, or the output of ALU is directly sent to the write port of Regfile.
