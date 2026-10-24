# **CONTROL FSM Interface Specification** 

## **1. Module Name** 

control_fsm 

## **2. Purpose** 

The Control FSM module is the central decision-making unit of the FPGA UART Chat System. 

It performs: 

- Monitoring RX FIFO status 

- Reading received bytes from RX FIFO 

- Checking TX FIFO availability 

- Moving data from RX FIFO to TX FIFO 

- Initiating UART transmission 

- Waiting for transmission completion 

- Coordinating data flow between communication modules 

The Control FSM serves as the brain of the communication subsystem. 

## **3. Position in System** 

UART RX ↓ RX FIFO ↓ CONTROL FSM ↓ TX FIFO ↓ UART TX 

## **4. Interface** 

module control_fsm( input clk, input rst, 

input rx_fifo_empty, output reg rx_fifo_rd_en, input [7:0] rx_fifo_data, 

input tx_fifo_full, output reg tx_fifo_wr_en, output reg [7:0] tx_fifo_data, 

input tx_done, output reg tx_start ); 

## **5. Signal Description** 

clk – 100 MHz system clock used for FSM operation rst – Reset signal returning FSM to IDLE state rx_fifo_empty – Indicates RX FIFO contains no data rx_fifo_rd_en – Read enable for RX FIFO rx_fifo_data[7:0] – Byte received from RX FIFO tx_fifo_full – Indicates TX FIFO cannot accept more data tx_fifo_wr_en – Write enable for TX FIFO tx_fifo_data[7:0] – Byte written into TX FIFO tx_done – UART TX transmission completion pulse tx_start – UART TX transmission request 

## **6. Internal Registers** 

state – Current FSM state next_state – Next FSM state received_byte[7:0] – Temporary storage for data read from RX FIFO 

## **7. Communication Flow** 

Step 1: UART RX receives byte Step 2: RX FIFO stores byte Step 3: Control FSM reads byte Step 4: Control FSM checks TX FIFO space Step 5: Control FSM writes byte into TX FIFO Step 6: UART TX transmits byte Step 7: Wait for tx_done signal Step 8: Return to IDLE 

## **8. FSM States** 

IDLE – Wait for available data in RX FIFO READ_RX – Read byte from RX FIFO CHECK_TX_SPACE – Verify TX FIFO has free space WRITE_TX – Write data into TX FIFO START_TX – Request UART transmission WAIT_TX_DONE – Wait for UART TX completion 

## **9. FSM State Descriptions** 

IDLE: 

Wait until RX FIFO contains data. 

READ_RX: 

Assert rx_fifo_rd_en and capture received byte. 

CHECK_TX_SPACE: Monitor tx_fifo_full flag. 

WRITE_TX: Write captured byte into TX FIFO. 

START_TX: 

### Assert tx_start signal for UART TX. 

WAIT_TX_DONE: 

Remain here until tx_done becomes active. 

## **10. FSM Diagram** 



<!-- Start of picture text -->
                    +------+<br>                    | IDLE |<br>                    +------+<br>                        |<br>            RX FIFO NOT EMPTY<br>                        |<br>                        v<br>                +---------------+<br>                |   READ_RX     |<br>                +---------------+<br>                        |<br>                        v<br>                +---------------+<br>                |CHECK_TX_SPACE |<br>                +---------------+<br>                        |<br>                  TX FULL?<br>                   /    \<br>                 YES    NO<br>                  |      |<br>                  |      v<br>                  | +-----------+<br>                  | | WRITE_TX  |<br>                  | +-----------+<br>                  |       |<br>                  |       v<br>                  | +-----------+<br>                  | | START_TX  |<br>                  | +-----------+<br>                  |       |<br>                  |       v<br>                  | +-------------+<br>                  +-|WAIT_TX_DONE |<br>                    +-------------+<br>                           |<br>                     tx_done = 1<br>                           |<br>                           v<br>                        IDLE<br><!-- End of picture text -->

## **11. Functional Contract** 

The Control FSM Shall: 

- Read data from RX FIFO 

- Check TX FIFO status 

- Transfer data between FIFOs 

- Start UART transmission 

- Wait for transmission completion 

- Coordinate communication flow 

The Control FSM Shall NOT: 

- Sample UART bits 

- Generate UART frames 

- Store packet data long-term 

- Manage FIFO memory arrays 

- Perform UART serialization 

These responsibilities belong to UART RX, UART TX and FIFO modules. 

## **12. Timing Requirements** 

```
RX FIFO receives byte
          |
          v
```

```
READ_RX
CHECK_TX_SPACE
WRITE_TX
START_TX
WAIT_TX_DONE
tx_done
Return to IDLE
```

## **13. Design Parameters** 

System Clock = 100 MHz Data Width = 8 Bits FSM Type = Moore FSM Application = UART Chat System Controller 

## **14. Deliverables** 

1. control_fsm.v 

2. control_fsm_tb.v 

3. FSM State Diagram 

4. Timing Diagram 

5. Simulation Waveforms 

6. Verification Report 

