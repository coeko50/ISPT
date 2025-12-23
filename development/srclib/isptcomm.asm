***********************************************************************
*-                                                                   -*
*-       C O M M O N    R O U T I N E S                              -*
*-       ==============================                              -*
*-                                                                   -*
***********************************************************************
         EJECT
*---------------------------------------------------------------------*
*- Routine to send http40x responses to the unlucky client.          -*
*- Input : R0  = length of additional text to send                  -*
*- Input : R1  = address of additional text to send                  -*
*---------------------------------------------------------------------*
Send400  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING Send400,R12
*
         la    r15,l'http400
         la    r3,http400
         b     snd40x1

Send401  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         LA    R15,Send401-Send400
         SR    R12,R15             Set same base register
*
         la    r15,l'http401
         la    r3,http401
         b     snd40x1

Send404  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         LA    R15,Send404-Send400
         SR    R12,R15             Set same base register
*
         la    r15,l'http404
         la    r3,http404
         b     snd40x1

Snd40x1  DS    0H
         lr    r6,r0
         lr    r7,r1              save extra info
         la    r5,hdrArea
         ex    r15,mov2Buff3
         ltr   r6,r6              and extra text send ?
         bz    snd40x2
         ar    r5,r15              point to new pos
         mvc   0(3,r5),=c' - '     separation
         la    r5,3(r5)
         ex    r0,mov2Buff1       do the move
*
snd40x2  ds  0H
         ar    r5,r15
         mvc   0(2,r5),crlfx
         mvc   2(2,r5),crlfx
         la    r5,4(r5)
         lr    r0,r5
         la    r1,hdrarea        r1->the buffer to send
         sr    r0,r1             the length
         st    r0,sendlen
*        L     R15,=A(ebc2asc)
*        basr  R14,R15
         la    r1,hdrarea
         l     r15,=A(socksend)
         basr  r14,r15           send it
snd400xit  ds  0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
crlfx     DC    c'`~'
mov2Buff1 mvc 0(*-*,R5),0(r1)
mov2Buff3 mvc 0(*-*,R5),0(r3)
http400   DC    C'HTTP/1.1 400 Bad Request'
http401   DC    C'HTTP/1.1 401 Unauthorized'
http404   DC    C'HTTP/1.1 404 NOT FOUND'
*
sendHdr  DS    0H
         #SAVEREG
         LR    R12,R15
         USING sendHdr,R12
*
*  send header lines
* ok, content type
         lr    r7,r0                save the type
         lr    r8,r1                save the body length
         la    r1,HTTP200           move http200 ok to buffer
         la    r15,l'HTTP200
         st    r15,sendlen
         la    r5,hdrarea
         ex    r15,Mov2Httpr
         ar    r5,r15
         cli   0(r7),c'H'           we send html content
         be    shdrHtml
         cli   0(r7),c'J'           we send jpeg content
         be    shdrJPG
         cli   0(r7),c'I'           we send icon content
         be    shdrICO
         la    r1,jsonCont          move content key + value
         la    r15,l'jsonCont       default to json - bad coding
         b     shdr020
shdrHtml ds    0h
         la    r1,htmlCont
         la    r15,l'htmlCont
*
         b     shdr020
shdrJPG  ds    0h
         la    r1,jpegCont
         la    r15,l'jpegCont
         b     shdr020
shdrICO  ds    0h
         la    r1,iconCont
         la    r15,l'iconCont
         b     shdr020
shdr020  ds    0h
* move content type hdr
         ex    r15,Mov2Httpr        move to outarea
         l     r0,sendlen           get the length already in the buff
         ar    r0,r15
         st    r0,sendlen           and adjust it
         ar    r5,r15               update the pointer
* 25/10/02b  send the map name
         la    r1,mapHdr            move http200 ok to buffer
         la    r15,l'mapHdr-1
         ex    r15,Mov2Httpr
         la    r15,l'mapHdr
         ar    r5,r15
         l     r0,sendlen           get the length already in the buff
         ar    r0,r15
         l     r1,mrba            r1->mrb
         la    r15,l'mrbName-1    r15=mrbname length
         ex    r15,Mov2Httpr
         la    r15,2(r15)
         ar    r0,r15
         st    r0,sendlen           and adjust it
         la    r5,l'mrbname(r5)
         mvi   0(r5),c' '
         la    r5,1(r5)
* 25/10/02e  send the map name
* move rest of hdr info -- update the content-length
         la    r1,hdr1
         la    r15,hdrlen
         ex    r15,Mov2Httpr        move to outarea
         lr    r4,r5                save start of hdr1 in outarea
         l     r0,sendlen           get the length already in the buff
         ar    r0,r15
         st    r0,sendlen           and adjust it
         ar    r5,r15               update the pointer
* update the content-length value
         lr    r1,r8                get the body length
         l     r15,=a(CNVB2D8)     to decimal
         basr  r14,r15
         la    r4,bodyOffset(r4)
         mvc   0(6,r4),WORK2+2  move the length

         la    r1,hdrarea
         l     r15,=A(SOCKSEND)     send it r1-addr sendlen=len
         basr  R14,R15
*
         #RESTREG
         BR  R14
mov2Httpr mvc 0(*-*,R5),0(r1)
http200   DC    C'HTTP/1.1 200 OK~'
maphdr    DC    C' MapName: '
hdr1      DC    C'Content-Length: '
bodyOffset equ  *-hdr1
bodyLen   DC    C'000000 ~'
hdr2      DC    C'Server: iServer/0.1 ~'         vir boetiekie Jan
hdr3      DC    C'Date: Wed, 21 May 2025 19:59:29 PST       ~'
hdr4      DC    C'Vary: Accept-Encoding~'
hdr5      DC    C'Connection: Keep-Alive~'
hdr6      DC    C'Keep-Alive: timeout=5, max=500~'
          DC    C'~'
hdrlen    equ   *-hdr1
htmlCont  DC    C'Content-Type: text/html; charset=utf-8~'
jsonCont  DC    C'Content-Type: application/json`~'
iconCont  DC    C'Content-Type: image/vnd.microsoft.icon`~'
gifCont   DC    C'Content-Type: image/gif`~'
jpegCont  DC    C'Content-Type: image/jpeg`~'
*

*---------------------------------------------------------------------*
*- Parse a codetableentry comma delimited string --                  -*
*- A mapping table                                                   -*
*- rec.ele,selUpd,selOutput,eleOff,eleLen,eleType
*---------------------------------------------------------------------*

PARSEROW DS    0H
          #SAVEREG                  Save the caller's registers
          LR    R12,R15
          USING PARSEROW,R12
*         l     r3,0(,r1)        r3 -> CodeTblEntry
*         l     r2,4(,r1)        r2 -> parsed mapping field struct
*         la    r0,0(r0)         -> set fld len to 0
*         using parsBuff,r1    parse parm structure
*         using MapEntry,r2    mapentry based on R2
*         using CodeTblEntry,r3  r3 still the base for cte
** key    first component of CodeTableEntry
*         la    r5,key              r5 -> output buffer for key
*         l     r6,tblKeyLn         keylen
*         l     r4,tblKeyA          key addr
*         la    r1,prsStruct        storage location for parms
*         st    r4,prsInpBufa       cur pos in inputbuffer
*         st    r6,prsInpbufL       remaining length
*         st    r5,prsOutbufA       output location
*         la    r1,prsStruct
*         L     R15,=A(PRSChar)     Parse the input parameters
*         BALR  R14,R15
*         sth   r0,keyln
*         la    r1,key
*         L     R15,=A(lcase)       Convert to lower case voor die voet
*         BALR  R14,R15
** value  second component CodeTableEntry
*         la    r1,prsStruct        r1 -> base for parms
*         l     r6,tblValLn         value length
*         l     r4,tblValA          value addr
*         st    r4,prsInpBufa       cur pos in inputbuffer
*         st    r6,prsInpbufL       remaining length
*         b     elenam
** element name
*elenam   ds    0h
*         la    r5,elename          r5 -> element name out
*         st    r5,prsOutbufA       output location
*         L     R15,=A(PRSChar)     Parse the input parameters
*         BALR  R14,R15
*         sth   r0,elenaml
*         lr    r1,r5               r1 -> end of elename
*         ar    r1,r0               point to the end
*elenaml1 ds    0h
*         cli   0(r1),c'.'          record ele delimiter
*         be    elenaml2
*         bctr  r1,0
*         bct   r0,elenaml1         loop
*elenaml2 ds    0h
*         sth   r0,recnaml          store the length
*         b     sel4updl1
*sel4updl1  ds 0h
** sel4upd
*         la    r1,prsStruct        r1 -> base for parms
*         la    r5,sel4upd          r5 -> sel4upd
*         st    r5,prsOutbufA       output location
*         L     R15,=A(PRSChar)     Parse the input parameters
*         BALR  R14,R15
** sel4out
*         la    r1,prsStruct
*         la    r5,sel4out          r5 -> sel4out
*         st    r5,prsOutbufA       output location
*         L     R15,=A(PRSChar)     Parse the input parameters
*         BALR  R14,R15
** eleOffs
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,eleOffs         store the offset
** eleType
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,eleType         store the offset
** elelen
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,eleLen          store the offset
** eledtaln
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,eleDtaLn        store the offset
** eleprec
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,elePrec         store the offset
** eleScale
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,eleScale        store the offset
** eleOcc
*         la    r1,prsStruct
*         L     R15,=A(prsNum)      Parse the input parameters
*         BALR  R14,R15
*         sth   r15,eleOcc          store the offset
** exit
*PRSMXIT  DS    0H
          xr    r15,r15     set to 0 for now!!!!!
          #RESTREG                  Restore the caller's registers
          BR    R14                 Return to the caller

*------------------------------------------------------------*
* Parse a character value from CSV type buffer
* 1 parm    r1 -> prsStruct a ParseBuff
*           prsInpBufa   cur pos in input buffer
*           prsInpbufL   remaining length of field (will decrement)
*           prsCTEa   map entry struct
*           prsOutbufA   output field within map entry struct
* on exit:
*   r0 =  field length
*   r1 -> prsStruct
*------------------------------------------------------------*
prsChar   ds 0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING prsChar,R12
*
         using parsBuff,r1
          l    r4,prsInpBufa
          l    r6,prsInpbufL
          l    r5,prsOutbufA
          ltr  r6,r6          any input buffer left?
          bnp  prsc03         nope - then exit
          la   r1,0           reset the length
          cli  0(r4),c','
          bne  prsc00
          la   r4,1(,r4)      next pos
          bctr r6,0
prsc00    ds 0h
          lr   r0,r4          save start pos
prsc01    ds 0h
          cli  0(r4),c' '     end of the text
          be   prsc02         not a space
          cli  0(r4),c','     end of the value
          be   prsc03         not a space
          mvc  0(1,r5),0(r4)  move the byte
          la   r5,1(,r5)       next output pos
          la   r1,1(,r1)      increment length
prsc02    ds 0h
          la   r4,1(,r4)       next input pos
          bct  r6,prsc01     runout end of buffer
