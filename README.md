#  DSP48A1 Verilog Design and Verification

## Overview
This project implements and verifies a **DSP48A1** module — a parameterized **Digital Signal Processing (DSP) block** inspired by Xilinx FPGA primitives.  
The design supports **configurable pipelining**, **carry handling**, **multiplier-accumulator (MAC)** operations, and **arithmetic logic** control through an **8-bit OPMODE** input.

---

##  Features
- **Parameterizable pipeline registers** for each stage (A, B, C, D, M, P, etc.)
- **Configurable reset type:** `SYNC` or `ASYNC`
- **Selectable carry-in source:** `CARRYIN`, `OPMODE5`, or constant `0`
- **B-input source control:** `DIRECT` or `CASCADE`
- **Supports arithmetic and multiply-accumulate operations**
- **Self-checking testbench** with multiple test paths

---

##  Main Module: `DSP48A1.v`

### Parameters
| Parameter | Description | Default |
|------------|-------------|----------|
| `A0REG, A1REG, B0REG, B1REG, ...` | Enables pipeline registers for each stage | 0 or 1 |
| `CARRYINSEL` | Carry input source (`"CARRYIN"`, `"OPMODE5"`) | `"OPMODE5"` |
| `B_INPUT` | Source of B input (`"DIRECT"` or `"CASCADE"`) | `"DIRECT"` |
| `RSTTYPE` | Reset behavior (`"SYNC"` or `"ASYNC"`) | `"SYNC"` |

### Ports
- **Inputs:** `A`, `B`, `C`, `D`, `CARRYIN`, `CLK`, enable and reset signals, `OPMODE`
- **Outputs:** `M`, `P`, `BCOUT`, `PCOUT`, `CARRYOUT`, `CARRYOUTF`

---

##  Testbench: `DSP48A1_tb.v`
The testbench verifies the DSP48A1 functionality using **four functional paths**:
1. **Reset test** — ensures outputs are cleared properly.  
2. **Path 1–4 functional tests** — check arithmetic and multiplication paths based on `OPMODE`.

Each test compares the DUT outputs against **expected values** and reports:

reset test passed
path 1 test passed
path 2 test passed
path 3 test passed
path 4 test passed
TEST PASSED :)


If a mismatch occurs, simulation halts and displays an error message.

---

## Simulation Instructions

###  Using ModelSim / QuestaSim
1. Open **ModelSim/QuestaSim**.
2. Run the `run.do` script:
   ```tcl
   vlib work
   vlog reg_mux_stage.v DSP48A1.v DSP48A1_tb.v
   vsim -voptargs=+acc work.DSP48A1_tb
   add wave *
   run -all


Author

Sameh Mohammed
