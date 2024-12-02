#ifndef __C4_H__
#define __C4_H__

#define VERSION   20241127
#define _SYS_LOAD_
#define EDITOR

#ifdef _MSC_VER
  #define _CRT_SECURE_NO_WARNINGS
  #define IS_WINDOWS 1
#elif (defined __i386 || defined __x86_64 || defined IS_LINUX)
  #define IS_LINUX   1
  #define IS_PC      1
#endif

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <stdint.h>
#include <time.h>

#ifdef IS_PC
  #define MEM_SZ        2*1024*1024
  #define STK_SZ            64 // Data stack
  #define RSTK_SZ           64 // Return stack
  #define LSTK_SZ           45 // 15 nested loops (3 entries per loop)
  #define TSTK_SZ           64 // 'A' and 'T' stacks
  #define FSTK_SZ           16 // Files stack
  #define NAME_LEN          17 // To make dict-entry size 24 (17+1+1+1+4)
  #define CODE_SLOTS        32*1024 // 32*1024*4 = 128k
  #define NUM_BLOCKS      1024 // Each block is 1024 bytes
  #define FILE_PC
#else
  #include <Arduino.h>
  #define MEM_SZ           320*1024
  #define STK_SZ            64 // Data stack
  #define RSTK_SZ           64 // Return stack
  #define LSTK_SZ           45 // 15 nested loops (3 entries per loop)
  #define TSTK_SZ           64 // 'A' and 'T' stacks
  #define FSTK_SZ           16 // Files stack
  #define NAME_LEN          17 // To make dict-entry size 24 (17+1+1+1+4)
  #define CODE_SLOTS        32*1024 // 32*1024*4 = 128k
  #define NUM_BLOCKS       128 // Each block is 1024 bytes
  // #define FILE_NONE
  #define FILE_PICO
  // #define FILE_TEENSY
#endif

#define btwi(n,l,h)   ((l<=n) && (n<=h))
#define _IMMED        1
#define _INLINE       2

#define CELL_T        int32_t
#define CELL_SZ       4
#define addressFmt    ": %s $%lx ; inline"
#define WC_T          uint32_t
#define WC_SZ         4
#define BLOCK_SZ      1024
#define NUM_BITS      0xE0000000
#define NUM_MASK      0x1FFFFFFF

enum { COMPILE=1, DEFINE=2, INTERP=3, COMMENT=4 };

typedef CELL_T cell;
typedef WC_T wc_t;
typedef unsigned char byte;
typedef struct { wc_t xt; byte fl, ln; char nm[NAME_LEN+1]; } DE_T;
typedef struct { wc_t op; const char *name; byte fl; } PRIM_T;

// These are defined by c4.cpp
extern cell block;
extern void push(cell x);
extern cell pop();
extern void inPush(char *in);
extern char *inPop();
extern void strCpy(char *d, const char *s);
extern int  strEq(const char *d, const char *s);
extern int  strEqI(const char *d, const char *s);
extern int  strLen(const char *s);
extern int  lower(const char c);
extern void zTypeF(const char *fmt, ...);
extern void inner(wc_t start);
extern void outer(const char *src);
extern void outerF(const char *fmt, ...);
extern void c4Init();
extern void ok();

// c4.cpp needs these to be defined
extern cell inputFp, outputFp;
extern cell fetch16(cell loc);
extern cell fetch32(cell loc);
extern void store16(cell loc, cell val);
extern void store32(cell loc, cell val);
extern void zType(const char *str);
extern void emit(const char ch);
extern void ttyMode(int isRaw);
extern int  key();
extern int  qKey();
extern cell timer();
extern void fileInit();
extern cell fileOpen(const char *name, const char *mode);
extern void fileClose(cell fh);
extern void fileDelete(const char *name);
extern cell fileRead(char *buf, int sz, cell fh);
extern cell fileWrite(char *buf, int sz, cell fh);
extern cell fileSeek(cell fh, cell pos);
extern void fileLoad(const char *name);
extern void blockLoad(int blk);
extern void blockDirty(int blk);
extern void blockLoadNext(int blk);
extern char *blockAddr(cell blk);
extern void editBlock(cell Blk);
extern void flushBlocks();
extern void sys_load();

#endif //  __C4_H__
