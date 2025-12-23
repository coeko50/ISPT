VECSTOR  TITLE 'PREEMPT RHDCMAPR WITH ISPTMAPR FOR TCP/IP'
*---------------------------------------------------------------------*
         MACRO
&LABEL   #SAVEREG
&LABEL   ST    R12,0(,R13)         Save R12
         ST    R14,4(,R13)         Save R14
         STM   R2,R8,8(R13)        Save R2-R8
         LA    R13,9*4(,R13)
         MEND
*---------------------------------------------------------------------*
         MACRO
&LABEL   #RESTREG
&LABEL   LA    R12,9*4             Get register stack entry length
         SR    R13,R12             Get A(previous register stack entry)
         L     R12,0(,R13)         Restore R12
         L     R14,4(,R13)         Restore R14
         LM    R2,R8,8(R13)        Restore R2-R8
         MEND
*---------------------------------------------------------------------*
         MACRO
&LABEL   MSGTXT &TXT
         LCLC  &TMP
&TMP     SETC  '&SYSNDX'
&LABEL   DC    AL1(L2&TMP)
L1&TMP   DC    C&TXT
L2&TMP   EQU   *-L1&TMP
         MEND
**  CREATE ISPTMAPR HOOK FOR IDMS VECTOR  RHDCMAPR
**
         #MOPT CSECT=ISPTVECT,ENV=USER
         #ENTRY TVECTEP1
         LR    12,15
         USING TVECTEP1,R12
         USING CSA,R10
         USING TCE,R9
         USING WORKD,R11
         #GETSTG TYPE=(USER,SHORT),PLIST=*,LEN=WORKlen,                X
               ADDR=(R11),INIT=X'00'
*
         #LOAD PGM='ISPTMAPR',EPADDR=(R5),COND=ALL
*
         #HOOK OUT,HOOKID='ISPTMAPR',VECTOR=CSAMAPRA,LOC=(R5)
*
         LR   R2,R15
         LR   R1,R15
         L     R15,=A(CNVB2D8L)
         BASR  R14,R15             CONVERT NUMBER TO DECIMAL
         MVC   OUTAREAT,=CL30'ISPTMAPR VECTOR REMOVE RC='
         MVC   OUTAREAT+26(2),WORK2
         LA    R1,30
         STC   R1,OUTAREA          SAVE OUTPUT LINE LENGTH
         LA    R3,OUTAREA
         #WTL  MSGID=M#999010,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=((R3))
         ltr   r2,r2              was hook installed ?
         bz    return             then return, else install
HOOKIN   DS    0H
         #HOOK IN,VECTOR=CSAMAPRA,LOC=(R5),WHEN=BEFORE,                X
               HOOKID='ISPTMAPR',PLIST=SYSPLIST
         LR   R1,R15
         L     R15,=A(CNVB2D8L)
         BASR  R14,R15             CONVERT NUMBER TO DECIMAL
         MVC   OUTAREAT,=CL26'ISPTMAPR VECTOR INSERT RC='
         MVC   OUTAREAT+26(2),WORK2
         LA    R1,30
         STC   R1,OUTAREA          SAVE OUTPUT LINE LENGTH
         LA    R3,OUTAREA
         #WTL  MSGID=M#999010,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=((R3))
*
RETURN DS 0H
         #RETURN
         #BALI
         DROP  R12
M#999010 DC    PL4'9990100'
OVRLOG   DC    X'8000000000'       #WTL to LOG only
CNVB2D8L DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING CNVB2D8L,R12
         LA    R2,2                Number left justified
         B     CB2D8@00            Branch to common code
*
CB2D8@00 DS    0H
         LTR   R1,R1               Input value negative ?
         BM    CB2D8@10            Yes, translate it to hexadecimal
         C     R1,=F'99999999'     Input value > 99,999,999 ?
         BH    CB2D8@10            Yes, translate it to hexadecimal
         B     CB2D8@20            No,  translate it to decimal
*
CB2D8@10 DS    0H
         B     CB2D8@99            Exit
*
CB2D8@20 DS    0H
         CVD   R1,WORK1
         OI    WORK1+7,X'0F'
         UNPK  WORK2(9),WORK1+3(5)
         MVC   WORK2(8),WORK2+1    Shift value 1 byte to the left
         MVI   WORK2+8,C' '
         MVI   WORK2+9,C' '        Clear last 2 bytes from WORK2 field
*
         LTR   R2,R2               Number must be right justified ?
         BZ    CB2D8@99            Yes, all done
*
         LA    R14,WORK2
         LA    R15,7               Keep at least one zero
CB2D8@30 DS    0H
         CLI   0(R14),C'0'         A leading zero ?
         BNE   CB2D8@40            No
         LA    R14,1(,R14)         Yes, increment counter
         BCT   R15,CB2D8@30        Loop
*
CB2D8@40 DS    0H
         C     R2,=F'2'            Number must be left justified ?
         BE    CB2D8@60            Yes
*                                  No, replace all leading zeros
         LA    R14,WORK2
         LA    R1,8-1-1
         SR    R1,R15              Number of blanks (for execute)
         EX    R1,CB2D8EX2         Clear leading zeros
         B     CB2D8@99            Exit
*
CB2D8@60 DS    0H                  Number must be left justified
         EX    R15,CB2D8EX1        Shift decimal number to the left
         LA    R14,WORK2+1(R15)    Point behind decimal number
         LA    R1,8-1-1
         SR    R1,R15              Number of blanks (for execute)
         EX    R1,CB2D8EX2         Clear trailing characters
*
CB2D8@99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
CB2D8EX1 MVC   WORK2(*-*),0(R14)   Execute statement
CB2D8EX2 MVC   0(*-*,R14),=CL7' '  Execute statement
         COPY #CSADS
         COPY #TCEDS
         COPY #PDTDS
         COPY #NVTDS
WORKD    DSECT
SYSPLIST DS    6F
WORK1    DS    D                   Work fields for conversions
WORK2    DS    XL10                Work fields for conversions
*
OUTAREA  DS    X                   Output area length
OUTAREAT DS    CL40                OUTPUT AREA
WORKDL   EQU   (*-WORKD+3)/4
WORKlen  EQU   *-WORKD
         END
