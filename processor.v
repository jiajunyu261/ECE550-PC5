/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem 
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem 

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile

	 );
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [31:0] address_dmem;//^
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 


    /* YOUR CODE STARTS HERE */
  
  
  reg [0:11]Q[0:31];//column:row
  
  initial 
  begin
  //              0123456789AB
  Q[5'b00000]=12'b100000000000;	// alu operations
  Q[5'b00101]=12'b101000000000;	// addi
  Q[5'b00111]=12'b011100000000;	// sw
  Q[5'b01000]=12'b101010000000;	// lw
  Q[5'b00001]=12'b000001000000;	// j
  Q[5'b00010]=12'b010000100000;	// bne
  //              0123456789AB
  Q[5'b00011]=12'b100000000001;	// jal
  Q[5'b00100]=12'b010000001000;	// jr
  Q[5'b00110]=12'b010000010000;	// blt
  Q[5'b10110]=12'b000000000100;	// bex
  Q[5'b10101]=12'b100000000010; 	// setx
  
  
  end
  
  wire [0:11]control;
  
  wire [31:0]w0;//se output
  wire [31:0]w1;//alu input2
  wire w2, w3, w4;//alu output ==/</overflow
  wire w13,w14; //actually overflow
  
  wire w16;//add 00000
  
  //wire [31:0]w5;//pc+1
  wire w6, w7, w8;
  
  wire [4:0]b30, b31, w15;//w15 alu input
  assign b30 = 5'b11110;
  assign b31 = 5'b11111;
  
  wire [31:0]w9;//data_writereg
  wire [31:0]w10,w11;//mux 123
  
  wire [26:0] target;
  

  // overflow
  of overflow(q_imem[31:27], q_imem[6:2], w13);
  and (w14, w13, w4);	// w14 overflow
  assign control = Q[q_imem[31:27]];
  
  //assign ctrl_readRegA = q_imem[21:17];//rs
  
  assign data = data_readRegB;
  
  assign wren = control[3];
  
  assign ctrl_writeEnable = control[0];
  
  assign target = q_imem[26:0];
  
  
  //assign ctrl_writeReg = q_imem[26:22];
  
  //reg
  MUX mux5_1(ctrl_readRegB, q_imem[16:12], q_imem[26:22], control[1]);
  defparam mux5_1.width = 5;

  // ctrl_writeReg 30/31
  wire [4:0] ctrl_30_31;
  MUX mux5_5(ctrl_30_31, b30, b31, control[11]);//ctrl_writeReg
  defparam mux5_5.width = 5;
  
  wire w17;
  or (w17, w14, control[10], control[11]);	// overflow or setx or jal
  MUX mux5_2(ctrl_writeReg, q_imem[26:22], ctrl_30_31, w17);//ctrl_writeReg
  defparam mux5_2.width = 5;
  
  or(w16, q_imem[31], q_imem[30], q_imem[29], q_imem[28], q_imem[27]);
  
  MUX mux5_3(w15, q_imem[6:2], 5'b00000, w16);
  defparam mux5_3.width = 5;
  
  // ctrl_readRegA
  MUX mux5_4(ctrl_readRegA, q_imem[21:17], 5'b11110, control[9]);
  defparam mux5_4.width = 5;
  
  //alu
  sign_extend se32(w0, q_imem[16:0]);
  
  MUX mux32_1(w1, data_readRegB, w0, control[2]);
  defparam mux32_1.width = 32;
  
  alu alu123(data_readRegA, w1, w15, q_imem[11:7], address_dmem, w2, w3, w4); 
  // w2 isNotEqual
  // w3 isLessThan
  // w4 overflow
  

  
  
  //dmem
  MUX mux32_2(w9, address_dmem, q_dmem, control[4]);
  defparam mux32_2.width = 32;
  
  MUX mux32_3(w10, 32'd1, 32'd3, q_imem[2]);
  defparam mux32_3.width = 32;
  
  MUX mux32_4(w11, w10, 32'd2, q_imem[27]);
  defparam mux32_4.width = 32;
  
  
  
  // pc
  wire [31:0] pc_1;		// pc+1
  wire [31:0] pc_1_n;	// pc+1+N
  alu alu456({20'b0,address_imem}, 32'b1, 5'b00000, 5'b00000, pc_1, w6, w7, w8);	// pc+1
  
  wire w_0, w_1, w_2;
  alu alu789(pc_1, w0, 5'b00000, 5'b00000, pc_1_n, w_0, w_1, w_2);	// pc+1+N
  
  // data_writeReg
  wire [31:0] af_of, af_setx;
  MUX mux32_5(af_of, w9, w11, w14);
  defparam mux32_5.width = 32;

  // after setx
  MUX mux32_9(af_setx, af_of, {5'b00000,target}, control[10]);
  defparam mux32_9.width = 32;
  // after jal
  MUX mux32_10(data_writeReg, af_setx, pc_1, control[11]);
  defparam mux32_10.width = 32;
  
  // control sel_A
  // w2 isNotEqual
  // w3 isLessThan
  wire sel_A;
  wire isBne, isBlt, isBiggerThan;
  wire [31:0] choose_A;
  
  and (isBiggerThan, w2, ~w3);
  and (isBne, control[6], w2);
  and (isBlt, control[7], isBiggerThan);
  or (sel_A, isBne, isBlt);
  
  
  
  MUX mux32_6(choose_A, pc_1, pc_1_n, sel_A);
  defparam mux32_6.width = 32;
  
  // control sel_B
  wire sel_B;
  wire [31:0] choose_B;
  wire isBex;
  wire or_rstatus;
  or_32 or_32_0(or_rstatus, data_readRegA);
  and (isBex, or_rstatus, control[9]);
  or (sel_B, isBex, control[5], control[11]);	// j or jal or (beq and or(r30)==1)
  MUX mux32_7(choose_B, choose_A, {5'b00000,target}, sel_B);
  defparam mux32_7.width = 32;
  
  // control 8 jr
  wire [31:0] pc_result;
  MUX mux32_8(pc_result, choose_B, data_readRegB, control[8]);
  defparam mux32_8.width = 32;  
  

  
  
  
  genvar i;
  generate for (i = 0; i < 12; i = i + 1) begin: loop0
  dffe_reg d1(address_imem[i], pc_result[i],clock, 1'b1, reset);
  end
  endgenerate

endmodule