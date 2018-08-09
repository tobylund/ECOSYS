
      SUBROUTINE hfunc(I,J,NHW,NHE,NVN,NVS)
C
C     THIS SUBROUTINE CALCULATES PLANT PHENOLOGY
C
      include "parameters.h"
      include "filec.h"
      include "files.h"
      include "blkc.h"
      include "blk1cp.h"
      include "blk1cr.h"
      include "blk1g.h"
      include "blk1n.h"
      include "blk1p.h"
      include "blk2a.h"
      include "blk2b.h"
      include "blk2c.h"
      include "blk3.h"
      include "blk8a.h"
      include "blk8b.h"
      include "blk9a.h"
      include "blk9b.h"
      include "blk9c.h"
      include "blk11a.h"
      include "blk11b.h"
      include "blk12a.h"
      include "blk12b.h"
      include "blk16.h"
      include "blk18a.h"
      include "blk18b.h"
      DIMENSION NBX(0:3),PSILY(0:2),FLG4Y(0:3)
      CHARACTER*16 DATA(30),DATAC(30,250,250),DATAP(JP,JY,JX)
     2,DATAM(JP,JY,JX),DATAX(JP),DATAY(JP),DATAZ(JP,JY,JX)
     3,OUTS(10),OUTP(10),OUTFILS(10,JY,JX),OUTFILP(10,JP,JY,JX)
      CHARACTER*3 CHOICE(102,20)
      CHARACTER*8 CDATE
      PARAMETER (PSILM=0.1,PSILX=-0.2)
      PARAMETER(GSTGG=2.00,GSTGR=0.667,FVRN=0.5,VRNE=3600.0)
      DATA PSILY/-200.0,-2.0,-2.0/
      DATA FLG4Y/336.0,672.0,672.0,672.0/
      DATA NBX /5,1,1,1/
      DO 9995 NX=NHW,NHE
      DO 9990 NY=NVN,NVS
      DO 9985 NZ=1,NP(NY,NX)
C     WRITE(*,4444)'IFLGC',I,NX,NY,NZ,DATAP(NZ,NY,NX),IFLGT(NY,NX)
C    2,IDAY0(NZ,NY,NX),IDAYH(NZ,NY,NX),IYRC,IYRH(NZ,NY,NX)
C    3,IDTH(NZ,NY,NX),IYR0(NZ,NY,NX),IFLGC(NZ,NY,NX)
4444  FORMAT(A8,4I8,A16,20I8)
      IF(DATAP(NZ,NY,NX).NE.'NO')THEN
      PPT(NY,NX)=PPT(NY,NX)+PP(NZ,NY,NX)
C
C     SET CROP FLAG ACCORDING TO PLANTING, HARVEST DATES, DEATH,
C     1 = ALIVE, 0 = NOT ALIVE
C
      IF(J.EQ.1)THEN
      IF(IDAY0(NZ,NY,NX).LE.IDAYH(NZ,NY,NX)
     3.OR.IYR0(NZ,NY,NX).LT.IYRH(NZ,NY,NX))THEN
      IF(I.GE.IDAY0(NZ,NY,NX).OR.IDATA(3).GT.IYR0(NZ,NY,NX))THEN
      IF(I.GT.IDAYH(NZ,NY,NX).AND.IYRC.GE.IYRH(NZ,NY,NX)
     2.AND.IDTH(NZ,NY,NX).EQ.1)THEN
      IFLGC(NZ,NY,NX)=0
      ELSE
      IF(I.EQ.IDAY0(NZ,NY,NX).AND.IDATA(3).EQ.IYR0(NZ,NY,NX))THEN
      IFLGC(NZ,NY,NX)=0
      IDTH(NZ,NY,NX)=0
      CALL STARTQ(NX,NX,NY,NY,NZ,NZ)
      TNBP(NY,NX)=TNBP(NY,NX)+WTRVX(NZ,NY,NX)
      ENDIF
      IF(DATAP(NZ,NY,NX).NE.'NO'.AND.IDTH(NZ,NY,NX).EQ.0)
     2IFLGC(NZ,NY,NX)=1
      ENDIF
      ELSE
      IFLGC(NZ,NY,NX)=0
      ENDIF
      ELSE
      IF((I.LT.IDAY0(NZ,NY,NX).AND.I.GT.IDAYH(NZ,NY,NX) 
     2.AND.IYRC.GE.IYRH(NZ,NY,NX).AND.IDTH(NZ,NY,NX).EQ.1)
     3.OR.(I.LT.IDAY0(NZ,NY,NX).AND.IYR0(NZ,NY,NX)
     4.GT.IYRH(NZ,NY,NX)))THEN
      IFLGC(NZ,NY,NX)=0
      ELSE
      IF(I.EQ.IDAY0(NZ,NY,NX).AND.IDATA(3).EQ.IYR0(NZ,NY,NX))THEN
      IFLGC(NZ,NY,NX)=0
      IDTH(NZ,NY,NX)=0
      CALL STARTQ(NX,NX,NY,NY,NZ,NZ)
      TNBP(NY,NX)=TNBP(NY,NX)+WTRVX(NZ,NY,NX)
      ENDIF
      IF(DATAP(NZ,NY,NX).NE.'NO'.AND.IDTH(NZ,NY,NX).EQ.0)
     2IFLGC(NZ,NY,NX)=1
      ENDIF
      ENDIF
      IFLGT(NY,NX)=IFLGT(NY,NX)+IFLGC(NZ,NY,NX)
      ENDIF
      IF(IFLGC(NZ,NY,NX).EQ.1)THEN
      RCO2Z(NZ,NY,NX)=0.0
      ROXYZ(NZ,NY,NX)=0.0
      RCH4Z(NZ,NY,NX)=0.0
      RN2OZ(NZ,NY,NX)=0.0
      RNH3Z(NZ,NY,NX)=0.0
      RH2GZ(NZ,NY,NX)=0.0
      CPOOLP(NZ,NY,NX)=0.0
      ZPOOLP(NZ,NY,NX)=0.0
      PPOOLP(NZ,NY,NX)=0.0
      NI(NZ,NY,NX)=NIX(NZ,NY,NX)
      NG(NZ,NY,NX)=MIN(NI(NZ,NY,NX),MAX(NG(NZ,NY,NX),NU(NY,NX)))
      NB1(NZ,NY,NX)=1
      NBTX=1.0E+06
