*NODMLIST
         TITLE 'ISPTMAPR   - RHDCMAPR replacement for TCPIP'
*---------------------------------------------------------------------*
*  call ISPTRDR or ISPTWTR if the line is TCPIP, else return          *
*                                                                     *
*  will be installed as a RHDCMAPR hook by ISPTVECT                   *
*                                                                     *
*---------------------------------------------------------------------*
         copy isptmac
*---------------------------------------------------------------------*
ISPTDR   CSECT
         @MODE MODE=IDMSDC
         #MOPT CSECT=ISPTDR,AMODE=ANY,RMODE=ANY,ENV=USER
         ENTRY ISPTEP01
ISPTEP01 DS     0H
         basr  R12,0
         BCTR  R12,0
         BCTR  R12,0
        USING ISPTEP01,R12
         USING csa,R10
         USING tce,R9
         b     start
         @INVOKE MODE=IDMSDC,MAP=EMPMAP,MAP=ISPTMLOD,MAP=TESTM001
** code to ease debugging -- vtam tasks ISPTDR,ISPTRDR& ISPTWTR will
** still call RDR & wtr as part of the mapin/out
**
start    ds  0h
         using workarea,r11
         #GETSTG TYPE=(USER,LONG,KEEP),PLIST=*,LEN=WORKAREL,           *
               STGID='SYB4',COND=(ALL),ERROR=ERRORTN,ADDR=(R11),       *
               INIT=X'00',RGSV=(R2-R8)
* ACQUIRE VARIABLE STORAGE
         SPACE 1
         #MAPBIND MRB=EMPMAP                  BIND MAP AND RECORDS
         #MAPBIND MRB=EMPMAP,RECNAME=EMPMAP_WORK_RECORD
         #MAPBIND MRB=EMPMAP,RECNAME=EMPLOYE,VERSION=100
         SPACE 1
         #MAPBIND MRB=ISPTMLOD                BIND MAP AND RECORDS
         #MAPBIND MRB=ISPTMLOD,RECNAME=ISPTDLOD_WORK
         #MAPBIND MRB=ISPTMLOD,RECNAME=ISPT_JSONSCHEMA
         SPACE 1
         #MAPBIND MRB=TESTM001                BIND MAP AND RECORDS
         #MAPBIND MRB=TESTM001,RECNAME=TEST_RECORD
         SPACE 1
         xr    r1,r1
         st    r1,parm3      msg address
         st    r1,parm4      msglen
         l     r1,x7F
         st    r1,parm1      x'7F'
*        #SNAP AREA=(0(R2),64),TITLE=' ISPTMAPR - IParm',RGSV=(R2-R8)
*        la    r1,ISPTMLOD
         la    r1,ISPTMLOD     default is isptmlod
         st    r1,parm2      mrb
         l     r8,parm2
         using mrb,r8
*
         #GETSTG TYPE=(USER,SHORT,KEEP),LEN=reqTblL,ADDR=(R4),         X
               init=X'00',COND=ALL,stgID='#REQ',NWSTXIT=SRV120
         LTR   R15,R15             Request successful ?
         bnz   srv120   -- for now
SRV120   DS    0h
**       st    r4,reqTblA          save the addr of newly acquired stg
**       st    r3,reqTblLen
         using reqTbl,r4
         mvc   0(3,r4),=cl4'#REQ'
