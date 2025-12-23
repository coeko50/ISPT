OutBuffer DSECT
outLen    DS    F                   buffer length
outText   DS    0C                  buffer content
*
InpBuffer DSECT
bufferHdr  ds   0h
methodLen  ds   F
methodA    ds   A
reqStrtA   DS   A                  start of the request
reqEndA    DS   A                  end of the request
*
reqUri     ds   0f
reqUriLen  ds   F
reqUriA    ds   A
reqUriEndA DS   A
reqMimeLen ds   F
reqMimeA   ds   A
reqParmLen ds   F
reqParmA   ds   A
bdyParmLen ds   F                 body parms len
bdyParmA   ds   A                 body parms addr
*
lastSlashA DS   A
*
parmFnd  #flag  x'01'
bdyFnd   #flag  x'40'
mimeFnd  #flag  x'02'
webReq   #flag  x'04'
endPoint #flag  x'08'
uriEnd   #flag  x'10'
bdyParms #flag  x'20'
reqFlag1   DS   X
*
getCmd   #flag  x'01'
putCmd   #flag  x'02'
postCmd  #flag  x'04'
deletCmd #flag  x'08'
updtCmd  #flag  x'0E'
reqFlag2   DS   X
*
mimeHTML  #flag c'H'
mimeICO   #flag c'I'
mimeJPG   #flag c'J'
mimType  ds    cl1
         ds    0f
bufferHdrL   equ  *-bufferHdr
*  the real data follows
inpLen    DS    F                   buffer length
inpData   DS    0C                  buffer content
*
parsBuff  DSECT                used for parsing csv structures
prsInpBufa     ds A            pointer to cur pos in input buffer
prsInpbufL     ds F            remaining  input buffer length
prsOutbufA     ds A            output buffer address
prsCTEa        ds A            Code Table Entry address (opt)
parsBuffL      equ *-parsBuff
*
*
*
srchCtl        DSECT
srchKeyLn    ds  F            length of the key to search for
srchKeyA     ds  A            Value of the key to search for
srchStrLn    ds  F            length of string to search
srchStrA     ds  A            address of string to search
strtPos      ds  F            position to start srch at
fndAtPos     ds  F            position where string was found
srchCtlL     equ  *-srchCtl
*
*
CodeTblEntry  DSECT
tblkeyTLn ds    f         trimmed length of the key
tblkeyln  DS    f         length of table key
tblkeyA   DS    A         addr of the key
tblvalln  DS    f         length for value
tblvalA   DS    A         addr of the value
codetblLen  equ  *-CodeTblEntry
codetblWrds  equ   (*-CodeTblEntry)/4
*
CodeTblHdr DSECT
TBTHDR   DS    0X            TABLE HEADER INFORMATION
TBTN     DS    H                 NUMBER OF ENTRIES IN TABLE
TBTELEN  DS    H                 LENGTH IN BYTES OF LARGEST ENTRY
TBTKEYOF DS    H                 KEY OFFSET
TBTKEYL  DS    XL1               LENGTH OF KEY
TBTLIN   #FLAG X'40'             TABLE TO BE SEARCHED LINEARLY
TBTBIN   #FLAG X'20'             TABLE TO BE SEARCHED BINARILY
TBTFLAG1 DS    XL1               FLAG-1 BYTE
TBTSTART DS    A                 POINTER TO START OF TABLE
TBTLTABL DS    F                 TOTAL LENGTH OF 'OBJECT' TABLE TEXT
TBTLIST  #FLAG X'80'             TYPE OF LIST  (ON=VALID,OFF=INVALID)
TBTSCOD  #FLAG X'40'             BINARY SEARCH (ON=ENCODE,OFF=DECODE)
TBTTYP1  #FLAG X'20'             ENCODE FORMAT (ON=NUMERIC,OFF=ALPHA)
TBTTYP2  #FLAG X'10'             DECODE FORMAT (ON=NUMERIC,OFF=ALPHA)
TBTSORT  #FLAG X'08'             TABLE       (ON=SORTED,OFF=UNSORTED)
TBTDUPL  #FLAG X'04'             DUPLICATES  (ON=ALLOW,OFF=NOT ALLOW)
TBTCTCH  #FLAG X'02'             CATCH ALL ACTIVE     (ON=YES,OFF=NO)
TBTEDIT  #FLAG X'01'             TYPE OF TABLE     (ON=EDIT,OFF=CODE)
TBTFLAG2 DS    XL1               FLAG-2 BYTE
TBTPOS1  DS    XL1               VAL-1 NUMERIC DECIMAL POSITION= 0-15
TBTPOS2  DS    XL1               VAL-2 NUMERIC DECIMAL POSITION= 0-15
TBTTYP3  #FLAG X'20'             ENCODE FORMAT (ON=GRAPHICS)      BZJ
TBTTYP4  #FLAG X'10'             DECODE FORMAT (ON=GRAPHICS)      BZJ
TBTFLAG3 DS    XL1               FLAG-3 BYTE                      BZJ
CodeTblL EQU   *-CodeTblHdr      20 bytes give or take
*
*
ReqTbl    DSECT           #REQ    Describe Request Control Table
reqpgmNm  ds    cl8
rqinpBufl ds    f             length of input buffer
rqinpBufA ds    A             its address
ads       #flag c'A'
cobol     #flag c'C'
map       #flag c'M'
pgmType   ds    cl1
xferLink  #flag c'L'              link to calling program
xferTask  #flag c'T'              exec next task code
xferXfer  #flag c'X'              transfer control
xferType  ds    cl1               How to transfer control
aidByte   ds    cl4               Aid key named PREMAP,ENTER,PFx
outJSON   #flag c'J'              write a json struct
outHTML   #flag c'H'              write HTML n struct
outFmt    ds    x                 output Format
debug     #flag x'01'
debugflg ds    cl1
server    #flag x'01'             server current prog
reader    #flag x'02'             reader current prog
writer    #flag x'04'             writer current prog
callchain ds    x                 last one using the #REQ storage
PrevCallchain ds    x             who call us
ServerErr #flag x'01'
statusFlag ds  X                   Option flag
          ds    0F
