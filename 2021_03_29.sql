20210329

job, ename 컬럼으로 구성된 IDX_emap_03 인덱스 삭제

CREATE 객체타입 객체명
DROP 객체타입, 객체명;

CREATE INDEX idx_emp4 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

SELECT ROWID, dept.*
FROM dept;

CREATE INDEX idx_dept_01 ON dept(deptno);

SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
    AND emp.empno = 7788;
    
emp
1. table full access
2. idx_emp_01
3. idx_emp_02
4. idx_emp_04

dept
1. table full access
2. idx_dept_01
16가지


INDEX Access
-소수의 데이터를 조회할 때 유리 (응답속도가 필요할 때)
index를 사용하는  Input/Output Single Block I/O
-다량의 데이터를 인댁스로 접근할 경우 속도가 느리다

Table Access
테이블의 모든 데이터를 읽고서 처리를 해야하는경우 인댁스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
-I/O 기준이 multi block

DDL ( 테이블에 인덱스가 많다면)

테이블의 빈공간을 찾아 데이터를 입력한다

인덱스의 구성 컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장

인덱스는 B*트리 구조이고, root node 부터 leaf node 까지의 depth가 항상 같도록 밸런스를 유지한다

즉 데이터 입력으로 밸런스가 무너질경우 밸런스를 맞추는 추가 작업이 필요

2-4까지의 과정을 각 인덱스 별로 반복한다


인덱스가 많아 질 경우 위 과정이 인덱스 개수 만큼 반복 되기 때문에 UPDATE, INSERT, DELETE 시 부하가 커진다
인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터 변경시 부하가 생긴다
테이블에 과도한 수의 인덱스를 생성하는 것은 바람직 하지 않음
하나의 쿼리를 위한 인덱스 설계는 쉬움
시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계하는 것이 힘듬

달력만들기
주어진것: 년월 6자리 문자열 ex>202103
만들것: 해당 년월에 해당하는 달력 (7칸짜리 테이블)

20210301 -날짜, 문자열
20210302
20210303
.
.
.
20211031

'202103' ==> 31
--LEVEL은 1부터 시작.
SELECT SYSDATE, LEVEL
FROM dual
CONNECT BY LEVEL <=10;

'202103' ==> 31

SELECT TO_CHAR(LAST_DAY (TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;

LEVEL은 1 부터 시작
SELECT DT, D, IW
FROM
(SELECT (TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt
        TO_CHAR(TO_DATE(YYYYMM,'YYYYMM') + (LEVEL -1), 'D') d
        TO_CHAR(TO_DATE(YYYYMM,'YYYYMM') + (LEVEL -1), 'IW') iw
FROM dual
CONNECT BY LEVEL  <= TO_CHAR(LAST_DAY (TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'));

주차:IW
주간요일:D
일요일이면 dt-아니면 null, 월요일이면 dt- 아니면 null
월요일이면 dt-아니면 null, 화요일이면 dt- 아니면 null
SELECT dt, d,
DECODE(4, 1, dt)sun, (SELECT(d, 2, dt)mon,
DECODE(4, 3, dt)tue, (SELECT(d, 4, dt)wen,
DECODE(4, 5, dt)thu, (SELECT(d, 6, dt)fri,
DECODE(4, 7, dt)sat,
-----------------------------------------------------------------------------
SELECT DECODE(d, 1, iw+1, iw),
       MIN(DECODE(d, 1, dt)) sun, MIN(DECODE(d, 2, dt)) mon,  
       MIN(DECODE(d, 3, dt)) tue, MIN(DECODE(d, 4, dt)) wed,  
       MIN(DECODE(d, 5, dt)) thu, MIN(DECODE(d, 6, dt)) fri,  
       MIN(DECODE(d, 7, dt)) sat
FROM 
    (SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1) dt,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'D') d ,
           TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (LEVEL-1), 'IW') iw
    FROM dual
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY DECODE(d, 1, iw+1, iw)
ORDER BY DECODE(d, 1, iw+1, iw);
-----------------------------------------------------------------------------

계층쿼리: 조작도, BOM, 게시판( 답변형 게시판)
            -데이터의 상하 관계를 나타내는 쿼리
SELECT empno, ename, mgr
FROM emp;

사용방법:1. 시작위치를 설정
        2. 행과 행의 연결 조건을 기술

SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839       -- >>> 7566 존스부터 
CONNECT BY PRIOR empno = mgr;


PRIOR - 이전의, 이미 읽은 데이터
CONNECT BY 내가 읽은 행의 사번 = 앞으로 읽을 행의 mgr컬럼
CONNECT BY PRIOR empno = mgr;

KING의 사번 = mgr 컬럼의 값이 KING의 사번인 녀석
empnp = mgr

SELECT LPAD('TEST', 1*10, '*')
FROM dual;
        
계층쿼리 방향에 따른 분류
상향식: 최하위 노드에서 자신의 부모를 방문 
하향식: 최상위 노드에서 모든 자식 노드 방문

상향식쿼리
SMITH부터 시작해 KIMG 까지 방문.

SELECT empno, ename, mgr
FROM emp
START WITH empno = 7369
CONNECT BY PRIOR mgr = empno;
CONNECT BY SMITH의 mgr 컬럼값 = 내 앞으로 읽을 행 empno

SELECT *
FROM dept_h;

h_1) 최상위 노드부터 라프 노드까지 탐색하는 계층쿼리 작성
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, LEVEL
FROM dept_h
START WITH deptcd = 'dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

h_2) 정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd  -- 왜 동일한 ALIAS? ALIAS를 안주면 ㄴ컬럼명이 지저분하게 나옴.
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

h_3)디자인팀에서 시작하는 상향식 계층 쿼리를 작성하세요
SELECT deptcd, LPAD(' ', (LEVEL-1)*3) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept00_0'                                -- 현재행의 부모 = 앞으로 읽을 행의 부서코드
CONNECT BY PRIOR deptcd = p_deptcd;


SELECT*
FROM h_sum;

h_4)
계층형쿼리 복습.sql을 이용하여 테이블을 생성하고 다음과 같은 결과가 나오도록 쿼리를 작성하세요.
s_id :노드 아이디
ps_id:부모 노드 아이디
value:노드 값

SELECT LPAD(' ', (LEVEL-1)*2) || s_id s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

SELECT s_id, value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id




        
        


