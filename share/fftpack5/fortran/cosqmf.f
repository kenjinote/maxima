CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C
C   FFTPACK 5.0 
C
C   Authors:  Paul N. Swarztrauber and Richard A. Valent
C
C   $Id$
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

      SUBROUTINE COSQMF (LOT, JUMP, N, INC, X, LENX, WSAVE, LENSAV, 
     1                   WORK, LENWRK, IER)
      INTEGER    LOT, JUMP, N, INC, LENX, LENSAV, LENWRK, IER
      REAL       X(INC,*), WSAVE(LENSAV), WORK(LENWRK)
      LOGICAL    XERCON
C
      IER = 0
C
      IF (LENX .LT. (LOT-1)*JUMP + INC*(N-1) + 1) THEN
        IER = 1
        CALL XERFFT ('COSQMF', 6)
        GO TO 300
      ELSEIF (LENSAV .LT. 2*N + INT(LOG(REAL(N))/LOG(2.)) +4) THEN
        IER = 2
        CALL XERFFT ('COSQMF', 8)
        GO TO 300
      ELSEIF (LENWRK .LT. LOT*N) THEN
        IER = 3
        CALL XERFFT ('COSQMF', 10)
        GO TO 300
      ELSEIF (.NOT. XERCON(INC,JUMP,N,LOT)) THEN
        IER = 4
        CALL XERFFT ('COSQMF', -1)
        GO TO 300
      ENDIF
C
      LJ = (LOT-1)*JUMP+1
      IF (N-2) 102,101,103
  101 SSQRT2 = 1./SQRT(2.)
      DO 201 M=1,LJ,JUMP
      TSQX = SSQRT2*X(M,2)
      X(M,2) = .5*X(M,1)-TSQX
      X(M,1) = .5*X(M,1)+TSQX
  201 CONTINUE
  102 RETURN
  103 CALL MCSQF1 (LOT,JUMP,N,INC,X,WSAVE,WORK,IER1)
      IF (IER1 .NE. 0) THEN
        IER = 20
        CALL XERFFT ('COSQMF',-5)
      ENDIF
C
  300 CONTINUE
      RETURN
      END