outHTML     ds    cl32              html name if type is html
          org   outHTML
outJson     ds    cl32
          org
JsonMapNm   ds    cl8             name of table containing mappings
            org   JsonMapNm
maptbln     ds    cl8             name of table containing mappings
            ds    0F
SOCKDESCg   DS    F               Socket descriptor for conversation
SOCKDESAg   DS    F               Socket descriptor used by ACCEPT
*
srvtask     ds   cl8              the name of the server task
*
endPointNm ds   CL8                name of module containing endpoints
endpTblA   ds   a                  address of loaded endpoint table
endpCTEa   ds   a                  base for CodeTbl current entry
endpointa  ds   a                  address of parsed endpoint
parmctla   ds   a                  address of current parmctl
*
in01$key   ds   cl8                  idmsin01 parms
in01$val   ds   cl32
reqTblL  EQU   *-reqTbl
*
*
*
parmCtl        DSECT                    passed parms control
parmNameLn     DS    F                   parm name length
parmNameA      DS    A                   parm name address
parmValLn      DS    F                   parm Value length
parmValA       DS    A                   parm value address
parmDptA       ds    A                   addr of decimal point in parm
curpos         DS    A
parmSignInd    ds    cl1                 1st pos of val is a sign char
parmValSigned equ   x'01'
parmCtlL       equ  *-parmCtl
*
EndpointT DSECT           Describes an endpoint
endpoint  ds  cl32        endpoint name
endpPgmNm ds  cl8         program to call
          org endpPgmNm
endpnxtsk ds  cl8         program to call
endpPgmTp ds  cl1         Program Language
LinkPgm   #flag c'L'
XferPgm   #flag C'X'
NxtTask   #flag C'T'
endpXfer  ds  cl1         How to transfer control
endpAid   ds  cl4         Aid key name
endprTyp  ds  cl4         return type HTML/JSON
endpMapn  ds  cl8         Mapping table name
endpHTML  ds  cl32        html name if type is html
endpointL equ *-endpointT
*
MapEntry DSECT  to be deleted
keyln    ds  h
key      DS  cl32     Address of key
elenaml  ds  h        length of elename
recnaml  ds  h        length of recname
eleName  ds  cl64
         org elename
meRecname ds cl32
meEleName ds cl32
         org
