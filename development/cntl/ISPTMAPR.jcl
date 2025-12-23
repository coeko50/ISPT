//ISPDCVEC JOB 'JOHN','JOHN ABELL',CLASS=A,MSGCLASS=X,
//         NOTIFY=&SYSUID
//*
//*
//******************************************************************
//*   DESCRIPTION:                                                 *
//*                                                                *
//*                                                                *
//*   ASSEMBLE ISPTMAPR & ISPTVECT                                 *
//******************************************************************
//*
//ASMRDR    EXEC HLASMCL
//C.SYSLIB  DD DISP=SHR,DSN=SYS1.MACLIB
//          DD DISP=SHR,DSN=SYS1.MODGEN
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.CUSTOM.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJMAC
//          DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB
//C.SYSIN   DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB(ISPTMAPR)
//*
//******************************************************************
//*                                                                *
//*   LINK                                                         *
//*                                                                *
//******************************************************************
//*
//*
//L.SYSLMOD DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//L.SYSIN   DD *
 ENTRY   TMAPREP1
 NAME    ISPTMAPR(R)
/*
//*
//ASMRDR    EXEC HLASMCL
//C.SYSLIB  DD DISP=SHR,DSN=SYS1.MACLIB
//          DD DISP=SHR,DSN=SYS1.MODGEN
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.CUSTOM.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJMAC
//          DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB
//C.SYSIN   DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB(ISPTVECT)
//*
//******************************************************************
//*                                                                *
//*   LINK                                                         *
//*                                                                *
//******************************************************************
//*
//*
//L.SYSLMOD DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//L.SYSIN   DD *
 ENTRY   TVECTEP1
 NAME    ISPTVECT(R)
/*
