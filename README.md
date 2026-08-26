# Digital Voting Machine with Secure Memory

A robust, fault-tolerant hardware design for an Electronic Voting Machine (EVM) implemented in SystemVerilog/Verilog, featuring secure non-volatile memory integration, switch debouncing, and finite state machine (FSM) control logic.

## Project Guidelines & Features
* **FSM-Based Vote Counting:** State machine logic controlling operational phases (`IDLE`, `VOTING`, `STORE_EEPROM`, and `DISPLAY_RESULTS`).
* **Secure Data Storage:** Non-volatile memory integration (I2C/SPI EEPROM module) for persistent, tamper-resistant vote tallies.
* **Hardware Debouncing:** Built-in debounce logic to eliminate mechanical contact noise on tactile voting switches.
* **Visual Display Interface:** Output drivers configured for 7-Segment Displays / LCD output modules.

## Module Breakdown
* `rtl/evm_fsm.sv`: Main controller managing state transitions and vote validation.
* `rtl/button_debouncer.sv`: Switch debouncing circuit using clock dividers and shift registers.
* `rtl/eeprom_controller.sv`: SPI/I2C protocol interface to write/read vote counts from secure memory.
* `rtl/display_driver.sv`: BCD to 7-Segment / LCD driver logic.
* `tb/tb_evm_top.sv`: Verification testbench simulating push-button inputs and memory writes.

## System Workflow
1. **Button Input:** Tactile switches pass through the debouncer module to prevent multi-triggering.
2. **State Transition:** FSM verifies voter eligibility flag, transitions to `VOTING` state, and increments the candidate register.
3. **Secure Write:** FSM triggers the EEPROM driver to store updated vote totals in non-volatile memory.
4. **Display Output:** Results are decoded and routed to 7-segment displays/LCD modules.

## EDA Tools & Simulation
* **Language:** SystemVerilog / Verilog HDL
* **Simulation:** ModelSim / Icarus Verilog / Xilinx Vivado
* **Waveform Analysis:** GTKWave

