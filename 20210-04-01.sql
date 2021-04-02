- view는 table과 유사한 객체이다
- View는 기존의 테이블이나 다른 View 객체를 통하여 새로운 SELECT문의 결과에 테이블처럼 사용한다.
    - View는 SELECT문에 귀속되는것이 아니고, 독립적으로 테이블처럼 존재
- View를 이용하는 경우
    - 필요한 정보가 한 개의 테이블에 있지 않고, 여러 개의 테이블에 분산되어 있는 경우
    - 테이블에 들어 있는 자료의 일부분만 필요하고 자료의 전체 row나 col이 필요하지 않은경우
    - 특정 자료에 대한 접근을 제한하고자 할 경우
    
- 인덱스는 많이 만들면 유지보수등 단점이 발생하기 때문에 적당히 만들어야함.


View 객체
- TABLE과 유사한 기능 제공
- 보안, QUERY 실행의 효율성, TABLE의 은닉성을 위하여 사용
(사용형식)
 CREATE [OR REPLACE] [FORCE] [NOFORCE] VIEW 뷰이름[(컬럼LIST)] 
 AS                                                            
    SELECT 문;
        [WITH CHECK OPTION;]
        [WITH READ ONLY;]
        
 --[OR REPLACE]: 뷰가 존재하면 덮어쓰고 없으면 신규생성.        
 --[FORCE] [NOFORCE]:  원본 테이블의 존재하지 않아도 뷰를 생성(FORCE), 생성불가(NOFORCE)
 -- '컬럼LIST' : 생성된 뷰의 컬럼명
 -- 'WITH CHECK OPTION' : SELECT문의 조건절에 위배되는 DML명령 실행 거부
 -- 'WITH READ ONLY' : 읽기 전용 뷰 생성
 
 사용 예)
  사원테이블에서 부모부서코드가 90번 부서에 속한 사원정보를 조회하시오.
    조회항 데이터: 사원번호, 사원명, 부서명, 급여
    
 사용 예) 
    회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를 조회하세요
    
    SELECT mem_id 회원번호,
           mem_name AS 회원명,
           mem_job 직업,
           mem_mileage 마일리지
    FROM MEMBER
    WHERE mem_mileage >=3000;
    
    => 뷰 생성
    CREATE OR REPLACE VIEW V_MEMBER01
    AS
         SELECT mem_id AS 회원번호,
                mem_name AS 회원명,
               mem_job AS 직업,
               mem_mileage AS 마일리지
        FROM MEMBER
        WHERE mem_mileage >=3000;
        
        
SELECT * FROM MEMBER;      -- 원본테이블과 뷰는 연동되어서 바뀌연 같이 바뀜
SELECT mem_name,mem_job,mem_mileage 
FROM member 
WHERE UPPER(mem_id) = 'C001';
        
(MEMBER 테이블에서 신용환의 마일리지를 10000로 변경) 
UPDATE MEMBER           -- UPDATE : 내용 변경
    SET mem_mileage = 10000
    WHERE mem_name = '신용환';
    
    
(View V_MEMBER 테이블에서 신용환의 마일리지를 10000로 변경)    -- 별칭으로 써줘야함
UPDATE V_MEMBER01
SET 마일리지 = 500
WHERE 회원명 = '신용환';


CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MMILE)
    AS
         SELECT mem_id AS 회원번호,
                mem_name AS 회원명,
               mem_job AS 직업,
               mem_mileage AS 마일리지
        FROM MEMBER
        WHERE mem_mileage >=3000
        WITH CHECK OPTION;

 SELECT *
 FROM V_MEMBER01;
(뷰 V_MEMBER01에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE V_MEMBER01
SET MMILE =2000
WHERE UPPER(MID) ='c001';


(테이블 MEMBER01에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE MEMBER 
    SET MEM_MILEAGE = 2000
    WHERE MEM_NAME = '신용환';

SELECT mem_name, mem_mileage
FROM member;

CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MMILE)
    AS
         SELECT mem_id AS 회원번호,
                mem_name AS 회원명,
               mem_job AS 직업,
               mem_mileage AS 마일리지
        FROM MEMBER
        WHERE mem_mileage >=3000
        WITH READ ONLY;
        

ROLLBACK;
SELECT * FROM V_MEMBER01;
UPDATE V_MEMBER01
SET MMILE = 5700
WHERE mname = '오철희';

SELECT HR.DEPARTMENTS.DEPARTMENT_ID,
        DEPARTMENT_NAME
        FROM HR.DEPARTMENTS;

2021 0401- 02
문제] HR계정의 사원테이블에서 50번 부서에 속한 사원 중 급여가 5000이상인 사원번호, 사원명,
입사일, 급여를 읽기 전용 뷰로 생성하시오. 뷰이름은 v_emp_sal01이고 컬럼명은 원본테이블의 컬럼명을 사용

SELECT*
FROM employees;

CREATE OR REPLACE VIEW v_emp_sal01
AS
    SELECT employee_id,
            CONCAT(first_name,last_name) AS name,
            hire_date,
            salary
    FROM employees
    WHERE department_id = 50 AND salary >=5000
    WITH READ ONLY;
    
    SELECT *
FROM v_emp_sal01;
UPDATE v_emp_sal01           -- UPDATE : 내용 변경
    SET salary = 10000
    WHERE employee_id = 120;
DROP View v_emp_sal01;      
    
    
SELECT C.employee_id 사원번호, C.name 사원명, B.job_title 직무명, C.salary
FROM v_emp_sal01 C,employees A, jobs B
WHERE   A.employee_id = C.employee_id AND
        A.job_id = B.job_id;
        

SELECT *
FROM v_emp_sal01;
SELECT *
FROM jobs;
SELECT *
FROM employees;


SELECT employee_id,
            CONCAT(first_name,last_name),
            hire_date,
            salary
FROM employees;            

