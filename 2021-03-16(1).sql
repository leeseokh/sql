--  2021_03_15
--  입사일자가 1982년 1월 1일 이후인 모든 직원 조회 하는 SELECT 쿼리를 작성하세요

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01' , 'YYYY/MM/DD'); -- YY 서버의 날짜 앞 년도. YY 20YY

-- WHERE절에서 사용 가능한 연산자 
--(비교 =, !=, >, <, ...)

비교대상 BETWEEN AND 비교대상의 허용 시작값 AND 비교대상의 허용 종료값
EX) 부서번호가 10번에서 20번 사이의 속한 직원들만 조회
SELECT *
FROM emp
WHERE deptno BETWEEN 10 AND 20; 

emp 테이블에서 급여가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
조건 sal>=1000   sal<=2000     --참 앤 참 >참 , 참 앤 거짓 > 거짓 , 참 또는 거짓 > 참

SELECT *
FROM emp
WHERE sal BETWEEN 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >=1000
AND   sal <=2000
AND   deptno = 10;

조건에 맞는 데이터 조회하기 
--emp 테이블에서 입사일자가 1982년 1월1일 이후부터 1983년 1월1일 이전인 사원의 ename, hiredate 데이터를 조회하는 쿼리를 작성하시오. (between 사용)
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1982/01/01' , 'YYYY/MM/DD') AND TO_DATE('1983/01/01' , 'YYYY/MM/DD');

BETWEEN AND: 포함(이상, 이하) > 초과, 미만의 개념은 비교연산자(>, <)를 사용.

IN 연산자
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, 대상자와 비교할 값3.....)
deptno IN(10, 20) ==> deptno 값이 10이나 20번이면 TRUE;

SELECT *
FROM emp
WHERE deptno = 10 
   OR deptno = 20;

SELECT *
FROM emp
WHERE 10 IN (10, 20);  >> --10은 10과 같거나 20과 같다  참인지 거짓인지 물어보는거임. 10과10임 참임으로 데이터가 다나옴.(OR)
= WHERE dept 10 OR dept 20;

users 테이블에서 userid가 brown, cony, sally인 데이터를 다음과 같이 조회 하시오. (IN 연산자 사용)

SELECT userid AS 아이디, user AS 이름, alias AS 별명
FROM users
WHERE userid IN ('brown', 'cony', 'sally');   --문자열 ' '!!!

LIKE 연산자 : 문자열 매칭 조회
게시글: 제목 검색, 내용 검색 
       제목에 [맥북에어]가 들어가는 게시글만 조회
       1. 얼마 안된 맥북에어 팔아요
       2. 맥북에어 팔아요
       3. 팝니다 맥북에어  --맥북에어 키워드를 검색할 때 사용 LIKE 연산자
       
     %: 0개 이상의 문자
     -: 1개의 문자
     c%
     SELECT *
     FROM users
     WHERE userid LIkE 'c%';  -- userid가 c로 시작하는 모든 사용자.

userid가 c로 시작하면서 c 이후에 3개의 글자가 오는 사용자 ??
     SELECT *
     FROM users
     WHERE userid LIkE 'c___';  --  ( - 3개)

userid에 l이 들어가는 모든 사용자 조회
SELECT *
FROM users
WHERE userid LIKE '%l%';

조건에 맞는 데이터 조회하기 - where4
member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오.

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

member 테이블에서 이름에 [이]자가 들어가는 모든 사람의 mem_id, mem_name 조회하는 쿼리를 작성하시오.

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

테이블: 게시글
제목 컬럼: 제목
SELECT* 
FROM 게시글
WHERE 제목 LIKE '%맥북에어%';
OR 내용 LIKE '%맥북에어%';  >> 제목 또는 내용이 들어간.

IS (NULL 비교)
emp테이블에서 comm 컬럼의 값이 NULL인 사람만 조회

SELECT*
FROM emp
WHERE comm IS NULL; >< IS NOT NULL

emp 테이블에서 매니저가 없는 직원만 조회

SELECT empno
FROM emp
WHERE mgr IS NULL;

BETWEEN AND, IN, LIKE, IS

논리 연산자: AND, OR, NOT
AND: 두가지 조건을 동시에 만족시키는지 확인할 때
     조건1 AND 조건2
