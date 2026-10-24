

# **FPGA Based FullDuplex Chat System** 





## **Group Members** 

##### 1. SIDDHARTH 

2. ARAVIND 

3. ALDRIN 

##### 4. ADHIL 





### **OBJECTIVE** 

•Design a UART based communication system on FPGA. •Implement transmitter and receiver modules using Verilog HDL. 

•Enable simultaneous bidirectional communication. 

•Use FIFO buffering for reliable data handling. 

•Demonstrate FPGA based real-time digital communication. 





#### **Methodologies Used** 

- Baud Generator for timing generation 

- UART TX for parallel-to-serial conversion 

- UART RX for serial-to-parallel conversion 

- FIFO for temporary data storage 

- Control FSM for communication management 

- Integrate all modules using a top module. 



Laptop A <mark>│</mark> 



#### **Architecture** 



<!-- Start of picture text -->
┌─────────┐<br>│  FPGA A  │<br>│  RX_PC  │<br>│  FIFO  │<br>│  FSM  │<br>│  TX_LINK  │<br>└──── ┬ ────┘<br><!-- End of picture text -->

UART Link(Jumper Wires) 



<!-- Start of picture text -->
┌──── ────┐<br>│  FPGA B  │<br>│  RX_LINK  │<br>│  FIFO  │<br>│  FSM  │<br>│  TX_PC  │<br>└──── ┬ ────┘<br>│<br>Laptop B<br><!-- End of picture text -->





### 1.UART TX Module 

•Converts 8-bit parallel data into UART serial format. 

•Generates start bit, 8 data bits, and stop bit. 

•FSM STATES: IDLE, LOAD_DATA, START_BIT, SEND_BITS, STOP_BIT, DONE. 

•UART frame length = 10 bits. 





<!-- Start of picture text -->
DATA LATCH<br>( tx_data )<br>Inputs Outputs<br>clk | UART TX FSM | ein<br>rst | IDLE tx_done<br>tx_data[7:0] ;<br>Dasa | LOAD_DATA<br>| | START_BIT<br>SEND_BITS<br>(8 bitsLSB First) [<br>BIT COUNTER<br>STOP_BIT | (0 to 7)<br>DONE |<br>SERIAL OUTPUT<br>(tx)<br><!-- End of picture text -->



### 2.UART RX Module 

•Receives serial UART data and converts it into 8-bit parallel data. 

•Detects start bit and samples incoming bits. 

•FSM STATES : IDLE, WAIT_START, RECEIVE_BITS, STOP_BIT, DONE. 





<!-- Start of picture text -->
RX INPUT<br>Inputs (m)rm Outputs<br>clk<br>aS, |ea rx_data[7:0]<br>mt UART RX FSM mx done<br>rm H<br>i WAIT_START<br>' | RECEIVE BITS<br>( 8 bits LSB First)<br>BIT COUNTER<br>STOP_BIT (0 to 7)<br>DONE<br>PARALLEL DATA OUT<br>( r_data[7:0) )<br><!-- End of picture text -->



### 3.FIFO Buffer 

•Provides temporary storage between modules operating at different speeds. 

•FIFO depth: 16 entries. 

•Data width: 8 bits. 

•Generates FULL and EMPTY status signals. 





<!-- Start of picture text -->
WRITE DATA<br>( data_in)<br>Inputs | FIFOMEMORY Outputs<br>clk memo] | data_out[7:0]<br>a | oe<br>wren emf] ' empty<br>rd_en \<br>WRITE mem[15] READ<br>POINTER POINTER<br>( wr_ptr ) | |_(rd_ptr)<br>COUNTER<br>({ count )<br>[ [<br>FULL EMPTY<br>{ count = 16) (count =0)<br><!-- End of picture text -->



### 4.Control FSM 

•Receives serial UART data and converts it into 8-bit parallel data. 

•Detects start bit and samples incoming bits. 

•FSM STATES : IDLE, WAIT_START, RECEIVE_BITS, STOP_BIT, DONE. 





<!-- Start of picture text -->
po CONTROL FSM<br>Inputs | if |<br>clk RY FIFO i tx_done = 1<br>| NOTEMPTY/<br>rx_fifo_empty | (Renan WAITTIX)<br>rx_fifo_data[7:0] a _DONE |<br>tx_fifo_full | |<br>taSuene | | Outputs<br>| CHECK_TX | rx_fifo_rd_en<br>TX FIFO |ie| : | txfifo_wr_en<br>FULL | SS? | t_fifo_data[7:0]<br>TX FIFO | tx_start<br>| NOT FULL |<br><!-- End of picture text -->

5.TOP MODULE 





<!-- Start of picture text -->
BAUD GEN<br>Inputs { baud_tick ) Output<br>clk<br>; x<br>rst<br>rx<br>|<br>1|<br>1 |<br>i<br>i<br>i a =a |<br>|<br>i RX FIFO | TX FIFO |<br>|<br>CONTROL FSM |<br>i|<br>i<br>i|<br>;<br>1<br>———SE———__ ae |<br>e527 oa Full Duplex Communication eas:<br><!-- End of picture text -->



<!-- Start of picture text -->
“8 8 sees<br><!-- End of picture text -->



### **Implementation** 

- Language: Verilog HDL 

- Platform: FPGA 

- Communication protocol: UART 

- Architecture: Full duplex communication system 





### **Results** 

- Successful design of modular UART communication system. 

- TX and RX operate independently. 

- Buffered data transfer prevents data loss. 

- Simulation and module verification can be performed using testbenches. 





Documents/vivado/project_chat via & v3.14.6 took 1m7s python Connected to /dev/ttyUSB1 @ 115200 baud es [Re tp Type your message and press Enter. Press Ctrl+C to exit. You: Friend: clear You: hello You: Friend: what's up You: all good You: 





### **Applications** 

- FPGA based communication devices. 

- Embedded communication systems. 

- Hardware interface learning platforms. 

- Real-time digital communication applications. 







**THANK YOU** 