C
C     TOTAL PLANT NON-STRUCTURAL C, N, P
C
      DO 140 NB=1,NBR(NZ,NY,NX)
      IF(IDTHB(NB,NZ,NY,NX).EQ.0)THEN
      CPOOLP(NZ,NY,NX)=CPOOLP(NZ,NY,NX)+CPOOL(NB,NZ,NY,NX)
      ZPOOLP(NZ,NY,NX)=ZPOOLP(NZ,NY,NX)+ZPOOL(NB,NZ,NY,NX)
      PPOOLP(NZ,NY,NX)=PPOOLP(NZ,NY,NX)+PPOOL(NB,NZ,NY,NX)
      CPOLNP(NZ,NY,NX)=CPOLNP(NZ,NY,NX)+CPOLNB(NB,NZ,NY,NX)
      ZPOLNP(NZ,NY,NX)=ZPOLNP(NZ,NY,NX)+ZPOLNB(NB,NZ,NY,NX)
      PPOLNP(NZ,NY,NX)=PPOLNP(NZ,NY,NX)+PPOLNB(NB,NZ,NY,NX)
      IF(NBTB(NB,NZ,NY,NX).LT.NBTX)THEN
      NB1(NZ,NY,NX)=NB
      NBTX=NBTB(NB,NZ,NY,NX)
      ENDIF
      ENDIF
140   CONTINUE
C
C     NON-STRUCTURAL C, N, P CONCENTRATIONS IN ROOT
C
      DO 180 N=1,MY(NZ,NY,NX)
      DO 160 L=NU(NY,NX),NI(NZ,NY,NX)
      IF(WTRTL(N,L,NZ,NY,NX).GT.ZEROL(NZ,NY,NX))THEN
      CCPOLR(N,L,NZ,NY,NX)=AMAX1(0.0,CPOOLR(N,L,NZ,NY,NX)
     2/WTRTL(N,L,NZ,NY,NX))
      CZPOLR(N,L,NZ,NY,NX)=AMAX1(0.0,ZPOOLR(N,L,NZ,NY,NX)
     2/WTRTL(N,L,NZ,NY,NX))
      CPPOLR(N,L,NZ,NY,NX)=AMAX1(0.0,PPOOLR(N,L,NZ,NY,NX)
     2/WTRTL(N,L,NZ,NY,NX))
C     CCPOLR(N,L,NZ,NY,NX)=AMIN1(1.0,CCPOLR(N,L,NZ,NY,NX))
      ELSE
      CCPOLR(N,L,NZ,NY,NX)=1.0
      CZPOLR(N,L,NZ,NY,NX)=1.0
      CPPOLR(N,L,NZ,NY,NX)=1.0
      ENDIF
160   CONTINUE
180   CONTINUE
C
C     NON-STRUCTURAL C, N, P CONCENTRATIONS IN SHOOT
C
      IF(WTLS(NZ,NY,NX).GT.ZEROL(NZ,NY,NX))THEN
      CCPOLP(NZ,NY,NX)=AMAX1(0.0,AMIN1(1.0,CPOOLP(NZ,NY,NX)
     2/WTLS(NZ,NY,NX)))
      CCPLNP(NZ,NY,NX)=AMAX1(0.0,AMIN1(1.0,CPOLNP(NZ,NY,NX)
     2/WTLS(NZ,NY,NX)))
      CZPOLP(NZ,NY,NX)=AMAX1(0.0,AMIN1(1.0,ZPOOLP(NZ,NY,NX)
     2/WTLS(NZ,NY,NX)))
      CPPOLP(NZ,NY,NX)=AMAX1(0.0,AMIN1(1.0,PPOOLP(NZ,NY,NX)
     2/WTLS(NZ,NY,NX)))
      ELSE
      CCPOLP(NZ,NY,NX)=1.0
      CCPLNP(NZ,NY,NX)=1.0
      CZPOLP(NZ,NY,NX)=1.0
      CPPOLP(NZ,NY,NX)=1.0
      ENDIF
      DO 190 NB=1,NBR(NZ,NY,NX)
      IF(WTLSB(NB,NZ,NY,NX).GT.ZEROP(NZ,NY,NX))THEN
      CCPOLB(NB,NZ,NY,NX)=AMAX1(0.0,CPOOL(NB,NZ,NY,NX)
     2/WTLSB(NB,NZ,NY,NX))
      CZPOLB(NB,NZ,NY,NX)=AMAX1(0.0,ZPOOL(NB,NZ,NY,NX)
     2/WTLSB(NB,NZ,NY,NX))
      CPPOLB(NB,NZ,NY,NX)=AMAX1(0.0,PPOOL(NB,NZ,NY,NX)
     2/WTLSB(NB,NZ,NY,NX))
      ELSE
      CCPOLB(NB,NZ,NY,NX)=1.0
      CZPOLB(NB,NZ,NY,NX)=1.0
      CPPOLB(NB,NZ,NY,NX)=1.0
      ENDIF
