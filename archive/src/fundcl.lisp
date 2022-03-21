(in-package "MAXIMA")


(import '(compiler::inline-unsafe compiler::inline-always compiler::boolean
    compiler::definline ) 'cl-maxima)


(defun proclaim-property (arg &aux (prop (car arg)))
    (sloop for v in (cdr arg)
	   do (assert (symbolp v))
	   (setf (get v prop) t)))



;;;;make not proclaimed, they do too much storage allocation, or binding:
;;remove1, meval1, arrstore, bigfloatm*, simplus , simpln, simpquot
;;simptimes, expand1, simpexpt, simpsignum, simpnrt, bprog, simpabs, simpderiv
;;simpinteg,
;;retrieve, remalias, loadfile, kill1 , filenamel , dollarify-name
;;dimension-string, dimension-infix, dimension-prefix, dimension-nary, 
;;dimension-postfix, dimension-nofix, dimension-superscript , nformat-all,
;;truep, par, unkind, activate, deactivate, context, cntxt, kcntxt, 
;;assume, maximin, rgrp, ratint, 
;;AMPERCHK, MAKSTRING,REMLABELS,LOAD-FUNCTION,NFORMAT-ALL,ASKSIGN-P-OR-N
;;SIMP-%ATAN SIMP-%COS SIMP-%COT  SIMP-%CSC SIMP-%SEC SIMP-%SIN SIMP-%TAN
;;FINDFUN,FINDBASE,PART*, PART+,APPLY1 APPLY1HACK APPLY2,       APPLY2HACK
;;ANTISYM 

