# sabnzbd-riscv64

SABnzbd for RISCV64 ... with RISCV Vector instructions (RVV) in both sabctools and par2cmdline-turbo.

Specials:
* alpine, as it provides gcc 14, which is needed to compile RVV
* par2cmdline-turbo: updated config.guess, a certain commit that works (with altered makefile)
* unrar: remove "-march=native" so that it compiles
* sabnzbd: use python modules cryptography and cffi from alpine (not from pip, as that needs rust and a lot of compiling)

# Prepare

Running on your RISCV64: Bianbu, with docker (docker.io) installed

# build

On your RISCV64 board, execute this:

```
docker build -t="sanderjo/sabnzbd-riscv64" github.com/sanderjo/sabnzbd-riscv64.git#main
```


Building will take 15 minutes (on a Banana Pi BPI-F3, with SpacemiT K1 8 core RISC-V chip)

Check your build with:
```
docker images
```


The "make -j3" uses 3 cores, so you should see 3 cores jump to 100%. More cores might lookup your system.

# run

```
docker run sanderjo/sabnzbd-riscv64

```

![image](https://github.com/user-attachments/assets/b48dc500-8772-42cf-a65b-2ca32f6c7ec2)

# SABnzbd logging

SABnzbd should show these lines at startup.

```
2024-08-16 20:42:16,038::INFO::[SABnzbd:425] SABCTools module (v8.2.5)... found!
2024-08-16 20:42:16,040::INFO::[SABnzbd:426] SABCTools module is using SIMD set: RVV
2024-08-16 20:42:16,041::INFO::[SABnzbd:427] SABCTools module is linked to OpenSSL: True
2024-08-16 20:42:16,042::INFO::[SABnzbd:447] Cryptography module (v43.0.0)... found!
2024-08-16 20:42:16,043::INFO::[SABnzbd:453] par2 binary... found (/usr/local/bin/par2)
2024-08-16 20:42:16,044::INFO::[SABnzbd:460] UNRAR binary... found (/usr/bin/unrar)
```

# run

# rvv

During the build, if your RISCV64 supports RVV, you should see the list of RVV commands in the par2 binary:

```
par2cmdline-turbo version 1.1.1
     58 vadd.vv
     82 vand.vi
     12 vand.vv
     29 vl1r.v
     50 vl1re16.v
    493 vle8.v
     61 vlseg2e8.v
     58 vmsle.vi
      6 vmv.v.i
    135 vmv.v.x
     43 vmv1r.v
    164 vnsrl.wi
    123 vor.vv
    451 vrgather.vv
     75 vs1r.v
      4 vse16.v
     96 vse8.v
    142 vsetivli
    288 vsetvli
    123 vslide1up.vx
    123 vslideup.vi
    246 vsll.vi
     12 vsra.vi
    328 vsrl.vi
     21 vsseg2e8.v
   1044 vxor.vv
     46 vxor.vx
```

