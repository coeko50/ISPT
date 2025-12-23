         TITLE 'ISPTSRV - IDMS TCP Server'
* ISPTSRV RENT EP=TSERVEP
*---------------------------------------------------------------------*
*- IDMS TCP REST Server program user to service REST Api calls       -*
*-  ISPTSRV runs as a tcpip listener on a specific port.             -*
*-  it is invoked when the initial request is received               -*
*-  it does all the setup work, relate the endpoint to a program     -*
*-  then call the program.                                           -*
*-  when the program does a map-in or map-out the io exits are called-*
*-  to move data from the request to record buffers (map-in)         -*
*-  or from the record buffer to a json structure (map-out)          -*
*-                                                                   -*
*- GET,PUT,POST,DELETE are supported (or will be)                    -*
*-                                                                   -*
*---------------------------------------------------------------------*
        copy isptmac         the macros
         EJECT
ISPTSRV CSECT
         @MODE MODE=IDMSDC
         #MOPT CSECT=ISPTSRV,AMODE=ANY,RMODE=ANY,ENV=USER
         EJECT
*-                                                                   -*
*- The server program is started by a listener PTE (in user mode).   -*
*-    On input, R1 point to a 3 fullwords parameter list:            -*
*-     - A(string defined on the PARM parameter)                     -*
*-     - A(socket descriptor)                                        -*
*-     - A(resume counter)                                           -*
*-                                                                   -*
*- Registers usage:                                                  -*
*-   R5  = A(output buffer)                                          -*
*-   R6  = A(input buffer)                                           -*
*-   R9  = A(TCE)                                                    -*
*-   R10 = A(CSA)                                                    -*
*-   R11 = A(Work Area)                                              -*
*-   R12 = Base Register                                             -*
*-   R13 = A(Internal register stack area)                           -*
*-                                                                   -*
*- Main routines                                                     -*
*- =============                                                     -*
*- PROCSER  : process a SERVER command                               -*
*- PROCLIS  : run a SERVER program started by a LISTENER             -*
*-                                                                   -*
*- Common subroutines                                                -*
*- ==================                                                -*
*- CMPBUFFS : compare the contents of the IN and OUT buffers         -*
*- CNVB2D8  : convert a binary value to a decimal string (max 8 chr) -*
*- CNVB2D8B : same as CNVB2D8 + replace all leading 0 by blanks      -*
*- CNVB2D8L : convert a binary value to a decimal string left-just.  -*
*- CNVB2X   : convert a binary value to an hexadecimal string        -*
*- CNVD2B   : convert a decimal string to binary                     -*
*- DIS3RC   : display the 3 return codes from #SOCKET calls          -*
*- DISAREA  : display an output area to the terminal or log file     -*
*- DISLINE  : display an output line to the terminal of log file     -*
*- FREESTG  : free a storage area                                    -*
*- GETSTGU  : allocate a storage area of type USER                   -*
*- PARSREQ  : parse the HTTP request                                 -*
*- PARSTBL  : parse a Code table containing configuration info       -*
*- READLINE : tbd  an input command line                             -*
*- SOCKRECV : receive a message from a slave                         -*
*- SOCKSEND : send a message to a slave                              -*
*---------------------------------------------------------------------*
         ENTRY TSERVEP1
TSERVEP1 DS     0H
         basr  R12,0
         BCTR  R12,0
         BCTR  R12,0
        USING TSERVEP1,R12
*
         LR    R2,R1               Save A(input plist)
*
         #GETSTG TYPE=(USER,SHORT),PLIST=*,LEN=WORKAREL,               X
               ADDR=(R1),INIT=X'00'
