         TITLE 'ISPTRDR - RHDCMAPR MAPin for TCP'
* ISPTRDR RENT EP=TRDREP01
         copy isptmac
         EJECT
ISPTRDR CSECT
         @MODE MODE=IDMSDC
         #MOPT CSECT=ISPTRDR,ENV=USER,modno=5738,AMODE=31,RMODE=ANY
         EJECT
*---------------------------------------------------------------------*
*- Main code                                                         -*
*- =========                                                         -*
*- Write a datastream to TCP - either JSON or HTML                   -*
*- calls in a CA-IDMS/DC environment.                                -*
*-                                                                   -*
*- Flow:                                                             -*
*- 1. Get addressibility to Map records via MRB                      -*
*- 2. Determine record name for map record                           -*
*- 3. Read the Request-Control  mem              `                   -*
*- 4. Load mapping module  (json/html <-> record ele)                -*
*- 5. Load HTML load mod or read from dict (optional)                -*
*- 6a.Write JSON by write each element                               -*
*- 6b.Write HTML by looking up the element in mapping table          -*
*-                                                                   -*
*- Passed parameters are:                                            -*
*-  1. x'7F'                                                         -*
*-  2. MRB                                                           -*
*-  3. Message line address                                          -*
*-  4. Message line end                                              -*
*-  5. (SSC record binds) future                                     -*
*-                                                                   -*
*- Registers usage:                                                  -*
*-   R5  = A(output buffer)                                          -*
*-   R6  = A(Mapping tabl)                                           -*
*-   R9  = A(TCE)                                                    -*
*-   R10 = A(CSA)                                                    -*
*-   R11 = A(Work Area)                                              -*
*-   R12 = Base Register                                             -*
*-   R13 = A(Internal register stack area)                           -*
*-                                                                   -*
*- Main routines                                                     -*
*- =============                                                     -*
*-                                                                   -*
*- Common subroutines                                                -*
*- ==================                                                -*
*- BLDHTML  : build HTML output buffer                               -*
*- BLDJSON  : build JSON output buffer                               -*
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
*- LOADHTML : load HTML from module or dictionary                    -*
*- LOADTBL  : load a table                                           -*
*- PARSCMD  : parse the requested command                            -*
*- PARSPARM : parse the input parameters                             -*
*- SOCKSEND : send a response to the requester                       -*
*- SRCHTBL  : search table for json/html value                       -*
*- WRITEHDR : send HTTP headers to the requester                     -*
*---------------------------------------------------------------------*
         #ENTRY TRDREP01
*RDREP01 #START MPMODE=CALLER
*tRDREP01 DS 0h
*        STM   R14,R12,12(R13)      Save registers at entry
*        STM   R14,R12,0(r13)       Save registers at entry
         BALR  R12,0
         BCTR  R12,0
         BCTR  R12,0
         LR    R12,R15
        USING TRDREP01,R12
*        ST    R12,0(,R13)         Save R12
*        ST    R14,4(,R13)         Save R14
*        STM   R2,R8,8(R13)        Save R2-R8
        USING CSA,R10
        USING TCE,R9
*
         lr    r3,r13
*        LA    R13,9*4(,R13)
         LR    R2,R1               Save A(input plist)
*
         #GETSTG TYPE=(USER,SHORT),PLIST=*,LEN=WORKAREL,               X
               ADDR=(R11),INIT=X'00',RGSV=(R2-R8)
*
*         LR    R11,R1              Get A(workarea)
        USING WORKAREA,R11
         LA    R13,REGSTACK        Get A(register stack area)
         st    r3,r13Sav           save passed R13
         st    r2,parmlistA        saved parmlistA
         mvc   M#Disline,=pl4'9990300'
*
         using tce,r9
         using lte,r8
         l     r8,tceltea
         mvc   nxttask(8),ltenxtsk
         mvc   nxttask(1),LTENXTK1
***      st    r15,LTEnxtsk
***      mvi   LTEnxtk1,x'00'  illegal with stor prot and usermode
         l     r15,TCETDEA
         mvc   curTask,(TDETSKCD-tde)(r15)  save current task id
         drop  R8
         drop  R9
* analyse the parms
*
* set defaults
*
         displayMsg 'ISPTRDR started'
*
* PARMLIST: ssc, DCDMCON, MRB
* ---------
         l     r1,parmlistA        r1 -> parmsa
         l     r1,0(r1)            r1-> parmlist
parm01   ds    0h
         l     r8,4(r1)            R8-> MRB
         la    r8,0(r8)
         st    r8,MRBA             address of map that called us
         using MRB,R8
*
         lr    r1,r12               get the program name from the csect
         la    r0,MOPTLEN
         sr    r1,r0
         mvc   pgmname,0(r1)
*
*        L     R15,=F'2097152'
         L     R15,=F'32768'
*        L     R15,=F'6000'
         ST    R15,MAXMSGLN        Set max message length to 32k
*
         displayTvar 'Cur  Task=',curtask
         displayTvar 'Next Task=',nxttask
*
* figure out which records are the sources for output fields
*  this info is contained in a mapping table that is defined as
*  part of an endpoint. TServer looks up the request-endpoint in the
*  Endpoint table and passed that info via the #REQ storage block.
* steps are:
*
*  1. Load the Request Control storage  (#REQ) [it must exists]
*  2. read input parms as send by mapping
*  3. build the output data buffers either JSON or HTML
*  4. write appropiate headers and then the body to the socket
*  5. close your eyes and hope for the best
*
         la    r3,reqtblL       get  reqTbl size
         #GETSTG TYPE=(USER,SHORT,KEEP),LEN=(R3),ADDR=(R7),            X
               INIT=X'00',COND=ALL,stgID='#REQ',NWSTXIT=error400
* storage should exits
          b TRDR01
error400   ds 0h
***      mvc   debugflg,(debugReq-reqtbl)(r1)
***      #test debug,on=error400d
         displayMsg '#REQ storage not preAllocated'
         b  trdrexit                   close socket and exit
error400d  ds 0h
         la   r15,(JsonMapNm-reqtbl)(r7)
         mvc  0(8,r15),=cl8'TEMPMAP '
         la   r15,(outjson-reqtbl)(r7)
         mvc  0(8,r15),=cl32'Emp_Json'
*
*
*
TRDR01   ds    0h
         ST    R7,ReqTbla          save the address for later
         using  reqtbl,r7
*
         displayMsg '#REQ allocated'
*
*  if the previous process on call chain was the server, process the
*  msg else do a recv and process. it will only be for a ads dialog
*
         #TEST SERVER,on=TRDR015   server was previous in call chain
         b  trdr020                writer was previous in chain
TRDR015  ds    0h
* previous in callchain is server  - realloc the input buffer
         #GETSTG TYPE=(USER,SHORT,KEEP),ADDR=(R1),                     X
               COND=NO,stgID='#BUF',NWSTXIT=error500
         l     r0,rqInpBufL
         st    r0,buffinln
         st    r1,buffina
         c     r1,rqInpBufA        same same?
         be    trdr400       process the parms
         displayMsg '#BUF length differ'
         b  trdrexit                   close socket and exit
error500   ds 0h
         displayMsg '#BUF not pre allocated'
         b  trdrexit                   close socket and exit

TRDR020  ds    0h
         displayMsg 'not pre-empt by server - will do SockRecv'
* clear all flags
         LA    R15,MSGFLAGD
        USING MSGFLAGS,R15
         MVI   MSGFLAG1,X'00'      Clear all message flags
         MVI   MSGFLAG2,X'00'
         MVI   MSGFLAG3,X'00'
         MVI   MSGFLAG4,X'00'
        DROP  R15

* free current #buf if exists
         #freestg stgid='#BUF'
         sr    r0,r0
         st    r0,rqInpBufL
         st    r0,buffinln
         st    r0,rqInpBufA
         st    r0,buffina

         Call  SOCKRECV
*
         LTR   R15,R15             Request successful ?
         BNZ   trdr170             No, close the socket and exit
         CLC   RETLEN,=F'0'        RECV length = 0 ?
         BE    trdr170             display and exit
         CLC   RETLEN,=F'5'        RECV length < 5 ?
*  command=exit?
         BL    trdr170             display and exit
**    parse the received message
*
* split the request into method, uri, parms
*   parms may be part of the uri or message header (body) or both
* split the uri into webpage or endpoint and parms
* split the header into a key/value array and parms
*
         displayMsg 'before parseReq'
         displayTxt 'ReqstBuffer',buffinln,buffina
         l     r0,buffInLn
         L     R1,BUFFINA          Get A(input buffer)
*
         Call  PARSREQ               parse the request
*
         ltr   r15,r15             good return
         bnz   reqParsErr
         l     r6,buffina          inputbuffer
         using inpBuffer,R6        r6 -> input buffer
         displayTxt 'uri',requriLen,reqUriA
         displayTxt 'parms',reqParmLen,reqParmA
*
* the endpoint will contain the program name & type, aid key
*  however, if the caller is the Map then the MRBname must match that
*           of the endpoint.
         using MRB,r8
         #TEST SERVER,on=trdr200
  displayTxt 'reader cycle - find mapname in uri',reqUriLen,reqUriA
         l    r15,reqUriA
         la   r2,8                      map name is max 8
trdr100  ds    0h
         cli  0(r15),c'/'               end of uri 1st qual?
         be   trdr115                   break
         la   r15,1(r15)                prev char maybe
         bct  r2,trdr100                decrement the length
TRDR115  ds    0h
         lr    r5,r15                   save current address
*        #SNAP AREA=(0(R5),12),TITLE=' mapnam',RGSV=(R2-R8)

*** 25/10/02  commment mapname check
*        la    r1,8
*        sr    r1,r2
*        bctr  r1,0                     bump len for compare
*        l     r15,reqUriA
*        ex    r1,CmpUriMrb
*        bne   trdr320
*** 25/10/02  commment mapname check
** if a mapuri and no parms then execute the control key
         clc   reqParmLen,=f'0'         any request parms ?
         bne   trdr200
         clc   bdyParmLen,=f'0'         any bodyparms?
         bne   trdr200
** find the control key name -- as part of the uri
*
*        #SNAP AREA=(0(R5),12),TITLE=' fndkey',RGSV=(R2-R8)
         la    r2,5                     key name max 5
*        DISPLAYtxt 'find control key',(r2),(r5)
         la    r1,5                     key name max 5
         lr    r15,r5
         cli   0(r15),c'/'              at a '/'
         bne   trdr150
         la    r5,1(r5)                 next char
         la    r15,1(r15)               next char
trdr150  ds    0h
         cli   0(r15),c' '              at a '/'
         be    trdr160
         cli   0(r15),c'/'              at a '/'
         be    trdr160
         la    r15,1(r15)               next char
         bct   r1,trdr150
trdr160  ds    0h
*
         lr    r2,r15
*        #SNAP AREA=(0(R5),12),TITLE=' key   ',RGSV=(R2-R8)
         lr    r15,r2
*
         sr    r15,r5                   convert to length
         bctr  r15,0                    bump the length
         ex    r15,mvcAidByt
         displaytxt 'Set control key and exit ',(r15),(r5)
         call  clSock
         b     trdr505                  go set the aidbyte and exit
cmpUriMrb clc  0(*-*,r15),mrbname       uri = mrb?
mvcAidByt mvc  aidbyte(0),0(r5)       move aidbyte
*
trdr170  ds    0h
         DISPLAYMSG 'will set pa1 control key to force exit'
         call  clSock
         mvc   aidbyte(4),=cl4'PA1'    convert to length
         b     trdr505                  go set the aidbyte and exit
*
*
TRDR200  ds    0h
*
*  lookup the uri, hlq=mapname in the endpoint table to get the name of
*   json maptbl
*
        la   r1,mappingCTE
        st   r1,endpCTEa         save the address
        la    r3,srchCtlPrm
        using srchCtl,r3
        l    r1,reqUriA          key to search for
        st   r1,srchKeyA
        l    r1,reqUriLen
        st   r1,srchKeyLn
*       displayvar 'reqUriLen:',reqUriLen
*    displayTxt 'in endpointlkp-searchKey',srchKeyLn,srchKeyA
        drop  r3
        la   r1,parms
        st   r3,0(r1)            srchCtl (ln,Key)
        l    r7,reqTblA          r7-> reqtbl
        st   r7,4(r1)            parm1 = reqtbla
*****
         la    R15,parsedEndpt     get addr of endpoint storage
         st    R15,endpointA       save it
         mvi   parsedEndPt,c' '    and clear it
         mvc   parsedEndPt+1(l'parsedEndPt-1),parsedEndPt
*****
         call EndpointLkup
         ltr   r15,r15
         bnz   trdr345           endpoint lkup error occurred
         st    r1,endpointa        save the address
*
         displayMsg 'after Parse'
         b     trdr400      process the message
*
trdr320  ds    0h
         l     r1,reqUriA
         mvc   tempname,0(r1)
         displayTvar 'Mapin map name does not match ReqUri',mrbname,   X
               tempname
         b     trdr390       for now
trdr340  ds    0h
         lr    r1,r15
** convert to display
         displayMsg 'Error with Socket Receive len=0, rc=xx'
         b     trdr390       for now
trdr345  ds    0h
         lr    r1,r15
         displayMsg 'error loading endpoint'
         b     trdr390       for now
trdr390   DS    0H
          call  clSock              close the socket
*
*
          displayMsg 'Close connection '

          l    r1,reqTblA
          ltr  r1,r1
          bz   trdr394
          #FREESTG STGID='#REQ'
trdr394   DS    0H
         ltr  r11,r11
         bz   trdr396
         #FREESTG ADDR=(R11)
trdr396 DS     0H
         #RETURN
          drop  r8
*
reqParsErr ds  0h
*
*
*
trdr400  ds    0h
**       #SNAP AREA=(0(R2),32),TITLE=' rdr r2  ',RGSV=(R2-R8)
**       #SNAP AREA=(0(R3),32),TITLE=' rdr r3',RGSV=(R2-R8)
         l     r8,MRBA              get the address of the MRB
**     #SNAP AREA=(0(R8),3048),TITLE=' rdr MRB?',RGSV=(R2-R8)
**     #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg1)
trdr405  ds    0h
         l     r8,MRBA              get the address of the MRB
         using MRB,R8
         lr    r5,r8                r5-> mrb
         ah    r5,MRBMREO           r5 -> 1st MRE
         ah    R5,MRBRECOF          R5 -> 1 rec addr
         st    r5,olmRecListA       save addr to map rec list
         l     r4,0(r5)             point to 1st record in list
**         #SNAP AREA=(0(R5),128),TITLE=' rdr MRB-rec',RGSV=(R2-R8)
         st    r4,olmRecA           save the address
         lh    r3,MRBNRECS          number of records
         st    r3,olmNRecs          save it
*        #SNAP AREA=(0(R4),64),TITLE=' rec1',RGSV=(R2-R8)
*
* copy control info from #req to local storage
*
         mvc SOCKDESC,SOCKDESCg      copy sock info from reqtbl
         mvc SOCKDESA,SOCKDESAg
***      mvc debugFlg,debugReq       set debug flag from server
         mvc   PrevCallChain,callchain  save the previous value
         mvi   callchain,x'00'
         #set  reader                set the writer as the curr proc

         #test debug,on=dbug1
         la   r1,debugno
         b    dbug2
dbug1    ds   0h
         la   r1,debugact
dbug2    ds   0h
         l    r15,=a(disLine)
         balr r14,r15
         b    dbugEnd
debugact  msgtxt 'debugging active'
debugno   msgtxt 'debugging off'
dbugEnd  ds   0h
*
*  load the map loadmodule to relate load addresses to record name
*
         #LOAD  PGM=MRBNAME,type=MAP,RGSV=(R2-R8),EPADDR=(R1)
         st     r1,mrbA            save map loadmodule address
         using  MCH,r1
         la     r0,MCHRNAMS        start of record names
         st     r0,olmRecNmA       save the address
         drop   r1
*
* load the mapping module that links JSON to internal names
         #test server,on=trdr501
         displayTvar 'Mapping Table Name',jsonMapNm
         #LOAD  PGM=JsonMapNm,type=TABLE,RGSV=(R2-R8),EPADDR=(R6)
         b   trdr501
*
trdr501  ds    0h
*
         st    r6,jsonMapA        save the address
*
         displayMsg ' do mapin.'
*
         l     r6,buffina          inputbuffer
         using inpBuffer,R6        r6 -> input buffer
*
*        #SNAP AREA=(0(R6),64),TITLE=' req fields',RGSV=(R2-R8)

         l     r15,reqParmLen       any reqparms passed ?
         ltr   r15,r15
         bz    trdr502

         la    r1,parms
         l     r0,ReqTbla
         st    r0,0(r1)            1st parm = reqtbla
*
         st    r15,4(r1)            2nd parm - req parm length
         l     r0,reqParmA         r0 ->  request parms
         st    r0,8(r1)            3rd parm - reqPArma
*        st    r6,12(r1)           r6-> codetable load address
*
         call MAPIN                move fields from buffer to rec
         b    trdr503
*
trdr502  ds    0h
         displaymsg 'no request parms passed'
trdr503  ds    0h
         #test bdyParms,on=trdr504     bdyparms passed ?
         displayMsg ' no bdyparms'
         b trdr505
trdr504  ds    0h
         displayMsg ' do bdyparms'
*        l     r1,bdyParma
*        #SNAP AREA=(0(R1),128),TITLE=' bdyParms',RGSV=(R2-R8)
         la    r1,parms
         l     R0,ReqTbla
         st    r0,0(r1)           reqtbla
         l     r0,bdyParmLen       get the length
         st    r0,4(r1)            store itas the 3rd parm
         l     r0,bdyParmA         addr of bodyParms
         st    r0,8(r1)            r-> parmflds
*        st    r6,12(r1)           r6-> codetable load address
         call  MapinJson           move fields from buffer to rec
         la  r15,mjbworkstg
*        #SNAP AREA=(0(R15),256),TITLE=' idms rec fields',RGSV=(R2-R8)
trdr505  ds    0h
         call SetAidbyt    set the aidbyte in the MRB
         b     trdrexit
*
trdrexit DS    0H
*
         displayMsg 'return to caller'
*
exit     ds  0h
*        #FREESTG stgID='#REQ'       free req tbl
*        l      r1,buffOutA          free the buffer
*        ltr    r1,r1
*        bz     exit2
*        #FREESTG addr=(r1)

exit2    ds  0h
         ltr    r11,r11
         bz     exit99
         b   exit99
**
EXIT99   ds 0h
** ret code needed because called directly from cobol
         l     r3,r13sav
**       #SNAP AREA=(0(R3),48),TITLE=' caller regs',RGSV=(R2-R8)
         displayMsg  'ISPTRDR on exit'

         #FREESTG ADDR=(R11)         free working storage
         lr    r15,r5         return the aidbyte
         #RETURN
*
        drop  r7
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to insert the aid byte into the MRB                       -*
*-                                                                   -*
*-  1) R8 -> MRB                                                     -*
*-  2) R11-> ReqTbla -> #req                                         -*
*---------------------------------------------------------------------*
SetAidByt DS   0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING setAidByt,R12
         l     r7,reqTblA          r7 base for reqTbl
         using reqTbl,r7
         #GETSTG TYPE=(USER,SHORT),len=rdrstgl,addr=(r3),              X
               INIT=X'00',COND=ALL,stgID='#rdr'
*        ltr   r15,r15
*  test for errors
         using rdrstg,r3
         La   r1,aidKeys
sab000   ds   0h
         clc   aidByte,0(r1)
         be    sab001
         la    r1,5(r1)      next key
         clc   ENDA,0(r1)
         bne  sab000         loop a bit
sab001   ds   0h
**stgprotmvc   MRBAID,4(r1)  move in the aid
         ic    r15,4(r1)
         stc   r15,lmrbAid     save the aidbyte for isptmapr to set
         la    r3,aidbyte
         la    r4,lmrbAid
         displayTxt 'set aid byte for ',l4,(r3),l1,(r4)
         xr    r4,r4
         ic    r4,lmrbaid
         displayvar 'mrb aid:',(r4)
         b     sab004
sab004   DS    0H
         b     setAidXit
l4       dc   f'4'
l1       dc   f'1'
aidKeys  ds   0h
         DC C'ENTE'
ENTERAID DC    C''''
         DC C'CLEA'
CLEARAID DC    C'_'
         DC C'PF1 '
PF1AID   DC    C'1'
         DC C'PF2 '
PF2AID   DC    C'2'
         DC C'PF3 '
PF3AID   DC    C'3'
         DC C'PF4 '
PF4AID   DC    C'4'
         DC C'PF5 '
PF5AID   DC    C'5'
         DC C'PF6 '
PF6AID   DC    C'6'
         DC C'PF7 '
PF7AID   DC    C'7'
         DC C'PF8 '
PF8AID   DC    C'8'
         DC C'PF9 '
PF9AID   DC    C'9'
         DC C'PF01'
PF01AID  DC    C'1'
         DC C'PF02'
PF02AID  DC    C'2'
         DC C'PF03'
PF03AID  DC    C'3'
         DC C'PF04'
PF04AID  DC    C'4'
         DC C'PF05'
PF05AID  DC    C'5'
         DC C'PF06'
PF06AID  DC    C'6'
         DC C'PF07'
PF07AID  DC    C'7'
         DC C'PF08'
PF08AID  DC    C'8'
         DC C'PF09'
PF09AID  DC    C'9'
         DC C'PF10'
PF10AID  DC    C':'
         DC C'PF11'
PF11AID  DC    C'#'
         DC C'PF12'
PF12AID  DC    C'@'
         DC C'PF13'
PF13AID  DC    C'A'
         DC C'PF14'
PF14AID  DC    C'B'
         DC C'PF15'
PF15AID  DC    C'C'
         DC C'PF16'
PF16AID  DC    C'D'
         DC C'PF17'
PF17AID  DC    C'E'
         DC C'PF18'
PF18AID  DC    C'F'
         DC C'PF19'
PF19AID  DC    C'G'
         DC C'PF20'
PF20AID  DC    C'H'
         DC C'PF21'
PF21AID  DC    C'I'
         DC C'PF22'
PF22AID  DC    C'½'
         DC C'PF23'
PF23AID  DC    C'.'
         DC C'PF24'
PF24AID  DC    C'<'
         DC C'PA01'
PA01AID  DC    C'%'
         DC C'PA02'
PA02AID  DC    C'>'
         DC C'PA03'
PA03AID  DC    C','
ENDA     DC CL4'ENDA'
         DC    C''''
          DROP   r7
SetAidxit ds   0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         ltorg
*
*---------------------------------------------------------------------*
*- Routine read through the passed paramaters and populate data      -*
*-   records                                                         -*
*-  1) Parse the input parameters                                    -*
*-  2) write the value of each entry to the appropiate record buffer -*
*-                                                                   -*
*-  parms:                                                           -*
*-   1. reqTblA                                                      -*
*-   2. length of parameter String                                   -*
*-   3. Address of string containing parameters                      -*
*-   4. Address of the loadmodule containing json-mapfield mapping   -*
*---------------------------------------------------------------------*
MAPIN DS       0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING mapin,r12

*
         l     r6,0(r1)
         using  reqTbl,r6        r6-> reqTbl
         l     r7,4(r1)          r7 = length of parmfields
         l     r2,8(r1)          r2-> passed parmfields
         la    r3,parmCtlStg     r3-> ParmCtl
         using  parmCtl,r3
*
         ltr    r7,r7            any parms to replace ?
         bz     parmexitok
*
         displayMsg 'in mapin'
*
*  pattern is: varnm=value&   -- last field value end with buffer end
*
varBegin ds    0h
         st    r2,parmNameA        variable name address
         la    r0,0
         st    r0,parmNameLn
loop1    ds    0h
         cli   0(r2),c'='          assignment?
         be    varEnd
         la    r2,1(,r2)           next char
         bct   r7,loop1
         b     parmerr1            error
varEnd   ds    0h
*
         lr    r1,r2
         s     r1,parmNameA            calc the length
         st    r1,parmNameLn           save variable name length
*
         la    r2,1(,r2)           bump the =
         st    r2,parmValA         save value start Addr
         bctr  r7,0                decrease the length
         ltr   r7,r7               end of life
         bz    parmsEnd
*
loop3    ds    0h
         cli   0(r2),X'50'         at '&' ==> end of value
         be    valEnd
*** values may contain spaces -- end of parm string will be crlf
*** or length parm exceeded
*        cli   0(r2),c' '          at ' ' ==> end of value
*        be    valEnd
         la    r2,1(,r2)           next char
         bct   r7,loop3            decrease the length
         b     valEnd              end of this parm & parms
valEnd   ds    0h
         lr    r1,r2
         s     r1,parmValA              calc the length
         st    r1,parmValLn             save it
*
         la    r2,1(r2)             point over the &
         st    r2,curpos            save the current position
* ignore 0 length str or if the value starts with %24%7B
         l     r1,parmValln
         bz    noRepl
         l     r1,parmValA
         clc   0(6,r1),=c'%24%7B'
         be    noRepl
*
         displayTxt 'parmKey',parmNameln,parmnamea,parmValln,parmValA
         lr    r1,r3               r1->parmCtlStg
         CALL  movParm2rec         move value to record buffer
         ltr   r15,r15
         bnz   parmerr2            error
noRepl   ds    0h
         l     r2,curpos            reset ourselfs
         ltr   r7,r7                if at zero - exit
         bz    parmexitok
         bct   r7,varbegin
         b     parmexitok          and exit
*
parmerr1 ds    0h
         displayMsg 'Parameter format error'
         l     r15,=f'-1'
         b     parmexit
*
parmerr2 ds    0h
         displayMsg 'Parameter replacement error'
         l     r15,=f'-2'
         b     parmexit
parme2x  ds    0h
*

parmExitOk DS  0H
         xr    r15,r15              rc = 0
parmexit DS    0H
parmsEnd DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         ltorg
         drop  R3
         drop  R6
*---------------------------------------------------------------------*
*- Routine read process data passed as part of the request body      -*
*-   data is passed as a json document                               -*
*-  Json object:                                                     -*
*-   Data is in name/value pairs                                     -*
*-   Data is separated by commas                                     -*
*-   Curly braces hold objects                                       -*
*-   Square brackets hold arrays                                     -*
*-                                                                   -*
*-  json document structure:                                         -*
*-  {                      -- document start                         -*
*-     "objectname": { data-properties } ,                           -*
*-   data-properties:                                                -*
*-     "fieldname" : value    ,                                      -*
*-     "fieldname" : numValue ,                                      -*
*-     "fieldname" : "character value"   ,                           -*
*-     "fieldname" : { "subfield" : value, ... } , -- structure      -*
*-     "fieldname" : [ arrayVal1, arrayVal2 .... ], -- array         -*
*-   }  end of document
*-     value = numvalue, charValue or structure                      -*
*-     arrayval: numvalue, charvalue, structure                      -*
*-                                                                   -*
*-  { "trec" : { "lvl1" : { "nval" : 5, "cval" : "string",           -*
*-     "struct" : { "snval" : 5, "ssval" : "string" }                -*
*-   , "numArray" : [ 1,2,3 ],"StrArray" : ["a","b"]                 -*
*-   , "sarray" : [ { "a" : 5, "b" : "str"                           -*
*-         , "subst" : { "nam" : "name" , "lastn": "lastname"}},...] -*
*-      } , ..... }                                                  -*
*-                                                                   -*
*-  1) Parse the input parameters                                    -*
*-  2) write the value of each entry to the appropiate record buffer -*
*-                                                                   -*
*-  parms:                                                           -*
*-   1. reqTblA                                                      -*
*-   2. length of body parms                                         -*
*-   3. Address of body parms                                        -*
*-   4. Address of the loadmodule containing json-mapfield mapping   -*
*---------------------------------------------------------------------*
MapinJson DS   0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING MapinJson,r12

*  we keep track of nesting by keep track of { and [ tokens
*  or actually waiting for their closures } and ]
*
         l     r6,0(r1)
         using  reqTbl,r6        r6-> reqTbl
         l     r7,4(r1)          r7 = length of bodyfields
         l     r5,8(r1)          r5-> passed bodyfields
         la    r3,parmCtlStg     r3-> ParmCtl
         using  parmCtl,r3
*
         ltr    r7,r7            any parms to replace ?
         bz     mjbExitok
*
         displayMsg 'in MapinJson'
         st    r5,buffinp           save r5 as current pointer
         ar    r5,r7
         st    r5,buffine           save it as buffer end address
         l     r5,buffinp
*
*  pattern is: { "var" : value , .... } value = num, "str" {struct}
*
* scan for {
mjb0010  ds  0h
         cli   0(r5),c'{'          begin of json document
         be    mjb0100
         la    r5,1(,r5)           next char
         bct   r7,mjb0010
         b     mjberr1             report dull document
*
mjb0100  ds  0h
         la    r5,1(r5)            point to next char
         xr    r0,r0
         la    r15,mjbWorkStg
         st    r0,(mjbCurJEleA-mjbWork)(r15)  clear it
         la    r1,parms
         st    r15,0(r1)            pass work storage
         call  scanforKeyVal       scan for a key value pair
*                              on return r15=0  value type in r1
         b    mjbExitOk
mjberr1  DS  0H
         xr    r15,r15
         bctr  r15,0                rc=-1
         b     mjbExit
mjbExitOk DS  0H
         xr    r15,r15              rc = 0
mjbExit  DS    0H
mjbEend  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
*---------------------------------------------------------------------*
*- ScanforKeyVal - scan for a fldname , value pair                   -*
*-    input: r5 -> current buffer pos                                -*
*-                                                                   -*
*---------------------------------------------------------------------*
scanforKeyVal  ds  0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING scanForKeyVal,r12
         l     r6,0(r1)            work stg address
         using mjbwork,r6
         la    r1,mjbstack
         st    r1,mjbstackp        init pointer
*
skv0010  ds    0h
         st    r5,buffinp           save pos
*
skv0011  ds    0h
**       l     r5,buffinp
         lr    r1,r5                start point for scan
         call  scanforFldNam        scan for a key literal
         ltr   r15,r15              on exit r1-> literal r0=len
         bnz   skverr1
         l     r5,buffinp           r5->next char after closing "
* dont know if this is needed
         la    r2,parmCtlStg
         st    r0,(parmNameLn-parmCtl)(r2)  save fieldnm len
         st    r1,(parmNameA-parmCtl)(r2)   save fieldnm address

         la    r3,srchCtlPrm
         using srchCtl,r3
         st    r0,srchKeyLn      key length
         st    r1,srchKeya       searchkey = fldname start
**       la    r8,64
**       displaytxt 'current fldname',srchkeyln,srchkeya,(r8),(r5)
         la    r1,parms
         l     r0,jsonMapA     loadmod addr
         st    r0,0(r1)
         l     r0,mjbCurGrpA   load the current json grp
         st    r0,4(r1)        current grp ele
         st    r3,8(r1)        search parms - json key

         call  findRecEle     find rec ele in jsonmap
         ltr   r15,r15           R1->CUR ELE
         bnz   skverr7
         st    r1,mjbCurJEleA          save cur ele
skv0100  ds    0h
         call  scanfor            next non white char
         ltr   r15,r15
         bm    skvexit               end of buffer  ???
         lr    r5,r1                 r5->curpos
         cli   0(r5),c':'            key/value seperator
         bne   skverr1c         a big error, i must say
         la    r5,1(r5)              skip pass
         call  scanfor               scan for the next token
         ltr   r15,r15
         bm    skvexit               end of buffer  ???
         lr    r5,r1                 r5->curpos
*
skv0101  ds    0h
         cli   0(r5),c'['            on exit r1->char
         bne   skv0200
* '['
         la    r5,1(r5)                next char
         #set  #array
         #set  #1stEle
*      set mjbstack
         l     r1,mjbstackp
         la    r1,1(r1)                nxt pos
         mvi   0(r1),c'['              set the level
         st    r1,mjbstackp
*      set occ lvl
         lh    r1,mjbocclvl
         la    r1,1(r1)                add 1 to the lvl
         ch    r1,=x'1'                exceed max occ levels
         bh    skverr3
         sth   r1,mjbOccLvl            save new level
*      reset occ counts
         xr    r1,r1
         cli   mjboccLvl+1,x'01'     we at level 0
         bh    skv0102
         sth   r1,mjbOcc
         mvc   mjbOccEleA,mjbCurJEleA
skv0102  ds    0h
         sth   r1,mjbOcc+2
         mvc   mjbOccEleA+4,mjbCurJeleA
* if  not a group we need to process each value till ]
*
skv0150  ds    0h
         call  scanfor
         ltr   r15,r15
         bm    skvexitOk
         lr    r5,r1
*
skv0200  ds    0h
         cli  0(r5),c'{'           a struct ?
         bne   skv0300
* '{'
         la    r5,1(r5)                next char
         #set  #1stEle
         l     r1,mjbstackp
         la    r1,1(r1)                nxt pos
         mvi   0(r1),c'{'              set the level
         st    r1,mjbstackp
         b     skv0010              read next literal
         drop  r3
*
skv0300  ds    0h
         call  scanfor
         ltr   r15,r15             end of buffer ?
         bm    skvexit
         lr    r5,r1

         cli  0(r5),c'}'           end of structure
         bne   skv0400
* '}'
         la    r5,1(r5)                next char

         l     r1,mjbstackp
         cli   0(r1),c'{'          closing a { ?
         bne   skverr6
         mvi   0(r1),c' '          closing
         bctr  r1,0                pop a level
         st    r1,mjbstackp

         l     r1,jsonmapa
         l     r2,mjbCurGrpa      we need to pop the grp
         lh    r3,(jeParent-jele)(r2) get the parent
         ar    r3,r1
         st    r3,mjbCurGrpa
         b     skv0300              read next literal
*
skv0400  ds    0h
         cli  0(r5),c']'           end of occurs ?
         bne   skv0500
         la    r5,1(r5)                next char
* ']'
         xr    r0,r0
         lh    r1,mjbOcclvl         r1=cur occ lvl
         bct   r1,skv0402           bump it
         sth   r0,mjbOcc            init the occ counters
         #reset #array
skv0402  ds    0h
         sth   r0,mjbOcc+2
         ltr   r1,r1
         bm    skverr5               level went negative
         sth   r1,mjbOcclvl          save the level
*
         l     r1,mjbstackp
         cli   0(r1),c'['          closing a { ?
         bne   skverr6
         mvi   0(r1),c' '          closing a [
         bctr  r1,0                pop a level
         st    r1,mjbstackp
*
         b     skv0300
*
*    ','
*
skv0500  ds    0h
         cli  0(r5),c','           continiuation ?
         bne   skv0600
         la    r5,1(r5)                next char
* ','
         l     r1,mjbstackp
         cli   0(r1),c'{'           in a struct ?
         be    skv0010
         cli   0(r1),c'['           at array inc pt ?
         bne   skv0010              not a struct or array, key then
* we expect an occursfield
* incr array counters for current lvl
         cli   mjbOccLvl+1,x'01'      lvl1 or 2?
         be    skv0518
         bh    skv0520
         b     skverr8
skv0518  ds    0h
         lh    r1,mjbOcc              incr level 1
         la    r1,1(r1)
         sth   r1,mjbOcc
         l     r15,mjbOccEleA         r15->current occurs ele
         b     skv0525
skv0520  ds    0h
         lh    r1,mjbOcc+2           incr level 2
         la    r1,1(r1)
         sth   r1,mjbOcc+2
         l     r15,mjbOccEleA+4       r15->current occurs ele
skv0525  ds    0h
         ch    r1,(jeOcc-jele)(r15)  compare with lvl  max
         bnl   skverr4             report an error
skv0550  ds    0h
         st    r5,buffinp
         b     skv0150             scan for next token { or value
*
skv0600  ds    0h
         cli  0(r5),c'"'           char value?
         bne   skv0700
* '"'
         lr    r1,r5
         call  scanforCharVal     buffinp->next char
         ltr    r15,r15           everything went ok?
         bm     skverr1d
         l      r5,buffinp        r5-> next pos
         la     r2,parmCtlStg
         st     r0,(parmValLn-parmCtl)(r2)  save field len
         st     r1,(parmvalA-parmCtl)(r2)   save field address
         la     r1,parms
         st     r2,0(r1)                   1st parm - data value
         st     r6,4(r1)                   2nd parm mjbWork
         call  movDtaIn
         ltr   r15,r15
         bm    skverr2
         b     skv0300         next char should be , } ]
skv0700  ds    0h
*  must be a numeric value
         call  scanforNumVal        all info stored in parmctl
         ltr   r15,r15
         bm    skverr2
         la    r1,parms
         la    r2,parmCtlStg
         st    r2,0(r1)                   1st parm - data value
         st    r6,4(r1)                   2nd parm mjbwork
         call  movDtaIn
         ltr   r15,r15
         bm    skverr2
         l     r5,buffinp
         b     skv0300          next char should be , } ]
*
skverr1 ds    0h
         l     r15,=f'-1'
         b     skverr1x
skverr1a ds    0h
         l     r15,=f'-2'
         b     skverr1x
skverr1c ds    0h
         l     r15,=f'-4'
         b     skverr1x
skverr1d ds    0h
         l     r15,=f'-5'
         b     skverr1x
skverr1x ds    0h
         displayvar 'r15=',(r15)
         la    r3,srchCtlPrm
         using srchCtl,r3
         la    r8,64
         sr    r5,r8
         sll   r8,1       x 2 == 128
         displaytxt 'current fldname',(r8),(r5),srchkeyln,srchkeya
         l     r15,=f'-1'
         b     skvExit
*
skverr2 ds    0h
         lr    r3,r15
         displayVar 'Parameter replacement error',(r3)
         l     r15,=f'-2'
         b     skvExit
skverr3 ds    0h
         la    r3,srchCtlPrm
        displayTxt 'Json occurence level of 2 exceeded',srchKeyLn,     X
               srchKeya
         l     r15,=f'-3'
         b     skvExit
skverr4 ds    0h
         la    r3,srchCtlPrm
        displayTxt  'Json subscript Exceeds record subscript',         X
               srchKeyln,srchKeya,(r8),(r5)
         l     r15,=f'-4'
         b     skvExit
skverr5 ds    0h
         la    r3,srchCtlPrm
         la    r8,64
         sr    r5,r8
         la    r8,64(r8)
        displayTxt  'Json subscript went negative ',                   X
               srchKeyln,srchKeya,(r8),(r5)
         l     r15,=f'-5'
         b     skvExit
skverr6 ds    0h
****** 25/10/02  begin  -- if }
         la    r1,mjbstack
         c     r1,mjbstackp
         be    skvExitOk         exit if at beginning of stack
****** 25/10/02  end
         la    r3,srchCtlPrm
         la    r8,128
         sr    r5,r8
         la    r8,128(r8)
        displayMsg  'Closing ] } does not correspond with open [ {',   X
               srchKeyln,srchKeya,(r8),(r5)
         l     r15,=f'-6'
         b     skvExit
skverr7 ds    0h
         la    r3,srchCtlPrm
         la    r8,64
         sr    r5,r8
         la    r8,64(r8)
        displayTxt  'Jsonfield not found in mapping table',            X
               srchKeyln,srchKeya,(r8),(r5)
         l     r15,=f'-7'
         b     skvExit
skverr8 ds    0h
         la    r3,srchCtlPrm
         la    r8,64
         sr    r5,r8
         la    r8,64(r8)
        displayTxt  'Comma placement wrong',                           X
               srchKeyln,srchKeya,(r8),(r5)
         l     r15,=f'-8'
         b     skvExit
skve2x  ds    0h
*

skvExit  DS    0H
         st    r5,buffinp
         l     r1,buffine
         sr    r5,r1
         bm    skvEnd
skvExitOk DS  0H
         xr    r15,r15              rc = 0
skvEnd   DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         ltorg
         drop  R3
         drop  R6
*
*---------------------------------------------------------------------
*
*---------------------------------------------------------------------*
*- ScanforFldNm & ScanforCharVal are using the same code             -*
*- as they both locate the value within quotes                       -*
* parms:                                                             -*
*    input r1 -> next position in buffer
* on output r1-> start of token
*           r0-> length of the token
*           buffinp -> next position after the ending "
*---------------------------------------------------------------------*
scanforCharVal ds  0h
scanforFldNam  ds  0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING scanForFldNam,r12
         call   scanFor        position at the next non blank
         ltr    r15,r15
         bm     sftErrExit
         l      r15,buffine       end address
         sr     r15,r1            length remaining
         lr     r5,r1             set r5 -> buf pos
         cli    0(r5),c'"'        is must be a " to mark the start
         be     sft0010
         b      sftErrExit
sft0010  ds     0h
         la     r5,1(r5)          point to char after 1st "
         lr     r2,r5             save the start aadr
sft0020  ds     0h
         cli    0(r5),c'"'        locate ending "
         be     sft0030
         la     r5,1(r5)          r5->next char
         bct    r15,sft0020       and loop
         b      sftExit           report an error
sft0030  ds     0h
         lr     r15,r5
         sr     r15,r2
         la     r5,1(r5)          point 1 pass the "
         st     r5,buffinp
         lr     r0,r15            the length
         lr     r1,r2             start loc
sftExitok ds    0h
         xr     r15,r15
sftErrExit  ds     0h
sftExit  ds     0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
*---------------------------------------------------------------------
*
*---------------------------------------------------------------------
* scan for a numeric value
*---------------------------------------------------------------------
*
scanforNumVal  ds 0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING scanForNumVal,r12
         call   scanFor        position at the next non blank
         ltr    r15,r15
         bm     sfnErrExit
         lr     r5,r1
         l      r15,buffine       endaddress
         xr     r0,r0
         la     r2,parmCtlStg
         using  parmCtl,r2
         st     r0,parmDptA        init
         ic     r0,parmSignInd
* verify that we do have a number, 1st digit  should be sign or 0-9
* if decimal we will need 0.xxx
         lr     r1,r5             save start pos
         cli    0(r5),c'-'        check if leading char is a sign
         be     sfn0008
         cli    0(r5),c'+'
         bne     sfn0010          if must be a digit then
sfn0008  ds     0h                we have a number
         mvi    parmSignInd,x'01' mark the value as signed
         la     r5,1(r5)          point passed the sign
sfn0010  ds     0h
         cli    0(r5),c'.'        decimal point
         be     sfn0018           thats ok
         cli    0(r5),c'0'
         bl     sfn0014           not numeric
         cli    0(r5),c'9'
         bh     sfnerr1           report an error
         b      sfn0020           a valid char then
sfn0014  ds     0h
         cli    0(r5),c' '        lookfor a ' '
         be     sfn0030
         cli    0(r5),c','        lookfor a ,
         be     sfn0030
         cli    0(r5),c'}'        lookfor a }
         be     sfn0030
         cli    0(r5),c']'        lookfor a ]
         be     sfn0030
         cli    0(r5),x'0D'       lookfor a cr
         be     sfn0030
         cli    0(r5),x'0A'       lookfor a lf
         be     sfn0030
         b      sfn0020
sfn0018  ds     0h
         st     r5,parmDptA       save decimal point address
sfn0020  ds     0h
         la     r5,1(r5)          point to next char
         cr     r15,r5            buffer overrun?
         bh     sfn0010           nope, still good
         xr     r15,r15
         bctr   r15,0             set error
         b      sfnExit
sfn0030  ds     0h
* parmNameln,parmnamea,parmValln,parmValA
         st     r1,(parmvalA-parmCtl)(r2)   save field address
         lr     r15,r5
         sr     r15,r1
         st     r15,(parmValLn-parmCtl)(r2)  save field len
         b      sfnexit

sfnerr1  ds 0h
*        displayTvar 'invalid number value for ',jejsonfld
         xr   r15,r15
         bctr r15,0
sfnErrExit ds 0h
sfnexit  ds 0h
         st     r5,buffinp
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop   r2
*
*
*---------------------------------------------------------------------
* SCANFOR the next character that is not white space ' ' cr or lf
*  Scan for the next character that is not a space, CR or LF
*  Parms: R5 ->current offset in buffin
*         r15 -  get clobbert
*  return:
*  r5 - offset of the next token
*  r15 - 0 ok, -1 error
*  incidently  buffinp will also be updated
*---------------------------------------------------------------------
scanfor      ds   0h
*
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING scanFor,r12
         l      r15,buffine       end address
         sr     r15,r5            length left
sfc0010  ds     0h
         cli    0(r5),c' '        a blank
         be     sfc0020
         cli    0(r5),lcr         cr
         be     sfc0020
         cli    0(r5),llf         lf
         be     sfc0020
         cli    0(r5),x'00'       lowly values
         bne    sfcexitok         at a non-whitespace char
sfc0020  ds     0h
         la     r5,1(r5)
         bct    r15,sfc0010       buffer overrun ?
         bctr   r15,0             make it -1
         b      sfcexit
sfcexitok ds    0h
         xr     r15,r15
sfcexit  ds    0h
         lr     r1,r5             return pos in r1
         st     r5,buffinp
         #restreg
         br     r14               return
*---------------------------------------------------------------------*
*
*  lookup the jsonkey within the json mapping loadmod
*   parm1 -> jsonloadmodule
*   parm2 -> current position in loadmod struct
*         -> if not zero search will only iterate over
*         -> the children of current entry if it is a group
*         -> if the current entry is not a group, pop to the grp
*         -> and iterate
*         -> this allow for indirect qualification of elements with
*         -> their group names in the idms record
*   parm3 -> search key
*
*  on exit - r15=0 find was ok
*  r1 -> the jeEle entry with jsonfld = srchkey
*---------------------------------------------------------------------*
*
findRecEle   ds 0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING findRecEle,r12
*
         l   r4,0(r1)              r4 -> jsonloadmod
         using jschema,r4
         l   r6,4(r1)              r6 -> current jeEle
         using jEle,r6
         l   r7,8(r1)              r7 -> srchCtl
         using srchctl,r7
*
* prepare the search key
*   r3 = srchkey len
*   r2 = srchkey address
*
         l    r2,srchKeyA
         l    r3,srchKeyln
         bctr r3,0                         bump the length for compare
         lr   r0,r3
         lr   r1,r2
         call ucase                        convert to upper
*
         displayTxt 'srchEle:',srchKeyLn,srchKeyA
         ltr  r6,r6                 grp ele passed?
         bnz  fre250                yes
*
*  search through record names or all the schema elements
*
fre008   ds   0h
         la   r5,jSchemaLn(r4)        r5->point to 1st rec
*
*   r2-> search key  r3 = length to the key
*
         lh   r8,(jsrecCnt-jSchema)(r4)  # of recs
fre010   ds   0h
         ex   r3,mvcRecnm
         lr    r0,r3                  recname length
         la    r1,lTblKey             name address  (local)
         call ucase
         ex   r3,clcRecnm
         be   fre900
         la   r5,jrecLn(r5)                  r5->next rec
         bct  r8,fre010
* jsonname was not a record name
         lh   r8,(jsEleCnt-jSchema)(r4)         element count
         lh   r5,(jsEleOffset-jSchema)(r4)      offset to 1st ele
         ar   r5,r4                         convert to address
         b    fre020
mvcRecnm mvc  lTblKey(0),(jrecname-jrec)(r5)    move from lmod to local
mvcEleNm mvc  lTblKey(0),(jeJsonfld-jele)(r5)   move from lmod to local
clcRecnm clc  0(*-*,r2),lTblKey                 check record names
clcEleNm clc  0(*-*,r2),lTblKey                 check jsonfld names
fre020   ds   0h
         ex   r3,mvcElenm                    move name to wrk stg
         lr    r0,r3                         elename length
         la    r1,lTblKey                    name address  (local)
         call ucase
         ex   r3,clcElenm                    check jsonfld names
         be   fre900
         la   r5,jEleLn(r5)                  r5->next ele
         bct  r8,fre020
         b    freErr1                        gaan klik
*
*  group ele (parent) passed with the key
*   search through all the children to find the ele
*
fre250   ds  0h
** r6 -> jele  = a grp element
**  the grpEle can be of type record or ele
         lh  r1,jsEleOffset       offset to element list
         ar  r1,r4                address
         cr  r1,r6                is the address passed a rec or ele?
         bnl fre300               it is a ele
         lh  r5,(jreleOffset-jRec)(r6)  get offset to 1st child
         b   fre310
fre300   ds  0h
         lh  r5,je1stchild        offset to 1st child
fre310   ds  0h
         ar  r5,r4                 r5-> 1st child
         ex   r3,mvcElenm                    check jsonfld names
         lr    r0,r3                         elename length
         la    r1,lTblKey                    name address  (local)
         call ucase
         ex   r3,clcElenm                    check jsonfld names
         be  fre900                yip then exit
         lh  r5,(jeNext-jEle)(r5)    next ele
         ltr r5,r5                 lst one?
         bm  fre350                set -1 rc
         b    fre310               and loop
fre350   ds  0h         search up the stack
         lh  r1,jsEleOffset       offset to element list
         ar  r1,r4                address
         cr  r1,r5                is current ele a record?
         bh  fre360               it is a rec
         lh  r6,(jeParent-jEle)(r5)  get the parent and retry
         ar  r6,r4                 convert to real address
         b   fre250
fre360   ds  0h         search up the stack
         xr  r6,r6      no group passed
         b   fre008
*
*  if there was a record switch ?
*
fre900   ds  0h
         lr  r3,r5                      r3->cur jEle
         la    r2,mjbWorkStg
         st   r3,(mjbCurJEleA-mjbWork)(r2) save jele addr
         lhi    r1,32
         displayTxt 'curJele:',(r1),(r3)
fre910   ds  0h
         cli   (jeGrpInd-jEle)(r3),c'Y' is it a group?
         bne   fre915
         st    r3,(mjbCurGrpA-mjbWork)(r2)   save new group
fre915   ds  0h
         cli (jeParentType-jEle)(r3),RecNode  is the record the parent?
         be  fre920                      jip
         lh  r3,(jeParent-jEle)(r3)      get the parent offset
         ar  r3,r4                       make it a real address
         b   fre910                      pop a level
fre920   ds  0h
         lh  r3,(jeParent-jEle)(r3)      get the parent offset
         ar  r3,r4                       make it a real address
         la     r1,32
         displayTxt 'curJeleRec:',(r1),(r3)
         c   r3,(mjbCurJrecA-mjbWork)(r2)   same as previous rec?
         be  fre940
         st     r3,(mjbCurJrecA-mjbWork)(r2)   save new address
         la     r1,32
         displayTxt 'new curRec:',(r1),(r3)
** lookup the corresponding idms record address and save it
         la     r1,parms
         st     r3,0(r1)               1st parm ->   json mapele entry
         l      r0,olmNRecs            # of records
         st     r0,4(r1)               2nd parm = rec count
         l      r0,olmRecNmA           list of map rec names
         st     r0,8(r1)               3rd parm -> list of record names
         l      r0,olmRecListA           list of rec bind addresses
         st     r0,12(r1)           4th parm -> list of rec bind addr's

         call   findMapRec          r1 -> idms rec buff addr
         ltr    r15,r15
         bm     freErr2
         la    r15,mjbWorkStg
         st     r1,(mjbCurRecA-mjbWork)(r15) save the IDMS rec addr
         l      r2,(mjbCurRecA-mjbWork)(r15)
*        #SNAP AREA=(0(R2),48),TITLE=' IDMSRec',RGSV=(R2-R8)
fre940   ds  0h
         xr  r15,r15
         lr  r1,r5                r1->jele entry  or rec entry
         b  freExit
*
*
*
freErr1  ds  0h
         la   r7,64
         sr   r5,r7
         la   r7,64(r7)
         displayTxt 'JsonField passed not in Mapping table',(r7),(r5)

         xr   r15,r15
         bctr r15,0
         b   freExit
freErr2  ds  0h
         displayMsg 'JsonREc - maprec not found'

         lhi  r15,-2
         b   freExit
freExit      ds 0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop   r7
*lcr      equ    c'`'
lcr      equ    x'0D'
*llf      equ    c'~'
llf      equ    x'0A'
*---------------------------------------------------------------------*
*
*
*  lookup the key and move parm data to record
*   parm1 -> parmCtl : key +  replacement value
*   mappingCTE -> endpoint entry
*   jsonMapA -> mapping load module
*
*   iterate over the records, and then its fields until
*   a jsonfield is found with the same name as the key.
*   use that info to move the value to the idms record buffer
*   At a later stage we will define the parm as jsonrec.jsonfld
*
*---------------------------------------------------------------------*
*
movParm2rec DS 0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING movParm2rec,R12
*
         lr    r2,r1                   save the parm
         using parmCtl,R2              r3->parm ctl
         displayTxt 'in movParm2rec',                                  X
               parmNameln,parmnamea,parmValln,parmValA
