













class uart_seqs extends uvm_sequence #(uart_xtn);
	`uvm_object_utils(uart_seqs)

	function new(string name="uart_seqs");
		super.new(name);
	endfunction
endclass


//full-duplex sequence 1
class full_duplex_seqs1 extends uart_seqs;
	`uvm_object_utils(full_duplex_seqs1)

	function new(string name="full_duplex_seqs1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1  msb is stoed in dlr_msb and lsb is stored in dlr_lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'd0;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd25;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
	//	reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass				



//full-duplex sequence 2
class full_duplex_seqs2 extends uart_seqs;
	`uvm_object_utils(full_duplex_seqs2)

	function new(string name="full_duplex_seqs2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
//step1
		//line control register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		finish_item(req);

//step2
		//divisor latch register (msb)
		// divisor1  and its binary  msb is stored in dlr_msb and lsb is stored in dlr_lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'd0;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd28;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
	//	reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass



//half duplex 1
class half_duplex_seqs1 extends uart_seqs;
	`uvm_object_utils(half_duplex_seqs1)

	function new(string name = "half_duplex_seqs1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 27 and is stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

//step 7
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd25;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	//as half duplex doesn't transmit and receive data simultaneously so seq1 doesn't have receiver logic and seq2 doesn't have transmitter logic
	endtask
endclass

//half duplex2

class half_duplex_seqs2 extends uart_seqs;
	`uvm_object_utils(half_duplex_seqs2)

	function new(string name = "half_duplex_seqs2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'd0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[1] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);



//step 7 
		//reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 8
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass


//loop back seq 1
class loop_back1 extends uart_seqs;
	`uvm_object_utils(loop_back1)

	function new(string name = "loop_back1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 326 and its binary is 0000_0001_0110_0110 msb is stored in dlr_msb and lsb is stored in dlr_lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'b0100_0110;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

	//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);


	//step 6
		//writing mcr[4]==1, it enables loop mode
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 4; wb_we_i == 1; wb_data_i == 8'b0001_0000;});
		finish_item(req);

	//step 7
		//IER - making ier[0] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

	//step 8
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd20;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	
	//step 9
		
		//reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass


//loop back seq 2
class loop_back2 extends uart_seqs;
	`uvm_object_utils(loop_back2)

	function new(string name = "loop_back2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 163 and its binary is 0000_0000_1010_0011 msb is stoed in dlr_msb and lsb is stored in dlr_lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'b1010_0011;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

	//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);


	//step 6
		//writing mcr[4]==1, it enables loop mode
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 4; wb_we_i == 1; wb_data_i == 8'b0001_0000;});
		finish_item(req);

	//step 7
		//IER - making ier[0] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0001;});
		finish_item(req);

	//step 8
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd15;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
	
	//step 9
		
		//reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10
				
		if(req.iir[3:1] == 3'b010)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass






///////////////////////////////////////////////////// partity error seq 1 ////////////////////////////////////////////
class parity_seq1 extends uart_seqs;
	`uvm_object_utils(parity_seq1)

	function new(string name="parity_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//lcr[7]==0, and for enabling parity lcr[3]==1, and lcr[4]==1 for even parity and lcr[4]==0 for odd parity, here we use even parity 
		//lcr == 8'b0001_1011
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0001_1011;}); 
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 5
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

	//step 6
		//writing into ier
		//making ier[2]==1, enabling the receiver line status interrupt
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

	//step 7	
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd24;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 8	
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10		
		if(req.iir[3:1] == 3'b011)	// means there is an parity error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==5; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass




//////////////////////////////////////////////////////// partity error seq 2 /////////////////////////////////////////
class parity_seq2 extends uart_seqs;
	`uvm_object_utils(parity_seq2)

	function new(string name="parity_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");

	//step 1
		//lcr[7]==1, enabling dlr register
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

	//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 4
		//lcr[7]==0, and for enabling parity lcr[3]==1, and lcr[4]==1 for even parity and lcr[4]==0 for odd parity, here we use even parity 
		//lcr == 8'b0001_1011
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_1011;}); 
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 5
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

	//step 6
		//writing into ier
		//making ier[2]==1, enabling the receiver line status interrupt
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

	//step 7	
		//thr (passing actual value) 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd30;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

	//step 8	
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

	//step 10
		if(req.iir[3:1] == 3'b011)	// means there is an parity error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==5; wb_we_i==0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass



//////FRAMING ERROR SEQUENCES//////



class framing1 extends uart_seqs;
	`uvm_object_utils(framing1)

	function new(string name="framing1");
		super.new(name);
	endfunction

	task body();
		//super.body();

//step1
		//line control register
		req = uart_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 1 \n\n\n\n");

//step2
		//divisor latch register (msb) divisor1 = 16'd54
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 2 \n\n\n\n");

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd54;});
		//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 3 \n\n\n\n");

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 5-bits soo the lcr[1:0] == 00
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 4 \n\n\n\n");

//step 5		
		//IER -  making ier[2] == 1 and ier[0] == 1	 ier == 5
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0101;}); ///ier == 5 2nd bit and 0th bit high
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 5 \n\n\n\n");