*
         LR    R11,R1              Get A(workarea)
        USING WORKAREA,R11
         mvi   blanks,c' '
         mvc   blanks+1(l'blanks),blanks  clear it
         LA    R13,REGSTACK        Get A(register stack area)
         MVC   SrvLbl,=cl4'#SRV'
         MVC   SrvLble,SrvLbl
         mvc   m#disline,=PL4'9990100'
*
         displayMsg 'in ISPTSRV'
*
         lr    r1,r12
         la    r0,MOPTLEN
         sr    r1,r0
         mvc   pgmName,0(r1)        set the pgmname

         #reset pgmdebug
         LTR   R2,R2               Invoked by a user task code ?
         Bnz   SRVndb              Nope
         #set pgmdebug
*------------------------------------------------*
*- Program invoked by a user task code          -*
*------------------------------------------------*
         b     setdbg2
msg1     dc    c'GET /EMPinq.html HTTP'
msg1l    equ   *-msg1
msg2     dc    c'GET /EMPlC/query/html?EMPID=31'
         dc    x'50'
         dc    c'empfname=AapStert HTTP'
msg2l    equ   *-msg2
msg3     dc    c'POST /emplc/QuErY/json HTTP  Content-Length: 22'
         dc    c'    empId=1'
         dc    x'50'
         dc    c'empfname=kosie'
msg3l    equ   *-msg3
setdbg   DS    0H
*
setdbg2  DS    0H
         la    r0,msg2l
         la    r1,msg2
         ST    R0,CURLEN           Save length of parameters string
         ST    R1,CURPARMA         Save A(parameters string)
*
SRVndb   ds    0h
* allocate global memory
*
         la    r3,reqtblL       get  reqTbl size
         #GETSTG TYPE=(USER,SHORT,KEEP),LEN=(R3),ADDR=(R4),            X
               INIT=X'00',COND=ALL,stgID='#REQ',NWSTXIT=SRV120
         LTR   R15,R15             Request successful ?
         c     r15,=f'4'
         l     r0,(rqinpBufA-reqTbl)(r3) copy of Req to local
         st    r0,buffina
         l     r0,(rqinpBufl-reqTbl)(r3) copy of Req to local
         st    r0,buffinln
         bh    SRV900              >4 is a error for sure
SRV120   DS    0h
         st    r4,reqTblA          save the addr of newly acquired stg
         st    r3,reqTblLen
         using reqTbl,r4
         mvc   0(3,r4),=cl4'#REQ'
* set some defauts and endpoint tbla
         L     R15,=F'2097152'
         ST    R15,MAXMSGLN        Set max message length to 2MB
         la    R15,endpCTE         get addr endpoint code table entry
         st    R15,endpCTEa        save endpoint code table entry a
         la    R15,parsedEndpt     get addr of endpoint storage
         st    R15,endpointA       save it
         mvi   parsedEndPt,c' '
         mvc   parsedEndPt+1(l'parsedEndPt-1),parsedEndPt
*
*------------------------------------------------*
*- Program invoked by a listener PTE            -*
*------------------------------------------------*
*
         #test pgmdebug,on=SRV00
*------------------------------------------------*
*- Set the default parameters for the SERVER    -*
*- function, and parse the PARM string          -*
*------------------------------------------------*
         LR    R1,R2               Restore input R1
         L     R15,=A(PROCLIS)     initialize
         basr  R14,R15
         LTR   r15,r15             something went wrong
         Bnz   SRV900
*
*
*--------------------------------------------------------*
*- Main loop:                                           -*
*-   RECV from the client. If len = 0 exit              -*
*-   process the request                                -*
*-   SEND reponse                                       -*
*-   loop                                               -*
*--------------------------------------------------------*
SRV00    ds    0h
*
*------------------------------------------------*
*- Loop on RECV/SEND with a client program      -*
*------------------------------------------------*
         LA    R15,MSGFLAGD
        USING MSGFLAGS,R15
         MVI   MSGFLAG1,X'00'      Clear all message flags
         MVI   MSGFLAG2,X'00'
         MVI   MSGFLAG3,X'00'
         MVI   MSGFLAG4,X'00'
        DROP  R15
*
SRV100   DS    0H
*
         Call  SOCKRECV            Receive the message from the slave
*
         LTR   R15,R15             Request successful ?
         BNZ   SRVerr1             No, close the socket and exit
         CLC   RETLEN,=F'0'        RECV length = 0 ?
         BE    SRVerr2
*
         L     r8,buffinA
         using inpBuffer,r8       r8 -> inpBuffer
         L     R0,buffInLn        Get length message text
         C     R0,=F'120'          display max 120 bytes of req
         BNH   SRV110
         L     R0,=F'120'
SRV110   DS    0H
         L     R1,BUFFINA          Get A(input buffer)
         la    r1,(inpData-inpBuffer)(R1) r1-> text part
         Call  DISAREA             Display the data buffer
*
* split the request into method, uri, parms
* split the uri into webpage or endpoint and parms
* split the header into an key/value array and parms
         l     r0,buffInLn
         L     R1,BUFFINA          Get A(input buffer)
         drop  r8
*
         Call  PARSREQ               parse the request
*
         ltr   r15,r15             good return
         bnz   reqParsErr
         using inpBuffer,r8
         displayTxt 'After parse uri',requriLen,reqUriA
         displayTxt 'passed parms',reqParmLen,reqParmA
*
*  signin using the uid/pw send as part of header
*
doSignon  ds   0h
         displayMsg 'signing in'
         la    r1,SRB
         using   SECRB,r1
         #SECSGON RB=(R1),                                             X
               USERID='ISPDC',                                         X
               PASSWRD='DIRK123',                                      X
               RGSV=(R2-R8)
               drop  r1
               LTR  r15,r15   signon ok
               B    signonOk
               displayMsg 'signon failed'
*
signonOk  ds   0h
*
*  set the dictname and dbname from the line pte parms
*
         clc   dictname(8),blanks
         be    chkdbn
         MVC   in01$key,=CL8'DICTNAME'      we want to set dictname
         MVC   in01$val,BLANKS              Init SETPROF variable
         MVC   in01$val(8),dictname         set the value
         IDMSIN01 SETPROF,                                             X
               PVALUE=in01$key,                                        X
               PRESULT=in01$val,                                       X
               ERROR=msgin01
chkdbn   ds    0h
         clc   dbname(8),blanks
         be    nodbname
         la    r0,8
         la    r2,dbname
         displaytxt 'set dbname to ',(r0),(r2)
         MVC   in01$key,=CL8'DBNAME'        need to set DBNAME
         MVC   in01$val,BLANKS              Init SETPROF variable
         MVC   in01$val(8),dbname           and set it
         IDMSIN01 SETPROF,                                             X
               PVALUE=in01$key,                                        X
               PRESULT=in01$val,                                       X
               ERROR=msgin01
nodbname    ds 0h
         #TEST webReq,on=serveMime
* ------------------
*
* An Endpoint Request
*
* ------------------
*
SRV115   DS    0h
**       mvi   cycle,c'N'           default to new
*
SRV125   DS    0h
         mvi   callchain,x'00'
         #set  server              set server as the current process
         l     r0,buffinln
         st    r0,rqinpBufl
         l     r0,buffina
         st    r0,rqinpBufa

         using tce,r9
         l     r3,tceltea
*        #SNAP AREA=(0(R3),300),TITLE=' LTE:Bulkal01',RGSV=(R2-R8)
         mvc   srvTask,(ltenxtsk-lte)(r3)
         mvc   srvTask(1),(LTENXTK1-lte)(r3)
*
         displaytxt 'Current task',srvTask
*
         drop r9
*
*
*
*  get the endpoint entry
SRV150   DS    0h
         la   r1,parms
         la   r0,reqUri           key to search for
         st   r0,0(r1)
         st   r4,4(r1)            parm1 = reqtbla
         call EndpointLkup
         ltr   r15,r15
         bnz   srv900            endpoint lkup error occurred
         st    r1,endpointa        save the address
*
         #set  server                 last one active
*
         l      r7,endpointa
         using endpointt,r7
*
         #test  XferPgm,on=msg400
         #test  LinkPgm,on=msg410
         displayTxt 'Return Next Task',endpPgmNm
         b     MSG900
msgin01  ds    0h
         displayMsg 'idmsin01 reported an error'
         b     MSG900
msg400   ds    0h
         displayTxt 'Xfer control to program',endpPgmNm
         b     MSG900
msg410   ds    0h
         displayTxt 'Link to program',endpPgmNm
msg900   ds    0h
*
*
**       CLI    cycle,c'O'
**       be     callAds
         MVC   in01$key,=CL8'DBNAME'        need to set DBNAME
         MVC   in01$val,BLANKS              Init SETPROF variable
         IDMSIN01 GETPROF,                                             X
               PVALUE=in01$key,                                        X
               PRESULT=in01$val,                                       X
               ERROR=msgin01
         la    r0,8
         la    r2,in01$val
         displaytxt 'cur dbname =',(r0),(r2)
         #test  XferPgm,on=SRV400
         #test  LinkPgm,on=SRV410
         #test  NxtTask,on=SRV420
         b      xferErr          invalid transfer
*allAds  DS    0h
*        mvc   endpPgmNm,adspgm       call adsomain
SRV400   DS    0h
**  should check that PGM is defined and active - else respond with 400
*      send ok msg  or let twriter do it
*
         #XCTL  PGM=endpPgmNm
SRV410   DS    0h
*
         #LINK  PGM=endpPgmNm,PGNAXIT=xferErr
         b     SRV700
*callAds  ds    0h
*         la    r1,traceMsgt
*         L     R15,=A(disLine)    display sendbuff in log
*         basr  R14,R15
*         b     trace420
*traceMsgT msgTxt 'next task no other than ADS2 '
*trace420 ds    0h
*         mvc endpnxtsk,=cl8'ADS2 '
SRV420   DS    0h
** should check that task is defined and active - else respond with 400
*  send ok msg - or twriter should do it
*
         #RETURN NXTTASK=endpnxtsk
SRV450  DS    0h
         drop r7
*
*
* ------------------
*
* An WEB Request -- serve any of the supported mime types
*
* ------------------
ServeMime DS   0h
*
*** get some output buffer
         MVC   BuffOutL,=F'32768'  32k is it enough?
         L     R0,BuffOutL         Get length of messages to send
         L     R15,=A(GETSTGU)
         basr  R14,R15             Get space for the output buffer
         LTR   R15,R15             Allocate error ?
         BZ    mim010              Yes, close the socket and exit
         L     R15,=A(ClSock)
         basr  R14,R15             close the socket
mim010   ds    0h
         ST    R1,BUFFOUTA         Save A(output buffer)
*
        #test mimeICO,on=serveICO
        #test mimeHTML,on=serveHTML
        #test mimeJPG,on=serveDCLOD
*
         la    r1,tracemsg31
         mvc   16(1,r1),mimehtmli
         L     R15,=A(disline)    display sendbuff in log
         basr  R14,R15
         b     trace31
tracemsg31  msgtxt 'mime undefined x '
trace31   ds    0h
*
        b  unkwnMime                go and complain
*
ServeICO   ds    0h
           b   serveHTML      try it
ServeDCLOD ds  0h
* send error for now
         la    r0,l'notSupported
         la    r1,notSupported
         L     r15,=A(send400)
         basr  r14,r15
**       L     R15,=A(ClSock)
**       basr  R14,R15             Get space for the output buffer
         b     SRV900               close socket and exit
notSupported dc c'Not supported'
*
*-------------------------------
ServeHTML  ds  0h
*-------------------------------
*** get html and serve it
*
         la    r1,tracemsg3
         L     R15,=A(disline)    display sendbuff in log
         basr  R14,R15
         b     trace3
tracemsg3 msgtxt 'serve/HTML'
trace3   ds    0h
*
         la    r1,parms
         l     r0,reqUriLen        html name len
         st    r0,0(r1)            parm1 = html name
         l     r0,reqUriA          point to uri (html)
         st    r0,4(r1)            parm1 = html name
         sr    r5,r5
         st    r5,buffOutP         start from scratch
         l     R5,BUFFOUTA         Save A(output buffer)
         st    r5,8(r1)            parm2 = outbuffer address
         l     r15,=A(getHtml)
         basr  r14,r15             read html and populate buffer
         ltr   r15,r15             good return  ?
         bnz   htmlErr             nope a error
*
         b     trace4
         la    r1,tracemsg4
         L     R15,=A(disline)    display sendbuff in log
         basr  R14,R15
         b     trace4
tracemsg4 msgtxt 'after gethtml'
trace4   ds    0h
*
         l     r7,endPointa        just to make sure
         using EndpointT,r7
         la    r0,htmlMime         get the hdr type sendhdr
         l     r1,buffoutp         body length
         l     r15,=a(sendHdr)     send the http200 header
         basr  r14,r15             read html and populate buffer
*
         l     r1,buffOuta         load the buff to send
         l     r0,buffoutp        next pos to write
         st    r0,sendLen
*        l     r15,=A(ebc2asc)
*        basr  r14,15
         l     r1,buffOuta         load the buff to send
         B     SRV700
htmlMime dc    cl1'H'
*
*-------------------------------
SRV700   DS    0h
*-------------------------------
         L     R0,DWAIT            Get WAIT time value
         LTR   R0,R0               Any wait time requested ?
         BZ    SRV710              No
*
         #SETIME TYPE=WAIT,INTVL=(R0)
*
*
SRVSend  DS    0H
SRV710   DS    0H
         L     R15,=A(SOCKSEND)    r1->msg   sendlen=msg len
         basr  R14,R15             Send the message to the partner
         LTR   R15,R15             Request successful ?
         Bnz   SRV900              No, close the socket and exit
*
SRV800   DS    0H
         #test ServerErr,on=SRV900 exit on error, no loop
******   B     SRV00               Loop on RECV/SEND
         b   SRVEXIT2     just a test -- d not cose the connection
         b   SRV900
*
*------------------------------------------------*
* error routines
*------------------------------------------------*
*
srverr1    ds  0h
           displayMsg 'sockrecv error'
           b   srv900
srverr2    ds  0h
           displayMsg 'sockrecv error received 0 bytes'
           b   srv900
*
reqParsErr ds  0h
* respond http400
*
*
         displayMsg 'Parse Error'
         #set  ServerErr
         la    r0,l'parsErrMsg
         la    r1,parsErrMsg
         call  send400
         b     SRV900
parsErrMsg dc c'Parse Error'
*
unkwnMime ds  0h
* respond http400
*
         #set  ServerErr
         la    r0,l'unkwnMimMsg
         la    r1,unkwnMimMsg
         call  send400
         b     SRV900
unkwnMimMsg DC C'Unsupported Mime'
*
xferErr  ds 0h
* respond http400
*
         #set  ServerErr
         la    r0,l'invlXferMsg
         la    r1,invlXferMsg
         L     r15,=A(send400)
         basr  r14,r15
         b     SRV900
invlXferMsg ds c'Invalid transfer type, not T,X,L'
*
htmlErr  ds 0h
* respond http400
*
         #set  ServerErr
         la    r0,htmlErrMsgL
         la    r1,htmlErrMsg
         s     r15,errCode
         L     r15,=A(send404)
         basr  r14,r15
         b     SRV900
         ds    0f
htmlErrMsg  dc  cl32'HTML file not found, IDMS code:'
errCode     dc  c'xxxx'
htmlErrMsgL equ *-htmlErrMsg
*
*------------------------------------------------*
*- Close the socket                             -*
*------------------------------------------------*
SRV900    DS    0H
closeSock ds   0h
          L     r15,=a(clSock)      close the socket
          basr  r14,r15
*
SRVEXIT   DS    0H
*
TCPASMEX  DS    0H
          LA    R1,LISMSG02
          L     R15,=A(disline)
          basr  R14,R15             Display line

          l    r1,reqTblA
          ltr  r1,r1
          bz   SRVexit2
          #FREESTG STGID='#REQ'
SRVEXIT2  DS    0H
         l    r1,buffinA
         ltr  r1,r1
         bz   SRVexit4
         #FREESTG ADDR=(R1)
SRVEXIT4 DS    0H
         ltr  r11,r11
         bz   SRVexit6
         #FREESTG ADDR=(R11)
SRVEXIT6 DS    0H
         #RETURN
*
*
        DROP  R12
LISMSG02 MSGTXT '===> Exit. '
         LTORG
         EJECT
*
*---------------------------------------------------------------------*
*- Routine to run a SERVER program started by a LISTENER.            -*
*-   invoke a tcpread loop until 0 bytes read or the client closes   -*
*-   the connection, then shutdown operations                        -*
*-                                                                   -*
*-                                                                   -*
*-  1) validate the input parameter list                             -*
*-  2) Parse the input parameters                                    -*
*-  3) receive a HTTP message from the requester in the form of:     -*
*-     method uri version headers   *space seperated                 -*
*-  4) if the method is GET/PUT data send is part of the uri as parms-*
*-     for post it is in the header                                  -*
*-  5) if the uri does not contain a '.' it is processed as a endpoint*
*-     else it is a web request -- a few mime are supported          -*
*-  7) for a endpoint: lookup the endpoint in the endpoint table     -*
*-       prepare the #PRM memory block with tcp info and program info-*
*-       transfer control to requested program return next task      -*
*-  8) for a http request:                                           -*
*-     find and read a module by name of webpage-html                -*
*-     for mapless programs call twriter to                          -*
*-                                                                   -*
*- Input : R1  = A(parameter list received from the listener)        -*
*---------------------------------------------------------------------*
PROCLIS  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PROCLIS,R12
        #test pgmdebug,off=lis000
        l  r2,=A(parmval)
        b  lis018
