class alu_cmd_env extends uvm_env;
    `uvm_component_utils(alu_cmd_env)
    alu_cmd_agent agt;
    virtual alu_cmd_if alu_if;

    function new(input string name = "alu_cmd_env",uvm_component parent = null);
        super.new(name,parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        agt = alu_cmd_agent::type_id::create("agt",this);
        
        if(!uvm_config_db#(virtual alu_cmd_if)::get(this, "", "alu_if", alu_if)) begin
            `uvm_fatal("ALU/AGT/VIF","No Virtual inteface specified for this env instance")
        end
        uvm_config_db#(virtual alu_cmd_if)::set(this, "agt", "alu_if",alu_if);
    endfunction:build_phase

endclass:alu_cmd_env

