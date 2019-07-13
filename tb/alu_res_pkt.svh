class alu_res_pkt extends uvm_sequence_item;
    rand bit                o_en        ;
    rand bit                o_of        ;
    rand bit                o_ofb       ;
    rand bit [D_BW-1:0]     o_dat       ;

    `uvm_object_utils(alu_res_pkt)

    function  new(input string name="alu_res_pkt");
        super.new(name);
    endfunction:new

endclass:alu_res_pkt