* *****
         la    r3,srchCtlPrm
         using srchCtl,r3
         l     r0,parmNameLn
         st    r0,srchKeyLn      key length
         l     r0,parmNameA
         st    r0,srchKeya       searchkey = fldname start
**       la    r8,64
**       displaytxt 'current fldname',srchkeyln,srchkeya,(r8),(r5)
         la    r1,parms
         l     r0,jsonMapA     loadmod addr
         st    r0,0(r1)
         xr    r0,r0           search to start from the top
         st    r0,4(r1)        current grp ele = 0
         st    r3,8(r1)        search parms - json key

         call  findRecEle     find recEle for parmfld using jsonmap
         ltr   r15,r15           R1->CUR ELE
         bnz   prtprmE

* -      st    r1,(mjbCurRecA-mjbWork)(r15) save the IDMS rec addr
* -      st    r1,mjbCurJEleA          save cur ele
*
* *****
        displayMsg 'back from parm.findRecEle'
*
*   at this point of the game mjbWork contains all the info we
*   need. ie. point to current json ele
*      and a pointer to target idms record buffer
*
movDta1  ds    0h
         displayMsg 'before call to movdtaIn'
         la    r1,parms
         la    r0,parmCtlStg     r3-> ParmCtl
         st    r0,0(,r1)              r3->parmctl (parmname+value)
         la    r0,mjbWorkStg          desc of the field to move
         st    r0,4(,r1)
