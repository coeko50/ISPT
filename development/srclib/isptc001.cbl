      *COBOL PGM SOURCE FOR isptc001
      *RETRIEVAL
      *DMLIST
       IDENTIFICATION DIVISION.
       PROGRAM-ID.                     isptc001.
       AUTHOR.                         Kosie.
       DATE-WRITTEN.                   05/21/25.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      * This is a table procedure to retrieve record elements          *
      * and the json names                                             *
      *                                                                *
      *                                                                *
      * Maintenance                                                    *
      * 25/12/18  add offset field to hold to make position real for   *
      *           subordinate elements in a multi level group          *
      *                                                                *
      * -------------------------------------------------------------- *
      * The procedure needs these schema definitions:                  *
      *                                                                *
      *                                                                *
      * CREATE SCHEMA ISPT;                                            *
      * -------------------------------------------------------------- *
      * This table procedure program expects the following definition. *
      *                                                                *
      * CREATE TABLE PROCEDURE ISPT.RECORD_INFO                        *
      *     ( PARENT_SEQ                       SMALLINT,               *
      *       NEXT_SEQ                         SMALLINT,               *
      *       FSTCHILD_SEQ                     SMALLINT,               *
      *       JSONREC                          CHARACTER(32),          *
      *       JRECVER                          SMALLINT,               *
      *       REC                              CHARACTER(32),          *
      *       RECVER                           SMALLINT,               *
      *       JSONFLD                          CHARACTER(32),          *
      *       ELE                              CHARACTER(32),          *
      *       SEQ                              INTEGER,                *
      *       LVL                              SMALLINT,               *
      *       ISGRP                            CHARACTER(1),           *
      *       ISMAPFLD                         CHARACTER(1),           *
      *       ISREQ                            CHARACTER(1),           *
      *       ISUPD                            CHARACTER(1),           *
      *       POS                              SMALLINT,               *
      *       Offset                           SMALLINT,               *
      *       ELEPIC                           CHARACTER(8),           *
      *       DTYPE                            SMALLINT,               *
      *       MODE                             SMALLINT,               *
      *       LEN                              SMALLINT,               *
      *       DLEN                             SMALLINT,               *
      *       PREC                             SMALLINT,               *
      *       SCALE                            SMALLINT,               *
      *       OCC                              SMALLINT,               *
      *       OCCDEPEND_seq                    smallint,               *
      *       OCCLVL                           SMALLINT,               *
      *       REDEFLVL                         SMALLINT,               *
      *       REDEFELE_seq                     smallint,               *
      *       DESC                             CHARACTER(32),          *
      *       PREFIX                           CHARACTER(8),           *
      *       UDC_KEY                          SMALLINT,               *
      *       UDC_VAL                          CHARACTER(16),          *
      *       MAPLIST                          CHARACTER(40)
      *     )                                                          *
      *       EXTERNAL NAME ISPTC001                                   *
      *       DEFAULT DATABASE NULL                                    *
      *       USER MODE                                                *
      *       LOCAL WORK AREA 1024                                     *
      *       GLOBAL WORK AREA 1024                                    *
      *       TIMESTAMP '2025-05-26-13.04.20.981045'                   *
      *       ;                                                        *
      *                                                                *
      * -------------------------------------------------------------  *
      * A key field must be defined on the table procedure so TDM      *
      * will know which columns are key fields for the table           *
      * procedure.                                                     *
      *                                                                *
      * rec & recver   the CALC key for the rcdsyn-079 record.         *
      *                                                                *
      * CREATE UNIQUE KEY isptc001_KEY                                 *
      *        ON ispt.record_info                                     *
      *                   (rec, rec_ver        );                      *
      *                                                                *
      *                                                                *
      * -------------------------------------------------------------  *
      * After compiling the procedure, create an access module         *
      *                                                                *
      *  CREATE ACCESS MODULE ispt.isptc001                            *
      *    FROM isptc001;                                              *
      *                                                                *
      * -------------------------------------------------------------  *
      * Standard SQL can be issued on the table procedure:             *
      *                                                                *
      * SELECT *  FROM ispt.record_info where rec = 'dd' and rec_ver = 1
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       ENVIRONMENT DIVISION.
      *
       CONFIGURATION SECTION.
      *SOURCE-COMPUTER.                IBM WITH DEBUGGING MODE.
      *
       IDMS-CONTROL SECTION.
       PROTOCOL.  MODE IS BATCH DEBUG
                  IDMS-RECORDS MANUAL.
      *----------------------------------------------------------------*
      *                                                                *
      *----------------------------------------------------------------*
       DATA DIVISION.
      *
       SCHEMA SECTION.
       DB    IDMSNWKA WITHIN IDMSNTWK VERSION 1.
      *----------------------------------------------------------------*
      *                                                                *
      *----------------------------------------------------------------*
       WORKING-STORAGE SECTION.
        01 FILLER                                 PIC X(50) VALUE
            '*******  isptc001  WORKING STORAGE STARTS HERE -->'.

       01  FILLER.
               05 WRK-DBKEY                       PIC 9(9) COMP.
               05 WRK-RADIX                       PIC 9(4) COMP.
           05  DIS-ROWID.
               07 DIS-GROUP                       PIC 9(5).
               07 FILLER                          PIC X     VALUE '/'.
               07 DIS-PAGE                        PIC 9(10).
               07 FILLER                          PIC X     VALUE ':'.
               07 DIS-LINE                        PIC 9(4).

      **************************************************************
      *     The following is the 1st parameter on all IDMSIN01 calls
      **************************************************************

       01  FILLER.
           05  DISPLAY-9                          PIC X(9).
           05  FILLER REDEFINES DISPLAY-9.
               07 NUMERIC-9                       PIC 9(9).
           05  FILLER REDEFINES DISPLAY-9.
               07 FILLER                          PIC X.
               07 DISPLAY-8                       PIC X(8).
               07 FILLER REDEFINES DISPLAY-8.
                  09 NUMERIC-8                    PIC 9(8).
               07 FILLER REDEFINES DISPLAY-8.
                  09 NUMERIC-4-1                  PIC 9(4).
                  09 NUMERIC-4-2                  PIC 9(4).

        01 UDC-FIELDS.
           02  udc-tbl.
                 05 filler pic x(20) value  'CCMMDDYY         016'.
                 05 filler pic x(20) value  'CCYYDDD          017'.
                 05 filler pic x(20) value  'YYYYDDD          017'.
                 05 filler pic x(20) value  'CCYYMM           028'.
                 05 filler pic x(20) value  'YYYYMM           028'.
                 05 filler pic x(20) value  'CCYYMMDD         009'.
                 05 filler pic x(20) value  'YYYYMMDD         009'.
                 05 filler pic x(20) value  'CCYYMMDDHHMI     047'.
                 05 filler pic x(20) value  'YYYYMMDDHHMI     047'.
                 05 filler pic x(20) value  'CCYYMMDDHHMISS   048'.
                 05 filler pic x(20) value  'YYYYMMDDHHMISS   048'.
                 05 filler pic x(20) value  'CCYYMMDDTTT      013'.
                 05 filler pic x(20) value  'YYYYMMDDTTT      013'.
                 05 filler pic x(20) value  'CYYMMDD          021'.
                 05 filler pic x(20) value  'CYYMMDDHHMMSS    032'.
                 05 filler pic x(20) value  'CCYY_MM_DD       063'.
                 05 filler pic x(20) value  'YYYY_MM_DD       063'.
                 05 filler pic x(20) value  'DDMMCCYY         060'.
                 05 filler pic x(20) value  'DDMMYYYY         060'.
                 05 filler pic x(20) value  'DDMMMYY          005'.
                 05 filler pic x(20) value  'DDMMYY           002'.
                 05 filler pic x(20) value  'DD_MM_YY         062'.
                 05 filler pic x(20) value  'DD_MM_CCYY       065'.
                 05 filler pic x(20) value  'DD_MM_YYYY       065'.
                 05 filler pic x(20) value  'MMDDCCYY         014'.
                 05 filler pic x(20) value  'MMDDYYYY         014'.
                 05 filler pic x(20) value  'MMDDYY           003'.
                 05 filler pic x(20) value  'MMDDYYCC         015'.
                 05 filler pic x(20) value  'MMYY             027'.
                 05 filler pic x(20) value  'MM_DD_YY         022'.
                 05 filler pic x(20) value  'MM_DD_CCYY       064'.
                 05 filler pic x(20) value  'MM_DD_YYYY       064'.
                 05 filler pic x(20) value  'YYDDD            006'.
                 05 filler pic x(20) value  'YYMM             026'.
                 05 filler pic x(20) value  'YYMMDD           001'.
                 05 filler pic x(20) value  'YY_MM_DD         061'.
                 05 filler pic x(20) value  'HHMMSS           129'.
                 05 filler pic x(20) value  'HH_MM_SS         130'.
                 05 filler pic x(20) value  'HHMM             132'.
                 05 filler pic x(20) value  'HH_MM            131'.
                 05 filler pic x(20) value  'not used         000'.
                 05 filler pic x(20) value  'not used         000'.
                 05 filler pic x(20) value  'not used         000'.
                 05 filler pic x(20) value  'not used         000'.
           02  udc-tbl-r  redefines udc-tbl.
             03  udc-entry  occurs 44
                          ascending key w-val  indexed by uIndex.
                 05  w-keyval.
                 07  w-val     pic x(16).
                 07  filler    pic x(1).
                 07  w-key     pic 9(3).
 
        01 WORK-FIELDS.
      *    05 WRK-X                               PIC S9(4) COMP.
           05 wk-dbname2                          PIC x(8).
           05 W-i                                 PIC S9(4) COMP.
           05 w-udc-cnt                           PIC S9(4) COMP.
           05 w-udc-tot                           PIC S9(4) COMP.
           05 w-depend-on                         PIC x(32).

      * code obtained from simotome.com
        01  BIT-ON                  pic 9     value 1.
        01  BIT-OFF                 pic 9     value 0.
        01  TWO-BYTES.
             05  TWO-BYTES-01        pic X.
             05  TWO-BYTES-02        pic X.
        01  TWO-BYTES-BINARY        redefines   TWO-BYTES
                             pic S9(4)   binary.

        01  IX-1                    pic 99      value 0.
        01  REGISTER-1              pic S9(5)   value 0.
        01  bts-parms.
            05  BTS-PASS-REcord.
                   10  BTS-pass-bits           pic x.
                   10  BTS-PASS-BYTES.
                       15  BTS-PASS-BYTE-01    PIC X.
                       15  BTS-PASS-BYTE-02    PIC X.
                       15  BTS-PASS-BYTE-03    PIC X.
                       15  BTS-PASS-BYTE-04    PIC X.
                       15  BTS-PASS-BYTE-05    PIC X.
                       15  BTS-PASS-BYTE-06    PIC X.
                       15  BTS-PASS-BYTE-07    PIC X.
                       15  BTS-PASS-BYTE-08    PIC X.

        01 COMMAND-TABLE.
           05 FILLER   PIC X(20) VALUE '01 Logical DDL      '.
           05 FILLER   PIC X(20) VALUE '02 Undefined        '.
           05 FILLER   PIC X(20) VALUE '03 CLOSE            '.
           05 FILLER   PIC X(20) VALUE '04 COMMIT           '.
           05 FILLER   PIC X(20) VALUE '05 COMMIT continue  '.
           05 FILLER   PIC X(20) VALUE '06 COMMIT release   '.
           05 FILLER   PIC X(20) VALUE '07 CONNECT          '.
           05 FILLER   PIC X(20) VALUE '08 DECLARE          '.
           05 FILLER   PIC X(20) VALUE '09 DELETE searched  '.
           05 FILLER   PIC X(20) VALUE '10 DELETE positioned'.
           05 FILLER   PIC X(20) VALUE '11 DESCRIBE         '.
           05 FILLER   PIC X(20) VALUE '12 EXECUTE          '.
           05 FILLER   PIC X(20) VALUE '13 TERMINATE        '.
           05 FILLER   PIC X(20) VALUE '14 EXECUTE IMMEDIATE'.
           05 FILLER   PIC X(20) VALUE '15 Undefined        '.
           05 FILLER   PIC X(20) VALUE '16 FETCH            '.
           05 FILLER   PIC X(20) VALUE '17 INSERT           '.
           05 FILLER   PIC X(20) VALUE '18 LOCK TABLE       '.
           05 FILLER   PIC X(20) VALUE '19 OPEN             '.
           05 FILLER   PIC X(20) VALUE '20 PREPARE          '.
           05 FILLER   PIC X(20) VALUE '21 RESUME           '.
           05 FILLER   PIC X(20) VALUE '22 RELEASE          '.
           05 FILLER   PIC X(20) VALUE '23 ROLLBACK         '.
           05 FILLER   PIC X(20) VALUE '24 ROLLBACK release '.
           05 FILLER   PIC X(20) VALUE '25 SELECT           '.
           05 FILLER   PIC X(20) VALUE '26 SET ACCESS MODE  '.
           05 FILLER   PIC X(20) VALUE '27 SET TRANSACTION  '.
           05 FILLER   PIC X(20) VALUE '28 SUSPEND          '.
           05 FILLER   PIC X(20) VALUE '29 UPDATE searched  '.
           05 FILLER   PIC X(20) VALUE '30 UPDATE positioned'.
           05 FILLER   PIC X(20) VALUE '31 SET COMPILE      '.
           05 FILLER   PIC X(20) VALUE '32 SET SESSION      '.
        01 FILLER REDEFINES COMMAND-TABLE.
           05 COMMAND-CODE PIC X(20) OCCURS 32 TIMES.

        01 OP-CODE-TABLE.
           05 FILLER   PIC X(20) VALUE '12 Open Scan        '.
           05 FILLER   PIC X(20) VALUE '16 Next Row         '.
           05 FILLER   PIC X(20) VALUE '20 Close Scan       '.
           05 FILLER   PIC X(20) VALUE '24 Suspend Scan     '.
           05 FILLER   PIC X(20) VALUE '28 Resume Scan      '.
           05 FILLER   PIC X(20) VALUE '32 Insert Row       '.
           05 FILLER   PIC X(20) VALUE '36 Delete Row       '.
           05 FILLER   PIC X(20) VALUE '40 Update Row       '.
        01 FILLER REDEFINES OP-CODE-TABLE.
           05 OP-CODE  PIC X(20) OCCURS 8 TIMES.

        01 COPY IDMS SUBSCHEMA-NAMES.
      * 01 IDMS-WORK-AREA.

        01 WS-SWITCHES.
           05 SW-XXXX                             PIC X(01).
              88 SW-YES                                     VALUE 'Y'.
              88 SW-NO                                      VALUE 'N'.
           05 DISC-REQUEST-SW                     PIC X(01).
              88 DISC-REQUEST                               VALUE 'Y'.
              88 NO-DISCONNECT                              VALUE 'N'.
           05 DISC-PATH-SW                        PIC X(01).
              88 DISC-PATH                                  VALUE '1'
                                                               THRU '2'.
              88 NULL-PATH                                  VALUE '1'.
              88 CHNG-PATH                                  VALUE '2'.
              88 KEEP-PATH                                  VALUE 'K'.

        01 WS-NUMBER.
           05 WS-S-VER                            PIC S9(08) COMP-3.

        EXEC SQL BEGIN DECLARE SECTION END-EXEC.
        77 wk-dbname                           PIC x(8).
        EXEC SQL  end  DECLARE SECTION END-EXEC.

        01 WS-ERROR-MESSAGES.
           05 DB-ERROR-MSG.
              10 FILLER                           PIC X(14) VALUE
                 'DML STATEMENT '.
              10 DB-ERROR-DML-NBR                 PIC 9(02).
              10 FILLER                           PIC X(29) VALUE
                 ' RETURNED AN ERROR STATUS OF '.
              10 DB-ERROR-STATUS                  PIC X(04).
              10 FILLER                           PIC X(33) VALUE SPACE.


      *----------------------------------------------------------------*
      *                                                                *
      *----------------------------------------------------------------*
       LINKAGE SECTION.

      *PROCEDURE PARAMETERS

        EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      *KEY 1, LEVEL 1 : UNIQUE FIELDS OF PATH RECORD

        77 PARENT-SEQ           PIC  S9(4) COMP SYNC.
        77 NEXT-SEQ             PIC  S9(4) COMP SYNC.
        77 FSTCHILD-SEQ         PIC  S9(4) COMP SYNC.
        77 JSONREC              PIC  X(32).
        77 JRECVER              PIC  S9(4) COMP SYNC.
        77 REC-NAME             PIC  X(32).
        77 RECVER               PIC  S9(4) COMP SYNC.
        77 JSONFLD              PIC  X(32).
        77 ELE                  PIC  X(32).
        77 SEQ                  PIC  S9(8) COMP SYNC.
        77 LVL                  PIC  S9(4) COMP SYNC.
        77 ISGRP                PIC  X(1).
        77 ISMAPFLD             PIC  X(1).
        77 ISREQ                PIC  X(1).
        77 ISUPD                PIC  X(1).
        77 POS                  PIC  S9(4) COMP SYNC.
        77 offset               PIC  S9(4) COMP SYNC.
        77 ELEPIC               PIC  X(8).
        77 DTYPE                PIC  S9(4) COMP SYNC.
        77 ELE-MODE             PIC  S9(4) COMP SYNC.
        77 LEN                  PIC  S9(4) COMP SYNC.
        77 DLEN                 PIC  S9(4) COMP SYNC.
        77 PREC                 PIC  S9(4) COMP SYNC.
        77 SCALE                PIC  S9(4) COMP SYNC.
        77 OCC                  PIC  S9(4) COMP SYNC.
        77 OCCDEPEND-seq        PIC  S9(4) COMP SYNC.
        77 OCCLVL               PIC  S9(4) COMP SYNC.
        77 REDEFLVL             PIC  S9(4) COMP SYNC.
        77 REDEFELE-seq         PIC  S9(4) COMP SYNC.
        77 DESC                 PIC  X(32).
        77 PREFIX               PIC  X(8).
        77 UDC-KEY              PIC  S9(4) COMP SYNC.
        77 UDC-VAL              PIC  X(16).
        77 MAPLIST              PIC  X(40).


      *PROCEDURE PARAMETER INDICATORS
        77 parent-i             PIC S9(4) COMP SYNC.
        77 next-i               PIC S9(4) COMP SYNC.
        77 fstchild-i           PIC S9(4) COMP SYNC.
        77 JSONREC-i            PIC S9(4) COMP SYNC.
        77 JRECVER-i            PIC S9(4) COMP SYNC.
        77 REC-i                PIC S9(4) COMP SYNC.
        77 RECVER-i             PIC S9(4) COMP SYNC.
        77 JSONFLD-i            PIC S9(4) COMP SYNC.
        77 ELE-i                PIC S9(4) COMP SYNC.
        77 SEQ-i                PIC S9(4) COMP SYNC.
        77 LVL-i                PIC S9(4) COMP SYNC.
        77 ISGRP-i              PIC S9(4) COMP SYNC.
        77 isMapFld-i           PIC S9(4) COMP SYNC.
        77 ISReq-i              PIC S9(4) COMP SYNC.
        77 ISUpd-i              PIC S9(4) COMP SYNC.
        77 POS-i                PIC S9(4) COMP SYNC.
        77 offset-i             PIC S9(4) COMP SYNC.
        77 Pic-i                PIC S9(4) COMP SYNC.
        77 DTYPE-i              PIC S9(4) COMP SYNC.
        77 usage-i              PIC S9(4) COMP SYNC.
        77 LEN-i                PIC S9(4) COMP SYNC.
        77 DLEN-i               PIC S9(4) COMP SYNC.
        77 PREC-i               PIC S9(4) COMP SYNC.
        77 SCALE-i              PIC S9(4) COMP SYNC.
        77 OCC-i                PIC S9(4) COMP SYNC.
        77 OCCDEPEND-i          PIC S9(4) COMP SYNC.
        77 OCCLVL-i             PIC S9(4) COMP SYNC.
        77 REDEFLVL-i           PIC S9(4) COMP SYNC.
        77 REDEFELE-i           PIC S9(4) COMP SYNC.
        77 DESC-i               PIC S9(4) COMP SYNC.
        77 PREFIX-i             PIC S9(4) COMP SYNC.
        77 UDC-KEY-i            PIC S9(4) COMP SYNC.
        77 UDC-VAL-i            PIC S9(4) COMP SYNC.
        77 mapList-i            PIC S9(4) COMP SYNC.
        EXEC SQL END DECLARE SECTION END-EXEC.

      *PROCEDURE CONTROL PARAMETERS
        77 RESULT-IND                             PIC S9(04) COMP SYNC.
        01 SQLSTATE2.
           02 SQLSTATE2-1.
              03 SQLSTATE2-CLASS                     PIC X(02).
              03 SQLSTATE2-SUBCLASS                  PIC X(03).
           02 SQLSTATE2-1R REDEFINES SQLSTATE2-1.
              03 filler                              PIC X(01).
              03 SQLSTATE2-ERROR                     PIC X(04).
        77 PROCEDURE-NAME                         PIC X(18).
        77 SPECIFIC-NAME                          PIC X(08).
        77 MESSAGE-TEXT                           PIC X(80).
        01 SQL-COMMAND-CODE                       PIC S9(08) COMP SYNC.
           88 SQL-COMMAND-CODE-VALID                         VALUE  +1
                                                               THRU +40.
        01 SQL-OP-CODE                            PIC S9(08) COMP SYNC.
           88 SQL-OPEN-SCAN                                  VALUE +12.
           88 SQL-NEXT-ROW                                   VALUE +16.
           88 SQL-CLOSE-SCAN                                 VALUE +20.
           88 SQL-SUSPEND-SCAN                               VALUE +24.
           88 SQL-RESUME-SCAN                                VALUE +28.
           88 SQL-INSERT-ROW                                 VALUE +32.
           88 SQL-DELETE-ROW                                 VALUE +36.
           88 SQL-UPDATE-ROW                                 VALUE +40.
        01 INSTANCE-ID                            PIC S9(08) COMP SYNC.
        01 LOCAL-WORK-AREA.
           02 FILLER                              PIC  X(8).

        01 GLOBAL-WORK-AREA.
           02 COPY IDMS SUBSCHEMA-CTRL.
           02 COPY IDMS RECORD class-092 .
           02 COPY IDMS RECORD attribute-093 .
           02 COPY IDMS RECORD RCDSYN-079 .
           02 COPY IDMS RECORD NAMESYN-083 .
           02 COPY IDMS RECORD mapfld-124  .
           02 COPY IDMS RECORD map-098     .
           02 COPY IDMS RECORD SDR-042 .
           02 COPY IDMS RECORD SDES-044.
           02 COPY IDMS RECORD ELEMSYN-085 .
           02 COPY IDMS RECORD INQ-058 .
           02 COPY IDMS RECORD SR-036 .
           02 COPY IDMS RECORD RCDSYNATTR-141.
           02 COPY IDMS RECORD ATTRNEST-132.
           02 COPY IDMS RECORD panelfld-121.
           02 COPY IDMS RECORD pfld-data-147.
           02 BIND-FLAG                           PIC X(01).
              88 BOUND                                       VALUE 'B'.
              88 UNBOUND                                     VALUE ' '.
           02 WS-SAVE-DBKEY-TABLE.
              05 WS-SAVE-DBKEY                    PIC S9(8) COMP SYNC
                 OCCURS 6 TIMES.
           02 filler redefines ws-save-dbkey-table.
              05 WS-SAVE-DBKEY-class              PIC S9(8) COMP SYNC.
              05 WS-SAVE-DBKEY-attr               PIC S9(8) COMP SYNC.
              05 WS-SAVE-DBKEY-rcdsyn             PIC S9(8) COMP SYNC.
              05 WS-SAVE-DBKEY-sdr                PIC S9(8) COMP SYNC.
              05 WS-SAVE-DBKEY-namesyn            PIC S9(8) COMP SYNC.
              05 WS-SAVE-DBKEY-work               PIC S9(8) COMP SYNC.
           02 WS-SAVE-CONTROL-FIELDS.
              05 WS-JSON-REC                       PIC X(32).
              05 WS-JSON-RECVER                    PIC S9(8) COMP SYNC.
              05 WS-REC                            PIC X(32).
              05 WS-RECVER                         PIC S9(8) COMP SYNC.
           02 ele-stack.
             03 ws-LVL-ix               PIC S9(4) COMP SYNC.
             03 ws-fstchid-in           PIC x.
                88 fstchild-found       value 'y'.
                88 fstchild-not-found   value 'n'.
             03 ele-entry  occurs 15 times.
      *       05 ws-eLE                  pic x(32).
              05 ws-rseq                 PIC S9(4) COMP SYNC.
              05 ws-seq                  PIC S9(4) COMP SYNC.
              05 ws-LVL                  PIC S9(4) COMP SYNC.
              05 ws-offset               pic s9(4) comp sync.

           02 w-date-id                  PIC S9(4) COMP.
           02 w-time-id                  PIC S9(4) COMP.
           02 w-datetime-id              PIC S9(4) COMP.
           02 map-cnt                    PIC S9(4) COMP SYNC.
           02 g-maplist.
               03 g-mapname-list.
                  07 mapname      pic x(8) occurs 5 times.
               03 map-dbkey    PIC S9(8) COMP SYNC occurs 5 times.

      *----------------------------------------------------------------*
       PROCEDURE DIVISION USING
                               parent-seq
                               next-seq
                               fstchild-seq
                               JSONREC
                               JRECVER
                               rec-name
                               RECVER
                               JSONFLD
                               ELE
                               SEQ
                               LVL
                               ISGRP
                               isMapFld
                               isReq
                               isUpd
                               POS
                               offset
                              elepic
                               DTYPE
                               ele-mode
                               LEN
                               DLEN
                               PREC
                               SCALE
                               OCC
                               OCCDEPEND-seq
                               OCCLVL
                               REDEFLVL
                               REDEFELE-seq
                               DESC
                               PREFIX
                               UDC-KEY
                               UDC-VAL
                               MapList
                               parent-i
                               next-i
                               fstchild-i
                               JSONREC-i
                               JRECVER-i
                               JSONFLD-i
                               REC-i
                               RECVER-i
                               ELE-i
                               SEQ-i
                               LVL-i
                               ISGRP-i
                               isMapFld-i
                               isReq-i
                               isUpd-i
                               POS-i
                               offset-i
                               Pic-i
                               DTYPE-i
                               usage-i
                               LEN-i
                               DLEN-i
                               PREC-i
                               SCALE-i
                               OCC-i
                               OCCDEPEND-i
                               OCCLVL-i
                               REDEFLVL-i
                               REDEFELE-i
                               DESC-i
                               PREFIX-i
                               UDC-KEY-i
                               UDC-VAL-i
                               MapList-i
                               RESULT-IND
                               SQLSTATE2
                               PROCEDURE-NAME
                               SPECIFIC-NAME
                               MESSAGE-TEXT
                               SQL-COMMAND-CODE
                               SQL-OP-CODE
                               INSTANCE-ID
                               LOCAL-WORK-AREA
                               GLOBAL-WORK-AREA.
      *----------------------------------------------------------------*
      *                                                                *
      *----------------------------------------------------------------*
      *                                                                *
      *----------------------------------------------------------------*
       0000-MAINLINE                       SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    DISPLAY '*-------------------------------*'.
      *    DISPLAY '*  isptc001 ENTRY               *'.
      *    DISPLAY '*-------------------------------*'.

           IF NOT SQL-COMMAND-CODE-VALID
              MOVE SQL-COMMAND-CODE      TO NUMERIC-8
              DISPLAY 'INVALID SQL-COMMAND-CODE:' DISPLAY-8
              DISPLAY 'INVALID sql-COMMAND-hex :'
                   function hex-of(sql-command-code)
              MOVE '38002'               TO SQLSTATE2
              MOVE 'INVALID SQL-COMMAND-CODE'
                                         TO MESSAGE-TEXT
              EXIT PROGRAM
              STOP RUN.

      *    DISPLAY ' '
      *    DISPLAY 'COMMAND-CODE : ', COMMAND-CODE(SQL-COMMAND-CODE).
      *    COMPUTE WRK-X = SQL-OP-CODE / 4 - 2.
      *    DISPLAY 'SQL-OP-CODE  : ', OP-CODE(WRK-X).
      *    DISPLAY ' '

           IF SQL-OPEN-SCAN
              PERFORM 0100-BIND-DATABASE
              PERFORM 0200-INIT-RUNTIME
           ELSE
              IF SQL-NEXT-ROW
                 PERFORM 1000-NEXT-ROW
              ELSE
                 IF SQL-INSERT-ROW
                    PERFORM 2000-INSERT-ROW
                 ELSE
                    IF SQL-UPDATE-ROW
                       PERFORM 3000-UPDATE-ROW
                    ELSE
                       IF SQL-DELETE-ROW
                          PERFORM 4000-DELETE-ROW
                       ELSE
                          IF SQL-CLOSE-SCAN
                            PERFORM 0300-FINISH.

      *    DISPLAY 'SQLSTATE : ', SQLSTATE2.

           EXIT PROGRAM.
           STOP RUN.

      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0100-BIND-DATABASE                  SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    DISPLAY '       0100-BIND-DATABASE'.

           if not bound
           exec sql
               select segment
                 into :wk-dbname
               from system.schema
               where name = 'ISPTDICT'
           end-exec;

             if sqlcode not = 0
                display ' isptc001 Error getting DB-NAME, sqlcode='
                   sqlcode ' state: ' sqlstate
                 MOVE '02000'  TO SQLSTATE2
                 go to section-exit
             end-if;

             MOVE 'ISPTC001' TO PROGRAM-NAME
             display program-name ' bind to ' wk-dbname
                 ' sqlstate ' sqlstate;
             BIND RUN-UNIT  dbname wk-dbname
             IF ANY-ERROR-STATUS
               PERFORM 9999-DB-ERROR
             END-IF
             BIND class-092
             IF ANY-ERROR-STATUS
               PERFORM 9999-DB-ERROR
             END-IF
             BIND attribute-093
             IF ANY-ERROR-STATUS
               PERFORM 9999-DB-ERROR
             END-IF
             bind RCDSYN-079
             BIND NAMESYN-083
             BIND SDR-042
             BIND SDES-044
             BIND ELEMSYN-085
             BIND INQ-058
             BIND SR-036
             BIND RCDSYNATTR-141
             BIND ATTRNEST-132
             BIND mapfld-124
             BIND panelfld-121
             BIND pfld-data-147
             BIND map-098
             IF ANY-ERROR-STATUS
               PERFORM 9999-DB-ERROR
             END-IF;
             ready  ddldml usage-mode retrieval
             SET BOUND                   TO TRUE
           END-IF.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0200-INIT-RUNTIME                   SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    DISPLAY '       0200-INIT-RUNTIME'.
           perform 0205-get-json-attr.
           IF DB-rec-not-found
             display program-name ' JSON ATTRIBUTE-093 not defined'
      *      GO TO SECTION-EXIT
           END-IF.
      *
      *

           if recver-i = -1
              move 1 to recver
           end-if.
           move  0 to  w-cur-idx.
           move rec-name    to rsyn-name-079.
           move recver      to rsyn-ver-079.
           display program-name ' where rec=' rec-name ' v' recver .
           find    calc RCDSYN-079
           IF DB-rec-not-found
             move '02000' to SQLstate2
             move 'Tried my best, but record was nowhere to be found.'
                 to message-text
             GO TO SECTION-EXIT
           END-IF.
           accept ws-save-dbkey-namesyn from
               rcdsyn-079  currency.

      *    move ws-save-dbkey-namesyn to wrk-dbkey.
      *    perform 9000-ROWID-DISPLAY
      *    display 'RCDSYN  dbkey ' DIS-ROWID.

           perform 0210-get-jsonrec.
           perform 0250-get-udckeys.

           if recver = 0
              move 1 to recver
           end-if.
           move rec-name    to WS-REC.
           move recver      to WS-RECVER.
           move rec-name    to rsyn-name-079.
           move recver      to rsyn-ver-079.
           obtain  calc RCDSYN-079
           perform idms-status.
           move 0 to map-cnt.
      *    display 'maplist' maplist maplist-i
           if maplist-i not = -1
              perform 0280-fetch-maps
           end-if.

           move 0 to ws-lvl-ix.
       SECTION-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       0205-get-json-attr                  SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0205-get-json-attr'
           move 'JSON' to attr-name-093.
           obtain calc  attribute-093.
       do-while-attr.
           IF DB-REC-NOT-FOUND
             move '90326' to SQLstate2
             display program-name ' Language JSON not defined.'
             move 'Language JSON not defined.' to message-text
             GO TO SECTION-EXIT
           END-IF.
           perform idms-status.
           obtain OWNER within class-attr.
           perform idms-status.
           if class-name-092 = 'LANGUAGE'
             move '00000' to SQLstate2
             accept WS-SAVE-DBKEY-attr from ATTRIBUTE-093
                currency
             GO TO SECTION-EXIT
           END-IF.
           find duplicate attribute-093.
           go to do-while-attr.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
       0210-get-jsonrec                    SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0210-get-jsonrec'.
           find current rcdsyn-079.
           obtain owner within sr-rcdsyn.
       DO-WHILE-SR-RCDSYN.
           obtain next  rcdsyn-079 within sr-rcdsyn.
           if db-end-of-set
              display program-name ': JSON not defined for rec'
              display 'Please assign Language Json to '
                ' a record synonym'
              move spaces to JSONREC
              move 0      to JRECVER
              move -1     to jsonrec-i
              move -1     to jrecver-i
              go to section-exit
           end-if.

             accept WS-SAVE-DBKEY-rcdsyn from
               rcdsyn-079  currency.
      *    move ws-save-dbkey-rcdsyn  to wrk-dbkey.
      *    perform 9000-ROWID-DISPLAY
      *    display rsyn-name-079 ' v' rsyn-ver-079
      *    display 'RCDSYN  dbkey ' DIS-ROWID.

       DO-WHILE-RCDSYN-ATTR.
           find   next  RCDSYNATTR-141 within RCDSYN-RCDSYNATT.
           if db-end-of-set
              go to DO-WHILE-SR-RCDSYN;
           end-if.
           accept WS-SAVE-DBKEY-work  from attr-jct
                owner currency.
           perform idms-status.

      *    move ws-save-dbkey-attr    to wrk-dbkey.
      *    perform 9000-ROWID-DISPLAY
      *    display 'attr dbkey ' DIS-ROWID.
      *    move ws-save-dbkey-work    to wrk-dbkey.
      *    perform 9000-ROWID-DISPLAY
      *    display 'rcdsynAttr dbkey ' DIS-ROWID.

           IF ws-save-dbkey-work  not = ws-save-dbkey-attr
              go to DO-WHILE-RCDSYN-ATTR
           end-if.

      * got a json rec
           move '00000' to SQLstate2
           move rsyn-name-079 to JSONREC;
           move rsyn-ver-079  to JRECVER;

           move 1 to w-i;
           move function lower-case(jsonrec) to jsonrec.
       do-while-ok.
           if jsonrec(w-i : 1) = '-'
              move '_' to jsonrec(w-i : 1)
           end-if
           add 1 to w-i
           if w-i < 33 and jsonfld(w-i : 1) not = ' '
              go to do-while-ok
           end-if.

      *    display 'Jsonrec=' jsonrec ' v ' jrecver
           accept WS-SAVE-DBKEY-rcdsyn from
               rcdsyn-079  currency.

       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0250-get-udckeys                    SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0250-get-udckeys '
      *    move 0 to w-udc-cnt.
           move 0 to w-date-id, w-time-id, w-datetime-id.
           move 'ISPT-DATE-FORMAT' to attr-name-093.
           perform 0260-getudc-id.
      *       display 'dateidx=' NEST-ID-132 error-status
           if db-status-ok
      *       display 'dateid=' NEST-ID-132
              move NEST-ID-132 to w-date-id
           end-if.
           move 'ISPT-TIME-FORMAT' to attr-name-093.
           perform 0260-getudc-id.
           if db-status-ok
               move NEST-ID-132 to w-time-id
           end-if.
           move 'ISPT-DATETIME-FORMAT' to attr-name-093.
           perform 0260-getudc-id.
           if db-status-ok
               move NEST-ID-132 to w-datetime-id
           end-if.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0260-getudc-id                      SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0260-getudc-id '.
           obtain calc attribute-093
           if db-rec-not-found
              display program-name
               ': USER DEFINED COMMENT on entity not defined for '
                 attr-name-093
              go to section-exit
           end-if.
           perform idms-status.
       attrnest-loop.
           obtain next ATTRNEST-132 within attr-impl.
           if db-end-of-set
              display program-name
                ': USER DEFINED COMMENT on entity RECORD '
                 'not defined for ' attr-name-093;
              go to section-exit
           end-if.
           perform idms-status.
           obtain owner within attr-expl.
           perform idms-status.
      *    display 'udc entity ' attr-name-093
           if attr-name-093 = 'RECORD'
              go to section-exit
           end-if.
           obtain duplicate attribute-093
           if db-status-ok
               go to attrnest-loop
           end-if.
              display program-name
               ': USER DEFINED COMMENT on entity RECORD '
                 'not defined for ' attr-name-093.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0280-fetch-maps                     SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0280-fetch maps'
           move 0 to w-i, map-cnt.
           move maplist to g-mapname-list.
       map-loop.
           add 1 to w-i.
           if w-i > 5
              go to section-exit
           end-if.
           if mapname(w-i) not = spaces
              move mapname(w-i) to map-name-098
              find calc map-098
           else
              go to map-loop
           end-if.
           if db-rec-not-found
              display program-name
                ': Map ' map-name-098 ' not found, ignored.'
              go to map-loop
           end-if.
           perform idms-status.
           add  1 to map-cnt.
           move mapname(w-i) to mapname(map-cnt)
           accept map-dbkey(map-cnt)  from
               map-098     currency.
           go to map-loop.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0300-FINISH                         SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    DISPLAY '       0300-FINISH'.
           finish.

           SET UNBOUND                   TO TRUE.

       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1000-NEXT-ROW                       SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    DISPLAY '       1000-NEXT-ROW'.
           perform 1010-reset-nulls.

           if ws-save-dbkey-namesyn = 0
              move '02000' to sqlstate2
              go to section-exit
           end-if.

           move ws-save-dbkey-namesyn to wrk-dbkey.
           perform 9000-ROWID-DISPLAY
      *    display 'namesyn dbkey ' DIS-ROWID.

           find db-key is ws-save-dbkey-namesyn.
           perform idms-status.
           obtain next namesyn-083 within rcdsyn-namesyn

           if db-end-of-set
              move '02000' to sqlstate2
              go to section-exit
           end-if.
           accept ws-save-dbkey-namesyn from
               namesyn-083 currency.
           perform idms-status.

           obtain owner within sdr-namesyn.
           perform idms-status.
           accept ws-save-dbkey-sdr from
               sdr-042  currency.

           obtain owner within inq-sdr.
           perform idms-status.

           move rsyn-name-079                to rec-name.
           move rsyn-ver-079                 to RECVER.
           move syn-name-083                 to ELE.
           move seq-042                      to SEQ.
           move DR-LVL-042                   to LVL.
           if lenGTH-042 + precision-042 + use-042 = 0
              move 'Y'                       to ISGRP
           else
              move 'N'                       to ISGRP
           end-if.
           move DR-LPOS-083                  to POS.
           move pic-042                      to elepic.
           move dATA-TYPE-042                to DTYPE.
           move use-042                      to ele-mode.
           move lenGTH-042                   to LEN.
           move DR-LGTH-042                  to DLEN.
           move PRECISION-042                to PREC.
           move SCALE-042                    to SCALE.
           move OCC-042                      to OCC.
           move OCC-LVL-042                  to OCCLVL.
           move RDF-LVL-042                  to REDEFLVL
           if   rdf-nam-083  = spaces
      *        display  seq ' ' lvl '  ele:' ele
                move -1  to redefele-i
                move 0   to redefele-seq
                move seq to ws-rseq(lvl)
           else
               move 0              to redefele-i
               compute REDEFELE-seq = ws-rseq(lvl) / 100
      *        display  seq ' ' lvl ' rele:' ele ' redef ' redefele-seq
           end-if.

           if   desc-058 = spaces
              move DR-NAM-042                   to DESC
           else
              move desc-058                     to DESC
           end-if.
           move PREFIX-VAL-079               to PREFIX.

