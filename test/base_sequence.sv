class base_sequence extends uvm_sequence #(my_transaction);

    my_transaction m_trans;
    `uvm_object_utils(base_sequence)
    function new(string name="base_sequence");
        super.new(name);

    endfunction 
    //控制phase的开始和结束
    task pre_body();
        begin
            if(starting_phase != null) begin
                starting_phase.raise_objection(this);
            end
        end
    endtask

    task post_body();
        begin
            if(starting_phase != null) begin
                starting_phase.drop_objection(this);
            end
        end
    endtask

endclass