*
         Call  MovDtaIn               move to rec buffer
**       displayMsg 'after  call to movdtaIn'
         la    r15,mjbWorkStg          desc of the field to move
         lr    r2,r15
*        #SNAP AREA=(0(R2),48),TITLE=' MJBwork',RGSV=(R2-R8)
         l     r2,(mjbCurRecA-mjbWork)(r15) save the IDMS rec addr
*        #SNAP AREA=(0(R2),48),TITLE=' recwith parm',RGSV=(R2-R8)
         xr    r15,r15
         b     mov2r950
         b     prtprm1

prtprmE  ds    0h
         st    r15,r15Sav
         displayTxt 'Parm not found in maptbl',parmNameLn,parmNameA
         l     r15,r15Sav              restore original code
         b     prtprm1
*
prtprm1  ds    0h
         st    r15,r15Sav
         l     r1,parmNameA
         l     r2,parmNameLn
         c     r2,=f'8'
         bnh   prtprm2
         la    r2,8
prtprm2  ds    0h
         bctr  r2,0
         bm    mov2r950
         ex    r2,pnammvc
         l     r1,parmValA
         l     r2,parmValLn
         c     r2,=f'8'
         bl    pshtr
         la    r2,8
pshtr    ds    0h
         bctr  r2,0
         ex    r2,pvalmvc
         la    r1,parmtxt
         l     r15,=a(disline)
         balr  r14,r15
         l     r15,r15Sav              restore original code
         drop  r3
