class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)
    alu_cmd_env env;
    alu_cmd_cfg cfg;
    virtual alu_cmd_if alu_cif;

    function new(string name ="alu_test", uvm_component parent = null);
        super.new(name,parent);
    endfunction:new

    function void build_phase(uvm_phase phase);
        env = alu_cmd_env::type_id::create("env",this);
        cfg = alu_cmd_cfg::type_id::create("cfg",this);

        uvm_config_db#(virtual alu_cmd_if)::set(this, "env", "alu_cif", alu_cif);
    endfunction:build_phase
    task run_phase(uvm_phase phase);
        alu_cmd_seq cmd_seq;
        cmd_seq = alu_cmd_seq::type_id::create("alu_cmd_seq");
        phase.raise_objection(this,"Starting");
        cmd_seq.start(env.agt.seqs);
        #1000ns;
        phase.drop_objection(this, "Finished");
    endtask:run_phase

endclass:alu_test
