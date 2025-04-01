class uart_monitor extends uvm_monitor;
	`uvm_component_utils(uart_monitor)
	uart_agt_cfg acfg;
	virtual uart_if.MON_MP vif;
	uart_xtn u_xtn;
	uvm_analysis_port #(uart_xtn)monitor_port;
	function new(string name="uart_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port",this);
	endfunction 

	function void build_phase(uvm_phase phase);
			
					super.build_phase(phase);
			if(!uvm_config_db #(uart_agt_cfg)::get(this,"","uart_agt_cfg",acfg))
				`uvm_fatal("Monitor","Cant get acfg")
		u_xtn = uart_xtn::type_id::create("u_xtn");

	endfunction

	function void connect_phase(uvm_phase phase);
		vif = acfg.vif;
	endfunction
		
	task run_phase(uvm_phase phase);
	
		forever
			begin
			
				collect_data();
			end
	endtask


	task collect_data();
	//	u_xtn = uart_xtn::type_id::create("u_xtn");
		@(vif.mon_cb);
		wait(vif.mon_cb.wb_ack_o)

		u_xtn.wb_we_i = vif.mon_cb.wb_we_i;
		u_xtn.wb_stb_i = vif.mon_cb.wb_stb_i;
		u_xtn.wb_adr_i = vif.mon_cb.wb_adr_i;
		u_xtn.wb_cyc_i = vif.mon_cb.wb_cyc_i;
		u_xtn.wb_data_i = vif.mon_cb.wb_dat_i;
		u_xtn.wb_sel_i = vif.mon_cb.wb_sel_i;

		//lcr register
		if(u_xtn.wb_adr_i == 3 && u_xtn.wb_we_i == 1)
			u_xtn.lcr = vif.mon_cb.wb_dat_i;

		//dlr (msb)
		if(u_xtn.lcr[7] == 1 && u_xtn.wb_adr_i == 1 && u_xtn.wb_we_i == 1)
			u_xtn.dlr_msb = vif.mon_cb.wb_dat_i;

		//dlr (lsb)
		if(u_xtn.lcr[7] == 1 && u_xtn.wb_adr_i == 0 && u_xtn.wb_we_i == 1)
			u_xtn.dlr_lsb = vif.mon_cb.wb_dat_i;

		//fcr register
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 2 && u_xtn.wb_we_i == 1)
			u_xtn.fcr = vif.mon_cb.wb_dat_i;

		//ier 
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 1 && u_xtn.wb_we_i== 1)
			u_xtn.ier = vif.mon_cb.wb_dat_i;

		//thr
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 0 && u_xtn.wb_we_i == 1)
			u_xtn.thr.push_back(vif.mon_cb.wb_dat_i);

		//rb
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 0 && u_xtn.wb_we_i== 0)
			u_xtn.rb.push_back(vif.mon_cb.wb_dat_o);


		//mcr
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 4 && u_xtn.wb_we_i == 1)
			u_xtn.mcr = vif.mon_cb.wb_dat_i;
 		//lcr
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 5 && u_xtn.wb_we_i == 0)
			u_xtn.lsr = vif.mon_cb.wb_dat_o;		

		//iir
		if(u_xtn.lcr[7] == 0 && u_xtn.wb_adr_i == 2 && u_xtn.wb_we_i== 0)
			begin
				wait(vif.mon_cb.int_o)
				@(vif.mon_cb);
				u_xtn.iir = vif.mon_cb.wb_dat_o;
			end
`uvm_info("mon", $sformatf("received data \n %s", u_xtn.sprint()), UVM_LOW)
	//		u_xtn.print();
		monitor_port.write(u_xtn); //sending to scoreboard
	endtask




endclass
