3-17
WHERE deptno = 10
AND sal > 500

SELECT ROWNUM a
FROM
   (SELECT empno, ename
   FROM emp)
     WHERE sal > 500;

     2021_03_17

     single row function
    --단일 행 기준 작업하고, 행당 하나의 결과를 반환
    --특정 컬럼의 문자열 길이 : lenght(ename)

     multi row function
     --여러행을 기준으로 작업하고 하나의 결과를 반환 
     --그룹함수
     count, sum, avg

--    함수명을 보고
--    : 파라미터가 어떻게 들어갈까? .
--    : 몇개의 파라미터가 들어갈까
--    : 변환되는 값을 무엇일까?

     함수
     character 
     대소문자: LOWER
     UPPER : 
     INTCAP: 첫글자를 대문자로만

     SELECT ename, LOWER(ename), LOWER('TEST') SUBSTR(ename, 1, 3)  SUBSTR(ename, 2

     )


     --입력값 ename
     FROM emp;

     SELECT * |colum 
     FROM emp;
     문자열 조작
     CONCAT:
     SUBSTR:부분의 연자
     LENGTH: 
     INSTR
     LPAD| RPAD 
     TRIM
     REPLACE : 치환

     DUAL table
     sys 계정에 있는 테이블
     누구나 사용 가능
     DUMMY 컬럼 하나만 존재하며 값은 'X'갑이며 데이터는 한 행만 존재
     데이터와 관련없이 함수 실행, 시퀀스 실행, merge 문에서, 데이터 복제시(connect by level)

     SELECT*
     FROM dual;

     SELECT LENTH
     FROM emp;

     SINGLE ROW FUNCTION : WHERE절에서도 사용 가능
     emp 테이블에 등록된 직원들 중에 직원의 이름의 길이가 5글자를 초과하는 직원만 조회

     SELECT *
     FROM emp
     WHERE LENGTH(ename) >5;

     SELECT*
     FROM emp
     WHERE LOWER(ename) = 'smith'; --권장하지 않음 14번의 ename 검색

     SELECT*
     FROM emp
     WHERE ename = UPPER('smith'); --권장 1번만 실행


     오라클 문자열 함수

SELECT 'HELLO'|| ',' || 'WORLD', 
       CONCAT('HELLO', CONCAT(', ' , 'WORLD')) CONCAT,
       SUBSTR('HELLO, WORLD', 1, 5) SUBSTA,
       LENGTH('HELLO, WORLD') LENGTH,
       INSTR('HELLO, WORLD', 'o') INSTR,
       INSTR('HELLO, WORLD', 'o', 6)INSTR2,
       LPAD('HELLO, WORLD', 15, '-')LPAD,
       RPAD('HELLO, WORLD', 15, '-')RPAD,
       REPLACE('HELLO, WORLD', 'o','x')REPLACE,
       TRIM --공백을 제거, 문자열의 앞과, 뒷부분에 있는 공백만
       TRIM(' HELLO, WORLD ') TRIM,
       TRIM('D' FROM 'HELLO, WORLD') TRIM
FROM dual;

    NUMBER 숫자조작 ROUND - 반올림
    TRUNC - 내림, MOD - 나눗셈의 나머지

(피재수, 재수)
SELECT MOD (10, 3)
FROM dual;

SELECT 
ROUND(105, 54, 1)round1, --반올림 결과가 소수점 첫번째 자리까지 나오도록:소수점 둘째 자리에서 반올림 :105.5
ROUND(105, 55, 1)round2, --반올림 결과가 소수점 첫번째 자리까지 나오도록:소수점 둘째 자리에서 반올림 :105.6
ROUND(105, 55,0)round3,--반올림 결과가 첫번째 자리까지 나오도록:소수점 첫째 자리에서 반올림 :106
ROUND(105, 55, -1)round4--반올림 결과가 두번째 자리(십의자리) 까지 나오도록:정수 첫째 자리에서 반올림:110
FROM dual;

SELECT 
TRUNC(105,54 , 1) trunc1,  --절식 결과가 소수점 첫번째 자리까지 나오도록:소수점 둘째 자리에서 반올림 :105.5
TRUNC(105,55 , 1) trunc2,  --절식 결과가 소수점 첫번째 자리까지 나오도록:소수점 둘째 자리에서 반올림 :105.5
TRUNC(105,55 , 0)trunc3,  --절식 결과가 첫번째 자리까지 나오도록:소수점 첫째 자리에서 반올림 :105
TRUNC(105,55 , -1)trunc4,  --절식 결과가 두번째 자리(십의자리) 까지 나오도록:정수 첫째 자리에서 반올림:100
FROM dual;

SELECT empno, ename, sal을 1000으로 나눴을 때의 몫, sal을 1000으로 나눴을 때의 나머지
FROM emp;

SELECT empno, ename, sal, TRUNC(sal/1000), MOD(SAL, 1000)
FROM emp;

날짜 <--> 문자
서버의 현재 시간 SYSDATE
LENGTH('TEST')
SYSDATE

SELECT SYSDATE
FROM dual;

SELECT SYSDATE +1/24  -- 1시간 + SELECT SYSDATE +1/24/60 -- 60분 단위로 쪼갠다
FROM dual;

date 실습 fn1
--1.2019년 12월 31일을 date형으로 표현
SELECT TO_DATE('2019/12/31' , 'YYYY/MM/DD') LASTDAY,
       TO_DATE('2019/12/31' , 'YYYY/MM/DD') -5 LASTDAY_BEFORE5,
       SYSDATE, 
       SYSDATE  -3
FROM dual;

--2.2019년 12월 31일을 date형으로 표현 하고 5일 이전 날짜


--3.현재날짜
SELECT SYSDATE 
FROM dual;
--4.현재 날짜에서 3일전 값.
SELECT SYSDATE 
FROM dual;

TO_DATE :인자-문자, 문자의 형식
TO_CHAR :인자-날짜, 문자의 형식

SELECT TO_CHAR (SYSDATE, 'YYYY-MM-DD--')
FROM dual;

-- 주간요일  0이 일요일 1-월요일 2-화요일 ... 6-토요일

SELECT SYSDATE, TO_CHAR(SYSDATE, 'IN')
FROM dual;
SELECT SYSDATE, TO_CHAR(SYSDATE, 'D')
FROM dual;

date FORMAT
YYYY: 4자리년도
MM: 2자리월
DD: 2자리 일자
D: 주간 일자(1~7)
IW: 주차(1~53)
HH, HH12: 2자리 시간(12시간 표현)
HH24: 2자리 시간 (24시간 표현)
MI: 2자리 분
SS: 2자리 초

--오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오.
1. 년-월-일
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD' )
FROM dual;

2. 년-월-일 시간 (24)-분-초
SELECT SYSDATE, TO_CHAR(SYSDATE, 'YYYY-MM-DD-HH24-MI-SS' )
FROM dual;

3. 일-월-년
SELECT SYSDATE, TO_CHAR(SYSDATE, 'DD-MM-YYYY' )DT_DD_YYYY,
FROM dual;

TO_CHAR를 사용.(날짜 , 포맷팅 문자열) 
SELECT  TO_CHAR

SELECT SYSDATE, TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYYMMDD'),'YYYYMMDD')
FROM dual; --오류뜬다.