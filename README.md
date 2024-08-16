# sabnzbd-riscv64

SABnzbd for RISCV64 ... with RISCV Vector instructions (RVV) in both sabctools and par2cmdline-turbo.

Specials:
* par2cmdline-turbo: updated config.guess, a certain commit that works (with altered makefile)
* unrar: remove -mative
* sabnzbd: use python modules cryptography and cffi from alpine (not from pip, as that needs rust and a lot of compiling)

# build

On your RISCV64 board, execute this:

docker build -t sanderjo/sabnzbd-riscv64 github.com/sanderjo/sabnzbd-riscv64.git#main

Building will take 10-15 minutes (on a Banana Pi BPI-F3, with SpacemiT K1 8 core RISC-V chip)

The "make -j3" uses 3 cores, so you should see 3 cores jump to 100%. More cores might lookup your system.

![image](https://github.com/user-attachments/assets/b48dc500-8772-42cf-a65b-2ca32f6c7ec2)

# run

