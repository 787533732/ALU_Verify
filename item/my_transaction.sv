class my_transaction extends uvm_sequence_item;

    rand bit        valid_i;
    rand fuOpType_e op_type;
    rand bit [31:0] src_0;
    rand bit [31:0] src_1;
    rand bit        valid_o;
    rand bit [31:0] sum;
    rand bit        taken;
    
    `uvm_object_utils_begin(my_transaction)
        `uvm_field_int  (valid_i, UVM_ALL_ON)
        `uvm_field_enum (fuOpType_e, op_type, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int  (src_0,   UVM_ALL_ON|UVM_HEX)
        `uvm_field_int  (src_1,   UVM_ALL_ON|UVM_HEX)
        `uvm_field_int  (valid_o, UVM_ALL_ON)
        `uvm_field_int  (sum,     UVM_ALL_ON|UVM_HEX)
        `uvm_field_int  (taken,   UVM_ALL_ON)
    `uvm_object_utils_end

   function new(string name = "my_transaction");
      super.new();
   endfunction

endclass