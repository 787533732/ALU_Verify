class my_scoreboard extends uvm_scoreboard;

      my_transaction expect_queue[$];//rfmodel结果存放的队列
      my_transaction actual_queue[$];//dut结果存放的队列
      uvm_blocking_get_port #(my_transaction)  exp_port;
      uvm_blocking_get_port #(my_transaction)  act_port;
     
      extern function new(string name, uvm_component parent = null);
      extern virtual function void build_phase(uvm_phase phase);
    //  extern virtual task reset_phase(uvm_phase phase);
      extern virtual task main_phase(uvm_phase phase);
      `uvm_component_utils(my_scoreboard)

endclass 

function my_scoreboard::new(string name, uvm_component parent = null);
   super.new(name, parent);
endfunction 

function void my_scoreboard::build_phase(uvm_phase phase);
   super.build_phase(phase);
   exp_port = new("exp_port", this);
   act_port = new("act_port", this);
endfunction 

task my_scoreboard::main_phase(uvm_phase phase);
   my_transaction  get_expect,  get_actual, temp_expect, temp_actual;
   int comp_item_num;
   super.main_phase(phase);
   forever begin
      exp_port.get(get_expect);
      expect_queue.push_back(get_expect);
      `uvm_info("my_scoreboard", "get_expect", UVM_LOW);
      act_port.get(get_actual);
      actual_queue.push_back(get_actual);
      `uvm_info("my_scoreboard", "get_actual", UVM_LOW);
      comp_item_num = (actual_queue.size()> expect_queue.size())? (expect_queue.size()) : (actual_queue.size());
      for(int i=0; i< comp_item_num;i++) begin
      
         temp_expect = expect_queue.pop_front();
         temp_actual = actual_queue.pop_front();
         if((temp_expect.src_0==temp_actual.src_0)&&(temp_expect.src_1==temp_actual.src_1)) begin
               if((temp_actual.op_type==4'b1010) || (temp_actual.op_type==4'b1011)||(temp_actual.op_type==4'b1100)
               ||(temp_actual.op_type==4'b1101)|| (temp_actual.op_type==4'b1110)||(temp_actual.op_type==4'b1111))begin
                  if(temp_expect.taken==temp_actual.taken) begin
                     `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);

                  end
                  else begin
                     `uvm_error("my_scoreboard", "Compare FAILED");
                     $display("the expect pkt is");
                     temp_expect.print();
                     $display("the actual pkt is");
                     temp_actual.print();
                  end
               end
               else if(temp_expect.sum == temp_actual.sum) begin
                  `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
               end
               else begin
                  `uvm_error("my_scoreboard", "Compare FAILED");
                  $display("the expect pkt is");
                  temp_expect.print();
                  $display("the actual pkt is");
                  temp_actual.print();
               end
         end
      end
   end
 /*  
      if(expect_queue.size() > 0) begin
         tmp_tran = expect_queue.pop_front();
         result = get_actual.compare(tmp_tran);
         if(result) begin 
            `uvm_info("my_scoreboard", "Compare SUCCESSFULLY", UVM_LOW);
            $display("the expect pkt is");
            tmp_tran.print();
            $display("the actual pkt is");
            get_actual.print();
            match_counter++;
         end
         else begin
            `uvm_error("my_scoreboard", "Compare FAILED");
            $display("the expect pkt is");
            tmp_tran.print();
            $display("the actual pkt is");
            get_actual.print();
            mismatch_counter++;
         end
      end
      else begin
         `uvm_error("my_scoreboard", "Received from DUT, while Expect Queue is empty");
         $display("the unexpected pkt is");
         get_actual.print();
      end */

endtask