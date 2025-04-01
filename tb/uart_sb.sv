

class uart_sb extends uvm_scoreboard;
	`uvm_component_utils(uart_sb)
	
	uvm_tlm_analysis_fifo #(uart_xtn) fifo_h[];
	uart_config cfg;
	uart_xtn uart1,uart2;
	uart_xtn cov_data;
	int thrsize1,thrsize2;
	int rbsize1,rbsize2;
	int no_of_agents;	
covergroup uart_signals_cov;
	option.per_instance = 1;
	
	DATA: coverpoint cov_data.wb_data_i[7:0]{bins data_i = {[0:255]}; }
	ADDRESS: coverpoint cov_data.wb_adr_i[2:0]{bins addr_sign ={[0:7]};}
	WR_ENB: coverpoint cov_data.wb_we_i{bins rd = {0};
					    bins wr = {1};}

endgroup
covergroup uart_lcr_cov;

	option.per_instance = 1;

	CHAR_SIZE: coverpoint cov_data.lcr[1:0]{bins five = {2'b00};
						bins six  = {2'b01};
						bins seven = {2'b10};
						bins eight = {2'b11}; }

	STOP_BIT: coverpoint cov_data.lcr[2]{bins one  = {1'b0};
					     bins more = {1'b1}; }

	PARITY:   coverpoint cov_data.lcr[3]{bins no_parity = {1'b0};
				             bins parity    = {1'b1};}

	EVE_ODD_PARITY: coverpoint cov_data.lcr[4]{bins odd_parity = {1'b0};
						   bins eve_parity = {1'b1};}

	STICK_PARITY: coverpoint cov_data.lcr[5]{bins no_stick_parity = {1'b0};
						 bins stick_parity = {1'b1};}

	BREAK: coverpoint cov_data.lcr[6]{bins break_low = {1'b0};
					  bins break_high    = {1'b1};}

	DIV_LCH: coverpoint cov_data.lcr[7]{bins low = {1'b0};
					    bins high = {1'b1};}

	LCR_RST: coverpoint cov_data.lcr[7:0]{bins lcr_rst = {8'd3};}

	CHAR_SIZE_X_STOP_BIT_X_EVE_ODD_PARITY: cross CHAR_SIZE,STOP_BIT,EVE_ODD_PARITY;



endgroup

covergroup uart_ier_cov;
	option.per_instance = 1;
	RCVD_INT:   coverpoint cov_data.ier[0]{bins dis = {1'b0};
				             bins en    = {1'b1};} 
	THRE_INT:   coverpoint cov_data.ier[0]{bins dis = {1'b0};
				             bins en    = {1'b1};} 
	LSR_INT:   coverpoint cov_data.ier[0]{bins dis = {1'b0};
				             bins en    = {1'b1};} 
	IER_RST:   coverpoint cov_data.ier[7:0]{bins ier_rst = {8'd0};} 


endgroup


covergroup uart_fcr_cov;
	option.per_instance = 1;
	RFIFO:      coverpoint cov_data.fcr[1]{bins dis = {1'b0};
				             bins clr    = {1'b1};} 
	TFIFO:   coverpoint cov_data.fcr[2]{bins dis = {1'b0};
				             bins clr    = {1'b1};} 
	TRG_LVL:   coverpoint cov_data.fcr[7:6]{bins one = {2'b00};
				                bins four    = {2'b01};
						bins eight    = {2'b10};
						bins fourteen    = {2'b11};}
	


endgroup

covergroup uart_mcr_cov;
	option.per_instance = 1;
	LB:   coverpoint cov_data.mcr[4]{bins dis = {1'b0};
				             bins en    = {1'b1};} 
	MCR_RST: coverpoint cov_data.mcr[7:0]{bins lcr_rst = {8'd0};}


endgroup

covergroup uart_iir_cov;
	option.per_instance = 1;

	IIR: coverpoint cov_data.iir[3:1]{bins lsr = {3'b011};
					 bins rdf  = {3'b010};
					 bins ti_o = {3'b110};
					 bins threm = {3'b001}; }
					

endgroup


covergroup uart_lsr_cov;
	option.per_instance = 1;

	DATA_READY:coverpoint cov_data.lsr[0]{bins fifo_empty = {1'b0};
				             bins datarcvd    = {1'b1};}
	OVER_RUN:coverpoint cov_data.lsr[1]{bins nooverrun = {1'b0};
				             bins overrun   = {1'b1};}
	PARITY_ERR:coverpoint cov_data.lsr[2]{bins noparityerr = {1'b0};
				             bins  parityerr    = {1'b1};}
	FRAME_ERR:coverpoint cov_data.lsr[3]{bins noframeerr = {1'b0};
				             bins frameerr    = {1'b1};}
	BREAK_INT:coverpoint cov_data.lsr[4]{bins nobreakint = {1'b0};
				             bins breakint    = {1'b1};}

	THR_EMPTY:coverpoint cov_data.lsr[5]{bins thrnotemp = {1'b0};
				             bins thremo    = {1'b1};}



endgroup




	function new(string name="uart_sb",uvm_component parent);

		super.new(name,parent);

		 uart_signals_cov = new();

		 uart_lcr_cov = new();
	
		 uart_ier_cov = new();

		 uart_fcr_cov = new();

		 uart_mcr_cov = new();

                 uart_iir_cov = new();

 		uart_lsr_cov = new();



	endfunction



	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(uart_config)::get(this,"","uart_config",cfg))
			`uvm_fatal("UART_SB","Cannot get cfg")

		
		fifo_h = new[cfg.no_of_agents];
		foreach(fifo_h[i])
			fifo_h[i]=new($sformatf("fifo_h[%0d]",i),this);
		uart1 = uart_xtn::type_id::create("uart1");
		uart2 = uart_xtn::type_id::create("uart2");
	endfunction

	task  run_phase(uvm_phase phase);
		$display("No_of_agents %0d",cfg.no_of_agents);		
		$display("SB RUN PHASE");

	fork
		forever
			 begin
				fifo_h[0].get(uart1);
				 cov_data = uart1;
				 uart_signals_cov.sample();				
				 uart_lcr_cov.sample();
				 uart_ier_cov.sample();
				 uart_fcr_cov.sample();
				 uart_mcr_cov.sample();
				 uart_iir_cov.sample();
				 uart_lsr_cov.sample();

				

			end
		forever 
			begin
				fifo_h[1].get(uart2);
				 cov_data = uart2;
				 uart_signals_cov.sample();				
				 uart_lcr_cov.sample();
				 uart_ier_cov.sample();
				 uart_fcr_cov.sample();
				 uart_mcr_cov.sample();
				 uart_iir_cov.sample();
				 uart_lsr_cov.sample();


			end
		
	join

	endtask
	
	function void check_phase(uvm_phase phase);
		$display("CHECK_PHASE");
		thrsize1 = uart1.thr.size;
		thrsize2 = uart2.thr.size;
		rbsize1 = uart1.rb.size;
		rbsize2 = uart2.rb.size;
		
    $display("The Value In The Tx FIFO in DUT1 is : %0p ", uart1.thr);
	$display("The Value In The Tx FIFO in DUT2 is : %0p ", uart2.thr);
	$display("The Value In The Rx FIFO in DUT1 is : %0p ", uart1.rb);
	$display("The Value In The Rx FIFO in DUT2 is : %0p ", uart2.rb);

	$display("The Value in DUT1 IIR is : %b ", uart1.iir);
	$display("The Value in DUT2 IIR is : %b ", uart2.iir);

