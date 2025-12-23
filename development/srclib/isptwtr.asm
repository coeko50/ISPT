         TITLE 'ISPTWTR - RHDCMAPR MAPOUT for TCP'
* ISPTWTR RENT EP=TWTREP01
         copy  isptmac
         EJECT
ISPTWTR CSECT
         @MODE MODE=IDMSDC
**       #MOPT CSECT=ISPTWTR,ENV=SYS,modno=5739,AMODE=31,RMODE=ANY
         #MOPT CSECT=ISPTWTR,ENV=USER,modno=5739,AMODE=31,RMODE=ANY
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
*-  1. X'7F'                                                         -*
*-  2. MRB                                                           -*
*-  3. Message line address                                          -*
*-  4. Message len                                                   -*
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
         ENTRY TWTREP01
TWTREP01 ds  0h
*        BAsR  R12,0
*        BCTR  R12,0
*        BCTR  R12,0
         lr    r12,r15
         la    r12,0(r12)           clear high order byte
** -     STM   R14,R12,12(R13)      Save registers at entry
**       LR    R12,R15
        USING TWTREP01,R12
        USING CSA,R10
        USING TCE,R9
*
         lr    r3,r13
         LR    R2,R1               Save A(input plist)
         l     r2,0(r2)            r2 -> parms
         lr    r3,r1               r2 -> parms
*-       la    r2,0(r2)            clear high order bit
*
         #GETSTG TYPE=(USER,SHORT),PLIST=*,LEN=WORKAREL,               X
               ADDR=(R1),INIT=X'00'
*
         LR    R11,R1              Get A(workarea)
        USING WORKAREA,R11
         LA    R13,REGSTACK        Get A(register stack area)
         st    r3,r13Sav
         st    r2,parmsa           save r1 - parms address
         MVC   M#DISLINE,=pl4'9990200'
*
* set defaults
*
          displayMsg   'we are in ISPTWTR.'
*
         using tce,r9
         using lte,r8
         l     r8,tceltea
         la    r1,nxtask
*sysmod  mvc   nxtask+11(8),ltenxtsk
*sysmod  mvc   nxtask+11(1),LTENXTK1
*        L     R15,=A(disline)    display sendbuff in log
*        basr  R14,R15
         b     nxtske
nxtask   msgtxt 'Next Task=xxxxxxxx'
         drop  R8
         drop  R9
nxtske   ds   0h
*
         lr    r1,r12               get the program name from the csect
         la    r0,MOPTLEN
         sr    r1,r0
         mvc   pgmname,0(r1)
*
         xr    r0,r0
         st    r0,olmMsgLn         set passed message to null
         sr    r15,r15
         st    r15,dwait
*
*        L     R15,=F'2097152'
         L     R15,=F'32768'
*        L     R15,=F'6000'
         ST    R15,MAXMSGLN        Set max message length to 32k
