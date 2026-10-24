# **FIFO Interface Specification** 

## **1. Module Name** 

fifo 

## **2. Purpose** 

The FIFO (First-In First-Out) module is responsible for temporarily storing data between producer and consumer modules operating at different rates. 

It performs: 

- Storing incoming byte data 

- Preserving order of arrival 

- Providing buffered data to downstream modules 

- Managing read and write operations 

- Indicating FIFO Full condition 

- Indicating FIFO Empty condition 

- Preventing data loss during burst transfers 

The FIFO module acts as a data buffering interface inside the FPGA communication system. 

## **3. Position in System** 

RX Path: UART RX ↓ RX FIFO ↓ Control FSM 

TX Path: Control FSM ↓ TX FIFO ↓ UART TX 

## **4. Interface** 

module fifo #( parameter DEPTH = 16, parameter DATA_WIDTH = 8 )( input clk, input rst, input wr_en, input rd_en, input [7:0] data_in, output reg [7:0] data_out, output full, output empty 

); 

## **5. Signal Description** 

clk – System clock used for FIFO operation rst – Reset signal clearing FIFO contents wr_en – Write enable signal rd_en – Read enable signal data_in[7:0] – Incoming byte data data_out[7:0] – Output byte data full – FIFO full status flag empty – FIFO empty status flag 

## **6. Internal Registers** 

mem[0:15] – Storage memory array wr_ptr – Write pointer rd_ptr – Read pointer count – Number of stored bytes state – FIFO controller FSM state 

## **7. FIFO Memory Organization** 

FIFO Depth = 16 Entries Data Width = 8 Bits 

Memory Layout: mem[0] mem[1] mem[2] ... mem[15] 

## **8. FIFO Operation** 

Write Operation: When wr_en = 1 and full = 0 Store data_in into memory location pointed by wr_ptr Increment wr_ptr Increment count 

Read Operation: When rd_en = 1 and empty = 0 Transfer memory data to data_out Increment rd_ptr Decrement count 

## **9. Status Flag Generation** 

empty = (count == 0) full = (count == DEPTH) 

Empty indicates no valid data available. Full indicates no additional data can be stored. 

## **10. FIFO Controller FSM** 

States: IDLE WRITE READ ERROR 

## **FSM Diagram** 



<!-- Start of picture text -->
           +-------+<br>           | IDLE  |<br>           +-------+<br>            /   \<br>           /     \<br>      wr_en       rd_en<br>         |           |<br>         v           v<br>    +---------+  +---------+<br>    | WRITE   |  | READ    |<br>    +---------+  +---------+<br>         |           |<br>         +-----+-----+<br>               |<br>               v<br>           +-------+<br>           | IDLE  |<br>           +-------+<br>Write when FULL<br>Read when EMPTY<br>        |<br>        v<br>     +-------+<br>     | ERROR |<br>     +-------+<br>        |<br>        v<br>      IDLE<br><!-- End of picture text -->

## **11. Functional Contract** 

The FIFO Module Shall: 

- Store incoming data bytes 

- Preserve arrival order 

- Support read and write operations 

- Generate full flag 

- Generate empty flag 

- Buffer communication traffic 

The FIFO Module Shall NOT: 

- Interpret commands 

- Generate UART frames 

- Perform protocol processing 

- Control transmission logic 

- Execute application operations 

These responsibilities belong to Control FSM, UART RX and UART TX. 

## **12. Design Parameters** 

FIFO Type = Synchronous FIFO Depth = 16 Entries Data Width = 8 Bits Clock Frequency = 100 MHz Storage Capacity = 16 Bytes 

## **13. Timing Requirements** 

```
Write Cycle
wr_en
  |
  v
data_in valid
memory write
wr_ptr++
count++
Read Cycle
rd_en
  |
  v
memory read
data_out valid
rd_ptr++
count--
```

## **14. Deliverables** 

1. fifo.v 

2. fifo_tb.v 

3. FIFO Controller FSM Diagram 

4. Timing Diagram 

5. Simulation Waveforms 

6. Verification Report 

