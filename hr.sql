데이터 결합 ( 실습 join4 )
● erd 다이어그램을 참고하여 customer, cycle 테이블을 조인하여
고객별 애음 제품, 애음요일, 개수를 다음과 같은 결과가 나오도록 쿼리를
작성해보세요(고객명이 brown, sally인 고객만 조회)
(*정렬과 관계없이 값이 맞으면 정답)

SELECT CUSTOMER.CID, CUSTOMER.CNM, CYCLE.PID, CYCLE.DAY, CYCLE.CNT
FROM customer, cycle
WHERE customer.cid = cycle.cid
AND cnm IN('brown', 'sally');

● erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
고객별 애음 제품, 애음요일, 개수, 제품명을 다음과 같은 결과가 나오도록
쿼리를 작성해보세요(고객명이 brown, sally인 고객만 조회)
(*정렬과 관계없이 값이 맞으면 정답)

SELECT CUSTOMER.CID, CUSTOMER.CNM, CYCLE.PID, PRODUCT.PNM, CYCLE.DAY, CYCLE.CNT
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND product.pid = cycle.pid         -- 참고!
AND cnm IN('brown', 'sally');

● erd 다이어그램을 참고하여 customer, cycle, product 테이블을 조인하여
애음요일과 관계없이 고객별 애음 제품별, 개수의 합과, 제품명을 다음과 같은
결과가 나오도록 쿼리를 작성해보세요
(*정렬과 관계없이 값이 맞으면 정답)

SELECT customer.cid, cnm, product.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
 AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, product.pid, pnm;


7번

8
SELECT customer.cid, cnm, product.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, product.pid, pnm;

--실습 8번
SELECT e.region_id, e.region_name, m.country_name 
FROM regions e, countries m
WHERE e.region_id = m.region_id  
AND region_name IN('Europe');

--실습 9번
SELECT e.region_id, e.region_name, e.country_name, locations.city

FROM
(SELECT r.region_id, r.region_name, c.country_name , c.country_id
FROM countries c, regions r 
WHERE c.region_id = r.region_id
AND r.region_id = 1 ) e , locations
WHERE e.country_id = locations.country_id;
FROM locations a, departments h
-- 10번

SELECT regions.region_id, region_name, country_name, city, department_name
FROM countries, regions, locations,departments
WHERE countries.region_id=regions.region_id
     AND countries.COUNTRY_ID = locations.COUNTRY_ID
     AND locations.LOCATION_ID = departments.LOCATION_ID
      AND region_name IN('Europe'); 
--11번
SELECT regions.region_id, region_name, country_name, city, department_name, first_name || last_name name
FROM countries, regions, locations,departments, employees
WHERE countries.region_id=regions.region_id
     AND countries.COUNTRY_ID = locations.COUNTRY_ID
     AND locations.LOCATION_ID = departments.LOCATION_ID
     AND departments.DEPARTMENT_ID = employees.DEPARTMENT_ID
    AND region_name IN('Europe'); 

SELECT employees.employee_id, first_name || last_name name, jobs.job_id, job_title
FROM employees, jobs
WHERE employees.JOB_ID = jobs.JOB_ID;

--13번
SELECT mgr_id, mgr_name, employeed_id, first_name || last_name name, job_id, job_title
FROM employees, jobs
WHERE mrg_id = 100;



































