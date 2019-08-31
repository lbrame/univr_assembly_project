# Assembly project

The goal of this project is to translate the high-level language code `gestioneVettore.c` into Assembly language.

The Assembly dialect is AT&T syntax. The architecture is x86 (32-bit Assembly). The assembler used is `as`, the GNU Assembler. This project uses Linux system calls and only works on Linux-based systems.

### Compiling and debugging dependecies



Fedora / Red Hat Enterprise Linux 8 / CentOS 8

```bash
dnf install glibc-devel-i686
dnf debuginfo-install glibc-2.29-15.fc30.i686
```

Debian, Ubuntu, Pop!_OS, Linux Mint, KDE Neon, Elementary OS and other derivates:

```bash
apt install gcc-multilib
```


On Arch Linux, `gcc-multilib` got merged into regular `gcc` and no extra dependecies are required.
