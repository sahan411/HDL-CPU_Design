module CPU (
    input wire clk,
    input wire reset
);
	// These wires are connected to other components of the CPU
    wire [15:0] pc_in, pc_out;
    wire [15:0] instruction; // from instruction memory
    wire [3:0] opcode; // opcode from instruction
    wire [2:0] reg1, reg2, write_reg;
    wire [15:0] immediate;
    wire [2:0] alu_op;
    wire [15:0] read_data1, read_data2, alu_result, mem_data;
    wire reg_write, mem_read, mem_write, jump, zero_flag; // control signals

    // Keep track of the current instruction address and increment or load new address
    ProgramCounter PC (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in),
        .pc_write_enable(1'b1), 
        .pc_out(pc_out)
    );

    // fetch instruction at current pc_out address
    InstructionMemory IM (
        .address(pc_out),
        .instruction(instruction)
    );

	 // Decode instruction fields
    assign opcode = instruction[15:12];     // type of the operation - 4 bit
    assign reg1 = instruction[11:9];        // First operand register - 3 bit
    assign reg2 = instruction[8:6];         // Second operand register - 3 bit
    assign write_reg = instruction[5:3];    // Destination register - 3 bit
    assign immediate = instruction[7:0];    

    // Instantiate Control Unit
    ControlUnit CU (
        .opcode(opcode),
        .regWrite(reg_write), // for register write
        .memRead(mem_read), // for memory read
        .memWrite(mem_write), // for memory write
        .aluOp(alu_op),
        .jump(jump)
    );

    // Instantiate Register File
    RegisterFile RF (
        .clk(clk),
        .read_reg1(reg1),
        .read_reg2(reg2),
        .write_reg(write_reg),
        .write_data(mem_data),   // write from DataMemory
        .reg_write(reg_write),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

	// ALU operation based on aluOp signal
    ALU ALU (
        .A(read_data1),
        .B(read_data2),
        .ALUOp(alu_op), // operation code
        .Result(alu_result),
        .Zero(zero_flag)
    );

    // Instantiate Data Memory
    DataMemory DM (
        .address(alu_result[7:0]), // lower 8 bits of ALU result
        .writeData(read_data2),    // Write the data from second register
        .memRead(mem_read),
        .memWrite(mem_write),
        .readData(mem_data)      
    );

    // update pc jump or increment
    assign pc_in = (jump) ? immediate : pc_out + 1;

endmodule
