           ds   0F
*
         DS    0D
WORK1    DS    D                   Work fields for conversions
WORK2    DS    XL10                Work fields for conversions
*
hdrAREA  DS    cl320               hdr Output area
         org hdrarea
blanks   ds    cl32
         org
OUTAREA  DS    X                   Output area length
OUTAREAT DS    0CL320               Output area
OUTAREAT1 ds   CL255               Output area
outareal    equ   *-outAreat1       length
OUTAREAT3 ds   CL65                Output area
*
BUFFOUTA DS    A                A(Output buffer) (for SEND)
BUFFOUTL DS    F                Output buffer Length
BUFFOUTP DS    F                current offset in output buffer
BUFFINA  DS    A                A(Input buffer)  (for RECV)
INMSGLEN ds    F                Requested Length of input msg text
buffInLn DS    F                Length of received input message text
MAXMSGLN DS    F                Maximum message length in bytes
CURPARMA DS    A                Current parameters address
CURLEN   DS    F                Current remaining length for parms
CTECounter  DS    F             code table entry  loop counter
*
*
* search string contorl
*
            ds  0f
srchCtlPrm  ds  cl(srchCtlL)    allocate storage for search parms
*
            ds  0f
mappingCte  DS  (codetblWrds)F   Storage for mapping Codetable Entry
            ds  0f
endpCTE     DS  (codetblWrds)F   Storage for Endpoint Codetable Entry
            ds  0f
parsedEndpt DS  cl(endpointL)    storage for parsed Endpoint

*
*
         DS    0f
RETCODE  DS    F
ERRNO    DS    F
RSNCODE  DS    F
*
DIPADDR  DS    F                   IPADDR binary value
DIPADDRL DS    F                   IPADDR string length
DLOOP    DS    F                   LOOP number
DMSGL    DS    F                   MSGLEN number
DWAIT    DS    F                   WAIT number
DPORT    DS    H                   PORT number
*
         DS    0F
MSGFLAGD DS    (MSGFLAGL)X         Message flags
         DS    0F
SOCKADDS DS    (SIN#LEN)X          SOCKADDR for the SERVER
*
         DS    0F
HOSTNAME DS    CL64
HOSTIPAD DS    CL16
HOSTID   DS    F
RETIPASL DS    F
RETHNAML DS    F
RETSNAML DS    F
RETLEN   DS    F
SENDLEN  DS    F
RECVLEN  DS    F
SOCKDESC DS    F                 Socket descriptor for conversation
SOCKDESA DS    F                   Socket descriptor used by ACCEPT
SADDCLEN DS    F
SADDSLEN DS    F
reqMaprN    DS    CL8               request mapper table name
ReqTblA     DS    A                 address of Request control tbl
jsonMapA    DS    A                 address of json mapping loadmod
olmMapA     DS    A                 address of olm map loadmod
            org  olmMapA
mrba        ds   A                 mrb address of current map
            org
olmRecListA DS    a                 map rec bind list addr
olmRecA     DS    A                 1st OLM data record address
olmRecNmA   DS    A                 1st OLM data record-name address
olmNRecs    DS    f                 OLM data record count
*
lTblKey     ds    cl32              local searchKey
            org  ltblkey
tempname    ds    cl16
            org
workp1      ds    pl16
workp2      ds    cl34
            org   workp2
            ds    cl19
workp231    ds    cl15
            org
*
* Json mapping table control
*
            ds   0f
wjeWorkStg  ds  cl(8*wjeworkl)   allocate storage map control vars
            ds   0f
jmapCtlStg  ds   cl(jmapctll)
            org jmapCtlStg
mjbWorkStg  ds  cl(mjbWorkl)   work storage uding mapin
            org
wjeMaxDepth equ x'08'
mjbMaxDepth equ x'06'
wjeStgCnt   ds  h                depth used
            org wjeStgCnt
mjbStgCnt   ds  h                depth used
            org
*
contChar    ds   cl1             continuation charator
*
            ds   0f
reqCurA    ds   A
reqCurA2   ds   A
reqLen     ds   F       remaining length of req buffer
SQLRPB     ds  XL36'00'                RPB used by IDMSIN01 macro
CONVFUNC DS     a                      STRCONV function:
M#disline  DS   PL4
sendNoLen #flag x'10'      sender did not include then length byte
flags      ds   x