//step 6		




		//clearing fifo registers
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 6 \n\n\n\n");

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd64;});
		//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 7 \n\n\n\n");

//step 8
	//	reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0;});
		finish_item(req);
		$display("\n\n\n\n THIS IS FD1 STEP 8 \n\n\n\n");
		get_response(req);

//step 9
				
		
		if(req.iir[3:1] == 2)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0;});
				//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
				$display("\n\n\n\n THIS IS FD1 STEP 9 \n\n\n\n");
			end
			
//step 10
			
		if(req.iir[3:1] == 3)	// 
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==5; wb_we_i==0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
				$display("\n\n\n\n THIS IS STEP 10 \n\n\n\n");
			end
	endtask
endclass				



class framing2 extends uart_seqs;
	`uvm_object_utils(framing2)

	function new(string name="framing2");
		super.new(name);
	endfunction

	task body();
		//super.body();

//step1
		//line control register
		req = uart_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 1 \n\n\n\n");

//step2
		//divisor latch register (msb)
		// divisor2 = 16'd27
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 2 \n\n\n\n");

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 3 \n\n\n\n");

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
	start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0111;});
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 4 \n\n\n\n");

//step 5		
		//clearing fifo registers
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 5 \n\n\n\n");
		

//step 6		
		//IER - making ier[2] == 1 and ier[0] == 1  its ier == 5
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0101;});
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 6 \n\n\n\n");
//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd69;});
		//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 7 \n\n\n\n");

//step 8
	//	reading iir (we can't say data is availabe in rb r not for that we are checking rb[3:1] is 2 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0;});
		finish_item(req);
		$display("\n\n\n\n THIS IS STEP 8 \n\n\n\n");
		get_response(req);

//step 9
			
		if(req.iir[3:1] == 2)	// means there is data available in receiver buffer(rb)
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==0; wb_we_i==0;});
				//`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
				$display("\n\n\n\n THIS IS STEP 9 \n\n\n\n");
			end

//step 10		
		
		
		if(req.iir[3:1] == 3)	// 
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==5; wb_we_i==0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
				$display("\n\n\n\n THIS IS STEP 10 \n\n\n\n");
			end	
	endtask
endclass


