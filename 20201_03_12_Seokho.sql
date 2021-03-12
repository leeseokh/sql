--Seokho 계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성
SELECT*
FORM prod;

--[sem계정]에 있는 prod 테이블의 prod_id, prod_name 두개의
SELECT prod_id, prod_name
FROM prod;

--select1.
--1. lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요.
SELECT*
FROM lprod;
--2. buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
SELECT buyer_id, buyer_name
FROM buyer;
--3. cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
SELECT*
FROM cart;
--4. member 테이블에서 mem_id, mem_pass, mem_name 컬럼만 조회하는 쿼리를 작성하세요
 SELECT mem_id, mem_pass, mem_name 
 FROM member;

--테이블의 에러메시지 보고 해석  모든데이터: *(별표)  ,  ctrl f: 오류찾기 연산 (): 우선순위 변경
--컬럼정보를 보는 방법
1. SELECT *  >> 컬럼의 이름을 알 수 있음.
2. SQL DEVELOPER의 테이블 객체를 클릭하여 정보확인        데이터타입: 문자 숫자 날짜 EX) ( 전체자리 소숫점 NUMBER{7, 2} ) 자바 STRING  = SQL VARCHAR >> 10BYTE 초과 안됨.

숫자, 날짜에서 사용가능한 연산자
--일반적인 사칙연산 + - / *, 우서순위 연산자( )
 
 DESC: 설명하다.
 DESC emp;

 empno : number ; 
 empno + 10    --Expression
 SELECT empno , empno + 10                   >> -- 숫자 날자에 사용가능한 연산자 
 FROM emp;
 
SELECT empno, empno + 10, 10,
        hiredate, hiredate - 10
        FROM emp;
  
  SELECT 
  
  ALIAS : 컬럼의 이름을 변경
        컬럼 : expresion [AS] [별칭명]
SELECT empno, empno + 10 AS empno_plus   -- 컬럼과 ALIAS 구분.., 별칭명은 대문자 소문자표기 "empno"
FROM emp;

NULL : 아직 모르는 값
       0과 공백은 NULL과 다르다.
    ****NULL을 포함한 연산은 결과가 항상 NULL ****
    
    SELECT ename, sal, comm, comm + 100   -- >> 800 + null을 더해도 값은 null
    FROM emp;
  >> NULL값을 다른 값으로 치환해주는 함수
 
 select2
 
 --1. prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오. (단 prod_id > id, prod_name > name
SELECT prod_id AS id , prod_name AS name
FROM prod;

 --2. lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오 (단 lprod_gu > gu, lprod> nm으로 지칭
SELECT lprod_gu AS gu , lprod_nm AS name
FROM lprod;
 
 --3. buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.(단 buyer i_ >바이어 아이디, buyer_name >이름 으로 지칭
SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer;

중요!!
literal : 값 자체
literal 표기법 : 값을 표현하는 방법

 *ㅣ {컬럼, ㅣ 표현식 [AS] [ALIAS], ...}
 숫자: 동일 문자열: " ", ' '

SELECT empno, 10, 'Hello World'  -- '문자열'
FROM emp;

문자열 연산
java : String msg = "Hello" + "world";

SELECT empno + 10, ename || ',Hello' || ',World'  -->> SQL 에서 +는 ||
       --CONCAT(ename, 'Hello',  World')
FROM emp;

아이디 : brown
아이디 : apeach
SELECT 'brown: ' || userid,
CONCAT ('apeach:', userid)
FROM users;

SELECT *
FROM user_tables;  -->> 오라클의 내부 테이블 몰라두 됨.

SELECT table_name
FROM user_tables;

SELECT 'select * from ' ||   table_name  || ';'
FROM user_tables;

CONCAT을 이용해서

SELECT CONCAT ('select * from ', table_name || ';')
FROM user_tables;

CONCAT (CONCAT ('select * from', table_name), ';') ---오류
FROM user_tables;

--부서번호가 10인 직원들만 조회
--부서번호 : dept no
SELECT *
FROM emp
WHERE deptno = 10 ;

--users 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회
SELECT*
FROM users
WHERE userid = 'brown';  -->> 데이터는 대소문자 구분 BROWN은 안됨. " " 표기상 틀림 brown은 콜롬으로 받아들임.
 
 -- emp 테이블에서 부서번호가 20번보다 큰 부서에 속한 직원 조회
 SELECT*
 FROM emp
 WHERE deptno > 20;
 
 -- emp 테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회
 SELECT*
 FROM emp
 WHERE deptno !=20; --> ! : 제외
 

 WHERE : 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다(FILTER)
WHERE 1=1; 참 WHERE 1=2; 거짓으로 출력 안됨.

 -- B로 시작하는 이름 검색
SELECT*
FROM emp
WHERE ename = 'WARD' ;



SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= '81/03/01'; - 81년 3월 1일 보다 크거나 같은 날짜값.

문자열을 날짜 타입으로 변환하는 방법
TO_DATE(날짜 문자열, 날짜 문자열의 포맷팅)
TO_DATE('1981/12/11', 'YYYY/MM/DD')

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1981/12/11', 'YYYY/MM/DD'); -- RRRR/YYYY 년도








 
 
 
 
 
 
 