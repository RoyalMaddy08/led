//-------------------------------------------
//	FPGA Synthesizable Verilog Netlist
//	Description: FPGA Verilog Testbench for Formal Top-level netlist of Design: led
//	Author: Xifan TANG
//	Organization: University of Utah
//	Date: Thu Feb 26 18:34:26 2026
//-------------------------------------------
//----- Default net type -----
`default_nettype none

module led_top_formal_verification_random_tb;
// ----- Default clock port is added here since benchmark does not contain one -------
	reg [0:0] clk;

// ----- Shared inputs -------
	reg [0:0] sw;

// ----- FPGA fabric outputs -------
	wire [0:0] led_gfpga;

// ----- Benchmark outputs -------
	wire [0:0] led_bench;

// ----- Output vectors checking flags -------
	reg [0:0] led_flag;

// ----- Error counter -------
	integer nb_error= 0;

// ----- FPGA fabric instanciation -------
	led_top_formal_verification FPGA_DUT(
		.sw(sw),
		.led(led_gfpga)
	);
// ----- End FPGA Fabric Instanication -------

// ----- Reference Benchmark Instanication -------
	led REF_DUT(
		.sw(sw),
		.led(led_bench)
	);
// ----- End reference Benchmark Instanication -------

// ----- Clock 'clk' Initialization -------
	initial begin
		clk[0] <= 1'b0;
		while(1) begin
			#0.308470577
			clk[0] <= !clk[0];
		end
	end

// ----- Begin reset signal generation -----
// ----- End reset signal generation -----

// ----- Input Initialization -------
	initial begin
		sw <= 1'b0;

		led_flag[0] <= 1'b0;
	end

// ----- Input Stimulus -------
	always@(negedge clk[0]) begin
		sw <= $random;
	end

// ----- Begin checking output vectors -------
// ----- Skip the first falling edge of clock, it is for initialization -------
	reg [0:0] sim_start;

	always@(negedge clk[0]) begin
		if (1'b1 == sim_start[0]) begin
			sim_start[0] <= ~sim_start[0];
		end else 
begin
			if(!(led_gfpga === led_bench) && !(led_bench === 1'bx)) begin
				led_flag <= 1'b1;
			end else begin
				led_flag<= 1'b0;
			end
		end
	end

	always@(posedge led_flag) begin
		if(led_flag) begin
			nb_error = nb_error + 1;
			$display("Mismatch on led_gfpga at time = %t", $realtime);
		end
	end


// ----- Begin output waveform to VCD file-------
	initial begin
		$dumpfile("led_formal.vcd");
		$dumpvars(1, led_top_formal_verification_random_tb);
	end
// ----- END output waveform to VCD file -------

initial begin
	sim_start[0] <= 1'b1;
	$timeformat(-9, 2, "ns", 20);
	$display("Simulation start");
// ----- Can be changed by the user for his/her need -------
	#1.233882308
	if(nb_error == 0) begin
		$display("Simulation Succeed");
	end else begin
		$display("Simulation Failed with %d error(s)", nb_error);
	end
	$finish;
end

endmodule
// ----- END Verilog module for led_top_formal_verification_random_tb -----

