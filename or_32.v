module or_32 (out, a);
	
	output out;
	input [31:0] a;

	wire [29:0] m;
	
	or (m[0], a[0], a[1]);
	
	genvar i;
	generate for(i=0; i<29; i=i+1) begin:or_loop
		or (m[i+1], m[i], a[i+2]);
	end
	endgenerate
	
	or (out, m[29], a[31]);
	

endmodule