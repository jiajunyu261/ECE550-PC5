module sign_extend (out, imme);
 output [31:0] out;
 input [16:0] imme;
 
 genvar i;
 generate for(i=0; i<17; i=i+1) begin:copy_loop
  and (out[i], imme[i], 1'b1);
 end
 endgenerate

 generate for(i=17; i<32; i=i+1) begin:extend_loop
  and (out[i], imme[16], 1'b1);
 end
 endgenerate

endmodule