prsc03    ds 0h
          lr   r0,r1         r0 contains the length
          la   r1,prsStruct
          st   r4,prsInpBufa
          st   r6,prsInpbufL
          st   r5,prsOutbufA
          #RESTREG                  Restore the caller's registers
          BR   R14                 Return to the caller

*------------------------------------------------------------*
* Endpoint lookup in the endpoint module
* to relate an endpoint with the program to call
* on entry:
*    parm1:  reqtblA
* on exit:
*   info extracted from endpoint will be saved in #req
*   r1 -> endpointA
*------------------------------------------------------------*
EndpointLkup ds 0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING EndpointLkup,r12
*
         l     r2,0(r1)      a reqUri described by srchctlPrm
         l     r4,4(r1)      request table
         using  reqTbl,r4
*
         using srchCtl,r2
**       DisplayTxt 'in endpoint lookup',srchKeyLn,srchKeyA
         DisplayMsg 'in endpoint lookup'
         drop   r2
         MVC   endPointNm,=cl8'ENDPOINT'
         #LOAD  PGM=endPointNm,type=TABLE,RGSV=(R2-R8),EPADDR=(R6)
         st    r6,endpTblA            save table load address
*
         l     r0,endpCTEa            endp code table entry
         l     r1,endpTblA             addr of a code table
         Call  TblSetup
*
         la    r1,parms
         st    r2,0(r1)               parm1: key to search for
         l     r0,endpTblA            search the endpoint table
         st    r0,4(r1)               parm2: table to search
         l     r0,endpCTEa            r0-> endpoint code table entry
         st    r0,8(r1)               resultset: entry info if found

         call  findTblKey             return a endpCTE for key if fnd
         ltr   R15,r15
         BNZ   fndKeyErr
*
         l     r0,endpCTEa            r0->code table entry endpoint
         l     r1,endpointA           r1->parsed EndPpoint Entry
         Call  ParseEndp              return a parsed endpoint
         ltr   R15,r15                something sinister went wrong
         BNZ   parsEndpErr
*
         l     R7,endpointA           r7-> endpoint (parsed)
         using ENDPOINTT,r7           r7 base for endpointT
         l     r4,reqtbla
*
         mvc   reqPgmNm(8),endpPgmNm
         mvc   pgmtype,endpPgmTp
         mvc   xferType,endpXfer
         mvc   aidByte,endpAid
         mvc   outFmt,endprTyp
         mvc   outHTML,endpHTML
         mvc   mapTblN,endpMapn
         mvc   SOCKDESCg,SOCKDESC
         mvc   SOCKDESAg,SOCKDESA
*        mvc   debugReq,debugFlg      send debugging ind along
         b     endpt900
*
FndKeyErr ds  0h
* respond http400
*
         #set  ServerErr
         la    r0,l'fndKErrMsg
         la    r1,fndKErrMsg
         L     r15,=A(send400)
         basr  r14,r15
         b     endpt900
fndKErrMsg dc c'URI not in Endpoint'
*
parsEndpErr ds 0h
* respond http400
*
         #set  ServerErr
         la    r0,l'endpMsg
         L     r15,=A(send400)
         basr  r14,r15
         b     endpt900
endpMsg  dc    c'Parse Endpoint error'
*
endpt900  ds  0h
          lr   r1,r7               return endpointa
          #RESTREG                  Restore the caller's registers
          BR   R14                 Return to the caller
          drop  r4
*
*---------------------------------------------------------------------*
*- Parse the enppoint table entry                                    -*
*- On entry r0 will point to CodeTableEntry with info of str to parse-*
*- R1 will point to the result table                                 -*
*---------------------------------------------------------------------*
parseEndp DS   0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING parseEndp,R12
         lr r6,r0            r6 -> endpCTE   (input)
         lr r7,r1            r7 -> parsed Endpoint (output)
         using EndpointT,r7
         using CodeTblEntry,R6
*
         l     r3,tblKeyln
         bctr  r3,0              bump the length with 1 for the move
         l     r4,tblkeyA
         la    r5,endpoint
         ex    r3,moveKey   move endpoint name
*
         l     r3,tblValLn  value length
         l     r4,tblValA   value addr
*
* parse each fld in the value entry
*
*endpPgmn
          using parsBuff,r1
          la    r1,prsStruct
          st    r4,prsInpBufa
          st    r3,prsInpbufL
          la    r5,endpPgmNm
          st    r5,prsOutbufA
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
*endpPgmTp ds 0h
          la  r5,endpPgmTp
          st    r5,prsOutbufA
          la    r1,prsStruct
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
*endpXfer ds 0h
          la  r5,endpXfer
          st    r5,prsOutbufA
          la    r1,prsStruct
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
*endpAid   ds 0h
          la  r5,endpAid
          st    r5,prsOutbufA
          la    r1,prsStruct
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
*endprTyp  ds 0h
          la  r5,endprTyp
          st    r5,prsOutbufA
          la    r1,prsStruct
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
*endpMapn  ds 0h
          la  r5,endpMapn
          st    r5,prsOutbufA
          la    r1,prsStruct
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
          XR    R15,R15             Clear return code
*endpHTML  ds 0h
          la  r5,endpHtml
          st    r5,prsOutbufA
          la    r1,prsStruct
          L     R15,=A(PRSChar)     Parse the input parameters
          basr  R14,R15
          XR    R15,R15             Clear return code
* exit
PRSEndpxt DS   0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
moveKey  mvc   0(*-*,r5),0(r4)    move the endpoint name

         drop  r6
         drop  r7
         EJECT
*------------------------------------------------------------*
* Parse a Numeric value form CSV type buffer
* 1 parm    r1 -> prsStruct a ParseBuff
*           prsInpBufa   cur pos in input buffer
*           prsInpbufL   remaining length of field (will decrement)
*           prsCTEa   map entry struct
*           prsOutbufA   output field within map entry struct
* on exit:
*   r0  = field value
*   r1 -> prsStruct
*------------------------------------------------------------*
prsnum    ds 0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PRSNUM,R12
*
*        using parsBuff,r1
          l    r4,prsInpBufa
          l    r6,prsInpbufL
          la    r5,0           reset the length
          cli   0(r4),c','
          bne   prsn00
          la    r4,1(,r4)      next pos
          bctr r6,0
prsn00    ds    0h
          lr    r1,r4          save start pos
prsn01    ds    0h
          cli   0(r4),c' '     end of the value
          be    prsn02         not a space
          cli   0(r4),c','     end of the text
          be    prsn03         not a space
          la    r5,1(r5)        add 1 to length
prsn02    ds    0h
          la    r4,1(r4)        next pos
          bct   r6,prsn01     runout end of buffer
prsn03    ds    0h
          lr   r0,r5              set the length
*         R1 - saved above
          L     R15,=A(CNVD2B)      convert decimal string to binary
          BALR  R14,R15
* r15 contains the value
          la   r1,prsStruct
          st   r4,prsInpBufa
          st   r6,prsInpbufL
          #RESTREG                  Restore the caller's registers
          BR    R14                 Return to the caller
          drop  R1
         EJECT
*---------------------------------------------------------------------*
*- Routine to convert a pack field   to a decimal string of maximum  -*
*- 31 digits - S9(31) to S9(23)v9(8)
*- Input : r1-> parms                                                -*
*-       : parm1 ->ele definition                                    -*
*-       : parm2 ->pack field                                        -*
*- Output: r0 - len of output field                                  -*
*-         r1 -> output field in the workarea                        -*
*---------------------------------------------------------------------*
CNVP2D   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNVp2D,R12
         l     r3,0(r1)    r3 -> ele def
         l     r4,4(r1)    r4 -> pack decimal field as described by r3
*
         using jele,r3
         zap   workp1,=pl1'0' it the field
         la    r1,workp1
         la    r0,l'workp1
         lh    r15,jelen
         sr    r0,r15
         ar    r1,r0        amount to shift left
         bctr  r15,0
         ex    r15,movpack         move from rec buff
