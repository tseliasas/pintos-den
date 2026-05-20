#include "threads/loader.h"

OUTPUT_FORMAT("elf32-i386")
OUTPUT_ARCH("i386")
ENTRY(start) 

SECTIONS
{
  /* Kernel starts at 2MB (0xc0200000) */
  . = LOADER_PHYS_BASE + LOADER_KERN_BASE;
  _start = .;

  .text : { 
    *(.start)   /* The entry point defined in start.S must be first */
    *(.text) 
  } = 0x90

  . = ALIGN(0x1000);
  _end_kernel_text = .;

  .rodata : { *(.rodata) *(.rodata.*) }
  
  .data : { 
    *(.data) 
    _signature = .; LONG(0xaa55aa55) 
  }

  .plt : { *(.plt*) }

  /* BSS must be after data */
  . = ALIGN(0x1000);
  _start_bss = .;
  .bss : { *(.bss) *(COMMON) }
  _end_bss = .;

  _end = .;

  ASSERT (_end - _start <= 512K, "Kernel image is too big.")
}