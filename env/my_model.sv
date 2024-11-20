class my_model extends uvm_component;
   
   uvm_blocking_get_port #(my_transaction)  port;
   uvm_analysis_port #(my_transaction)  ap;
   int unsigned mui_item_count;
   extern function new(string name, uvm_component parent);
   extern function void build_phase(uvm_phase phase);
   extern virtual  task main_phase(uvm_phase phase);

   `uvm_component_utils(my_model)

endclass 

function my_model::new(string name, uvm_component parent);
   super.new(name, parent);
   mui_item_count = 0;
endfunction 

function void my_model::build_phase(uvm_phase phase);
   super.build_phase(phase);
   port = new("port", this);
   ap = new("ap", this);
endfunction

task my_model::main_phase(uvm_phase phase);
    my_transaction tr;
    super.main_phase(phase);
   
    forever begin
        port.get(tr);
        `uvm_info(get_full_name(), "my_model get transaction from i_mon, print it:", UVM_LOW)
        tr.print();
            if(tr.valid_i == 1'b1) begin
                case(tr.op_type)
                    4'b0000 : begin//add
                        tr.sum = tr.src_0 + tr.src_1;
                        tr.valid_o = 1'b1;
                        end
                    4'b0001 : begin//sub
                        tr.sum = tr.src_0 - tr.src_1;
                        tr.valid_o = 1'b1;
                    end
                    4'b0010 : begin//sll
                        tr.sum = tr.src_0 << tr.src_1[4:0];
                        tr.valid_o = 1'b1;
                    end
                    4'b0011 : begin//slt
                        tr.sum = ($signed(tr.src_0) < $signed(tr.src_1)) ? {{31'b0}, 1'b1} : 32'b0;
                        tr.valid_o = 1'b1;
                    end
                    4'b0100 : begin//sltu
                        tr.sum = (tr.src_0 < tr.src_1) ? {{31'b0}, 1'b1} : 32'b0;
                        tr.valid_o = 1'b1;
                    end
                    4'b0101 : begin//xor
                        tr.sum = tr.src_0 ^ tr.src_1;
                        tr.valid_o = 1'b1;
                    end
                    4'b0110 : begin//srl
                        tr.sum = tr.src_0 >> tr.src_1[4:0];
                        tr.valid_o = 1'b1;
                    end
                    4'b0111 : begin//sra
                        tr.sum = $signed(tr.src_0) >>> tr.src_1[4:0];
                        tr.valid_o = 1'b1;
                    end
                    4'b1000 : begin//or
                        tr.sum = tr.src_0 | tr.src_1;
                        tr.valid_o = 1'b1;
                    end
                    4'b1001 : begin//and
                        tr.sum = tr.src_0 & tr.src_1;
                        tr.valid_o = 1'b1;
                    end
                    4'b1010 : begin//beq
                        tr.taken = (tr.src_0 == tr.src_1)? 1'b1: 1'b0;
                        tr.valid_o = 1'b1;
                    end
                    4'b1011 : begin//bne
                        tr.taken = (tr.src_0 != tr.src_1)? 1'b1: 1'b0;
                        tr.valid_o = 1'b1;
                    end
                    4'b1100 : begin//blt
                        tr.taken = ($signed(tr.src_0) < $signed(tr.src_1))? 1'b1: 1'b0;
                        tr.valid_o = 1'b1;
                    end  
                    4'b1101 : begin//bge
                        tr.taken = ($signed(tr.src_0) >= $signed(tr.src_1))? 1'b1: 1'b0;
                        tr.valid_o = 1'b1;
                    end
                    4'b1110 : begin//bltu
                        tr.taken = (tr.src_0 < tr.src_1)? 1'b1: 1'b0;
                        tr.valid_o = 1'b1;
                    end
                    4'b1111 : begin//bgeu
                        tr.taken = (tr.src_0 >= tr.src_1)? 1'b1: 1'b0;
                        tr.valid_o = 1'b1;
                    end
                endcase
       `uvm_info(get_full_name(), "my_model predict transaction, print it:", UVM_LOW)
        tr.print();
        mui_item_count++;
        ap.write(tr);  
        end
    end
endtask