*
* figure out which records are the sources for output fields
*  this info is contained in a mapping table that is defined as
*  part of an endpoint. TServer looks up the request-endpoint in the
*  Endpoint table and passed that info via the #REQ storage block.
* steps are:
*
*  1. Load the Request Control storage  (#REQ) [it must exists]
*  2. check to see if a message buffer was send as well
*  3. build the output data buffers either JSon or HTML
*  4. write appropiate headers and then the body to the socket
*  5. close your eyes and hope for the best
*
         #GETSTG TYPE=(USER,SHORT),ADDR=(R7),len=reqTbll,              X
               COND=NO,stgID='#REQ',NWSTXIT=error400
* storage should exits
          b twtr01
error400   ds 0h
***      mvc   debugflg,(debugReq-reqtbl)(r1)
***      #test debug,on=error400d
         displayMsg '#REQ storage not preAlqqcated'
         b  twtr01                     close socket and exit
         b  CloseSock                  close socket and exit
error400d  ds 0h
         la   r15,(JsonMapNm-reqtbl)(r7)
         mvc  0(8,r15),=cl8'TEMPMAP '
         la   r15,(outjson-reqtbl)(r7)
         mvc  0(8,r15),=cl32'Emp_Json'
twtr01   ds    0h
         ST    R7,ReqTbla          save the address for later
*
          displayMsg  '#REQ allocated.'
*
*
* PARMLIST: 07F, MRB, messageLine, msgline End
* ---------
         l     r2,parmsa
         lr    r1,r2               save the parmlist addr
*        #SNAP AREA=(0(R2),32),TITLE=' ISPTWTR prms',RGSV=(R2-R8)
         cli   0(r2),x'7F'         been called from rhdcmapr?
         be    parm005
         lr    r2,r1               else its a cobol call
parm005  ds    0h
         l     r7,0(r2)            x'7F'
         l     r8,4(r2)            R8-> MRB
         st    r8,MRBA             address of map that we write
         tm    4(r2),x'80'         last parm ?
         bo    parm010
         l     r1,8(r2)            R1-> optional message
         la    r1,0(r1)           switch off high order bit
         st    r1,olmMsgA          save the address
         l     r15,12(r2)           R15-> addres of length
         la    r15,0(r15)           clear high order bit
         cli   0(r2),x'7F'         been called from rhdcmapr?
         be    parm008
         l     r15,0(r15)           the msg length
parm008  ds    0h
         st    r15,olmMsgLn         and save it
         displayTxt 'Message:',olmMsgLn,olmMsgA
parm010  ds    0h
         l      r7,reqtbla          * R7 -> req tbl
         using  reqtbl,r7
         la    r8,0(r8)
**       #SNAP AREA=(0(R8),32),TITLE=' ISPTWTR #MRB',RGSV=(R2-R8)
         l     r2,olmMsgA
*        #SNAP AREA=(0(r2),32),TITLE=' ISPTWTR msg',RGSV=(R2-R8)
         using MRB,R8
*
         lr    r1,r8               r1-> mrb
         ah    r1,MRBMREO           r1 -> 1st MRE
         ah    R1,MRBRECOF          R1 -> 1 rec addr
         st    r1,olmRecListA       save rec bind addr list
         l     r4,0(r1)             point to 1st record in list
         st    r4,olmRecA           save the address
         lh    r3,MRBNRECS          number of records
         st    r3,olmNRecs          save it
*
* copy control info from #req to local storage
*
         mvc SOCKDESC,SOCKDESCg      copy sock info from reqtbl
         mvc SOCKDESA,SOCKDESAg
***      mvc   debugFlg,debugReq       set debug flag from server
         mvc   PrevCallChain,callchain  save the previous value
         mvi   callchain,x'00'
         #set  writer                set the writer as the curr proc

         #test outHtml,on=parm020      ignore callchain if HTML req
*        cli   prevCallChain,readerM   was we preceded by a mapin?
*        clc   aidbyte,=cl4'PREM'        is it a premap call
*        bne   exit2                 a premap - no need to write
*                                    will just do a mapin

parm020  ds    0h
         #test debug,on=dbug1
         displayMsg 'debugging inactive'
         b    dbug2
dbug1    ds   0h
         displayMsg 'debugging active'
dbug2    ds   0h
*
*  load the map loadmodule to relate load addresses to record name
*
         #LOAD  PGM=MRBNAME,type=MAP,RGSV=(R2-R8),EPADDR=(R1)
***      st     r1,maploadmA       save map loadmodule address
         using  MCH,r1
         la     r0,MCHRNAMS        start of record names
         st     r0,olmRecNmA       save the address
         drop   r1
*
* load the endpoint table to find the jsonMapTable for the map
*
         la   r0,endpCTE
         st   r0,endpCTEA         save the address
         la    R15,parsedEndpt     get addr of endpoint storage
         st    R15,endpointA       save it
         mvi   parsedEndPt,c' '    and clear it
         mvc   parsedEndPt+1(l'parsedEndPt-1),parsedEndPt

         la    r3,srchCtlPrm
         using srchCtl,r3
         la   r1,MRBNAME          key to search for
         st   r1,srchKeyA
         la   r0,8
         call strlen     r1->var  r0=var len
         st   r15,srchKeyLn
         drop  r3
** endpoint lookup
         la   r1,parms
         st   r3,0(r1)            srchCtl (ln,Key)
         l    r7,reqtbla          r7-> reqtbl
         st   r7,4(r1)            parm1 = reqtbla
         call  EndpointLkup
         ltr   r15,r15           found the endpoint?
         bnz   werr001           endpoint lkup error occurred
         st    r1,endpointa        save the address
* JsonMapNm will contain the json mapping table name
*
* load the mapping module that list json name->internal info
*
         la     r5,l'JsonMapNm
         la     r6,JsonMapNm
         displayTxt  'Will load jsonMapTbl',(r5),(r6)
loadmaptbl ds 0h
         #LOAD  PGM=JsonMapNm,RGSV=(R2-R8),EPADDR=(R6),cond=(PGNF),    X
               ,PGNFXIT=loadmaptble
*
*  work through the mapping table entries and get the data from the
*   record buffers and build the output buffer
*
         using  jSchema,R6            r6->mappng loadmod
         st    r6,jsonMapA             save the address
         lh    r2,=h'5934'
*        #SNAP AREA=(0(r6),(r2)),TITLE=' Json Schema',RGSV=(R2-R8)
         drop r6    for now to see if we are using it
*
*
*     allocate an output buffer
*
         mvc   inMsgLen,=f'32476'

         #GETSTG TYPE=(USER,SHORT),ADDR=(R1),len=inMsgLen,             X
               COND=ALL,NWSTXIT=twtr10,init=x'00'
         LTR   R15,R15             Allocate error ?
         Bz    twtr10              all hunkey dory
         lr    r3,r15
        displayVar 'getstg rc:',(r3)
* return error  if no output buffer
* test line v 0
         displayMsg 'output buff alloc error'
         la    r0,l'msg400obf             additional text
         la    r1,msg400obf             additional text
         L     r15,=A(send400)
         balr  r14,r15
         b     CloseSock                  closr socket and exit
msg400obf dc  c'output buffer alloc error'
twtr10   ds    0h
         ST    R1,BUFFOUTA         Save A(output buffer)
         ST    R1,BUFFOUTP         and current pointer
*
*     check output type
*
twtr15   ds    0h
         #test outHtml,on=WHTML    write html?
* JSON
         displayMsg 'building json.'

         la    r1,parms           r4->recBufs,r6->CodeTbl,r3->OutBuffer
         l     r0,olmRecListA     parm1-> map record buffers
         st    r0,0(r1)
         l     r0,jsonMapA        parm2-> mapping code table
         st    r0,4(r1)
         Call  BldJson             Write JSON
*
*
         LA    r0,jsonMime
         L     r1,buffoutp           current write pointer
         l     r15,buffouta          start pointer
         sr    r1,r15                calc the length
         lr    r4,r1

         displayVar 'JSON build ok - length ',(r4)

         l     r1,(TCESSSCA-tce)(r9)
         lr    r1,r4                 restore r1
         call  sendHdr               send OK msg
         b     svr700

WHTML    ds    0h
*
         displayMsg 'in BldHTML'
         b     whtml10
*
WHTML10  ds    0h
         Call  BLDHTML               Write HTML
*        ltr   r15,r15               good return ?
*        bnz   xxxx   for now , write what we have
         LA    r0,htmlMime           set the type and
         l     r1,buffoutP           the length of the html
         call  sendHdr               send OK msg
         displayMsg 'writing HTML'
         b     svr700
jsonMime dc    cl1' '
htmlMime dc    cl1'H'
****
*------------ errors
werr001    ds 0h
         DISPLAYMSG 'Endpoint lkup failed'
         b  CloseSock                  close socket and exit
*
loadmaptble  ds 0h
         la   r0,JsonMapnm
         DISPLAYTXT 'JSON Map Table - not found',l8,(r0)
         b  CloseSock                  close socket and exit
l8       dc    f'8'
*----------------
SVRENDP  DS    0h
SVR700   DS    0h
*
*
         L     R0,DWAIT            Get WAIT time value
         LTR   R0,R0               Any wait time requested ?
         BZ    SendBuff            No
*
         #SETIME TYPE=WAIT,INTVL=(R0)
*
SendBuff ds    0h
         l     r2,buffOutA
         l     r3,buffoutP                load the buffer length
         sr    r3,r2
         st    r3,sendlen
         l     r5,buffoutp
*        #SNAP AREA=(0(r2),(r3)),TITLE=' buffer',RGSV=(R2-R8)
         l     r1,buffoutA
         l     r15,=A(SOCKSEND)
         BALR  R14,R15
* kept the session open if we are writing html
* else close the socket
*
CloseSock DS   0h
         b     exit1       leave session intact
****     #test outHtml,on=exit     write html?
         L     R15,=A(CLSOCK)      Close socket
         BALR  R14,R15

exit     ds  0h
         #FREESTG stgID='#REQ'       free req tbl
exit1    ds  0h
         l      r1,buffOutA          free the buffer
         ltr    r1,r1
         bz     exit2
         #FREESTG addr=(r1)
exit2    ds  0h
         ltr    r11,r11
         bz     exitxx
         displayMsg 'before return'
*
         #FREESTG ADDR=(R11)         free working storage
         b   exitxx
**
EXIT99   ds 0h
** ret code needed because called directly from cobol
         l     r13,r13sav
         LM    R14,R12,12(R13)      Restore registers
         OI    15(R13),X'01'        This bit on means this save area is
         BR    R14
EXITxx   ds 0h
         #return
         drop r7
*----------------
*
         DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to build JSON data stream                                 -*
*-                                                                   -*
*-   parms:                                                          -*
*-    1: olmRecA      MRB record list addr  (global)                 -*
*-    2: jsonMapA     jsonMappingTable      (global)                 -*
*-    3: buffoutA     output buffer position                         -*
*-                                                                   -*
*-   R3 - used for record looping                                    -*
*-                                                                   -*
*-  1) Parse the input parameters                                    -*
*-  2) write each entry                                              -*
*---------------------------------------------------------------------*
BLDJSON  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING BLDJSON,R12

