`timescale 1ns / 1ps

module CPU_tb;
    reg clk;
    reg reset;

    CPU cpu (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk; // Generate a clock 10ns period

    initial begin
        clk = 0;
        reset = 1;

        #10 reset = 0;

        #1000;

        $stop;
    end

	initial begin
        
        cpu.IM.memory[0] = 16'b0000000000000001;  // ADD
        cpu.IM.memory[1] = 16'b0001000000000010;  // SUB
        cpu.IM.memory[2] = 16'b0010000000000100;  // LOAD
        cpu.IM.memory[3] = 16'b0011000000000101;  // STORE
        cpu.IM.memory[4] = 16'b0100000000000000;  // JUMP to address 0

        // set up initial data in registers or memory if needed
        cpu.RF.registers[1] = 16'd10; // Set Reg[1] = 10
        cpu.RF.registers[2] = 16'd5;  // Set Reg[2] = 5
        cpu.RF.registers[3] = 16'd3;  // Set Reg[3] = 3
        cpu.RF.registers[5] = 16'd15; // Set Reg[5] = 15
        cpu.DM.memory[1] = 16'd100;   // Set DataMemory at address 1 to 100

        $monitor("Time=%0t PC=%h, Instruction=%h, Reg[0]=%h, Reg[4]=%h, DataMem[1]=%h",
                 $time, cpu.PC.pc_out, cpu.IM.instruction, cpu.RF.registers[0], cpu.RF.registers[4], cpu.DM.memory[1]);
    end
endmodule