190   CONTINUE
C
C     EMERGENCE DATE FROM COTYLEDON HEIGHT, LEAF AREA, ROOT DEPTH
C
      IF(IDAY(1,NB1(NZ,NY,NX),NZ,NY,NX).EQ.0)THEN
      ARLSP=ARLFP(NZ,NY,NX)+ARSTP(NZ,NY,NX)
      IF((HTCTL(NZ,NY,NX).GT.SDPTH(NZ,NY,NX))
     2.AND.(ARLSP.GT.ZEROL(NZ,NY,NX))
     3.AND.(RTDP1(1,1,NZ,NY,NX).GT.SDPTH(NZ,NY,NX)+1.0E-06))THEN
      IDAY(1,NB1(NZ,NY,NX),NZ,NY,NX)=I
      VHCPC(NZ,NY,NX)=4.19*(WTSHT(NZ,NY,NX)*10.0E-06+VOLWC(NZ,NY,NX))
      ENDIF
      ENDIF
C
C     ADD BRANCH TO SHOOT IF PLANT GROWTH STAGE, SHOOT NON-STRUCTURAL C
C     CONCENTRATION PERMIT
C
C     WRITE(*,224)'HFUNC',I,J,IFLGI(NZ,NY,NX),PP(NZ,NY,NX)
C    2,TCG(NZ,NY,NX),PSIRG(1,NG(NZ,NY,NX),NZ,NY,NX)
C    3,PSILM,ISTYP(NZ,NY,NX),IDAY(2,NB1(NZ,NY,NX),NZ,NY,NX)
C    4,NBR(NZ,NY,NX),WTRVC(NZ,NY,NX),CCPOLP(NZ,NY,NX)
C    5,PB(NZ,NY,NX),IDTHB(NB,NZ,NY,NX),NB1(NZ,NY,NX)
C    6,PSTG(NB1(NZ,NY,NX),NZ,NY,NX),NBT(NZ,NY,NX)
C    7,NNOD(NZ,NY,NX),FNOD(NZ,NY,NX),XTLI(NZ,NY,NX)
224   FORMAT(A8,3I6,5E12.4,3I6,3E12.4,2I6,1E12.4,2I6,2E12.4)
      IF(IFLGI(NZ,NY,NX).EQ.0)THEN
      IF(J.EQ.1.AND.PP(NZ,NY,NX).GT.0.0)THEN
      IF(PSIRG(1,NG(NZ,NY,NX),NZ,NY,NX).GT.PSILM)THEN
      IF(ISTYP(NZ,NY,NX).NE.0
     2.OR.IDAY(2,NB1(NZ,NY,NX),NZ,NY,NX).EQ.0)THEN
      IF((NBR(NZ,NY,NX).EQ.0.AND.WTRVC(NZ,NY,NX).GT.0.0)
     2.OR.(CCPOLP(NZ,NY,NX).GT.PB(NZ,NY,NX)
     3.AND.PB(NZ,NY,NX).GT.0.0))THEN
      DO 120 NB=1,10
      IF(IDTHB(NB,NZ,NY,NX).EQ.1)THEN
      IF(NB.EQ.NB1(NZ,NY,NX)
     2.OR.PSTG(NB1(NZ,NY,NX),NZ,NY,NX).GT.NBT(NZ,NY,NX)
     2+NNOD(NZ,NY,NX)/FNOD(NZ,NY,NX)+XTLI(NZ,NY,NX))THEN
      NBT(NZ,NY,NX)=NBT(NZ,NY,NX)+1
      NBR(NZ,NY,NX)=MIN(NBX(IBTYP(NZ,NY,NX)),MAX(NB,NBR(NZ,NY,NX)))
      NBTB(NB,NZ,NY,NX)=NBT(NZ,NY,NX)-1
      IDTHP(NZ,NY,NX)=0
      IDTHB(NB,NZ,NY,NX)=0
      VRNS(NB,NZ,NY,NX)=VRNL(NB,NZ,NY,NX)+0.5
      IF(ISTYP(NZ,NY,NX).EQ.0)THEN
      GROUP(NB,NZ,NY,NX)=AMAX1(0.0,GROUPI(NZ,NY,NX)-NBTB(NB,NZ,NY,NX))
      ELSE
      GROUP(NB,NZ,NY,NX)=GROUPI(NZ,NY,NX)
      ENDIF
      GO TO 125
      ENDIF
      ENDIF
120   CONTINUE
125   CONTINUE
      ENDIF
      ENDIF
      ENDIF
C
C     ADD AXIS TO ROOT IF PLANT GROWTH STAGE, ROOT NON-STRUCTURAL C
C     CONCENTRATION PERMIT
C
      IF(PSIRG(1,NG(NZ,NY,NX),NZ,NY,NX).GT.PSILM)THEN
      IF(NRT(NZ,NY,NX).EQ.0.OR.PSTG(NB1(NZ,NY,NX),NZ,NY,NX)
     2.GT.NRT(NZ,NY,NX)/FNOD(NZ,NY,NX)+XTLI(NZ,NY,NX))THEN
      IF((NRT(NZ,NY,NX).EQ.0.AND.WTRVC(NZ,NY,NX).GT.0.0)
     2.OR.(CCPOLP(NZ,NY,NX).GT.PR(NZ,NY,NX)
     3.AND.PR(NZ,NY,NX).GT.0.0))THEN
      NRT(NZ,NY,NX)=MIN(10,NRT(NZ,NY,NX)+1)
      IDTHR(NZ,NY,NX)=0
      ENDIF
      ENDIF
      ENDIF
      ENDIF
      ENDIF
