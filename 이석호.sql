바탕으로 고객이름 추가하기 5 outerjoin

outer join4 고객 이름컬럼 추가하기.


SELECT p.pid, p.pnm ,NVL(c.cid , 0 ) cid , NVL(c.day, 0 ) day ,NVL(c.cnt, 0 ) cnt , t.cnm
FROM product p ,cycle c, customer t 
WHERE p.pid = c.pid(+) AND :cid = c.cid(+)
AND :cid =t.cid ;
