class uart_config extends uvm_object;
	`uvm_object_utils(uart_config)
	
	uart_agt_cfg acfg[];
	virtual uart_if vif;
	int no_of_agents;
	int has_v_seqr;
	int has_scoreboard;

	function new(string name="uart_config");
		super.new(name);
	endfunction
endclass