////////////////////////////////////////////////// overrun sequence 1 ///////////////////////////////////////
class overrun1 extends uart_seqs;
	`uvm_object_utils(overrun1)

	function new(string name="overrun1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value) and repeating it for more than 16 times which creates an overrun i.e., rb gets overflowed
		repeat(18)
			begin 
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 5; wb_we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

/////////////////////////////////////////////////////overrun sequence 2 //////////////////////////////////
class overrun2 extends uart_seqs;
	`uvm_object_utils(overrun2)

	function new(string name="overrun2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11
start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value) and repeating it for more than 16 times which creates an overrun i.e., rb gets overflowed
		repeat(18)
			begin 
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 5; wb_we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass				














		
//////////////////////////////////////////////////// break inetrrupt error sequence 1 ////////////////////////////////////////
class break_int_seq1 extends uart_seqs;
	`uvm_object_utils(break_int_seq1)

	function new(string name="break_int_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11 and lcr[6] == 1 this will break the communication and the thr will transmits all 0's
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0100_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd65;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 5; wb_we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

////////////////////////////////////////////////////////// break interrupt error sequence 2 //////////////////////////
class break_int_seq2 extends uart_seqs;
	`uvm_object_utils(break_int_seq2)

	function new(string name="break_int_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no_of bits per each character is 8-bits soo the lcr[1:0] == 11 and lcr[6] == 1 this will break the communication and the thr will transmits all 0's
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0100_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0100;});
		finish_item(req);

//step 7
		//thr (passing actual value) 			 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd50;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 3 or not, if it is 3 then there is an error and we have to read lsr at this time and if it is not 3 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b011)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 5; wb_we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		






//////////////////////////////////////////////// timeout error sequence 1 /////////////////////////////////
class timeout_seq1 extends uart_seqs;
	`uvm_object_utils(timeout_seq1)

	function new(string name="timeout_seq1");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 27 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd27;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no of bits is 8 by making lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr and the reciever fifo interrupt triggers after it reveives 1 byte i.e., fcr[7:6] == 00
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0000_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0101;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd20;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 6 or not, if it is 6 then there is an error and we have to read lsr at this time and if it is not 6 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b110)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		

//////////////////////////////////////////////// timeout error sequence 2 /////////////////////////////////
class timeout_seq2 extends uart_seqs;
	`uvm_object_utils(timeout_seq2)

	function new(string name="timeout_seq2");
		super.new(name);
	endfunction

	task body();
		req = uart_xtn::type_id::create("req");
	
	//step 1
	//lcr register
	//making lcr[7] == 1, so that dlr can be accessed
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b1000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence %s",req.sprint()),UVM_LOW)
		finish_item(req);

//step2
		//divisor latch register (msb) divisor1 = 13 and stored in lsb
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0000;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step3
		//divisor latch register (lsb)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd13;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 4
		//enabling normal registers by making lcr[7] = 0 and no of bits is 8 by making lcr[1:0] == 11
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 3; wb_we_i == 1; wb_data_i == 8'b0000_0011;});
		finish_item(req);

//step 5		
		//clearing fifo registers, writing into fcr and the reciever fifo interrupt triggers after it reveives 4 bytes i.e., fcr[7:6] == 01
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 1; wb_data_i == 8'b0100_0110;});
		finish_item(req);

//step 6		
		//IER - making ier[2] == 1	
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 1; wb_we_i == 1; wb_data_i == 8'b0000_0101;});
		finish_item(req);

//step 7
		//thr (passing actual value)
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 1; wb_data_i == 8'd24;});
		`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
		finish_item(req);

//step 8
		//reading iir and checking iir[3:1] is 6 or not, if it is 6 then there is an error and we have to read lsr at this time and if it is not 6 there is no error 
		start_item(req);
		assert(req.randomize() with {wb_adr_i == 2; wb_we_i == 0; wb_data_i == 0;});
		finish_item(req);
		get_response(req);

//step 9
				
		if(req.iir[3:1] == 3'b110)	// means there is error
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i == 0; wb_we_i == 0; wb_data_i == 0;});
				`uvm_info(get_type_name(),$sformatf("printing from sequence \n %s", req.sprint()),UVM_LOW)
				finish_item(req);
			end
	endtask
endclass		




