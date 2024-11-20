class my_sequencer extends uvm_sequencer #(my_transaction);

    function new(string name="my_sequencer", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("my_sqr", "new is called", UVM_LOW);
    endfunction 

    `uvm_component_utils(my_sequencer)
    
endclass 