*
         using  JSchema,R8
         using  jrec,r7               r6->currect rec
*
         l      r5,buffoutP            r5->current write addr
         l      r8,jsonMapA            r8->jsonMap load mod
         la     r4,jMapCtlStg          ctl area
         using  jmapCtl,r4             r4->map ctl
         displaytxt 'bldjson:',jschnm
*
*
         lr     r7,r8                  r7->jsonmap
         la     r7,jSchemaLn(r8)       r7->point to 1st rec after sch
         st     r7,jCurRecA            save current rec address
*
         la     r15,wjeWorkStg        r15->1st wjeWork
*
         lh     r6,(jrEleOffset-jrec)(r7)    get offset to 1st rec ele
         ar     r6,r8                 covert to real address
         st     r6,(jcurEleA-wjeWork)(r15)  r6-> 1st element
         lh     r3,jsRecCnt            total # of recs
*     #SNAP AREA=(0(r8),32),TITLE=' jsch',RGSV=(R2-R8)
*     #SNAP AREA=(0(r7),200),TITLE=' jrec',RGSV=(R2-R8)
*     #SNAP AREA=(0(r6),200),TITLE=' jele',RGSV=(R2-R8)
         mvi    0(r5),c'{'       document start
         la     r5,1(r5)
         b      bldj010
*
*  record loop
recLoop  ds     0h
         l      r5,buffoutP          r5->nextwrite pos
         mvi    0(r5),c','
         la     r5,1(r5)
         l      r7,jCurRecA
         la     r7,jRecLn(R7)      -> next record
         st     r7,jCurRecA

         lh     r6,jrEleOffset        get offset to 1st rec ele
         ar     r6,r8                 covert to real address
         la     r15,wjeWorkStg        r15->1st wjeWork
         st     r6,(jcurEleA-wjeWork)(r15)  r6-> 1st element
bldj010  ds     0h
**    #SNAP AREA=(0(r6),jrecln),TITLE=' rec 1st ele',RGSV=(R2-R8)
         sth    r3,jRecCnt           save the loop count
         l      r7,jCurRecA
         displaytxt 'Record:',jrecname

         mvc    0(2,r5),crlf        prefix the rec with crlf
         la     r5,2(r5)
         mvc    0(2,r5),=c' "'  1st rec start quote
         la     r5,2(r5)
* move in name of json structure
         la     r0,l'jrecname
         la     r1,jrecname
         call   strLen
*  on return    r15 = trimmed length of the name
         ex     r15,movJsonNm
         ar     r5,r15               point to next write pos
         mvc    0(4,r5),=c'": {'
         la     r5,4(r5)
         mvc    0(2,r5),crlf       newline
         la     R5,2(r5)      r5 rdy to receive ele info'
         st     r5,buffoutp        save the write pointer
*251009 b   try to get rid of leading comma for 1st rec 1st ele
        la     r15,wjeWorkStg         parm2:wjeWorkStg
        using  wjeWork,r15
        #reset  writeCont            unset flag
        drop r15
*251009 e
*===============
** next is to find the record buffer corresponding to the entry
        la     r1,parms
        l      r0,jcurReca
        st     r0,0(r1)             1st parm ->jcurreca
        l      r0,olmNRecs          # of records
        st     r0,4(r1)             2nd parm = rec count
        l      r0,olmRecNmA         list of map rec names
        st     r0,8(r1)             3rd parm -> list of record names
        l      r0,olmRecListA       list of rec bind addresses
        st     r0,12(r1)            4th parm -> list of rec bind addr's

        call   findMapRec           will store rec addr  in olmRecA
        ltr    r15,r15
        bnz    blderr01              rec not found
        st     r1,jidmsRecA          save the rec address
*
* jidmsrec  contains the address of idms user record in rec buffer
*
      l     r2,jidmsreca
*
*  loop through record elements and write them
*
        la     r15,wjeWorkStg         parm2:wjeWorkStg
        lh     r3,jrelecnt           # of direct descends
        lh     r6,jrEleOffset        r6 -> offset to 1st rec ele
        using   wjework,r15
        #reset  writeCont            unset flag
        #reset  recEleCont           set flag
        drop   r15
        b      bldj020
recEleLoop ds 0h
        l      r5,buffoutp
** 251009b - only write contchar after 1st ele was written
        using   wjework,r15
        la     r15,wjeWorkStg       r15->1st wjeWork
        #test  recEleCont,off=bldj022
        #set   writeCont            set flag
bldj022 ds     0h
        drop   r15
** 251009e - only write contchar after 1st ele was written
bldj020 ds     0h
        ltr    r6,r6                 a valid offset ?
        bnp    nextRec               nope
*
*  call writeJsonELe for each top level rec ele
*
        st     r5,buffoutp
        la     r1,parms
        la     r0,jmapctlStg         parm1: jmapctl
        st     r0,0(r1)
        la     r15,wjeWorkStg         parm2:wjeWorkStg
        st     r15,4(r1)              set as 2nd parm
        a      r6,jsonMapA            convert r6 offset to real addr
        st     r6,(jCurEleA-wjeWork)(R15)  save as cur ele Addr
*
        call   WriteJsonEle          write the element

        lh     r6,(jeNext-jEle)(r6) offset to next ele
        bct    r3,recEleLoop         loop through rec ele
*
nextRec ds 0h
        l      r5,buffoutp           last point of writing
        mvi    0(5),c'}'             end of record
        la     r5,1(r5)              adjust
        st     r5,buffoutp           last point of writing
        l      r7,jCurRecA
        la     r7,jSchemaLn(r8)      point to next record
        st     r7,jCurRecA           save next rec address
bldj050 ds     0h
        lh     r3,jRecCnt            restore the counter value
        displayVar 'cur record cnt:',(r3)
        bct    r3,recloop            and loop
        b      jsonxit               end of records - exit
bldErr01  ds 0h
         la  r4,jRecName
         la  r1,32
         displaytxt 'REcord Not found',(r1),(r4)
         b   jsonxit
*  process $message if in existence for the map
JSONXIT  DS    0H
         l     r15,olmMsgLn      get address of msg len
         ltr   r15,r15
         bz    jsonxit2
         mvc   0(2,r5),crlf
         mvc   2(13,r5),=c',"$Message":"'
         la    r5,15(r5)
         l     r1,olmMsgA              r1 -> message
         ex    r15,movMsg
         ar    r5,r15                  adj buffer addr
         mvi   0(r5),c'"'
         la    r5,1(r5)
         b     jsonxit2