//Thr_Empty_sequence 1
class thr_empty_seqs1 extends uart_seqs;
	//factory registration
	`uvm_object_utils(thr_empty_seqs1)
	
	//new constructor method
	function new(string name="thr_empty_seqs1");
		super.new(name);
	endfunction
	
	
	task body();

	//step-1 LCR[7]=1 enables DLR
		req=uart_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_data_i==8'b1000_0000;});
		$display("----------------------------THR EMPTY SEQUENCE 1----------------------------");
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-2 DLR msb stores msb of divisor
		start_item(req);
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_data_i==8'b0000_0000;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-3 DLR lsb stores lsb of divisor
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_data_i==8'd27;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-4 LCR[7]=0 disables DLR and enables normal registers & no. of bits each characters is 8-bits LCR[1:0]=2'b11
		start_item(req);
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_data_i==8'b0000_0011;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-5 FCR clears tx and rx FIFO
		start_item(req);
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_data_i==8'b0000_0000;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-6 IER enables Receiver Data available
		start_item(req);
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_data_i==8'b0000_0010;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-7 Sending actual Data (passing thr)
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_data_i==8'd96;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-8 Reading IIR (we can't say data is available in rb, so to check -> iir[3:1]=3'b010)
		start_item(req);
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==0;});
		finish_item(req);
		get_response(req);
	
	// step-9 LSR
	//iir[3:1]=001 -> Transmitter holding register empty
		if(req.iir[3:1]==3'b001) //reading LSR
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==5; wb_we_i==0;});
				$display("----------------------------THR EMPTY SEQUENCE 1----------------------------");
				`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
				finish_item(req);
			end
		
	endtask
	
endclass


//Thr_Empty_sequence 2
class thr_empty_seqs2 extends uart_seqs;
	//factory registration
	`uvm_object_utils(thr_empty_seqs2)
	
	//new constructor method
	function new(string name="thr_empty_seqs2");
		super.new(name);
	endfunction
	
	
	task body();

	//step-1 LCR[7]=1 enables DLR
		req=uart_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_data_i==8'b1000_0000;});
		$display("----------------------------THR EMPTY SEQUENCE 2----------------------------");
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-2 DLR msb stores msb of divisor
		start_item(req);
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_data_i==8'b0000_0000;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-3 DLR lsb stores lsb of divisor
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_data_i==8'd27;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-4 LCR[7]=0 disables DLR and enables normal registers & no. of bits each characters is 8-bits LCR[1:0]=2'b11
		start_item(req);
		assert(req.randomize() with {wb_adr_i==3; wb_we_i==1; wb_data_i==8'b0000_0011;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-5 FCR clears tx and rx FIFO
		start_item(req);
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==1; wb_data_i==8'b0000_0000;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-6 IER enables Receiver Data available
		start_item(req);
		assert(req.randomize() with {wb_adr_i==1; wb_we_i==1; wb_data_i==8'b0000_0010;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-7 Sending actual Data (passing thr)
		start_item(req);
		assert(req.randomize() with {wb_adr_i==0; wb_we_i==1; wb_data_i==8'd69;});
		`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
		finish_item(req);
	
	//step-8 Reading IIR (we can't say data is available in rb, so to check -> iir[3:1]=3'b010)
		start_item(req);
		assert(req.randomize() with {wb_adr_i==2; wb_we_i==0;});
		finish_item(req);
		get_response(req);
	
	// step-9 LSR
	//iir[3:1]=001 -> Transmitter holding register empty
		if(req.iir[3:1]==3'b001) //reading LSR
			begin
				start_item(req);
				assert(req.randomize() with {wb_adr_i==5; wb_we_i==0;});
				$display("----------------------------THR EMPTY SEQUENCE 2----------------------------");
				`uvm_info(get_type_name(), $sformatf("printing from sequence \n %s", req.sprint()), UVM_LOW)
				finish_item(req);
			end
		
	endtask
	
endclass