mov2r950 DS    0H
*  r15 has the return code, pass it to caller
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
pnammvc  mvc   pnam(*-*),0(r1)
pvalmvc  mvc   pval(*-*),0(r1)
parmtxt  dc  AL1(parmtxtl)
         dc  c'parm name:'
pnam     dc  cl8'________'
         dc  c'parm val:'
pval     dc  cl8'________'
parmtxtl equ *-parmtxt
         dc  cl128' '
         ltorg
         drop r6
*
*
*---------------------------------------------------------------------*
*- move data from input buffer to record buffer  --                  -*
*- for numeric fields do a conversion first                          -*
*---------------------------------------------------------------------*
MOVDtaIn DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING MOVDTAIn,R12
         l  r3,0(,r1)        r3 -> parm field
         l  r6,4(,r1)        r6 -> mjb work
         using jEle,r2
         using parmCtl,r3
         using mjbWork,r6
** base recele and idms record

         l  r2,mjbcurJEleA   r2 -> the corresponding json mapping fld
         l  r4,mjbCurRecA    r4 -> IDMS data record buffer

         displayTxt 'in MovDtaIn',parmNameLn,parmNameA
*        #SNAP AREA=(0(R3),parmCtlL),TITLE=' parmCtl',RGSV=(R2-R8)
*        #SNAP AREA=(0(R6),mjbworkl),TITLE=' mjbWork',RGSV=(R2-R8)
*
* check data type if 0 or 1 move directly
*
*
normalfld ds   0h
** handle occurs
         cli   jeOcclvl+1,x'00'
         be    movd005            no occurs
         ah    r4,jeOccOffset      add occurs base offset
         lh    r15,mjbOcc          level 1 occ count
         mh    r15,jeOccSize       convert to a rel offset
         ar    r4,r15              adjust for level 1 occur
         cli   mjbOccLvl+1,x'01'    at level 1
         be    movd006            then we are done
         lh    r15,mjbOcc+2        level 1 occ count
         mh    r15,jeOccSize+2     convert to a rel offset
         ar    r4,r15              adjust for level 2 occurs
         b     movd006
