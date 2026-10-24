# **UART TX Interface Specification** 

## **1. Module Name** 

uart_tx 

## **2. Purpose** 

The UART TX module is responsible for transmitting parallel byte data over a serial UART communication channel. 

- Accepting parallel byte data from higher-level modules 

- Converting parallel data into serial UART format 

- Generating UART start bit 

- Transmitting 8 data bits 

- Generating UART stop bit 

- Indicating completion of transmission 

- Providing serial data output to external UART devices 

The UART TX module is the output communication interface of the FPGA system. 

## **3. Position in System** 

Control FSM / TX FIFO ↓ tx_data[7:0] ↓ UART TX ↓ tx ↓ Laptop / External UART Device 

## **4. Interface** 

module uart_tx( input clk, input rst, input [7:0] tx_data, input tx_start, output reg tx, output reg tx_done ); 

## **5. Signal Description** 

clk – 100 MHz system clock used for baud timing and FSM operation rst – Resets UART transmitter and returns FSM to IDLE tx_data[7:0] – Byte to be transmitted tx_start – Begins UART transmission tx – UART serial output line tx_done – Pulse indicating transmission completion 

## **6. Internal Registers** 

bit_count – Counts transmitted bits from 0 to 7 shift_reg – Holds data being serialized baud_count – Generates baud timing intervals tx_busy – Indicates transmitter is active state – Current FSM state 

## **7. UART Frame Format** 

Start Bit | Data[7:0] | Stop Bit 0 | LSB First | 1 

Frame Length = 10 bits 

- 1 Start Bit 

- 8 Data Bits 

- 1 Stop Bit 

## **8. Transmission Operation** 

Idle State → Waits for tx_start assertion Data Load → Copies tx_data into shift register Start Bit → Drives tx low Data Transmission → Sends 8 bits LSB first Stop Bit → Drives tx high Done → Generates tx_done pulse 

## **9. FSM State Machine** 

States: IDLE LOAD_DATA START_BIT SEND_BITS STOP_BIT DONE 

## **FSM Diagram** 



<!-- Start of picture text -->
+-------+<br>| IDLE  |<br>+-------+<br>    |<br>tx_start<br>    |<br>    v<br>+-------------+<br>| LOAD_DATA   |<br>+-------------+<br>    |<br>    v<br>+-------------+<br>| START_BIT   |<br>+-------------+<br>    |<br>    v<br>+-------------+<br><!-- End of picture text -->

```
| SEND_BITS   |
+-------------+
    |
bit_count = 8
    |
    v
+-------------+
| STOP_BIT    |
+-------------+
    |
    v
+-------------+
| DONE        |
+-------------+
    |
    v
+-------+
| IDLE  |
+-------+
```

## **10. Baud Rate Requirements** 

Clock Frequency = 100 MHz Baud Rate = 115200 bps 

Divider = 100,000,000 / 115,200 = 868.055 Implemented Value: BAUD_DIV = 868 

1 UART Bit = 868 Clock Cycles 

## **11. Functional Contract** 

The UART TX Module Shall: 

- Accept transmit requests 

- Convert parallel data into serial format 

- Generate UART start bit 

- Transmit 8 data bits 

- Generate UART stop bit 

- Generate transmission completion pulse 

The UART TX Module Shall NOT: 

- Interpret commands 

- Store packets 

- Control memory 

- Manage FIFO buffers 

- Receive UART data 

These responsibilities belong to Control FSM, TX FIFO and UART RX. 

## **12. Deliverables** 

1. uart_tx.v 

2. uart_tx_tb.v 

3. FSM State Diagram 

4. Timing Diagram 

5. Simulation Waveforms 

6. Verification Report 

## **13. Timing Requirements** 

```
tx_start
    |
    v
START_BIT (868 cycles)
DATA0 (868 cycles)
DATA1 (868 cycles)
DATA2 (868 cycles)
DATA3 (868 cycles)
DATA4 (868 cycles)
DATA5 (868 cycles)
DATA6 (868 cycles)
DATA7 (868 cycles)
STOP_BIT (868 cycles)
tx_done pulse
```