sel4upd  ds  cl1      field is updateable for mapin
sel4out  ds  cl1      field selected for output
eleOffs  ds  h        offset within record
eleType  ds  h        data type
elelen   ds  h        field len
eledtaln ds  h        data len
eleprec  ds  h        precision
eleScale ds  h        scale
eleOcc   ds  h        occurences
mapentrl equ *-mapentry
*
varChar  DSECT
len      DS    F
val      DS    0c
varCharl equ *-varChar
*
* mapping loadmodule dsects
*
jmapCtl     dsect     mappingcontrol dsect
jidmsReca   ds  A     address of current user record
jcurReca    ds  A     address of current record in json schema
jRecCnt     ds  h     current record index
wcnt        ds  h     global work counter
wOccBase    ds   h    1st occ offset
wOccCnt     ds  2h    occurence count stack for occ lvl
        org wOccCnt
wOccCnt1    ds   h    occurence count stack for occ lvl1
wOccCnt2    ds   h    occurence count stack for occ lvl2
            org
jmapCtll   equ  *-jmapCtl
*
* mapping loadmodule dsects
*  instance variables for recursive call usage
wjeWork    dsect
jcurEleA    ds  A     address of current mapping ele
jNxtEleA    ds  A     address of next ele in chain
*jEleCnt     ds  h     current element index
*wRecEleCnt  ds   h    current ele nbr in rec/grp (decreasing)
*wGrpEleCnt  ds   h    current element index
*wChildCnt   ds   h    if a group - the number of children
wOffset     ds   h    offset
wOcc        ds   h    max occurs for current occ lvl
charFld    #FLAG  X'01'
occFld     #FLAG  X'02'
dataFlag    ds    X
writeCont   #flag x'01'
recEleCont  #flag x'02'           control continuation char writes
contFlg     ds   cl1
            ds    0A
wjeworkl   equ  *-wjeWork