movd005  ds    0h
         ah    R4,jeOffset        r4-> dta field
movd006  ds    0h
         lh    r0,jeDtype
         ch    r0,=h'1'        0,1 are char types
         bh    movd020
         Lh    R15,jeLen
         ltr   r15,r15          is the len = 0
         bnz   movd010
         lh    R15,jeDlen     external length
movd010  ds    0h
*  clear the rec ele field
         mvi   0(r4),c' '
         lr    r1,r15           get the length
         bctr  r1,0             bump it by one
         bctr  r1,0             one less for clear
         ex    r1,clearfld
         la    r1,1(r1)         add it back
         l     r1,parmValLn     the length of the source
         bctr  r1,0             bump it for the move
         l     r5,parmValA      address of the source
         ex    r1,MoveDta       move the value
         b     setdxit          and return
clearFld MVC   1(*-*,R4),0(r4)  move from data buf to output buf
moveDta  MVC   0(*-*,R4),0(r5)  move from data buf to output buf
*
* numeric data types
movd020  ds    0h
         ch    r0,=h'3'
         be    setpack
         ch    r0,=h'129'
         be    setpack
         ch    r0,=h'2'
         be    setznum
         ch    r0,=h'128'
         be    setznum
         ch    r0,=h'5'
         bh    setfloat