***   *    move DEPEND-ON-083                to OCCDEPEND.
           if DEPEND-ON-083 Not Equal spaces
      *       display 'find depend on for '  syn-name-083
              move depend-on-083 to w-depend-on
              move 0  to occdepend-i
              find current namesyn-083
              perform idms-status
              perform 1550-find-depend-on
           else
              move -1 to occdepend-i
              move 0 to occdepend-seq
           end-if.
           find db-key is ws-save-dbkey-namesyn.
           perform idms-status.
           perform 1500-check-map-participation.
           perform 1100-get-jsonele.
           perform 1200-get-udc.
           move '00000' to sqlstate2.

           if ws-lvl-ix = 0
              move 1   to ws-lvl-ix
              move -1  to ws-seq(ws-lvl-ix)
              move 0   to ws-lvl(ws-lvl-ix)
              move 0   to ws-offset(ws-lvl-ix)
           end-if.
  
	     
           if lvl > ws-lvl(ws-lvl-ix)
              add 1 to ws-lvl-ix
           end-if.

           if lvl < ws-lvl(ws-lvl-ix)
              perform until lvl not less than ws-lvl(ws-lvl-ix)
                 or  ws-lvl-ix = 2
                 move 0 to ws-offset(ws-lvl-ix)
                 subtract 1 from ws-lvl-ix
              end-perform;
           end-if.
           move seq to ws-seq(ws-lvl-ix).
           move lvl to ws-lvl(ws-lvl-ix).
           move ws-seq(ws-lvl-ix - 1) to parent-seq.
           compute parent-seq =  ws-seq(ws-lvl-ix - 1) / 100.
           compute ws-offset(ws-lvl-ix) = pos + wk-offset(ws-lvl-ix -1) -1.
           move ws-offset(ws-lvl-ix) to offset.
           perform 1900-get-siblings.

      *    display 'ISPTC001  Ele: ' seq ' ' lvl ' ' ele.
       SECTION-EXIT.
           EXIT.

      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1010-reset-nulls                    SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
              move 0 to parent-i.
              move 0 to JSONREC-i .
              move 0 to JRECVER-i .
              move 0 to JSONFLD-i .
              move 0 to REC-i .
              move 0 to RECVER-i .
              move 0 to ELE-i .
              move 0 to SEQ-i .
              move 0 to LVL-i .
              move 0 to ISGRP-i .
              move 0 to POS-i .
              move 0 to offset-i.
              move 0 to Pic-i .
              move 0 to DTYPE-i .
              move 0 to usage-i .
              move 0 to LEN-i .
              move 0 to DLEN-i .
              move 0 to PREC-i .
              move 0 to SCALE-i .
              move 0 to OCC-i .
              move 0 to OCCDEPEND-i.
              move 0 to OCCLVL-i .
              move 0 to REDEFLVL-i .
              move 0 to REDEFELE-i .
              move 0 to DESC-i .
              move 0 to PREFIX-i .
              move 0 to UDC-KEY-i .
      *       move spaces to udc-key, udc-val .
       SECTION-EXIT.
           EXIT.

      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1100-get-jsonele                    SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '1100-get-jsonele'
           move '0000' to error-status.
       do-while-namesyn.
           find next namesyn-083 within sdr-namesyn.
           if db-end-of-set
              move ele  to   jsonfld
              go to section-exit
           end-if.
           perform idms-status;

           accept ws-save-dbkey-work from
                rcdsyn-namesyn owner currency.
           perform idms-status;
           if ws-save-dbkey-work = ws-save-dbkey-rcdsyn
              get namesyn-083;
              move SYN-NAME-083   to JSONFLD
      *       display 'jsonfld:' sYN-NAME-083
              go to section-exit
           end-if.
           go to do-while-namesyn.
       SECTION-EXIT.
              perform 1800-sanitize-jsonfld
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1200-get-udc                        SECTION.
      *----------------------------------------------------------------*
      *  for the current sdr check if it has a sdes-044 with cmt-it    *
      *    = to a UDC
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '1200-get-udc'
           move spaces to udc-val.
           move 0      to udc-key.
           find  sdr-042 db-key  is ws-save-dbkey-sdr.
           perform idms-status.
       udc-loop.
           obtain next SDES-044 within sdr-sdes.
           if db-end-of-set
              go to section-exit
           end-if.
           if cmt-id-044 > 0
              if cmt-id-044 = w-date-id
              or cmt-id-044 = w-time-id
              or cmt-id-044 = w-datetime-id
                  move function upper-case(cmt-info-044(1))
                       to udc-val;
                  INSPECT udc-val
                      REPLACING ALL '/' BY '_'
                                ALL '-' BY '_'
                                ALL ':' BY '_'
                                ALL '.' BY '_';
      *          display 'Will search for ' udc-val
                 Set Uindex to 1
                 Search udc-entry
                   when w-val(uindex)    = udc-val
                      move 0 to udc-val-i, udc-key-i
                      move w-key(uIndex) to udc-key
                 end-search;
                 if udc-key = 0
                    display program-name ' udc key ' udc-val
                        ' not defined in ' program-name;

                 end-if;
                 display program-name ' ' function trim(ele)
                          '  udc ' udc-val ' = ' udc-key ;
              end-if;
              go to section-exit
           end-if.
           go to udc-loop.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1500-check-map-participation        SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display ' map participation'
           MOVE 'N' TO isMapFld.
           move 0   to isMapFld-i.
           MOVE 'N' TO isReq.
           move 0   to isReq-i.
           MOVE 'N' TO isUpd.
           move 0   to isUpd-i.
      *    if map-cnt = 0
      *       if namesyn-mapfld not empty
      *          move 0 to ismapfld-i
      *          move 'Y' to isMapfld
      *          perform 1600-getmaps
      *       end-if;
      *       go to section-exit;
      *    end-if.
       maplookup-loop.
           obtain next mapfld-124 within namesyn-mapfld.
           if db-end-of-set
      *       display 'end of maplookup'
              go to section-exit
           end-if.
           perform idms-status.
           if map-cnt = 0
                 move 0 to ismapfld-i
                 move 'Y' to isMapfld
                 perform 1600-getmapInfo
                 if isReq = 'Y' and isUpd = 'Y'
                    go to section-exit;
                 go to maplookup-loop
           end-if.
           accept ws-save-dbkey-work from
                map-mapfld owner currency.
           perform idms-status;
           move 0 to w-i.
       mapcheck-loop.
            add 1 to w-i.
            if w-i > map-cnt
               go to maplookup-loop
            end-if.
            if ws-save-dbkey-work = map-dbkey(w-i)
      *          display ele ' in a map ' mapname(w-i)
                 move 0 to ismapfld-i
                 move 'Y' to isMapfld
                 perform 1600-getmapInfo
                 if isReq = 'Y' and isUpd = 'Y'
                    go to section-exit;
            end-if.
            go to mapcheck-loop.
       SECTION-EXIT.
           EXIT.

      *----------------------------------------------------------------*
       1550-find-depend-on                 SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display ' 1550 find depend on' .
       do-while-namesyn.
           obtain prior namesyn-083 within rcdsyn-namesyn
           if db-end-of-set
              move 0  to OCCDEPEND-seq
              go to section-exit
           end-if.
           perform idms-status.
      *    display 'ele '  syn-name-083 ' depnd ' w-depend-on
           if syn-name-083 = w-depend-on
              obtain owner within sdr-namesyn
              perform idms-status
              compute occdepend-seq = seq-042 / 100
              go to section-exit
           end-if.
           go to do-while-namesyn.
       SECTION-EXIT.
           EXIT.

      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1600-getmapinfo                     SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '1600-getmapinfo'
           find owner within panelfld-mapfld
           obtain first pfld-data-147 within panelfld-pfld
      *    display 'attr-flag:' function hex-of(ATTR-FLAG-147)
      *        ' mflflg1:' function hex-of(MFLFLG1-124);
           move attr-flag-147 to bts-pass-bits.
           perform 7000-expand-bits.
           if BTS-PASS-BYTE-03 = 0
              move 0 to isUpd-i
              move 'Y' to isUpd
           end-if.
           move MFLFLG1-124   to bts-pass-bits.
           perform 7000-expand-bits.
           if BTS-PASS-BYTE-02 = 1
              move 0 to isReq-i
              move 'Y' to isReq
           end-if.

       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1800-sanitize-jsonfld               SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '1800-sanitize-jsonfld'
           move 1 to w-i.
           move function lower-case(jsonfld) to jsonfld.
       do-while-ok.
           if jsonfld(w-i : 1) = '-'
              move '_' to jsonfld(w-i : 1)
           end-if.
           add 1 to w-i.
           if w-i > 32 or jsonfld(w-i : 1) = ' '
              go to section-exit
           end-if.
           go to do-while-ok.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       1900-get-siblings                   SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '1900-get-siblings'
           move 0 to next-seq, fstchild-seq.
           move -1 to next-i, fstchild-i.
           set fstchild-not-found to true.

           find db-key is ws-save-dbkey-namesyn.
           perform idms-status.
       do-while-ok.
           find   next namesyn-083 within rcdsyn-namesyn

           if db-end-of-set
              go to section-exit
           end-if.

           obtain owner within sdr-namesyn.
           perform idms-status.

           if   DR-LVL-042 > ws-lvl(ws-lvl-ix)
              if fstchild-not-found
                 compute fstchild-seq  = seq-042 / 100;
                 move  1       to fstchild-i
                 set fstchild-found to true
              end-if;
           else if   DR-LVL-042 = ws-lvl(ws-lvl-ix)
              compute  next-seq =   seq-042 / 100;
              move  1       to next-i
              go to  section-exit
           else
              go to  section-exit
           end-if.
           go to do-while-ok.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       2000-INSERT-ROW                     SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           DISPLAY '       2000-INSERT-ROW'.


           MOVE '01000'  TO SQLSTATE2.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       3000-UPDATE-ROW                     SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           DISPLAY '       3000-UPDATE-ROW'.


           MOVE SQLSTATE TO SQLSTATE2.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       4000-DELETE-ROW                     SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           DISPLAY '       4000-DELETE-ROW'.


           MOVE SQLSTATE TO SQLSTATE2.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *  Convert WRK-ROWID to display in DIS-ROWID                     *
      *----------------------------------------------------------------*
       9000-ROWID-DISPLAY                  SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           move  16 to wrk-radix.
           DIVIDE WRK-DBKEY BY WRK-radix
                  GIVING    DIS-PAGE
                  REMAINDER DIS-LINE.

       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       copy idms idms-status.
      *----------------------------------------------------------------*
       idms-abort                          SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
              move error-status to sqlstate2-ERROR.
              MOVE '02' to SQLSTATE2-CLASS.


       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
       7000-expand-bits                    SECTION.
      * code obtained from simotime.com                               -*
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           subtract TWO-BYTES-BINARY from TWO-BYTES-BINARY
           add 1   to ZERO giving IX-1
           add 128 to ZERO giving REGISTER-1
           move BTS-PASS-BITS to TWO-BYTES-02
           perform 8 times
               if  TWO-BYTES-BINARY = REGISTER-1
               or  TWO-BYTES-BINARY > REGISTER-1
                   move BIT-ON to BTS-PASS-BYTES(IX-1:1)
                   subtract REGISTER-1 from TWO-BYTES-BINARY
               else
                   move BIT-OFF to BTS-PASS-BYTES(IX-1:1)
               end-if
               divide 2 INTO REGISTER-1
               add 1 to IX-1
           end-perform.

       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
       9999-DB-ERROR                       SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           DISPLAY '       9999-DB-ERROR'.

           EXIT PROGRAM.
           STOP RUN.


       SECTION-EXIT.
           EXIT.
