`include "timescale.v"

module top;

	import uart_pkg::*;
	import uvm_pkg::*;
	
	`include "uvm_macros.svh"


	bit clk1;
	bit clk2;

// Intermediary wires
	wire a,b;


always #10 clk1 = ~clk1;
always #20 clk2 = ~clk2;


uart_if in1(clk1);
uart_if in2(clk2);

uart_top DUV1 ( .wb_clk_i(clk1),
	      .stx_pad_o(a),
	      .srx_pad_i(b),
	      .wb_rst_i(in1.wb_rst_i),
	      .wb_adr_i(in1.wb_adr_i),
	      .wb_dat_i(in1.wb_dat_i),
	      .wb_dat_o(in1.wb_dat_o),
	      .wb_sel_i(in1.wb_sel_i),
	      .wb_stb_i(in1.wb_stb_i),
	      .wb_cyc_i(in1.wb_cyc_i),
              .wb_we_i(in1.wb_we_i),
	      .wb_ack_o(in1.wb_ack_o),
	      .int_o(in1.int_o));

uart_top DUV2  (.wb_clk_i(clk2),
			.stx_pad_o(b),
			.srx_pad_i(a),
			.wb_rst_i(in2.wb_rst_i),
			.wb_adr_i(in2.wb_adr_i),
			.wb_dat_i(in2.wb_dat_i),
			.wb_dat_o(in2.wb_dat_o),
			.wb_sel_i(in2.wb_sel_i),
			.wb_stb_i(in2.wb_stb_i),
			.wb_cyc_i(in2.wb_cyc_i),
			.wb_we_i(in2.wb_we_i),
			.wb_ack_o(in2.wb_ack_o),
			.int_o(in2.int_o));




	initial
		begin
			

			uvm_config_db#(virtual uart_if)::set(null,"*","vif_0",in1);
			uvm_config_db#(virtual uart_if)::set(null,"*","vif_1",in2);
		
			run_test();
		end
endmodule 