C
C     THE REST OF THE SUBROUTINE MODELS THE PHENOLOGY OF EACH BRANCH
C
      IF(IDAY(1,NB1(NZ,NY,NX),NZ,NY,NX).NE.0
     2.OR.IFLGI(NZ,NY,NX).EQ.1)THEN
      DO 2010 NB=1,NBR(NZ,NY,NX)
      IF(IDTHB(NB,NZ,NY,NX).EQ.0)THEN
      IF(IDAY(1,NB,NZ,NY,NX).EQ.0)THEN
      IDAY(1,NB,NZ,NY,NX)=I
      ENDIF
C
C     CALCULATE NODE INITIATION AND LEAF APPEARANCE RATES
C     FROM TEMPERATURE FUNCTION CALCULATED IN 'UPTAKE' AND
C     RATES AT 25C ENTERED IN 'READQ' EXCEPT WHEN DORMANT
C
      IF(IWTYP(NZ,NY,NX).EQ.0
     2.OR.VRNF(NB,NZ,NY,NX).LT.VRNX(NB,NZ,NY,NX))THEN
      TKCO=TKG(NZ,NY,NX)+OFFST(NZ,NY,NX)
      RTK=8.3143*TKCO
      STK=710.0*TKCO
      ACTV=1+EXP((197500-STK)/RTK)+EXP((STK-222500)/RTK)
      TFNP=EXP(25.229-62500/RTK)/ACTV
      RNI=AMAX1(0.0,TFNP*XRNI(NZ,NY,NX))
      RLA=AMAX1(0.0,TFNP*XRLA(NZ,NY,NX))
C
C     NODE INITIATION AND LEAF APPEARANCE RATES SLOWED BY LOW TURGOR
C
      IF(ISTYP(NZ,NY,NX).EQ.0.AND.IDAY(6,NB,NZ,NY,NX).EQ.0)THEN
      WFNS=AMIN1(1.0,AMAX1(0.0,PSILG(NZ,NY,NX)-PSILM))
      WFNSP=WFNS**0.25
      RNI=RNI*WFNSP
      RLA=RLA*WFNSP
      ENDIF
C
C     ACCUMULATE NODE INITIATION AND LEAF APPEARANCE RATES
C     INTO TOTAL NUMBER OF NODES AND LEAVES
C
      PSTG(NB,NZ,NY,NX)=PSTG(NB,NZ,NY,NX)+RNI
      VSTG(NB,NZ,NY,NX)=VSTG(NB,NZ,NY,NX)+RLA
C
C     USE TOTAL NUMBER OF NODES TO CALCULATE PROGRESSION THROUGH
C     VEGETATIVE AND REPRODUCTIVE GROWTH STAGES. THIS PROGRESSION
C     IS USED TO SET START AND END DATES FOR GROWTH STAGES BELOW
C
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)THEN
      GSTGI(NB,NZ,NY,NX)=(PSTG(NB,NZ,NY,NX)-PSTGI(NB,NZ,NY,NX))
     2/GROUPI(NZ,NY,NX)
      DGSTGI(NB,NZ,NY,NX)=RNI/(GROUPI(NZ,NY,NX)*GSTGG)
      TGSTGI(NB,NZ,NY,NX)=TGSTGI(NB,NZ,NY,NX)+DGSTGI(NB,NZ,NY,NX)
      ENDIF
      IF(IDAY(6,NB,NZ,NY,NX).NE.0)THEN
      GSTGF(NB,NZ,NY,NX)=(PSTG(NB,NZ,NY,NX)-PSTGF(NB,NZ,NY,NX))
     2/GROUPI(NZ,NY,NX)
      DGSTGF(NB,NZ,NY,NX)=RNI/(GROUPI(NZ,NY,NX)*GSTGR)
      TGSTGF(NB,NZ,NY,NX)=TGSTGF(NB,NZ,NY,NX)+DGSTGF(NB,NZ,NY,NX)
      ENDIF
      IFLGG(NB,NZ,NY,NX)=1
      ELSE
      IFLGG(NB,NZ,NY,NX)=0
      ENDIF
C
C     REPRODUCTIVE GROWTH STAGES ADVANCE WHEN THRESHOLD NUMBER
C     OF NODES HAVE BEEN INITIATED. FIRST DETERMINE PHOTOPERIOD
C     AND TEMPERATURE EFFECTS ON FINAL VEG NODE NUMBER FROM
C     NUMBER OF INITIATED NODES
C
      IF(IDAY(2,NB,NZ,NY,NX).EQ.0)THEN
      IF(PSTG(NB,NZ,NY,NX).GT.GROUP(NB,NZ,NY,NX)
     2+PSTGI(NB,NZ,NY,NX).AND.VRNS(NB,NZ,NY,NX)
     2.GE.VRNL(NB,NZ,NY,NX))THEN
C
C     FINAL VEGETATIVE NODE NUMBER DEPENDS ON PHOTOPERIOD FROM 'DAY'
C     AND ON MATURITY GROUP, CRITICAL PHOTOPERIOD AND PHOTOPERIOD
C     SENSITIVITY ENTERED IN 'READQ'
C
      IF(IPTYP(NZ,NY,NX).EQ.0)THEN
      PPD=0.0
      ELSE
      PPD=AMAX1(0.0,XDL(NZ,NY,NX)-DYLN(NY,NX))
      IF(IPTYP(NZ,NY,NX).EQ.1.AND.DYLN(NY,NX).GE.DYLX(NY,NX))PPD=0.0
      ENDIF
