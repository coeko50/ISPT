         TITLE 'ISPTMAPR   - RHDCMAPR replacement for TCPIP'
*---------------------------------------------------------------------*
*  call ISPTRDR or ISPTWTR if the line is TCPIP, else return          *
*                                                                     *
*  will be installed as a RHDCMAPR hook by ISPTVECT                   *
*                                                                     *
*---------------------------------------------------------------------*
         copy isptmac
*---------------------------------------------------------------------*
ISPTMAPR CSECT
         @MODE MODE=IDMSDC
         #MOPT ENV=SYS,modno=5737,AMODE=31,RMODE=ANY
TMAPREP1 #start mpmode=CALLER
         LR    r12,r15
         USING csa,R10
         USING tce,R9
** code to ease debugging -- vtam tasks ISPTDR,ISPTRDR& ISPTWTR will
** still call RDR & wtr as part of the mapin/out
**
         l     r4,(tceLtea-tce)(r9)   get LTE
         l     r5,(LtePtea-lte)(r4)   get the PTE
         l     r4,(PTEPLEA-pte)(r5)   and then the line
         cli   (PLEType-ple)(r4),PLETCPD  is it a tcpip line?
*        bne   return
         Be    continue
         clc   (TCETSKID-tce)(R9),tdriver
         be    continue
         clc   (TCETSKID-tce)(R9),treader
         be    continue
         clc   (TCETSKID-tce)(R9),twriter
         bne   return
*
continue ds    0h
*
* VECTOR SPECIFIC OVERRIDE CODING HERE
*
*
TCP001   ds 0h
*  for tcip line - we must now figure out if it is a mapin or mapout
         lr    r2,r1
         #getstk =WKLEN,reg=r11
         using stckarea,r11

         #GETSTG TYPE=(USER,SHORT),LEN=WORKAREL,                       X
               ADDR=(R3),INIT=X'00',RGSV=(R2-R8)
               using workarea,r3
         xr    r1,r1
         st    r1,parm3      msg address
         st    r1,parm4      msglen
         l     r1,0(r2)
         st    r1,parm1      x'7F'
*        #SNAP AREA=(0(R2),64),TITLE=' ISPTMAPR - IParm',RGSV=(R2-R8)
         l     r1,4(r2)
         st    r1,parm2      mrb
         l     r8,parm2
         using mrb,r8

         #test MRBREAD,off=callWTR
callRDR   ds   0h
         #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,             X
               RGSV=(R2-R8),PARMS=(id,msg1)
         la    r2,parms
         la    r4,treader
         b     callpgm
callWTR   ds   0h
       #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg2)X
               ,RGSV=(R2-R8)
         la    r4,twriter
*   only a mapout request will pass a message addr
         l     r1,16(r2)     msg address
         ltr   r1,r1         any message to display ?
         bz    callpgm
         st    r1,parm3      save the msg addr
         cli   20(r2),x'04'  msg length in next addr ?
         be    setMsgLn
calcMsgl ds    0h
         lhi   r6,1
         l     r5,24(r2)    msg end addr
         sr    r5,r1        calc the length
         st    r5,parm4     save it
         b     dspMsg
setMsgLn ds    0h
         lhi   r6,-1
         lhi   r5,-1
         l     r1,24(r2)     load the length itself
         st    r1,parm4      save it
dspMsg   ds    0h
*        #SNAP AREA=(parms,32),TITLE=' isptmapr parms',RGSV=(R2-R8)
callpgm  ds    0h
         #link pgm=(r4),parms=(parms),MODE=USER,RGSV=(R2-R8)
         ltr   r15,r15             all went well?
         b     returne
         bz    returne
         dc    0h                  0c4
returne  ds    0h
         #test MRBREAD,off=returnm
         #GETSTG TYPE=(USER,SHORT),len=rdrstgl,addr=(r3),              X
               RGSV=(R2-R8),COND=ALL,stgID='#rdr'
               using rdrstg,r3
         xr    r4,r4
         ic    r4,lmrbaid
         stc   r4,mrbaid      set the mrb aid byte
*        displayvar 'isptmapr set mrb aid to:',(r4)
         drop  r3
*        L     r15,CallnoMore      don't call rhdcmapr
returnm  ds    0h
       #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg3)X
               ,RGSV=(R2-R8)
        #RTNSTK =WORKAREL
return   ds    0h
        #RTN
*
id       msgtxt 'ISPTMAPR'
msg1     msgtxt 'RHDCMAPR - will call ISPTRDR'
msg2     msgtxt 'RHDCMAPR - will call ISPTWTR'
msg3     msgtxt 'before mapr return'
M#999011 DC    PL4'9990110'
OVRLOG   DC    X'8000000000'       #WTL to LOG only
*****
callNoMore dc  f'-1'
tdriver  dc    cl8'ISPTDR'
treader  dc    cl8'ISPTRDR'
twriter  dc    cl8'ISPTWTR'
        DROP  R12
         LTORG
         EJECT
*
*
*
*---------------------------------------------------------------------*
*- Internal workarea                                                 -*
*---------------------------------------------------------------------*
WORKAREA DSECT     must be rhdcmapr work addresses
*
parms      DS    0F                  subroutine call parms
parm1      ds    A    supposed to be ssc
parm2      ds    A    supposed to be mcon
parm3      ds    A    supposed to be MRB
parm4      DS    A    optional message  or addr of aidbyte
parm5      ds    F    message length
WORKAREL EQU   *-WORKAREA       LENGTH IN bytes

STCKAREA DSECT     must be rhdcmapr work addresses
*
SYSPLIST DS    32F

WKLEN    EQU   (*-STCKAREA+3)/4       LENGTH IN WORDS.
*
rdrstg   DSECT     return info passed by isptrdr
lmrbaid  DS    cl1
         ds    0f
rdrstgl  EQU   *-rdrstg            LENGTH IN WORDS.
*
         COPY #CSADS
         COPY #MRBDS
         COPY #TCEDS
         COPY #PTEDS
         COPY #PLEDS
         COPY #LTEDS
              #SSCTRL DSECT=YES
         END   ISPTMAPR