(proclaim-property '(compiler::fixed-args crecip
      ptimes* pderivative2 pcoefadd

      oldget

      *KAR ACOT ACOTH ACSC ACSCH  ADD2LNC ADDF ADDK ADDLABEL
      ALG ALIAS ALIKE ALIKE1  
      ARCP  ASEC ASECH  ASSQ 
      ATAN1 BATCH1   CARFILE CASIFY-EXPLODEN
      CG-IMAGE-TYO CG-IMAGE-TYO-N CG-TYO CG-TYO-N CLEAR 
      COMMUTATIVE1 COMPUTIME CONSTFUN  CONTEXTMARK COT COTH CSC
      CSCH DATUM  DECLAREKIND DIMENSION-ATOM 
         
        DINTERN DINTERNP DISPLA
      DOLLARIFY  DOUTERN DSKRAT EQTEST ERRBREAK EVEN
      EXPTRL EXPONENTIALIZE  FACT FALSEP FEXPRCHECK 
      FILEPRINT FILESTRIP FIND-FUNCTION FIND0  FINDBE FINDEXPON
       FORGET FORMFEED FPCOFRAT FREE FREEARGS FREEL FULLSTRIP
      FULLSTRIP1 FUNCER GETL GETLABCHARN GETLABELS GETLABELS* GREAT
      I-$ALLOC I-$REMOVE I-$REMVALUE IMPROPER-ARG-ERR INFSIMP IOLFUN IS
      ISINOP ISP KAR  KDR KILL  KILLC KILLFRAME KIND KINDP
      LASSOCIATIVE LEARN LIKE LOAD-FILE  
      MACHERRFUN MAKELABEL MAKESTRING MAPPLY MARGS MARK MARKP
      MATCHERR  MAXIMUM MBAGP MBIND MCONS-OP-ARGS MEMQ MEQP
      MEQUALP MEVAL MEVAL*  MEVAL2 MEVALATOMS MEVALN MEVALP
      MEVALP2 MEXPLODEN MEXPTP MFBOUNDP MFILE-OUT MFILEP MGET MGETL
      MGQP MGRP MINIMUM MLOGP MMAPEV MMINUSP MMINUSP* MMMINUSP MNCEXPTP
      MNCTIMESP MNEGP MNQP MNUMP MOP MOPP MOPP1 MORE-FUN MPLUSP
      MPUTPROP MQAPPLYP MQUOTEP MRATCHECK MREMPROP MRETURN MSET MSETCHK
      MSETERR MSETQP MSTRING MTERPRI MTIMESP MTRUENAME MUNBIND
      MXORLISTP NARY1 NEVERSET NFORMAT  NONSYMCHK NONVARCHK
      NTHKDR NUMERSET ODDFUN ONEARGCHECK ONEP ONEP1 OPTIONP PALGSIMP
        PCDIFFER PCDIFFER1 PCDIFFER2 PCOEFADD PCPLUS
      PCPLUS1 PCSUB PCTIMES PCTIMES1 PDEGREE PDERIVATIVE PDIFFER1
      PDIFFERENCE PGCD1 PMINUS PMINUSP PMOD
      ;POINTERGP
      PPLUS PPLUS1
      PQUOTIENT PQUOTIENTCHK PRE-ERR PRED-REVERSE PRINL PRINTLABEL
      PSIMP1 PTIMES PTIMES1 RASSOCIATIVE RAT RATDENOMINATOR
      RATDERIVATIVE RATDIF RATDISREP RATEXPT RATF RATFACT 
      RATMINUS RATNUMERATOR RATNUMP RATPLUS RATQUOTIENT RATREDUCE
      RATREP RATREP* RATTIMES RDIFFERENCE  REMALIAS1 REMARRELEM
       REMOV  REMPROPCHK REMRULE REMVALUE REPRINT
      RESTORE-FACTS   RPLUS RREMAINDER RTIMES RUBOUT*
      RULEOF SEC SECH SIGN SIGNUM1  SIMP-LIMIT 
      SIMPARGS SIMPARGS1 SIMPBIGFLOAT SIMPCHECK  SIMPEXP
        SIMPLAMBDA SIMPLIFYA   SIMPMATRIX
      SIMPMDEF SIMPMQAPPLY    SIMPSQRT
       SPECDISREP SPECREPP SQ-SUMSQ SQRT1+X^2 SQRT1-X^2
      SQRTX^2-1 SRATSIMP SSIMPLIFYA STRIPDOLLAR STRMEVAL SUBARGCHECK
      SUBFUNARGS SUBFUNMAKE SUBFUNMAKES SUBFUNNAME SUBFUNSUBS TIMEORG
      TIMESK TOTAL-NARY TRIGP TRUE* TRUEFNAME  TTYINTFUN
      TTYINTFUNSETUP TTYRETFUN TWOARGCHECK TYI*  UNMRK UNTRUE
      VISIBLEP WNA-ERR ZEROP1 ZL-ASSOC ZL-MEMBER

;     ;;these are fixed args but probably not called enough.
;      $%TH $ACOS $ACOSH $ACOT $ACOTH $ACSC $ACSCH $ASEC $ASECH $ASIN $ASINH
;      $ASKSIGN $ATAN $ATANH $BFLOATP $BINOMIAL $BOTHCASES $COMPARE
;      $CONSTANTP $COS $COSH $COT $COTH $CSC $CSCH $DDT $DEBUGMODE
;      $DSKGC $EVENP $EXP $EXPONENTIALIZE $FEATUREP $FLOATNUMP $FPPREC
;      $FUNMAKE $GAMMA $GET $INTEGERP $KILLCONTEXT $LOG $LOGOUT $MAPATOM
;      $NEWCONTEXT $NONSCALARP $NOUNIFY $NUMBERP $NUMFACTOR $ODDP
;      $ORDERGREATP $ORDERLESSP $PAGEPAUSE $POISLIM $POLYSIGN $PUT $QUIT
;      $RATNUMP $RATP $REM $SCALARP $SEC $SECH $SIGN $SIN $SINH $SQRT
;      $SUBVARP $TAN $TANH $THROW $TO_LISP $UUO $VERBIFY |''MAKE-FUN|


   ))


