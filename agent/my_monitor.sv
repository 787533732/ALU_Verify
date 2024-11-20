class my_monitor extends uvm_monitor;

   virtual my_if vif;
   int dut_out = 0;
   uvm_analysis_port #(my_transaction) ap;
   `uvm_component_utils(my_monitor)
   function new(string name = "my_monitor", uvm_component parent = null);
      super.new(name, parent);
   endfunction
   
   virtual function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if(!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
         `uvm_fatal("my_monitor", "virtual interface must be set for vif!!!")
      ap = new("ap", this);
   endfunction

   extern task main_phase(uvm_phase phase);
   extern task collect_one_pkt(my_transaction tr);
endclass

task my_monitor::main_phase(uvm_phase phase);
   my_transaction tr;
   tr = new("tr");
   forever begin
      if(dut_out==1'b1) begin
         if(vif.valid_o) begin
            tr = new("i_item");
            tr.valid_i  = vif.valid_i;
            $cast(tr.op_type, vif.op_type);
            //tr.op_type = vif.op_type;
            tr.src_0    = vif.src_0;  
            tr.src_1    = vif.src_1;  
            tr.valid_o  = vif.valid_o;
            tr.taken    = vif.taken;
            tr.sum      = vif.sum;
            ap.write(tr);
            @(posedge vif.clk);
         end
      end
      else begin
         if(vif.valid_i) begin
            tr = new("i_item");
            tr.valid_i  = vif.valid_i;
            $cast(tr.op_type, vif.op_type);
            tr.src_0    = vif.src_0;  
            tr.src_1    = vif.src_1;  
            tr.valid_o  = vif.valid_o;
            tr.taken    = vif.taken;
            tr.sum      = vif.sum;
            ap.write(tr);
            @(posedge vif.clk);
         end
      end
      @(posedge vif.clk);
   end

endtask
