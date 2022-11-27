module of(a, b, c);
	
	input [4:0]a,b;
	output c;
	
wire w0,w1,w2;

and(w0, ~a[0], ~a[1], ~a[2], ~a[3], ~a[4], ~b[0], ~b[1], ~b[2], ~b[3], ~b[4]);
and(w1, a[0], ~a[1], a[2], ~a[3], ~a[4], ~b[0], ~b[1], ~b[2], ~b[3], ~b[4]);
and(w2, ~a[0], ~a[1], ~a[2], ~a[3], ~a[4], b[0], ~b[1], ~b[2], ~b[3], ~b[4]);

or(c, w0, w1, w2);

endmodule
