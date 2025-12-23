         TITLE 'TMAPR   - Insertion into rhdcmapr'
*---------------------------------------------------------------------*
*- Main code                                                         -*
*- =========                                                         -*
*- we fix rhdcmapr to exit immediatly if been called from a          -*
*-   TCP/IP line.                                                    -*
*-                                                                   -*
*-   isptfix1 change code at offset 128 in rhdc mapr to branch       -*
*-   to patch area. there we test for line tcp/ip and exit          -*
*-   if it is. else we execute the section of code at                -*
*-   offset 128                                                      -*
*-                                                                   -*
*-   assemble this code and use the assembled code to Amaspzap       -*
*-   rhdcmapr                                                        -*
*-                                                                   -*
*-                                                                   -*
*---------------------------------------------------------------------*
TMAPR CSECT
         @MODE MODE=IDMSDC
         #MOPT CSECT=TMAPR,ENV=SYS,modno=5737,AMODE=31,RMODE=ANY
TMAPREP1 #start mpmode=CALLER
        USING csa,R10
        USING tce,R9
*
oconst  ds  0h
**** ignore this code
      cli   0(R4),C'1'
      be    oconst
      bne   oconst
      bh    oconst
      bnh   oconst
      bl    oconst
      bm    oconst
      bnm   oconst
      bo    oconst
      bno   oconst
      b     oconst
      tm    0(R1),126
      bz    oconst
      bnz   oconst
      bm    oconst
      bnm   oconst
      bo    oconst
      bno   oconst
********
      dc    cl38' '
********
*     l     r15,CDMSPTCH      -- address of patch area @1038
*     b     3968(R12)         -- 1038-B8 to convert to R12 offset
      l     r15,3968(r12)     -- 1038-B8 to convert to R12 offset
      br    r15
*
         LTORG
         EJECT
*
         COPY #MRBDS
         COPY #TCEDS
         COPY #PTEDS
         COPY #PLEDS
         COPY #LTEDS
         COPY #CSADS
         END   TMAPR
