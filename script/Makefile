all: vcs simv
#===================================
# declare variables
#===================================
SEED 		?=
#rtl name
DUT  		?= dut
#testcase name
TEST 		?= random_test
TEST_CASES  =  logic_test random_test
#uvm version
UVM_VER 	= uvm-1.1
#uvm info
VERBOSITY 	= UVM_HIGH
#sim date
SHELL_DATE	= $(shell date +%F-%H-%M-%S)
DATE		= $(SHELL_DATE)
#===================================
# directory path
#===================================
#Makefile position
SCRIPT_DIR	= $(shell pwd)
SIM_DIR		= $(SCRIPT_DIR)/$(DUT)
#other dir
VERIFY_DIR	= $(SCRIPT_DIR)/..
RTL_DIR		= $(VERIFY_DIR)/rtl
TOP_DIR		= $(VERIFY_DIR)/top
RESULT_DIR	= $(VERIFY_DIR)/results
#===================================
# UVM component path
#===================================
AGENT_DIR	= $(VERIFY_DIR)/agent
ENV_DIR		= $(VERIFY_DIR)/env
ITEM_DIR	= $(VERIFY_DIR)/item
TEST_DIR	= $(VERIFY_DIR)/test
#===================================
# VCS complie option
#===================================
#top file
VCS_VFILES += $(TOP_DIR)/top_tb.sv
#dut code
VCS_VFILES += $(RTL_DIR)/*.v

VCS_FLAGS  += -full64 +v2k -sverilog -q
VCS_FLAGS  += -debug_acc+dmptf -debug_region+cell+encrypt
VCS_FLAGS  += -timescale="1ns/1ns"
VCS_FLAGS  += +define+$(DUT)+DUT_NAME=$(DUT)
#VCS_FLAGS  += -lca
VCS_FLAGS  += -cm_tgl mda -kdb -ntb_opts $(UVM_VER)
#uvm component positon
VCS_FLAGS  += +incdir+$(AGENT_DIR)
VCS_FLAGS  += +incdir+$(ENV_DIR)
VCS_FLAGS  += +incdir+$(ITEM_DIR)
VCS_FLAGS  += +incdir+$(TEST_DIR)
#compile time reg
#VCS_FLAGS  += +vcs+imitreg_random
#enable coverage
VCS_FLAGS  += -cm line+tgl+cond+fsm+branch+assert
VCS_FLAGS  += -l $(SIM_DIR)comp.log


#===================================
# VCS simulation option
#===================================
SIMV_FLAG  += +UVM_TESTNAME=$(TEST)
SIMV_FLAG  += +ntb_random_seed=$(SEED)
SIMV_FLAG  += +vcs+initreg+0

#SIMV_FLAG  += -gui=verdi +UVM_VERDI_TRACE="UVM_AWARE+RAL+HIER+COMPWAVE"+UVM_TR_RECORD 
SIMV_FLAG  += -cm line+tgl+cond+fsm+branch+assert
#SIMV_FLAG  += -cm_name $(COV_DIR)
SIMV_FLAG  += +FSDB_NAME=$(RESULT_DIR)/wave.fsdb
SIMV_FLAG  += -l $(RESULT_DIR)/run.log
SIMV_FLAG  += +UVM_VERPOSITY=$(VERBOSITY)
SIMV_FLAG  += +UVM_TR_RECORD +UVM_LOG_RECORD


vcs:
	@echo $(SCRIPT_DIR)
ifeq ($(SIM_DIR), $(wildcard $(SIM_DIR)))
	@echo "simulation dir exsited"
else
	@echo "simulation dir created now"
	mkdir $(SIM_DIR)
endif
	@echo "compile simv in 64-bit mode"
	cd $(SIM_DIR); vcs $(VCS_FLAGS) $(VCS_VFILES)

simv:
	@echo $(DATE)
ifeq ($(RESULT_DIR), $(wildcard $(RESULT_DIR)))
	@echo "simulation dir exsited"
else
	@echo "simulation dir created now"
	mkdir -p $(RESULT_DIR)
endif
	cd $(SIM_DIR); ./simv $(SIMV_FLAG)
#see wave
verdi:
	cd $(SIM_DIR); verdi -ntb_opts uvm -sv $(VCS_VFILES) -ssf $(RESULT_DIR)/wave.fsdb &
#see coverage
dve:
	cd $(SIM_DIR); dve -full64 -cov -dir simv.vdb &
clean:
	cd $(RESULT_DIR); rm -rf *.log *.fsdb \
    cd $(SCRIPT_DIR)/$(DUT);rm -rf simv* csrc* *.tmp *.vpd *.key *.log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys* novas.* *.dat *.fsdb verdi* 
#
#regression:
#	@for test in $(TEST_CASES); do \
#		echo "Running $$test..."; \
#		cd $(SIM_DIR);  ./simv $(SIMV_FLAG) +UVM_TESTNAME=$$test; \
#	done

#	cd $(SIM_DIR); vcs $(VCS_FLAGS) $(VCS_VFILES) 
#	cd $(SIM_DIR); ./simv $(SIMV_FLAG) +UVM_TESTNAME=logic_test 
#	cd $(SIM_DIR); ./simv $(SIMV_FLAG) +UVM_TESTNAME=random_test
	
