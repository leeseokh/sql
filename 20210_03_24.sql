SMITH 가 속한 부서에 있는 직원들을 조회하기  == 20 부서에 속한 직원들 조회하기
1번 정보에서 알아낸 부서번호로 해당부서에 속하는 직원을 emp 테이블에서 검색한다.

1.
SELECT *
FROM emp
WHERE ename = 'SMITH';

2.
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
FROM emp
WHERE ename = 'SMITH');       --서브쿼리

SELECT *
FROM emp      --MAIN QUERY
WHERE deptno =(SELECT deptno  -- IN을 사용해야함.
               FROM emp    
               WHERE ename = 'SMITH' OR ename = 'ALLEN');       --서브쿼리

--WHERE deptno IN(20, 30)

서브쿼리: 쿼리의 일부로 사용되는 쿼리
    --1. 사용위치에 따른 분류
    SELECT : 스칼라 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행,하나의 컬럼을 반환하는 쿼리.
    FROM : 인라인 뷰
    WHERE : 서브쿼리
              메인쿼리의 컬럼을 가져다가 사용할 수 있다.
              반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다
    반환값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
    행-다중행, 단일행, 컬럼 - 단일 컬럼, 복수 컬럼
    다중행 단일 컬럼
    단일행 단일 컬럼
    단일행 복수 컬럼
    
main - sub query의 관계에 따른 분류 
    상호 연관 서브 쿼리 - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
    > 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능.
    비상호 연관 서브 쿼리 -(non-correlated sub query)- 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우
    > 메인쿼리가 없어도 서브쿼리로만 실행이 가능하다.
    
-비상호-
SELECT *
FROM emp
WHERE deptno =(SELECT deptno
FROM emp
WHERE ename = 'SMITH');    
    
--서브쿼리 1
평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요.
SELECT AVG(sal)
FROM emp;
+
SELECT *
FROM emp
WHERE sal >= 2073;

SELECT*
FROM emp
WHERE sal >= (SELECT AVG(sal)  --where절 서브쿼리 사용,
              FROM emp);
--서브쿼리2
평균 급여보다 높은 급여를 받는 직원의 수를 조회하시오.
SELECT*
FROM emp
WHERE sal >= (SELECT AVG(sal)  
              FROM emp);
              
서브쿼리 3
SMITH와 WARD사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요.
SELECT*
FROM emp
WHERE deptno IN(SELECT deptno  -- IN을 사용해야함.
               FROM emp    
               WHERE ename IN('SMITH', 'WARD'));
               
MULTI ROW 연산자 -- 많이 안씀 넘어가도됨.
IN  = +OR
비교연산자: ANY
비교연산자: ALL

SELECT*
FROM emp e
WHERE sal < ANY ( SELECT sal          --ANY 직원중 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회
                  FROM emp m
                  WHERE ename IN('SMITH', 'WARD'));     
                  
SELECT*
FROM emp m
WHERE sal < ANY (SELECT MAX(s.sal)          --ALL 직원중 급여값이 SMITH(800)나 WARD(1250)의 급여보다 큰 직원을 조회
                  FROM emp s
                  WHERE s.ename IN('SMITH', 'WARD'));  

SELECT*
FROM emp m
WHERE sal <  (SELECT MIN(s.sal)          -- 직원의 급여값이 800보다 작고 1250보다 작은 사람들.
              FROM emp s
              WHERE s.ename IN('SMITH', 'WARD'));                  

서브쿼리 사용시 주의점 NULL 값
IN ()
NOT IN()

SELECT *    
FROM emp
WHERE deptno IN (10, 20, NULL);
-->> 동등 연산자로 바꾸면  dept = 10 OR deptno =20 OR deptno = NULL 
                                                        >>FALSE
SELECT *    
FROM emp
WHERE deptno NOT IN (10, 20, NULL);
--> deptno ! = 10 AND deptno ! =20AND deptno != NULL
                                               >>FALSE
TRUE AND TRUE AND TRUE  >> TRUE
TRUE AND TRUE AND FALSE >> FALSE

SELECT*
FROM emp
WHERE empno NOT IN (SELECT mgr  --NOT IN 썻는데 결과가 안나오면 널값이 있는지 확인해봐라. 9번 널
                    FROM emp);
                    
SELECT*
FROM emp
WHERE empno NOT IN (SELECT NVL (mgr, 9999)  -- 직원중에 매니저가 아닌사람.  시험 나올듯..
FROM emp);   

