# Interface and Architecture Overview

This note summarizes the supplied presentation and interface-specification PDFs. The RTL in `rtl/` is reconstructed reference code and must be validated.

## Documented system parameters
- 100 MHz system clock
- 115200-bps UART
- 8-bit data, LSB first
- One start bit and one stop bit (8N1)
- FIFO depth of 16 entries
- Real Digital Boolean FPGA board

## Modules
- **baud_gen:** clock divider that generates a one-cycle timing pulse.
- **uart_tx:** parallel-byte to serial UART transmitter; start, eight data, stop.
- **uart_rx:** detects a start bit, samples eight data bits, and reports completed bytes.
- **fifo:** synchronous FIFO with read/write enables and full/empty flags.
- **control_fsm:** transfers received bytes from the RX FIFO into the TX FIFO.
- **top:** integrates receiver, FIFOs, controller, and transmitter.

## Integration note
The supplied interface documents have a few differences between the described connections and module port lists. This reconstruction makes the top-level connection internally consistent and uses independent baud counters in the UART TX/RX modules. The `baud_gen` is included as a reference timing block but its tick is not consumed by these UART modules. Review this design choice before treating the project as a final implementation.

## Verification plan
1. Run `testbench/uart_tx_tb.v` and verify start/data/stop bit behavior.
2. Add UART RX and integrated top-level tests, including back-to-back bytes.
3. Test FIFO full/empty behavior and simultaneous read/write.
4. Verify synthesis and timing in Vivado.
5. Confirm board-specific pin constraints and physical UART wiring.