* set some defauts and endpoint tbla
         la    R15,endpCTE         get addr endpoint code table entry
         st    R15,endpCTEa        save endpoint code table entry a
         la    R15,parsedEndpt     get addr of endpoint storage
         st    R15,endpointA       save it
         mvi   parsedEndPt,c' '
         mvc   parsedEndPt+1(l'parsedEndPt-1),parsedEndPt
**       mvc   SOCKDESCg      copy sock info from reqtbl
**       mvc   SOCKDESAg
         #set  debug                   set debug flag from server
         #set  server                set the writer as the curr proc
         #set  outjson

*
*
*
         #ACCEPT TYPE=TASKCODE,FIELD=TASKCODE
         clc   taskcode,tdriver
         be    callRdr
         clc   taskcode,treader
         be    callRdr
         clc   taskcode,twriter
         be    callWtr
         clc   taskcode,tempr
         be    callEmprdr
         clc   taskcode,tempw
         be    callEmpWtr
         clc   taskcode,testw
         be    callTstWtr
         b     return
*
errortn  ds    0h
         dc    x'00'
*
callEmprdr ds  0h
       #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg2)X
               ,RGSV=(R2-R8)
         #GETSTG TYPE=(USER,SHORT,KEEP),LEN=reqTblL,ADDR=(R5),         X
               init=X'00',COND=ALL,stgID='#BUF',NWSTXIT=rdr120
rdr120   ds    0h
* set MRB to EMPMAP
         #set server
*  the real data follows
         using InpBuffer,r5
         mvc  inpLen,=f'38'
         mvc  inpData(100),inputurl
         mvc  rqInpBufL,inplen
         mvc  jsonMapNm,=cl8'EMPINQJS'
         st   r5,rqInpBufa
**

              mvc methodLen,=f'3'
              st r5,methodA    ds   A
              la r5,5(r5)
              st r5,reqStrtA   DS   A             start of the request
              st r5,reqUriA    ds   A
              la r5,12(r5)
              st r5,reqEndA    DS   A            end of the request
              st r5,reqUriEndA DS   A
*             *
              mvc reqUriLen,=f'12'
              la r5,13(r5)
              mvc reqParmLen,=f'10'
              st r5,reqParmA   ds   A
              mvc bdyParmLen,=f'0'
*             *
              #set parmfnd
*             *
              #set getCmd
**
         la    r1,EMPMAP     set the MRB
         st    r1,parm2      mrb
* move default values to the emp rec
         b      callrdr2
inputUrl dc cl38'GET /empmap/enter?empid=1234 HTTP '

callRDR   ds   0h
         #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,             X
               RGSV=(R2-R8),PARMS=(id,msg1)
         la    r2,parms
         la    r4,treader
callRDR2  ds   0h
         #link pgm=treader,parms=(parms),MODE=USER,RGSV=(R2-R8)
         b     returne
*        b     callpgm
callEmpwtr ds  0h
       #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg2)X
               ,RGSV=(R2-R8)
* set MRB to EMPMAP
         la    r1,EMPMAP     set the MRB
         st    r1,parm2      mrb
* move default values to the emp rec
       mvc  WK_EMPSTART,=c'05/07/1999'
       mvc  WK_DATE_2,=c'05/07/1999'
       mvc  WK_SKILL_NAME,=cl48'dish washingdrying      cooking'
       mvc  WK_EMP_ID,=cl4'1234'
       mvc  WK_EMP_FIRST_NAME,=cl10'peter'
       mvc  WK_EMP_LAST_NAME,=cl15'pan'
       mvc  WK_EMP_STREET,=cl20'234 affie str'
       mvc  WK_EMP_CITY,=cl15'boggemsbaai'
       mvc  WK_EMP_STATE,=c'wc'
       mvc  WK_EMP_ZIP,=cl9'23433'
       mvc  WK_DEPT_NAME,=cl45'kitchen'
       mvc  WK_title,=cl20'master bottle washer'
         b      callwtr2

callTstwtr ds  0h
       #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg2)X
               ,RGSV=(R2-R8)
* set MRB to TEStM001
         la    r1,TESTM001   set the MRB
         st    r1,parm2      mrb
* move default values to the emp rec
       mvc  char_fld,=cl20'abcdef'
       mvc  znum_fld,=x'f1f2f3f4f5'
       mvc  pack_fld,=pl4'1234511'
       mvc  bin_fld,=f'12'
       mvc  sznum_fld,=x'f1f2f3f4D5'
       mvc  spack_fld,=cl4'    '
       mvc  sbin_fld,=f'123'
         b      callwtr2

callWTR   ds   0h
       #WTL  MSGID=M#999011,MSGPREF='IW',OVRIDES=OVRLOG,PARMS=(id,msg2)X
               ,RGSV=(R2-R8)
* call c002 to populate jsonschema
         #LOAD  PGM='ISPTJLOD',RGSV=(R2-R8),EPADDR=(R6),cond=(PGNF),   X
               ,PGNFXIT=loadmaptble
*
         mvc   W_REC_HEADER,0(r6)
         la    r5,w_rec_info
         lh    r15,(W_REC_COUNT-ISPT_JSONSCHEMA)(r6)
         la    r1,l'w_rec_entry
         sth   r1,hw
         mh    r15,hw
         la    r2,l'w_rec_header(r6)
         ex    r15,movdta
         ar    r2,r15
         la    r5,w_ele_info
         lh    r15,(w_sch_ele_count-ISPT_JSONSCHEMA)(r6)
         la    r1,l'w_ele_entry
         sth   r1,hw
         mh    r15,hw
         ex    r15,movdta
         b      callwtr2
movdta   mvc    0(*-*,r5),0(r2)
*
callwtr2 ds 0h
         la    r4,twriter
*   only a mapout request will pass a message addr
         xr    r1,r1
         ic    r1,msg1       get msg len
         st    r1,parm4
         la    r1,msg1+1
         st    r1,parm3      save the msg addr
dspMsg   ds    0h
*        #SNAP AREA=(parms,32),TITLE=' isptmapr parms',RGSV=(R2-R8)
callpgm  ds    0h
         #link pgm=twriter,parms=(parms),MODE=USER,RGSV=(R2-R8)
*        #link pgm=(r4),parms=(parms),MODE=USER,RGSV=(R2-R8)
         ltr   r15,r15             all went well?
         b     returnm
         bz    returnm
loadmaptble ds  0h
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
return   ds    0h
        #return
*
         ds 0f
x7f      dc   xl1'7F'
          DS  Xl3'00'
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
tempr    dc    cl8'ISPTEMPR'
tempw    dc    cl8'ISPTEMPW'
testw    dc    cl8'TESTWTR'
        DROP  R12
         LTORG
         EJECT
         #BALI
*
*
*
*---------------------------------------------------------------------*
*- Internal workarea                                                 -*
*---------------------------------------------------------------------*
WORKAREA DSECT     must be rhdcmapr work addresses
*
parmaddr   DS    a                   subroutine call parms
parms      DS    0F                  subroutine call parms
parm1      ds    A    supposed to be ssc
parm2      ds    A    supposed to be mcon
parm3      ds    A    supposed to be MRB
parm4      DS    A    optional message  or addr of aidbyte
parm5      ds    F    message length
hw         ds    h
           ds  0f
SYSPLIST  DS 20F           MAP OUT PARAMETER LIST AREA
TASKCODE  DS CL8          TASK CODE WHICH INVOKED PROGRAM
mappingCte  DS  (codetblWrds)F   Storage for mapping Codetable Entry
endpCTE     DS  (codetblWrds)F   Storage for Endpoint Codetable Entry
parsedEndpt DS  cl(endpointL)    storage for parsed Endpoint
         @COPY IDMS,MAP-CONTROL=EMPMAP
         @COPY IDMS,MAP-CONTROL=ISPTMLOD
         @COPY IDMS,MAP-CONTROL=TESTM001
         @COPY IDMS,RECORD=TEST_RECORD,VERSION=1
         @COPY IDMS,RECORD=EMPLOYE,VERSION=100
         @COPY IDMS,RECORD=EMPMAP_WORK_RECORD
         @COPY IDMS,RECORD=ISPTDLOD_WORK
         @COPY IDMS,RECORD=ISPT_JSONSCHEMA
SYBMAPLN EQU *-ISPTMLOD          LENGTH OF #MRB FOR SNAP
WORKAREL EQU   *-WORKAREA       LENGTH IN bytes

*
rdrstg   DSECT     return info passed by isptrdr
lmrbaid  DS    cl1
         ds    0f
rdrstgl  EQU   *-rdrstg            LENGTH IN WORDS.
*
         COPY isptdsct
         COPY #CSADS
         COPY #MRBDS
         COPY #TCEDS
         COPY #PTEDS
         COPY #PLEDS
         COPY #LTEDS
              #SSCTRL DSECT=YES
         END   ISPTDR