/*
	//Full Duplex

		if(thrsize1 != 0 && thrsize2 != 0 && uart1.thr == uart2.rb && uart1.rb == uart2.thr)
`uvm_info(get_type_name(), $sformatf("\n Full duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart1.sprint()),UVM_LOW)

//			`uvm_info(get_type_name(),"Data match successfull",UVM_LOW)
		//	$display("Full Duplex is SUCCESS");
		
	//Half Duplex
		else if(thrsize1 != 0 && thrsize2 == 0 && uart1.thr == uart2.rb)
			`uvm_info(get_type_name(), $sformatf("\n Half duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)


	//Loop Back
		else if(thrsize1 != 0 && thrsize2 != 0 && uart1.mcr[4] == 1 && uart2.mcr[4] == 1 && uart1.thr == uart1.rb && uart2.thr == uart2.rb)	
			`uvm_info(get_type_name(), $sformatf("\n Loop Back test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)


	//Parity Error
		else if(uart1.lcr[3]==1 && uart1.ier[2]==1 && uart1.iir[3:1]==3 && uart1.lsr[2]==1)
			`uvm_info(get_type_name(), $sformatf("\n Parity Error Successfull \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)

	//Framing Error
		else if(uart1.ier[2]==1 &&  uart1.iir[3:1]==3 && uart1.lsr[3]==1)
			`uvm_info(get_type_name(), $sformatf("\n Framing Error Successfull \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)

	//Overrun Error
		else if(uart1.ier[2]==1 &&  uart1.iir[3:1]==3 && uart1.lsr[1]==1)
			`uvm_info(get_type_name(), $sformatf("\n Overrun Error Successfull \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)


	//BREAK INTERRUPT ERROR
		else if(uart1.lcr[6]==1 && uart1.ier[2]==1 && uart1.iir[3:1]==3 && uart1.lsr[4]==1)
			`uvm_info(get_type_name(), $sformatf("\n Break Interrupt Error Successfull \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)
	
	//Timeout Sequence

		else if(uart1.fcr[7:6]!=uart2.fcr[7:6])
			begin
				if(uart1.iir[3:1]==6) $display("Timeout Occured at UART1\n");
				if(uart2.iir[3:1]==6) $display("Timeout Occured at UART2\n");		
			
			end
	
	//Thrempty Sequence

		else if(uart1.ier[1]==1&&uart1.iir[3:1]==1&&uart1.lsr[5]==1)
			`uvm_info(get_type_name(), $sformatf("\n Thr Empty Successfull \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)
	


	//data mismatch
		else if(thrsize1 != 0 && thrsize2 != 0 && uart1.thr != uart2.rb && uart2.thr != uart1.rb)
			`uvm_info(get_type_name(), $sformatf("\n test failed \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)

		else
			`uvm_info(get_type_name(), $sformatf("\n no data found   \n from sb uart1: \n%s \n from sb uart2: \n%s", uart1.sprint(),uart2.sprint()),UVM_LOW)


*/


