## ECE550 Checkpoint 5 - Full Processor

**Runya Liu (rl235)**

**Jiajun Yu (jy261)**

**Ruizi Han (rh328)**



The processor is made by a PC block and ALU. The PC block is added by 1 for each instruction. 
The processor is connected to the Regfile, Instruction memory, and Data memory. 
Specifically, the [21:17] bits  of the instruciton goes to RS port of Regfile. 
A mux of [26:22] or [16:12]bits of the instruction goes to RT port of Regfile, and the selector is whether the instruction is store word.
A mux of [26:22] of the instruciton or 30 goes to RD port of Regfile, and the selector is whether there's an overflow.
Then, the respective port of Regfile sends the relative data to ALU to compute the address of dmem, or the output of ALU is directly sent
to the write port of Regfile.