movMsg   mvc   0(*-*,r5),0(r1)
JSONXIT2 DS    0H
         mvc   0(2,r5),crlf
** 251007b -- remove extra closing }
**       mvc   2(4,r5),=c'   }'
**       mvc   6(2,r5),crlf
** 251007e -- remove extra closing }
         mvi   8(r5),c'}'
         mvc   9(2,r5),crlf
         mvc   11(2,r5),crlf
         la    r5,13(r5)               adjust the buffer length
         st    r5,buffoutP             save new write pointer

         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
movJsonNm MVC   0(*-*,r5),jrecname   move sch name
        drop   r4
        drop   r7
        drop   r8

*---------------------------------------------------------------------*
*- Write a json ele (group or simple)                                -*
*-   parms:                                                          -*
*-    1: jmapctl      contains pointers to all areas used            -*
*-    2: wjeWork      new copy for each invocation                   -*
*-  areas used:
*-    1: olmRecA      current mrb record addr (data source)          -*
*-    2: jsonMapA     jsonMappingTable                               -*
*-    3: buffoutA     output buffer position                         -*
*-    4: wjeWorkStg   local working storage                          -*
*-                                                                   -*
*-  1) loop over the record/grp  elements                            -*
*-  2) loop over occurs fields                                       -*
*-  3) this routine is called recursively                            -*
*-                                                                   -*
*-  2) max levels is 5                                               -*
*---------------------------------------------------------------------*
WriteJsonEle ds  0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING WriteJsonEle,r12
         l     r4,0(r1)             mapctl
         l     r10,4(r1)            wjeWork
         using  jmapctl,r4
         using  wjeWork,r10
         l     r6,jcurEleA         r6 -> current element
         using  jele,r6
*
*      #SNAP AREA=(0(r10),wjeworkl),TITLE=' wje workarea',RGSV=(R2-R8)

         lh    r15,wjestgCnt
         la    r15,1(r15)
         sth   r15,wjeStgCnt
         ch    r15,=h'5'            exceeding stack?
         bh    wjeErr2
*
         l      r5,buffoutP          r5->nextwrite pos
*
* if ele selected for output or required (grp ele) write the literal
* if any of the subords of a group is selected for output but
*    not the groupEle, the groupEle is still written to enclose
*    the subords (it will be marked as required)
*
         cli   jeSel4out,c'Y'        then it is required by default
         be    wje090                nope bypass all the exitement
         cli   jeIsRequired,c'Y'     json required ?
         bne   wje900                nope next lady for a shave
* write field literal
wje090   ds    0h
         cli   jeGrpInd,c'Y'       a group field ?
         bne   wje100              redundant test
wje100   ds    0h                     element loop
         #test writeCont,off=wje105
         mvi   0(r5),c','            write continuation
         la    r5,1(r5)              and adjust
wje105   ds    0h
         #set   recEleCont           set flag
         #set   writeCont            set flag
         bal   r3,wjeMovLit           move field literal
         l     r5,buffoutp            get last buffer position unnec
*
wje120   ds    0h
*
*  occurs handling
*
*  process an element with an occurs clause  defined
*
         lh    r8,jeOcc         get the occurence count
         ltr   r8,r8            does the field occurs?
         bp    wje150           yes -
*
*  process an element that occurs or is part of an occurs group
*  or a single element that occurs
*
         cli   jeOccLvl+1,x'00' is occlvl > 0 - field has a subscript
         bh    wje240           yes
* init occurs control fields for a non occurs ele
         xr    r0,r0
*        sth   r0,wocc          initialize the occ fields
*        sth   r0,wOccCnt
         sth   r0,wOccBase
         b     wje240           bypass all occ calcs
