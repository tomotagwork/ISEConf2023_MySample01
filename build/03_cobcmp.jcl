//COBCMP  JOB ,NOTIFY=&SYSUID,
// MSGCLASS=H,MSGLEVEL=(1,1),REGION=0M
//*****************************************************************
//    SET HLQ='@HLQ@'                       *HLQ
//    SET CMPLLIB='@CompLibrary@'           *COMPILER LIBRARY
//    SET LINKLIB='@LinkLibrary@'              *LINK LIBRARY
//    SET SPACE1='SYSALLDA,SPACE=(CYL,(1,1))' *SPACE ALLOCATION
//    SET SPACE2='SYSALLDA,SPACE=(CYL,(1,1))' *SPACE ALLOCATION
//*
//***************************
//*                         *
//*  COMPILE               **
//*                         *
//***************************
//*
//CMP      EXEC PGM=IGYCRCTL,PARM='LIST,MAP,LIB'
//STEPLIB  DD DISP=SHR,DSN=&CMPLLIB
//SYSIN    DD DISP=SHR,DSN=&HLQ..COBOL.SOURCE(@ProgName@)
//SYSLIB   DD DISP=SHR,DSN=&HLQ..COBOL.COPYLIB
//SYSLIN   DD DISP=SHR,DSN=&HLQ..COBOL.OBJ(@ProgName@)
//SYSPRINT DD DISP=SHR,DSN=&HLQ..COBOL.OUTPUT(@ProgName@)
//*SYSPRINT DD SYSOUT=*
//SYSMDECK DD UNIT=&SPACE1
//SYSUT1   DD UNIT=&SPACE1
//SYSUT2   DD UNIT=&SPACE1
//SYSUT3   DD UNIT=&SPACE1
//SYSUT4   DD UNIT=&SPACE1
//SYSUT5   DD UNIT=&SPACE1
//SYSUT6   DD UNIT=&SPACE1
//SYSUT7   DD UNIT=&SPACE1
//SYSUT8   DD UNIT=&SPACE1
//SYSUT9   DD UNIT=&SPACE1
//SYSUT10  DD UNIT=&SPACE1
//SYSUT11  DD UNIT=&SPACE1
//SYSUT12  DD UNIT=&SPACE1
//SYSUT13  DD UNIT=&SPACE1
//SYSUT14  DD UNIT=&SPACE1
//SYSUT15  DD UNIT=&SPACE1
//*
//***************************
//*                         *
//*  LINK                   *
//*                         *
//***************************
//*
//LINK     EXEC PGM=IEWL,REGION=3000K
//SYSLMOD  DD  DISP=SHR,DSN=&HLQ..LOAD
//SYSPRINT DD  SYSOUT=*
//SYSUT1   DD  UNIT=&SPACE2
//SYSLIB   DD  DISP=SHR,DSN=&LINKLIB
//         DD  DISP=SHR,DSN=&HLQ..LOAD
//OBJ      DD  DISP=SHR,DSN=&HLQ..COBOL.OBJ
//SYSLIN   DD *
     INCLUDE OBJ(@ProgName@)
     ENTRY @ProgName@
     NAME @ProgName@(R)
/*