OR: 두가지 조건중 하나라도 만족 시키는지 확인할 때
     조건1 OR 조건2
NOT: 부정형 논리 연산자, 특정 조건을 부정
     mgr IS NULL: mgr 컬럼의 값이 NULL인 사람만 조회
     mgr IS NOT NULL: mgr 컬럼의 값이 NULL이 아닌사람만 조회
     
     -emp 테이블에서 mgr의 사번이 7698이면서 sal값이 1000보다 큰 직원만 조회;
SELECT*
FROM emp
WHERE mgr = 7698 AND sal > 1000;     --조건의 순서는 결과와 무관하다     
WHERE mgr = 7698 OR sal > 1000;      --조건을 하나만 만족해도 모두 출력.
AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다.
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다.
NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다.
  EX) IS NOT, NOT IN, NOT LIKE

SELECT *
FROM emp
WHERE deptno NOT IN (30); -- 직원의 부서번호가 30번이 아닌 직원들
WHERE deptno ! = 30;

SELECT *
FROM emp
WHERE ename 'S%';

SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';
     
NOT IN 연산자 사용시 주의점: 비교값중에 NULL이 포함되면 데이터가 조회되지 않는다.  ★ 시험문제
SELECT *
FROM emp
WHERE mgr IN (7698, 7839, NULL);
==> mgr = 7698 OR mgr = 7839 OR mgr = NULL

WHERE mgr NOT IN (7698, 7839, NULL); -->데이터가 안나옴.  
==> mgr != 7698 AND mgr != 7839 AND mgr != NULL  -- mgr! = NULL은 항상 거짓. 참, 거짓이 의미가 없음.

mgr = 7698 ==> mgr ! =7698
OR         ==> AND

-where7
emp테이블에서 job이 SALESMAN이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 조회하세요
SELECT*
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD') AND job = 'SALESMAN';

-where8
emp테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 ( IN, NOT IN 사용금지)
SELECT*
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD') AND deptno! = 10;
                                                         = deptno NOI IN(10);
where-10                                                    
emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년6월1일이후인 직원의 정보를 다음과 같이 조회하세요( 부서는 10. 20 .30 만 있다고 가정하고 IN 연사자 사용)
SELECT*
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD') AND deptno IN (20, 30);

where-11
SELECT*
FROM emp
    WHERE hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD') OR job = 'SALESMAN';

where-12 풀면 좋고 못풀어도 괜찮은 문제.
emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요.
SELECT*
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';
where-13
emp테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회 하세요.(LIKE 없이) -데이터 파일에 대해서..고민
SELECT*
FROM emp
WHERE job = 'SALESMAN' OR
empno BETWEEN 7800 AND  7899;


2021_03_16

SELECT *
FROM emp
WHERE SUBSTR(empno, 1, 2)='78' OR
    job = 'SALESMAN';                    --> 참신!
    
SELECT empno, ename, job, mgr, hiredate, sal, comm, deptno
FROM emp
WHERE job = 'SALESMAN' 
    OR empno BETWEEN 7800 AND 7899
    OR empno BETWEEN 780 AND 789
    OR empno BETWEEN 78 AND 78;          -->> 베스트!
    
    AND OR 연산자 우선순위 AND가 높다.
    ==> 헷갈리면 ()를 사용하여 우선순위를 조정하자
    
    SELECT *
    FROM emp
    WHERE ename = 'SMTH' OR (ename = 'ALLEN' AND job = 'SALESMAN')
     ==>> 직원의 이름이 ALLEN 이면서 job이 SALESMAN 이거나 :
     직원의 이름이 SMTH 인 직원 정보를 조회
    SELECT *
    FROM emp
    WHERE (ename = 'SMTH' OR ename = 'ALLEN') AND job = 'SALESMAN'
직원의 이름이 ALLEN 이거나 SMTH 이면서 job이 SALESMAN 인 사람

where14 
emp 테이블에서
1. job이 SALESMAN 이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인 직원 정보
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR (empno LIKE '78%' AND hiredate >= TO_DATE('1981/06/01' , 'YYYY/MM/DD'));

-WHERE절 기초 끝-




