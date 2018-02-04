#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "svdpi.h"

int fd;
struct stat sb;

static inline unsigned long swap4(unsigned long data)
{
	__asm__ __volatile__("bswap %1":"=r"(data):"0"(data));
	return data;
}

static unsigned long long swap8(unsigned long long data)
{
	return ((unsigned long long)swap4(data) << 32) | swap4(data >> 32);
}

void mem_init(char *fn)
{
	fd = open(fn, O_RDONLY);
	if (fd < 0)
		return;
	if (fstat(fd, &sb) < 0) {
		close(fd);
		return;
	}
	printf("mem_init(%s): sucess.\n", fn);
}

static unsigned char *mem_page[0x400];

#define	PAGE_SHIFT	13
#define	PAGE_SIZE	(1 << PAGE_SHIFT)

static unsigned char *get_mem_addr(unsigned addr)
{
	unsigned page = addr >> PAGE_SHIFT;

	if (mem_page[page] == NULL) {
		mem_page[page] = calloc(PAGE_SIZE, 1);

		if ((page << PAGE_SHIFT) < sb.st_size) {
			lseek(fd, page << PAGE_SHIFT, SEEK_SET);
			read(fd, mem_page[page], PAGE_SIZE);
		}
	}
	return mem_page[page] + (addr & (PAGE_SIZE - 1));
}

unsigned long long mem_read(int size, unsigned long long addr)
{
	unsigned char buf[8];

	addr &= ~0x8000000000000000LL;
	// bios area
	switch (addr) {
	case 0x0000fffffffffffcLL:
		return 0xf1f00001;
	case 0x0000ffffffc00000LL:
		return 0xe0008000;
	case 0x0000ffffffc00004LL:
		return 0x9f000000;
	}

	if (addr < 0x00800000) {
		unsigned char *mem_addr;

		switch (size) {
		case 0:
			break;
		case 1:
			addr &= ~1;
			break;
		case 2:
			addr &= ~3;
			break;
		case 3:
			addr &= ~7;
			break;
		}
		mem_addr = get_mem_addr(addr);
		switch (size) {
		case 0:
			*(buf + 7) = *mem_addr;
			break;
		case 1:
			*(unsigned short *)(buf + 6) = *(unsigned short *)mem_addr;
			break;
		case 2:
			*(unsigned int *)(buf + 4) = *(unsigned int *)mem_addr;
			break;
		case 3:
			*(unsigned int *)buf = *(unsigned int *)mem_addr;
			*(unsigned int *)(buf + 4) = *(unsigned int *)(mem_addr + 4);
			break;
		}
		return swap8(*(unsigned long long *)buf);
	}

	return 0xdeadbeefdeadbeefLL;
}

void mem_write(int size, unsigned long long addr, unsigned long long data)
{
	addr &= ~0x8000000000000000LL;

	if (addr < 0x00800000) {
		unsigned char *mem_addr;
		unsigned char *buf;

		data = swap8(data);
		buf = (unsigned char *)&data;

		switch (size) {
		case 0:
			break;
		case 1:
			addr &= ~1;
			break;
		case 2:
			addr &= ~3;
			break;
		case 3:
			addr &= ~7;
			break;
		}
		mem_addr = get_mem_addr(addr);
		switch (size) {
		case 0:
			*mem_addr = *(buf + 7);
			break;
		case 1:
			*(unsigned short *)mem_addr = *(unsigned short *)(buf + 6);
			break;
		case 2:
			*(unsigned int *)mem_addr = *(unsigned int *)(buf + 4);
			break;
		case 3:
			*(unsigned int *)mem_addr = *(unsigned int *)buf;
			*(unsigned int *)(mem_addr + 4) = *(unsigned int *)(buf + 4);
			break;
		}
	}
}
