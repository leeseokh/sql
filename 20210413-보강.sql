--데이터베이스 보강(2021.04.12)-1.

1.ROLLUP
    -GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
    -명시한 표현식의 수와 순서 (오른쪽에서 왼쪽 순)에 따라 레벨별로 집계한 결과를 반환한다.
    -표현식에 n개 사용된 경우 n+1가지의 집계반환 
    (사용형식)
    SELECT 컬럼list
    FROM 테이블명
    WHERE 조건
    GROUP BY [컬럼명] ROLLUP(컬럼명1, 컬럼명2, ...컬럼명n)
    ROLLUP안에 기술된 컬럼명1, 컬럼명2, ...컬럼명n을 오른쪽 부터 왼쪽순으로 레벨화 시키고 그 것을 기준으로 집계결과를 반환한다.
    
    사용예) 우리나라 광역시도의 대출현황테이블에서 기간별, 지역별 구분별 잔액합계를 조회하시오
        
    --그룹바이절 사용--
    SELECT SUBSTR (PERIOD 1, 4) AS "기간(년)",
           REGION AS 지역,
           GUBUN AS 구분,
           SUM(LONG_JAN_AMT) AS 잔액합계
        FROM KOR_LONG_STATUS
        GROUP BY SUBSTR(PERIOD,1,4),REGION, GUBUN
        ORDER BY 1;
      
      --ROLLUP 절 사용--
          SELECT SUBSTR (PERIOD 1, 4) AS "기간(년)",
           REGION AS 지역,
           GUBUN AS 구분,
           SUM(LONG_JAN_AMT) AS 잔액합계
        FROM KOR_LONG_STATUS
        GROUP BY ROLLUP (SUBSTR(PERIOD,1,4),REGION, GUBUN)
        ORDER BY 1;
      
      
      2.CUBE
        -GROUP BY 절과 같이 사용하여 추가적인 집계정보를 제공함
        -CUBE절안에 사용된 컬럼의 조합가능한 가지수 만큼의 종류별 집계반환
                  SELECT SUBSTR (PERIOD 1, 4) AS "기간(년)",
           REGION AS 지역,
           GUBUN AS 구분,
           SUM(LONG_JAN_AMT) AS 잔액합계
        FROM KOR_LONG_STATUS
        GROUP BY CUBE (SUBSTR(PERIOD,1,4),REGION, GUBUN)
        ORDER BY 1;
        
        extra-0413)조인
    -다수개의 테이블로 부터 필요한 자료 추출
    -rdbms에서 가장 중요한 연산
    1. 조인이란??

→ 서로 다른 테이블간에 설정된 관계가 결합하여 1개 이상의 테이블에서 데이터를 조회하기 위해 사용 됩니다. 
이 때 테이블간의 상호 연결을 조인이라고 하는데요. 각각의 테이블에 분리된 연관성 있는 데이터를 연결하거나 
조합해야 하는데 이러한 일련의 작업들을 조인이라고 합니다.

    1. 내부 조인
        -조인조건을 만족하지 않는 행은 무시
        예) 상품테이블에서 상품의 분류별 상품의 수를 조회하시오.
        Alias 분류코드, 분류명, 상품의 수
    **상품테이블에서 사용한 분류코드의 종류   사용된 분류코드종류 알려면 DISTINCT 사용
        SELECT DISTINCT PROD_LGU
            FROM PROD;          --남는 코드들은 무시-내부조인 /// 남는 코드들도 출력됨 -외부조인 두개를비교 4개가 남아 그거를 NULL로 채움.
    
SELECT A.LPROD_GU AS 분류코드,   -- 분류코드는 LPROD 아님 PROD 둘중 뭘 써도 괜찮.
       A.LPROD_NM AS 분류명, 
       COUNT(*) AS "상품의 수"   --공백으로 인해 " "
    FROM LPROD A, PROD B    
    WHERE LPROD_GU = PROD_LGU
    GROUP BY A.LPROD_GU, A.LPROD_NM
    ORDER BY 1;                 -- 1번컬럼 기준

예) 2005년 5월 매출자료와 거래처테이블을 이용하여 거래처별 상품매출정보를
    조회하시오
    Alias는 거래처코드, 거래처명, 매출액

    SELECT  B.PROD_BUYER AS 거래처코드 ,
                C.BUYER_NAME AS 거래처명,
                SUM(A.CART_QTY*B.PROD_PRICE) AS 매출액
            FROM CART A , PROD B , BUYER C
         WHERE A.CART_PROD=B.PROD_ID
            AND B.PROD_BUYER=C.BUYER_ID
            AND A.CART_NO LIKE '200505%'
        GROUP BY  B.PROD_BUYER,C.BUYER_NAME
        ORDER BY 1;

    
    ANSI 내부조인
    SELECT 컬럼list
      FRON 테이블명
    INNER JOIN 테이블명2 ON (조인조건
        [AND 일반조건])
    INNER JOIN 테이블명3 ON (조인조건      --테이블 3은 테이블1 과 2의 결과와 조인됨.
        [AND 일반조건])
            :
        WHERE 조건;
        
        
         FROM CART A
    INNER JOIN PROD B ON (A.CART_PROD=B.PROD_ID
    AND A.CART                               --CART와 BUYER는 공통 컬럼이 없어서 PROD가 필요함.
    WHERE A.CART_PROD = B.PROD_ID  
      AND B.PROD_BUYER = C.BUYER_ID --거래처명
      AND A.CART_NO LIKE '200505%' 
    GROUP BY B.PROD_BUYER, C.BUYER_NAME
    GROUP BY 1;
        
        
문제1) 2005년 1월~3월 거래처별 매입정보를 조회하시오
       Alias는 거래처코드, 거래처명, 매입금액합계이고
       매입금액 합계가 500만원 이상인 거래처만 검색하시오.

문제2) 사원테이블(EMPLOYEES)에서 부서별 평균급여보다 급여를 많이 받는
        직원들의 수를 부서별로 조회하시오.
        Alias는 부서코드, 부서명, 부서평균급여, 인원수
        
        
        
        
        
        
        
        
        
        
        
        
        