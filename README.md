# 🥗 VegLu DB (veglu_db) - 필수 항목 가이드

비건 및 글루텐 프리(GF) 식당 추천 서비스 **VegLu**의 데이터베이스 테이블별 **필수 입력(`NOT NULL`) 컬럼** 명세입니다. 

---

## 🛠️ 배포 안내 (Data Protection)
* 본 스크립트는 `CREATE TABLE IF NOT EXISTS` 구조로 되어 있어, **기존 데이터와 테이블 구조를 절대 삭제하지 않고 안전하게 보존**합니다.
* 아래 명시된 `NOT NULL` 컬럼들은 데이터 저장 시 값이 누락되면 DB 에러가 발생하므로, 백엔드 엔티티(Entity) 및 DTO 설계 시 **필수(Required) 검증** 처리가 필요합니다.

---

## 📌 테이블별 필수(`NOT NULL`) 컬럼 명세

### 1. 유저 정보 테이블 (`users`)
회원가입 및 시스템 권한 식별을 위해 반드시 필요한 핵심 정보입니다.

| 필수 컬럼명 | 데이터 타입 | 설명 |
| :--- | :--- | :--- |
| **`user_id`** | BIGINT | PK (자동 생성되는 고유 식별 ID) |
| **`user_email`** | VARCHAR(255) | 로그인 ID로 사용되는 이메일 (UNIQUE) |
| **`user_nickname`** | VARCHAR(100) | 서비스 내에서 식별할 유저 닉네임 |
| **`user_provider`** | ENUM | 로그인 제공처 ('LOCAL', 'KAKAO', 'NAVER', 'GOOGLE', 'APPLE') |
| **`user_role`** | ENUM | 사용자 접근 권한 ('USER', 'OWNER', 'ADMIN') |
| **`user_created_at`** | TIMESTAMP | 계정 생성 일시 (시스템 자동 생성) |

---

### 2. 식당 정보 테이블 (`restaurants`)
식당 등록 및 위치 기반 지도 검색을 수행하기 위해 단 하나라도 누락되면 안 되는 필수 데이터입니다.

| 필수 컬럼명 | 데이터 타입 | 설명 |
| :--- | :--- | :--- |
| **`restaurant_id`** | BIGINT | PK (자동 생성되는 식당 고유 ID) |
| **`restaurant_name`** | VARCHAR(255) | 상호명 / 가게 이름 |
| **`restaurant_address`** | VARCHAR(255) | 서비스 기준이 되는 도로명 주소 |
| **`restaurant_location`** | POINT | 반경 검색용 위경도 좌표 (Spatial Index 적용) |
| **`restaurant_latitude`** | DOUBLE | 지도 마커 표시용 위도 수치값 |
| **`restaurant_longitude`** | DOUBLE | 지도 마커 표시용 경도 수치값 |
| **`restaurant_category`** | VARCHAR(50) | 비건/GF 등 대분류 카테고리 |
| **`restaurant_price_range`** | VARCHAR(50) | 식당 가격대 범위 (LOW ~ VERY_HIGH) |
| **`restaurant_business_hours`**| JSON | 백엔드 파싱용 요일별 영업시간 데이터 |
| **`restaurant_status`** | VARCHAR(20) | 현재 매장 상태 ('OPEN', 'TEMP_CLOSED', 'CLOSED') |
| **`restaurant_created_at`** | TIMESTAMP | 식당 데이터 등록 일시 (시스템 자동 생성) |
| **`restaurant_updated_at`** | TIMESTAMP | 식당 데이터 수정 일시 (변경 시 자동 갱신) |

---

### 3. 사용자 리뷰 테이블 (`reviews`)
신뢰도 높은 리뷰 시스템을 유지하기 위해 작성 시 무조건 채워져야 하는 기본 조건입니다.

| 필수 컬럼명 | 데이터 타입 | 설명 |
| :--- | :--- | :--- |
| **`review_id`** | BIGINT | PK (자동 생성되는 리뷰 고유 ID) |
| **`review_restaurant_id`** | BIGINT | FK (어느 식당에 작성된 리뷰인지 식별) |
| **`review_user_id`** | BIGINT | FK (어느 유저가 작성한 리뷰인지 식별) |
| **`review_rating`** | DOUBLE | 유저가 부여한 종합 평점 별점 (1.0 ~ 5.0) |
| **`review_content`** | TEXT | 리뷰 본문 텍스트 내용 |
| **`review_created_at`** | TIMESTAMP | 리뷰 작성 시간 (시스템 자동 생성) |

*(※ `user_preferences` 테이블은 모든 항목이 선택 사항(Optional)이므로 필수 `NOT NULL` 컬럼이 존재하지 않습니다.)*