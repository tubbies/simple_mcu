class alu_cmd_seq extends uvm_sequence #(alu_cmd_pkt);
    `uvm_object_utils(alu_cmd_seq)
    function new (string name = "alu_cmd_seq");
        super.new(name);
    endfunction

    task body();
        alu_cmd_pkt alu_cmd;

        repeat(15) begin
        // forever begin
            alu_cmd = alu_cmd_pkt::type_id::create("req");
            start_item(alu_cmd);

            if(!alu_cmd.randomize()) begin
                `uvm_error("alu_cmd", "Randomize failed.");
            end
            finish_item(alu_cmd);
        end
    endtask: body
endclass: alu_cmd_seq
