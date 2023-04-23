//ALLCDS JOB CLASS=A,MSGCLASS=X,MSGLEVEL=(1,1)
//*********************************************************************
//*
//ALLOCTGT PROC HLQ=,
//            VOL=,
//            DSP=
//*
//ALLOC    EXEC PGM=IEFBR14
//JCL      DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,
//            RECFM=FB,
//            LRECL=80,
//            BLKSIZE=32720,
//            DSN=&HLQ..JCL
//*
//COBSRC   DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,
//            RECFM=FB,
//            LRECL=80,
//            BLKSIZE=32720,
//            DSN=&HLQ..COBOL.SOURCE
//*
//COBCOPY  DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,
//            RECFM=FB,
//            LRECL=80,
//            BLKSIZE=32720,
//            DSN=&HLQ..COBOL.COPYLIB
//*
//COBOBJ   DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,
//            RECFM=FB,
//            LRECL=80,
//            BLKSIZE=32720,
//            DSN=&HLQ..COBOL.OBJ
//*
//COBOUT   DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,
//            RECFM=FB,
//            LRECL=133,
//            BLKSIZE=32718,
//            DSN=&HLQ..COBOL.OUTPUT
//*
//COBSDEB  DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,
//            RECFM=FB,
//            LRECL=1024,
//            BLKSIZE=31744,
//            DSN=&HLQ..COBOL.SYSDEBUG
//*
//LOAD     DD SPACE=(TRK,(15,5,5)),
//            UNIT=3390,
//            VOL=SER=&VOL,
//            DISP=(NEW,&DSP),
//            DSNTYPE=LIBRARY,       
//            RECFM=U,
//            LRECL=0,
//            BLKSIZE=32760,
//            DSN=&HLQ..LOAD
//*
//EALLOCT  PEND
//*
//*  The following steps execute the PROCs to allocate the data sets.
//*
//ALLOCT   EXEC ALLOCTGT,     * Allocate Libraries
//            HLQ=@HLQ@,
//            VOL=@VOL@,
//            DSP=CATLG
//*