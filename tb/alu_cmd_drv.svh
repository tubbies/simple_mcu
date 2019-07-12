class alu_cmd_drv extends uvm_driver#(alu_cmd_pkt);
    `uvm_component_utils(alu_cmd_drv)
    virtual alu_cmd_if alu_if;

    function new(string name="alu_core_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_cmd_if)::get(this, "", "alu_if", alu_if)) begin
            `uvm_error("", "uvm_config_db::get failed");
        end
        // void'(uvm_resource_db#(virtual alu_core_if)::read_by_name
        //      (.scope("ifs"), .name("alu_core_if"), .val(alu_if)));
    endfunction

    task run_phase(uvm_phase phase);
        alu_cmd_pkt alu_pkt;

        forever begin
            seq_item_port.get_next_item(alu_pkt);
            drive_item(alu_pkt);
            @(posedge alu_if.clk);
            seq_item_port.item_done();
        end
    endtask
    
    task drive_item(input alu_cmd_pkt alu_pkt);
        if(~alu_if.rst_n) begin
            alu_if.i_en  = 1'b0;
            alu_if.i_cmd = {I_BW{1'b0}};
            alu_if.i_da  = {D_BW{1'b0}};
            alu_if.i_db  = {D_BW{1'b0}};
        end
        else begin
            alu_if.i_en  = alu_pkt.i_en ;
            alu_if.i_cmd = alu_pkt.i_cmd;
            alu_if.i_da  = alu_pkt.i_da ;
            alu_if.i_db  = alu_pkt.i_db ;
        end
    endtask
endclass: alu_cmd_drv
