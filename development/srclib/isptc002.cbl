      *COBOL PGM SOURCE FOR isptc002                                    00010015
      *RETRIEVAL                                                        00020015
      *DMLIST                                                           00030015
       IDENTIFICATION DIVISION.                                         00040015
       PROGRAM-ID.                     isptc002.                        00050015
       AUTHOR.                         Kosie.                           00060015
       DATE-WRITTEN.                   06/17/25.                        00070015
      *----------------------------------------------------------------*00080015
      *                                                                *00090015
      *                                                                *00100015
      * retrieve a json mapping module and endpoint definition         *00110015
      * from the load area and return it to the caller                 *00120015
      *                                                                *00130015
      *                                                                *00140015
      * -------------------------------------------------------------  *00150015
      *                                                                *00160015
      *----------------------------------------------------------------*00170015
       ENVIRONMENT DIVISION.                                            00180015
      *                                                                 00190015
       CONFIGURATION SECTION.                                           00200015
      *SOURCE-COMPUTER.                IBM WITH DEBUGGING MODE.         00210015
      *                                                                 00220015
       IDMS-CONTROL SECTION.                                            00230015
       PROTOCOL.  MODE IS BATCH            DEBUG                        00240015
                  IDMS-RECORDS MANUAL.                                  00250015
      *----------------------------------------------------------------*00260015
      *                                                                *00270015
      *----------------------------------------------------------------*00280015
       DATA DIVISION.                                                   00290015
      *                                                                 00300015
       SCHEMA SECTION.                                                  00310015
       DB    IDMSNWKA WITHIN IDMSNTWK VERSION 1.                        00320015
      *----------------------------------------------------------------*00330015
      *                                                                *00340015
      *----------------------------------------------------------------*00350015
       WORKING-STORAGE SECTION.                                         00360015
        01 FILLER                                 PIC X(50) VALUE       00370015
            '*******  isptc002  WORKING STORAGE STARTS HERE -->'.       00380015
                                                                        00390015
       01  FILLER.                                                      00400015
               05 WRK-DBKEY                       PIC 9(9) COMP.        00410015
               05 WRK-RADIX                       PIC 9(4) COMP.        00420015
           05  DIS-ROWID.                                               00430015
               07 DIS-GROUP                       PIC 9(5).             00440015
               07 FILLER                          PIC X     VALUE '/'.  00450015
               07 DIS-PAGE                        PIC 9(10).            00460015
               07 FILLER                          PIC X     VALUE ':'.  00470015
               07 DIS-LINE                        PIC 9(4).             00480015
                                                                        00490015
                                                                        00500015
        EXEC SQL BEGIN DECLARE SECTION END-EXEC.                        00510015
        77 wk-dbname                           PIC x(8).                00520015
        EXEC SQL  end  DECLARE SECTION END-EXEC.                        00530015
                                                                        00540015
        01 WORK-FIELDS.                                                 00550015
           05 W-pos                               PIC S9(4) COMP.       00560015
           05 W-spos                              PIC S9(4) COMP.       00570015
           05 W-len                               PIC S9(4) COMP.       00580015
           02 W-snap                              PIC S9(5) COMP.       00590015
           02 W-row                               PIC 9(3).             00600015
           02 W-title                             PIC x(134).           00610015
           02 W-mod-flags.                                              00620015
              07 jsonmap-flag                     pic 9.                00630015
                88 jsonmap-found                    value 1.            00640015
                88 not-jsonmap                      value 2.            00650015
              07 endpoint-flag                    pic 9.                00660015
                88 endpoint-found                   value 1.            00670015
                88 not-endpoint                     value 2.            00680015
           02 W-mod-ind   redefines w-mod-flags  pic x(2).              00690015
              88 all-found                        value '11'.           00700015
              88 only-Endpoint                    value '01'.           00710015
              88 only-jsonmap                     value '10'.           00720015
              88 none-found                       value '00'.           00730015
           02 w-jsonmap-signature                pic x(8)               00740015
                 value '#JSONMAP'.                                      00750015
           02 w-endpoint-signature               pic x(8)               00760015
                 value '#ISPTEPT'.                                      00770015
           02 WS-SAVE-CONTROL-FIELDS.                                   00780015
              05 w-hdr-len                         PIC S9(4) COMP SYNC. 00790015
              05 w-rec-len                         PIC S9(4) COMP SYNC. 00800015
              05 w-ele-Entry-len                   PIC S9(4) COMP SYNC. 00810015
              05 w-ele-Offs                        PIC S9(4) COMP SYNC. 00820015
                                                                        00830015
                                                                        00840015
        01 COPY IDMS SUBSCHEMA-NAMES.                                   00850015
        01 IDMS-work-AREA.                                              00860015
           02 COPY IDMS SUBSCHEMA-CTRL.                                 00870015
           02 COPY IDMS RECORD LOADHDR-156.                             00880015
           02 COPY IDMS RECORD loadtext-157.                            00890015
           02 COPY IDMS RECORD lvl-test.                                00900015
                                                                        00910015
        01 WS-ERROR-MESSAGES.                                           00920015
           05 DB-ERROR-MSG.                                             00930015
              10 FILLER                           PIC X(14) VALUE       00940015
                 'DML STATEMENT '.                                      00950015
              10 DB-ERROR-DML-NBR                 PIC 9(02).            00960015
              10 FILLER                           PIC X(29) VALUE       00970015
                 ' RETURNED AN ERROR STATUS OF '.                       00980015
              10 DB-ERROR-STATUS                  PIC X(04).            00990015
              10 FILLER                           PIC X(33) VALUE SPACE.01000015
                                                                        01010015
        01 w-buffer.                                                    01020015
           02 ws-buffer       pic x(512) occurs 64.                     01030015
      *----------------------------------------------------------------*01040015
      *                                                                *01050015
      *----------------------------------------------------------------*01060015
       LINKAGE SECTION.                                                 01070015
                                                                        01080015
        01 COPY IDMS record ispt-jsonschema.                            01090015
        01 COPY IDMS record ispt-endpoint-definition.                   01100015
                                                                        01110015
      *----------------------------------------------------------------*01120015
       PROCEDURE DIVISION USING                                         01130015
                    ispt-jsonschema                                     01140015
                    ispt-endpoint-definition.                           01150015
      *----------------------------------------------------------------*01160015
      *                                                                *01170015
      *----------------------------------------------------------------*01180015
       0000-MAINLINE                       SECTION.                     01190015
      *----------------------------------------------------------------*01200015
       SECTION-ENTRY.                                                   01210015
      *    DISPLAY '*-------------------------------*'.                 01220015
           DISPLAY '*  isptc002 ENTRY               *'.                 01230015
           display 'jsonsch  ' SCHEMA-NAME.                             01240015
           display 'jsonmap  ' we-jsonmap-name.                         01250015
      *    DISPLAY '*-------------------------------*'.                 01260015
                                                                        01270015
               perform 0100-bind-database.                              01280015
                                                                        01290015
               compute w-hdr-len = Function length(REC-HEADER).         01300015
               compute w-rec-len = Function Length( rec-entry(1) ).     01310015
               compute w-ele-entry-len =                                01320016
                   Function Length( ele-entry(1) ).                     01321016
               move 0 to w-mod-flags.                                   01330015
               perform 1200-obtain-loadmod.                             01340015
               display ' flags ' w-mod-flags ':' w-mod-ind.             01341016
               if  not-jsonmap                                          01350015
                 or not-endpoint                                        01360015
                   move -1  to we-return-code                           01370015
                   display we-jsonMap-name ' is not a ISPT '            01380015
                     ' file.'                                           01390015
               end-if.                                                  01400015
               if  all-found                                            01410015
                   move 0  to we-return-code                            01420015
                   display we-jsonMap-name ' endpoint and '             01430015
                     ' jsonmap loaded'                                  01440015
               end-if.                                                  01450015
               if none-found                                            01460015
                   move 100 to we-return-code                           01470015
                   display we-jsonMap-name ' not to be found.'          01480015
               end-if.                                                  01490015
               if  only-endpoint                                        01500015
                   move 4    to we-return-code                          01510015
                   display we-jsonMap-name ' no jsonmap '               01520015
               end-if.                                                  01530015
               if  only-jsonmap                                         01540015
                   move 8    to we-return-code                          01550015
                   display we-jsonMap-name ' no definition'             01560015
               end-if.                                                  01570015
                                                                        01580015
               perform 9000-finish.                                     01590015
                                                                        01600015
           EXIT PROGRAM.                                                01610015
           STOP RUN.                                                    01620015
                                                                        01630015
      *----------------------------------------------------------------*01640015
      *                                                                *01650015
      *                                                                *01660015
      *----------------------------------------------------------------*01670015
       0100-BIND-DATABASE                  SECTION.                     01680015
      *----------------------------------------------------------------*01690015
       SECTION-ENTRY.                                                   01700015
      *    DISPLAY '       0100-BIND-DATABASE'.                         01710015
                                                                        01720015
           exec sql                                                     01730015
               select segment                                           01740015
                 into :wk-dbname                                        01750015
               from system.schema                                       01760015
               where name = 'ISPTDICT'                                  01770015
           end-exec.                                                    01780015
                                                                        01790015
             if sqlcode not = 0                                         01800015
                 display ' isptc002 Error getting DB-NAME, sqlcode='    01810015
                    sqlcode ' state: ' sqlstate.                        01820015
                                                                        01830015
             MOVE 'isptc002' TO PROGRAM-NAME                            01840015
             display program-name ' bind to ' wk-dbname.                01850015
             BIND RUN-UNIT  dbname wk-dbname                            01860015
             perform idms-status.                                       01870015
             BIND loadhdr-156                                           01880015
             perform idms-status.                                       01890015
             BIND loadtext-157                                          01900015
             perform idms-status.                                       01910015
             ready  ddldclod usage-mode retrieval.                      01920015
             perform idms-status.                                       01930015
                                                                        01940015
                                                                        01950015
       SECTION-EXIT.                                                    01960015
           EXIT.                                                        01970015
      *----------------------------------------------------------------*01980015
      *                                                                *01990015
      *                                                                *02000015
      *----------------------------------------------------------------*02010015
      *----------------------------------------------------------------*02020015
       1200-obtain-loadmod                 SECTION.                     02030015
      *----------------------------------------------------------------*02040015
       SECTION-ENTRY.                                                   02050015
           display '1200-obtain-loadmod jsonmap-name='                  02060015
             we-jsonMap-name.                                           02070015
           move we-jsonMap-name to loadhdr-modname-156.                 02080015
           obtain calc  loadhdr-156.                                    02090015
       do-while-loadhdr.                                                02100015
           IF DB-REC-NOT-FOUND                                          02110015
             GO TO SECTION-EXIT                                         02130015
           END-IF.                                                      02140015
           perform idms-status.                                         02150015
           display ' loadmod:' loadhdr-modname-156 ' v'                 02160015
                loadhdr-vers-156                                        02170015
           if loadhdr-vers-156 = 1                                      02180015
              move 1 to jsonmap-flag                                    02190015
              perform 2000-obtain-loadtext                              02200015
              if jsonmap-found                                          02210015
                 perform 3000-move-jsonschema                           02220015
              end-if;                                                   02230015
           end-if.                                                      02240015
           if loadhdr-vers-156 = 2                                      02250015
              move 1 to endpoint-flag                                   02260015
              perform 2000-obtain-loadtext                              02270015
              if endpoint-found                                         02280015
                 perform 4000-move-endpoint                             02290015
              end-if;                                                   02300015
           end-if.                                                      02310015
           obtain duplicate loadhdr-156                                 02320015
           go to do-while-loadhdr.                                      02330015
       SECTION-EXIT.                                                    02340015
           EXIT.                                                        02350015
      *----------------------------------------------------------------*02360015
       2000-obtain-loadtext                SECTION.                     02370015
      *----------------------------------------------------------------*02380015
       SECTION-ENTRY.                                                   02390015
           display '2000-obtain-loadtext.'.                             02400015
           obtain first loadtext-157 within loadhdr-loadtext            02410015
           if db-status-ok  and loadhdr-vers-156 = 1                    02420015
              if loadtext-157(1:8) not = w-jsonmap-signature            02430015
                 move 2 to jsonmap-flag                                 02440015
                 display  w-jsonmap-signature ' not found v1'           02441016
                 go to section-exit                                     02450015
             end-if;                                                    02460015
           end-if.                                                      02470015
                                                                        02480015
           if db-status-ok  and loadhdr-vers-156 = 2                    02490015
              if loadtext-157(1:8) not = w-endpoint-signature           02500015
                 move 2 to endpoint-flag                                02510015
                 display  w-jsonmap-signature ' not found v2'           02511016
                 go to section-exit                                     02520015
             end-if;                                                    02530015
           end-if.                                                      02540015
                                                                        02550015
           move 0 to w-row.                                             02560015
           move 1 to w-pos.                                             02570015
       DO-WHILE-loadtext.                                               02580015
           if db-end-of-set                                             02590015
              go to end-of-loadtext                                     02600015
           end-if.                                                      02610015
           perform idms-status.                                         02620015
           add 1 to w-row.                                              02630015
           move loadtext-157 to ws-buffer(w-row).                       02640015
      *    display 'w-row:' w-row                                       02650015
      *    move 128 to w-snap                                           02660015
      *                                                                 02670015
      *    if w-row < 3                                                 02680015
      *     STRING '  LOADtext-:'  DELIMITED BY ':'                     02690015
      *             w-row DELIMITED BY SIZE into w-title                02700015
      *     SNAP title w-title from loadtext-157 length w-snap          02710015
      *     STRING '  ws-buffer-:'  DELIMITED BY ':'                    02720015
      *             w-row DELIMITED BY SIZE into w-title                02730015
      *     SNAP title w-title from ws-buffer(w-row) length w-snap      02740015
      *    end-if.                                                      02750015
           add 512 to w-pos                                             02760015
           obtain next loadtext-157 within loadhdr-loadtext             02770015
           go to do-while-loadtext.                                     02780015
                                                                        02790015
       end-of-loadtext.                                                 02800015
            move w-pos to w-snap.                                       02810015
      *     move '  ws-buffer' to w-title.                              02820015
      *     SNAP title w-title from w-buffer length w-snap.             02830015
      *     move 300 to w-snap.                                         02840015
       SECTION-EXIT.                                                    02850015
           EXIT.                                                        02860015
      *----------------------------------------------------------------*02870015
      *                                                                *02880015
      *                                                                *02890015
      *----------------------------------------------------------------*02900015
       3000-move-jsonschema                SECTION.                     02910015
      *----------------------------------------------------------------*02920015
       SECTION-ENTRY.                                                   02930015
           display '3000-move-jsonschema ' w-hdr-len.                   02940015
           compute w-len = w-hdr-len.                                   02950015
           move w-buffer(1:w-len) to REC-HEADER.                        02960015
                                                                        02970015
           display 'sch move 1:' w-len ' ' jsonmap-name                 02980015
               ' reccnt ' rec-count ' ele-cnt ' sch-ele-count           02990015
               ' eleoffs' sch-ele-offset.                               03000015
                                                                        03010015
           compute w-pos = w-len + 1.                                   03020015
           compute w-len =  rec-count *  w-rec-len.                     03030015
                                                                        03040015
           move w-buffer(w-pos:w-len) to rec-info.                      03050015
                                                                        03060015
           compute w-spos = w-rec-len.                                  03070015
      *    display 'rec move ' w-pos ':' w-len ' recln:' w-spos.        03080015
                                                                        03090015
      *    compute w-pos = sch-ele-offset + 1.                          03100015
           compute w-pos = w-pos + w-len.                               03110015
           compute w-len = sch-ele-count *  w-ele-entry-len.            03120015
                                                                        03130015
      **   display 'ele move from ' w-pos  ' len ' w-len                03140015
      **     ' sch ele count:' sch-ele-count ' entry len:'              03150015
      **      w-ele-entry-len.                                          03160015
           move w-buffer(w-pos:w-len) to ele-info.                      03170015
                                                                        03180015
      **   display  ele-lvl(1) ':'                                      03190015
      **        ELE-ISGROUPELE (1)                                      03200015
      **        ELE-ISSEL4OUPUT (1)                                     03210015
      **        ELE-ISUPDATEABLE (1)                                    03220015
      **        ELE-ISJSONREQUIRED (1) ':' JSONFLD(1) ':'               03230015
      **        ELE-DTYPE (1) .                                         03240015
                                                                        03250015
      *     display 'endofsetup'.                                       03260015
                                                                        03270015
       SECTION-EXIT.                                                    03280015
           EXIT.                                                        03290015
   ****                                                                 03300015
   ****1200-obtain-loadmod                 SECTION.                     03310015
   ****----------------------------------------------------------------*03320015
   ****SECTION-ENTRY.                                                   03330015
   ****    display '1200-obtain-loadmod'.                               03340015
   ****                                                                 03350015
   ****    move we-jsonMap-name to loadhdr-modname-156.                 03360015
   ****    obtain calc  loadhdr-156.                                    03370015
   ****do-while-loadhdr.                                                03380015
   ****    IF DB-REC-NOT-FOUND                                          03390015
   ****      GO TO SECTION-EXIT                                         03400015
   ****    END-IF.                                                      03410015
   ****    perform idms-status.                                         03420015
   ****    display ' loadmod:' loadhdr-modname-156 ' v'                 03430015
   ****         loadhdr-vers-156                                        03440015
   ****    if loadhdr-vers-156 = 1                                      03450015
   ****       move 1 to jsonmap-flag                                    03460015
   ****       perform 2000-obtain-loadtext                              03470015
   ****       if jsonmap-found                                          03480015
   ****          perform 3000-move-jsonschema                           03490015
   ****       end-if;                                                   03500015
   ****    end-if.                                                      03510015
   ****    if loadhdr-vers-156 = 2                                      03520015
   ****       move 1 to endpoint-flag                                   03530015
   ****       perform 2000-obtain-loadtext                              03540015
   ****       if endpoint-found                                         03550015
   ****          perform 4000-move-endpoint                             03560015
   ****       end-if;                                                   03570015
   ****    end-if.                                                      03580015
   ****    obtain duplicate loadhdr-156.                                03590015
   ****    go to do-while-loadhdr.                                      03600015
   ****SECTION-EXIT.                                                    03610015
   ****    EXIT.                                                        03620015
   ****----------------------------------------------------------------*03630015
   ****2000-obtain-loadtext                SECTION.                     03640015
   ****----------------------------------------------------------------*03650015
   ****SECTION-ENTRY.                                                   03660015
   ****    display '2000-obtain-loadtext.'.                             03670015
   ****    obtain first loadtext-157 within loadhdr-loadtext.           03680015
   ****    if db-status-ok  and loadhdr-vers-156 = 1                    03690015
   ****       if loadtext-157(1:8) not = w-jsonmap-signature            03700015
   ****          move 2 to jsonmap-flag                                 03710015
   ****          go to section-exit                                     03720015
   ****      end-if;                                                    03730015
   ****    end-if.                                                      03740015
   ****                                                                 03750015
   ****    if db-status-ok  and loadhdr-vers-156 = 2                    03760015
   ****       if loadtext-157(1:8) not = w-endpoint-signature           03770015
   ****          move 2 to endpoint-flag                                03780015
   ****          go to section-exit                                     03790015
   ****      end-if;                                                    03800015
   ****    end-if.                                                      03810015
   ****    move 1 to w-pos.                                             03820015
   ****DO-WHILE-loadtext.                                               03830015
   ****    if db-end-of-set                                             03840015
   ****       go to section-exit                                        03850015
   ****    end-if.                                                      03860015
   ****    perform idms-status.                                         03870015
   ****    move loadtext-157 to ws-buffer(w-pos:512).                   03880015
   ****    add 512 to w-pos.                                            03890015
   ****    obtain next loadtext-157 within loadhdr-loadtext.            03900015
   ****    go to do-while-loadtext.                                     03910015
   ****                                                                 03920015
   ****SECTION-EXIT.                                                    03930015
   ****    EXIT.                                                        03940015
   ****----------------------------------------------------------------*03950015
   ****                                                                *03960015
   ****                                                                *03970015
   ****----------------------------------------------------------------*03980015
   ****3000-move-jsonschema                SECTION.                     03990015
   ****----------------------------------------------------------------*04000015
   ****SECTION-ENTRY.                                                   04010015
   ****    display '3000-move-jsonschema'.                              04020015
   ****    compute w-len = function length(REC-HEADER).                 04030015
   ****    move ws-buffer(1:w-len) to REC-HEADER.                       04040015
   ****                                                                 04050015
   ****    display 'sch move 1:' w-len ' ' jsonmap-name                 04060015
   ****        ' reccnt ' rec-count ' ele-cnt ' sch-ele-count           04070015
   ****        ' eleoffs' sch-ele-offset.                               04080015
   ****                                                                 04090015
   ****    compute w-pos = w-len + 1.                                   04100015
   ****    compute w-len =  rec-count *                                 04110015
   ****            Function Length( rec-entry(1) ).                     04120015
   ****    move ws-buffer(w-pos:w-len) to rec-info.                     04130015
   ****                                                                 04140015
   ****    compute w-spos = Function Length( rec-entry(1) ).            04150015
   ****    display 'rec move ' w-pos ':' w-len ' recln:' w-spos.        04160015
   ****                                                                 04170015
   ****    compute w-pos = w-pos + w-len.                               04180015
   ****    compute w-len = sch-ele-count *                              04190015
   ****            Function Length( ele-entry(1) ).                     04200015
   ****                                                                 04210015
   ****    display 'ele move from ' w-pos  ' len ' w-len  ':'           04220015
   ****       ws-buffer(w-pos: 64).                                     04230015
   ****                                                                 04240015
   ****    move ws-buffer(w-pos:w-len) to ele-info.                     04250015
   ****                                                                 04260015
   ****SECTION-EXIT.                                                    04270015
   ****    EXIT.                                                        04280015
      *----------------------------------------------------------------*04290015
      *                                                                *04300015
      *                                                                *04310015
      *----------------------------------------------------------------*04320015
       4000-move-endpoint                  SECTION.                     04330015
      *----------------------------------------------------------------*04340015
       SECTION-ENTRY.                                                   04350015
      *    display '4000-move-endpoint'.                                04360015
           compute w-len = Function Length(ispt-endpoint-definition).   04370015
           move w-buffer(1:w-len) to ispt-endpoint-definition.          04380015
       SECTION-EXIT.                                                    04390015
           EXIT.                                                        04400015
      *----------------------------------------------------------------*04410015
      *                                                                *04420015
      *                                                                *04430015
      *----------------------------------------------------------------*04440015
       9000-FINISH                         SECTION.                     04450015
      *----------------------------------------------------------------*04460015
       SECTION-ENTRY.                                                   04470015
      *    DISPLAY '       0300-FINISH'.                                04480015
           finish.                                                      04490015
       SECTION-EXIT.                                                    04500015
           EXIT.                                                        04510015
      *----------------------------------------------------------------*04520015
      *                                                                *04530015
      *                                                                *04540015
      *----------------------------------------------------------------*04550015
       copy idms idms-status.                                           04560015
      *----------------------------------------------------------------*04570015
       idms-abort                          SECTION.                     04580015
      *----------------------------------------------------------------*04590015
       SECTION-ENTRY.                                                   04600015
           DISPLAY ' idms aborting......'.                              04610015
                                                                        04620015
       SECTION-EXIT.                                                    04630015
           EXIT.                                                        04640015
      *----------------------------------------------------------------*04650015
       9999-DB-ERROR                       SECTION.                     04660015
      *----------------------------------------------------------------*04670015
       SECTION-ENTRY.                                                   04680015
           DISPLAY '       9999-DB-ERROR'.                              04690015
                                                                        04700015
           EXIT PROGRAM.                                                04710015
           STOP RUN.                                                    04720015
                                                                        04730015
                                                                        04740015
       SECTION-EXIT.                                                    04750015
           EXIT.                                                        04760015
