class uart_test extends uvm_test;
	`uvm_component_utils(uart_test)

	uart_env envh;
	int no_of_agents=2;
	int has_scoreboard =1;


	uvm_active_passive_enum is_active = UVM_ACTIVE;


//	int has_v_seqr = 1;
	uart_config cfg;
	//now adding agent configuation
	uart_agt_cfg acfg[];	

	function new(string name="uart_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		
		super.build_phase(phase);

		acfg = new[no_of_agents];
		cfg=uart_config::type_id::create("cfg");
		foreach(acfg[i])
			begin
				acfg[i] = uart_agt_cfg::type_id::create($sformatf("acfg[%0d]",i));
				if(!uvm_config_db #(virtual uart_if)::get(this,"",$sformatf("vif_%0d",i),acfg[i].vif))
					`uvm_fatal("VF CONFIG","Cannot get interface vif")
				acfg[i].is_active= this.is_active;
			end
		cfg.no_of_agents = no_of_agents;
		cfg.has_scoreboard = has_scoreboard;
		cfg.acfg           = new[no_of_agents];
		for(int i=0;i<no_of_agents;i++)
			cfg.acfg[i] = acfg[i];
//		cfg.has_v_seqr = has_seqr;


	//	SETING UART CONFIG 

		uvm_config_db #(uart_config)::set(this,"*","uart_config",cfg);

	//	cfg.is_active=UVM_ACTIVE;

		
		envh=uart_env::type_id::create("envh",this);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology;
	endfunction

endclass


class full_dplx_test extends uart_test;
	`uvm_component_utils(full_dplx_test)
	
	full_duplex_seqs1 f1;
	full_duplex_seqs2 f2;

	function new(string name = "full_dplx_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
				
			f1=full_duplex_seqs1::type_id::create("f1");
			f2=full_duplex_seqs2::type_id::create("f2");

				fork

					f1.start(envh.agnth[0].seqrh);
					f2.start(envh.agnth[1].seqrh);
				join
				#100;

		phase.drop_objection(this);
	endtask
endclass

//half duplex test
class half_dplx_test extends uart_test;
	`uvm_component_utils(half_dplx_test)

	half_duplex_seqs1 h1;
	half_duplex_seqs2 h2;

	function new(string name="half_dplx_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		h1 = half_duplex_seqs1::type_id::create("h1");
		h2 = half_duplex_seqs2::type_id::create("h2");
		fork
			h1.start(envh.agnth[0].seqrh);
			h2.start(envh.agnth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass





//loop back test
class loop_back_test extends uart_test;
	`uvm_component_utils(loop_back_test)

	loop_back1 l1;
	loop_back2 l2;

	function new(string name="loop_back_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		l1 = loop_back1::type_id::create("l1");
		l2 = loop_back2::type_id::create("l2");
		fork
			l1.start(envh.agnth[0].seqrh);
			l2.start(envh.agnth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass






//Parity error test
class parity_error_test extends uart_test;
	`uvm_component_utils(parity_error_test)

	parity_seq1 p1;
	parity_seq2 p2;

	function new(string name="parity_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		p1 = parity_seq1::type_id::create("p1");
		p2 = parity_seq2::type_id::create("p2");
		fork
			p1.start(envh.agnth[0].seqrh);
			p2.start(envh.agnth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass

//framing error test
class framing_error_test extends uart_test;
	`uvm_component_utils(framing_error_test)

	framing1 fr1;
	framing2 fr2;

	function new(string name="framing_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		fr1 = framing1::type_id::create("fr1");
		fr2 = framing2::type_id::create("fr2");
		fork
			fr1.start(envh.agnth[0].seqrh);
			fr2.start(envh.agnth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass

//overrun error test
class overrun_error_test extends uart_test;
	`uvm_component_utils(overrun_error_test)

	overrun1 or1;
	overrun2 or2;

	function new(string name="overrun_error_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		or1 = overrun1::type_id::create("or1");
		or2 = overrun2::type_id::create("or2");
		fork
			or1.start(envh.agnth[0].seqrh);
			or2.start(envh.agnth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass



//break interrupt error test
class break_int_test extends uart_test;
	`uvm_component_utils(break_int_test)

	break_int_seq1  br1;
	break_int_seq2  br2;

	function new(string name="break_int_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		br1 = break_int_seq1::type_id::create("br1");
		br2 = break_int_seq2::type_id::create("br2");
		fork
			br1.start(envh.agnth[0].seqrh);
			br2.start(envh.agnth[1].seqrh);
		join
		#100;
		phase.drop_objection(this);
	endtask
endclass



//timeout test
class timeout_test extends uart_test;
	`uvm_component_utils(timeout_test)

	 timeout_seq1  t1;
	  timeout_seq2  t2;

	function new(string name="timeout_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		t1 = timeout_seq1::type_id::create("t1");
		t2 = timeout_seq2::type_id::create("t2");
		fork
			t1.start(envh.agnth[0].seqrh);
			t2.start(envh.agnth[1].seqrh);
		join
		#10000;
		phase.drop_objection(this);
	endtask
endclass



//thrempty test
class thrempty_test extends uart_test;
	`uvm_component_utils(thrempty_test)

	  thr_empty_seqs1  te1;
	  thr_empty_seqs2  te2;

	function new(string name="thrempty_test",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		te1 = thr_empty_seqs1::type_id::create("te1");
		te2 = thr_empty_seqs2::type_id::create("te2");
		fork
			te1.start(envh.agnth[0].seqrh);
			te2.start(envh.agnth[1].seqrh);
		join
		#10000;
		phase.drop_objection(this);
	endtask
endclass










