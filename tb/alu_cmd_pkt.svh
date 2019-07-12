class alu_cmd_pkt extends uvm_sequence_item;
    rand bit                i_en        ;
    rand bit [I_BW-1:0]     i_cmd       ;
    rand bit [D_BW-1:0]     i_da        ;
    rand bit [D_BW-1:0]     i_db        ;

    `uvm_object_utils_begin(alu_cmd_pkt)
        `uvm_field_int(i_en ,UVM_ALL_ON)
        `uvm_field_int(i_cmd,UVM_ALL_ON)
        `uvm_field_int(i_da ,UVM_ALL_ON)
        `uvm_field_int(i_db ,UVM_ALL_ON)
    `uvm_object_utils_end

    //constructor 
    function new(string name ="alu_cmd_pkt");
        super.new(name);
    endfunction:new

    constraint c_i_cmd {i_cmd >=0; i_cmd <=8;}
endclass:alu_cmd_pkt
