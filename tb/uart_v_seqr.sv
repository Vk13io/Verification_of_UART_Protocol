





class uart_v_seqr extends uvm_sequencer #(uvm_sequence_item);



	`uvm_component_utils(uart_v_seqr)
	
	uart_seqr seqr[];

	uart_config cfg;

	function new(string name = "uart_v_seqr", uvm_component parent);
		super.new(name,parent);

	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(uart_config)::get(this,"","uart_config",cfg))
			`uvm_fatal("CONFIG IN VIRTUAL SEQR","Cannot get cfg")
		super.build_phase(phase);
		seqr = new[cfg.no_of_agents];
	endfunction










endclass





