C     WRITE(*,333)'IDAY2',I,J,NZ,NB,IDAY(2,NB,NZ,NY,NX)
C    2,PPD,XDL(NZ,NY,NX),DYLN(NY,NX),DYLX(NY,NX),VRNS(NB,NZ,NY,NX)
C    3,VRNL(NB,NZ,NY,NX),PSTG(NB,NZ,NY,NX),GROUP(NB,NZ,NY,NX)
C    4,PSTGI(NB,NZ,NY,NX),XPPD(NZ,NY,NX)
333   FORMAT(A8,5I4,20E12.4)
      IF(IPTYP(NZ,NY,NX).EQ.0
     2.OR.(IPTYP(NZ,NY,NX).EQ.1.AND.PPD.GT.XPPD(NZ,NY,NX))
     3.OR.(IPTYP(NZ,NY,NX).EQ.2.AND.PPD.LT.XPPD(NZ,NY,NX))
     4.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     5.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     6.AND.DYLN(NY,NX).LT.DYLX(NY,NX)))THEN
      IF(IWTYP(NZ,NY,NX).EQ.0.OR.IPTYP(NZ,NY,NX).EQ.0
     2.OR.(IPTYP(NZ,NY,NX).EQ.1.AND.DYLN(NY,NX).LE.DYLX(NY,NX))
     3.OR.(IPTYP(NZ,NY,NX).EQ.2.AND.DYLN(NY,NX).GE.DYLX(NY,NX))
     4.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     5.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     6.AND.DYLN(NY,NX).LT.DYLX(NY,NX)))THEN
      IDAY(2,NB,NZ,NY,NX)=I
      PSTGI(NB,NZ,NY,NX)=PSTG(NB,NZ,NY,NX)
      IF(ISTYP(NZ,NY,NX).EQ.0.AND.IDTYP(NZ,NY,NX).EQ.0)THEN
      VSTGX(NB,NZ,NY,NX)=PSTG(NB,NZ,NY,NX)
      ENDIF
      ENDIF
      ENDIF
      ENDIF
C
C     STEM ELONGATION
C
      ELSEIF(IDAY(3,NB,NZ,NY,NX).EQ.0)THEN
      IF(GSTGI(NB,NZ,NY,NX).GT.0.25*GSTGG
     2.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     3.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     3.AND.DYLN(NY,NX).LT.DYLX(NY,NX).AND.IFLGE(NB,NZ,NY,NX).EQ.1
     4.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))
     5.OR.(IWTYP(NZ,NY,NX).EQ.2.AND.ISTYP(NZ,NY,NX).EQ.0)
     6.AND.IFLGE(NB,NZ,NY,NX).EQ.1
     7.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))THEN
      IDAY(3,NB,NZ,NY,NX)=I
      ENDIF
      ELSEIF(IDAY(4,NB,NZ,NY,NX).EQ.0)THEN
      IF(GSTGI(NB,NZ,NY,NX).GT.0.50*GSTGG
     2.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     3.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     3.AND.DYLN(NY,NX).LT.DYLX(NY,NX).AND.IFLGE(NB,NZ,NY,NX).EQ.1
     4.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))
     5.OR.(IWTYP(NZ,NY,NX).EQ.2.AND.ISTYP(NZ,NY,NX).EQ.0)
     6.AND.IFLGE(NB,NZ,NY,NX).EQ.1
     7.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))THEN
      IDAY(4,NB,NZ,NY,NX)=I
      IF(ISTYP(NZ,NY,NX).EQ.0.AND.IDTYP(NZ,NY,NX).NE.0)THEN
      VSTGX(NB,NZ,NY,NX)=PSTG(NB,NZ,NY,NX)
      ENDIF
      ENDIF
      ELSEIF(IDAY(5,NB,NZ,NY,NX).EQ.0)THEN
      IF(GSTGI(NB,NZ,NY,NX).GT.1.00*GSTGG
     2.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     3.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     3.AND.DYLN(NY,NX).LT.DYLX(NY,NX).AND.IFLGE(NB,NZ,NY,NX).EQ.1
     4.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))
     5.OR.(IWTYP(NZ,NY,NX).EQ.2.AND.ISTYP(NZ,NY,NX).EQ.0)
     6.AND.IFLGE(NB,NZ,NY,NX).EQ.1
     7.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))THEN
      IDAY(5,NB,NZ,NY,NX)=I
      ENDIF
C
C     ANTHESIS OCCURS WHEN THE NUMBER OF LEAVES THAT HAVE APPEARED
C     EQUALS THE NUMBER OF NODES INITIATED WHEN THE FINAL VEGETATIVE
C     NODE NUMBER WAS SET ABOVE
C
      ELSEIF(IDAY(6,NB,NZ,NY,NX).EQ.0)THEN
      IF((ISTYP(NZ,NY,NX).EQ.0.AND.VSTG(NB,NZ,NY,NX)
     2.GT.PSTGI(NB,NZ,NY,NX)).OR.(ISTYP(NZ,NY,NX).NE.0
     3.AND.IDAY(5,NB,NZ,NY,NX).NE.0)
     2.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     3.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     3.AND.DYLN(NY,NX).LT.DYLX(NY,NX).AND.IFLGE(NB,NZ,NY,NX).EQ.1
     4.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))
     5.OR.(IWTYP(NZ,NY,NX).EQ.2.AND.ISTYP(NZ,NY,NX).EQ.0)
     6.AND.IFLGE(NB,NZ,NY,NX).EQ.1
     7.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))THEN
      IF(NB.EQ.NB1(NZ,NY,NX)
     2.OR.IDAY(6,NB1(NZ,NY,NX),NZ,NY,NX).NE.0)THEN
      IDAY(6,NB,NZ,NY,NX)=I
      PSTGF(NB,NZ,NY,NX)=PSTG(NB,NZ,NY,NX)
      ENDIF
      ENDIF