parmval dc cl80'DEBUG=NO,DBNAME=APPLDICT'
*------------------------------------------------*
*- Validate the parameter list                  -*
*------------------------------------------------*
LIS000   DS    0H
         LTR   R1,R1               Parameter list present ?
         BNZ   LIS010              Yes
         displayMsg '===> Invalid parameter list.'
         B     LISERR              Exit
*
LIS010   DS    0H
         LM    R2,R4,0(R1)         Get the 3 parameters
         LTR   R2,R2               Parm 1 = A(PARM value) ?
         BNZ   LIS012              Yes
         displayMsg '===> Invalid PARM string parameter.'
         B     LISERR              Exit
*
LIS012   DS    0H
         LTR   R3,R3               Parm 2 = A(socket descriptor) ?
         BNZ   LIS014              Yes
         displayMsg '===> Invalid socket descriptor parameter.'
         B     LISERR              Exit
*
LIS014   DS    0H
         LTR   R4,R4               Parm 3 = A(resume counter) ?
         BNZ   LIS016              Yes
         displayMsg '===> Invalid resume counter parameter.'
         B     LISERR              Exit
*
LIS016   DS    0H
         MVC   OUTAREAT(18),=CL18'Socket-descriptor='
         L     R1,0(,R3)           Get the socket descriptor value
         ST    R1,SOCKDESC         Save it for the #SOCKET calls
         L     R15,=A(CNVB2D8L)
         basr  R14,R15             Convert number to decimal
         MVC   OUTAREAT+18(8),WORK2
