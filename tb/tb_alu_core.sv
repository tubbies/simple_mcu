`include "uvm_macros.svh"
import uvm_pkg::*;
// refer http://www.edaplayground.com/x/296 and youtube video https://www.youtube.com/watch?v=Qn6SvG-Kya0
module tb_alu_core;
//clock
/*{{{*/ // clock / reset generation
reg                         clk                             ;// System clock
reg                         rst_n                           ;// System reset
reg                         apb_clk                         ;// apb clock
reg                         rst_apb_n                       ;// apb reset

initial begin:p_sys_clk_gen
    clk     =   1'b1;
    while (1) begin #2  clk = ~clk; end
end // end of p_sys_clk_gen

initial begin:p_apb_clk_gen
    apb_clk =   1'b1;
    while (1) begin #3 apb_clk = ~apb_clk; end
end // end of p_apb_clk_gen

initial begin:p_sys_rst_gen
    rst_n   =   1'b0;
    repeat(1000) @(posedge clk);
    rst_n   =   1'b1;
end // end of p_sys_rst_gen

initial begin:p_apb_rst_n
    rst_apb_n   =   1'b0;
    repeat(800) @(posedge apb_clk);
    rst_apb_n   =   1'b1;
end // end of p_apb_rst_n
/*}}}*/
/*{{{*/ // init / start generation
reg                         init                            ;
reg                         start                           ;
initial begin:p_init_gen
    init    =   1'b0;
    repeat(1000) @(posedge clk);
    init    =   1'b1;
    repeat(5   ) @(posedge clk);
    init    =   1'b0;
end // end of p_init_gen
initial begin:p_start_gen
    start   =   1'b0;
    repeat(1010) @(posedge clk);
    start   =   1'b1;
    repeat(1   ) @(posedge clk);
    start   =   1'b0;
end // end of p_start_gen
/*}}}*/
//end of clock
localparam  D_BW    =   8   ;
localparam  I_BW    =   4   ;

alu_core_if #(.I_BW(I_BW), .D_BW(D_BW)) alu_if();

// sequence_item
class alu_core_item extends uvm_sequence_item;
    rand bit                    inp_en  ;
    rand bit    [   I_BW-1:0]   inp_cmd ;
    rand bit    [   D_BW-1:0]   inp_da  ;
    rand bit    [   D_BW-1:0]   inp_db  ;
    function new (string name = "alu_core_item");
        super.new(name);
    endfunction
    `uvm_object_utils_begin(alu_core_item)
        `uvm_field_int(inp_en , UVM_ALL_ON)
        `uvm_field_int(inp_cmd, UVM_ALL_ON)
        `uvm_field_int(inp_da , UVM_ALL_ON)
        `uvm_field_int(inp_db , UVM_ALL_ON)
    `uvm_object_utils_end
endclass: alu_core_item

// Sequence
class alu_core_sequence extends uvm_sequence #(alu_core_item);
    `uvm_object_utils(alu_core_sequence)
    function new (string name = "");
        super.new(name);
    endfunction

    task body();
        alu_core_item ac_item;

        // repeat(15) begin
        forever begin
            ac_item = alu_core_item::type_id::create("req");
            start_item(ac_item);

            if(!ac_item.randomize()) begin
                `uvm_error("ac_item", "Randomize failed.");
            end
            finish_item(ac_item);
        end
    endtask: body
endclass: alu_core_sequence
// Driver
class alu_core_driver extends uvm_driver#(alu_core_item);
    `uvm_component_utils(alu_core_driver)
    protected virtual alu_core_if #(.I_BW(I_BW), .D_BW(D_BW)) alu_if;

    function new(string name="alu_core_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual alu_core_if #(.I_BW(I_BW), .D_BW(D_BW)))::get(this, "", "alu_core_vif", alu_if)) begin
            `uvm_error("", "uvm_config_db::get failed");
        end
        // void'(uvm_resource_db#(virtual alu_core_if)::read_by_name
        //      (.scope("ifs"), .name("alu_core_if"), .val(alu_if)));
    endfunction

    task run_phase(uvm_phase phase);
        alu_core_item ac_item;

        forever begin
            seq_item_port.get_next_item(ac_item);
            drive_item(ac_item);
            @(posedge clk);
            seq_item_port.item_done();
        end
    endtask
    
    task drive_item(input alu_core_item ac_item);
        if(~rst_n) begin
            alu_if.i_en  = 1'b0;
            alu_if.i_cmd = {I_BW{1'b0}};
            alu_if.i_da  = {D_BW{1'b0}};
            alu_if.i_db  = {D_BW{1'b0}};
        end
        else begin
            alu_if.i_en  = ac_item.inp_en ;
            alu_if.i_cmd = ac_item.inp_cmd;
            alu_if.i_da  = ac_item.inp_da ;
            alu_if.i_db  = ac_item.inp_db ;
        end
    endtask
endclass: alu_core_driver



typedef uvm_sequencer #(alu_core_item) alu_core_sequencer;

// agent
class alu_core_agent extends uvm_agent;
    `uvm_component_utils(alu_core_agent)
    alu_core_driver     alu_core_drvr;
    alu_core_sequencer  alu_core_seqr;

    function new(string name = "alu_core_agent", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        alu_core_drvr  = alu_core_driver::type_id::create(.name("alu_core_drvr"), .parent(this));
        alu_core_seqr  = alu_core_sequencer::type_id::create(.name("alu_core_seqr"), .parent(this));
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase); //
        alu_core_drvr.seq_item_port.connect(alu_core_seqr.seq_item_export);
    endfunction

    task run_phase(uvm_phase phase);
        alu_core_sequence ac_seq;

        phase.raise_objection(this);
        begin
            ac_seq = alu_core_sequence::type_id::create(.name("seq"));
            ac_seq.start(alu_core_seqr);
        end
        phase.drop_objection(this);
    endtask
endclass

// env
class alu_core_env extends uvm_env;
    `uvm_component_utils(alu_core_env)

    alu_core_agent ac_agent;

    function new(string name = "alu_core_seq", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ac_agent = alu_core_agent::type_id::create(.name("ac_agent"), .parent(this));
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction
endclass

// Test
class alu_core_test extends uvm_test;
    `uvm_component_utils(alu_core_test)

    alu_core_env ac_env;

    function new(string name = "alu_core_test", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ac_env = alu_core_env::type_id::create(.name("ac_env"), .parent(this));
    endfunction

    task run_phase(uvm_phase phase);
        alu_core_sequence ac_seq;
        phase.raise_objection(.obj(this));
        phase.drop_objection (.obj(this));
    endtask
endclass: alu_core_test

initial begin
    uvm_config_db #(virtual alu_core_if #(.I_BW(I_BW), .D_BW(D_BW)))::set(null, "*", "alu_core_vif",alu_if);
    run_test("alu_core_test");
end


wire                             o_en                    ;// output data enable
wire                             o_of                    ;// output overflow flag
wire                             o_ofb                   ;// output overflow bit
wire [   D_BW    -1:0]           o_dat                   ;// output data

alu_core #(.D_BW(D_BW), .I_BW(I_BW)) DUT
(/*{{{*/
.clk        (clk                ),
.rst_n      (rst_n              ),

.i_en       (alu_if.i_en        ),
.i_cmd      (alu_if.i_cmd       ),
.i_da       (alu_if.i_da        ),
.i_db       (alu_if.i_db        ),

.o_en       (o_en               ),
.o_of       (o_of               ),
.o_ofb      (o_ofb              ),
.o_dat      (o_dat              ) 
);/*}}}*/    
endmodule    
