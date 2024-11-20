interface my_if(input clk, input rst_n);
    logic        valid_i;   
    logic [ 3:0] op_type;
    logic [31:0] src_0;
    logic [31:0] src_1;
    logic        valid_o;
    logic [31:0] sum;
    logic        taken;   
endinterface