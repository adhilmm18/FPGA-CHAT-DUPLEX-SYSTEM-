# **TOP MODULE Interface Specification** 

## **1. Module Name** 

top 

## **2. Purpose** 

The Top Module is the system integration layer of the FPGA UART Chat System. 

It performs: 

- Instantiating all communication modules 

- Connecting internal signals between modules 

- Distributing baud timing signals 

- Routing data between subsystems 

- Connecting FPGA pins to internal logic 

The Top Module serves as the motherboard of the UART communication architecture. 

## **3. Position in System** 

External UART Device / Laptop ↓ 

TOP MODULE 

↓ 

Entire FPGA UART Chat System 

## **4. System Architecture** 



<!-- Start of picture text -->
                   +-----------+<br>                   | BAUD GEN  |<br>                   +-----------+<br>                          |<br>                     baud_tick<br>                          |<br>          +---------------+---------------+<br>          |                               |<br>          v                               v<br>      +-------+                      +-------+<br>      |UART RX|                      |UART TX|<br>      +-------+                      +-------+<br>          |                               ^<br>          |                               |<br>          v                               |<br>      +---------+                   +---------+<br>      | RX FIFO |                   | TX FIFO |<br>      +---------+                   +---------+<br>          |                               ^<br>          |                               |<br>          +----------+      +-------------+<br>                     |      |<br>                     v      |<br>                +-------------+<br>                | CONTROL FSM |<br>                +-------------+<br><!-- End of picture text -->

## **5. Interface** 

module top( input clk, input rst, input rx, output tx ); 

## **6. Signal Description** 

clk – 100 MHz system clock rst – System reset signal rx – UART serial input from external device tx – UART serial output to external device 

## **7. Internal Wires** 

baud_tick – Baud generator timing pulse rx_data[7:0] – Received UART byte rx_done – UART RX completion signal tx_start – UART TX start request tx_done – UART TX completion signal rx_fifo_empty – RX FIFO empty flag tx_fifo_full – TX FIFO full flag rx_fifo_data[7:0] – Data read from RX FIFO tx_fifo_data[7:0] – Data written to TX FIFO 

## **8. Module Instantiations** 

1. baud_gen 

2. uart_rx 

3. rx_fifo 

4. control_fsm 

5. tx_fifo 

6. uart_tx 

## **9. Data Flow Operation** 

Step 1: UART RX receives serial data Step 2: RX FIFO stores received byte Step 3: Control FSM reads byte from RX FIFO Step 4: Control FSM checks TX FIFO availability Step 5: Control FSM writes byte into TX FIFO Step 6: UART TX transmits byte Step 7: External device receives byte 

## **10. Module Connectivity** 



<!-- Start of picture text -->
100 MHz Clock<br>      |<br>      v<br>+-------------+<br>|  BAUD GEN   |<br>+-------------+<br>      |<br>      +------------------+<br>      |                  |<br><!-- End of picture text -->



<!-- Start of picture text -->
      v                  v<br>+---------+        +---------+<br>| UART RX |        | UART TX |<br>+---------+        +---------+<br>      |                  ^<br>      v                  |<br>+---------+        +---------+<br>| RX FIFO |        | TX FIFO |<br>+---------+        +---------+<br>      |                  ^<br>      +-------+  +-------+<br>              |  |<br>              v  |<br>        +------------+<br>        |CONTROL FSM |<br>        +------------+<br><!-- End of picture text -->

## **11. FSM Considerations** 

The Top Module contains no FSM. 

### Reason: 

- The Top Module performs signal routing only. 

- Communication decisions are handled by control_fsm. 

- UART state machines remain inside uart_rx and uart_tx. 

- FIFO management remains inside fifo modules. 

## **12. Functional Contract** 

The Top Module Shall: 

- Instantiate all modules 

- Connect all internal signals 

- Route communication data 

- Connect FPGA I/O pins 

- Distribute baud timing signals 

The Top Module Shall NOT: 

- Receive UART frames 

- Transmit UART frames 

- Store FIFO data 

- Generate baud timing 

- Control communication flow 

These responsibilities belong to lower-level modules. 

## **13. Design Parameters** 

System Clock = 100 MHz UART Baud Rate = 115200 bps Data Width = 8 Bits FIFO Depth = 16 Entries Architecture Type = Full Duplex UART Chat System 

## **14. Timing Overview** 

```
UART RX Receives Byte
          |
          v
```

```
RX FIFO Stores Data
```

```
          |
          v
CONTROL FSM Transfers Data
          |
          v
TX FIFO Stores Data
          |
          v
UART TX Sends Data
```

## **15. Deliverables** 

1. top.v 

2. top_tb.v 

3. System Architecture Diagram 

4. Connectivity Diagram 

5. Timing Diagram 

6. Verification Report 

