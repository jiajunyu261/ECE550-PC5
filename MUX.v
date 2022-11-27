module MUX (out, a, b, s);
 parameter width = 16;
 output [width-1:0] out;
 input [width-1:0] a, b;
 input s;
 
 wire [width-1:0] and_a, and_b;
 wire ns;
 
 not (ns, s);
 
 genvar i;
 generate for(i=0; i<width; i=i+1) begin:mux_loop
  and (and_a[i], a[i], ns);
  and (and_b[i], b[i], s);
  or (out[i], and_a[i], and_b[i]);
 end
 endgenerate

endmodule