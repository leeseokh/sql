2021_03_18

--날짜관련 함수
MONTHS_BETWEEN : 인자 - start date, end date, 반환값 : 두 일자 사이의 개월수
ADD_MONTH
인자: date, number 더할 개월수: date로 부터 x개월 뒤의 날짜

NEXT_DAY
인자: date,number(weekday, 주간일자)
date 이후의 가장 첫번째 주간일자에 해닿아는 date를 반환

LAST DAY
인자: date: date가 속한 월의 마지막 일자를 date로 반환.

MONTHS_BETWEEN

SELECT ename, TO_CHAR(hiredate, 'YYYYMMDD HH24:MI:SS')hiredate,
              MONTHS_BETWEEN(SYSDATE, hiredate), -- 입사한 날 부터 지금까지의 개월수
              ADD_MONTHS(SYSDATE, 5), -- 5개월 추가
              ADD_MONTHS(TO_DATE('20210215', 'YYYYMMDD'),-5), --5개월 빼기
              NEXT_DAY(SYSDATE, 6)NEXT_DAY,                                   --오늘부터 처음 나오는 금요일     
              TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01', 'YYYYMMDD')FIRST_DAY
FROM emp;

--SYSDATE를 이용해 SYSDATE가 속한 월의 첫번째날짜 구하기.
--SYSDATE를 이용해 년월까지 문자로 구하기 (2)

--FN3 파라미터로 yyyymm형식의 문자열을 사용 하여 해당 년월에 해당하는 일자 수를 구해보세요
yyyymm=201912 => 31
yyyymm=201911 => 30
yyyymm=201602 => 29 
FN3 LAST_DAY(날짜)

SELECT :YYYYMM, 
        LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')) DT
FROM dual; 



SELECT :YYYYMM, 
        TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD') DT
FROM dual;  --TO_CHAR 이용해 마지막 날 DAY만 뽑기.





형변환
-명시적 형변환
TO_DATE, TO_CHAR, TO_NUMBER
-묵시적 형변환
--1. 위에서 아래로
--2. 단, 들여쓰기 되어있을 경우(자식노드) 자식노드부터 읽는다.
SELECT *
FROM emp
WHERE empno = '7369';

NUMBER :형변환 (CHAR > NUMBER)      9:숫자 0:강제로 0표시 ,:1000자리 표시 .:소수점 L:화폐단위(사용자지역) $:달러단위
SELECT ename, sal, TO_CHAR(sal, 'L0009,999.00') fm_sal --잘 안쓰는 개념. (참고)

NULL처리 함수 : 4가지
NVL(exprl, expr2): expr1이 NULL 값이 아니면 expr1 을 사용하고, expr1이 null 값이면 expr2로 대체해서 사용한다.