*
* write occurs open [
wje150 ds      0h                  a fullword field
         #set  occFld           set the flag
         mvi   0(r5),c'['       begin mult occ makrer
         la    r5,1(r5)
* reset occ counter for 2nd lvl if top lvl incr
         xr    r0,r0
         lh    r15,jeOccLvl
         ch    r15,=h'1'        is occlvl = 1?
         bh    wje152
         sth   r0,woccCnt1          reset level occ counter
*
wje152 ds      0h                  a fullword field
         sth   r0,woccCnt2          reset level occ counter
*
         cli   jeOccDepInd,noDep  occurs depending?
         be    wje220             nope
         cli   jeOccDepInd,x'F0'  occurs depending?
         be    wje220             nope
*
*  get occurs depending value and override occ max
*
         lh    r14,jeOccDepOffset offset to depnd occur val
         a     r14,jsonMapA       convert to real
** r15 -> element def of occurs depend on. must gets is value in the re cord
         lh    r15,(jeOffset-jEle)(r14)  get offset in idmsrec
         a     r15,jIdmsReca     r15-> occ depend field value
         cli   jeOccDepInd,depl2  2 byte value ?
         bne   wje210              4 bytes
         lh    r8,0(r15)           load the hw value
         b     wje220
wje210 ds      0h                  a fullword field
         l     r8,0(r15)           load the fw value
*
* save the max occurs value - for the level (recursive)
wje220 ds      0h
         sth   r8,wocc               save max occurs for the level
         ltr   r8,r8                is occurs set empty?
         bnp   wje650               yes, bypass
*
*
* field does not occurs but may be part of occurs group though
*
wje240   ds    0h                  not a occurs field

         lh     r3,jeOffset        offset within the user record
         lh     r1,jeOccLvl        occurence level 0 if no  occ
         ltr    r1,r1
         bz     wje260             field not part of occurs
         b      wje245             but no , the 1st time
*
occloop  ds     0h                 loop until r8 = wocc(2)
         mvc   0(2,r5),=cl2', '    occ continuation
         la    r5,2(r5)
*
*  calculate offset of ele within an occurs
*
wje245   ds    0h                  not a occurs field
         lh     r3,jeOccOffset     r3=base offset for occ field
         ch     r1,=h'1'           lvl 1 or 2 ?
         bh     wje250             its lvl 2 occurs
* level 1
         lh     r2,woccCnt1        current occurs
         mh     r2,jeOccSize       adjust for the occur cnt
         sth    r2,wOccBase        save as level1 base offset
         ar     r3,r2              r3=offset occ adjusted for lvl1
         b      wje260             do the moves
* level 2
wje250   ds     0h                 handle 2nd occurs
         lh     r2,woccCnt2        current occurs
*        displayvar 'lvl2 occnt ',(r2)
         lh     r2,wOccCnt2        current occurs
         mh     r2,jeOccSize+2     adjust for the occurs
         ah     r2,wOccBase        add Level1 base offset
         ar     r3,r2              r3=offset occ adjusted
**
** now we can move the ele
**
wje260   ds     0h
         sth    r3,wOffset            r3= offset within record

*  determine it its a occ fld and if occ or subord needs to
*  be written
         cli    jeGrpInd,c'Y'         is this a grp field
         bne    wje500                goto simple field output
         cli   jeSel4out,c'Y'        grp ele selected for output?
         be    wje270                yes, write as string
         b     wje280                else write each field seperately
*
* Group field processing:
*     write group field  as 1 long string
*
wje270   ds    0h
         b     wje530                 write the field
*
movGrp   mvc   0(*-*,r5),0(r1)        move the grp field
*
* write selected group subords
*
wje280   ds    0h
         mvi   0(r5),c'{'            write open curlies
         la    r5,1(r5)              let's move forward
         #reset writeCont          1st subord not preceding ,
* start the chain
         lh    r3,je1stChild       r0-> next ele (1st child)
         b     wje290
*
*    process each subord ele of the group
*    R10 -> current wjeWork and R15 -> next wjeWork
grpEleLoop ds  0h
         #set  writeCont
**       mvi   0(r5),c','            write continuation
**       la    r5,1(r5)              and adjust
         la    r15,wjeWorkL(R10)      point to next wjeWork
         OI    (writeConti-wjeWork)(r15),writeContm t writeconti
wje290   ds    0h
         st    r5,buffoutp           save write pointer

         la    r1,parms
         la    r0,jmapCtlStg
         st    r0,0(r1)
         la    r15,wjeWorkL(R10)      point to next wjeWork
         st    r15,4(r1)

* R6 -> current group element
* r3 -> offset of 1st or next ele in chain
         a     r3,jsonMapA         convert to real address
         st    r3,(jCurEleA-wjeWork)(r15) save next ele addr
         st    r3,jNxtEleA          save next ele addr in cur stack

         call  WriteJsonEle        write the element

         ltr   r15,r15             everything cosher?
         bm    wjeErr1             nope - report the error
         l     r5,buffoutp         get last point written
* get next subord for the group
         l     r3,jNxtEleA          r3->cur child
         lh    r3,(jeNext-jele)(R3)  r3= offset of next ele in chain
         ltr   r3,r3               one available ?
         bp    grpEleLoop          next lady for a shave
wje400   ds    0h                  end of subord chain
         mvi   0(r5),c'}'          write close curlies
         la    r5,1(r5)
         mvc   0(2,r5),crlf       newline
         la    R5,2(r5)
         #set writeCont             next ele need proceeding ,
         b     wje600                and exit if not a occurs field

crlf      DC    c'`~'
*
* write a element  -- an element with a picture clause
*
wje500   ds    0h

wje530   ds    0h
         cli   jeDtype+1,numtypes
         bh    wje540
         mvi   0(r5),c'"'        literal in quotes
         la    r5,1(,r5)
wje540   ds    0h
*
* move its data from the record to the write buffer
*   next is some test senerios
*        clc   jeJsonFld(11),=c'SCHEMA_NAME'
*        be    tester1
*        clc   jeJsonFld(8),=c'REC_NAME'
*        be    tester1
*        clc   jeJsonFld(9),=c'ELE_DTYPE'
*        be    tester1
*        clc   jeJsonFld(9),=c'ELE_SCALE'
*        be    tester1
**       b     tester1
         b     testerx
tester1  ds    0h
      lh   r1,wcnt
      ch   r1,=h'4'
      bh   testerx
      la   r1,1(r1)
      sth  r1,wcnt
*     #SNAP AREA=(0(r6),jeLeln),TITLE=' in movDta Jsonfld',RGSV=(R2-R8)
      la   r3,jejsonFld
      la   r2,32
      displayTxt 'JsonFld',(r2),(r3)
      lh    r2,wOccCnt
      lh    r3,wOffset
      displayVar 'occCnt ',(r2)
      displayVar 'offset ',(r3)
*     l   r3,jidmsrecA
*     ah  r3,wOffset
*     lh  r2,jelen
*     #SNAP AREA=(0(r3),(r2)),TITLE=' datavalue',RGSV=(R2-R8)

testerx  ds    0h
         la    r1,parms          r4-> rec r2->entry desc r5->output bu
         l     r0,jidmsReca
         st    r0,0(r1)          data record (source)  address
         l     r0,jCurEleA       2nd parm=current mapping ele
         st    r6,4(r1)          r2->Jele dsect describing the ele
         st    r5,8(r1)          r5->target for data
         lh    r0,wOffset
         st    r0,12(r1)         offset within the record
         st    r4,16(r1)         r4->jmapctl
*
         call  movDta            move data from record buf to outputbuf
         ar    r5,r15             add the length of the data value

         cli   jeDtype+1,numtypes
         bh    wje600
         mvi   0(r5),c'"'        literal in quotes
         la    r5,1(r5)
****
** end of write - determine occurs looping
****
wje600   ds    0h
         #test occFld,off=wje660
         lh    r1,jeOcc         get the occurence count
         ltr   r1,r1            is this an occurring field/grp?
         bz    occloop          nope, only a subord in occ grp
*  increment the occ count
         lh    r15,jeOccLvl     get the level
         ch    r15,=h'1'        is occlvl = 1?
         bh    wje648
         lh    r1,wOccCnt1
         la    r1,1(r1)           increment
         sth   r1,wOccCnt1
*        displayvar 'lvl1 occnt ',(r1)
         lh    r1,wOccCnt1
         b     wje649
wje648   ds    0h
         lh    r1,wOccCnt2
         la    r1,1(r1)           increment
         sth   r1,wOccCnt2
*        displayvar 'lvl2 occnt ',(r1)
         lh    r1,wOccCnt2
wje649   ds    0h
         ch    r1,wOcc            got them all?
         bl    occloop            nope, write next occ ele

wje650   ds    0h
         mvi   0(r5),c']'       end mult occ marker
         la    r5,1(,r5)
         #reset occFld           and mark an end to occ
         #set   writeCont        and cont char
wje660   ds    0h
         lr    r1,r5
         l     r15,buffouta
         sr    r1,r15             outbuffer length
         ah    r1,=h'1024'        1k needed
         c     r1,MAXMSGLN        larger than the max length?
         bh    wjeErr3            buffer overrun
         b     wje900
*  ------------------------------------

wjeErr   DS    0H
wjeErr1  DS    0H
         displayMsg  'WriteJsonEle: call failed for grp ele'
         lh    r15,=h'-1'
         b     wje901
wjeErr2  DS    0H
         displayMsg  'WriteJsonEle: call stack of 5 exceeded'
         lh    r15,=h'-1'
         b     wje901
wjeErr3  DS    0H
         displayMsg  'WriteJsonEle: output buffer overrun'
         lh    r15,=h'-1'
         b     wje901
wje900   DS    0H
         xr    r15,r15    set rc=0
wje901   DS    0H
         #reset  writeCont
         st    r5,buffoutp
         lh    r14,wjeStgCnt
         bctr  r14,0               bump the count
         sth   r14,wjeStgCnt
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*   --------------------
*  sub routine
* move in the json fld name
*
wjeMovLit  ds   0h
         mvc   0(2,r5),=c' "'
         la    r5,2(r5)
         la     r0,l'jeJsonFld
         la     r1,jeJsonFld
         L      r15,=A(strLen)
         balr   r14,r15
*  on return    r15 = trimmed length of the name
         ex    r15,moveJkey     varlen move of key to output
         b      json031
moveJkey  MVC   0(*-*,r5),jeJsonFld varlen move
json031  ds    0h
         ar    r5,r15           add the length

         mvc   0(3,R5),=c'": '
         la    r5,3(r5)
         st    r5,buffoutP       save the last write pointer
         br    r3
* ------------------
         drop  r4
         drop  r10
*---------------------------------------------------------------------*
*- Routine to build HTML data stream                                 -*
*-                                                                   -*
*-  1) Parse the input parameters                                    -*
*-  2) write each entry                                              -*
*---------------------------------------------------------------------*
BLDHTML  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING BLDHTML,R12

         l      r7,reqtbla          * R7 -> req tbl
         using  reqtbl,r7