*
         MVC   OUTAREAT+26(16),=CL16' Resume-counter='
         L     R1,0(,R4)           Get the counter value
         L     R15,=A(CNVB2D8L)
         basr  R14,R15             Convert number to decimal
         MVC   OUTAREAT+42(8),WORK2
*
         LA    R1,50
         STC   R1,OUTAREA          Save output line length
         LA    R1,OUTAREA
         L     R15,=A(DISLINE)
         basr  R14,R15             Display the input parameters
*
LIS018   DS    0H
         MVC   OUTAREAT(80),0(R2)  Move the PARM string
         LA    R1,80
         STC   R1,OUTAREA          Save output line length
         LA    R1,OUTAREA
         L     R15,=A(DISLINE)
         basr  R14,R15             Display the PARM string parameter
         la    r0,80               length of parm string
         lr    r1,r2               addr of parms
         call  parsparm            parse the parms
         b     lisExit
*------------------------------------------------*
*
LISEXIT  DS    0H
         sr    r15,r15             set the error
         B     LIS900              No, close the socket and exit
LISERR   DS    0H
         La    r15,1               set the error
         B     LIS900              No, close the socket and exit
LIS900   DS    0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller

*
        DROP  R4
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to input parameters.                                      -*
*- Input : R0  = length of input parameters string                   -*
*-         R1  = A(input parameters string)                          -*
*-  we are currently and for a long time in the future able to handle-*
*-    the following parms:                                           -*
*-      DEBUG    YES/NO                                              -*
*-      DBNAME   dbname                                              -*
*-      DICTNAME dictname                                            -*
*- Output: R15 = 0 or -1 in case of error                            -*
*---------------------------------------------------------------------*
PARSPARM DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PARSPARM,R12
        l     r5,reqtbla
        using reqTbl,r5
