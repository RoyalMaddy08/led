//-------------------------------------------
//	FPGA Synthesizable Verilog Netlist
//	Description: Netlist Summary
//	Author: Xifan TANG
//	Organization: University of Utah
//	Date: Thu Feb 26 18:34:26 2026
//-------------------------------------------
//----- Time scale -----
`timescale 1ns / 1ps

// ------ Include fabric top-level netlists -----
`include "./SRC/fabric_netlists.v"

`include "led_output_verilog.v"

`include "./SRC/led_top_formal_verification.v"
`include "./SRC/led_formal_random_top_tb.v"
