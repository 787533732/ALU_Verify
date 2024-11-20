class my_driver extends uvm_driver#(my_transaction);

   virtual my_if vif;
   `uvm_component_utils_begin(my_driver)
      `uvm_field_int(pre_num, UVM_ALL_ON)
   `uvm_component_utils_end

   function new(string name = "my_driver", uvm_component parent = null);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(uvm_phase phase);
      `uvm_info("my_driver", $sformatf("before super.build_phase, the pre_num is %0d", pre_num), UVM_LOW) 
      super.build_phase(phase);
      `uvm_info("my_driver", $sformatf("after super.build_phase, the pre_num is %0d", pre_num), UVM_LOW) 
      if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_driver", "virtual interface must be set for vif!!!")
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task drive_one_pkt(my_transaction tr);
endclass

task my_driver::main_phase(uvm_phase phase);
    vif.valid_i <= 0;
    vif.op_type <= 0;
    vif.src_0   <= 0;
    vif.src_1   <= 0;
   while(!vif.rst_n)
      @(posedge vif.clk);
   while(1) begin
      seq_item_port.get_next_item(req);
      drive_one_pkt(req);
      seq_item_port.item_done();
   end
endtask

task my_driver::drive_one_pkt(my_transaction tr);
   while(!vif.rst_n)
      @(posedge vif.clk);
   `uvm_info("my_driver", "begin to drive one pkt", UVM_LOW);
   vif.valid_i <= tr.valid_i;
   vif.op_type <= tr.op_type;
   vif.src_0   <= tr.src_0;
   vif.src_1   <= tr.src_1;
   repeat(2) begin
      @(posedge vif.clk);
   end
   vif.valid_i <= 1'b0;
   vif.op_type <= 4'b0000;
   vif.src_0   <= 32'd0;
    vif.src_1  <= 32'd0;
   `uvm_info("my_driver", "end drive one pkt", UVM_LOW);
   @(posedge vif.clk);
endtask