*
         LR    R3,R0               Get length of parameters
         LR    R2,R1               Get A(parameters)
         MVC   DWAIT(4),=F'0'      Set default WAIT value
         mvc   dbname(8),blanks
         mvc   dictname(8),blanks
         #reset debug
*------------------------------------------------*
*- Extract the next parameter                   -*
*------------------------------------------------*
PARSPA10 DS    0H
         LTR   R3,R3               Buffer exhausted ?
         BNP   PARSPA98            Yes, exit
*
PARSPA12 DS    0H
         CLI   0(R2),C' '
         Be    PARSPA14
         CLI   0(R2),C','
         BNE   PARSPA20
PARSPA14 DS    0H
         LA    R2,1(,R2)
         BCT   R3,PARSPA12         Skip all blanks
         B     PARSPA98            Exit if buffer exhausted
*
PARSPA20 DS    0H
**       displaytxt 'parm to find',(r3),(r2)
         LA    R15,6
         LA    R14,PARSDEBUG
         CLC   0(6,R2),=CL6'DEBUG='
         BE    PARSPA30            Process the DEBUG  parameter
*
         LA    R15,7
         LA    R14,PARSDBN
         CLC   0(7,R2),=CL7'DBNAME='
         BE    PARSPA30            Process the DBNAMAE parameter