C
C     START GRAIN FILL PERIOD
C
      ELSEIF(IDAY(7,NB,NZ,NY,NX).EQ.0)THEN
      IF(GSTGF(NB,NZ,NY,NX).GT.0.50*GSTGR 
     2.OR.((IWTYP(NZ,NY,NX).EQ.1.OR.IWTYP(NZ,NY,NX).EQ.3)
     3.AND.ISTYP(NZ,NY,NX).NE.0.AND.IPTYP(NZ,NY,NX).NE.1
     3.AND.DYLN(NY,NX).LT.DYLX(NY,NX).AND.IFLGE(NB,NZ,NY,NX).EQ.1
     4.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))
     5.OR.(IWTYP(NZ,NY,NX).EQ.2.AND.ISTYP(NZ,NY,NX).EQ.0)
     6.AND.IFLGE(NB,NZ,NY,NX).EQ.1
     7.AND.VRNF(NB,NZ,NY,NX).GT.VRNX(NB,NZ,NY,NX))THEN
      IDAY(7,NB,NZ,NY,NX)=I
      IF(IWTYP(NZ,NY,NX).NE.0.AND.NB.EQ.NB1(NZ,NY,NX))THEN
      DO 1500 NBB=1,NBR(NZ,NY,NX)
      IF(NBB.NE.NB.AND.IDAY(5,NBB,NZ,NY,NX).EQ.0)THEN
      IDAY(5,NBB,NZ,NY,NX)=I
      PSTGF(NBB,NZ,NY,NX)=PSTG(NBB,NZ,NY,NX)
      ENDIF
1500  CONTINUE
      ENDIF
      ENDIF
C
C     END SEED NUMBER SET PERIOD
C
      ELSEIF(IDAY(8,NB,NZ,NY,NX).EQ.0)THEN
      IF(GSTGF(NB,NZ,NY,NX).GT.1.00*GSTGR)THEN
      IDAY(8,NB,NZ,NY,NX)=I
      IF(IWTYP(NZ,NY,NX).NE.0.AND.NB.EQ.NB1(NZ,NY,NX))THEN
      DO 1495 NBB=1,NBR(NZ,NY,NX)
      IF(NBB.NE.NB.AND.IDAY(6,NBB,NZ,NY,NX).EQ.0)THEN
      IDAY(6,NBB,NZ,NY,NX)=I
      ENDIF
1495  CONTINUE
      ENDIF
      ENDIF
C
C     END SEED SIZE SET PERIOD
C
      ELSEIF(IDAY(9,NB,NZ,NY,NX).EQ.0)THEN
      IF(GSTGF(NB,NZ,NY,NX).GT.1.50*GSTGR)THEN
      IDAY(9,NB,NZ,NY,NX)=I
      ENDIF
      ENDIF
      ENDIF
      KVSTGX=KVSTG(NB,NZ,NY,NX)
      IF(VSTGX(NB,NZ,NY,NX).LE.1.0E-06)THEN
      KVSTG(NB,NZ,NY,NX)=INT(VSTG(NB,NZ,NY,NX))+1
      ELSE
      KVSTG(NB,NZ,NY,NX)=INT(AMIN1(VSTG(NB,NZ,NY,NX)
     2,VSTGX(NB,NZ,NY,NX)))+1
      ENDIF
      KLEAF(NB,NZ,NY,NX)=MIN(24,KVSTG(NB,NZ,NY,NX))
      IF(KVSTG(NB,NZ,NY,NX).GT.KVSTGX)THEN
      IFLGP(NB,NZ,NY,NX)=1
      ELSE
      IFLGP(NB,NZ,NY,NX)=0
      ENDIF
C
C     TERMINATE ANNUALS AFTER GRAIN FILL
C
      IF(ISTYP(NZ,NY,NX).EQ.0.AND.IWTYP(NZ,NY,NX).NE.0
     2.AND.FLG4(NB,NZ,NY,NX).GT.0.0)THEN
      IF(FLG4(NB,NZ,NY,NX).GT.FLG4Y(IWTYP(NZ,NY,NX)))THEN
      VRNF(NB,NZ,NY,NX)=VRNX(NB,NZ,NY,NX)+0.5
      ENDIF
      ENDIF
C
C     PHENOLOGY
C   
      IF(IDTHB(NB,NZ,NY,NX).EQ.0.OR.IFLGI(NZ,NY,NX).EQ.1)THEN
      IF(DYLN(NY,NX).GE.DYLX(NY,NX))THEN
      VRNY(NB,NZ,NY,NX)=VRNY(NB,NZ,NY,NX)+1.0
      VRNZ(NB,NZ,NY,NX)=0.0
      ELSE
      VRNY(NB,NZ,NY,NX)=0.0
      VRNZ(NB,NZ,NY,NX)=VRNZ(NB,NZ,NY,NX)+1.0
      ENDIF
