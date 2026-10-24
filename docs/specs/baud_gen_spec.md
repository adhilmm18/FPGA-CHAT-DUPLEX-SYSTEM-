# **BAUD GENERATOR Interface Specification** 

## **1. Module Name** 

baud_gen 

## **2. Purpose** 

The Baud Generator module is responsible for generating timing pulses used by UART communication modules. 

It performs: 

- Dividing the 100 MHz system clock 

- Generating baud-rate timing pulses 

- Synchronizing UART RX operation 

- Synchronizing UART TX operation 

- Providing a common timing reference for serial communication 

The Baud Generator serves as the timing heartbeat of the UART communication subsystem. 

## **3. Position in System** 

100 MHz System Clock ↓ BAUD GEN ↓ baud_tick ↓ 

UART RX & UART TX 

## **4. Interface** 

module baud_gen( input clk, input rst, output reg baud_tick ); 

## **5. Signal Description** 

clk – 100 MHz system clock input rst – Reset signal returning module to initial state baud_tick – Single-cycle timing pulse used by UART modules 

## **6. Internal Registers** 

baud_count – Clock divider counter state – Current FSM state 

## **7. Design Parameters** 

Clock Frequency = 100 MHz UART Baud Rate = 115200 bps Divider Value = 868 Counter Width = 10 Bits Tick Width = 1 Clock Cycle 

## **8. Baud Divider Calculation** 

Clock Frequency = 100,000,000 Hz Baud Rate = 115,200 bps 

Divider = Clock / Baud Divider = 100,000,000 / 115,200 Divider = 868.055 

Implemented Divider: BAUD_DIV = 868 

Therefore: 1 UART Bit = 868 Clock Cycles 

## **9. Operation** 

Normal Operation: Increment baud_count every clock cycle. 

Divider Match: When baud_count reaches 867, generate baud_tick and reset counter. 

Otherwise: Continue counting and keep baud_tick low. 

## **10. FSM States** 

RESET – Initialize counter and outputs COUNT – Count clock cycles toward divider value GENERATE_TICK – Generate one-cycle baud_tick pulse 

## **11. FSM Diagram** 



<!-- Start of picture text -->
          +---------+<br>          | RESET   |<br>          +---------+<br>               |<br>               v<br>          +---------+<br>          | COUNT   |<br>          +---------+<br>               |<br>      baud_count == 867<br>               |<br>               v<br>     +------------------+<br>     | GENERATE_TICK    |<br>     +------------------+<br>               |<br>               v<br>          +---------+<br>          | COUNT   |<br><!-- End of picture text -->

```
          +---------+
```

## **12. Timing Requirements** 

```
clk
|_|-|_|-|_|-|_|-|_|-|_|-|_|-|_|-|_|-|_|-
baud_count
0 1 2 3 ... 866 867
```

`baud_tick _____________________|` I `|________________ Tick Width = 1 Clock Cycle New Tick Every 868 Clock Cycles` 

## **13. Functional Contract** 

The Baud Generator Shall: 

- Generate baud timing pulses 

- Divide the 100 MHz clock frequency 

- Produce baud_tick signals 

- Synchronize UART communication modules 

The Baud Generator Shall NOT: 

- Transmit UART frames 

- Receive UART frames 

- Store communication data 

- Control FIFO operation 

- Manage communication flow 

These responsibilities belong to UART RX, UART TX, FIFO and Control FSM modules. 

## **14. Deliverables** 

1. baud_gen.v 

2. baud_gen_tb.v 

3. FSM State Diagram 

4. Timing Diagram 

5. Simulation Waveforms 

6. Verification Report 

