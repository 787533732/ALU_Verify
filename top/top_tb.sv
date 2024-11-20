`include "../../top/top_tb_pkg.sv"
module top_tb;

reg          clk;
reg          rst_n;
reg  [3:0]   op_type;
reg  [31:0]  src_0  ;
reg  [31:0]  src_1  ;
reg          valid_i;
wire [31:0]  sum;
wire         taken;
wire         valid_o;

my_if input_if(clk, rst_n);

dut dut_inst
(  
   .clk      (clk  ),
   .rst_n    (rst_n),

   .op_type  (input_if.op_type),
   .src_0    (input_if.src_0  ), 
   .src_1    (input_if.src_1  ), 
   .valid_i  (input_if.valid_i),
   .sum      (input_if.sum    ),
   .taken    (input_if.taken),
   .valid_o  (input_if.valid_o) 
);

initial begin
   clk = 0;
   forever begin
      #100 clk = ~clk;
   end
end

initial begin
   rst_n = 1'b0;
   #100;
   rst_n = 1'b1;
end

initial begin
   run_test();
end

initial begin
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.drv", "vif", input_if);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.i_agt.mon", "vif", input_if);
   uvm_config_db#(virtual my_if)::set(null, "uvm_test_top.env.o_agt.mon", "vif", input_if);
end

initial begin
    string fsdbfile;
        if($value$plusargs("FSDB_NAME=%s", fsdbfile)) begin
            $fsdbDumpfile(fsdbfile);
            $fsdbDumpvars(0, top_tb, "+all");
            $fsdbDumpon;
        end
end

endmodule