*
         LA    R15,9
         LA    R14,PARSDICT
         CLC   0(9,R2),=CL9'DICTNAME='
         BE    PARSPA30            Process the DICTNAME parameter
*
         LA    R15,5
         LA    R14,PARSWAIT
         CLC   0(5,R2),=CL5'WAIT='
         BE    PARSPA30            Process the WAIT parameter
*
         displaytxt  'missing parm ',(r15),(r2)
         B     PARSPAR1            Unknown parameter: error exit
*
PARSPA30 DS    0H
         AR    R2,R15              Update input pointer
         SR    R3,R15              Update remaining length
         BR    R14                 Go process the requested parameter
*------------------------------------------------*
*- Process "DEBUG" parameter                    -*
*------------------------------------------------*
PARSDEBUG DS   0H
         LTR   R3,R3               Buffer exhausted ?
         BNP   PARSPAR6            Yes, error exit
*        displaytxt  'parmval',(r3),(r2)
         #reset debug   reset debug flags
         CLC   0(3,R2),=CL3'YES'
         be    PARSdbg1
         CLC   0(2,R2),=cl2'ON'
         BNE   PARSdbg2
         LA    R15,2
         b     PARSdbgd
PARSdbg1 DS    0H
         LA    R15,3
PARSdbgd DS    0H
         #set  debug               Set debug on
         B     PARSdbg6
PARSdbg2 DS    0H
         CLC   0(2,R2),=CL4'NO'
         Be    PARSdbg4
         CLC   0(3,R2),=CL4'OFF'
         BNE   PARSPAR5
         LA    R15,3
         B     PARSdbg5
PARSdbg4 DS    0H
         LA    R15,2
PARSdbg5 DS    0H
         #reset debug              Set debug off
         B     PARSdbg6
PARSdbg6 DS    0H
         AR    R2,R15              Update input pointer
         SR    R3,R15              Update remaining length
         B     PARSPA10            Goto process next parameter
*------------------------------------------------*
*- Process "DBNAME" parameter                   -*
*------------------------------------------------*
PARSDBN  DS    0H
         LTR   R3,R3               Buffer exhausted ?
         BNP   PARSPAR2            Yes, error exit
         LR    R4,R2               Get A(start dbname value)
         XR    R15,R15             Will contain dbname value length
PARSDBN2 DS    0H
         CLI   0(R2),C' '          End of DBNAME value ?
         BE    PARSDBN4            Yes
         CLI   0(R2),C','          End of DBNAME value ?
         BE    PARSDBN4            Yes
         LA    R2,1(,R2)           Increment pointer
         LA    R15,1(,R15)         Increment value length
         BCT   R3,PARSDBN2         Loop
PARSDBN4 DS    0H
         bctr  r15,0               bump length with 1
         ex    r15,movdbn
         B     PARSPA10            Goto process next parameter
