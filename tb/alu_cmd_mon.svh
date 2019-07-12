class alu_cmd_mon extends uvm_monitor;
    `uvm_object_utils(alu_cmd_mon)

    function new(input string name ="alu_cmd_mon", uvm_component parent =null);
        super.new(name,parent);
    endfunction:new
endclass:alu_cmd_mon
