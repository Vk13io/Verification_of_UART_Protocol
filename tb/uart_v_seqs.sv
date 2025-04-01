


class uart_v_seqs extends uvm_sequence #(uvm_sequence_item);


	`uvm_object_utils(uart_v_seqs)
	uart_v_seqr v_seqr;
	uart_config uart_cfg;
	uart_seqr seqr[];

	function new(string name = "uart_v_seqs")

		super.new(name);

	
	endfunction
	
	task body;

		if(!uvm_config_db#(uart_config)::get(null,"UART_V_SEQS","uart_config",uart_cfg))
			`uvm_fatal("VIRTUAL SEQS","CANNOT GET UART_CONFIG")
		assert($cast(uart_v_seqs,m_sequencer))
			

			else
				begin
					`uvm_error("$cast","error in $cast of uart_v_seqs")
				end


		seqr = new[uart_cfg.no_of_agents];
		
		foreach(seqr[i])
			seqr[i] = v_seqr.seqr[i];

	endtask




endclass
