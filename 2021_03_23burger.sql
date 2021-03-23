SELECT a.sido, a.sigungu, ROUND(a.cnt/b.cnt, 2) 도시발전지수
FROM
(SELECT sido, sigungu, COUNT(*) cnt
 FROM burgerstore
 WHERE storecategory IN ( 'KFC', 'MACDONALD', 'BURGER KING')
 GROUP BY sido, sigungu) a,
(SELECT sido, sigungu, COUNT(*) cnt
 FROM burgerstore
 WHERE storecategory = 'LOTTERIA'
 GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
AND a.sido = '대전'
AND a.sigungu = '중구'
ORDER BY '도시발전지수' DESC;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
SELECT kmb.sido, kmb.sigungu, kmbcount/lcount "도시발전지수"
FROM
(SELECT SIDO, SIGUNGU, count(storecategory) kmbcount
FROM burgerstore
WHERE sido = :sido AND sigungu = :sigungu AND storecategory NOT IN('LOTTERIA')
GROUP BY sido, sigungu) kmb,
(SELECT SIDO, SIGUNGU, storecategory, count(storecategory) lcount
FROM burgerstore
WHERE sido = :sido AND sigungu = :sigungu AND storecategory IN('LOTTERIA')
GROUP BY storecategory, sido, sigungu) l;












