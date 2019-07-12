class alu_cmd_cfg extends uvm_object;
    `uvm_object_utils(alu_cmd_cfg)
    virtual alu_cmd_if #(.I_BW(I_BW), .D_BW(D_BW)) alu_cmd;

    function new(input string name="alu_cmd_cfg");
        super.new(name);
    endfunction
endclass:alu_cmd_cfg
