# My Hobby OS: A Learning Journey

This project is a journey into the world of operating system development, undertaken as a hobby in my spare time. The primary goal is to learn and understand the low-level workings of an OS, exploring how it bridges the gap between hardware and software. This is a learning exercise focused on implementing the core components of a modern operating system from scratch.

## Core Learning Objectives

This project will focus on the hands-on implementation of the following core OS concepts:

### 1. Memory and Resource Management
This is the foundation of the OS. The goal is to learn how to manage the computer's physical memory and provide abstractions for processes.
*   **Physical Memory Manager (PMM):** To track which parts of the physical RAM are in use or available.
*   **Virtual Memory Manager (VMM):** To implement paging, giving each process its own isolated virtual address space. This is crucial for memory protection.
*   **Kernel Heap:** To allow the kernel to dynamically allocate memory for its own data structures.

### 2. Concurrency: Multitasking, Scheduling, and Synchronization
This is where the OS learns to do more than one thing at once.
*   **Multitasking:** Implement the core structures to manage multiple running processes or threads simultaneously.
*   **Scheduler:** Build a scheduler (e.g., a simple round-robin algorithm) to decide which process gets to use the CPU and for how long.
*   **Process Synchronization:** Implement primitives like mutexes or semaphores to prevent race conditions and safely manage access to shared data between different processes.

### 3. Kernel-User Space Interaction: System Calls and IPC
This is about building the bridge that allows user programs to safely interact with the kernel and with each other.
*   **System Calls:** Design and implement a secure interface that allows user-mode applications to request services from the kernel (e.g., reading a file, allocating memory, or creating a new process).
*   **Inter-Process Communication (IPC):** Use the system call infrastructure to build mechanisms like pipes or signals that allow different processes to communicate and coordinate with each other.

### 4. Networking Stack
A key goal is to understand how networking is implemented at a low level.
*   **Driver:** Write a driver for a common network interface card (NIC).
*   **Protocols:** Implement the core internet protocols from the ground up, including ARP, IP, ICMP (for ping), UDP, and TCP.

## Development Roadmap

### Phase 1: Bare Bones & Core Infrastructure
*   [x] Set up a cross-compiler (GCC, Binutils)
*   [x] Create a bootloader that enters 32-bit Protected Mode and loads the kernel
*   [x] Implement a Global Descriptor Table (GDT)
*   [ ] Implement an Interrupt Descriptor Table (IDT)
*   [ ] Implement Interrupt Service Routines (ISRs) for exceptions
*   [ ] Implement Interrupt Handlers (IRQs) for hardware interrupts
*   [ ] Implement a driver for the Programmable Interval Timer (PIT)
*   [ ] Implement a driver for the keyboard

### Phase 2: Memory Management
*   [ ] Implement a Physical Memory Manager (PMM)
*   [ ] Implement a Virtual Memory Manager (VMM) with paging
*   [ ] Implement a kernel heap (kmalloc)

### Phase 3: Multitasking
*   [ ] Implement a process/task abstraction
*   [ ] Implement a scheduler
*   [ ] Implement context switching

### Phase 4: User Space & System Calls
*   [ ] Design and implement a system call interface
*   [ ] Implement a loader for a simple executable format (e.g., ELF)
*   [ ] Create the first user-mode process (init) and a simple shell

### Phase 5: Filesystems
*   [ ] Implement a driver for an ATA/SATA disk controller
*   [ ] Implement a Virtual File System (VFS)
*   [ ] Implement a simple filesystem

### Phase 6: Networking
*   [ ] Implement a driver for a network card
*   [ ] Implement the ARP protocol
*   [ ] Implement the IP protocol
*   [ ] Implement the ICMP protocol (for ping)
*   [ ] Implement the UDP protocol
*   [ ] Implement the TCP protocol

---

## Build Instructions

This document provides instructions on how to build and run this operating system project.

### Recommended Method: Using Nix

This project uses [Nix](https://nixos.org/) with [Flakes](https://nixos.wiki/wiki/Flakes) to provide a reproducible and isolated development environment. This is the easiest and most reliable way to build the project.

1.  **Install Nix:** If you don't have it, [install the Nix package manager](https://nixos.org/download.html). Make sure to enable Flakes support.

2.  **Start the Development Shell:** Navigate to the `src` directory (where this `README.md` is located) and run the following command:
    ```sh
    nix develop
    ```
    This command will download all the necessary dependencies and drop you into a new shell session that is fully configured for building the OS.

3.  **Build the OS:** Once inside the Nix shell, you can use the standard `make` commands to build and run the project. See the "Makefile Targets" section below.

### Manual Method

If you do not wish to use Nix, you can install the required tools on your system manually. You will need:

*   A 32-bit cross-compiler toolchain (e.g., `i686-elf-gcc`).
*   NASM (The Netwide Assembler).
*   QEMU.

Ensure these tools are available in your system's `PATH`.

### Makefile Targets

Once your environment is set up, use the following `make` commands:

*   `make build` or `make`: Compiles all code and creates the final `build/os.img` disk image.
*   `make run`: Builds and runs the OS image in QEMU.
*   `make debug`: Builds and runs the OS in QEMU with a GDB server listening on `localhost:1234`.
*   `make clean`: Removes the `build` directory and all compiled artifacts.