C
C     CALCULATE EVERGREEN PHENOLOGY DURING LENGTHENING PHOTOPERIODS
C
      IF(IWTYP(NZ,NY,NX).EQ.0.AND.ISTYP(NZ,NY,NX).NE.0)THEN
      IF(DYLN(NY,NX).GE.DYLX(NY,NX))THEN
      VRNS(NB,NZ,NY,NX)=VRNY(NB,NZ,NY,NX)
      IF(VRNS(NB,NZ,NY,NX).GE.VRNL(NB,NZ,NY,NX).OR.
     2(ALAT(NY,NX).GT.0.0.AND.I.EQ.173)
     3.OR.(ALAT(NY,NX).LT.0.0.AND.I.EQ.355))THEN
      VRNF(NB,NZ,NY,NX)=0.0
      IFLGF(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
C
C     CALCULATE EVERGREEN PHENOLOGY DURING SHORTENING PHOTOPERIODS
C
      IF(DYLN(NY,NX).LT.DYLX(NY,NX))THEN
      VRNF(NB,NZ,NY,NX)=VRNZ(NB,NZ,NY,NX)
      IF(VRNF(NB,NZ,NY,NX).GE.VRNX(NB,NZ,NY,NX).OR.
     2(ALAT(NY,NX).GT.0.0.AND.I.EQ.355)
     3.OR.(ALAT(NY,NX).LT.0.0.AND.I.EQ.173))THEN
      VRNS(NB,NZ,NY,NX)=0.0
      IFLGE(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
C
C     CALCULATE WINTER DECIDUOUS PHENOLOGY BY ACCUMULATING HOURS IN 
C     SPECIFIED TEMPERATURE RANGES DURING LENGTHENING PHOTOPERIODS
C
      ELSEIF(IWTYP(NZ,NY,NX).EQ.1)THEN
      IF((DYLN(NY,NX).GE.DYLX(NY,NX).OR.DYLN(NY,NX).GE.DYLM(NY,NX)-2.0)
     2.AND.IFLGE(NB,NZ,NY,NX).EQ.0)THEN
      IF(TCG(NZ,NY,NX).GE.TCZ(NZ,NY,NX))THEN
      VRNS(NB,NZ,NY,NX)=VRNS(NB,NZ,NY,NX)+1.0
      ENDIF
      IF(VRNS(NB,NZ,NY,NX).LT.VRNL(NB,NZ,NY,NX))THEN
      IF(TCG(NZ,NY,NX).LT.CTC(NZ,NY,NX))THEN
      VRNS(NB,NZ,NY,NX)=AMAX1(0.0,VRNS(NB,NZ,NY,NX)-1.5)
      ENDIF
      ENDIF
      IF(VRNS(NB,NZ,NY,NX).GE.VRNL(NB,NZ,NY,NX))THEN
      VRNF(NB,NZ,NY,NX)=0.0
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)IFLGF(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)IFLGF(NB,NZ,NY,NX)=0
C     WRITE(*,4646)'VRNS',I,J,NZ,NB,VRNS(NB,NZ,NY,NX),TCG(NZ,NY,NX)
C    2,TCZ(NZ,NY,NX),PSILG(NZ,NY,NX),PSILM,CTC(NZ,NY,NX)
C    3,DYLN(NY,NX),DYLX(NY,NX),DYLM(NY,NX),VRNL(NB,NZ,NY,NX)
4646  FORMAT(A8,4I4,20E12.4)
C
C     CALCULATE WINTER DECIDUOUS PHENOLOGY BY ACCUMULATING HOURS IN 
C     SPECIFIED TEMPERATURE RANGES DURING SHORTENING PHOTOPERIODS
C
      IF((DYLN(NY,NX).LT.DYLX(NY,NX).OR.DYLN(NY,NX) 
     2.LT.24.0-DYLM(NY,NX)+2.0).AND.IFLGF(NB,NZ,NY,NX).EQ.0)THEN
      IF(TCG(NZ,NY,NX).LE.TCX(NZ,NY,NX))THEN
      VRNF(NB,NZ,NY,NX)=VRNF(NB,NZ,NY,NX)+1.0
      ENDIF
      IF(VRNF(NB,NZ,NY,NX).GE.VRNX(NB,NZ,NY,NX)
     2.AND.IFLGE(NB,NZ,NY,NX).EQ.1)THEN
      VRNS(NB,NZ,NY,NX)=0.0
      IFLGE(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
C
C     CALCULATE DROUGHT DECIDUOUS PHENOLOGY BY ACCUMULATING HOURS IN 
C     SPECIFIED TURGOR RANGES IN DORMANT STATE 
C
      ELSEIF(IWTYP(NZ,NY,NX).EQ.2.OR.IWTYP(NZ,NY,NX).EQ.4
     2.OR.IWTYP(NZ,NY,NX).EQ.5)THEN
      IF(IFLGE(NB,NZ,NY,NX).EQ.0)THEN
      IF(PSILT(NZ,NY,NX).GE.PSILX)THEN
      VRNS(NB,NZ,NY,NX)=VRNS(NB,NZ,NY,NX)+1.0
      ENDIF
      IF(VRNS(NB,NZ,NY,NX).LT.VRNL(NB,NZ,NY,NX))THEN
      IF(PSILT(NZ,NY,NX).LT.PSILY(IGTYP(NZ,NY,NX)))THEN
      VRNS(NB,NZ,NY,NX)=AMAX1(0.0,VRNS(NB,NZ,NY,NX)-12.0)
      ENDIF
      ENDIF
      IF(VRNS(NB,NZ,NY,NX).GE.VRNL(NB,NZ,NY,NX))THEN
      VRNF(NB,NZ,NY,NX)=0.0
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)IFLGF(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)IFLGF(NB,NZ,NY,NX)=0
C
C     CALCULATE DROUGHT DECIDUOUS PHENOLOGY BY ACCUMULATING HOURS IN 
C     SPECIFIED TURGOR RANGES IN DORMANT STATE 
C
      IF(IFLGE(NB,NZ,NY,NX).EQ.1
     3.AND.IFLGF(NB,NZ,NY,NX).EQ.0)THEN
      IF(PSILT(NZ,NY,NX).LT.PSILY(IGTYP(NZ,NY,NX)))THEN
      VRNF(NB,NZ,NY,NX)=VRNF(NB,NZ,NY,NX)+1.0
      ENDIF
      IF(IWTYP(NZ,NY,NX).EQ.4)THEN
      IF(VRNZ(NB,NZ,NY,NX).GT.VRNE)THEN
      VRNF(NB,NZ,NY,NX)=VRNZ(NB,NZ,NY,NX)
      ENDIF
      ELSEIF(IWTYP(NZ,NY,NX).EQ.5)THEN
      IF(VRNY(NB,NZ,NY,NX).GT.VRNE)THEN
      VRNF(NB,NZ,NY,NX)=VRNY(NB,NZ,NY,NX)
      ENDIF
      ENDIF
      IF(VRNF(NB,NZ,NY,NX).GE.VRNX(NB,NZ,NY,NX)
     2.AND.IFLGE(NB,NZ,NY,NX).EQ.1)THEN
      VRNS(NB,NZ,NY,NX)=0.0
      IFLGE(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
C
C     CALCULATE WINTER AND DROUGHT DECIDUOUS PHENOLOGY BY ACCUMULATING HOURS 
C     IN SPECIFIED TEMPERATURE RANGES DURING LENGTHENING PHOTOPERIODS
C
      ELSEIF(IWTYP(NZ,NY,NX).EQ.3)THEN
      IF((DYLN(NY,NX).GE.DYLX(NY,NX).OR.DYLN(NY,NX).GE.DYLM(NY,NX)-2.0)
     2.AND.IFLGE(NB,NZ,NY,NX).EQ.0)THEN
      IF(TCG(NZ,NY,NX).GE.TCZ(NZ,NY,NX)
     2.AND.PSILG(NZ,NY,NX).GT.PSILM)THEN
      VRNS(NB,NZ,NY,NX)=VRNS(NB,NZ,NY,NX)+1.0
      ENDIF
      IF(VRNS(NB,NZ,NY,NX).LT.VRNL(NB,NZ,NY,NX))THEN
      IF(TCG(NZ,NY,NX).LT.CTC(NZ,NY,NX)
     2.OR.PSILG(NZ,NY,NX).LT.PSILM)THEN
      VRNS(NB,NZ,NY,NX)=AMAX1(0.0,VRNS(NB,NZ,NY,NX)-1.5)
      ENDIF
      ENDIF
      IF(VRNS(NB,NZ,NY,NX).GE.VRNL(NB,NZ,NY,NX))THEN
      VRNF(NB,NZ,NY,NX)=0.0
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)IFLGF(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
      IF(IDAY(2,NB,NZ,NY,NX).NE.0)IFLGF(NB,NZ,NY,NX)=0
C     WRITE(*,4647)'VRNS',I,J,NZ,NB,VRNS(NB,NZ,NY,NX),TCG(NZ,NY,NX)
C    2,TCZ(NZ,NY,NX),PSILG(NZ,NY,NX),PSILM,CTC(NZ,NY,NX)
C    3,DYLN(NY,NX),DYLX(NY,NX),DYLM(NY,NX),VRNL(NB,NZ,NY,NX)
4647  FORMAT(A8,4I4,20E12.4)
C
C     CALCULATE WINTER DECIDUOUS PHENOLOGY BY ACCUMULATING HOURS IN 
C     SPECIFIED TEMPERATURE RANGES DURING SHORTENING PHOTOPERIODS
C
      IF((DYLN(NY,NX).LT.DYLX(NY,NX).OR.DYLN(NY,NX) 
     2.LT.24.0-DYLM(NY,NX)+2.0).AND.IFLGF(NB,NZ,NY,NX).EQ.0)THEN
      IF(TCG(NZ,NY,NX).LE.TCX(NZ,NY,NX)
     2.OR.PSILT(NZ,NY,NX).LT.PSILY(IGTYP(NZ,NY,NX)))THEN
      VRNF(NB,NZ,NY,NX)=VRNF(NB,NZ,NY,NX)+1.0
      ENDIF
      IF(VRNF(NB,NZ,NY,NX).GE.VRNX(NB,NZ,NY,NX)
     2.AND.IFLGE(NB,NZ,NY,NX).EQ.1)THEN
      VRNS(NB,NZ,NY,NX)=0.0
      IFLGE(NB,NZ,NY,NX)=0
      ENDIF
      ENDIF
      ENDIF
      ENDIF
2010  CONTINUE
C
C     WATER STRESS INDICATOR
C
      IF(PSILT(NZ,NY,NX).LT.PSILY(IGTYP(NZ,NY,NX)))THEN
      WSTR(NZ,NY,NX)=WSTR(NZ,NY,NX)+1.0
      ENDIF
      ENDIF
      ENDIF
      ENDIF
9985  CONTINUE
9990  CONTINUE
9995  CONTINUE
      RETURN
      END