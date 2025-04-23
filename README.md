# Verification_of_UART_Protocol
Verification of UART Protocol using UVM Testbench
# UART Verification using UVM

## Overview
This project implements **Universal Asynchronous Receiver Transmitter (UART) verification** using **Universal Verification Methodology (UVM)**. The goal is to create a robust **UVM testbench (TB)** to validate the functionality of a UART module by applying various test scenarios.


### Key Registers in UART:
1. **THR (Transmit Holding Register)**: Holds the data to be transmitted by the UART. The data is sent serially to the receiver once it's placed in the THR.
2. **RBR (Receiver Buffer Register)**: Holds the data that has been received by the UART from the transmitting device. It is implemented as a FIFO buffer to handle incoming data without loss.
3. **IER (Interrupt Enable Register)**: Enables interrupts for events like data ready to be read or transmission completed.
4. **FCR (FIFO Control Register)**: Manages the operation of the **FIFO** buffers for both transmission and reception.
5. **LCR (Line Control Register)**: Configures the UART’s data format, including bit length, stop bits, and parity.
6. **LSR (Line Status Register)**: Indicates the status of UART operations, including errors like overrun or framing issues.
7. **MCR (Modem Control Register)**: Controls modem lines like DTR and RTS.
8. **MSR (Modem Status Register)**: Provides the status of the modem lines.


### Working of UART Protocol:
1. **Data Transmission**: Data is loaded into the **THR** for transmission. It is then serialized and sent out.
2. **Data Reception**: Data from the receiver is placed in the **RBR** FIFO for later retrieval and processing.
3. **FIFO Buffer in RBR**: The **RBR** FIFO stores incoming data, ensuring no data loss when multiple packets are received.

---
## Features
- **UVM-based Testbench**: Implements a scalable and reusable testbench using UVM.
- **Transaction-based Verification**: Uses a layered approach for stimulus generation and response checking.
- **Assertions & Scoreboarding**: Ensures protocol compliance and functional correctness.
- **Randomized and Directed Testing**: Covers different data transmission scenarios.
- **Self-checking Mechanism**: Automates result verification to improve efficiency.

## Project Structure
```
├── rtl/                  # UART RTL source files
├── tb/                   # UVM Testbench files
│   ├── top.sv            # Top-level module
│   ├── uart_agent.sv     # UVM Agent
│   ├── uart_agt_cfg.sv   # UVM Agent Configuration
│   ├── uart_config.sv    # UVM Configuration
│   ├── uart_drv.sv       # UVM Driver
│   ├── uart_env.sv       # UVM Environment
│   ├── uart_monitor.sv   # UVM Monitor
│   ├── uart_sb.sv        # UVM Scoreboard
│   ├── uart_seqr.sv      # UVM Sequencer
│   ├── uart_seqs.sv      # UVM Sequences
│   ├── uart_v_seqr.sv    # UVM Virtual Sequencer
│   ├── uart_v_seqs.sv    # UVM Virtual Sequences
│   ├── uart_xtn.sv       # UVM Transaction
├── test/                 # Test cases and test configurations
├── sim/                  # Simulation scripts, logs, and Makefile
├── docs/                 # Documentation & Reports
└── README.md             # Project Documentation
```

## Setup and Usage
### Prerequisites
Ensure you have the following tools installed:
- **SystemVerilog Simulator**: QuestaSim or VCS
- **UVM Framework**: UVM 1.2 or later
- **Make** (for automated build and simulation)

### How to Run the Simulation
1. **Clone the Repository**:
   ```sh
   git clone <repo-link>
   ```
2. **Compile the UVM Testbench**:
   ```sh
   make sv_cmp
   ```
3. **Run the Simulation**:
   ```sh
   make run_testi             i=1 to 9
   ```
4. **View the Waveforms**:
   ```sh
   make view_wave_i           i=1 to 9
   ```

## Test Scenarios
- **Basic Transmission & Reception**: Verify UART TX/RX communication.
- **Baud Rate Variation**: Check operation at different baud rates.
- **Framing Errors**: Validate detection of incorrect stop/start bits.
- **Parity Check**: Ensure data integrity using parity.
- **FIFO Buffer Handling**: Simulate different buffer depths.
- **Overrun Errors**: Test UART's response to overrun conditions.
- **Break Interrupts**: Verify UART's handling of break conditions.
- **Timeout Errors**: Assess UART's timeout error detection and response.
- **Full-Duplex Operation**: Test simultaneous bidirectional data transmission and reception.
- **THR Empty Case**: Test the condition where the Transmit Holding Register (THR) is empty, ensuring that the UART correctly handles data transmission when no data is available in the THR for transmission.


## Results & Logs
After running the testbench, logs and coverage reports will be generated in the `sim/` directory. 

## Contribution
Feel free to fork this repository and contribute by adding more test scenarios or improving the testbench architecture.

## License
This project is licensed under the **MIT License**.

---
📌 **Author**: Vikas K  
📩 **Contact**: [GitHub Profile](https://github.com/Vk13io)