*
         la    r1,parms
         la    r0,l'outHTML        html name len
         st    r0,0(r1)            parm1 = html name
         la    r0,outHTML          point to uri (html)
         st    r0,4(r1)            parm1 = html name
         xr    r5,r5
         st    r5,buffOutP         start from scratch
         l     R5,BUFFOUTA         Save A(output buffer)
         st    r5,8(r1)            parm2 = outbuffer address
         call  getHtml             getHtml calls procHtml to read html
         ltr   r15,r15             good return  ?
         bnz   htmlErr             nope a error
*
*
         displayMsg 'after gethtml'
*
         l     r1,buffOuta         load the buff to send
         l     r0,buffoutp        next pos to write
         st    r0,sendLen
         B     bldhxit

htmlerr  DS    0H
BLDHXIT  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         ltorg
         drop  r6
         drop  r7

*---------------------------------------------------------------------*
*- Parse a codetableentry comma delimited string --                  -*
*- A mapping table                                                   -*
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
*- move data from record buffer to output buffer --                  -*
*- for numeric fields do a conversion first                          -*
*
* on exit : r15 - length of data moved
*---------------------------------------------------------------------*
MOVDTA   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING MOVDTA,R12   r4-> rec r2->entry desc r5->output buff
         l  r4,0(,r1)        r4 -> data record buffer
         l  r6,4(,r1)        r2 -> current mapping entry
         l  r5,8(,r1)        r5 -> output buffer
         l  r8,12(,r1)       r8 =  offset within the record
         using jele,r6
*
* check data type if 0 or 1 move directly
*
*  SPECIAL MAP FIELDS
*
         clc   jeElement(8),msgFldN   is it $Message ?
         bne   normalfld
         sr    r15,r15
         sth   r15,jeOffset
         l     r15,olmMsgLn           the length of the field
         ltr   R15,r15                been send?
         Bz    fixup                  nope, write it as is
         sth   r15,jeLen              override the length
         l     r4,olmMsgA             passed message field
         b     normalfld              move the suffix
fixup    ds    0h
         la    r4,msgfldn
         la    r15,l'msgfldN
         sth   r15,jeLen
         b     normalfld
msgFldn  dc    cl8'$MESSAGE'
normalfld ds   0f
         ar    R4,r8              r4-> dta fld loc + occ offset
movd005  ds    0h
*     #SNAP AREA=(0(r6),jeLeln),TITLE=' in movDta Jsonfld',RGSV=(R2-R8)

         clc   jeUdcKey,=h'0'        field managed by udc?
         be    movd006
** only handle udcDMM_DD_CCYY  for now
**       cli   jeUdcKey+1,udcDMM_DD_CCYY
         b     movUDC
movd006  ds    0h
         cli   jeDtype+1,numtypes
         bh    movd020
         Lh    R15,jeLen
         ltr   r15,r15          is the len = 0
         bnz   movd010
         lh    R15,jeDLen      external length
movd010  ds    0h
         lr    r0,r15           full length
         lr    r1,r4            address of field

         call  strlen           remove trailing blanks
* strlen return length in r15
         bctr  r15,0          bump for move
         ltr   r15,r15
         bm    getdxit        move len is 0
         EX    R15,MoveDta    * MOVE the data
         b     getdxit          and return
moveDta  MVC   0(*-*,R5),0(r4)  move from data buf to output buf
*
* numeric data types
movd020  ds    0h
*     SZNUM_FLD                              2
*     SPACK_FLD                              3
*     ZNUM_FLD                             128
*     PACK_FLD                             129
*     BIN_FLD                                5
*     FLOAT_FLD                              7
*     REAL_FLD                               8
*
         cli   jeDtype+1,spack_fld_tp     signed
         be    getpack
         cli   jeDtype+1,pack_fld_tp  unsigned
         be    getpack
         cli   jeDtype+1,sznum_fld_tp      signed zone num
         be    getznum
         cli   jeDtype+1,znum_fld_tp      unsigned zone num
         be    getznum
         cli   jeDtype+1,bin_fld_tp       binary - 2,4 bytes
         be    getbin
         cli   jeDtype+1,float_fld_tp     short float - 4 byte
         be    getfloat
         cli   jeDtype+1,real_fld_tp      long float - 8 byte
         be    getfloat
         b     movderr1
* sit with binary
getbin   ds    0h
         lh    r0,jeLen
         ch    r0,=h'2'
         bh    getfw
         lh    r1,0(r4)     load halfw
         b     getd003
getfw    ds    0h
         l     r1,0(r4)
getd003  ds    0h
         call   CNVB2D8L
         la    r15,10        max length
         la    R1,work2+9   offset adjusted
getd004  ds    0h
         cli   0(r1),c' '    trailing space?
         bne   getd005       nope, we hit a digit
         bctr  r1,0
         bct   r15,getd004
getd005  ds    0h
         la    r1,work2
         ex    r15,moveNum    move the number
* r15 contains length of the move
         la    r15,1(r15)    convert to length
         b     getdxit

getznum  ds    0h
        #SNAP AREA=(0(R6),jeleln),TITLE=' znum fld def',RGSV=(R2-R8)
        #SNAP AREA=(0(R4),32),TITLE=' znum fld',RGSV=(R2-R8)
         lh    r15,jeLen
         bctr  r15,0
         bctr  r15,0
         ex    r15,testznum     test the leading bytes
         bm    moveZero
         lh    r15,jeLen        get the length
         ar    r15,r4           point to next field
         bctr  r15,0            backup 1
         trt   0(1,r15),zonesign    test last byte
         bnz   moveZero
         la    r1,parms
         st    r6,0(r1)      --- jeele (field descr)
         st    r4,4(r1)
         call  CNVz2dsp     convert zone to display
         lr    r15,r0      on exit r1->external Nbr,  r0 = len
exclzero  ds 0h
         cli  0(r1),c'0'       a leading zero ?
         bne  movznum
         la   r1,1(r1)        next char
         bct  r15,exclzero    and loop
