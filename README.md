# Simple CPU Design with Verilog HDL

## Overview
This project implements a basic CPU using Verilog HDL with a limited instruction set: load, store, add, and subtract operations. The design includes the following modules:
- **Program Counter (PC)**: Holds the address of the instruction to fetch.
- **Instruction Memory**: Stores the instructions that the CPU fetches.
- **Register File**: Holds registers for storing values.
- **ALU (Arithmetic Logic Unit)**: Performs arithmetic and logic operations.
- **Control Unit**: Decodes instructions and generates control signals.
- **Data Memory**: Stores data for load/store operations.
- **CPU**: Integrates all the components and executes instructions.

The CPU follows a simple instruction pipeline with three main stages: **Fetch**, **Decode**, and **Execute**.
