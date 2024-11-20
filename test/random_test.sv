class random_sequence extends base_sequence;
   my_transaction m_trans;

   function  new(string name= "random_sequence");
      super.new(name);
   endfunction 
   
   virtual task body();
      repeat(1000) begin           
         m_trans = my_transaction::type_id::create("m_trans");     
         `uvm_info("random_seq", "send one transaction, print it", UVM_LOW)
         start_item(m_trans);
         //随机化
         if(!m_trans.randomize() with {
                                       m_trans.valid_i == 1'b1;
                                       })
         begin
            `uvm_error("body", "req randomization failure")
         end
         finish_item(m_trans);
         m_trans.print();
      end
      #100;
      repeat(100) begin           
         m_trans = my_transaction::type_id::create("m_trans");     
         `uvm_info("random_seq", "send one transaction, print it", UVM_LOW)
         start_item(m_trans);
         if(!m_trans.randomize() with {
                                       m_trans.src_0 == m_trans.src_1;
                                       m_trans.valid_i == 1'b1;
                                       })
         begin
            `uvm_error("body", "req randomization failure")
         end
         finish_item(m_trans);
         m_trans.print();
      end 
   endtask

   `uvm_object_utils(random_sequence)
endclass

class random_test extends base_test;

   function new(string name = "random_test", uvm_component parent = null);
      super.new(name,parent);
   endfunction 
   extern virtual function void build_phase(uvm_phase phase); 
   `uvm_component_utils(random_test)
endclass

function void random_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
   //set this Sequence as Sequencer's main_phase
   uvm_config_db#(uvm_object_wrapper)::set(this, 
                                           "env.i_agt.sqr.main_phase", 
                                           "default_sequence", 
                                           random_sequence::type_id::get());
endfunction