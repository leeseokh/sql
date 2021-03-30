2021-03-30


가지치기 : Pruning branch

SELECT *
FROM emp;

SELECT empno, LPAD(' ', (LEVEL-1)*4) ||ename ename, mgr, deptno, job
FROM emp
WHERE job!='ANALYST'
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

차이점: WHERE절에는 START에서 다 하고 기술 CONNECT절에서하면 거기서 기술. 계층에서는 WHERE절에선 일반적으로 기술하지 않음 

SELECT empno, LPAD(' ', (LEVEL-1)*4) ||ename ename, mgr, deptno, job
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr AND job!='ANALYST';

계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 최상위 노드의 해당 컬럼 값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열

SELECT LPAD(' ', (LEVEL-1)*4) ||ename ename,
    CONNECT_BY_ROOT(ename) root_ename,
    SYS_CONNECT_BY_PATH(ename, '-')path_ename   --어떻게 값을 타고 내려온지 볼 수 있음.
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;

SELECT LPAD(' ', (LEVEL-1)*4) ||ename ename,
    CONNECT_BY_ROOT(ename) root_ename,
    LTRIM(SYS_CONNECT_BY_PATH(ename, '-'),'-')path_ename,   --어떻게 값을 타고 내려온지 볼 수 있음.
    INSTR('TEST', 'T'),
    INSTR('TEST', 'T', 2)
FROM emp
START WITH mgr IS null
CONNECT BY PRIOR empno = mgr;
다섯번째 글은 네번째 글의 답글입니다.
여섯번째 글은 다섯번째 글의 답글입니다.

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_SEQ IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS  BY seq DESC;

시작글은 작성순서의 역순으로
답글은

최상위글은 최신글이 먼저오괴 답글의 경우 작성한 순서대로 정렬 어떻게 해야 최상위글은 최신글desc 으로 정렬하고 답글은 asc적으로 정렬 할 수 있을까?
SELECT gn, seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가

ALTER TABLE board_test ADD (gn NUMBER);
DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq IN(1, 9);

UPDATE board_test SET gn = 2
WHERE seq IN(2, 3);

UPDATE board_test SET gn = 4
WHERE seq NOT IN(1, 2, 3, 9);

SELECT CONNECT_BY_ROOT(seq) root,seq,
seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH PARENT_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq ASC;

SELECT *
FROM 
(SELECT seq, LPAD( ' ' , (LEVEL-1)*3 ) || title title , CONNECT_BY_ROOT(seq) gn  
FROM board_test
START WITH PARENT_SEQ IS NULL 
CONNECT BY PRIOR  SEQ = PARENT_SEQ  )
ORDER BY gn DESC, seq ASC;

SELECT*
FROM
(SELECT ROWNUM rn, a.*
FROM 
(SELECT gn, seq, LPAD( ' ' , (LEVEL-1)*3 ) || title title 
FROM board_test
START WITH PARENT_SEQ IS NULL 
CONNECT BY PRIOR  SEQ = PARENT_SEQ  
ORDER BY gn DESC, seq ASC a
WHERE rn BETWEEM 6 AND 10;

그 사람이 누군지?
SELECT *
FROM emp 
WHERE deptno =10
AND sal =   (SELECT MAX(sal) 
              FROM emp
              WHERE deptno = 10 );

분석함수(window함수)
-SQL에서 행간 연산을 지원하는 함수

-해당행의 범위를 넘어서 다른 행과 연산이 가능 - SQL의 약점 보완
-이전행의 특정 컬럼을 참조
-특정 범위의 행들의 컬럼의 합
-특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여

-SUM, COUNT, AVG, MAX, MIN, RANK, LEAD, LAG...

실습ana0
사원의 부서별 급여별 순위 구하기 emp 테이블사용

SELECT ename, sal, deptno , 
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC ) sal_rank     
FROM emp ; 
PARTITION BY: 같은 부서코드를 갖는 row를 그룹으로 묶는다
ORDER BY sal : 그룹내에서 sal로 row의 순서를 정한다.
RANK(): 파티션 단위안에서 정렬 순서대로 순위를 부여한다.


SELECT *
FROM 
(SELECT ename, sal, deptno, ROWNUM rn
    FROM
    (SELECT ename, sal, deptno                 ----------부서별이며  전체 랭크.
     FROM emp
     ORDER BY deptno, sal DESC) ) a

-----------------------------------------------
SELECT *
FROM 
(SELECT ename, sal, deptno, ROWNUM rn
    FROM
    (SELECT ename, sal, deptno
     FROM emp
     ORDER BY deptno, sal DESC) ) a,
     (SELECT deptno, lv, ROWNUM rn
FROM 
    (SELECT a.deptno, b.lv
    FROM 
    (SELECT deptno, COUNT(*) cnt
     FROM emp
     GROUP BY deptno) a, 
    (SELECT LEVEL lv
     FROM dual
     CONNECT BY LEVEL <= (SELECT COUNT(*) FROM emp) ) b
    WHERE a.cnt >= b.lv
    ORDER BY a.deptno, b.lv )) b
    WHERE a.rn = b.rn;
---------------------------------------------------
순위 관련된 함수
RANK : 동일값에 대해서 동일 순위를 부여한다. 
       후순위 :동일값만 건너뛴다. 1등이 2명이면 그 다음 순위가 3위다. ( 1, 1, 3) 
DENSE_RANK : 동일값에 대해 동일 순위를 부여하는데 
             후순위 :이어서 부여한다. 1등이 2명이면 그 다음순위가 2위 ( 1, 1, 2 ) 
ROW_NUMBER : 동일값이라도 다른 순위를 부여한다./ 중복없이 행에 순차적인 번호 부여 ( 1, 2, 3) 


SELECT ename, sal, deptno ,  
RANK() OVER (PARTITION BY deptno ORDER BY sal DESC ) sal_rank ,
DENSE_RANK() OVER (PARTITION BY deptno ORDER BY sal DESC ) sal_dense_lank,
ROW_NUMBER() OVER ( PARTITION BY deptno ORDER BY sal DESC ) sal_row_number 
FROM emp ; 

SELECT WINDOW_FUNCTION(인자) , OVER 

window 함수 실습 ana1)
사원 전체 급여 순위를 rank, dense_rank, row_number를 이용하여 구하세요
단 급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 하세요

SELECT empno, ename, sal, deptno,
RANK() OVER (ORDER BY sal desc , empno) sal_rank ,
DENSE_RANK() OVER ( ORDER BY sal desc , empno ) sal_dense_lank,
ROW_NUMBER() OVER ( ORDER BY sal desc , empno ) sal_row_number 
FROM emp;

winwdow 함수 실습 ana2)
기존의 배운 내용 활용 모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리 작성

SELECT empno, ename, deptno,  COUNT(*)over ( partition by deptno  )cnt
FROM emp;

SELECT empno, ename, deptno
FROM emp,
    (SELECT deptno, COUNT(*) cnt
    FROM emp
    GROUP BY deptno) b
    WHERE emp.deptno = b.deptno
    ORDER BY emp.deptno;








