class uart_drv extends uvm_driver#(uart_xtn);
	`uvm_component_utils(uart_drv)

		uart_agt_cfg acfg;
		virtual uart_if.DRV_MP vif;

	function new(string name="uart_drv",uvm_component parent);
		super.new(name,parent);
	endfunction


function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(uart_agt_cfg)::get(this,"","uart_agt_cfg",acfg))
				`uvm_fatal("DRIVER","cant get acfg")
	
						

endfunction

	function void connect_phase(uvm_phase phase);
		vif = acfg.vif;
	endfunction

	task run_phase(uvm_phase phase);
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 0; 
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 1;	
		vif.drv_cb.wb_stb_i <= 0;
		vif.drv_cb.wb_cyc_i <= 0;
		@(vif.drv_cb);
		vif.drv_cb.wb_rst_i <= 0;
		
		forever
			begin
				seq_item_port.get_next_item(req);
				send_to_dut(req);
				seq_item_port.item_done();
			end
	endtask

	task send_to_dut(uart_xtn u_xtn);
		`uvm_info("S_DRV",$sformatf("printing from driver \n %s", u_xtn.sprint()),UVM_LOW)
		@(vif.drv_cb);
		vif.drv_cb.wb_sel_i <= 4'b0001;
		vif.drv_cb.wb_stb_i <= 1;
		vif.drv_cb.wb_cyc_i <= 1;
		vif.drv_cb.wb_we_i <= u_xtn.wb_we_i;
		vif.drv_cb.wb_adr_i <= u_xtn.wb_adr_i;
		vif.drv_cb.wb_dat_i <= u_xtn.wb_data_i;
		wait(vif.drv_cb.wb_ack_o)
		vif.drv_cb.wb_stb_i <= 0;
		vif.drv_cb.wb_cyc_i <= 0;
		
		if(u_xtn.wb_adr_i == 2 && u_xtn.wb_we_i == 0)
			begin
				wait(vif.drv_cb.int_o);
				repeat(2)
					@(vif.drv_cb);
				u_xtn.iir = vif.drv_cb.wb_dat_o;
				seq_item_port.put_response(u_xtn);
			end
	endtask
endclass
