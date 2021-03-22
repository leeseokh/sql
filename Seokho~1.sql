SELECT *
FROM prod.id, prod;

SELECT lprod, prod
FROM lprod lprod_gu = prod.prod_lgu;

SELECT*
FROM prod;

SELECT*
join - 2 문제
erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여 buyer별 담당하는제품 정보를 다음과 같은 결과로 쿼리 작성

SELECT buyer_id, buyer_name,prod_id, prod_name
FROM PROD,BUYER                     --정답
WHERE PROD.PROD_BUYER=BUYER.BUYER_ID; 

join - 3
erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여 회원별 
장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리 작성

SELECT member_name, member_id, prod_name, prod_id, cart_qtv
FROM member, cart, prod              --내가 한거
WHERE cart.cart_member = member.mem_id
AND cart.cart_prod = prod.prod_id;

SELECT member.mem_id,member.mem_name, prod.prod_id, prod.prod_name, CART.CART_QTY
FROM prod,member, cart   --답
WHERE member.mem_id=cart.cart_member 
AND cart.cart_prod=prod.prod_id;

SELECT member.mem_id,member.mem_name, prod.prod_id, prod.prod_name, CART.CART_QTY
FROM member JOIN cart ON (member.mem_id=cart.cart_member)  --답
            JOIN prod ON (cart.cart_prod=prod.prod_id);

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

SELECT customer.cid, cnm, product.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid
AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, product.pid, pnm;

OUTER JOIN: 컬럼 연결이 실패해도 [기준]이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
LEFT OUTER JOIN: 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
RIGHT OUTER JOIN: 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
FULL OUTER JOIN: LEFT OUTER JOIN + RIGHT OUTER JOIN -- 중복데이터 한개만 남기고 제거
테이블1: JOIN 테이블
테이블1: LEFT OUTER JOIN 테이블2
테이블2: RIGHT OUTER JOIN 테이블2

직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 JOIN QUERY 작성
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

SELECT e.empno, e.ename, m.empno, m.ename  -- 상사의 부서번호가 10번인것을 제외.
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
AND m.deptno(+) = 10; 

데이터는 몇건이 나올까? 그려볼 것
SELECT  e.empno, e.ename, e.mgr, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno);

SELECT  e.empno, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno);    --아우터~!!

FULL OUTER JOIN 은 오라클 SQL 문법으로 제공하지 않는다.
SELECT e.ename, m.ename
FROM emp e, emp m
WHERE e.mgr(+) = m.empno(+);


SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회. 없을 경우는 null로 표현
제품코드: 수량
outer join 1 buyerprod 테이블에 구매일자가 2005냔 1.25일인 데이터는 3품목 밖에 없다. 모든 품목이 나올수 있도록 쿼리를 작성하세요

SELECT *
FROM buyprod RIGHT OUTER JOIN prod ON buyprod.buy_prod = prod.prod_id AND buy_date = TO_DATE('2005/01/25' , 'YYYY/MM/DD');
/

