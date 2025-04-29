# Pipelined-RISC-V-Processor
## Overview
This project implements femtoRV32, a simplified RISC-V RV32I processor for FPGA deployment on the Nexys A7 platform. The processor supports the RV32I base integer instruction set, incorporates pipelining with hazard management, and is tested both through simulation and directly on FPGA hardware.

## Features
- Full implementation of the **RV32I base instruction set** (42 user-level instructions).
- **5-stage pipelined architecture** with hazard detection and data forwarding.
- **Single-port memory** model with structural hazard handling.
- **Simple branch prediction** (static) for control hazard management.
- **Custom test program generator** (C++) for creating random valid instruction sequences.
- **Successful FPGA deployment** and testing using **Nexys A7** board.

## Assumptions
- Byte-addressable, word-aligned memory system.
- Static branch prediction; no dynamic prediction techniques.
- `ECALL` and `EBREAK` instructions are treated as halting or no-op operations.
- Single memory module shared between instructions and data, leading to structural hazards.

## Testing & Validation
- Full simulation of arithmetic, logical, branch, and memory operations.
- FPGA tests verified correct execution flow, hazard management, and performance.
- Test programs automatically generated using the custom C++ instruction generator.

## Authors
- **Saif Abd Elfattah**
- **Adham Ali**

## References
- [RISC-V Specifications](https://riscv.org/technical/specifications/)
- [Nexys A7 FPGA Board Documentation](https://digilent.com/reference/programmable-logic/nexys-a7/start)
