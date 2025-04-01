#Makefile for UVM Testbench - Lab 05

# SIMULATOR = Questa for Mentor's Questasim
# SIMULATOR = VCS for Synopsys's VCS

SIMULATOR = Questa 



RTL= ../rtl/*
work= work #library name
SVTB1= ../tb/top.sv
INC = +incdir+../tb +incdir+../test +incdir+../rtl
SVTB2 = ../test/uart_pkg.sv
VSIMOPT= -vopt -voptargs=+acc 
VSIMCOV= -coverage -sva 
VSIMBATCH1= -c -do  " log -r /* ;coverage save -onexit mem_cov1;run -all; exit"
VSIMBATCH2= -c -do  " log -r /* ;coverage save -onexit mem_cov2;run -all; exit"
VSIMBATCH3= -c -do  " log -r /* ;coverage save -onexit mem_cov3;run -all; exit"
VSIMBATCH4= -c -do  " log -r /* ;coverage save -onexit mem_cov4;run -all; exit"
VSIMBATCH5= -c -do  " log -r /* ;coverage save -onexit mem_cov5;run -all; exit"
VSIMBATCH6= -c -do  " log -r /* ;coverage save -onexit mem_cov6;run -all; exit"
VSIMBATCH7= -c -do  " log -r /* ;coverage save -onexit mem_cov7;run -all; exit"
VSIMBATCH8= -c -do  " log -r /* ;coverage save -onexit mem_cov8;run -all; exit"
VSIMBATCH9= -c -do  " log -r /* ;coverage save -onexit mem_cov9;run -all; exit"
VSIMBATCH10= -c -do  " log -r /* ;coverage save -onexit mem_cov10;run -all; exit"

help:
	@echo =============================================================================================================
	@echo "! USAGE   	--  make target                           	!"
	@echo "! clean   	=>  clean the earlier log and intermediate files.     	!"
	@echo "! sv_cmp    	=>  Create library and compile the code.                  !"
	@echo "! run_test	=>  clean, compile & run the simulation for ram_base_test in batch mode.!" 
	@echo ====================================================================================================================

clean : clean_$(SIMULATOR)
sv_cmp : sv_cmp_$(SIMULATOR)
run_test : run_test_$(SIMULATOR)
run_test1 : run_test1_$(SIMULATOR)
run_test2 : run_test2_$(SIMULATOR)
run_test3 : run_test3_$(SIMULATOR)
run_test4 : run_test4_$(SIMULATOR)
run_test5 : run_test5_$(SIMULATOR)
run_test6 : run_test6_$(SIMULATOR)
run_test7 : run_test7_$(SIMULATOR)
run_test8 : run_test8_$(SIMULATOR)
run_test9 : run_test9_$(SIMULATOR)
view_wave1 : view_wave1_$(SIMULATOR)
view_wave2 : view_wave2_$(SIMULATOR)
view_wave3 : view_wave3_$(SIMULATOR)
view_wave4 : view_wave4_$(SIMULATOR)
view_wave5 : view_wave5_$(SIMULATOR)
view_wave6 : view_wave6_$(SIMULATOR)
view_wave7 : view_wave7_$(SIMULATOR)
view_wave8 : view_wave8_$(SIMULATOR)
view_wave9 : view_wave9_$(SIMULATOR)
view_wave10 : view_wave10_$(SIMULATOR)
# ----------------------------- Start of Definitions for Mentor's Questa Specific Targets -------------------------------#

sv_cmp_Questa:
	vlib $(work)
	vmap work $(work)
	vlog -work $(work) $(INC) $(RTL) $(SVTB2) $(SVTB1) 	
	
run_test_Questa: clean sv_cmp
	vsim  $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH1)  -l test1.log  -sv_seed random  work.top +UVM_TESTNAME=uart_test
	 vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov1
	
run_test1_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH2)  -wlf wave_file2.wlf -l test2.log  -sv_seed random  work.top +UVM_TESTNAME=full_dplx_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov2
 
run_test2_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH3)  -wlf wave_file3.wlf -l test3.log  -sv_seed random  work.top +UVM_TESTNAME=half_dplx_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov3

run_test3_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH4)  -wlf wave_file4.wlf -l test4.log  -sv_seed random  work.top +UVM_TESTNAME=loop_back_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov4 

run_test4_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH5)  -wlf wave_file5.wlf -l test5.log  -sv_seed random  work.top +UVM_TESTNAME=parity_error_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov5

run_test5_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH6)  -wlf wave_file6.wlf -l test6.log  -sv_seed random  work.top +UVM_TESTNAME=framing_error_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov6
  
run_test6_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH7)  -wlf wave_file7.wlf -l test7.log  -sv_seed random  work.top +UVM_TESTNAME=overrun_error_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov7
  
run_test7_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH8)  -wlf wave_file8.wlf -l test8.log  -sv_seed random  work.top +UVM_TESTNAME=break_int_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov8       

run_test8_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH9)  -wlf wave_file9.wlf -l test9.log  -sv_seed random  work.top +UVM_TESTNAME=timeout_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov9

run_test9_Questa:
	vsim -cvgperinstance $(VSIMOPT) $(VSIMCOV) $(VSIMBATCH10)  -wlf wave_file10.wlf -l test10.log  -sv_seed random  work.top +UVM_TESTNAME=thrempty_test
	vcover report  -cvg  -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov10
 
view_wave1_Questa:
	vsim -view wave_file1.wlf
	
view_wave2_Questa:
	vsim -view wave_file2.wlf
	
view_wave3_Questa:
	vsim -view wave_file3.wlf
	
view_wave4_Questa:
	vsim -view wave_file4.wlf

view_wave5_Questa:
	vsim -view wave_file5.wlf
 
view_wave6_Questa:
	vsim -view wave_file6.wlf
  
view_wave7_Questa:
	vsim -view wave_file7.wlf
  
view_wave8_Questa:
	vsim -view wave_file8.wlf
  
view_wave9_Questa:
	vsim -view wave_file9.wlf       
 
view_wave10_Questa:
	vsim -view wave_file10.wlf
   
report_Questa:
	vcover merge mem_cov mem_cov1 mem_cov2 mem_cov3 mem_cov4 mem_cov5 mem_cov6 mem_cov7 mem_cov8 mem_cov9 mem_cov10 
	vcover report -cvg -details -nocompactcrossbins -codeAll -assert -directive -html mem_cov

regress_Questa: clean_Questa run_test_Questa run_test1_Questa run_test2_Questa run_test3_Questa run_test4_Questa run_test5_Questa run_test6_Questa run_test7_Questa run_test8_Questa run_test8_Questa run_test9_Questa report_Questa cov_Questa

cov_Questa:
	firefox covhtmlreport/index.html&
	
	
clean_Questa: 
	rm -rf transcript* log fcover* covhtml* mem_cov* *.wlf modelsim.ini work
	clear

# ----------------------------- End of Definitions for Mentor's Questa Specific Targets -------------------------------#

# ----------------------------- Start of Definitions for Synopsys's VCS Specific Targets -------------------------------#

sv_cmp_VCS:
	vcs -l vcs.log -timescale=1ns/1ps -sverilog -ntb_opts uvm -debug_access+all -full64 $(INC) $(SVTB2) $(SVTB1) $(RTL)
	      
run_test_VCS:	clean  sv_cmp_VCS
	./simv -a test.log +ntb_random_seed_automatic +UVM_TESTNAME=uart_test
	urg -dir mem_cov2.vdb -format both -report urgReport1
 	 
	
run_test1_VCS:	
	./simv -a vcs.log +fsdbfile+wave2.fsdb -cm_dir ./mem_cov2 +ntb_random_seed_automatic +UVM_TESTNAME=full_dplx_test 
	urg -dir mem_cov2.vdb -format both -report urgReport2
	
clean_VCS:
	rm -rf simv* csrc* .tmp *.vdb *.key *.log *hdrs.h urgReport novas* vdCov*
	clear


# ----------------------------- END of Definitions for Synopsys's VCS Specific Targets -------------------------------#
