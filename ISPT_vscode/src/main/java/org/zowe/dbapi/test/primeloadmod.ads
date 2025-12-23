mod process ISPT-LOADMOD-PRIME 
process source follows 
move 'ISPTLMOD'  TO W-SCHEMA-NAME. 
move 'ISPTJLOD'  TO W-SCHEMA-NAME. 
move 01 to w-rec-count.
move 0042 to w-sch-ele-count.
compute w-sch-ele-offset = slen(w-schema-info) +  
        (w-rec-count * slen(w-rec-info(1))) .
call addSch.
move w-sch-ele-offset to w-rec-ele-offset(1).
 move 'ISPT-JSONSCHEMA'  TO w-rec-name(1). 
 move 1 to W-REC-VERSION(1). 
 move 42 to W-ELE-COUNT(1). 
 move 3 to W-REC-CHILDCNT(1). 
compute w-rec-ele-offset(2) = w-rec-ele-offset(1) + 
          (slen(w-ele-info(1)) * w-ele-count(1)).
call addRec.
move 0 to w-ecnt.
add 1 to w-ecnt.
!* SCHEMA_INFO
 move 0 to W-PARENT-OFFSET(w-ecnt).
 move 'R' to W-ELE-PARENT-TYPE(w-ecnt).
 move 600 to W-Next-OFFSET(w-ecnt).
 move 200 to W-1STCHILD-OFFSET (w-ecnt).
 move 'SCHEMA_INFO' to W-JSONFLD(w-ecnt).
 move 0002 to W-ELE-LVL(w-ecnt).
 move 'W-SCHEMA-INFO' to W-ELE-ELEMENT(w-ecnt).
 move 000100 to W-ELE-SEQ(w-ecnt) .
 move 0004 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00000 to W-ELE-LEN(w-ecnt).
 move 00014 to W-ELE-DLEN(w-ecnt).
 move 00000 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCCLVL(w-ecnt).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'Y' to W-ELE-ISGROUPELE(w-ecnt).
 move 'N' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'N' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'Y' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0 to W-ELE-DTYPE(w-ecnt).
 move 0 to W-ELE-USAGE(w-ecnt).
 move 0 to W-ELE-PREC(w-ecnt).
 move 0 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* SCHEMA_NAME
 move 100 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 300 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'SCHEMA_NAME' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-SCHEMA-NAME' to W-ELE-ELEMENT(w-ecnt).
 move 000200 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00008 to W-ELE-LEN(w-ecnt).
 move 00008 to W-ELE-DLEN(w-ecnt).
 move 00000 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCCLVL(w-ecnt).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* REC_COUNT
 move 100 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 400 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'REC_COUNT' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-REC-COUNT' to W-ELE-ELEMENT(w-ecnt).
 move 000300 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000008 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00008 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCCLVL(w-ecnt).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* SCH_ELE_COUNT
 move 100 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 500 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'SCH_ELE_COUNT' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-SCH-ELE-COUNT' to W-ELE-ELEMENT(w-ecnt).
 move 000400 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000010 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00010 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCCLVL(w-ecnt).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* SCH_ELE_OFFSET
 move 100 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move -1 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'SCH_ELE_OFFSET' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-SCH-ELE-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 000500 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000012 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00012 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCCLVL(w-ecnt).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* REC_INFO
 move 0 to W-PARENT-OFFSET(w-ecnt).
 move 'R' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1200 to W-Next-OFFSET(w-ecnt).
 move 700 to W-1STCHILD-OFFSET (w-ecnt).
 move 'REC_INFO' to W-JSONFLD(w-ecnt).
 move 0002 to W-ELE-LVL(w-ecnt).
 move 'W-REC-INFO' to W-ELE-ELEMENT(w-ecnt).
 move 000600 to W-ELE-SEQ(w-ecnt) .
 move 0005 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00000 to W-ELE-LEN(w-ecnt).
 move 00200 to W-ELE-DLEN(w-ecnt).
 move 00014 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0005 to W-ELE-OCC(w-ecnt).
 move '2' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00008 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00040 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'Y' to W-ELE-ISGROUPELE(w-ecnt).
 move 'N' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'N' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'Y' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0 to W-ELE-DTYPE(w-ecnt).
 move 0 to W-ELE-USAGE(w-ecnt).
 move 0 to W-ELE-PREC(w-ecnt).
 move 0 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* REC_NAME
 move 600 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 800 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'REC_NAME' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-REC-NAME' to W-ELE-ELEMENT(w-ecnt).
 move 000700 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00032 to W-ELE-LEN(w-ecnt).
 move 00032 to W-ELE-DLEN(w-ecnt).
 move 00014 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00040 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* REC_VERSION
 move 600 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 900 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'REC_VERSION' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-REC-VERSION' to W-ELE-ELEMENT(w-ecnt).
 move 000800 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000032 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00046 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00040 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_COUNT
 move 600 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1000 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_COUNT' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-COUNT' to W-ELE-ELEMENT(w-ecnt).
 move 000900 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000034 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00048 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00040 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* REC_CHILDCNT
 move 600 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1100 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'REC_CHILDCNT' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-REC-CHILDCNT' to W-ELE-ELEMENT(w-ecnt).
 move 001000 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000036 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00050 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00040 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* REC_ELE_OFFSET
 move 600 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move -1 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'REC_ELE_OFFSET' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-REC-ELE-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 001100 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000038 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00052 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00040 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_INFO
 move 0 to W-PARENT-OFFSET(w-ecnt).
 move 'R' to W-ELE-PARENT-TYPE(w-ecnt).
 move -1 to W-Next-OFFSET(w-ecnt).
 move 1300 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_INFO' to W-JSONFLD(w-ecnt).
 move 0002 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-INFO' to W-ELE-ELEMENT(w-ecnt).
 move 001200 to W-ELE-SEQ(w-ecnt) .
 move 0002 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00000 to W-ELE-LEN(w-ecnt).
 move 21000 to W-ELE-DLEN(w-ecnt).
 move 00214 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0150 to W-ELE-OCC(w-ecnt).
 move '2' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00010 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'Y' to W-ELE-ISGROUPELE(w-ecnt).
 move 'N' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'N' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'Y' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0 to W-ELE-DTYPE(w-ecnt).
 move 0 to W-ELE-USAGE(w-ecnt).
 move 0 to W-ELE-PREC(w-ecnt).
 move 0 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_NODE_INFO
 move 1200 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1700 to W-Next-OFFSET(w-ecnt).
 move 1400 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_NODE_INFO' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-NODE-INFO' to W-ELE-ELEMENT(w-ecnt).
 move 001300 to W-ELE-SEQ(w-ecnt) .
 move 0003 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00000 to W-ELE-LEN(w-ecnt).
 move 00006 to W-ELE-DLEN(w-ecnt).
 move 00214 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'Y' to W-ELE-ISGROUPELE(w-ecnt).
 move 'N' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'N' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'Y' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0 to W-ELE-DTYPE(w-ecnt).
 move 0 to W-ELE-USAGE(w-ecnt).
 move 0 to W-ELE-PREC(w-ecnt).
 move 0 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* PARENT_OFFSET
 move 1300 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1500 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'PARENT_OFFSET' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-PARENT-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 001400 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00214 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* NEXT_OFFSET
 move 1300 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1600 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'NEXT_OFFSET' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-NEXT-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 001500 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000002 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00216 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* 1STCHILD_OFFSET
 move 1300 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move -1 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move '1STCHILD_OFFSET' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-1STCHILD-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 001600 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000004 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00218 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_DB_INFO
 move 1200 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move -1 to W-Next-OFFSET(w-ecnt).
 move 1800 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_DB_INFO' to W-JSONFLD(w-ecnt).
 move 0003 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-DB-INFO' to W-ELE-ELEMENT(w-ecnt).
 move 001700 to W-ELE-SEQ(w-ecnt) .
 move 0025 to W-ELE-CHILDCNT(w-ecnt).
 move 000006 to W-ELE-OFFSET(w-ecnt).
 move 00000 to W-ELE-LEN(w-ecnt).
 move 00134 to W-ELE-DLEN(w-ecnt).
 move 00220 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'Y' to W-ELE-ISGROUPELE(w-ecnt).
 move 'N' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'N' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'Y' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0 to W-ELE-DTYPE(w-ecnt).
 move 0 to W-ELE-USAGE(w-ecnt).
 move 0 to W-ELE-PREC(w-ecnt).
 move 0 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* JSONFLD
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 1900 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'JSONFLD' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-JSONFLD' to W-ELE-ELEMENT(w-ecnt).
 move 001800 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000006 to W-ELE-OFFSET(w-ecnt).
 move 00032 to W-ELE-LEN(w-ecnt).
 move 00032 to W-ELE-DLEN(w-ecnt).
 move 00220 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_LVL
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2000 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_LVL' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-LVL' to W-ELE-ELEMENT(w-ecnt).
 move 001900 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000038 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00252 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_ELEMENT
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2100 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_ELEMENT' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-ELEMENT' to W-ELE-ELEMENT(w-ecnt).
 move 002000 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000040 to W-ELE-OFFSET(w-ecnt).
 move 00032 to W-ELE-LEN(w-ecnt).
 move 00032 to W-ELE-DLEN(w-ecnt).
 move 00254 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_SEQ
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2200 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_SEQ' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-SEQ' to W-ELE-ELEMENT(w-ecnt).
 move 002100 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000072 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00286 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_CHILDCNT
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2300 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_CHILDCNT' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-CHILDCNT' to W-ELE-ELEMENT(w-ecnt).
 move 002200 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000074 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00288 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OFFSET
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2400 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OFFSET' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 002300 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000076 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00290 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_LEN
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2500 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_LEN' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-LEN' to W-ELE-ELEMENT(w-ecnt).
 move 002400 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000078 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00292 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_DLEN
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2600 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_DLEN' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-DLEN' to W-ELE-ELEMENT(w-ecnt).
 move 002500 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000080 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00294 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OCC
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2700 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OCC' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OCC' to W-ELE-ELEMENT(w-ecnt).
 move 002600 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000082 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00296 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OCC_OFFSET
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2800 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OCC_OFFSET' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OCC-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 002700 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000084 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00298 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OCC_DEPEND_IND
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 2900 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OCC_DEPEND_IND' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OCC-DEPEND-IND' to W-ELE-ELEMENT(w-ecnt).
 move 002800 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000086 to W-ELE-OFFSET(w-ecnt).
 move 00001 to W-ELE-LEN(w-ecnt).
 move 00001 to W-ELE-DLEN(w-ecnt).
 move 00300 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_PARENT_TYPE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3000 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_PARENT_TYPE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-PARENT-TYPE' to W-ELE-ELEMENT(w-ecnt).
 move 002900 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000087 to W-ELE-OFFSET(w-ecnt).
 move 00001 to W-ELE-LEN(w-ecnt).
 move 00001 to W-ELE-DLEN(w-ecnt).
 move 00301 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OCC_DEPEND_OFFSET
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3100 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OCC_DEPEND_OFFSET' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OCC-DEPEND-OFFSET' to W-ELE-ELEMENT(w-ecnt).
 move 003000 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000088 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00302 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OCCLVL
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3200 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OCCLVL' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OCCLVL' to W-ELE-ELEMENT(w-ecnt).
 move 003100 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000090 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00304 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_OCCSIZE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3300 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_OCCSIZE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-OCCSIZE' to W-ELE-ELEMENT(w-ecnt).
 move 003200 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000000 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00004 to W-ELE-DLEN(w-ecnt).
 move 00306 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0002 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0002 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00002 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_ISGROUPELE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3400 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_ISGROUPELE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-ISGROUPELE' to W-ELE-ELEMENT(w-ecnt).
 move 003300 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000096 to W-ELE-OFFSET(w-ecnt).
 move 00001 to W-ELE-LEN(w-ecnt).
 move 00001 to W-ELE-DLEN(w-ecnt).
 move 00310 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_ISSEL4OUPUT
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3500 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_ISSEL4OUPUT' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-ISSEL4OUPUT' to W-ELE-ELEMENT(w-ecnt).
 move 003400 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000097 to W-ELE-OFFSET(w-ecnt).
 move 00001 to W-ELE-LEN(w-ecnt).
 move 00001 to W-ELE-DLEN(w-ecnt).
 move 00311 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_ISUPDATEABLE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3600 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_ISUPDATEABLE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-ISUPDATEABLE' to W-ELE-ELEMENT(w-ecnt).
 move 003500 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000098 to W-ELE-OFFSET(w-ecnt).
 move 00001 to W-ELE-LEN(w-ecnt).
 move 00001 to W-ELE-DLEN(w-ecnt).
 move 00312 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_ISJSONREQUIRED
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3700 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_ISJSONREQUIRED' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-ISJSONREQUIRED' to W-ELE-ELEMENT(w-ecnt).
 move 003600 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000099 to W-ELE-OFFSET(w-ecnt).
 move 00001 to W-ELE-LEN(w-ecnt).
 move 00001 to W-ELE-DLEN(w-ecnt).
 move 00313 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_DTYPE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3800 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_DTYPE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-DTYPE' to W-ELE-ELEMENT(w-ecnt).
 move 003700 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000100 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00314 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_USAGE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 3900 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_USAGE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-USAGE' to W-ELE-ELEMENT(w-ecnt).
 move 003800 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000102 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00316 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_PREC
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 4000 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_PREC' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-PREC' to W-ELE-ELEMENT(w-ecnt).
 move 003900 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000104 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00318 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_SCALE
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 4100 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_SCALE' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-SCALE' to W-ELE-ELEMENT(w-ecnt).
 move 004000 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000106 to W-ELE-OFFSET(w-ecnt).
 move 00002 to W-ELE-LEN(w-ecnt).
 move 00002 to W-ELE-DLEN(w-ecnt).
 move 00320 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0005 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0015 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_UDC_KEY
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move 4200 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_UDC_KEY' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-UDC-KEY' to W-ELE-ELEMENT(w-ecnt).
 move 004100 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000108 to W-ELE-OFFSET(w-ecnt).
 move 00016 to W-ELE-LEN(w-ecnt).
 move 00016 to W-ELE-DLEN(w-ecnt).
 move 00322 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
