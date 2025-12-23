//ISPDCASM JOB 'JOHN','JOHN ABELL',CLASS=A,MSGCLASS=X,
//         NOTIFY=&SYSUID
//*
//*
//******************************************************************
//*   DESCRIPTION:                                                 *
//*                                                                *
//*                                                                *
//*   ASSEMBLE ISPTSRV, TCPREAD AND TCPWRITE ROUTINES              *
//******************************************************************
//*
//ASMRDR    EXEC HLASMCL
//C.SYSLIB  DD DISP=SHR,DSN=SYS1.MACLIB
//          DD DISP=SHR,DSN=SYS1.MODGEN
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.CUSTOM.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJMAC
//          DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB
//C.SYSIN   DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB(ISPTSRV)
//*
//******************************************************************
//*                                                                *
//*   LINK                                                         *
//*                                                                *
//******************************************************************
//*
//*
//L.IDMS    DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJLOAD
//L.SYSLMOD DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//L.SYSIN   DD *
 INCLUDE IDMS(IDMSIN01)
 ENTRY   TSERVEP1
 NAME    ISPTSRV(R)
/*
//ASMRDR    EXEC HLASMCL
//C.SYSLIB  DD DISP=SHR,DSN=SYS1.MACLIB
//          DD DISP=SHR,DSN=SYS1.MODGEN
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.CUSTOM.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJMAC
//          DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB
//C.SYSIN   DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB(ISPTRDR)
//*
//******************************************************************
//*                                                                *
//*   LINK                                                         *
//*                                                                *
//******************************************************************
//*
//*
//L.IDMS    DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJLOAD
//L.SYSLMOD DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//L.SYSIN   DD *
 INCLUDE IDMS(IDMSIN01)
 ENTRY   TRDREP01
 NAME    ISPTRDR(R)
/*
//*
//*   ASSEMBLE TCPWRITE
//*
//*
//*
//ASMWRTR   EXEC HLASMCL
//C.SYSLIB  DD DISP=SHR,DSN=SYS1.MACLIB
//          DD DISP=SHR,DSN=SYS1.MODGEN
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.CUSTOM.LOADLIB
//          DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJMAC
//          DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB
//C.SYSIN   DD DISP=SHR,DSN=ISPDC.TEST.SRCLIB(ISPTWTR)
//*
//******************************************************************
//*                                                                *
//*   LINK                                                         *
//*                                                                *
//******************************************************************
//*
//*
//L.IDMS    DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.RT.CAGJLOAD
//L.SYSLMOD DD DISP=SHR,DSN=ISPLG.IDMS.R190.Z211.DBA.LOADLIB
//L.SYSIN   DD *
 INCLUDE IDMS(IDMSIN01)
 ENTRY   TWTREP01
 NAME    ISPTWTR(R)
/*
//
