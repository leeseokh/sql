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

20210_03_31
SELECT empno, ename, sal, deptno,
ROUND(AVG (sal) OVER (PARTITION BY deptno),2)avg_sal,
MIN(sal) OVER (PARTITION BY deptno),2)min_sal
FROM emp;

LAG: 파티션별 윈도우에서 이전 행의 컬럼 값
LEAD: 파티션별 윈도우에서 이후 행의 컬럼 값

window3
자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성
SELECT empno, ename, hiredate, sal,LEAD(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp
-- ORDER BY sal DESC;  -- 이것이 순위.
window 5
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,입사일자,급여,전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요(급여 같을시 입사순)
;
SELECT empno, ename, hiredate, sal,LAG(sal) OVER (ORDER BY sal DESC, hiredate)
FROM emp;

window 5_1
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름,입사일자,급여,전체 사원중 급여 순위가 1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요(급여 같을시 입사순)
분석함수와 LEAD 안쓰고


SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM
(SELECT a.*, ROWNUM rn
FROM 
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) ,
(SELECT a.* ,ROWNUM rn
FROM 
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) b
WHERE a.rn -1 = b.rn(+);

ana6
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 직군(job), 급여 정보와 담당업무(job)별 급여 순위가 1단계 높은 
사람의 급여를 조회하는 쿼리를 작성하세요 ( 급여가 같을 경우 입사일이 빠른 사람이 우선순위.)

SELECT empno, ename, hiredate, job , sal , 
LAG(sal) OVER (PARTITION BY job ORDER BY sal DESC, hiredate ASC)lag_sal 
FROM emp;

LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기
SELECT empno, ename, hiredate, sal, 
LAG(sal, 2) OVER (ORDER BY sal DESC, hiredate)
FROM emp;

window함수 실습 no_ana3)
HINT rownum, 범위 조인
empno, ename, sal, c.sum


SELECT a.empno, a.ename, a.sal, b.sal
FROM
(SELECT a.*, ROWNUN rn
FROM
(SELECT empno, ename, sal, sal                             -- LAG(sal, 2) OVER (OREDER BY sal DESC) c,sum
FROM emp
ORDER BY sal, empno ) a ) b
WHERE a.rn >= b.rn
ORDER BY a.sal, a.empno;

SELECT empno,

WINDOWIMG : 윈도우 함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행(LAG)
      
        PRECEDING: 특정 행을 기준으로 N행 이전행(LAG)
CURRENT ROW : 현재행

UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행 (LEAD)
        FOLLOWING: 특정 행을 기준으로 N행 이후행(LEAD)
        
분석함수()OVER ( [] [ORDER] (WINDOWING)

SELECT empno, ename, sal , SUM(sal) OVER (ORDER BY sal,hiredate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) c_sum   
FROM emp;  --길어도 이코드 추천 명확함...

SELECT empno, ename, sal , SUM(sal) OVER (ORDER BY sal,hiredate ASC ROWS  UNBOUNDED PRECEDING) c_sum 
FROM emp; --참고.. 비추

window 7)
사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬 했을때, 자신의 급여와 선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요(window 사용)
SELECT empno, ename, deptno, sal , 
       SUM(sal) OVER (PARTITION BY deptno ORDER BY sal,hiredate ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) c_sum
FROM emp;

ROWS와 RANGE의 차이  --참고만.
rows 는 물리적인 row 
range : 뒤에 같은 값이 나오면 
SELECT empno, ename, sal , 
SUM(sal) OVER ( ORDER BY sal  ROWS UNBOUNDED PRECEDING ) rows_c_SUM , 
SUM(sal) OVER ( ORDER BY sal  RANGE UNBOUNDED PRECEDING ) range_c_SUM , 
SUM(sal) OVER ( ORDER BY sal )  no_win_c_sum   --order by 이후 윈도윙 없을경우 기본 설정: RANGE UNBOUNDED PRECEDING
--SUM(sal) OVER () no_ord_c_sum
FROM emp ; 

default 는 range 다.    


