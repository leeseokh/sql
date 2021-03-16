데이터 정렬
TABLE 객체에는 데이터를 저장 조회시 순서를 보장하지 않음.
-보편적으로 데이터 입력순
-데이터가 항상 동일한 순서로 조회되는 것 보장하지 않음.
-데이터가 삭제되고, 다른 데이터가 들어 올 수도있음.

ORDER BY 
ASC :오름차순 DESC : 내림차순

ORDER BY {정렬기준 컬럼 OR alias OR 컬럼번호} [ASC OR DESC]...
ORDER by ename 등..

데이터 정렬이 필요한 이유?
--1. table 객체는 순서를 보장하지 않는다. 
==> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서를 조화가 되지 않을 수도 있다.
--2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다. 
==> 게시판의 게시글은 보편적으로 가장 최신글이 처음에 나오고, 가장 오래된 글이 맨 밑에 있다.

SQL에서 정렬 : ORDER BY ==> SELECT -> FROM -> [WHERE] -> ORDER BY
   ORDER BY 컬럼명 멀럼 인덱스(순서) 별칭[정렬순서]
   정렬순서 : 기본 ASC(오름차순) DESC(내림차순)

SELECT *
FROM emp
ORDER BY ename;

A-> B -> C -> [D] -> Z
1 > 2 > 3 ...->100 : 오름차순 ename ASC ..  ASC=> DEFAULT 자동.
100-> 99.... -> 1  : 내림차순 DESC => 명시

SELECT *
FROM emp
ORDER BY job DESC, sal ASC;

정렬 : 컬럼명이 아니라 select 절의 컬럼 순서 (index)

SELECT ename, empno, job
FROM emp
ORDER BY 2;  --> 2번째 직원번호만 정렬

SELECT ename, empno, job, mgr AS m
FROM emp
ORDER BY m

orderby1
dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록  쿼리를 작성하세요.
dept 테이블의 모든 정보를 부서 위치로 내림차수 정렬로 조회되도록 쿼리를 작성하세요.

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

orderby2
emp 테이블에서 상여(comm) 정보가 있는 사람들만 조회하고, 상여를 많이 받는 사람이 먼저 조회 되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요 (상여가 0인 사람은 상여가 없는 것으로 간주)

SELECT *
FROM emp
WHERE comm IS NOT NULL
 AND comm ! = 0 ORDER BY empno DESC

orderby3
emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job)순으로 오름차순 정렬하고, 직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하시오.

SELECT *
FROM emp
WHERE mgr IS NOT NULL 
ORDER BY job, empno DESC;

orderby4
emp 테이블에서 10번부서(deptno) 혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는 사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리 작성

SELECT *
FROM emp
WHERE deptno IN(10, 30) 
AND sal > 1500
ORDER BY ename DESC;

페이징 처리(게시글) ==> 정렬의 기준? (일반적으로는 게시글의 작성일시 역순) ★
페이징 처리: 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을때 원하는 페이지의 데이터만 가져오는 방법
(만약 페이징 처리를 안할시 400건을 다 조회하고 필요한 20것만 사용하는 방법--> 전체조회(400))
(400건의 데이터중 원하는 페이지의 20건만 조회 --> 페이징 처리(20)
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈

ROWNUM: 행 번호를 부여하는 특수 키워드 (오라클에서만 제공)
  *제약사항: ROWNUM 은 WHERE 절에서도 사용 가능.
        단  ROWNUM 의 사용을 1부터 사용하는 경우에만 사용 가능
         WHERE ROWNUM BETWEEN 1 AND 5 ==> 사용 가능
         WHERE ROWNUM BETWEEN 6 AND 10 ==> 사용 불가능
         WHERE ROWNUM = 1;  가능
         WHERE ROWNUM = 2;  불가능
         WHERE ROWNUM < 10; 가능 10이하 (1포함.)
         WHERE ROWNUM > 10; 불가능 11부터
          전체 데이터: 14건
          페이지 사이즈: 5건
          1번째 페이지: 1~5
          2번째 페이지: 6~10
          3번째 페이지: 11~15(14)
         
SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;    
        
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 5 ;

         SQL 절은 다음의 순서로 실행된다
         FROM  > WHERE > SELECT -> ORDER BY
         ORDER BY 와  ROWNUM 을 동시에 사용하면 정렬된 기준으로 ROWNUM 이 부여되지 않는다.
         SELECT 절이 먼저 실행되므로 ROWNUM 이 부여된 상태에서 ORDER BY 절에 의해 정렬이 된다.

인라인 뷰
ALIAS
-- 인라인 뷰 --
SELECT *
FROM (SELECT empno, ename FROM emp);

SELECT ROWNUM, empno, ename   
FROM (SELECT empno, ename 
      FROM emp 
      ORDER BY ename);  
      WHERE BETWEEN 1 AND 6 ;  --1이 포함 해야함.

SELECT *
FROM
(SELECT ROWNUM, empno, ename   
 FROM (SELECT empno, ename 
      FROM emp 
      ORDER BY ename));       -- 여기서 rn이란 ALIAS를 넣으면 아래로 

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename   
 FROM (SELECT empno, ename 
      FROM emp 
      ORDER BY ename))
WHERE rn BETWEEN 11 AND 15;  --1 부터 안 넣어도 실행이 가능. 

셀렉절이 오더바이보다 먼저 실행되서 해결하려고 한것.,

pazeSize : 5건
1. page : rn BETWEEN 1 AND 5;
2. page : rn BETWEEN 6 AND 10;
3. page : rn BETWEEN 11 AND 15;
n. page : rn BETWEEN (n-1)*pageSize + 1 AND (n-1*)pageSize;

rn BETWEEN (page - 1)*pageSize + 1 AND page*pageSize ;

rn BETWEEN (:page - 1)*:pageSize + 1 AND :page*:pageSize ;


SELECT *
FROM
(SELECT ROWNUM rn, empno, ename   
 FROM (SELECT empno, ename 
      FROM emp 
      ORDER BY ename))
WHERE rn BETWEEN (:page - 1)*:pageSize + 1 AND :page*:pageSize ;

row-1
emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요 (정렬 없이 진행.)

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

row-2
ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해 보세요

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 20;

row3
emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요.

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM (
SELECT empno, ename
FROM emp
ORDER BY ename))
WHERE rn BETWEEN 11 AND 20;

질문 SELECT ROWNUM, emp.empno
     FROM emp;  -- emp AS e 안됌 emp e 이렇게 별칭짓기.  SELECT e 













