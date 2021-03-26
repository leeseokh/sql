INSERT: 단건, 여러건
UPDATE 테이블명 SET 컬럼명1 = (스칼라 서브쿼리),
                   컬럼명2 = (스칼라 서브쿼리),
                   컬럼명3 = 'TEST';
                   
9999번 사번을 갖는 brown 직원(ename)을 입력

INSERT INTO emp (empno,ename) VALUES (9999, 'brown');
INSERT INTO emp (empno,ename) VALUES ('brown', 9999);
DESC emp; 보면서 순서 맞춰주자

SELECT *
FROM emp;

9999번 직원의 deptno와 job정보를 SMITH 사원의 deptno, job 정보로 업데이트

UPDATE emp SET deptno =(SELECT deptno
                        FROM emp
                        WHERE ename = 'SMITH'),
                        job = (SELECT job
                        FROM emp
                        WHERE ename = 'SMITH')
WHERE empno = 9999;

SELECT *
FROM emp
WHERE empno = 9999;

MERGE

DELETE: 기존에 존재하는 데이터를 삭제

DELETE 테이블명; --> 테이블의 모든행을 지워라.
WHERE 조건

삭제 테스트를 위한 데이터 입력
INSERT INTO emp (empno,ename) VALUES (9999, 'brown');

DELETE emp
WHERE empno = 9999;

mgr 이 7698 사번인 직원들 모두 삭제
SELECT *
FROM emp
WHERE mgo = 7698;

SELECT *
FROM emp
WHERE empno IN(SELECT empno
            FROM emp
            WHERE mgr = 7698);

DELETE emp   --삭제
WHERE empno IN(SELECT empno
            FROM emp
            WHERE mgr = 7698); 
            
DBMS는 DML 문장을 실행하게 되면 LOG를 남긴다.
    >> UNDO OR REDO 라함.
    
    로그를 남기지 않고 더 빠르게 데이터를 삭제하는 방법 : TRUNCATE
    -DML이 아니고 DDL 이다
    -ROLLBACK이 안된다.(복구 불가)            
    -주로 테스트 환경에서 사용
TRUNCATE TABLE 테이블명;
    
    CREATE TABLE emp_test AS
    SELECT *
    FROM emp;

SELECT *
FROM emp_test;

TRUNCATE TABLE emp_test;

트랜잭션 예시
게시글 입력시( 제목, 내용, 복수개의 첨부파일
게시글 테이블 게시글 첨부파일 테이블
1. DML :게시글 입력
2. DML :게시글 첨부파일 입력

읽기 일관성

인댁스
-눈에 안보임.
-테이블의 일부 컬럼을 사용하여 데이터를 정렬한 객체
     ==> 원하는 데이터를 빠르게 찾을 수 있다.
    -일부 컬럼과 함께 그 컬럼의 행을 찾을 수 있는 ROWID가 같이 저장됨.
    
    ROWID : 테이블의 저장된 행의 물리적 위치, 집 주소 같은 개념
            주소를 통해서 해당 행의 위치를 빠르게 접근하는 것이 가능
            데이터가 입력이 될 때 생성
            
SELECT  emp.* --한점자
FROM emp
WHERE empno = 7369;

SELECT empno, ROWID
FROM emp
WHERE empno = 7782;

SELECT *
FROM emp
WHERE ROWID = 'AAAE5dAAFAAAACPAAG';

EXPLAIN PLAN FOR    -- 실행 계획보기 아래것들.
SELECT *
FROM emp
WHERE empno = 7782;

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY); --실행계획 보기. NAME 이후로 쓸데없음.
-- TABLE ACCESS FULL 비효율 테이블을 다읽은것.


오라클 객체 생성
CREATE 객체 타입(INDEX, TABLE.....) 객체명
==> 자바로 표현
            int  변수명

인덱스 생성
CREATE [UNIQUE] INDEX 인덱스 이름 ON 테이블명(컬럼1, 컬럼2 ...);

CREATE UNIQUE INDEX PK_emp ON emp(empno);
-----------------------
EXPLAIN PLAN FOR   
SELECT *
FROM emp
WHERE empno = 7782;

filter : 읽고 거름      access : 위치를 찾아감, 7782가 빠르게 찾아감~~  ROWID를 가지고 테이블에 접근.
테이블만 읽을지 테이블 인덱스를 거쳐 읽을지
SELECT *
FROM emp;


------------------------------
EXPLAIN PLAN FOR   
SELECT empno
FROM emp
WHERE empno = 7782;        -- empno는 인덱스만 읽어도 사용자가 원하는 결과를 알수있음 

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY); --순서 밑에서부터 아래로 들여쓰기는 그거부터.

DROP INDEX PK_EMP;

CREATE INDEX IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE empno =7782;

SELECT*
FROM TABLE(DBMS_XPLAN.DISPLAY);        UNIQUE RANGE 범위 중복의 허용 여부 인덱스를 한 건 읽었냐 여러건 읽었냐?

JOB 컬럼에 인덱스 생성

CREATE INDEX IDX_emp_02 ON emp (job);

SELECT job, ROWID
FROM emp
ORDER BY job;

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';
   
   1 - filter("ENAME" LIKE 'C%')
   2 - access("JOB"='MANAGER')

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

CREATE INDEX IDX_emp_03 ON emp (job, ename);

SELECT job, ename, ROWID
FROM emp
ORDER BY job, ename;

EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE 'C%';
    
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')


EXPLAIN PLAN FOR
SELECT*
FROM emp
WHERE job = 'MANAGER'
    AND ename LIKE '%C'; --올바르지않음
    
SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);