* sit with binary
movdbin  ds    0h
         l   r0,parmValLn
         l   r1,parmValA
         l  r15,=A(CNVd2b)
         basr r14,r15         on exit r15=binary value
         lh    r0,jelen
         ch    r0,=h'2'
         bh    setfw
         sth   r15,0(r4)     store halword
         b     setd003
setfw    ds    0h
         st    r15,0(r4)
setd003  ds    0h
         b     setdxit
movenum  mvc   0(*-*,r5),work2

setznum  ds    0h
         displaytxt 'setZnum'
*        #SNAP AREA=(0(R6),mjbworkl),TITLE=' mjbWork-1',RGSV=(R2-R8)
**    #SNAP AREA=(0(R3),parmCtlL),TITLE=' setznum parmCtl',RGSV=(R2-R8)
**       #SNAP AREA=(0(R2),jeleln),TITLE=' jEle',RGSV=(R2-R8)
         l     r1,parms
**       l  r2,mjbcurJEleA   r2 -> the corresponding json mapping fld
         st    r2,0(r1)         eledef  mjbcurJEleA
         st    r3,4(r1)         parmctl
         call  cnv2znum         convert parm to zonenum
         ltr   r15,r15          workp2 contains result
         bm    znmerr1
*  r0 = len   r1-> converted data
*  move the correctly formated field to the record buffer
         lr    r15,r0           r0 = len of znum number
         lr    r5,r1            r1 -> start of znum number
         lr    r8,r15   save it
         #SNAP AREA=(workp2,l'workp2),TITLE=' workp2 src',RGSV=(R2-R8)
