class alu_res_mon extends uvm_monitor;

    virtual alu_res_if alu_if;

    uvm_analysis_port #(alu_res_pkt) ap;
    `uvm_component_utils(alu_res_mon)
    function new(input string name="alu_res_mon", uvm_component parent = null);
        super.new(name,parent);
        ap = new("ap",this);
    endfunction:new

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (! uvm_config_db #(virtual alu_res_if) :: get (this, "", "alu_if", alu_if)) begin
         `uvm_error (get_type_name (), "DUT interface not found")
      end
    endfunction: build_phase


endclass:alu_res_mon