movdbn   mvc   dbname(*-*),0(r4)
*
*------------------------------------------------*
*- Process "DICTNAME" parameter                 -*
*------------------------------------------------*
PARSdict DS    0H
         LTR   R3,R3               Buffer exhausted ?
         BNP   PARSPAR3            Yes, error exit
         LR    R4,R2               Get A(start dictname value)
         XR    R15,R15             Will contain dictname value length
PARSdic2 DS    0H
         CLI   0(R2),C' '          End of DBNAME value ?
         BE    PARSdic4            Yes
         CLI   0(R2),C','          End of DBNAME value ?
         BE    PARSdic4            Yes
         LA    R2,1(,R2)           Increment pointer
         LA    R15,1(,R15)         Increment value length
         BCT   R3,PARSdic2         Loop
PARSdic4 DS    0H
         bctr  r15,0               bump length with 1
         ex    r15,movdic
         B     PARSPA10            Goto process next parameter
movdic   mvc dictname(*-*),0(r4)
*
*------------------------------------------------*
*- Process "WAIT" parameter                     -*
*------------------------------------------------*
PARSWAIT DS    0H
         LTR   R3,R3               Buffer exhausted ?
         BNP   PARSPAR8            Yes, error exit
         LR    R4,R2               Get A(start WAIT value)
         XR    R15,R15             Will contain WAIT value length
PARSWAI2 DS    0H
         CLI   0(R2),C' '          End of WAIT value ?
         BE    PARSWAI4            Yes
         CLI   0(R2),C'0'          Digit ?
         BL    PARSPAR8            No, error exit
         CLI   0(R2),C'9'          Digit ?
         BH    PARSPAR8            No, error exit
         LA    R2,1(,R2)           Increment pointer
         LA    R15,1(,R15)         Increment value length
         BCT   R3,PARSWAI2         Loop
PARSWAI4 DS    0H
         LTR   R15,R15             WAIT value specified ?
         BZ    PARSPAR8            No, error exit
         CH    R15,=H'5'           WAIT value length > 4 ?
         BH    PARSPAR8            Yes, error exit
         LR    R0,R15              Get decimal string length
         LR    R1,R4               Get A(decimal string)
         L     R15,=A(CNVD2B)      Convert PORT value to binary
         BALR  R14,R15
         C     R15,=F'3600'        WAIT value > 3600 ?
         BH    PARSPAR8            Yes, error exit
         ST    R15,DWAIT           Save WAIT value
         B     PARSPA10            Goto process next parameter
*------------------------------------------------*
*- PARSPARM routine exit                        -*
*------------------------------------------------*
PARSPAR1 DS    0H
         LA    R1,PARSPAT1         Invalid input parameter
         B     PARSPA97
PARSPAR2 DS    0H
         LA    R1,PARSPAT2         Invalid dbname parameter value
         B     PARSPA97
PARSPAR3 DS    0H
         LA    R1,PARSPAT3         Invalid dictname parameter value
         B     PARSPA97
PARSPAR5 DS    0H
         LA    R1,PARSPAT5         Invalid deb parameter value
         B     PARSPA97
PARSPAR6 DS    0H
         LA    R1,PARSPAT6         invlaid r3     parameter
         B     PARSPA97
PARSPAR8 DS    0H
         LA    R1,PARSPAT8         Invalid WAIT parameter value
         B     PARSPA97
*
PARSPA97 DS    0H
         L     R15,=A(DISLINE)
         BALR  R14,R15             Display error message
         L     R15,=F'-1'          Set return code to -1
         B     PARSPA99
*
PARSPA98 DS    0H
         XR    R15,R15             Clear return code
*
PARSPA99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
PARSPAT1 MSGTXT 'Invalid input parameter.'
PARSPAT2 MSGTXT 'Invalid DBNAME parameter value.'
PARSPAT3 MSGTXT 'Invalid DICTNAME parameter value.'
PARSPAT5 MSGTXT 'Invalid DEBUG parameter value.'
PARSPAT6 MSGTXT 'Invalid R3  parameter value.'
PARSPAT8 MSGTXT 'Invalid WAIT parameter value.'
*
        DROP  R12
        DROP  R5
         LTORG
         EJECT
*---------------------------------------------------------------------*
*-  BUILD THE HTML OUTPUT BUFFER                                     -*
*-                                                                   -*
*- Input : R1  = A(CURRENT TEXT-088 ROW )                            -*
*-       : R5  = A(output buffer)                                    -*
*---------------------------------------------------------------------*
PROCHTML DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PROCHTML,r12
*        r0 = length               save input address
*        r1 -> data area to write  ignore
         l     r5,buffOuta
         a     r5,buffOutP         point to new pos to write
*        la    r0,l'SOURCE_088     length
*        la    r1,SOURCE_088       address
*
*        L     R15,=A(disArea)    display sendbuff in log
*        basr  R14,R15
*
         la    r0,l'SOURCE_088     length
         la    r1,SOURCE_088       address
         l     r15,=A(strlen)
         basr  r14,r15
