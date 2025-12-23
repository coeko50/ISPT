      *COBOL PGM SOURCE FOR isptc003
      *RETRIEVAL
      *DMLIST
       IDENTIFICATION DIVISION.
       PROGRAM-ID.                     isptc003.
       AUTHOR.                         Kosie.
       DATE-WRITTEN.                   05/21/25.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      * This is a table procedure to retrieve a JSONMAP                *
      *                                                                *
      *                                                                *
      * -------------------------------------------------------------- *
      * The procedure needs these schema definitions:                  *
      *                                                                *
      *                                                                *
      * CREATE SCHEMA ISPT;                                            *
      * -------------------------------------------------------------- *
      * This table procedure program expects the following definition. *
      *                                                                *
      * CREATE TABLE PROCEDURE ISPT.JSONSCHEMA                         *
      *   ( JSONMAP_NAME                     CHARACTER(8),             *
      *     REC_COUNT                        SMALLINT,                 *
      *     SCH_ELE_COUNT                    SMALLINT,                 *
      *     SCH_ELE_OFFSET                   SMALLINT,                 *
      *     REC_NAME                         CHARACTER(32),            *
      *     REC_VERSION                      SMALLINT,                 *
      *     JSONREC_NAME                     CHARACTER(32),            *
      *     JSONREC_VER                      SMALLINT,                 *
      *     ELE_COUNT                        SMALLINT,                 *
      *     REC_CHILDCNT                     SMALLINT,                 *
      *     REC_ELE_OFFSET                   SMALLINT,                 *
      *     PARENT_OFFSET                    SMALLINT,                 *
      *     NEXT_OFFSET                      SMALLINT,                 *
      *     FSTCHILD_OFFSET                  SMALLINT,                 *
      *     JSONFLD                          CHARACTER(32),            *
      *     ELE_LVL                          SMALLINT,                 *
      *     ELE_ELEMENT                      CHARACTER(32),            *
      *     ELE_IX                           SMALLINT,                 *
      *     ELE_SEQ                          SMALLINT,                 *
      *     ELE_CHILDCNT                     SMALLINT,                 *
      *     ELE_OFFSET                       SMALLINT,                 *
      *     ELE_LEN                          SMALLINT,                 *
      *     ELE_DLEN                         SMALLINT,                 *
      *     ELE_OCC                          SMALLINT,                 *
      *     ELE_OCC_OFFSET                   SMALLINT,                 *
      *     ELE_OCC_DEPEND_IND               CHARACTER(1),             *
      *     ELE_PARENT_TYPE                  CHARACTER(1),             *
      *     ELE_OCC_DEPEND_OFFSET            SMALLINT,                 *
      *     ELE_OCCLVL                       SMALLINT,                 *
      *     ELE_OCCSIZE_1                    SMALLINT,                 *
      *     ELE_OCCSIZE_2                    SMALLINT,                 *
      *     ELE_ISGROUPELE                   CHARACTER(1),             *
      *     ELE_ISSEL4OUPUT                  CHARACTER(1),
      *     ELE_ISUPDATEABLE                 CHARACTER(1),             *
      *     ELE_ISJSONREQUIRED               CHARACTER(1),             *
      *     ELE_DTYPE                        SMALLINT,                 *
      *     ELE_USAGE                        SMALLINT,                 *
      *     ELE_PREC                         SMALLINT,                 *
      *     ELE_SCALE                        SMALLINT,                 *
      *     ELE_UDC_KEY                      SMALLINT,                 *
      *     FUNC                             CHARACTER(1)              *
      *   )                                                            *
      *     EXTERNAL NAME ISPTC003                                     *
      *     DEFAULT DATABASE NULL                                      *
      *     ESTIMATED ROWS 60                                          *
      *     ESTIMATED IOS 150                                          *
      *     USER MODE                                                  *
      *     LOCAL WORK AREA 16                                         *
      *     GLOBAL WORK AREA 32760                                     *
      *    ;                                                           *
      *                                                                *
      *                                                                *
      * -------------------------------------------------------------  *
      * A key field must be defined on the table procedure so TDM      *
      * will know which columns are key fields for the table           *
      * procedure.                                                     *
      *                                                                *
      * rec & recver   the CALC key for the rcdsyn-079 record.         *
      *                                                                *
      * CREATE UNIQUE KEY isptc003_KEY                                 *
      *        ON ispt.jsonschema                                      *
      *                   (jsonmap_name        );                      *
      *                                                                *
      *                                                                *
      * -------------------------------------------------------------  *
      * After compiling the procedure, create an access module         *
      *                                                                *
      *  CREATE ACCESS MODULE ispt.isptc003                            *
      *    FROM isptc003;                                              *
      *                                                                *
      * -------------------------------------------------------------  *
      * Standard SQL can be issued on the table procedure:             *
      *                                                                *
      * SELECT *  FROM ispt.jsonschema where jsonmap_name = 'ddd';     *
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       ENVIRONMENT DIVISION.
      *
       CONFIGURATION SECTION.
      *SOURCE-COMPUTER.                IBM WITH DEBUGGING MODE.
      *
       IDMS-CONTROL SECTION.
       PROTOCOL.  MODE IS idms-dc  DEBUG
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
            '*******  isptc003  WORKING STORAGE STARTS HERE -->'.

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


        01 w-buffer.
           02 ws-buffer       pic x(512) occurs 64.
        01 WORK-FIELDS.
           02 W-pos                               PIC S9(5) COMP.
           02 W-spos                              PIC S9(5) COMP.
           02 W-len                               PIC S9(5) COMP.
           02 W-snap                              PIC S9(5) COMP.
           02 W-row                               PIC 9(3).
           02 W-title                             PIC x(134).
           02 W-mod-flags.
              07 jsonmap-flag                     pic 9.
                88 jsonmap-found                    value 1.
                88 not-jsonmap                      value 2.
           02 w-jsonmap-signature                pic x(8)
                 value '#JSONMAP'.

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



        EXEC SQL BEGIN DECLARE SECTION END-EXEC.
        77 wk-dbname                           PIC x(8).
        EXEC SQL  end  DECLARE SECTION END-EXEC.

        01 COPY IDMS SUBSCHEMA-NAMES.
        01 IDMS-work-AREA.
           02 COPY IDMS SUBSCHEMA-CTRL.
           02 COPY IDMS RECORD LOADHDR-156.
           02 COPY IDMS RECORD loadtext-157.

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

        77  w-JSONMAP-NAME       PIC X(8).
        77  w-REC-COUNT          PIC S9(4) COMP.
        77  w-SCH-ELE-COUNT      PIC S9(4) COMP.
        77  w-SCH-ELE-OFFSET     PIC S9(4) COMP.
        77  w-REC-NAME           PIC X(32).
        77  w-REC-VERSION        PIC S9(4) COMP.
        77  w-JSONREC-NAME       PIC X(32).
        77  w-JSONREC-VER        PIC S9(4) COMP.
        77  w-ELE-COUNT          PIC S9(4) COMP.
        77  w-REC-CHILDCNT       PIC S9(4) COMP.
        77  w-REC-ELE-OFFSET     PIC S9(4) COMP.
        77  w-PARENT-OFFSET     PIC S9(4) COMP.
        77  w-NEXT-OFFSET       PIC S9(4) COMP.
        77  w-1STCHILD-OFFSET   PIC S9(4) COMP.
        77  w-JSONFLD           PIC X(32).
        77  w-ELE-LVL           PIC S9(4) COMP.
        77  w-ELE-ELEMENT       PIC X(32).
        77  w-ELE-ix            PIC S9(4) COMP.
        77  w-ELE-SEQ           PIC S9(4) COMP.
        77  w-ELE-CHILDCNT      PIC S9(4) COMP.
        77  w-ELE-OFFSET        PIC S9(4) COMP.
        77  w-ELE-LEN           PIC S9(4) COMP.
        77  w-ELE-DLEN          PIC S9(4) COMP.
        77  w-ELE-OCC           PIC S9(4) COMP.
        77  w-ELE-OCC-OFFSET    PIC S9(4) COMP.
        77  w-ELE-OCC-DEPEND-IND PIC X(1).
        77  w-ELE-PARENT-TYPE   PIC X(1).
        77  w-ELE-OCC-DEPEND-OFFSET
                                PIC S9(4) COMP.
        77  w-ELE-OCCLVL        PIC S9(4) COMP.
        77  w-ELE-OCCSIZE-1     PIC S9(4) COMP.
        77  w-ELE-OCCSIZE-2     PIC S9(4) COMP.
        77  w-ELE-ISGROUPELE    PIC X(1).
        77  w-ELE-ISSEL4OUPUT   PIC X(1).
        77  w-ELE-ISUPDATEABLE  PIC X(1).
        77  w-ELE-ISJSONREQUIRED PIC X(1).
        77  w-ELE-DTYPE         PIC S9(4) COMP.
        77  w-ELE-USAGE         PIC S9(4) COMP.
        77  w-ELE-PREC          PIC S9(4) COMP.
        77  w-ELE-SCALE         PIC S9(4) COMP.
        77  w-ELE-UDC-KEY       PIC S9(4) COMP.
        77  w-func              PIC x(1) .


      *PROCEDURE PARAMETER INDICATORS
        77  w-JSONMAP-NAME-i         PIC S9(4) COMP SYNC.
        77  w-REC-COUNT-i            PIC S9(4) COMP SYNC.
        77  w-SCH-ELE-COUNT-i        PIC S9(4) COMP SYNC.
        77  w-SCH-ELE-OFFSET-i       PIC S9(4) COMP SYNC.
        77  w-REC-NAME-i             PIC S9(4) COMP SYNC.
        77  w-REC-VERSION-i          PIC S9(4) COMP SYNC.
        77  w-JSONREC-NAME-i         PIC S9(4) COMP SYNC.
        77  w-JSONREC-VER-i          PIC S9(4) COMP SYNC.
        77  w-ELE-COUNT-i            PIC S9(4) COMP SYNC.
        77  w-REC-CHILDCNT-i         PIC S9(4) COMP SYNC.
        77  w-REC-ELE-OFFSET-i       PIC S9(4) COMP SYNC.
        77  w-PARENT-OFFSET-i        PIC S9(4) COMP SYNC.
        77  w-NEXT-OFFSET-i          PIC S9(4) COMP SYNC.
        77  w-1STCHILD-OFFSET-i      PIC S9(4) COMP SYNC.
        77  w-JSONFLD-i              PIC S9(4) COMP SYNC.
        77  w-ELE-LVL-i              PIC S9(4) COMP SYNC.
        77  w-ELE-ELEMENT-i          PIC S9(4) COMP SYNC.
        77  w-ELE-ix-i               PIC S9(4) COMP SYNC.
        77  w-ELE-SEQ-i              PIC S9(4) COMP SYNC.
        77  w-ELE-CHILDCNT-i         PIC S9(4) COMP SYNC.
        77  w-ELE-OFFSET-i           PIC S9(4) COMP SYNC.
        77  w-ELE-LEN-i              PIC S9(4) COMP SYNC.
        77  w-ELE-DLEN-i             PIC S9(4) COMP SYNC.
        77  w-ELE-OCC-i              PIC S9(4) COMP SYNC.
        77  w-ELE-OCC-OFFSET-i       PIC S9(4) COMP SYNC.
        77  w-ELE-OCC-DEPEND-IND-i   PIC S9(4) COMP SYNC.
        77  w-ELE-PARENT-TYPE-i      PIC S9(4) COMP SYNC.
        77  w-ELE-OCC-DEPEND-OFFSET-i PIC S9(4) COMP SYNC.
        77  w-ELE-OCCLVL-i           PIC S9(4) COMP SYNC.
        77  w-ELE-OCCSIZE-1-i        PIC S9(4) COMP SYNC.
        77  w-ELE-OCCSIZE-2-i        PIC S9(4) COMP SYNC.
        77  w-ELE-ISGROUPELE-i       PIC S9(4) COMP SYNC.
        77  w-ELE-ISSEL4OUPUT-i      PIC S9(4) COMP SYNC.
        77  w-ELE-ISUPDATEABLE-i     PIC S9(4) COMP SYNC.
        77  w-ELE-ISJSONREQUIRED-i   PIC S9(4) COMP SYNC.
        77  w-ELE-DTYPE-i            PIC S9(4) COMP SYNC.
        77  w-ELE-USAGE-i            PIC S9(4) COMP SYNC.
        77  w-ELE-PREC-i             PIC S9(4) COMP SYNC.
        77  w-ELE-SCALE-i            PIC S9(4) COMP SYNC.
        77  w-ELE-UDC-KEY-i          PIC S9(4) COMP SYNC.
        77  w-func-i                 PIC S9(4) COMP SYNC.
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
           02 WS-SAVE-CONTROL-FIELDS.
              05 w-ix                              PIC S9(4) COMP SYNC.
              05 w-rx                              PIC S9(4) COMP SYNC.
              05 w-row-ele-cnt                     PIC S9(4) COMP SYNC.
              05 w-hdr-len                         PIC S9(4) COMP SYNC.
              05 w-rec-len                         PIC S9(4) COMP SYNC.
              05 w-ele-Entry-len                   PIC S9(4) COMP SYNC.
              05 w-ele-Offs                        PIC S9(4) COMP SYNC.
           02 COPY IDMS RECORD ispt-jsonschema.
           02 BIND-FLAG                           PIC X(01).
              88 BOUND                                       VALUE 'B'.
              88 UNBOUND                                     VALUE ' '.

      *----------------------------------------------------------------*
       PROCEDURE DIVISION USING
                 w-JSONMAP-NAME
                 w-REC-COUNT
                 w-SCH-ELE-COUNT
                 w-SCH-ELE-OFFSET
                 w-REC-NAME
                 w-REC-VERSION
                 w-JSONREC-NAME
                 w-JSONREC-VER
                 w-ELE-COUNT
                 w-REC-CHILDCNT
                 w-REC-ele-offset
                 w-PARENT-OFFSET
                 w-NEXT-OFFSET
                 w-1STCHILD-OFFSET
                 w-JSONFLD
                 w-ELE-LVL
                 w-ELE-ELEMENT
                 w-ELE-ix
                 w-ELE-SEQ
                 w-ELE-CHILDCNT
                 w-ELE-OFFSET
                 w-ELE-LEN
                 w-ELE-DLEN
                 w-ELE-OCC
                 w-ELE-OCC-OFFSET
                 w-ELE-OCC-DEPEND-IND
                 w-ELE-PARENT-TYPE
                 w-ELE-OCC-DEPEND-OFFSET
                 w-ELE-OCCLVL
                 w-ELE-OCCSIZE-1
                 w-ELE-OCCSIZE-2
                 w-ELE-ISGROUPELE
                 w-ELE-ISSEL4OUPUT
                 w-ELE-ISUPDATEABLE
                 w-ELE-ISJSONREQUIRED
                 w-ELE-DTYPE
                 w-ELE-USAGE
                 w-ELE-PREC
                 w-ELE-SCALE
                 w-ELE-UDC-KEY
                 w-func

                 w-JSONMAP-NAME-i
                 w-REC-COUNT-i
                 w-SCH-ELE-COUNT-i
                 w-SCH-ELE-OFFSET-i
                 w-REC-NAME-i
                 w-REC-VERSION-i
                 w-JSONREC-NAME-i
                 w-JSONREC-VER-i
                 w-ELE-COUNT-i
                 w-REC-CHILDCNT-i
                 w-REC-ELE-OFFSET-i
                 w-PARENT-OFFSET-i
                 w-NEXT-OFFSET-i
                 w-1STCHILD-OFFSET-i
                 w-JSONFLD-i
                 w-ELE-LVL-i
                 w-ELE-ELEMENT-i
                 w-ELE-ix-i
                 w-ELE-SEQ-i
                 w-ELE-CHILDCNT-i
                 w-ELE-OFFSET-i
                 w-ELE-LEN-i
                 w-ELE-DLEN-i
                 w-ELE-OCC-i
                 w-ELE-OCC-OFFSET-i
                 w-ELE-OCC-DEPEND-IND-i
                 w-ELE-PARENT-TYPE-i
                 w-ELE-OCC-DEPEND-OFFSET-i
                 w-ELE-OCCLVL-i
                 w-ELE-OCCSIZE-1-i
                 w-ELE-OCCSIZE-2-i
                 w-ELE-ISGROUPELE-i
                 w-ELE-ISSEL4OUPUT-i
                 w-ELE-ISUPDATEABLE-i
                 w-ELE-ISJSONREQUIRED-i
                 w-ELE-DTYPE-i
                 w-ELE-USAGE-i
                 w-ELE-PREC-i
                 w-ELE-SCALE-i
                 w-ELE-UDC-KEY-i
                 w-func-i
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
      *    DISPLAY '*  isptc003 ENTRY               *'.
      *    DISPLAY '*-------------------------------*'.

           IF NOT SQL-COMMAND-CODE-VALID
              MOVE SQL-COMMAND-CODE      TO NUMERIC-8
              display program-name ':'
                      'INVALID SQL-COMMAND-CODE:' DISPLAY-8
              DISPLAY 'INVALID sql-COMMAND-hex :'
                   function hex-of(sql-command-code)
              MOVE '38002'               TO SQLSTATE2
              MOVE 'INVALID SQL-COMMAND-CODE'
                                         TO MESSAGE-TEXT
              EXIT PROGRAM
              STOP RUN.


           IF SQL-OPEN-SCAN
              if w-jsonmap-name-i = -1
                 MOVE '02000'  TO SQLSTATE2
                 go to exit-quick-quick
              end-if;
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
                            PERFORM 9000-FINISH.

           if sqlstate2 not equal  '00000'
              if bound
                 perform 9000-finish;
              end-if;
           end-if.
       exit-quick-quick.
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
               display ' isptc003 Error getting DB-NAME, sqlcode='
                  sqlcode ' state: ' sqlstate
                MOVE '02000'  TO SQLSTATE2
                go to section-exit
           end-if;

             MOVE 'isptc003' TO PROGRAM-NAME
             display program-name ' bind to ' wk-dbname
             BIND RUN-UNIT  dbname wk-dbname
             perform idms-status
             BIND loadhdr-156
             perform idms-status
             BIND loadtext-157
             perform idms-status
             ready  ddldclod usage-mode retrieval
             perform idms-status

              SET BOUND                   TO TRUE
             end-if.
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
               compute w-hdr-len = Function length(REC-HEADER).
               compute w-rec-len = Function Length( rec-entry(1) ).
               compute w-ele-entry-len = Function Length( ele-entry(1) ).

      *        display 'hdrlen:' w-hdr-len ' reclen:' w-rec-len
      *                'elelen:' w-ele-entry-len.

               perform 0300-obtain-loadmod.
               if ANY-ERROR-STATUS
                  go to section-exit.
               if  not-jsonmap
                   display program-name ' :'
                           w-jsonMap-name ' is not a ISPT '
                     ' file.'
                  MOVE '38010'  TO SQLSTATE2
               end-if.
               perform 9000-finish.

               perform 0600-init-nulls.
               move 0 to w-ix, w-rx, w-row-ele-cnt.
       SECTION-EXIT.
           EXIT.


      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0300-obtain-loadmod                 SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0300-obtain-loadmod'.

           move w-jsonMap-name to loadhdr-modname-156.
           obtain calc  loadhdr-156
            on db-rec-not-found  next sentence.
       do-while-loadhdr.
           IF DB-REC-NOT-FOUND
              move '02000' to sqlstate2
             GO TO SECTION-EXIT
           END-IF.
           perform idms-status.
           display program-name
             ' loadmod:' loadhdr-modname-156 ' v'
                loadhdr-vers-156
           if loadhdr-vers-156 = 1
              move 1 to jsonmap-flag
              perform 0400-obtain-loadtext
              if jsonmap-found
                 perform 0500-move-jsonschema
              end-if;
              go to section-exit
           end-if.
           obtain duplicate loadhdr-156
            on db-rec-not-found  next sentence.
           go to do-while-loadhdr.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
       0400-obtain-loadtext                SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0400-obtain-loadtext.'.
           obtain first loadtext-157 within loadhdr-loadtext
              on DB-END-OF-SET next sentence.
           if db-status-ok  and loadhdr-vers-156 = 1
              if loadtext-157(1:8) not = w-jsonmap-signature
                 move 2 to jsonmap-flag
                 go to section-exit
             end-if;
           end-if.

           move 0 to w-row.
           move 1 to w-pos.
       DO-WHILE-loadtext.
           if db-end-of-set
              go to end-of-loadtext
           end-if.
           perform idms-status.
           add 1 to w-row.
           move loadtext-157 to ws-buffer(w-row).
      *    display 'w-row:' w-row
      *    move 128 to w-snap
      *
      *    if w-row < 3
      *     STRING '  LOADtext-:'  DELIMITED BY ':'
      *             w-row DELIMITED BY SIZE into w-title
      *     SNAP title w-title from loadtext-157 length w-snap
      *     STRING '  ws-buffer-:'  DELIMITED BY ':'
      *             w-row DELIMITED BY SIZE into w-title
      *     SNAP title w-title from ws-buffer(w-row) length w-snap
      *    end-if.
           add 512 to w-pos
           obtain next loadtext-157 within loadhdr-loadtext
              on DB-END-OF-SET next sentence.
           go to do-while-loadtext.

       end-of-loadtext.
      *     move 800 to w-snap
      *     move '  ws-buffer' to w-title.
      *     SNAP title w-title from w-buffer length w-snap.
            move 300 to w-snap.
       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0500-move-jsonschema                SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
      *    display '0500-move-jsonschema'.
           compute w-len = w-hdr-len.
           move w-buffer(1:w-len) to REC-HEADER.

      *    display 'sch move 1:' w-len ' ' jsonmap-name
      *        ' reccnt ' rec-count ' ele-cnt ' sch-ele-count
      *        ' eleoffs' sch-ele-offset.

           compute w-pos = w-len + 1.
           compute w-len =  rec-count *  w-rec-len.

           move w-buffer(w-pos:w-len) to rec-info.

           compute w-spos = w-rec-len.
      *    display program-name ' :'
      *            'rec move ' w-pos ':' w-len ' recln:' w-spos.

      *    display program-name ' :'
      *       ' REC-NAME(1):' rec-name(1).

      *    compute w-pos = sch-ele-offset + 1.
           compute w-pos = w-pos + w-len.
           compute w-len = sch-ele-count *  w-ele-entry-len.

      *    display program-name ' :'
      *      'ele move from ' w-pos  ' len ' w-len
      *      ' sch ele count:' sch-ele-count ' entry len:'
      *       w-ele-entry-len.
           move w-buffer(w-pos:w-len) to ele-info.

      **   display  ele-lvl(1) ':'
      **        ELE-ISGROUPELE (1)
      **        ELE-ISSEL4OUPUT (1)
      **        ELE-ISUPDATEABLE (1)
      **        ELE-ISJSONREQUIRED (1) ':' JSONFLD(1) ':'
      **        ELE-DTYPE (1) .

      *     display 'endofsetup'.

       SECTION-EXIT.
           EXIT.
      *----------------------------------------------------------------*
      *                                                                *
      *                                                                *
      *----------------------------------------------------------------*
       0600-init-nulls                     SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           move 1 to  w-JSONMAP-NAME-i            .
           move 1 to  w-REC-COUNT-i               .
           move 1 to  w-SCH-ELE-COUNT-i           .
           move 1 to  w-SCH-ELE-OFFSET-i          .
           move 1 to  w-REC-NAME-i                .
           move 1 to  w-REC-VERSION-i             .
           move 1 to  w-JSONREC-NAME-i            .
           move 1 to  w-JSONREC-VER-i             .
           move 1 to  w-ELE-COUNT-i               .
           move 1 to  w-REC-CHILDCNT-i            .
           move 1 to  w-REC-ELE-OFFSET-i          .
           move 1 to  w-PARENT-OFFSET-i           .
           move 1 to  w-NEXT-OFFSET-i             .
           move 1 to  w-1STCHILD-OFFSET-i         .
           move 1 to  w-JSONFLD-i                 .
           move 1 to  w-ELE-LVL-i                 .
           move 1 to  w-ELE-ELEMENT-i             .
           move 1 to  w-ELE-ix-i                 .
           move 1 to  w-ELE-SEQ-i                 .
           move 1 to  w-ELE-CHILDCNT-i            .
           move 1 to  w-ELE-OFFSET-i              .
           move 1 to  w-ELE-LEN-i                 .
           move 1 to  w-ELE-DLEN-i                .
           move 1 to  w-ELE-OCC-i                 .
           move 1 to  w-ELE-OCC-OFFSET-i          .
           move 1 to  w-ELE-OCC-DEPEND-IND-i      .
           move 1 to  w-ELE-PARENT-TYPE-i         .
           move 1 to  w-ELE-OCC-DEPEND-OFFSET-i   .
           move 1 to  w-ELE-OCCLVL-i              .
           move 1 to  w-ELE-OCCSIZE-1-i           .
           move 1 to  w-ELE-OCCSIZE-2-i           .
           move 1 to  w-ELE-ISGROUPELE-i          .
           move 1 to  w-ELE-ISSEL4OUPUT-i         .
           move 1 to  w-ELE-ISUPDATEABLE-i        .
           move 1 to  w-ELE-ISJSONREQUIRED-i      .
           move 1 to  w-ELE-DTYPE-i               .
           move 1 to  w-ELE-USAGE-i               .
           move 1 to  w-ELE-PREC-i                .
           move 1 to  w-ELE-SCALE-i               .
           move 1 to  w-ELE-UDC-KEY-i             .
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
           MOVE '00000'  TO SQLSTATE2

           add 1 to w-ix

           if w-ix > sch-ele-count
      *       display 'End of rows - ' w-ix
              move '02000' to sqlstate2
              go to section-exit
           end-if.

           perform 0600-init-nulls .

           if w-ix > w-row-ele-cnt
             add 1 to w-rx
             add ele-count(w-rx) to w-row-ele-cnt
      **
             display program-name
                 ' rec:' REC-NAME(w-rx)
                 ' rec-ele-offset:' REC-ELE-OFFSET (w-rx)
                 ' w-ix:' w-ix '-' w-rx ' ' ELE-COUNT (w-rx)
           end-if.

           move JSONMAP-NAME           to w-JSONMAP-NAME  .
           move REC-COUNT              to w-REC-COUNT     .
           move SCH-ELE-COUNT          to w-SCH-ELE-COUNT .
           move SCH-ELE-OFFSET         to w-SCH-ELE-OFFSET.
           move REC-NAME        (w-rx) to w-REC-NAME      .
           move REC-VERSION     (w-rx) to w-REC-VERSION   .
           move JSONREC-NAME    (w-rx) to w-JSONREC-NAME  .
           move JSONREC-VER     (w-rx) to w-JSONREC-VER   .
           move ELE-COUNT       (w-rx) to w-ELE-COUNT     .
           move REC-CHILDCNT    (w-rx) to w-REC-CHILDCNT  .
      *    move REC-ELE-OFFSET  (w-rx) to w-REC-ELE-OFFSET.
      *    override rec-ele-offset to show current element offset
           compute w-REC-ELE-OFFSET   = sch-ele-offset +
               (w-ix - 1) *  w-ele-entry-len.

           move PARENT-OFFSET   (w-ix) to w-PARENT-OFFSET .
           move NEXT-OFFSET     (w-ix) to w-NEXT-OFFSET   .
           move 1STCHILD-OFFSET (w-ix) to w-1STCHILD-OFFSET
           move JSONFLD         (w-ix) to w-JSONFLD       .
           move ELE-LVL         (w-ix) to w-ELE-LVL       .
           move ELE-ELEMENT     (w-ix) to w-ELE-ELEMENT   .
      **
      **   display program-name ' :'
      **         w-ix ' lvl:' ele-lvl(w-ix) ' ' ele-element(w-ix)
      **       ' seq:'   ele-seq(w-ix)
      **       ' offs'   w-rec-ele-OFFSET.

           move w-ix                   to w-ELE-ix        .
           move ELE-SEQ         (w-ix) to w-ELE-SEQ       .
           move ELE-CHILDCNT    (w-ix) to w-ELE-CHILDCNT  .
           move ELE-OFFSET      (w-ix) to w-ELE-OFFSET    .
           move ELE-LEN         (w-ix) to w-ELE-LEN       .
           move ELE-DLEN        (w-ix) to w-ELE-DLEN      .
           move ELE-OCC         (w-ix) to w-ELE-OCC       .
           move ELE-OCC-OFFSET  (w-ix) to w-ELE-OCC-OFFSET.
           move ELE-OCC-DEPEND-IND(w-ix) to w-ELE-OCC-DEPEND-IND.
           move ELE-PARENT-TYPE (w-ix) to w-ELE-PARENT-TYPE.
           move ELE-OCC-DEPEND-OFFSET(w-ix) to w-ELE-OCC-DEPEND-OFFSET.
           move ELE-OCCLVL      (w-ix) to w-ELE-OCCLVL    .
           move ELE-OCCSIZE(w-ix, 1)   to w-ELE-OCCSIZE-1 .
           move ELE-OCCSIZE(w-ix, 2)   to w-ELE-OCCSIZE-2 .
           move ELE-ISGROUPELE  (w-ix) to w-ELE-ISGROUPELE.
           move ELE-ISSEL4OUPUT (w-ix) to w-ELE-ISSEL4OUPUT
           move ELE-ISUPDATEABLE(w-ix) to w-ELE-ISUPDATEABLE
           move ELE-ISJSONREQUIRED(w-ix) to w-ELE-ISJSONREQUIRED.
           move ELE-DTYPE       (w-ix) to w-ELE-DTYPE     .
           move ELE-USAGE       (w-ix) to w-ELE-USAGE     .
           move ELE-PREC        (w-ix) to w-ELE-PREC      .
           move ELE-SCALE       (w-ix) to w-ELE-SCALE     .
           move ELE-UDC-KEY     (w-ix) to w-ELE-UDC-KEY   .
      *
      *    compute w-SCH-ELE-OFFSET =  w-SCH-ELE-OFFSET - w-hdr-len
      *    compute w-REC-ele-offset =  w-REC-ele-offset - w-hdr-len -
      *        ( w-rec-count * w-rec-len ).
      *    compute w-REC-ele-offset =  w-REC-ele-offset /
      *            w-ele-entry-len.
      *    add 1 to w-rec-ele-offset.
      *    if w-parent-offset < w-ele-offs
      *       compute w-PARENT-OFFSET  = w-PARENT-OFFSET - w-hdr-len
      *       compute w-PARENT-OFFSET  = w-PARENT-OFFSET / w-rec-len
      *    else
      *       compute w-PARENT-OFFSET  = w-PARENT-OFFSET - w-ele-offs
      *       compute w-PARENT-OFFSET  = w-PARENT-OFFSET /
      *               w-ele-entry-len
      *    end-if.
      *    add 1 to w-parent-offset.
      *    if w-next-offset > 0
      *      compute w-NEXT-OFFSET  = w-NEXT-OFFSET - w-ele-offs
      *      compute w-NEXT-OFFSET  = w-NEXT-OFFSET / w-ele-entry-len
      *      add 1 to w-next-offset
      *    end-if
      *    if w-1STCHILD-OFFSET > 0
      *      compute w-1STCHILD-OFFSET = w-1STCHILD-OFFSET - w-ele-offs
      *      compute w-1STCHILD-OFFSET = w-1STCHILD-OFFSET
      *            / w-ele-entry-len
      *      add 1 to w-1STCHILD-OFFSET
      *    end-if
      *    if w-ELE-OCC-OFFSET > 0
      *      compute w-ELE-OCC-OFFSET  = w-ELE-OCC-OFFSET  - w-ele-offs
      *      compute w-ELE-OCC-OFFSET  = w-ELE-OCC-OFFSET  /
      *          w-ele-entry-len
      *      add 1 to w-ELE-OCC-OFFSET
      *    end-if
      *    if w-ELE-OCC-DEPEND-OFFSET > 0
      *      compute w-ELE-OCC-DEPEND-OFFSET = w-ELE-OCC-DEPEND-OFFSET
      *              - w-ele-offs
      *      compute w-ELE-OCC-DEPEND-OFFSET = w-ELE-OCC-DEPEND-OFFSET
      *              / w-ele-entry-len
      *      add 1 to w-ELE-OCC-DEPEND-OFFSET
      *    end-if

           MOVE '00000'  TO SQLSTATE2.


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
       9000-finish                         SECTION.
      *----------------------------------------------------------------*
       SECTION-ENTRY.
           finish
            on any-error-status  next sentence.

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
              display 'ISPTC003 - error ' error-status.
              display '   dmlSequence:  ' dml-sequence.
              display '   errorRecord:  ' error-record.
              move error-status to sqlstate2-ERROR.
              MOVE '02' to SQLSTATE2-CLASS.


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
