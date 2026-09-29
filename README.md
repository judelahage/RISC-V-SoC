<h1 align="center">RISC-V Processor & SoC</h1>

<p align="center">
  A 32-bit <b>RV32I</b> RISC-V processor core and System-on-Chip (SoC) designed from scratch in <b>Verilog</b> for a <b>Xilinx FPGA</b>.
</p>

---

## Overview

This project implements a 32-bit RISC-V (RV32I) processor core in Verilog using Xilinx Vivado. The processor is designed to execute standard RISC-V machine instructions and interface with memory-mapped peripherals (GPIO, UART, and a custom CAN controller) to run compiled C firmware and communicate with physical hardware.

## Architecture & Subsystems

The core implements the RV32I base integer instruction set with modular hardware blocks:

| Subsystem | Source File | Description |
|---|---|---|
| **Register File** | `regfile.v` | 32 × 32-bit general-purpose registers, two asynchronous read ports, one synchronous write port, `x0` hardwired to zero |
| **Program Counter** | `PCreg.v` | Synchronous 32-bit PC register with synchronous reset and next-PC calculation |
| **Instruction Memory** | `imem.v` | Read-only memory storing assembled RV32I machine instructions |
| **Instruction Decoder** | `instr_decoder.v` | Deconstructs 32-bit instructions into opcode, rd, rs1, rs2, funct3, funct7, and generates sign-extended immediates (I, S, B, U, J types) |
| **ALU** | `alu.v` | 32-bit arithmetic and logic unit supporting ADD, SUB, AND, OR, XOR, SLT, SLTU, SLL, SRL, and SRA with zero/comparison flags |
| **Control Unit** | `control_unit.v` | Main opcode decoding and ALU control generating control signals for the datapath |

## Project Roadmap

- [x] **Phase 1: RV32I Core Datapath** — Register file, PC, instruction memory, instruction decoder, ALU, and control unit.
- [ ] **Phase 2: Memory & GPIO** — FPGA Block RAM integration and memory-mapped GPIO (switches, buttons, LEDs).
- [ ] **Phase 3: Serial Communication** — Memory-mapped UART peripheral for bidirectional terminal interaction.
- [ ] **Phase 4: Toolchain & Firmware** — Bare-metal C runtime, linker script, and RISC-V GCC cross-compilation.
- [ ] **Phase 5: Custom CAN Controller** — Industrial CAN bus protocol engine (bit timing, CRC-15, arbitration) for multi-node sensor telemetry.
- [ ] **Phase 6: Traps & FreeRTOS** — Machine-mode CSRs (`mstatus`, `mepc`, `mtvec`, `mcause`), timer interrupts, and FreeRTOS porting.

## Tools & Requirements

- **HDL:** Verilog (IEEE 1364-2001)
- **EDA Tool:** AMD / Xilinx Vivado
- **Target Platform:** Xilinx Artix-7 FPGA