*        r15 = length
         ex    r15,mov2Buff
         a     r15,buffOutP        add current offset
         st    r15,buffOutP        save if for next time
         lr    r1,r15
         sr    r15,r15
html900  DS    0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
mov2Buff mvc 0(*-*,R5),0(r1)
         LTORG
         EJECT
*
        DROP  R8
        DROP  R12
         LTORG
         EJECT
         copy  ISPTLODR
         copy  ISPTCOMM

*
         LTORG
         EJECT
         #BALI
         EJECT
*---------------------------------------------------------------------*
*- Internal workarea                                                 -*
*---------------------------------------------------------------------*
WORKAREA DSECT
*
srvLbl   DS    CL4
         DS    0F
REGSTACK DS    (7*9)F              Register stack area (5 entries)
REGSTKMX DS    0F                  Register stack area upper limit
*
SYSPLIST DS    16F
*
parms      DS    6F                  subroutine call parms
           org parms
prsStruct  DS   cl(parsBuffL)       prschar parameters
           org
*
*
*
*
reqTblLen   ds  a                  Request table length
reqTblCte   ds (codetblWrds)F      base for CodeTblEntry
*
           copy   isptdsc2
**cycle      ds   C
*
AdsPgm   DS    CL8
dictname ds    cl8
dbname   ds    cl8
pgmdebug  #flag x'01'
pgdbgflg ds    xl1
*
*
*     subschema control and so forth
*
*        @COPY IDMS,SUBSCHEMA-CTRL
                                 DS    0D
SSCTRL                           DS    0CL216
PGMNAME                          DC    CL8' '
ERRSTAT                          DC    CL4'1400'
DBKEY                            DS    FL4
RECNAME                          DC    CL16' '
AREANAME                         DC    CL16' '
ERRORSET                         DC    CL16' '
ERRORREC                         DC    CL16' '
ERRAREA                          DC    CL16' '
SSCIDBCM                         DS    0CL100
IDBMSCOM                         DS    100CL1
         ORG   SSCIDBCM
RDBMSCOM                         DS    0CL100
PGINFO                           DS    0CL4
PGINFGRP                         DS    HL2
PGINFDBK                         DS    HL2
                                 DS    CL96
DIRDBKEY                         DC    FL4'0'
DBSTATUS                         DS    0CL8
DBSTMTCD                         DS    CL2
DBSTATCD                         DS    CL5
                                 DS    CL1
RECOCCUR                         DC    FL4'0'
DMLSEQ                           DC    FL4'0'
****************************************
*        @COPY IDMS,RECORD=MODULE-067
                                 DS    0D
MODULE_067                       DS    0CL164
MOD_NAME_067                     DS    CL32
         ORG   MOD_NAME_067
FUNC_GROUP_067                   DS    0CL32
FUNC_GROUP1_067                  DS    0CL32
                                 DS    CL9
FUNC_NAME_IP_067                 DS    CL23
         ORG   FUNC_GROUP1_067
FUNC_GROUP2_067                  DS    0CL32
                                 DS    CL9
FUNC_REG_NAME_067                DS    CL8
                                 DS    CL1
FUNC_SYS_NAME_067                DS    CL8
                                 DS    CL6
         ORG   FUNC_GROUP1_067
FUNC_GROUP3_067                  DS    0CL32
                                 DS    CL18
FUNCTYP_067                      DS    CL6
                                 DS    CL8
                                 DS    0H
MOD_VER_067                      DS    HL2
DATE_LU_067                      DS    CL8
DESCR_067                        DS    CL40
BUILDER_067                      DS    CL1
DATE_CREATED_067                 DS    CL8
PREP_BY_067                      DS    CL8
REV_BY_067                       DS    CL8
LANG_067                         DS    CL40
TIME_LU_067                      DS    CL8
PUB_ACCESS_FLAG_067              DS    BL1
FLAG_067                         DS    CL1
                                 DS    CL1
                                 DS    0H
USER_COUNT_067                   DS    HL2
                                 DS    CL4
****************************************
                                 DS    CL4
*        @COPY IDMS,RECORD=TEXT-088
                                 DS    0D
TEXT_088                         DS    0CL84
                                 DS    0F
IDD_SEQ_088                      DS    FL4
SOURCE_088                       DS    CL80
****************************************
                                 DS    CL4
*
srb        DS  cl(SRBSPLEN)
srvLble  DS    CL4
WORKAREL EQU   *-WORKAREA
*
         COPY ISPTDSCT     * our defs
         COPY #TCEDS
         COPY #LTEDS
         COPY #PTEDS
         COPY #CSADS
         COPY #SECRB
         COPY #SECEQU
         COPY #STRDS
         COPY #MRBDS
*---------------------------------------------------------------------*
*- TCP/IP tables                                                     -*
*---------------------------------------------------------------------*
*
         #SOCKET TCPIPDEF
         #SOCKET ERRNOS
*
         END   TSERVEP1
