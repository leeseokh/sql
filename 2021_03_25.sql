실습 쿼리 5)
cycle, product 테이블을 이용하여 cid=1인 고객이 예음하지 않는 제품을 조회하는 쿼리를 작성하세요

SELECT *
FROM product
WHERE   pid   NOT IN(SELECT pid
               FROM cycle
               WHERE cid = 1); 
 --2021_03_25--

실습 커리 6)
cycle 테이블을 이용하여  cid=1인고객이 애음하는 제품중 cid=2인 고객도 애음하는 제품의 애음정보를 조회하는  쿼리를 작성하세요.

SELECT *
FROM cycle
WHERE cid =1  
AND pid     IN(SELECT pid 
             FROM cycle
             WHERE cid = 2) ;
             
customer, cycle, product 테이블을 이용하여 cid = 1인 고객이 애음하는 제품중 cid=2 인 고객도 애음하는 제품의 애음정보를 조회하고
고객명과 제품명까지 포함하는 쿼리를 작성하세요.

SELECT  c.cycle, t.customer, p.product
FROM cycle c, customer t, product p
WHERE c.cid =1  
AND c.pid = p.pid    
AND c.cid =t.cid 
AND  pid IN(SELECT   pid 
                    FROM cycle
                    WHERE c.cid = 2) ;
                    
EXISTS: 서브쿼리 연산자: 단항
IN :WHERE 컬럼 EXPRESSION IN (값1, 값2, 값3 ...)
EXISTS :WHERE EXISTS(서브쿼리)
>> 서브쿼리의 실행 결과로 조회되는 행이 있으면 TRUE, 없으면 FALSE
EXISTS 연산자와 사용되는 서브쿼리는상호연관 비상호연관 서브쿼리 둘다 사용 가능하지만 행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다.

서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행되지 않고 효율적으로 일을 끊어 버린다.
서브쿼리가 1000건이라 하더라도 10번째 행에서 EXISTS 연산을 만족하는 행을 발견하면 나머지9999건 정도의 데이터는 확인하지 않는다.

==매니저가 존재하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT*
FROM emp e
WHERE EXISTS (SELECT empno
              FROM emp m
              WHERE e.mgr = m.empno);

SELECT*
FROM emp e
WHERE EXISTS (SELECT *
              FROM dual);
SELECT*
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM emp m
              WHERE e.mgr = m.empno);
SELECT*
FROM emp e
WHERE EXISTS (SELECT empno
              FROM dual);

SELECT*
FROM dual
WHERE EXISTS (SELECT 'X'
              FROM emp
              WHERE deptno = 10 );    --존재여부는 EXISTS 연산자가 좋음.

서브쿼리 실습9)
cycle , product 테이블을 이용하여 cid = 1 인 고객이 애음하는 제품을 조회하는 쿼리를  EXISTS 사용해 풀기
pid | pnm

SELECT *
FROM product
WHERE EXISTS ( SELECT *
               FROM cycle
               WHERE cid = 1
               AND product.pid = cycle.pid);  -- 여기 킵
반대             
SELECT *
FROM product
WHERE NOT EXISTS ( SELECT 'X'
               FROM cycle
               WHERE cid = 1
               AND product.pid = cycle.pid);  -- 여기 킵

집합
UNION ==> 합집합 a, u  U  a, c = a u c

UNION ALL ==> 중복을 허용하는 합집합   a u U a c  = a, a, c, u
집합연산 : 행을 확장 : 위 아래 집합의 콜론의 개수와 타입이 일치해야한다.
조인 : 열을 확장 > 양옆

intersect 교집합 공통

minus 차집합  한집합

UNION 두개의 셀렉 결과를 하나로 합침. 단 중복은 제거

SELECT empno, ename ,NULL 
FROM emp
WHERE empno IN(7369, 7499)

UNION
----------------------------------------------------------
SELECT empno, ename, NULL
FROM emp
WHERE empno IN(7369, 7521);

UNION ALL : 중복제거 로직 없어 속도 빠름, 합집합 혀라는 집합간 중복이 없다는 것을 알경우 UNION 연산자보다 UNION ALL 연산자가 유리하다.

SELECT empno, ename ,NULL 
FROM emp
WHERE empno IN(7369, 7499)

UNION ALL
----------------------------------------------------------
SELECT empno, ename, NULL
FROM emp
WHERE empno IN(7369, 7521);

SELECT empno, ename ,NULL 
FROM emp
WHERE empno IN(7369, 7499)

INTERSECT : 한쪽 집합에서 다른 한쪽 집합을 제외한 나머지 요소들으 반환

SELECT empno, ename, NULL
FROM emp
WHERE empno IN(7369, 7521);
----------------------------------------------------------
SELECT empno, ename ,NULL 
FROM emp
WHERE empno IN(7369, 7499)

MINUS

SELECT empno, ename, NULL
FROM emp
WHERE empno IN(7369, 7521);

교환법칙
A U B == B U A (UNION, UNION ALL) 주로 씀.
A ^ B == B ^ A
A - B != B - A  => 집합이 순서에 따라 결과가 다라질 수 있다(주의)

집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 칼럼 이름을 첫번째 집합의 컬럼을 따른다.
SELECT empno e, ename ena -- 여기만 줘도 아래까지 통합
FROM emp
WHERE empno IN(7369, 7499)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7521);

2.집합연산의 결과를 정렬하고 싶으면 가장 마지막 뒤에 ORDER BY 써주면 된다.
개별 집합에 ORDER BY 를 사용할 경우 에러 단 인라인뷰를 사용시 괜찮다.-일반적이지 않음.
SELECT empno e, ename ena 
FROM emp
WHERE empno IN(7369, 7499)
UNION
SELECT empno, ename
FROM emp
WHERE empno IN(7369, 7521)
ORDER BY e;

3.중복된 제거 된다(예외 UNION ALL)

4.(참고) 이전버전 그룹연산 하면 기본적으로 오름차순

DML
        SELECT
        데이터 신규입력 : INSERT
        기존 데이터 수정: UPDATE
        기존 데이터 삭제: DELETE

만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다.
INSERT 문법
INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3...)
INSERT INTO VALUES  (값1, 값2, 값3...)
INSERT INTO 테이블명 ({column,}) VALUES ({value,})

INSERT INTO dept (deptno, dname, loc)
            VALUES(99, 'ddit','daejeon');

DESC dept;

INSERT INTO emp (empno, ename, job) 
VALUES (9999, 'brown', 'RANGER'); --정보 넣기

SELECT*
FROM emp;--확인

INSERT INTO emp (empno, ename, job, hiredate, sal, comm) 
VALUES (9998, 'sally', 'RANGER', TO_DATE('2021-03-24', 'YYYY-MM-DD'), 1000, NULL );    --SYSDATE OR TO_DATE('2021-03-24', 'YYYY-MM-DD

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리 

INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDIT8', '대전' FROM dual

UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경

UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2 = 값2, 컬럼명3= 값3...
WHERE ;

SELECT *
FROM dept;

주의!! WHERE 절이 누락 됐는지 확인해야함. 모든 테이블이 변경됨.
부서번호 99번 부서정보를 부서명=대덕IT로,  loc는 영민 빌딩으로 변경

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩' 
WHERE deptno = 99;




