# DE0_MMIX

Partial implementation of Knuth's MMIX processor for DE0.
To study HDL, I started to implement MMIX processor with System Verilog.

## Feature
Support [DE0 MMIX BIOS](http://github.com/eiji-y/DE0_MMIX_BIOS).
Currently, BIOS display banner message only.

## Memory map

Avalon memory map
```
0x0000 0000 ~ 0x007f ffff : RAM (SDRAM)
0x07c0 0000 ~ 0x07ff ffff : ROM (Flash)
0x0900 0000 ~ 0x0900 0007 : PS2
0x0a00 0000 ~ 0x0a00 1fff : Video RAM
0x0b00 0000 ~ 0x0b00 03ff : SD Card
```

MMIX address (64bit) to Avalon address (32bit) conversion
('-' : Ignore, so different MMIX address maps to same Avalon address.)

```
---- ---- ---- ---x ---- ---- ---- ---- ---- -xxx xxxx xxxx xxxx xxxx xxxx xxxx
                   \________________________  |                               |
                                            \ v                               v
                                             xxxx xxxx xxxx xxxx xxxx xxxx xxxx
```

Resulting MMIX memory map
```
0x0000 0000 0000 0000 ~ 0x0000 0000 007f ffff : RAM
0x0000 ffff ffc0 0000 ~ 0x0000 ffff ffff ffff : ROM
0x0001 0000 0900 0000 ~ 0x0001 0000 0900 0007 : PS2
0x0001 0000 0a00 0000 ~ 0x0001 0000 0a00 1fff : Video RAM
0x0001 0000 0b00 0000 ~ 0x0001 0000 0b00 03ff : SD Card
```

## Initial PC
0x0000 ffff ffff fffc

## Known Issue
First character of banner message is not shown.

## TODO
* Support TRAP, Interrupt, etc for linux kernel execution.
* Boot linux kernel from SD card.