* prepare workp2
         mvi   workp2,x'20'
         mvc   workp2+1(l'workp2-1),workp2  make all x'20'
         mvi   workp2+(l'workp2-1),x'60'     sign
         mvi   workp2,x'40'        prefix with spaces
*
         lh    r1,jescale          get # of decimals
         ltr   r1,r1               an integer ?
         bz    cp2d004             yes
         la    r4,workp2+(l'workp2-4)    4 = # ctl chars
         sr    r4,r1               backtrack for # of dec
         mvc   0(3,r4),decMask     move the dec mask in
         b     cp2d006
cp2d004  ds    0h
         mvi   workp2+(l'workp2-3),x'21'  at least 1 zero if int
cp2d006  ds    0h
         ed    WORKp2(l'workp2),WORKp1
*
         ic    r2,workp2+(l'workp2-1) get the sign
         stc   r2,workp2           insert the sign upfront
         la    r4,workp2+1         sign upfront
         lr    r1,r4               save leftmost pos
         la    r15,(l'workp2-2)    scan for 33 bytes
cp2d010  ds    0h
         cli   0(r4),c' '          spaces ?
         bne   cp2d020             nope 1st digit
         la    r4,1(r4)
         bct   r15,cp2d010         and loop
cp2d020  ds    0h
         bctr  r15,0
         ex    r15,movpack         and left justify the val
         la    r15,2(r15)          add2. signbyte + bctr
         lr    r0,r15              return the length
         la    r1,workp2           return the addr
*
cp2d090  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
movpack  mvc   0(*-*,r1),0(r4)     move data
decMask  dc    x'21204B'
*
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to convert a source numeric string to zone numeric        -*
*- conforming to the target specification                            -*
*- at this stage we truncate input decimals ie no rounding           -*
*-  in json  preceding 0 are not allowed                             -*
*-    thus 1 is good but not 01                                      -*
*-                                                                   -*
*- if target  is s9(3)v9(2)  precision=5 scale=2                     -*
*- input  123     12.2      0.494  1      -123.4    12345.1          _*
*- output 12300   01220     00049  00100   1234} D0  error           _*
*-                                                                   -*
*- if target  is s9(3)       precision=3 scale=0                     -*
*- input  123     12.2      0.494  1      -123.4    12345.1          _*
*- output 123     012       000    001     12L D3    error           _*
*-                                                                   -*
*- if target  is  9(3)       precision=3 scale=0                     -*
*- input  123     12.2      0.494  1      -123.4    12345.1          _*
*- output 123     012       000    001     123       error           _*
*-                                                                   -*
*- Input : r1-> parms                                                -*
*-       : parm1 ->ele definition                                    -*
*-       : parm2 ->parmctl : describing the input                    -*
*-                                                                   -*
*- Output: r0 = len of znum field   (must be = jePrec)               -*
*-         r1 -> start of zone numeric field (in workp2)             -*
*-                                                                   -*
*- this routine is used to process all numeric input                 -*
*-                                                                   -*
*---------------------------------------------------------------------*
CNV2znum DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNV2znum,r12
         l     r3,0(r1)    r3 -> ele def
         l     r6,4(r1)    r6 -> parmctl
         displayMsg 'cnv2znum'
* r2 - source integer component len
* r3 - ele def
* r4 -
* r5 -
* r6 ->parm ctl dsect
* r7 -> source read position
* r8 -> target write position
* r9 -> target start position
* r15 - length of the moves
*
*
         using jele,r3
         using parmctl,r6
         l     r1,parmValLn
         ch    r1,=h'33'      31digits dec+sign
         bh    c2znErr1       go and complain
*
***      zap   workp1,0     init the result field
         mvi   workp2,x'f0'  init it to zeros
         mvc   workp2+1(l'workp2-1),workp2
*        #SNAP AREA=(workp2,l'workp2),TITLE=' workp2',RGSV=(R2-R8)

* init tgt registers   r8-> point at end of work field
*                      r9-> start of resulting number in workp2
         xr    r15,r15             init # dec positions used
         la    r8,workp2
         la    r8,l'workp2(r8)     r8->point to the end of the target
         lh    r14,jeprec          len of target field
         lr    r9,r8
         sr    r9,r14              r9->begin of the field in workp2

*  calculate the length of the integer portion of the source field
*  r2 = integer len of source
*  if the source is integer bypass any fractional moves
         l     r2,parmDptA         source decimal addr
         ltr   r2,r2               any dec pos ?
         bnz   c2zn020             yes
         l     r2,parmValLn        integer len
         b     c2zn100              skip fraction moves
c2zn020  ds    0h
         l     r0,parmValA         source start
         sr    r2,r0               r2 = source integer component len

* if the target is an integer bypass decimal fraction moves
c2zn022  ds    0h
         cli   jescale+1,x'00'     zero decimal places
         be    c2zn100             yes, get out of here
*
* move the fractional portion of the source to the target
* setup input
         l     r15,parmvalLn       get source length
         lr    r0,r15              save parm length
         sr    r15,r2              declen = totlen - intlen
         bctr  r15,0               not including the .
         ch    r15,jeScale         compare extdec with intdec
         bnh   c2zn050
         lh    r15,jeScale          set max dec length
c2zn050  ds    0h
         sh    r8,jeScale          backtrack to dec pos part
         l     r7,parmDptA         offset to decimal part
         la    r7,1(r7)            ignore the .
*        #SNAP AREA=(0(R7),12),TITLE=' dec mov',RGSV=(R2-R8)
         bctr  r15,0
         ex    r15,movdigits
         b     c2zn100
movdigits mvc   0(*-*,r8),0(r7)     move text from source to workp2

* now we can move the integer part
c2zn100 ds    0h
* verify that the source integer len is not > target int len
         lh    r14,jeprec
         sh    r14,jescale          r14=target int len
         cr    r14,r2               will all the numbers fit?
         bl    c2znerr2             complain
*
*  r7-> source digits  point pass sign if there is 1
         l     r7,parmvalA         r7-> start of source value
         xr    r1,r1
         ic    r1,parmSignInd      signind=0 or 1
         ar    r7,r1               not including a sign
*                                  r7 -> 1st source digit
c2zn110 ds    0h
*
* determine target offset for the move
* r8 point at this point to the end of target int value
         sr    r8,r2               r8-> start of target integer digits
         lr    r15,r2              r15= # of digits
         sr    r15,r1              - sign pos if present
         bctr  r15,0               r15 = # chars to move
c2zn102 ds    0h
         ex    r15,movdigits
         lr   r5,r1
*      #SNAP AREA=(workp2,l'workp2),TITLE=' workp2 filled',RGSV=(R2-R8)
         lr    r1,r5
* fix the sign
         ltr   r1,r1               is a sign present ?
         bz    c2znOk              nope, go home
         l     r14,parmVala
         cli   0(r14),c'+'         if positive all is ok
         be    c2znOk
         ni    workp2+(l'workp2-1),x'DF'     force it negative
         oi    workp2+(l'workp2-1),x'D0'     force it negative
         b     c2znOk
*
c2znErr1 ds    0h
         displayTxt 'numeric value exceeds 31 characters',parmNameLn,  X
               parmNameA
         b    c2znerrx
*
c2znErr2 ds    0h
         displayTxt 'numeric value exceeds target size',parmNameLn,    X
               parmNameA
c2znerrx DS    0H
         xr    r15,r15
         bctr  r15,0
         b     c2znXit
*
c2znOk   DS    0H
         lr    r1,r9           r1 = r9 -> start of field in workp2
         lh    r0,jePrec
         xr    r15,r15
c2znXit  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*---------------------------------------------------------------------*
*- Routine to convert a zone numeric field to display format         -*
*- conforming to the target specification                            -*
*-                                                                   -*
*- if src     is s9(4)v9(1)  precision=5 scale=1                     -*
*- input  12340   00122     0123D    01234D9   12345                 -*
*- output 1234    12.2      -123     -123.49   1234.5
*-                                                                   -*
*- Input : r1-> parms                                                -*
*-       : parm1 ->ele definition                                    -*
*-       : parm2 ->addres of source field                            -*
*-                                                                   -*
*- Output: r0 = len of znum field   (must be = jePrec)               -*
*-         r1 -> zone numeric field (offset in workp2)               -*
*-                                                                   -*
*---------------------------------------------------------------------*
CNVZ2dsp DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNVz2dsp,r12
         l     r3,0(r1)    r3 -> ele def
         l     r4,4(r1)    r4 -> source field
* r2 - source integer component len
* r3 - ele def
* r4 -
* r5 -
* r7 -> source read position
* r8 -> target write position
* r15 - length of the moves
*
*
         using jele,r3
         lh    r1,jelen
         ch    r1,=h'32'      31digits+dec+sign
         bh    z2dpErr1       go and complain
*
***      zap   workp1,0     init the result field
         mvi   workp2,x'f0'  init it to zeros
         mvc   workp2+1(l'workp2-1),workp2

* init so registers   r8-> point at end of work field
         xr    r15,r15             init # dec positions used
         la    r8,workp2
         la    r8,(l'workp2)(r8)   r8->point to the end of the target
         lr    r15,r8              save last pos
         bctr  r15,0               r15->last digit

         lh    r2,jePrec           r2 = precision
         sr    r8,r2               r8 -> start of target field
         bctr  r2,0                bump the length
         ex    r2,movzdta          move number
         clc   jeScale,=h'0'        any decimals ?
         be    fixsign
***
*** move the integer part of the value to the left
*** to make space for the decima point
         sh    r2,jeScale          left with integer len
         lr    r4,r8
         bctr  r8,0                shift left 1
         ex    r2,movzdta
         ah    r4,r2
         mvi   1(r4),c'.'          set dec point

fixsign   ds     0h
* if the target is an integer bypass decimal fraction moves
         tm    0(r15),x'F0'         unsigned
         bo    z2dpok
         tm    0(r15),x'C0'         positive
         bo    z2dpok
         bctr  r8,0
         mvi   0(r8),c'-'           set the sign
         b     z2dpOk
movzdta   mvc   0(*-*,r8),0(r4)     move text from source to workp2
*
z2dpErr1 ds    0h
         displayTxt 'numeric value exceeds 31 characters',parmNameLn,  X
               parmNameA
*
z2dperrx DS    0H
         xr    r15,r15
         bctr  r15,0
         b     z2dpXit
*
z2dpOk   DS    0H
         sr    r15,r8              calc total length of display field
         lr    r0,r15              r0 = total len - 1
         lr    r1,r8               r1->start of field
         xr    r15,r15
z2dpXit  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
*---------------------------------------------------------------------*
*- Routine to convert a decimal string to a pack field               -*
*- 31 digits - S9(31) to S9(23)v9(8)
*- Input : r1-> parms                                                -*
CNVd2p   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNVd2p,R12
         l     r6,4(r1)    r6 -> parmctl
         call  cnv2znum    convert the source string to znum
         pack  workp1,workp231
         lh    r0,jeLen          r0 = data len
         la    r1,workp1
         la    r15,l'workp1
         sr    r15,r0
         ar    r1,r15             r1->point to data start
         b     cd2pXit
cd2p150 ds    0h
*
cd2pXit  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to convert a binary value to a decimal string of maximum  -*
*- 8 characters. If the binary value is negative or greater than     -*
*- 99,999,999 (8 digits), then convert the value to hexadecimal.     -*
*- CNVB2D8  entry: decimal number is right justified                 -*
*- CNVB2D8B entry: replace all leading zeros by blanks               -*
*- CNVB2D8L entry: decimal number is left justified                  -*
*- Input : R1  = binary value                                        -*
*- Output: WORK2 field (8 bytes) from the WORKAREA                   -*
*---------------------------------------------------------------------*
CNVB2D8  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNVB2D8,R12
         XR    R2,R2               Number right justified
         B     CB2D8@00            Branch to common code
*
CNVB2D8B DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         LA    R15,CNVB2D8B-CNVB2D8
         SR    R12,R15             Set same base register
         LA    R2,1                Replace all zeros by blanks
         B     CB2D8@00            Branch to common code
*
CNVB2D8L DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         LA    R15,CNVB2D8L-CNVB2D8
         SR    R12,R15             Set same base register
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
         L     R15,=A(CNVB2X)      Yes, translate it to hexadecimal
         basr  R14,R15
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
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to convert a binary value to an hexadecimal string.       -*
*- Input : R1  = binary value                                        -*
*- Output: WORK2 field (8 bytes) from the WORKAREA                   -*
*---------------------------------------------------------------------*
CNVB2X   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNVB2X,R12
*
         ST    R1,WORK1            Store input binary value
         UNPK  WORK2(9),WORK1(5)
         NC    WORK2(8),CNVB2X0F
         TR    WORK2(8),CNVB2XTT
*
CNVB2X99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
CNVB2X0F DC    XL8'0F0F0F0F0F0F0F0F'
CNVB2XTT DC    CL16'0123456789ABCDEF'
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to convert a decimal string to binary.                    -*
*- Input : R0  = string length                                       -*
*-         R1  = A(decimal string)                                   -*
*- Output: R15 = binary value                                        -*
*---------------------------------------------------------------------*
CNVD2B   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CNVD2B,R12
*
         LR    R14,R0
         MVI   WORK2,C'0'          Initiate receiving field
         MVC   WORK2+1(L'WORK2-1),WORK2
         LA    R15,WORK2+10
         SR    R15,R14             Get A(where to move)
         BCTR  R14,0
         EX    R14,CNVD2BEX        Value now right-justified
         PACK  WORK1(8),WORK2(10)  Convert to packed
         CVB   R15,WORK1           Convert to binary
*
CNVD2B99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
CNVD2BEX MVC   0(*-*,R15),0(R1)
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to display the 3 return code variables returned by all    -*
*- the #SOCKET calls.                                                -*
*- Input : R1  = A(message text prefix) (first byte = message length)-*
*-         RETCODE, ERRNO and RSNCODE from the workarea              -*
*---------------------------------------------------------------------*
DIS3RC   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING DIS3RC,R12
*
         XR    R2,R2
         IC    R2,0(,R1)
         LTR   R2,R2               Any message prefix ?
         BZ    DIS3RC20            No, continue
         LA    R15,80-48           The 3 RC's need 48 bytes
         CR    R2,R15
         BNH   DIS3RC10
         LR    R2,R15              Take max length for message prefix
         LA    R15,OUTAREA
         CR    R1,R15              Message prefix already in outAreat ?
         BE    DIS3RC20            Yes, skip the move
DIS3RC10 DS    0H
         BCTR  R2,0
         EX    R2,DIS3RCEX         Move message prefix to area
         LA    R2,1(,R2)
*
DIS3RC20 DS    0H
         LA    R2,outAreat(R2)     Update pointer in output area
*
         L     R1,RETCODE
         L     R15,=A(CNVB2X)
         basr  R14,R15             Convert RETCODE in hexadecimal
         MVC   0(8,R2),=CL8'RETCODE='
         MVC   8(8,R2),WORK2
*
         L     R1,ERRNO
         L     R15,=A(CNVB2D8L)
         basr  R14,R15             Convert ERRNO in decimal
         MVC   16(7,R2),=CL7' ERRNO='
         MVC   23(8,R2),WORK2
*
         L     R1,RSNCODE
         L     R15,=A(CNVB2X)
         basr  R14,R15             Convert RSNCODE in hexadecimal
         MVC   31(9,R2),=CL9' RSNCODE='
         MVC   40(8,R2),WORK2
*
         LA    R2,48(,R2)
         LA    R15,outAreat
         SR    R2,R15
         STC   R2,OUTAREA
         LA    R1,OUTAREA
         L     R15,=A(DISLINE)
         basr  R14,R15             Display the output message
*
DIS3RC99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
DIS3RCEX MVC   outAreat(*-*),1(R1)
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- display message and the value in errno                             *
*- Input : R0  = value to display                                    -*
*-       : R1  = A(message text prefix) (first byte = message length)-*
*-                  ERRNO             from the workarea              -*
*---------------------------------------------------------------------*
DISErr   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING DISErr,R12
*
         st    r0,errno
         XR    R2,R2
         IC    R2,0(,R1)
         LTR   R2,R2               Any message prefix ?
         BZ    DISErr20            No, continue
         LA    R15,80-8            The rc needs 8 bytes
         CR    R2,R15
         BNH   DISErr10
         LR    R2,R15              Take max length for message prefix
         LA    R15,OUTAREA
         CR    R1,R15              Message prefix already in outAreat ?
         BE    DISErr20            Yes, skip the move
DISErr10 DS    0H
         BCTR  R2,0
         EX    R2,DISErrEX         Move message prefix to area
         LA    R2,1(,R2)
*
DISErr20 DS    0H
         LA    R2,outAreat(R2)     Update pointer in output area
*
*
         L     R1,ERRNO
         Call  CNVB2D8L            Convert to decimal
         MVC   0(8,R2),WORK2
*
*
         LA    R2,48(,R2)
         LA    R15,outAreat
         SR    R2,R15
         STC   R2,OUTAREA
         LA    R1,OUTAREA
         Call  DISLINE             display message
*
DISErr99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
DISErrEX MVC   outAreat(*-*),1(R1)
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to display an output area to the terminal or log file.    -*
*- Input : R0  = line length                                         -*
*-         R1  = A(output line)                                      -*
*---------------------------------------------------------------------*
DISAREA  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING DISAREA,R12
*
         LTR   R2,R0               Length = 0 ?
         BZ    DISARE99            Yes, exit
         C     R2,=F'80'           Length > 80 ?
         BNH   DISARE10            No
         LA    R2,80               Yes, take max length = 80
DISARE10 DS    0H
         STC   R2,OUTAREA          Save area length
         BCTR  R2,0
         EX    R2,DISAREEX         Copy data to outAreat buffer
*
         LA    R1,OUTAREA
         L     R15,=A(DISLINE)
         basr  R14,R15             Display the output message
*
DISARE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
DISAREEX MVC   outAreat(*-*),0(R1)
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to display an output line to the terminal or log file.    -*
*- Input : R1  = A(output line)  (first byte = message length)       -*
*---------------------------------------------------------------------*
DISLINE  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING DISLINE,R12
*
         LR    R2,R1               Save A(output line)
         La    R0,M#DisLine        load A(message nbr)
*
DISLIN10 DS    0H
*
         #WTL  MSGID=(R0),MSGPREF='IW',OVRIDES=OVRLOG,PARMS=((R2))
         b   dislin99
*---------------------------------------------------------------------*
*- Routine to display an output line to the terminal or log file.    -*
*- Input : R1  = A(output line)  (first byte = message length)       -*
*---------------------------------------------------------------------*
DISLINE2 DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING DISLINE2,R12
*
         l     r2,0(r1)            parm1
         l     r3,4(r1)            parm2
         l     r4,8(r1)            parm3
         ltr   r3,r3           0?
         bz    dislin230
         ltr   r4,r4
         bz    dislin240
         b     dislin250
dislin230 ds   0h
         la    r3,nulMsg
dislin240 ds   0h
         la    r4,nulMsg
dislin250 ds   0h
*
*
         #WTL  MSGID=M#disline,MSGPREF='IW',OVRIDES=OVRLOG,            X
               PARMS=((R2),(r3),(r4))
*
DISLIN99 DS    0H
         mvi   outareat,c' '
         mvc   outareat+1(64),outareat
         mvi   outarea,x'00'       set length to 0
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
nulMsg   DC    AL1(nulMsgE)
nulMsgb  DC    C'..'
nulMsgE  EQU   *-nulMsgB
OVRLOG   DC    X'8000000000'       #WTL to LOG only
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to free a piece of storage.                               -*
*- Input : R1  = storage to free                                     -*
*- Output: R15 = 0 or -1 in case of error                            -*
*---------------------------------------------------------------------*
FREESTG  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING FREESTG,R12
*
         #FREESTG ADDR=(R1)
*
         LTR   R15,R15             Request successful ?
         BNZ   FSTG90              No, error exit
         B     FSTG98              Yes, exit
*
FSTG90   DS    0H
         LA    R1,FSTGERR1
         L     R15,=A(DISLINE)
         basr  R14,R15             Display error message
         B     FSTG97
*
FSTG97   DS    0H
         L     R15,=F'-1'          Set return code to -1
         B     FSTG99
*
FSTG98   DS    0H
         XR    R15,R15             Clear return code
*
FSTG99   DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
FSTGERR1 MSGTXT '===> FREESTG() error.'
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to allocate a piece of storage of type USER.              -*
*- Input : R0  = length to allocate                                  -*
*- Output: R1  = A(allocated area)                                   -*
*-         R15 = return code                                         -*
*---------------------------------------------------------------------*
GETSTGU  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING GETSTGU,R12
        lr     r3,r0   save length
        la     r3,128(r3)     make it a bit bigger
*
         lr   r4,r2
GETST02  DS    0H
         #GETSTG TYPE=(USER,SHORT,KEEP),LEN=(R3),ADDR=(R2),INIT=X'40', X
               COND=ALL,stgID='#BUF',NWSTXIT=GSTGU98
*
         LTR   R15,R15             Request successful ?
         BNZ   GSTGU97             No, error exit
** we should have gotten new stg. will free and getstg again
         #FREESTG STGID='#BUF'
         b     getst02
*
GSTGU97  DS    0H
         displayVar '--> Getstg Error rc=',(R15)
         L     R15,=F'-1'          Set return code to -1
         B     GSTGU99
*
GSTGU98  DS    0H
         st    r2,buffina
         st    r3,buffinLn
         displayVar 'new buffer storage len=',(r3)
         XR    R15,R15             Clear return code
*
GSTGU99  DS    0H
         lr    r1,r2
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
        DROP  R12
         LTORG
         EJECT
*
*---------------------------------------------------------------------*
*- Routine to parse the requested command.                           -*
*- Input : R0  = length of input parameters string                   -*
*-         R1  = A(input parameters string)                          -*
*- Output: R0  = remaining length for parameters                     -*
*-         R1  = A(remaining parameters)                             -*
*-         R15 = 0 or -1 in case of error                            -*
*---------------------------------------------------------------------*
PARSCMD  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PARSCMD,R12
*
         LR    R3,R0               Get length of parameters
         LR    R2,R1               Get A(parameters)
*
         LTR   R3,R3               Buffer empty ?
         BNP   PARSCM98            Yes, exit
*------------------------------------------------*
*- Extract the requested command                -*
*------------------------------------------------*
PARSCM10 DS    0H
         CLI   0(R2),C' '
         BNE   PARSCM20
         LA    R2,1(,R2)
         BCT   R3,PARSCM10         Skip all blanks
         B     PARSCM98            Exit
*
PARSCM20 DS    0H
         LA    R15,4
*------------------------------------------------*
*- Exits                                        -*
*------------------------------------------------*
PARSCM90 DS    0H
         LA    R1,PARSCMT1         Invalid command
         B     PARSCM97            Error exit
*
PARSCM97 DS    0H
         L     R15,=A(DISLINE)
         basr  R14,R15             Display error message
         XR    R0,R0               Clear remaining length
         XR    R1,R1               Clear remaining parameters address
         L     R15,=F'-1'          Set return code to -1
         B     PARSCM99
*
PARSCM98 DS    0H
         LR    R0,R3               Return R0 = remaining length
         LR    R1,R2               Return R1 = A(remaining parameters)
         XR    R15,R15             Clear return code
*
PARSCM99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
PARSCMT1 MSGTXT 'Invalid command.'
*
        DROP  R12
         LTORG
         EJECT
*---------------------------------------------------------------------*
*- Routine to input parameters.                                      -*
*- Input : R0  = length of input parameters string                   -*
*-         R1  = A(input parameters string)                          -*
*- Output: R15 = 0 or -1 in case of error                            -*
*  scan for a ,  or the 1st ' '
*---------------------------------------------------------------------*
PARSCSV  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PARSCSV,R12
*
         LR    R3,R0               Get length of parameters
         LR    R2,R1               Get A(parameters)
*------------------------------------------------*
*- Extract json name                            -*
*------------------------------------------------*
PARSCV10 DS    0H
         LTR   R3,R3               Buffer exhausted ?
         BNP   PARSCV98            Yes, exit
*
PARSCV12 DS    0H
         CLI   0(R2),C' '
         Be    PARSCV20
         CLI   0(R2),C','          or at end of cur entry
         Be    PARSCV20
         LA    R2,1(,R2)
         BCT   R3,PARSCV12         Skip all blanks
         B     PARSCV20            Exit if buffer exhausted
*
PARSCV20 DS    0H
*
         B     PARSCV99            Unknown parameter: error exit
*
PARSCV30 DS    0H
         AR    R2,R15              Update input pointer
         SR    R3,R15              Update remaining length
         BR    R14                 Go process the requested parameter
*
PARSCV98 DS    0H
         XR    R15,R15             Clear return code
*
PARSCV99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
        DROP  R12
         LTORG
         EJECT
         EJECT
*---------------------------------------------------------------------*
*- Routine to receive a message from the partner.                    -*
*- The message prefix (first 4 bytes) containing the length of the   -*
*- message text is first read, followed by an eventual loop of RECV  -*
*- calls, until the entire message is received.                      -*
*- Input : None                                                      -*
*- Output: R15 = 0 or -1 in case of error                            -*
*---------------------------------------------------------------------*
SOCKRECV DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING SOCKRECV,R12
         xr   r1,r1
         st   r1,inmsglen
*
         #SOCKET RECV,SOCK=SOCKDESC,BUFFER=INMSGLEN+2,BUFFERL=2,       X
               FLAGS=MSGFLAGD,RETLEN=RETLEN,                           X
               RETCODE=RETCODE,ERRNO=ERRNO,RSNCODE=RSNCODE
*
         XR    R15,R15
         IC    R15,SOCKRET1
         EX    R15,SOCKREEX        Copy the debug message text
         L     R1,RETLEN
         L     R15,=A(CNVB2D8B)
         BALR  R14,R15
         MVC   OUTAREAT+11(7),WORK2+1 Put the length really received
*
         LA    R1,OUTAREA
         L     R15,=A(DIS3RC)
         BALR  R14,R15             Display function + 3 RC's
         CLC   RETCODE,=F'0'       #SOCKET request successful ?
         BNE   SOCKRE97            No, error exit
*
         CLC   RETLEN,=F'0'        RECV length = 0 ?
         BE    SOCKRE90            Yes, error exit
         CLC   RETLEN,=F'2'        RECV length = 4 ?
         BL    SOCKRE91            No, error exit
*
         l     r1,inmsglen
         ch    r1,=x'4745'       sender use old format: 4745=GE
         bne   sockre02
         lh    r1,=h'1000'        set len as 1000
         st    r1,inMsgLen        override
         #set  sendNoLen          set the flag
SOCKRE02 DS    0H
         displayVar 'Request Message length= ',INMSGLEN
         displayVar 'Current buffer length= ',BUFFINLn
         L     R2,InMsgLen         Get length of message text
         LA    R2,0(,R2)           Be sure it's positive
         A     R2,=F'4'            Add 4 for the prefix
         la    r2,bufferhdrl(r2)   add bufferheader len as well
**       st    r2,inMsgLen         new length (req+overhead)
         C     R2,MAXMSGLN         Length > max length allowed ?
         BH    SOCKRE92            Yes, error exit
         L     R3,BUFFINLn         Get size current input buffer
         LTR   R3,R3               Buffer already allocated ?
         BZ    SOCKRE10            No, go allocate it
         CR    R2,R3               Current size big enough ?
         BNH   SOCKRE20            Yes, use it
*

SOCKRE08 DS    0H
         displayVar 'will free current storage:',buffina
         l     r1,buffina
         call  FREESTG              Free the old input buffer
*
SOCKRE10 DS    0H
         displayVar 'Will Alloc new storage=',(r2)
         LR    R0,R2
         L     R15,=A(GETSTGU)
         BALR  R14,R15             Get space for a new input buffer
         LTR   R15,R15             Allocate error ?
         BNZ   SOCKRE97            Yes, exit
*
SOCKRE20 DS    0H
         L     R2,BUFFINA          Get A(input buffer)
         L     R3,INMSGLEN         R3 = expected receive length
         ST    R3,(inpLen-inpBuffer)(r2)  save msg len
         LA    R2,(inpData-inpBuffer)(,r2)  R2 = A(where to recv data)
         ST    R3,RECVLEN          Save total length for RECV
*
SOCKRE30 DS    0H
**       displayVar 'before sock receive:',(r2)
         displayVar '  bufferlen:',RECVLEN
         #SOCKET RECV,SOCK=SOCKDESC,BUFFER=(R2),BUFFERL=RECVLEN,       X
               FLAGS=MSGFLAGD,RETLEN=RETLEN,                           X
               RETCODE=RETCODE,ERRNO=ERRNO,RSNCODE=RSNCODE
*
         XR    R15,R15
         IC    R15,SOCKRET1
         EX    R15,SOCKREEX        Copy the debug message text
         L     R1,RETLEN
         L     R15,=A(CNVB2D8B)
         BALR  R14,R15
         MVC   OUTAREAT+11(7),WORK2+1   Put the length really received
*
         LA    R1,OUTAREA
         L     R15,=A(DIS3RC)
         BALR  R14,R15             Display function + 3 RC's
         CLC   RETCODE,=F'0'       #SOCKET request successful ?
         BNE   SOCKRE97            No, error exit
*
         CLC   RETLEN,=F'0'        RECV length = 0 ?
         BE    SOCKRE90            Yes, error exit
*
         #test SendNoLen,off=sockre50
         l     r3,retlen
SOCKRE50 DS    0H
         s     R3,RETLEN           recvlen - retlen
         ltr   r3,r3              are there still bytes to be received?
         bnp   SOCKRE98            no, exit
         bz    SOCKRE98            no, exit
         bm    SOCKRE98            no, exit
*
         ST    R3,RECVLEN          Update remaining length to receive
         A     R2,RETLEN           Update A(where to receive data)
         B     SOCKRE30            Loop on RECV
*
SOCKRE90 DS    0H
         LA    R1,SOCKRET2         Connection has been closed
         L     R15,=A(DISLINE)
         BALR  R14,R15             Display function error message
         B     SOCKRE97            Error exit
*
SOCKRE91 DS    0H
         LA    R1,SOCKRET3         Message prefix too short
         L     R15,=A(DISLINE)
         BALR  R14,R15             Display function error message
         B     SOCKRE97            Error exit
*
SOCKRE92 DS    0H
         LA    R1,SOCKRET4         Message text too long
         L     R15,=A(DISLINE)
         BALR  R14,R15             Display function error message
         B     SOCKRE97            Error exit
*
SOCKRE97 DS    0H
         L     R15,=F'-1'          Set return code to -1
         B     SOCKRE99
*
SOCKRE98 DS    0H
*        l     r2,buffina         r2-> input buffer
*        #SNAP AREA=(0(R2),120),TITLE=' bufferin',RGSV=(R2-R8)
         l     r2,buffina         r2-> input buffer
         l     r0,(inplen-inpBuffer)(R2) r0 - text len
         la    r1,(inpData-inpBuffer)(R2) r2-> text part
         L     R15,=A(asc2ebc)    Convert to EBCDIC voor die voet
         basr  R14,R15
*        #SNAP AREA=(0(R2),84),TITLE=' bufferin ebc ',RGSV=(R2-R8)
****
         L     R15,(inplen-inpBuffer)(R2)   message length
         la    r5,(inpData-inpBuffer)(R2) r2-> text part
         la    r6,64
         cr    r6,r15
         bl    recdis3
         lr    r6,r15
recdis3  ds    0h
         displaytxt 'HTTP Request:',(r6),(r5)
         XR    R15,R15             Clear return code
*
SOCKRE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
SOCKREEX MVC   OUTAREA(*-*),SOCKRET1
*
SOCKRET1 MSGTXT '===> RECV (0000000): '
SOCKRET2 MSGTXT '===> RECV() error  : connection has been closed.'
SOCKRET3 MSGTXT '===> RECV() error  : message prefix too short.'
SOCKRET4 MSGTXT '===> RECV() error  : message text too long.'

        DROP  R12
         LTORG
*---------------------------------------------------------------------*
*- Routine to send a message to the partner.                         -*
*- The #SOCKET SEND call is placed in a loop to be sure the entire   -*
*- message is sent to the partner.                                   -*
*- Input : R1  = A(buffer to send)                                   -*
*-         SENDLEN = buffer length                                   -*
*- Output: R15 = 0 or -1 in case of error                            -*
*---------------------------------------------------------------------*
SOCKSEND DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING SOCKSEND,R12
*
         LR    R2,R1               R2 = A(data to be sent)
         L     R3,SENDLEN          R3 = length to send

*
SOCKSE10 DS    0H
*
*  display max 120 characters from send string
*
         lr    r1,r2
         l     r0,sendlen
         c     r0,=f'120'
         bl    sockse15            then is good
         l     r0,=f'120'          mx is 120
SOCKSE15 DS    0H
         l     r15,=A(disarea)
         basr  r14,r15
*
*   convert send data to ascii before we send it
*
         l     r0,sendlen
         lr    r1,r2
         l     r15,=A(ebc2asc)
         basr  r14,r15
*
         #SOCKET SEND,SOCK=SOCKDESC,BUFFER=(R2),BUFFERL=SENDLEN,       X
               FLAGS=MSGFLAGD,RETLEN=RETLEN,                           X
               RETCODE=RETCODE,ERRNO=ERRNO,RSNCODE=RSNCODE
*
sockse20 ds    0h
         XR    R15,R15
         IC    R15,SOCKSET1
         EX    R15,SOCKSEEX        Copy the debug message text
         L     R1,RETLEN
         L     R15,=A(CNVB2D8B)
         basr  R14,R15
         MVC   outAreat+11(7),WORK2+1 Put the requested length
         L     R1,SENDLEN
         L     R15,=A(CNVB2D8B)
         basr  R14,R15
         MVC   outAreat+22(7),WORK2+1 Put the length really sent
*
         LA    R1,OUTAREA
         L     R15,=A(DIS3RC)
         basr  R14,R15             Display function + 3 RC's

         CLC   RETCODE,=F'0'       #SOCKET request successful ?
         BNE   SOCKSE97            No, error exit
*
         CLC   RETLEN,=F'0'        SEND length = 0 ?
         BE    SOCKSE90            Yes, error exit
*
         C     R3,RETLEN           All requested data sent ?
         BNH   SOCKSE98            Yes, exit
         A     R2,RETLEN           Update A(remaining data to be sent)
         S     R3,RETLEN
         ST    R3,SENDLEN          Update remaining length to send
         B     SOCKSE10            Loop on SEND
*
SOCKSE90 DS    0H
         LA    R1,SOCKSET2  Connection has been closed
         L     R15,=A(DISLINE)
         basr  R14,R15             Display function error message
         B     SOCKSE97            Error exit
*
SOCKSE97 DS    0H
         L     R15,=F'-1'          Set return code to -1
         #abend ABCODE='boem'
         B     SOCKSE99
*
SOCKSE98 DS    0H
         XR    R15,R15             Clear return code
*
SOCKSE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
SOCKSEEX MVC   OUTAREA(*-*),SOCKSET1
*
SOCKSET1 MSGTXT '===> SEND (0000000 of 0000000): '
SOCKSET2 MSGTXT '===> SEND() error  : connection has been closed.'

        DROP  R12

*---------------------------------------------------------------------*
*- Close the socket                                                  -*
*---------------------------------------------------------------------*
CLSOCK   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING CLSOCK,R12
***      #test debug,off=clsock10
         b  clsock10
         mvc   SENDLEN,=f'95'
         mvc   RETlen,=f'95'
         mvc   RETCODE,=f'0'
         mvc   ERRNO,=f'0'
         mvc   RSNCODE,=f'0'
         xr    r15,r15
         b     clsock20
clsock10 ds 0h
         #SOCKET CLOSE,SOCK=SOCKDESC,                                  X
               RETCODE=RETCODE,ERRNO=ERRNO,RSNCODE=RSNCODE
*
clsock20 ds 0h
         LA    R1,LISMSG01
         L     R15,=A(DIS3RC)
         basr  R14,R15             Display function + 3 RC's
CLSOCK99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
LISMSG01 MSGTXT '===> CLOSE         : '
*
*---------------------------------------------------------------------*
*- Routine to parse the request                                      -*
*- Input : R0  = length of input parameters string                   -*
*-         R1  = A(input parameters string)                          -*
*- Output: 4 addresses populated                                     -*
*-         methodA, uriA, headerA, parmA                             -*
*-           with methodLen, uriLen, headerLen  parmLen              -*
*-         R15 = 0 or -1 in case of error                            -*
*---------------------------------------------------------------------*
PARSreq  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING PARSreq,R12
*
         LR    R3,R0               Get length of parameters
         LR    R6,R1               Get A(request) - inpbuffer
         using inpBuffer,r6
         l     r6,buffina         r6 -> input buffer
         la    r2,inpData
*
*------------------------------------------------*
*- Extract the requested Method                 -*
*------------------------------------------------*
         displayMsg 'IN parseReq'
* init
         sr    r15,r15
         st    r15,reqUriLen
         st    r15,reqMimeLen
         st    r15,reqParmLen
         st    r15,bdyParmLen
PARSRQ10 DS    0H
         CLI   0(R2),C' '
         BNE   PARSRQ20
         LA    R2,1(,R2)
         BCT   R3,PARSRQ10         Skip all blanks
         B     PARSRQ90            Exit
*
PARSRQ20 DS    0H                1st parm = method
         st    R2,methodA
         st    r2,reqStrtA       save start address
         lr    r1,r2               save start address
PARSRQ21 ds    0h
         CLI   0(R2),C' '          seperator is a space
         BE    PARSRQ25
         LA    R2,1(,R2)
         BCT   R3,PARSRQ21         Skip over the method
         B     PARSRQ90            only a command?
*
PARSRQ25 ds    0h
         CLC   0(4,R1),=CL4'GET '  make sure its only a get
         BNE   PARSRQ26
         #SET  getcmd              mark it as GET
         B     PARSRQ30            Process the uri
*
PARSRQ26 ds    0h
         CLC   0(4,R1),=CL4'PUT '  make sure its only a get
         BNE   PARSRQ27
         #SET  putcmd              mark it as PUT
         B     PARSRQ30            Process the uri
*
PARSRQ27 ds    0h
         CLC   0(5,R1),=CL5'POST '  make sure its only a POST
         BNE   PARSRQ28            its a error
         #SET  postCmd             mark it as POST
         B     PARSRQ30            Process the uri
*
PARSRQ28 ds    0h
         CLC   0(7,R1),=CL7'DELETE ' make sure its only a DELETE
         BNE   PARSRQ90            its a error
         #SET  deletCmd            mark it as DELETE
         B     PARSRQ30            Process the uri
rq2710   ds    0h
         cli   0(r5),c' '          a space?
         be    rq2720
         la    r5,1(r5)            next pos
         b     rq2710
rq2720   ds    0h
         l     r7,retlen
         la    r3,inpData
         lr    r4,r0
         lr    r5,r1
q2701    ds    0h
         c     r7,=f'50'
         bl    q2702
         l     r0,=f'50'
         b     q2703
q2702    ds    0h
         lr    r0,r7
q2703    ds    0h
         lr    r1,r3
         l     r15,=a(disarea)
         basr  r14,r15
         la    r3,50(r3)
         s     r7,=f'50'
         ltr   r7,r7
         bp    q2701
         lr    r0,r4
         lr    r1,r5
         B     PARSRQ30            Process the uri
*
RQ2790   DS    0h
*
* now for the uri
PARSRQ30 DS    0H
         lr    r15,r2
         sr    r15,r1               calc the length
         st    r15,methodLen        and save it
PARSRQ31 DS    0H
         CLI   0(R2),C' '
         BNE   PARSRQ32
         LA    R2,1(,R2)
         BCT   R3,PARSRQ31         Skip all blanks
         B     PARSRQ98            Exit
* at the uri
PARSRQ32 DS    0H                1st parm = method
         cli   0(r2),c'/'        the start of the uri
         bne   PARSRQ90          very unlikely
         st    r2,lastSlashA      want addr of last /
         LA    R2,1(,R2)         skip over the /
         BCTR  R3,0              and decrement the length
         st    R2,reqUriA
         lr    r1,r2               save start addr
* scan the uri for a '.?/ '
PARSRQ34 DS    0H
         cli   0(r2),c' '         end of uri?
         be    PARSRQ40
         cli   0(r2),c'.'         found a req mime prefix ?
         be    PARSRQ36
         cli   0(r2),c'/'         found a /
         be    PARSRQ37
         cli   0(r2),c'?'         found a ?
         be    PARSRQ38
PARSRQ35 DS    0H                1st value= method
         la    r2,1(,r2)           next pos and loop
         BCT   R3,PARSRQ34
         B     PARSRQ91            no headers ? expecting HTTP/?.?
* '.'
PARSRQ36 DS    0H                  found '.'
         #set  mimeFnd             mark that we found a mime
         la    r0,1(,r2)           skip the .
         st    r0,reqMimeA
         b     PARSRQ35
* '/'
PARSRQ37 DS    0H
         st    r2,lastSlashA      want addr of last /
         b     PARSRQ35           back to the loop
* '?'
PARSRQ38 DS    0H
         st    r2,reqUriEndA       Uri and Mime end addr
         #set  uriEnd              mark end of uri found
         #set  parmFnd             mark that we found a parm
         la    r0,1(,r2)           skip the ?
         st    r0,reqParmA
         b     PARSRQ35           back to the loop
* end of uri and parms
PARSRQ40 DS    0H
         st    r2,reqEndA          r2 -> request end address
         #TEST parmFnd,OFF=PARSRQ41
         l     r5,reqParmA         r5 ->begin of parm
         lr    r4,r2               r4 = end of parm
         sr    r4,r5
         st    r4,reqParmlen        save parm length
         b     PARSRQ41
PARSRQ41 DS    0H
         #test uriEnd,on=PARSRQ42   if a uri end was not found
         st    r2,reqUriEndA        save r2 as the uri end addr
* process mime
PARSRQ42 DS    0H
         #TEST mimeFnd,OFF=PARSRQ44
         #set  webReq
         l     r4,reqMimeA           mime begin addr
         l     r5,reqUriEndA         mime end addr
         sr    r5,r4                 calc mime length
         st    r5,reqMimeLen
*
         lr    r0,r5                  mime length
         lr    r1,r4                  mime address
         Call  ucase
*
         la    r1,tracemsgh2
         mvc   11(4,r1),0(r4)
         Call  disLine            display sendbuff in log
*
         b     traceh2
tracemsgh2  msgtxt 'mime type xxxx'
traceh2  ds    0h
*
         clc   0(4,r4),=cl4'HTML'
         be    PARSRQ43H
         clc   0(3,r4),=cl3'ICO'
         be    PARSRQ43I
         clc   0(3,r4),=cl3'JPG'
         bNE   PARSRQ44           handle it as an endpoint
         #set  mimeJPG            just for frustration
         b     PARSRQ46
PARSRQ43H DS   0H
         #set  mimeHTML
         b     PARSRQ46
PARSRQ43I DS   0H
         #set  mimeICO
         b     PARSRQ46
*
*  no mime then request must be an endpoint
PARSRQ44 DS    0H
         #set  Endpoint
*
*  finising up - calc the uri length
PARSRQ46 DS    0H
         l     r4,reqUriA
         l     r5,reqUriEndA
         sr    r5,r4
         st    r5,reqUriLen
* HTTP/?.?  should be next
         clc   1(4,r2),=cl4'HTTP'
         BNE   PARSRQ90      go and complain
*
         l     r0,reqUriLen
         l     r1,reqUriA
         call  ucase              uppercase the uri
*
**       displayMsg 'parsing ok'
traceh1  ds    0h
*
*        b     PARSRQ98      set rc and exit
*
* for a POST & PUT the data will be passed as bodyparms in the header
* we will search for the header length, and then search for the parms
* the parms is a string preceeded by 4 blanks (by geneva convention)
* not so sure of the 4 blanks, maybe two sets of crlf pairs
* get the size of the whole request header
*  Content-Length: nnn
*

         #TEST updtCmd,ANY=PARSRQ50   check for body parms
         displaymsg 'request has no bodyparms'   check for body parms
         b PARSRQ98
PARSRQ50 ds    0h
         st    r1,reqCurA    save our registers from disaster
         st    r2,reqCurA2
         st    r4,reqLen         remaining length
         displayMsg 'Search for bodyparms'
         la    r3,srchCtlPrm
         using srchCtl,r3
         la    r0,0
         st    r0,strtPos          set strtpos to 0
         la    r0,l'contentLit     length of contentSize str
         st    r0,srchKeyLn        save it as the search val len
         la    r15,contentlit
         st    r15,srchKeyA         set it as search for str addr
         st    r2,srchStrA         current buffer is search-in str
         st    r4,srchStrLn        save remaining length as srchin len
         lr    r1,r3               r1 -> srch ctl
*
         Call  strSrch
         ltr   r15,r15             did we find the literal?
         bm    PARSRQ98           no content-length
* we found the lit
         displayMsg 'got content-length'
         la    r1,srchCtlPrm       rebase R1
         l     r4,srchStrA         r4-> begin buffer
         a     r4,fndAtPos         r4->'Content-Length:'
         a     r4,srchKeyLn        point pass the literal
         la    r4,1(r4)            point pass the space
         l     r0,srchStrA
         sr    r0,R4               r0 is negative
         l     r15,srchStrLn       length of buffer
         ar    r15,r0              substract skipped part
         st    r15,srchStrLn       set new length
         st    r4,srchStrA         set a new strtpos
* find the end of the parm
         la    r0,crlf2
         st    r0,srchKeyA         set the key as CRLF
         la    r0,2
         st    r0,srchKeyLn       set the length
         call  strSrch
         ltr   r15,r15             did we fnd the length
         bm    PARSRQ98            nope
         l     r0,fndAtPos
         s     r0,strtPos          length=endpos-startpos
         l     r1,srchStrA         the beginning
         call cnvd2b               convert to binary
         st    r15,bdyParmLen      store it as the body parm length
         displayVar 'search for body parms len=',bdyParmLen
* search for the start of the in-body parmblock preceded by 2xcrlf
         la    r1,srchCtlPrm       rebase R1
         la    r0,crlf4
         st    r0,srchKeya
         la    r0,4
         st    r0,srchKeyln
         call strsrch               search for parm prefix (4 crlf)
         ltr   r15,r15              any parms send?
         bnm   parsrq05              found it
*
         la    r0,4                  else try with 4 blanks
         st    r0,srchKeyln
         la    r0,=cl4'    '         4 blanks
         st    r0,srchKeya
         call strsrch               search for parm 4 blanks
         ltr   r15,r15              foundit?
         bm    parsrq90             nope
PARSRQ05 ds    0h
         a     r15,srchStra         convert position to Addr
         la    r15,4(r15)           point pass parm prefix 0d0a0d0a
         st    r15,bdyParmA         save the address
         #set  bdyParms
         displayTxt 'request contains body parms',bdyParmLen,bdyParma
         b     PARSRQ98             and continue
contentLit     dc c'Content-Length:'
crlf4    dc    xl4'0D0A0D0A'
         org   crlf4
crlf2    ds    xl2
         org
*------------------------------------------------*
*- Exits                                        -*
*------------------------------------------------*
PARSRQ90 DS    0H
*
*        displayMsg 'invalid http request'
         LA    R1,PARSRQT1         Invalid http request
         B     PARSRQ97            Error exit
*
PARSRQ91 DS    0H
*
*        displayMsg 'invalid http format'
*
         LA    R1,PARSRQT2         Invalid HTTP format
         B     PARSRQ97            Error exit
*
PARSRQ97 DS    0H
         L     R15,=A(DISLINE)
         basr  R14,R15             Display error message
         XR    R0,R0               Clear remaining length
         XR    R1,R1               Clear remaining parameters address
         L     R15,=F'-1'          Set return code to -1
         B     PARSRQ99
*
PARSRQ98 DS    0H
         LR    R0,R3               Return R0 = remaining length
         LR    R1,R2               Return R1 = A(remaining parameters)
         SR    R15,R15             Clear return code
*
PARSRQ99 DS    0H
*        displayMsg 'methodL,A,StrtA,enda,UriL,A,MimeL,A,ParmL,A'
*        #SNAP AREA=(0(R6),64),TITLE=' bufferin',RGSV=(R2-R8)
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
PARSRQT1 MSGTXT 'Invalid command.'
PARSRQT2 MSGTXT 'Invalid HTTP request format.'
*
        DROP  R12
        DROP  R3
         LTORG
*---------------------------------------------------------------------*
*- initial setup of the CodeTableEntry structure just after loading -*
*- R1 -> code table R0->CTE structure that needs to be populated    -*
*---------------------------------------------------------------------*
tblSetup DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING tblSetup,r12
         lr r2,r0            r2 -> CodeTblEntry = endpCTE
         lr r6,r1            r6 -> Code Table
         using  CodeTblHdr,R6
         using  CodeTblEntry,r2
*        #SNAP AREA=(0(r6),20),TITLE=' codetbl-hdr   ',RGSV=(R2-R8)
*        #SNAP AREA=(0(r2),20),TITLE=' codetbl-entry ',RGSV=(R2-R8)
         #test  TBTLIN,ON=tsup010
* binary search so fix length key & value
         sr     r0,r0
         ic     r0,TBTKEYL             length of keys
         st     r0,tblkeyln
         lh     r0,TBTKEYOF            key offset
         a      r0,TBTSTART            offset to start of tableent
         ar     r0,r6                  convert to a address
         st     r0,tblKeyA             get the key offset
         a      r0,tblkeyln            convert to a addr
         st     r0,tblvala             and save it
         lh     r0,TBTELEN             get total entry length
         s      r0,tblkeyln            subtract key length
         st     r0,tblvalln            save value length
         b      tsup020
tsup010  ds     0h
* search is linear.Setup the CodeTableEntry structure
         l      r15,TBTKEYOF
         ar     r15,r6                  convert to a address
*  r0-> x'B0' should be
         sr     r0,r0
         ic     r0,1(,r15)             second byte has length
         a      r0,tblkeyln            convert to a addr
         la     R15,2(,r15)            r15->key
         st     r15,tblKeyA            get the key offset
         ar     r15,r0
         st     r15,tblvala            and save it
         bctr   r15,0
         sr     r0,r0                  set to 0
         ic     r0,0(r15)             get value length
         st     r0,tblvalln            save value length
tsup020  ds     0h
tsupXIT  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*---------------------------------------------------------------------*
*- find a record in the map                                          -*
*-    parms:                                                         -*
*-       1  -> mapctl -- containing jsonrecname, idms rec a          -*
*-       2  # of map records                                         -*
*-       3  -> list of map record names                              -*
*-       4  -> list of rec bind addr's                               -*
*-  return                                                           -*
*-      r1 - record buffer address                                   -*
*-note: the record name in the json mapping module is in uppercase   -*
*---------------------------------------------------------------------*
findMaprec ds 0h
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING findMapRec,R12
         USING jrec,r6          r6->jsonmap rec
****     USING jmapctl,R2
****     l     r2,0(,r1)        r2 -> mapctl
         l     r6,0(,r1)        r2 -> jsonmap rec addr
         l     r3,4(,r1)        r3 =  # of map records
         l     r4,8(,r1)        r4 -> list of map record names
         l     r5,12(,r1)       r5 -> list of rec bind addr's
****     l     r6,jcurReca      r6-> json ele record name
*        #SNAP AREA=(0(r2),32),TITLE=' cur entry',RGSV=(R2-R8)
*        #SNAP AREA=(0(R4),64),TITLE=' recnames',RGSV=(R2-R8)
*        #SNAP AREA=(0(R5),16),TITLE=' recaddr ',RGSV=(R2-R8)
cmpNam1 ds     0h
*       #SNAP AREA=(0(R4),64),TITLE=' currec  ',RGSV=(R2-R8)
        la     r0,32
        lr     r1,r4
        call   strlen
        bctr   r15,0
        ex     r15,cmpRecNam
        be     cmpNam2
        la     r4,32(r4)              next record name
        la     r5,4(r5)               next record bind address location
        bct    r3,cmpNam1             reached end of the list ?
        b      cmpNamE                yes, report an error
cmpRecNam clc  0(*-*,r4),jrecname     (based on r6)
cmpNam2 ds     0h
        l      r5,0(r5)                load the rec address
**      st     r5,jidmsReca            save record bind address
        la     r1,32
        displayTxt 'target record found',(r1),(r4)
*        #SNAP AREA=(0(R5),64),TITLE=' recData ',RGSV=(R2-R8)
        xr     r15,r15              set return code
        b      cmpNam9
cmpNamE  ds    0h
        la     r1,32
        displayTxt 'json map record not found',(r1),(r6)
        la     r15,3                set return code
        b      cmpNam9
cmpNam9  ds    0h
         lr    r1,r5               r1->idms record buffer addr
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop  r2
*---------------------------------------------------------------------*
*- search for a key in the mapping load module                       -*
*- r15=0 then found  else not found                                  -*
*- on exit r15 -> jEle dsect describing the element                  -*
*-    -1 then not found                                              -*
*---------------------------------------------------------------------*
findKey  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING findKey,R12
         l  r3,0(r1)         r3 -> search keylen,keya of key to search
         l  r6,4(r1)         r6 -> loaded mapping module address
         using  srchCtl,R3
         using  jschema,R6
         displayMsg 'loadmod ',l8,jschname
         lh     r3,jsrecCnt        # of records
         la     r6,jSchemaLn(r6)   r6-> 1st record
         drop r6
         using  jrec,r6            r6-> records
         lr     r4,r3
         mh     r4,jrecLn          rec entry len * #
         using  jele,r4            r4->elements
* upper case the search string
         l      r0,srchKeyLn       the length
         la     r1,srchKeyA        address of key
         Call   ucase              convert the srchKey to uppercase
*
fklm005  ds     0h
         lh     r2,jrelecnt        r2 = # elements for cur record
fklm010  ds     0h
         ex     r15,cmpKey
         be     fklm020            element founded
         la     r4,jEleLn(r4)     point to next element
         bct    r2,fklm010
         la     r6,jSchemaLn(r6)   r6-> nxt record
         bct    r3,fklm005         loop for next record
         l      r15,=f'-1'
         b      fklm050            report that element was not found
cmpkey   clc    0(*-*,r3),jeElement

*
fklm020  ds    0h
         st    r4,fndAtPos         save the address
         xr    r15,r15
         displayTxt 'srch found ',srchKeyln,srchKeyA
         b     fklmXit
*
fklm050  ds    0h
         displayTxt 'srch nfound',srchkeyln,srchkeyA
         l    r15,=f'-1'
fklmXIT  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop r3
         drop r6
         ltorg
*---------------------------------------------------------------------*
*- search for a key in a codetable                                   -*
*- r15=0 then found  else not found                                  -*
*- on exit the passed codetableEntry will contain the row info of    -*
*-    the row where key was found, not that it was missing, located  -*
*---------------------------------------------------------------------*
findTblKey ds  0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING findTblKey,R12
         l  r3,0(r1)         r3 -> search keylen,keya of key to search
         l  r6,4(r1)         r6 -> loaded code table address
         l  r2,8(r1)         r2 -> CodeTblEntry = endpCTE -> proc resul
         using  CodeTblEntry,r2
         using  srchCtl,R3
         using  CodeTblHdr,R6
fkey020  ds     0h
         lh     r7,TBTN            number of table entries
*
* upper case the search string
         l      r0,srchKeyLn       the length
         la     r1,srchKeyA        address of key
         Call   ucase              convert the srchKey to uppercase
*
         displayTxt 'in findkey- searchKey',srchKeyLn,srchKeyA
         displayVar 'keylen=',srchkeyln
         #test  TBTLIN,OFF=fkey030    the keyln is the real length
         mvc   tblKeyTLn,tblKeyLn     set the trimmed length
fkey030  ds    0h
** at long last can we do actual comparing of keys
*
         #test  TBTLIN,ON=fkey032    the keyln is the real length
*
         l     r1,tblkeya         r1-> key
         l     r0,tblkeyln        r0=length
         call  StrLen             get string length
         st    r15,tblKeyTLn      save the trimmed length
*
fkey032  ds    0h                  ucase the tblKey
**       displayTxt 'in findkey- curTblKey',tblKeyTln,tblKeyA
**       displayVar 'tblkeylen=',tblkeyTln
         l      r15,tblKeyTLn       the length
         l      r1,tblKeyA         address of key
** copy the key to local storage (stor protect issue)
         bctr   r15,0              bump the length
         ex     r15,movkey         move to local storage
         l      r0,tblKeyTLn       the length
         la     r1,ltblKey
         call   uCase              convert key to uppercase
         b      fkey033
movKey     mvc   ltblKey(0),0(r1)
fkey033  ds    0h                  ucase the tblKey
*
*        #test debug,off=trace1
*
*        b     trace1
**       displayTxt 'search key',srchKeyLn,srchKeyA
*
trace1   ds    0h
         clc    tblKeyTln,srchKeyLn  is the lengths the same?
         BNE    fkey034
         la     r15,lTblKey        r15-> current key (local copy)
         l      r8,srchKeyA        r0-> search key
         l      r1,tblKeyTln       maybe a reload
         bctr   r1,0
         ex     r1,compkeys        r1=len, keys =?
         be     fkey050            yes and exit
fkey034  ds    0h                  nope, next entry
         #test  TBTLIN,ON=fkey041
         l     r15,tblKeya         r15-> current key entry
         ah    r15,TBTELEN         r15-> next entry
         st    r15,tblKeyA
         l     r15,tblVala         r15-> current value entry
         ah    r15,TBTELEN         r15-> next entry
         st    r15,tblValA
         b     fkey042
fkey041  ds    0h
* search is linear.Setup the CodeTableEntry structure
         l      r15,tblValA
         a      r15,tblValln            point to next key
*  r0-> x'B0' should be
         lh     r0,0(,r15)             get nxt entry length
         ni     r0,x'0f'               second byte has length
         st     r0,tblkeyln            save the length
         la     r15,2(,r15)            r15->key
         st     r15,tblkeyA            save the address
*
         sr     r0,r0                  set to 0
         ic     r0,1(,r15)             get value length
         st     r0,tblvalln            save value length
         la     R15,1(,r15)            r15->entry value
         st     r15,tblvalA            and save it
*
fkey042  ds    0h
         Bct   r7,fkey030
         displayTxt 'key not found:',tblKeyln,tblKeyA
         la    r15,1               key not found
         b     fkeyxit
fkey050  ds    0h
         displayTxt 'srch Result',tblValln,tblValA
         xr    r15,r15             key found
fkeyXIT  DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
compkeys clc   0(*-*,r15),0(r8)     compare key values
         drop r2
         drop r3
         drop r6
*---------------------------------------------------------------------*
*-  String Search                                                    -*
*-                                                                   -*
*- Input : R1  = srchStrCtl structure                                -*
*-                                                                   -*
*- Output : r15 -> fnd pos or -1                                     -*
*---------------------------------------------------------------------*
StrSrch  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
        USING StrSrch,r12
*
*  r1  will point to srchCtl defined by
*  srchKeyLn    ds  F               length of str
*  srchKeyA     ds  A               string to search for
*  srchStrLn    ds  F               length of seached string
*  srchStrA     ds  A               address of string to search
*  strtPos      ds  F               position to start srch at
*  fndAtPos     ds  F               position of found string
*
         lr   r3,r1
         using srchCTL,r3
*        #SNAP AREA=(0(R3),32),TITLE=' srchCtl tbl',RGSV=(R2-R8)
         l    r2,srchKeyA          r2-> srchKey
strs001  ds   0h
         l    r0,strtPos
         l    r15,srchStrLn
         cr   r0,r15            is startPos > search-in str len?
         bh   strs990
         a    r0,srchKeyln      strtpos+srchKeyLn > srchStrln ?
*        a    r0,strtPos        is search-in str longer then the
         cr   r0,r15            startpos + srch-str len
         bh   strs990          technically only this 2nd test is needed
*
         l    r7,srchStrLn
         l    r15,srchKeyLn
         sr   r7,r15               r7=potential #of comparisons
         l    r0,strtpos           r0=strtpos
         sr   r7,r0                r7=number of comparisons
         l    r1,srchStrA
         ar   r1,r0                position of 1st compare pos
         bctr r15,0             subtract one - i do not know why
         b    strs010
strs010  ds   0h
         ex   r15,cmpStr
         be   strs020              jippie
         la   r1,1(r1)
         bct  r7,strs010           try again
strs990  DS    0h
         l    r15,=f'-1'
         b    strs999              go and tell
*
         ds   0h
cmpStr   clc  0(*-*,r1),0(r2)      compare the string
*
strs020  ds   0h
         l    r15,srchStrA         search-in str start addres
         sr   r1,r15               where we found the search string
         lr   r15,r1               r15 = pos found
         st   r15,fndAtPos         save position of string
strs999  DS    0h
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop  r3
*---------------------------------------------------------------*
*  strlen
*- Input : R0 = string length with padded spaces               -*
*-         R1 -> string
*- Output : r15 -> trimmed string length                       -*
*---------------------------------------------------------------*
strlen  DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING strlen,r12
         lr    r2,r1               save str start
         ar    r1,r0               point to end of the str
         lr    r15,r0
strlen10 ds    0h
         bctr  r1,0
         cli   0(r1),c' '
         be    strlene
         cli   0(r1),x'00'
         be    strlene
         b     strlenx
strlene  DS    0H
         bct   r15,strlen10
strlenx  DS    0H
         lr    r1,r2               restore str pointer
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*     R15 = str length
*
ucase   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING ucase,R12
         LR    r15,r0              length to convert
         LR    r3,r1               addr of string to convert
         ex    r15,conv2upp           convert to upper
ucaseE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
*
conv2upp   tr    0(*-*,R3),l2ucase
*

lcase   DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING lcase,R12
*        tr    upcase(10),u2lcase
*        tr    lwcase(10),u2lcase
         LR    r15,r0              length to convert
         ex    r15,conv2low           convert to ascii
lcaseE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
*
conv2low   tr    0(*-*,R1),u2lcase
*upcase   dc cl10'ABCDEFGHIJ'
*lwcase   dc cl10'abcdefghij'
*

ebc2asc DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING ebc2asc,R12
         l     r4,reqtbla
         using reqtbl,r4
         LR    r2,r0              length to convert
         LR    r3,r1
*********************************************************
*  Call IDMSIN01 to request a 'STRCONV' to convert a string
*  from EBCDIC to ASCII
*    CONVFUN - specifies which conversion:
*       ETOA - EBCDIC to ASII
*       ATOE - ASCII to EBCDIC
*
*    BUFFER - SPECIFIES STRING TO CONVERT
*    BUFFERL- SPECIFIES LENGTH OF STRING
*********************************************************
*        MVC   CONVFUNC,=A(CONVFE2A)        Convert EBCDIC to ASCII
*        IDMSIN01 STRCONV,                                            X
*              CONVFUN=CONVFUNC,                                      X
*              BUFFER=(r3),                                           X
*              BUFFERL=(r2),                                          X
*              ERROR=olde2a
*              b     ebc2ae99
**
olde2a   ds   0h
         lr    r1,r3
         la    r15,255
ebc2aE10 DS    0H
         cr    r2,r15            more than 248 to move?
         bh    ebc2ae20           yes
         lr    r15,r2             move the last bit
ebc2aE20 DS    0H
         ex    r15,conv2asc       convert to ascii
         la    r1,256(r1)         move on
         sr    r2,r15
         ltr   r2,r2
         bp    ebc2aE10
ebc2aE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
conv2asc   tr    0(*-*,R1),ebc2asct
          drop   R4
*

asc2ebc DS    0H
         #SAVEREG                  Save the caller's registers
         LR    R12,R15
         USING asc2ebc,R12
         l     r4,reqtbla
         using reqtbl,r4
         LR    r3,r1              addr   to convert
         LR    r2,r0              length to convert
*        b     olda2e
*--------------------
*********************************************************
*  Call IDMSIN01 to request a 'STRCONV' to convert a string
*  from ASCII to EBCDIC
*    CONVFUN - specifies which conversion:
*       ETOA - EBCDIC to ASII
*       ATOE - ASCII to EBCDIC
*
*    BUFFER - SPECIFIES STRING TO CONVERT
*    BUFFERL- SPECIFIES LENGTH OF STRING
*********************************************************
*        MVC   CONVFUNC,=A(CONVFA2E)        Convert ASCII to EBCDIC
**             CONVFUN=CONVFUNC,                                      X
*        IDMSIN01 STRCONV,                                            X
*              CONVFUN='ATOE',                                        X
*              BUFFER=(r3),                                           X
*              BUFFERL=(r2),                                          X
*              ERROR=olda2e
*              b     asc2ee99
olda2e   ds  0h
         la    r15,255
asc2eE10 DS    0H
         cr    r2,r15            more than 255 to move?
         bh    asc2ee20           yes
         lr    r15,r2             move the last bit
asc2eE20 DS    0H
         ex    r15,conv2ebc       convert to ascii
         la    r1,256(r1)         move on
         sr    r2,r15
         ltr   r2,r2
         bp    asc2eE10
*--------------------
asc2eE98 DS    0H
*        displayvar  'idmsin01 is erg ongelukkig EtoA',(r15)
asc2eE99 DS    0H
         #RESTREG                  Restore the caller's registers
         BR    R14                 Return to the caller
         drop  r4
*
CONVFE2A dc cl4'ETOA'                  - EBCDIC -> ASCII
CONVFA2E dc cl4'ATOE'                  - ASCII  -> EBCDIC
conv2ebc   tr    0(*-*,R1),asc2ebct
L2Ucase dc  256al1(*-l2ucase)
        org l2ucase+c'a'
        dc c'ABCDEFGHI'
        org l2ucase+c'j'
        dc c'JKLMNOPQR'
        org l2ucase+c's'
        dc c'STUVWXYZ'
        org ,
*
U2Lcase dc  256al1(*-u2lcase)
        org u2lcase+c'A'
        dc c'abcdefghi'
        org u2lcase+c'J'
        dc c'jklmnopqr'
        org u2lcase+c'S'
        dc c'stuvwxyz'
        org ,
*
EBC2ASCt ds  0CL256
*     <            0 1 2 3 4 5 6 7 8 9 A B C D E F
*   change 5a to 21 from 5d
a2e00    dc   Xl16'000102030405060708090A0B0C0D0E0F'
a2e10    dc   Xl16'101112131A1A081A18191A1A1C1D1E1F'
a2e20    dc   Xl16'1A1A1A1A1A0A171B1A1A1A1A1A050607'
a2e30    dc   Xl16'1A1A161A1A1A1A041A1A1A1A14151A1A'
a2e40    dc   Xl16'201A1A1A1A1A1A1A1A1A5B2E3C282B21'
a2e50    dc   Xl16'261A1A1A1A1A1A1A1A1A21242A293B5E'
a2e60    dc   Xl16'2D2F1A1A1A1A1A1A1A1A7C2C255F3E3F'
a2e70    dc   Xl16'1A1A1A1A1A1A1A1A1A0D3A2340273D22'
a2e80    dc   Xl16'1A6162636465666768691A1A1A1A1A1A'
a2e90    dc   Xl16'1A6A6B6C6D6E6F7071721A1A1A1A1A1A'
a2eA0    dc   Xl16'1A0A737475767778797A1A1A1A5B1A1A'
a2eB0    dc   Xl16'1A1A1A1A1A1A1A1A1A1A1A1A1A5D1A1A'
a2eC0    dc   Xl16'7B4142434445464748491A1A1A1A1A1A'
a2eD0    dc   Xl16'7D4A4B4C4D4E4F5051521A1A1A1A1A1A'
a2eE0    dc   Xl16'5C1A535455565758595A1A1A1A1A1A1A'
a2ef0    dc   Xl16'303132333435363738391A1A1A1A1A1A'

ASC2EBCt ds  0CL256
         dc    Xl16'000102030405060708090a0B0C0D0E0F'
         dc    xl16'101112133C3D322618193F271C1D1E1F'
         dc    Xl16'404F7F7B5B6C507D4D5D5C4E6B604B61'
         dc    Xl16'F0F1F2F3F4F5F6F7F8F97A5E4C7E6E6F'
         dc    Xl16'7CC1C2C3C4C5C6C7C8C9D1D2D3D4D5D6'
         dc    Xl16'D7D8D9E2E3E4E5E6E7E8E9ADE0BD5F6D'
         dc    Xl16'79818283848586878889919293949596'
         dc    Xl16'979899A2A3A4A5A6A7A8A9C06AD0A107'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'
         dc    Xl16'3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F3F'


