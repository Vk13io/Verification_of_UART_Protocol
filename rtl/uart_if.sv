interface uart_if (input bit wb_clk_i);
	bit wb_rst_i;
	bit [2:0] wb_adr_i;
	bit [7:0] wb_dat_i;
	bit [7:0] wb_dat_o;
	bit [3:0] wb_sel_i;
	bit wb_stb_i;
	bit wb_cyc_i;
	bit wb_we_i;
	bit wb_ack_o;
	bit int_o;

	clocking drv_cb @(posedge wb_clk_i);
		default input #1 output #1;
		output wb_rst_i;
		output wb_adr_i;
		output wb_dat_i;
		output wb_sel_i;
		output wb_stb_i;
		output wb_cyc_i;
		output wb_we_i;
		input  wb_dat_o;
		input wb_ack_o;
		input int_o;
	endclocking 

	clocking mon_cb @(posedge wb_clk_i);
		default input #1 output #1;
		input wb_rst_i;
		input wb_adr_i;
		input wb_dat_i;
		input wb_sel_i;
		input wb_stb_i;
		input wb_cyc_i;
		input wb_we_i;
		input  wb_dat_o;
		input wb_ack_o;
		input int_o;
	endclocking 

	modport DRV_MP (clocking drv_cb);
	modport MON_MP (clocking mon_cb);
endinterface