*        #SNAP AREA=(0(R6),mjbworkl),TITLE=' mjbWork-2',RGSV=(R2-R8)
         lr    r15,r8
         ex    r15,MoveDta       move the value
         #SNAP AREA=(0(R4),(r8)),TITLE=' target movedta',RGSV=(R2-R8)
*        #SNAP AREA=(0(R6),mjbworkl),TITLE=' mjbWork-3',RGSV=(R2-R8)
         b     setdxit
*
*
setpack  ds    0h
*
         l     r1,parms
         st    r2,0(r1)         eledef
         st    r3,4(r1)         parmctl
         call  cnvd2p
         ltr   r15,r15
         bm    pckerr1
*  r0 = len   r1-> converted data
         lr    r15,r0
         lr    r5,r1
         ex    r15,MoveDta       move the value
         b     setdxit

setFLOAT ds    0h
*        handle the floats

* exit
pckErr1  ds    0h
         displayMsg 'pack error'
         l     r15,=f'-1'          error ind
         b     setdxit1
znmErr1  ds    0h
         displayMsg 'znm error'
         l     r15,=f'-1'          error ind
         b     setdxit1
setdxit  ds    0h
         xr    r15,r15             clean return
setdxit1 ds    0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop  r2
         drop  r3
         EJECT
         EJECT
         #BALI
         EJECT
         copy   ISPTCOMM
         LTORG
