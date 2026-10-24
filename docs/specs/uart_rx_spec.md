# **UART RX Interface Specification** 

## **1. Module Name** 

uart_rx 

## **2. Purpose** 

The UART RX module is responsible for receiving serial UART data from an external device and converting it into parallel byte data. 

It performs: 

- Detecting incoming UART frames 

- Synchronizing with baud rate 

- Sampling incoming bits 

- Converting serial bits into 8-bit parallel data 

- Indicating completion of byte reception 

- Providing received data to higher-level modules 

The UART RX module is the input communication interface of the FPGA system. 

## **3. Position in System** 

|Laptop / External UART Device|
|---|
|↓|
|UART RX|
|↓|
|rx_data[7:0]|
|↓|
|Control FSM / RX FIFO|



## **4. Interface** 

module uart_rx( input clk, input rst, input rx, output reg [7:0] rx_data, output reg rx_done ); 

## **5. Signal Description** 

|Signal|Direction|Description|
|---|---|---|
|clk|Input|System clock used for baud timing and FSM operation.|
|rst|Input|Reset signal. Clears reception and returns FSM to idle.|
|rx|Input|UART serial input line.|
|rx_data[7:0]|Output|8-bit parallel received byte.|
|rx_done|Output|Pulse indicating successful byte reception.|



## **6. Internal Registers** 

|Register|Purpose|
|---|---|
|bit_count|Counts received data bits from 0 to 7.|
|shift_reg|Stores incoming serial bits before conversion.|
|baud_count|Generates sampling intervals.|



## **7. UART Frame Format** 

UART Frame: 

Start Bit | Data[7:0] | Stop Bit 

- 0 | LSB First | 1 

Frame length = 10 bits 

- 1 Start bit 

- 8 Data bits 

- 1 Stop bit 

## **8. Reception Operation** 

|Stage|Operation|
|---|---|
|Idle State|Waits for rx to become 0 indicating start bit.|
|Start Detection|Initializes counters and begins reception.|
|Data Sampling|Samples 8 data bits received LSB first.|
|Stop Bit|Checks final bit and transfers data.|
|Done|Generates rx_done pulse.|



## **9. FSM State Machine** 

|State|Description|
|---|---|
|IDLE|Wait for incoming data.|



|State|Description|
|---|---|
|WAIT_START|Confirm valid start bit.|
|RECEIVE_BITS|Shift incoming bits and increment bit counter.|
|STOP_BIT|Verify stop bit and prepare output.|
|DONE|Generate rx_done and return to IDLE.|



## **10. Functional Contract** 

The UART RX module shall: 

- Detect UART frames 

- Sample incoming bits 

- Convert serial data into parallel data 

- Generate receive completion signal 

The UART RX module shall NOT: 

- Interpret commands 

- Store packets 

- Execute operations 

- Control memory 

- Generate UART output 

These responsibilities belong to: 

Control FSM 

FIFO 

UART TX 

## **11. Deliverables** 

1. uart_rx.v 

2. uart_rx_tb.v 

3. FSM State Diagram 

4. Timing Diagram 

5. Simulation Waveforms 

6. Verification Report 

