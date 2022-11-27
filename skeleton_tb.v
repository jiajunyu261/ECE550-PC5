// ---------- SAMPLE TEST BENCH ----------
`timescale 1 ns / 100 ps
module skeleton_tb();
    // inputs to the DUT are reg type
    reg            clock, reset;

    // outputs from the DUT are wire type
    wire imem_clock, dmem_clock, processor_clock, regfile_clock;



    // instantiate the DUT
	 skeleton skl(clock, reset, imem_clock, dmem_clock, processor_clock, regfile_clock);
    // setting the initial values of all the reg
    initial
    begin
        $display($time, " << Starting the Simulation >>");
        clock = 1'b0;    // at time 0

        reset = 1'b1;    // assert reset
		#100 reset = 0;
        #4000 $stop;
    end



    // Clock generator
    always
         #10     clock = ~clock;    // toggle
			

   
endmodule