*---------------------------------------------------------------------*
*- Internal workarea                                                 -*
*---------------------------------------------------------------------*
WORKAREA DSECT
*
REGSTACK DS    (10*9)F              Register stack area (9 entries)
REGSTKMX DS    0F                  Register stack area upper limit
r13sav   DS    F                   Register stack save addr
r15sav   DS    F                   Register stack save addr
*
SYSPLIST DS    16F
*
parmlistA ds   A                   addr of passed parms
parms    ds    5A
           org parms
prsStruct  DS   cl(parsBuffL)       prschar parameters
           org
*
*
BUFFINP  DS    F                   -> cur pos in buffer
BUFFINe  DS    F                   -> end of the buffer

*
nxttask     ds   cl8
curtask     ds   cl8
*
*
***debug    #flag x'01'
***debugFlg DS    X                   debugging
outlog   #flag X'40'               Output to log
OPTFLAG  DS    X                   Option flag
*
*
*
            DS    0F
ParmCtlStg     ds   cl(parmCtlL)     storage for parameter control
*
            DS    0F
mapEntryStg ds    cl(mapentrl)      storage for a map entry

            ds    0f
*
dtaKey         ds    2f                 search key structure
               org   dtaKey
skeyLn         ds    F            search key len
skeyA          ds    A            search key address
               org
srclen         ds    f        length of source line
wpos1          ds    f        pos of ${
wpos2          ds    f        pos of }
*
               ds    0f
extErrMsg      ds    cl32                  extended error message
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
         COPY ISPTDSC2
*
WORKAREL    EQU   *-WORKAREA
*
rdrstg   DSECT     return info passed by isptrdr
lmrbaid  DS    cl1
         ds    0f
rdrstgl  EQU   *-rdrstg
*
         print on
         COPY #MRBDS
         COPY #MCHDS
         COPY #CSADS
         COPY #TCEDS
         COPY #LTEDS
         COPY #pTEDS
         COPY #JTRDS
         COPY #tdtDS
         #OTBDS TYPE=DSECT,       DSECT | CSECT                        X
               EXPAND=ONLINE     BOTH | ONLINE | BATCH
         print on
         copy  isptdsct
*---------------------------------------------------------------------*
*- TCP/IP tables                                                     -*
*---------------------------------------------------------------------*
*
         #SOCKET TCPIPDEF
         #SOCKET ERRNOS
*
         END   TRDREP01