*
*  work fields for mapin recursive processing
*
mjbWork     dsect
mjbCurJEleA ds a       address of current json ele in a struct
mjbCurGrpA  ds a       address of current json grp ele
mjbCurJRecA ds a       address of current json record
mjbCurRecA  ds a       address of current IDMS record
mjbOcclvl   ds h       current occurs level
mjbOcc      ds 2h     occ nbr for the level
mjbOccEleA  ds 2a     address of the element with the occurs
mjbStack    ds 20cl1   keep track of levels { and [
#array     #flag  x'01'
#struct    #flag  x'02'
#1stEle    #flag  x'04'
mjbflag     ds x
            ds 0f
mjbstackp   ds a      pointer to cur pos
mjbworkl   equ  *-mjbWork

*
*
* the following descts describes a json mapping loadmodule
* that have the following structure
*  start with jschema dsect
*  followed by jsReCnt jrec dsects
*  followed by jsEleCnt jele dsects,  (in jrelecnt groups)
*
JSchema     dsect
jsId        ds cl8     signature #JSONMAP
jschnm      ds cl8     schema name
jsrecCnt    ds h       number of records in schema
jsEleCnt    ds h       number of elements in schema
jsEleOffset ds h       offset to 1st ele
jSchemaLn   equ *-jschema
*
                                 ds    cl160
jrec        dsect
jrecname        ds cl32    record name
jrecVer         ds  h      record version
jrJsonRec       ds cl32    json   name
jrJsonVer       ds  h      json version
jrTotCnt        ds  h      total number of elements in record
jrEleCnt        ds  h      number of 1st level elements
jrEleOffset     ds  h      offset to record's elements
jRecln      equ *-jrec
*
jele      dsect
jeParent        ds   h      offset to the element node's parent
jeNext          ds   h      offset to next in chain (same level) -1 end
je1stChild      ds   h      offset to 1st child (-1 if none)
jeJsonfld       ds   cl32   json field name
jeLvl           ds   h      rec element level
jeElement       ds   cl32   element name
jeSeq           ds   h      seq in record
jeChildCnt      ds   h      if a group - the number of children
jeOffset        ds   h      offset in rec for non occ elements
jeLen           ds   h      external length
jeDlen          ds   h      internal length
jeOcc           ds   h      occurences
jeOccOffset     ds   h      base offset for occurs element
jeOccDepInd     ds   cl1    occ depend on indicator
noDep    equ  c'N'          no dependcy defined
depl2    equ  c'2'          dependency field is half word
depl4    equ  c'4'          dependency field is fullword
jeParentType    ds   CL1    type of the parent
RecNode   equ c'R'              Record
EleNode   equ c'G'              group ele
jeOccDepOffset  ds   h      offset to fld with actual # occurences
jeOccLvl        ds   h      occurence level
jeOccSize       ds  2h      size of 1 occ
jeGrpInd        ds   cl1    y=grp field
jeSel4out       ds   cl1    is field selected for output
jeISUpdateable  ds   cl1    is this field updateable
jeIsRequired     ds   cl1    is the field required
jeDtype          ds   h      field data type
strTp    equ  x'00'
charTp   equ  x'01'
numtypes equ  x'01'
binTp    equ  x'05'
znumTp   equ  x'02'
packTp   equ  x'03'
SZNUM_FLD_tp   equ x'02'
SPACK_FLD_tp   equ x'03'
ZNUM_FLD_tp    equ x'80'    128
PACK_FLD_tp    equ x'81'    129
BIN_FLD_tp     equ x'05'
FLOAT_FLD_tp   equ x'07'
REAL_FLD_tp    equ x'08'
jeUsage          ds   h      element datatype usage
useDisp  equ  x'00'
useInt   equ  x'01'
usePck   equ  x'04'
* 0 = DISPLAY
* 1 = COMPUTATIONAL (BINARY)
* 2 = COMPUTATIONAL-1 (SHORT-POINT)
* 3 = COMPUTATIONAL-2 (LONG-POINT)
* 4 = COMPUTATIONAL-3 (PACKED)
* 5 = BIT
* 6 = POINTER
* 7 = DISPLAY-1 (KANJI/DBCS)
* 8 = SQL BINARY
* 88 = CONDITION NAME
jePrec           ds   h      precision
jeScale          ds   h      scale
jeUdcKey         ds   h      User defined Comment (external data type)
jEleLn         equ   *-jele
***
* udc date data type
udcType   dsect
udct      ds  h
udc_CCMMDDYY           EQU 016
udc_CCYYDDD            EQU 017
udc_CCYYMM             EQU 028
udc_CCYYMMDD           EQU 009
udc_CCYYMMDDHHMI       EQU 047
udc_CCYYMMDDHHMISS     EQU 048
udc_CCYYMMDDTTT        EQU 013
udc_CYYMMDD            EQU 021
udc_CYYMMDDHHMMSS      EQU 032
udc_CCYY_MM_DD         EQU 063
udc_DDMMCCYY           EQU 060
udc_DDMMMYY            EQU 005
udc_DDMMYY             EQU 002
udc_DD_MM_YY           EQU 062
udc_DD_MM_CCYY         EQU 065
udc_MMDDCCYY           EQU 014
udc_MMDDYY             EQU 003
udc_MMDDYYCC           EQU 015
udc_MMYY               EQU 027
udc_MM_DD_YY           EQU 022
udc_MM_DD_CCYY         EQU 064
udc_YYDDD              EQU 006
udc_YYMM               EQU 026
udc_YYMMDD             EQU 001
udc_YY_MM_DD           EQU 061
udc_HHMMSS             EQU 129
udc_HH_MM_SS           EQU 130
udc_HHMM               EQU 132
udc_HH_MM              EQU 131
* udc_CCMMDDYY         EQU X'016'
* udc_CCYYDDD          EQU X'017'
* udc_CCYYMM           EQU X'028'
* udc_CCYYMMDD         EQU X'009'
* udc_CCYYMMDDHHMI     EQU X'047'
* udc_CCYYMMDDHHMISS   EQU X'048'
* udc_CCYYMMDDTTT      EQU X'013'
* udc_CYYMMDD          EQU X'021'
* udc_CYYMMDDHHMMSS    EQU X'032'
* udc_CCYY_MM_DD       EQU X'063'
* udc_DDMMCCYY         EQU X'060'
* udc_DDMMMYY          EQU X'005'
* udc_DDMMYY           EQU X'002'
* udc_DD_MM_YY         EQU X'062'
* udc_DD_MM_CCYY       EQU X'065'
* udc_MMDDCCYY         EQU X'014'
* udc_MMDDYY           EQU X'003'
* udc_MMDDYYCC         EQU X'015'
* udc_MMYY             EQU X'027'
* udc_MM_DD_YY         EQU X'022'
* udc_MM_DD_CCYY       EQU X'064'
* udc_YYDDD            EQU X'006'
* udc_YYMM             EQU X'026'
* udc_YYMMDD           EQU X'001'
* udc_YY_MM_DD         EQU X'061'
* udc_HHMMSS           EQU X'129'
* udc_HH_MM_SS         EQU X'130'
* udc_HHMM             EQU X'132'
* udc_HH_MM            EQU X'131'
