*---------------------------------------------------------------------*
*- READ HTML SOURCE FROM THE DICTIONARY AND CALL A PROCESSING ROUTINE*
*- TO HANDLE THE LINE                                               -*
*-                                                                  -*
*- R1 > REQTBL                                                      -*
*- R5 > output buffer                                               -*
*- R11 - WORK AREA BASE                                             -*
*---------------------------------------------------------------------*
GETHTML  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING GETHTML,R12
*
*        r1 -> (-> namelen, -> name, ->outBuffer)
*
         l    r2,0(r1)                r2 =len of name
         l    r3,4(r1)                r3-> name
         l    r5,8(r1)                r5->outbuffer
         b    begin
*
*        @MODE MODE=IDMSDC,DEBUG=YES
*        @INVOKE SUBSCH=IDMSNWKA,SCHEMA=IDMSNTWK,VERSION=1
BEGIN DS 0F
         @BIND SUBSCH='IDMSNWKA',SCB=SSCTRL,DICTNAM='APPLDICT'
         @BIND REC='MODULE-067',IOAREA=MODULE_067
         @BIND REC='TEXT-088',IOAREA=TEXT_088
BINDRU   EQU   *
         @READY AREA='DDLDML',RDONLY=YES
         CLC   =CL4'0000',ERRSTAT
         BNE   IDMSERR
OBTAINC  EQU   *
         la    r15,mod_name_067
         MVi   0(r15),c' '                     clear the key
         MVC   1(31,r15),0(r15)
         ex    r2,movName                       set the calc key
         lr    r1,r2
GETH010  DS    0H                     edit the value inplace
         CLI   0(R15),C' '            uri deimiter ?
         BE    GETH040
         CLI   0(R15),C'/'            replace / or . with -
         BE    GETH020
         CLI   0(R15),C'.'
         BNE   GETH030
GETH020  DS    0H
         MVI   0(R15),C'-'
GETH030  DS    0H
         la    r15,1(r15)
         BCT   R1,GETH010
GETH040  DS    0H
**
         lh     r1,=h'1'
         sth    r1,MOD_VER_067          set default version to 1
*
         @OBTAIN CALC,REC='MODULE-067'
         CLC   =CL4'0000',ERRSTAT
         BNE   IDMSERR
OBNEXT   EQU   *
         @OBTAIN NEXT,SET='MODULE-TEXT'
         CLC   =CL4'0000',ERRSTAT
         BE    GETH050
         CLC   =CL4'0307',ERRSTAT
         BNE   IDMSERR
         B     RETURN
GETH050  EQU   *
         la    r0,80
         LA    R1,TEXT_088
         L     R15,=A(PROCHTML)     callback to process row
         BALR  R14,R15
         ltr   r15,r15              everyok down there?
         bnz   gethexit
         B     OBNEXT
RETURN   EQU   *
         @FINISH
         CLC   =CL4'0000',ERRSTAT
         SR    R15,R15                  SET CLEAN RC
         BE    GETHEXIT
IDMSERR  EQU   *
         L     R15,ERRSTAT
GETHEXIT DS  0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
movName  MVC   MOD_NAME_067(*-*),0(r3)
