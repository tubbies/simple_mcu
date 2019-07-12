class alu_cmd_seqs extends uvm_sequencer #(alu_cmd_pkt);
    `uvm_component_utils(alu_cmd_seqs)
    function new(input string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction:new
endclass:alu_cmd_seqs
