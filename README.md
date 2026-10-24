# FPGA-Based Full-Duplex Chat System

A modular UART chat system designed in Verilog HDL for two Real Digital Boolean FPGA boards connected to two laptops. This repository combines the supplied project documentation with reconstructed RTL for modules whose original source files were missing.

> **Important:** Reconstructed modules are a fresh implementation based on the supplied interface specifications, not recovered original source. Simulate and validate the design in your Vivado version and on the actual board before relying on it.

## Features

- UART transmit and receive (8-N-1 framing, LSB first)
- Nominal 115200 baud from a 100 MHz clock
- 16-entry, 8-bit RX and TX FIFO buffers
- Control FSM to forward received bytes to the transmitter
- Modular RTL and a self-checking UART transmitter testbench
- Real Digital Boolean FPGA hardware reference

## Architecture

```text
Laptop A <-> FPGA A <==== UART link / jumper wires ====> FPGA B <-> Laptop B

Each FPGA endpoint:
UART RX -> RX FIFO -> Control FSM -> TX FIFO -> UART TX
```

## Design parameters

| Parameter | Value |
|---|---|
| FPGA board | Real Digital Boolean ([board information](https://www.realdigital.org/hardware/boolean)) |
| HDL | Verilog HDL |
| System clock | 100 MHz (documented design assumption) |
| UART baud rate | 115200 bps |
| UART frame | 1 start, 8 data bits (LSB first), 1 stop |
| FIFO depth | 16 bytes per FIFO |
| Data width | 8 bits |
| FPGA tool | Vivado (project material references Vivado 2025.2) |

The divider estimate is 100,000,000 / 115,200 ≈ 868.055. The reconstructed UART modules use 868 clocks per bit; confirm the resulting baud error and timing on the target system.

## Repository layout

- `rtl/` — baud generator, UART TX/RX, FIFO, controller FSM, top module
- `testbench/` — UART TX simulation testbench
- `docs/` — architecture and verification notes
- `constraints/` — placeholder for verified board-specific XDC constraints
- `images/` — add hardware photos, diagrams, and screenshots
- `results/` — add simulation and hardware test evidence

## Run a simulation

Using Vivado: create/open a project for the Boolean board, add all files in `rtl/`, add `testbench/uart_tx_tb.v` as a simulation source, set `uart_tx_tb` as simulation top, and run behavioral simulation. The testbench uses a reduced clock divider to keep simulation fast.

No board-specific XDC file has been reconstructed because the exact board pin mapping and wiring must be verified rather than guessed. The physical two-board chat demonstration also requires correct TX-to-RX wiring, common ground, appropriate I/O voltage levels, and host serial configuration.

## Documentation basis

The project overview and module intent are based on the supplied 19-page presentation and the TX, RX, FIFO, Control FSM, Baud Generator, and Top Module interface-specification PDFs. The RTL in this repository is reconstructed and should be treated as unverified until simulation and hardware checks are repeated.

## Contributors

The supplied presentation lists Siddharth, Aravind, Aldrin, and Adhil. Add full names and contributions with the team's approval.

## License

No license has been selected. Agree on terms with all project contributors before adding one.
