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
cdmsptch CSECT
         @MODE MODE=IDMSDC
         #MOPT ENV=SYS,modno=5737,AMODE=31,RMODE=ANY
        USING csa,R10
        USING tce,R9
        using mrb,r8
cdmstrt  ds  0h
         l     r3,(tceLtea-tce)(r9)   get LTE
         l     r3,(LtePtea-lte)(r3)   get the PTE
         l     r3,(PTEPLEA-pte)(r3)   and then the line
         cli   (PLEType-ple)(r3),PLETCPD  is it a tcpip line?
         be    58(r15)      return
*        be    2478(r12)    return
*        bcr   0,0          exit rhdcmapr
*        ber   r14          exit rhdcmapr
** from rhdcmapr -- code we replaced
A000128  CLC     MRBNAME(4),3856(r12)   FC8-B8                          00000640
         BC      8,150(r12)      14e - B8 (relative to R12)             00000650
         TM      MRBTYPE,8                                              00000660
         BC      1,150(r12)      14e - B8 (relative to R12)             00000670
         TM      MRBTYPE,2                                              00000680
         BC      1,728(r12)      390 - B8 (relative to R12)             00000690
         TM      MRBOPT1,4                                              00000700
         BC      8,728(r12)      390 - B8 (relative to R12)             00000710
         B       156(r12)        154 - B8 (relative to R12)             00000720
** from rhdcmapr -- code we replaced
*
return   ds    0h
         #rtn
         LTORG
         EJECT
         COPY #CSADS
         COPY #MRBDS
         COPY #TCEDS
         COPY #PTEDS
         COPY #PLEDS
         COPY #LTEDS
         END   cdmsptch
