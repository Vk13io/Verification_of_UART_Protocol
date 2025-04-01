class uart_agent extends uvm_agent;
 	`uvm_component_utils(uart_agent)
	uart_agt_cfg acfg;
	uart_drv drvh;
	uart_monitor monh;
	uart_seqr seqrh;
	function new(string name="uart_agent",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(uart_agt_cfg)::get(this,"","uart_agt_cfg",acfg))
			`uvm_fatal("AGENT","cant get the config acfg")
		
		monh=uart_monitor::type_id::create("monh",this);
		if(acfg.is_active==UVM_ACTIVE)
			begin
				drvh=uart_drv::type_id::create("drvh",this);
				seqrh=uart_seqr::type_id::create("seqrh",this);
			end
		
	endfunction

	function void connect_phase(uvm_phase phase);
		if(acfg.is_active==UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(seqrh.seq_item_export);
			end
	endfunction

endclass