if (expr1 = null 
system.out.println(expr2)  -->>자바로 표현
else
system.out.println(expr1)

emp테이블에서 comm 컬럼의 값이 NULL일 경우 0으로 대체 해서 조회하기
SELECT empno, comm, NVL(comm, 0)
FROM emp;

sal+NVL(comm,0)
NVL(sal+comm,0)

NVL2 (expr1, expr2, expr3)

if(expr1 != null)
    System.out.println(expr2);
else
    System.out.println(expr3);
    
comm이 null이 아니면 sal+comm을 반환,
comm이 null 이면 sal을 반환.

SELECT empno, sal, comm, 
       NVL2(comm, sal+comm, sal) nvl2,
       sal + NVL(comm, 0)
FROM emp;

NULL(expr1, expr2)
if(expr1 == expr2)
    System.out.println(null)
else
    System.out.println(expr1)

SELECT empno, sal, NULLIF(sal, 1250)
FROM emp;


COALESCE(expr1, expr2, exrp3 .....)-- 인자들 중에 가장 먼저 등장하는  null이 아닌 인자를 반환
if(expr1 ! = null)
    System.out.println(expr1);
else
    COALESCE(expr2, expr3 .....);
    
if(expr2 ! = null)
    System.out.println(expr2);
else
    COALESCE(expr3, expr4 ....);
    
SELECT empno, sal, comm, COALESCE

null실습 fn4 emp 테이블의 정보를 다음과 같이 (nvl, nvl2, coalesce)

SELECT empno, ename, mgr, NVL(mgr, 9999) mgr_n, NVL2(mgr, mgr, 9999) mgr_n_1, COALESCE(mgr, 9999)mgr_2
FROM emp;

fn5 users테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요  reg_dt가 null일 경우 sysdate를 적용

SELECT userid, usernm, reg_dt, NVL(reg_dt, SYSDATE) n_reg_dt
FROM users
WHERE userid IN('cony', 'sally');

조건분기
1.CASE절
    CASE절 expr1 비교적 (참거짓을 판단 할수 없는 수식) THEN 사용할 값1 >if
    CASE절 expr2 비교적 (참거짓을 판단 할수 없는 수식) THEN 사용할 값2 >else if
    CASE절 expr3 비교적 (참거짓을 판단 할수 없는 수식) THEN 사용할 값3 >else if
    사용할 값                                                      >else
    END
--직원들의 급여를 인상하려고 한다. 
job이 salesman 이면 현재 급여에서 5%
job이 manager 이면 현재 급여에서 10%
job이 president 이면 현재 급여에서 20%
그 이외의 직군으 현재 급여를 유지
   
SELECT ename, job, sal,       --인상된 급여  -- RMxdp , 붙이기
        CASE 
            WHEN job = 'SALESMAN' THEN sal * 1.05
            WHEN job = 'MANAGER' THEN sal * 1.10
            WHEN job = 'PRESIDENT' THEN sal * 1.20
            ELSE sal *1.0
        END
FROM emp;
         
2.DECODE함수 ==> COALESCE 함수 처럼 가변이지 사용
 DECODE(expr1, search1, return1, search2, return2, search3, return3 ...[,default])
if(expr == search1)
    System.out.println(return1)
else if(expr == search2)
    System.out.println(return2)
else if(expr == search3)
    System.out.println(return3)
else 
    System.out.println(default)

DECODE( expr1,
            search1, return1
             ...[,default])
SELECT ename, job, sal, 
DECODE(job,
            'SALESMAN', sal * 1.05,
            'MANAGER', sal * 1.10,
            'PRESIDENT',  sal * 1.20,
            sal * 1.0) sal_Bonus
FROM emp;

CONDITION1 문제

emp 테이블을 이용하여 deptno에 따라 부서명으로 변경 해서 다음과 같이 조회되는 쿼리를 작성하세요.
10 ->'ACCOUNTING'
20 ->'RESEARCH'
30 ->'SALES'
40 ->'OPERATIONS'
기타 다른 값 ->'DDIT'

SELECT empno, ename, deptno,
CASE
    WHEN deptno = 10 THEN 'ACCOUNTING'
    WHEN deptno = 20 THEN 'RESEARCH'
    WHEN deptno = 30 THEN 'SALES'
    WHEN deptno = 40 THEN 'OPERATIONS'
    ELSE 'DITT'
    END dname
FROM emp;

condi2
emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요 (생년을 기준으로 하나 여기선 입사년도 기준으로)
짝수년도 대상자

SELECT MOD(1981, 2)
FROM dual;
SELECT empno, ename, hiredate, 
CASE
    WHEN
        MOD(TO_CHAR(hiredate, 'yyyy'),2)=
        MOD(TO_CHAR(SYSDATE, 'yyyy'),2) THEN '건강검진 대상자'  --1일 구하려한것.
    ELSE '비건강검진 대상자'
    END CONTACT_TO_DOCTOR          --DECODE로도 
FROM emp;

condition3
users 테이블을 이용하여 reg_dt에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요. reg_dt 를 기준으로

SELECT userid, usernm, reg_dt,
    CASE
        WHEN
         MOD(TO_CHAR(reg_dt, 'yyyy'),2)=
         MOD(TO_CHAR(SYSDATE, 'yyyy'),2) THEN '건강검진 대상자' 
         ELSE '비건강검진 대상자'
         END CONTACT_TO_DOCTOR 
FROM users
WHERE userid IN('brown', 'cony', 'sally', 'moon', 'james');

GROUP FUNCTION: 여러행을 그룹으로 하여 하나의 행으로 결과값을 반환하는 함수
-부서별 급여 높은순        >
-부서별 평균 급여          >     >  그룹기준이 중요
-부서별 조직원수           >
그룹 함수
AVG: 평균 COUNT: 건수 MAX: 최대값 MIN:최소값 SUM:합

SELECT deptno,
               MAX(sal), MIN(sal), ROUND(AVG(sal), 2),
               SUM(sal),
               COUNT(sal), --그룹핑 된 행중에 sal 컬럼의 값이 NULL이 아닌 건수
               COUNT(mgr),--그룹핑 된 행중에 mgr컬럼의 값이 null이 아닌 행의 건수
               COUNT(*) --그룹핑 된 행 건수
FROM emp
GROUP BY deptno;

-그룹바이를 사용하지 않을 경우 테이블의 모든 행을 하나의 행으로 그룹핑한다.
SELECT deptno,
COUNT(*), MAX(sal), MIN(sal), SUM(sal)
FROM emp
GROUP BY deptno;
-그룹바이절에 나온 컬럼이 SELECT절에 그룹함수가 적용되지 않은채로 기술되면 에러

SUM(NVL)(comm), 0)),
NVL(SUM)(comm),0)
FROM emp
HAVING COUNT(*)>= 4;

그룹함수
그룹함수에서 NULL컬럼은 계산에서 제외된다.
GROUP BY 절에 작성된 컬럼 이외의 컬럼이 SELECT절에 올 수 없다.
WHERE절에 그룹 함수를 조건으로 사용할 수 없다.
HAVING절 사용
WHERE SUM(sal) >3000 (x)
HAVING SUM(sal) > 3000(o)

그룹1 문제
직원중 가장 높은급여
직원중 가장 낮은급여
직원의 급여 평균
직원의 급여합
직원중 급여가 있는 직원의수 널제외
직원중 상급자가 있는 직원의 수 널제외
전체직원의 수

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal)), SUM(sal),
FROM emp
GROUP BY ;

emp테이블을 이욯애




