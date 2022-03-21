      SUBROUTINE ROOT(T,FT,B,C,RELERR,ABSERR,IFLAG)
C
C  ROOT COMPUTES A ROOT OF THE NONLINEAR EQUATION F(X)=0
C  WHERE F(X) IS A CONTINOUS REAL FUNCTION OF A SINGLE REAL
C  VARIABLE X.  THE METHOD USED IS A COMBINATION OF BISECTION
C  AND THE SECANT RULE.
C
C  NORMAL INPUT CONSISTS OF A CONTINUOS FUNCTION F AND AN
C  INTERVAL (B,C) SUCH THAT F(B)*F(C).LE.0.0.  EACH ITERATION
C  FINDS NEW VALUES OF B AND C SUCH THAT THE INTERVAL(B,C) IS
C  SHRUNK AND F(B)*F(C).LE.0.0.  THE STOPPING CRITERION IS
C
C          DABS(B-C).LE.2.0*(RELERR*DABS(B)+ABSERR)
C
C  WHERE RELERR=RELATIVE ERROR AND ABSERR=ABSOLUTE ERROR ARE
C  INPUT QUANTITIES.  SET THE FLAG, IFLAG, POSITIVE TO INITIALIZE
C  THE COMPUTATION.  AS B,C AND IFLAG ARE USED FOR BOTH INPUT AND
C  OUTPUT, THEY MUST BE VARIABLES IN THE CALLING PROGRAM.
C
C  IF 0 IS A POSSIBLE ROOT, ONE SHOULD NOT CHOOSE ABSERR=0.0.
C
C  THE OUTPUT VALUE OF B IS THE BETTER APPROXIMATION TO A ROOT
C  AS B AND C ARE ALWAYS REDEFINED SO THAT DABS(F(B)).LE.DABS(F(C)).
C
C  TO SOLVE THE EQUATION, ROOT MUST EVALUATE F(X) REPEATEDLY. THIS
C  IS DONE IN THE CALLING PROGRAM.  WHEN AN EVALUATION OF F IS
C  NEEDED AT T, ROOT RETURNS WITH IFLAG NEGATIVE.  EVALUATE FT=F(T)
C  AND CALL ROOT AGAIN.  DO NOT ALTER IFLAG.
C
C  WHEN THE COMPUTATION IS COMPLETE, ROOT RETURNS TO THE CALLING
C  PROGRAM WITH IFLAG POSITIVE=
C
C     IFLAG=1  IF F(B)*F(C).LT.0 AND THE STOPPING CRITERION IS MET.
C
C          =2  IF A VALUE B IS FOUND SUCH THAT THE COMPUTED VALUE
C              F(B) IS EXACTLY ZERO.  THE INTERVAL (B,C) MAY NOT
C              SATISFY THE STOPPING CRITERION.
C
C          =3  IF DABS(F(B)) EXCEEDS THE INPUT VALUES DABS(F(B)),
C              DABS(F(C)).  IN THIS CASE IT IS LIKELY THAT B IS CLOSE
C              TO A POLE OF F.
C
C          =4  IF NO ODD ORDER ROOT WAS FOUND IN THE INTERVAL.  A
C              LOCAL MINIMUM MAY HAVE BEEN OBTAINED.
C
C          =5  IF TOO MANY FUNCTION EVALUATIONS WERE MADE.
C              (AS PROGRAMMED, 500 ARE ALLOWED.)
C
C  THIS CODE IS A MODIFICATION OF THE CODE ZEROIN WHICH IS COMPLETELY
C  EXPLAINED AND DOCUMENTED IN THE TEXT  NUMERICAL COMPUTING:  AN
C  INTRODUCTION,  BY L. F. SHAMPINE AND R. C. ALLEN.
C
C  CALLS  D1MACH .
C
      DOUBLE PRECISION A,ABSERR,ACBS,ACMB,AE,B,C,CMB,D1MACH,FA,FB,
     1  FC,FT,FX,P,Q,RE,RELERR,T,TOL,U
      INTEGER IC,IFLAG,KOUNT
      SAVE
C
      IF(IFLAG.GE.0) GO TO 100
      IFLAG=ABS(IFLAG)
      GO TO (200,300,400), IFLAG
  100 U=D1MACH(4)
      RE=MAX(RELERR,U)
      AE=MAX(ABSERR,0.0D0)
      IC=0
      ACBS=ABS(B-C)
      A=C
      T=A
      IFLAG=-1
      RETURN
  200 FA=FT
      T=B
      IFLAG=-2
      RETURN
  300 FB=FT
      FC=FA
      KOUNT=2
      FX=MAX(ABS(FB),ABS(FC))
    1 IF(ABS(FC).GE.ABS(FB))GO TO 2
C
C  INTERCHANGE B AND C SO THAT ABS(F(B)).LE.ABS(F(C)).
C
      A=B
      FA=FB
      B=C
      FB=FC
      C=A
      FC=FA
    2 CMB=0.5*(C-B)
      ACMB=ABS(CMB)
      TOL=RE*ABS(B)+AE
C
C  TEST STOPPING CRITERION AND FUNCTION COUNT.
C
      IF(ACMB.LE.TOL)GO TO 8
      IF(KOUNT.GE.500)GO TO 12
C
C  CALCULATE NEW ITERATE EXPLICITLY AS B+P/Q
C  WHERE WE ARRANGE P.GE.0.  THE IMPLICIT
C  FORM IS USED TO PREVENT OVERFLOW.
C
      P=(B-A)*FB
      Q=FA-FB
      IF(P.GE.0.0)GO TO 3
      P=-P
      Q=-Q
C
C  UPDATE A, CHECK IF REDUCTION IN THE SIZE OF BRACKETING
C  INTERVAL IS SATISFACTORY.  IF NOT BISECT UNTIL IT IS.
C
    3 A=B
      FA=FB
      IC=IC+1
      IF(IC.LT.4)GO TO 4
      IF(8.0*ACMB.GE.ACBS)GO TO 6
      IC=0
      ACBS=ACMB
C
C  TEST FOR TOO SMALL A CHANGE.
C
    4 IF(P.GT.ABS(Q)*TOL)GO TO 5
C
C  INCREMENT BY TOLERANCE
C
      B=B+SIGN(TOL,CMB)
      GO TO 7
C
C  ROOT OUGHT TO BE BETWEEN B AND (C+B)/2
C
    5 IF(P.GE.CMB*Q)GO TO 6
C
C  USE SECANT RULE.
C
      B=B+P/Q
      GO TO 7
C
C  USE BISECTION.
C
    6 B=0.5*(C+B)
C
C  HAVE COMPLETED COMPUTATION FOR NEW ITERATE B.
C
    7 T=B
      IFLAG=-3
      RETURN
  400 FB=FT
      IF(FB.EQ.0.0)GO TO 9
      KOUNT=KOUNT+1
      IF(SIGN(1.0D0,FB).NE.SIGN(1.0D0,FC))GO TO 1
      C=A
      FC=FA
      GO TO 1
C
C FINISHED.  SET IFLAG.
C
    8 IF(SIGN(1.0D0,FB).EQ.SIGN(1.0D0,FC))GO TO 11
      IF(ABS(FB).GT.FX)GO TO 10
      IFLAG=1
      RETURN
    9 IFLAG=2
      RETURN
   10 IFLAG=3
      RETURN
   11 IFLAG=4
      RETURN
   12 IFLAG=5
      RETURN
      END