//NOW CHECKING BOTH UARTS IN CHECK PHASE

//FULL DUPLEX
		if(thrsize1 != 0 && thrsize2 != 0 && uart1.thr == uart2.rb && uart2.thr == uart1.rb)
			`uvm_info(get_type_name(), $sformatf("\n Full duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)
		else
			$display("Full duplex is failed \n");

	
		//HALF DUPLEX
		if((thrsize1 != 0) && (thrsize2 == 0))
			begin
				if(uart1.thr == uart2.rb)
					`uvm_info(get_type_name(), $sformatf("\n Half duplex test successful \n from sb uart1:\n %s \n from sb uart2:\n %s",uart1.sprint(),uart2.sprint()),UVM_LOW)
				else
					$display("Half duplex failed \n");
			end
	
		if((thrsize1 == 0) && (thrsize2 != 0))
			begin
				if(uart2.thr == uart1.rb)
					`uvm_info(get_type_name(), $sformatf("\n Half duplex test successful \n from sb uart2:\n %s \n from sb uart2:\n %s",uart2.sprint(),uart1.sprint()),UVM_LOW)
				else
					$display("Half duplex failed \n");
			end

		//LOOPBACK
		if(uart1.mcr[4] == 1)
			begin
				if(thrsize1 != 0)
					begin
						if(uart1.thr == uart1.rb)
							`uvm_info(get_type_name(), $sformatf("\n Loopback in UART1 is successful:\n %s",uart1.sprint()),UVM_LOW)
						else
							$display("Loopback in UART1 failed");
					end
			end							
	
		if(uart2.mcr[4] == 1)
			begin
				if(thrsize2 != 0)
					begin
						if(uart2.thr == uart2.rb)
							`uvm_info(get_type_name(), $sformatf("\n Loopback in UART2 is successful:\n %s",uart2.sprint()),UVM_LOW)
						else
							$display("Loopback in UART2 failed");
					end
			end							

	
		//PARITY ERROR
		if(uart1.lcr[3] == 1 && uart1.ier[2] == 1 && uart1.iir[3:1] == 3 && uart1.lsr[2] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Parity Error in UART 1:\n %s",uart1.sprint()),UVM_LOW)
			
		if(uart2.lcr[3] == 1 && uart2.ier[2] == 1 && uart2.iir[3:1] == 3 && uart2.lsr[2] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Parity Error in UART 2:\n %s",uart2.sprint()),UVM_LOW)


		//FRAMING ERROR
		
		if(uart1.ier[2] == 1 && uart1.iir[3:1] == 3 && uart1.lsr[3] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Framing Error in UART 1:\n %s",uart1.sprint()),UVM_LOW)

		if(uart2.ier[2] == 1 && uart2.iir[3:1] == 3 && uart2.lsr[3] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Framing Error in UART 2:\n %s",uart2.sprint()),UVM_LOW)

	
		//OVERRUN ERROR
		if(uart1.ier[2] == 1 && uart1.iir[3:1] == 3 && uart1.lsr[1] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Overrun Error in UART 1:\n %s",uart1.sprint()),UVM_LOW)

		if(uart2.ier[2] == 1 && uart2.iir[3:1] == 3 && uart2.lsr[1] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Overrun Error in UART 2:\n %s",uart2.sprint()),UVM_LOW)
	

		//BREAK INTERRUPT
		if(uart1.lcr[6] == 1 && uart1.ier[2] == 1 && uart1.iir[3:1] == 3 && uart1.lsr[4] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Break Interrupt in UART 1:\n %s",uart1.sprint()),UVM_LOW)
			
		if(uart2.lcr[6] == 1 && uart2.ier[2] == 1 && uart2.iir[3:1] == 3 && uart2.lsr[4] == 1)
			`uvm_info(get_type_name(), $sformatf("\n Break Interrupt in UART 2:\n %s",uart2.sprint()),UVM_LOW)

		
		//TIMEOUT
		if(uart1.fcr[7:6] != uart2.fcr[7:6])
			begin
				if(uart1.iir[3:1] == 6)
					`uvm_info(get_type_name(), $sformatf("\n Time out occured in uart 1: \n %s",uart1.sprint()),UVM_LOW)	
				if(uart2.iir[3:1] == 6)
					`uvm_info(get_type_name(), $sformatf("\n Time out occured in uart 2: \n %s",uart2.sprint()),UVM_LOW)
			end
		

		//THREMPTY
		if(uart1.ier[1] == 1 && uart1.iir[3:1] == 1 && uart1.lsr[5] == 1)
			`uvm_info(get_type_name(), $sformatf("\n THR empty in UART 1:\n %s",uart1.sprint()),UVM_LOW)

		if(uart2.ier[1] == 1 && uart2.iir[3:1] == 1 && uart2.lsr[5] == 1)
			`uvm_info(get_type_name(), $sformatf("\n THR Empty in UART 2:\n %s",uart2.sprint()),UVM_LOW)


	endfunction


endclass


