class alu_cmd_agent extends uvm_agent;
    alu_cmd_seqs seqs;
    alu_cmd_drv  drv ;
    alu_cmd_mon  mon ;

    virtual alu_cmd_if alu_if;

    `uvm_component_utils_begin(alu_cmd_agent)
        `uvm_field_object(seqs,UVM_ALL_ON)
        `uvm_field_object(drv ,UVM_ALL_ON)
        `uvm_field_object(mon ,UVM_ALL_ON)
    `uvm_component_utils_end

    function new(input string name = "alu_cmd_agent", uvm_component parent = null);
        super.new(name,parent);
    endfunction:new

    virtual function void build_phase(uvm_phase phase);
        seqs = alu_cmd_seqs::type_id::create("seqs",this);
        drv  = alu_cmd_drv ::type_id::create("drv" ,this);
        mon  = alu_cmd_mon ::type_id::create("mon", this);

        if (!uvm_config_db#(virtual alu_cmd_if)::get(this, "", "alu_if", alu_if)) begin
         `uvm_fatal("ALU_CMD/AGT/NOVIF", "No virtual interface specified for this agent instance")
        end
        uvm_config_db#(virtual alu_cmd_if)::set( this, "seqs", "alu_if", alu_if);
        uvm_config_db#(virtual alu_cmd_if)::set( this, "drv" , "alu_if", alu_if);
        uvm_config_db#(virtual alu_cmd_if)::set( this, "mon" , "alu_if", alu_if);
    endfunction:build_phase

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); 
        drv.seq_item_port.connect(seqs.seq_item_export);
    endfunction:connect_phase



endclass:alu_cmd_agent