PATR WISE : 순서쌍
SELECT*
FROM emp
WHERE mgr IN (SELECT mgr 
              FROM emp
              WHERE empno IN(7499, 7782))
    AND deptno IN (SELECT deptno
                   FROM emp
                    WHERE empno IN(7499, 7782));
      --ALLEN(30, 7698), CLARK(10, 7839)
        SELECT ename, mgr, deptno
        FROM emp
        WHERE empno IN (7499, 7782);
                           
SELECT *
FROM emp
WHERE mgr IN (7698, 7839)
    AND deptno IN(10, 30);
   >> mgr deptno
   (7698,10), (7698,30),(7839,30) 이 나옴.     
   
   요구사항: ALLEN또는 CLARK 의 소속 부서번호가 같으면서 상사도 같은 직원들을 조회.
   
   SELECT*
   FROM emp
   WHERE(mgr, deptno) IN
                       (SELECT mgr, deptno          --두가지를 동시에 만족해야함..., 개발원에서는 안나올듯...
                        FROM emp
                        WHERE ename IN ('ALLEN', 'CLARK'));
DISTNCT 
1. 설계가 잘못
2. 개발자가 잘못
3. 요구사항이 이상한 경우 
스칼라 서브쿼리: SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리(스칼라 서브쿼리) 중요!~!~~!~!~!~!

SELECT empno, ename, SYSDATE
FROM emp;


SELECT SYSDATE
FROM dual;


SELECT empno, ename, (SELECT SYSDATE FROM dual)   
FROM emp;

SELECT empno, ename, (SELECT SYSDATE, SYSDATE FROM dual) -- 스칼라 서브쿼리는 하나의 컬럼만 가능.
FROM emp;

emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.  -- 조인 대신 스칼라서브쿼리

스미스가 속한 부서의 이름을 바꾸기위한 쿼리
상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다.
SELECT empno, ename, deptno
        (SELECT dame FROM dept WHERE dept.deptno= emp.deptno) -- 메인쿼리 1 서브쿼리 14번실행
FROM emp;


비상호 연관 서브쿼리는 메인쿼리가 먼저 실행 될 수도 있고
                    서브쿼리가 먼저 실행 될 수도있다.
                        >> 성능 면에서 유리한걸 오라클이 설정.
SMITH : SELECT dname FROM dept WHERE deptno = 20;
ALLEN : SELECT dname FROM dept WHERE deptno = 30;
CLARK : SELECT dname FROM dept WHERE deptno = 10;

SELECT empno, ename, deptno
        (SELECT dame FROM dept WHERE deptno=20)
        (SELECT dame FROM dept WHERE deptno=30)
        (SELECT dame FROM dept WHERE deptno=10)
FROM emp;
인라인  : 해당 위치에 직접 기술 함.
인라인뷰: 해당 위치에 직접 기술한 뷰
뷰     : 쿼리(0) ==>  뷰테이블(X)
SELECT *
FROM
(SELECT deptno, ROUND( AVG(sal), 2) avg_sal
FROM emp 
GROUP BY deptno)   -- 인라인뷰
WHERE deptno IN(20, 10);

아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
SELECT*
FROM emp
WHERE sal > = (SELECT AVG(sal)
               FROM emp);

SELECT empno, ename, sal, deptno   --??
FROM emp;

20번의 부서평균(2175)
SELECT AVG(sal)
FROM emp
WHERE deptno = 20;

10번의 부서평균 (2916.666)
SELECT AVG(sal)
FROM emp
WHERE deptno = 10;

직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회
SELECT  empno, ename, sal, deptno  
FROM emp e 
WHERE e.sal >  (SELECT AVG(sal)         --구분위해 별칭e 써주기
               FROM emp a
              WHERE a.deptno = e.deptno);  -- a -> 평균

deptno, dname, loc
INSERT INTO dept VALUES(99, 'ditt', 'daejeon');

실습 쿼리 4)
dept 테이블에 신규 등록된 99번 부서에 속한 사람은 없음. 직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요.

SELECT*
FROM dept
WHERE deptno NOT IN   (SELECT deptno
                       FROM emp);
                
실습 쿼리 5)
cycle, product 테이블을 이용하여 cid=1인 고객이 예음하지 않는 제품을 조회하는 쿼리를 작성하세요

SELECT *
FROM product
WHERE   pid   NOT IN(SELECT pid
               FROM cycle
               WHERE cid = 1); 
              



