add 1 to w-ecnt.
!* ELE_UDC_VAL
 move 1700 to W-PARENT-OFFSET(w-ecnt).
 move 'G' to W-ELE-PARENT-TYPE(w-ecnt).
 move -1 to W-Next-OFFSET(w-ecnt).
 move -1 to W-1STCHILD-OFFSET (w-ecnt).
 move 'ELE_UDC_VAL' to W-JSONFLD(w-ecnt).
 move 0004 to W-ELE-LVL(w-ecnt).
 move 'W-ELE-UDC-VAL' to W-ELE-ELEMENT(w-ecnt).
 move 004200 to W-ELE-SEQ(w-ecnt) .
 move 0000 to W-ELE-CHILDCNT(w-ecnt).
 move 000124 to W-ELE-OFFSET(w-ecnt).
 move 00016 to W-ELE-LEN(w-ecnt).
 move 00016 to W-ELE-DLEN(w-ecnt).
 move 00338 to W-ELE-OCC-OFFSET(w-ecnt).
 move 0000 to W-ELE-OCC(w-ecnt).
 move 'N' to w-ELE-OCC-DEPEND-IND(w-ecnt).
 move 00000 to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).
 move 0001 to W-ELE-OCCLVL(w-ecnt).
 move 00140 to W-ELE-OCCSIZE(w-ecnt,1).
 move 00000 to W-ELE-OCCSIZE(w-ecnt,2).
 move 'N' to W-ELE-ISGROUPELE(w-ecnt).
 move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).
 move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).
 move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).
 move 0001 to W-ELE-DTYPE(w-ecnt).
 move 0000 to W-ELE-USAGE(w-ecnt).
 move 0000 to W-ELE-PREC(w-ecnt).
 move 0000 to W-ELE-SCALE(w-ecnt).
 move ' ' to W-ELE-UDC-KEY(w-ecnt).
 move ' ' to W-ELE-UDC-VAL(w-ecnt).
  
call addEle.
call prolog.
move concat(w-schema-name,' was successfully saved in ',
     db-name) to w-buffer.
return. 
 include ISPT-LOADMOD-PRIME-subroutines. 
msend.