movznum   ds 0h
         ex    r15,movenum
         b     getdxit
*
* PACK DECIMAL FIELDS
*
getpack  ds    0h
         lh    r15,jeLen
         bctr  r15,0
         bctr  r15,0
         ex    r15,tstdigit     test the leading bytes
         bm    moveZero
         lh    r15,jeLen        get the length
         ar    r15,r4           point to next field
         bctr  r15,0            backup 1
         trt   0(1,r15),packsign    test last byte
         bnz   moveZero
*        unpck
         la    r1,parms
         st    r6,0(r1)      --- jeEle (field descr)
         st    r4,4(r1)      -> data field in record buffer
         call  CNVP2D        on exit r1->external Nbr,  r0 = len
         lr    r15,r0
         ex    r15,movenum
         b     getdxit
moveZero ds    0h
        #SNAP AREA=(0(R6),jeleln),TITLE=' corrupt fld def',RGSV=(R2-R8)
        #SNAP AREA=(0(R4),32),TITLE=' corrupt fld',RGSV=(R2-R8)
         mvc   0(1,r5),=c'0'
         la    r15,0
         b     getdxit
testznum trt   0(*-*,r4),zonedigit
tstdigit trt   0(*-*,r4),packdigit
tstsign  trt   0(*-*,r3),packsign
movenum  mvc   0(*-*,r5),0(r1)
getfloat ds    0h
         xr    r15,r15
         mvc   0(5,r5),=cl5'float'
         la    r15,4
         b     getdxit

movUDC   ds    0h      the udc value set the type for the move
*        #SNAP AREA=(0(R6),jeleln),TITLE='date jeleUDC-6C',RGSV=(R2-R8)
         cli   jeUdcKey+1,udc_MM_DD_CCYY
         be    dMM_DD_CCYY
         cli   jeUdcKey+1,udc_DD_MM_YY
         be    dDD_mm_YY
         cli   jeUdcKey+1,udc_DDMMYY
         be    dDDMMYY
         b     movd006   -- else move as is
**       b     movderr1    --- error for now
dMM_DD_CCYY  ds 0h
         mvc   0(4,r5),6(r4)    move ccyy
         mvi   4(r5),c'/'
         mvc   5(2,r5),0(r4)    move mm
         mvi   7(r5),c'/'
         mvc   8(2,r5),3(r4)    move dd
         lhi   r15,9            len-1 of moved data
         b     getdxit
dDD_MM_YY    ds 0h
         mvc   0(2,r5),=cl2'20'  move CC
         mvc   2(2,r5),6(r4)    move yy
         mvi   4(r5),c'/'
         mvc   5(2,r5),3(r4)    move mm
         mvi   7(r5),c'/'
         mvc   8(2,r5),0(r4)    move dd
         lhi   r15,9            len-1 of moved data
         b     getdxit
dDDMMYY      ds 0h
         mvc   0(2,r5),=cl2'20'  move CC
         mvc   2(2,r5),4(r4)    move yy
         mvi   4(r5),c'/'
         mvc   5(2,r5),2(r4)    move mm
         mvi   7(r5),c'/'
         mvc   8(2,r5),0(r4)    move dd
         lhi   r15,9            len-1 of moved data
         b     getdxit
* error in d type
movderr1 ds 0h
         la   r1,32
         displayMsg 'movdta - invalid datatype',(r1),jeElement
         b     getdxit
* exit
getdxit  ds    0h
* r15 contains the length of data moved
         la   r15,1(r15)           correct the length
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         EJECT
PackDigit ds  0CL256
*     <            0 1 2 3 4 5 6 7 8 9 A B C D E F
*   test if field is in comp-3 format
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   00-0f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   01-1f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   02-2f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   03-3f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   04-4f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   05-5f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   06-6f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   07-7f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   08-8f
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   09-9f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   A0-af
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   B0-bf
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   C0-cf
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   D0-df
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   E0-ef
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   F0-Ff
*
PackSign ds  0CL256
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   00-0f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   01-1f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   02-2f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   03-3f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   04-4f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   05-5f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   06-6f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   07-7f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   08-8f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFF0000FF00'   09-9f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   A0-af
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   B0-bf
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   C0-cf
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   D0-df
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   E0-ef
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   F0-Ff
*
zoneDigit ds 0CL256
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   00-0f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   01-1f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   02-2f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   03-3f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   04-4f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   05-5f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   06-6f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   07-7f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   08-8f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   09-9f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   A0-af
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   B0-bf
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   C0-cf
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   D0-df
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   E0-ef
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   F0-Ff
*
zonesign ds  0CL256
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   00-0f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   01-1f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   02-2f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   03-3f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   04-4f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   05-5f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   06-6f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   07-7f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   08-8f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   09-9f
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   A0-af
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   B0-bf
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   C0-cf
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   D0-df
         dc   Xl16'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF'   E0-ef
         dc   Xl16'00000000000000000000FFFFFFFFFFFF'   F0-Ff
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
* we need to prevent buffer overruns and one should check everytime
* R5 (buffer pointer) gets written to, which is a schlep
* so we can assume that each write cycle is no more than 80 chars
* text-088 length, + the length of a variable replacement. (32 chars)
* so we will make sure that there are at least 80 bytes avaiable at
* the beginning and then check if the replacement will fit.
*
         l     r0,MaxMsgLn
         s     r0,buffoutP
         c     r0,=f'124'             at least 124 byes availalbe?
         bl    phtml960
*
         l     r5,buffOuta
         a     r5,buffOutP         point to new pos to write
*        la    r0,l'SOURCE_088     length
*        la    r1,SOURCE_088       address
*
*        L     R15,=A(disArea)    display sendbuff in log
*        BALR  R14,R15
*
         la    r0,l'SOURCE_088     length
         la    r1,SOURCE_088       address
         l     r15,=A(strlen)
         balr  r14,r15
*        r15 = length
         st    r15,srclen            save the length
*
*  determine if the line contains a replacment variable
*
         la    r3,srchCtlPrm
         using srchCtl,r3
         la    r2,l'bgDelim        ${
         st    r2,srchKeyLn          search for Str length
         la    r0,bgDelim            search for String
         st    r0,srchKeyA           save the address
         st    r15,srchStrLn         search-in Str length
         st    r1,srchStrA           search-in str addr
         sr    r0,r0
         st    r0,strtPos            set strtpos to 0
*
         la    r1,srchCtlPrm         adres of 'dsect'
         CALL  strSrch             routine to do the work
         ltr   r15,r15             found anything
         bm    phtml010            nothing?
* we found ${
* now we must locate the closing }
         st    r15,strtPos          curpos next srch startpos
*
* move  data before the variable
         st    r15,wpos1           save offset
         la    r1,SOURCE_088       address
         ex    r15,mov2Buff
         ar    r5,r15              point to next write pos
