class uart_env extends uvm_env;
	`uvm_component_utils(uart_env)
	uart_config cfg;
	uart_agt_cfg acfg[];
	int no_of_agents;
	uart_agent agnth[];
	uart_sb sb;
	function new(string name ="uart_env",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
			super.build_phase(phase);
	//Getting uart config

		if(!uvm_config_db #(uart_config)::get(this,"","uart_config",cfg))
			`uvm_fatal("CONFIG","Not getting config")

	
	//	if(!uvm_config_db #(int)::get(this,"","no_of_agents",no_of_agents))
	//		`uvm_fatal("FATAL","no of agents is not set")
		
		agnth=new[cfg.no_of_agents];
		foreach(agnth[i])
		    begin
			agnth[i]=uart_agent::type_id::create($sformatf("agnth[%0d]",i),this);
		    	uvm_config_db #(uart_agt_cfg)::set(this,$sformatf("agnth[%0d]*",i),"uart_agt_cfg",cfg.acfg[i]);
		    end
		
		if(cfg.has_scoreboard) 	
			begin
		        sb = uart_sb::type_id::create("sb",this);
			end
			
	endfunction
	function void connect_phase(uvm_phase phase);

		if(cfg.has_scoreboard) 
		begin
			foreach(agnth[i]) 
			begin
				
				agnth[i].monh.monitor_port.connect(sb.fifo_h[i].analysis_export);
			end
		end

	endfunction

/*	task run_phase(uvm_phase phase);
		uvm_top.print_topology;
	endtask */
endclass
