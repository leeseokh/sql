2021_04_05  SQL
* 인덱스 객체
(사용 형식)
CREATE (UNIQUE|BITMAP) INDEX 인덱스명
ON 테이블명(컬럼명1(, 컬럼명2, ...]) [ASC|DESC] -삭제시 DROP사용


---------------------------------------------------------------------------------
Index 사용 이유
-WHERE 구문과 일치하는 열을 빨리 찾기 위해.
-특정 열을 고려 대상에서 빨리 없애 버리기 위해.
-조인 (join)을 실행할 때 다른 테이블에서 열을 추출하기 위해.
-특정하게 인덱스된 컬럼을 위한 MIN() 또는 MAX() 값을 찾기 위해.
-사용할 수 있는 키의 최 좌측 접두사(leftmost prefix)를 가지고 정렬 및 그룹화를 하기 위해.
-데이터 열을 참조하지 않는 상태로 값을 추출하기 위해서 쿼리를 최적화 하는 경우.
---------------------------------------------------------------------------------

Key : 인덱스를 생성하라고 지정한 컬럼의 값

DELETE
<Table과 Index 상황 비교>

Table에서 data가 delete 되는 경우
Data가 지워지고, 다른 Data가 그 공간을 사용 가능하다.

Index에서 Data가 delete 되는 경우
Data가 지워지지 않고, 사용 안 됨 표시만 해둔다.
Table의 Data 수와 Index의 Data 수가 다를 수 있다.

UPDATE
Table에서 update가 발생하면 → Index는 Update 할 수 없다.
Index에서는 Delete가 발생한 후, 새로운 작업의 Insert 작업 / 2배의 작업이 소요되어 힘들다.
-----------------------------------------------------------------------------------  여까지 인터넷 서치


상품테이블에서 상품명으로 노멀 인덱스를 구성하시오
CREATE INDEX_PROD_NAME
ON PROD(PROD_NAME);

사용예) 장바구니 테이븰에서 장바구니 번호중 3번째에서 6글자로 인덱스를 구성하시오.
CREATE INDEX IDX_CART+NO
    ON CART(SUBSTR(CART_NO,3 ,6));
    
**인덱스의 재구성
- 데이터 테이블을 다른 테이블스페이스로 이동 시킨 후 

2021_04_05  PL/SQL
-PROCEDURAL LANGUAGE sql의 약자
-표준 SQL에 절차적 언어의 기능(비교 반복 변수 등) 이 추가
-블록(BLOCK)구조로 구성
-미리 컴파일되어 실행 가능한 상태로 서버에 저장되어 필요시 호출되어 사용된다.
-모듈화, 캡슐화 기능 제공
-Anonymous Block, Stored Procedure, User Defined Function, Package, Trigger 등으로 구성됨.

1.익명블록
-pl/sql의 기본구조
-선언부와 실행부로 구성
(구성형식)

DECLARE
-- 선언영역
-- (변수, 상수, 커서 )3가지만 선언 할 수 있다.

BEGIN
-- 실행 영역
--BUSINESS LOGIC 처리

(EXCEPTION
예외처리명령;   >> 비정상적 종료를 정상적으로 돌려주는 명령.

END;

사용예 ) 키보드로 2~9 사이의 값을 입력 받아 그 수에 해당하는 구구단을 작성하시오.

ACCEPT P_NUM PROMPT '수 입력(2~9) : '                       --수 입력창이 ACCEPT
DECLARE
  V_BASE NUMBER := TO_NUMBER('&P_NUM');   --P의 값을 참조하라!.
  V_CNT NUMBER :=0;  --숫자 0 초기값 설정, 초기화
  V_RES NUMBER :=0;              
BEGIN
 LOOP
  V_CNT:=V_CNT+1;    --
  EXIT WHEN V_CNT > 9;
  V_RES:=V_BASE*V_CNT;
  
  DBMS_OUTPUT.PUT_LINE(V_BASE||'*'||V_CNT||'='||V_RES);
  END LOOP;
  
  EXCEPTION WHEN OTHERS THEN
  DBMS_OUTPUT.PUT_LINE('예외발생:'||SQLERM)
  END;
  
  1)변수, 상수 선언
  -실행영역에서 사용할 변수 및 상수 선언
  (1)변수의 종류
  
  -SCLAR 변수- 하나의 데이터를 저장하는 일반적 변수
  -REGERENCES 변수 - 해당 테이블의 컬럼이나 행에 대응하는 타입과 크기를 참조하는 변수
  -COMPOSITE 변수 - PL/SQL에서 사용하는 배열 변수
   RECORD TYPE
   TABLE TYPE 변수
   -BIND 변수 -파라미터로 넘겨지는 IN, OUT, INOUT에서 사용되는 변수
   RETURN 되는 값을 전달받기 위한 변수.
  
  2)선언방식
  변수명 [CONSTANT] 데이터타입 [:=초기값]
  변수명 테이블명.컬럼명%TYPE [:=초기값, -> 컬럼 참조횽
  변수명 테이블명%ROWTYPE -> 행 참조형 (자주씀)
  3)데이터타입
  표준 SQL에서 사용하는 데이터 타입
  -PLS_INTEGER, BINARY_INTEGER : 2147483647~2147483648 까지 자료처리
  -BOOLEAN : TRUE, FALSE, NULL 처리
  -LONG, LONG RAW : DEPRECATED

예) 장바구니에서 2005년 5월 가장 많은 구매를 한(구매금액 기준) 회원정보를 조회 하시오(회원번호, 회원명, 구매금액합)

*표준 SQL
SELECT 회원번호, 회원명, 구매금액합
    FROM



SELECT A.CART_MEMBERS AS 회원번호,
       B.MEM_NAME AS 회원명,
       SUM(PROD_PRICE*CART_QTY) AS 구매금액합
    FROM CART, MEMBER B, PROD C
    WHERE A.CART_MEMBER=B.MEM_ID
    AND A.CART_PROD=C.PROD_ID
    GROUP BY A.CART_MEMBER, B.MEM_NAME
    ORDER BY 3 DESC;


