*
*  find end delimiter and extract the variable name
*
         la    r3,srchCtlPrm
         la    r2,l'endDelim
         st    r2,srchKeyLn          search Str length
         la    r0,endDelim           search String
         st    r0,srchKeyA           save the address
*
         la    r1,srchCtlPrm         adres of 'dsect'
         CALL  STRSRCH             routine to do the work
         ltr   r15,r15             found anything
         bm    phtml940            nothing? an error
* r15 - pos of '}'
         st    r15,wpos2          pos of }
         l     r1,wpos1           pos of ${
         la    r1,2(r1)           r1->pos of variable
         sr    r15,r1             wpos2 - wpos1
         st    r15,skeyln         search key length
         la    r2,SOURCE_088       address
         ar    r2,r1              r2-> variable
         st    r2,skeyA           store search key address
*
*  lookup the key and move its data
*
*
*
* --
* --     la    r0,mappingCTE           endp code table entry
* --     l     r1,jsonMapA             addr of a code table
* --     l     R15,=A(TblSetup)        reset the table to 1st entry
* --     BALR  R14,R15
* --
* --     la    r1,parms
* --     la    r15,dtaKey             r1-> search keyln,keyA pair
* --     st    r15,0(r1)              parm1: key to search for
* --     l     r15,jsonMapA
* --     st    r15,4(r1)              parm2: table to search
* --     la    r15,mappingCTE
* --     st    r15,8(r1)              resultset: entry info if found
* --     l     R15,=A(findTblKey)     return a endpCTE for key if fnd
* --     BALR  R14,R15
* --     ltr   R15,r15                found it ?
* --     BNZ   phtml020               nope, write it as is
* --
* --     la    r2,mapentryStg         point to parsed mapentry
* --     la    r3,mappingCTE          point to code table entry
* --     la    r1,parms
* --     st    r3,0(r1)               r3->CodeTblEntry
* --     st    r2,4(r1)               r2->parsed map entry
* --     L     R15,=A(PARSEROW)       unravel the map entry
* --     BALR  R14,R15
* --     ltr   R15,r15                something sinister went wrong
* --     BNZ   phtml950
* --
* check for buffer overrun
* --     la    r2,mapentryStg    point to parsed mapentry
* --     using jEle,r2
* --     l     r0,maxMsgLn
* --     s     r0,buffoutP
* --     sh    r0,elelen
* --     sh    r0,eledtaln
* --     c     r0,=f'80'             at least 80 byes available?
* --     bl    phtml960
* --     drop  r2
* --
* -for occurences - not handled - use single instance entries
* --
* --     la    r1,parms          r4-> rec r2->entry desc r5->output bu
* --     st    r4,0(r1)          r4-> data record (source)
* --     st    r2,4(r1)          r2->mapping entry line
* --     st    r5,8(r1)          r5->target for data
* --     xr    r8,r8
* --     st    r8,12(r1)         r8=occurence number
* --     L     R15,=A(movdta)    move data from record buf to outputbuf
* --     BALR  R14,R15
* --
* --     ar    r5,r15             add the length of the data value
*
*   move the data suffix to output buffer
phtml005 ds    0h                  no variable on the line
         l     r15,srclen          length of source string
         l     r1,wpos2            pos of }
         la    r0,1(r1)            point to data
         sr    r15,r0
         la    r1,source_088
         ar    r1,r0
         b     phtml040            move the suffix
*
phtml010 ds    0h                  no variable on the line
         l     r15,srclen
         la    r1,SOURCE_088       address
         b     phtml040            move the line
*
*  variable not found in mapping table
*
phtml020 ds    0h                  variable not found
         l     r15,srclen          length of source string
         l     r1,wpos1            pos of ${
         la    r0,1(r1)            point to data
         sr    r15,r0
         la    r1,source_088
         ar    r1,r0
*        b     phtml040            move the suffix
phtml040 ds    0h
         ex    r15,mov2Buff
         ar    r5,r15              point to next pos
         l     r1,buffouta
         sr    r5,r1               convert to a offset
         st    r5,buffOutP         save if for next time
         lr    r1,r5
         b     phtml980
phtml940 ds    0h
phtml950 ds    0h
         b     phtml970
phtml960 ds    0h                 buffer overrun
         la    r1,bufOvrrun
         L     R15,=A(disLine)    display sendbuff in log
         BALR  R14,R15
phtml970 ds    0h                 buffer overrun
         l     r15,=f'-1'
         b     phtml990
bufOvrrun msgtxt 'Output buffer overrun - aborting'
phtml980 ds    0h                 buffer overrun
         sr    r15,r15            clean bill of rights
phtml990 ds    0h
html990  DS    0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
bgDelim  dc  c'${'            begin delimiter
endDelim dc  c'}'             end delimiter
mov2Buff mvc 0(*-*,R5),0(r1)
         drop  r3
         LTORG
         EJECT
*
* -----------------------------------
         COPY   ISPTLODR
         COPY   ISPTCOMM

         LTORG
         EJECT
         #BALI
         EJECT
*---------------------------------------------------------------------*
*- Internal workarea                                                 -*
*---------------------------------------------------------------------*
WORKAREA DSECT
*
REGSTACK   DS    (9*11)F             Register stack area (9 entries)
REGSTKMX   DS    0F                  Register stack area upper limit
r13sav     DS    A                   r13 save area
parmsa     DS    A                   r13 save area
*
SYSPLIST   DS    16F
*
parms      ds    5A
parms2     ds    5A
prsStruct  DS    cl(parsBuffL)       prschar parameters
*
*
olmMsgLn   DS   F                 the length the passed message
olmMsgA    DS   A                 address of passed message
*
*
**debug    #flag x'01'
**debugFlg DS    X                   debugging
outlog   #flag X'40'               Output to log
OPTFLAG  DS    X                   Option flag
*
*
            DS    0F
mapEntryStg ds    cl(mapentrl)      storage for a map entry
            DS    0F
*
dtaKey     ds   2f                 search key structure
           org  dtaKey
skeyLn      ds   F            search key len
skeyA       ds   A            search key address
           org
srclen   ds    f        length of source line
wpos1    ds    f        pos of ${
wpos2    ds    f        pos of }
*
extErrMsg   ds  cl32                  extended error message
            org extErrMsg
**weleind     ds  cl4
            org
xout     ds    cl34    -- we can handle pl15
xpk      ds    pl16    -- we can handle pl15
*
*
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
    copy isptdsc2
WORKAREL    EQU   *-WORKAREA
*
*
*
*

         COPY #MRBDS
         COPY #MCHDS
         COPY #CSADS
         COPY #TCEDS
         COPY #LTEDS
         COPY #pTEDS
         copy  isptdsct
*---------------------------------------------------------------------*
*- TCP/IP tables                                                     -*
*---------------------------------------------------------------------*
*
         #SOCKET TCPIPDEF
         #SOCKET ERRNOS
*
         END   TWTREP01
