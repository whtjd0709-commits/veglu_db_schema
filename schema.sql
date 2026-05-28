USE veglu_db;

-- 1. 유저 (users) 테이블
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '사용자 고유 ID',
    user_email VARCHAR(255) NOT NULL COMMENT '이메일 (로그인 ID)',
    user_password VARCHAR(255) COMMENT 'BCrypt 해시 비밀번호',
    user_nickname VARCHAR(100) NOT NULL COMMENT '닉네임',
    user_profile_image_url VARCHAR(500) COMMENT 'PRO필 사진 URL',
    user_bio VARCHAR(500) COMMENT '자기소개',
    user_provider ENUM('LOCAL', 'KAKAO', 'NAVER', 'GOOGLE', 'APPLE') NOT NULL COMMENT '로그인 제공처',
    user_role ENUM('USER', 'OWNER', 'ADMIN') NOT NULL COMMENT '사용자 권한',
    user_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '가입일시',
    user_last_login_at TIMESTAMP COMMENT '마지막 로그인',
    user_deleted_at TIMESTAMP COMMENT '탈퇴일시 (soft delete)',
    
    UNIQUE KEY uidx_user_email (user_email) 
) COMMENT='사용자 정보';


-- 2. 유저 프로필 및 선호도 (user_preferences) 테이블
-- * users 테이블과 1:1 관계 (공유 식별자 구조)
CREATE TABLE user_preferences (
    pref_user_id BIGINT PRIMARY KEY COMMENT '사용자 ID',
    pref_favorite_categories JSON COMMENT '선호 카테고리',
    pref_disliked_categories JSON COMMENT '비선호 카테고리',
    pref_allergies JSON COMMENT '알러지 정보',
    pref_spicy_level INT COMMENT '선호 매운맛 단계 (0~5)',
    pref_preferred_price_range VARCHAR(50) COMMENT '선호 가격대',
    pref_dietary_restrictions JSON COMMENT '식이 제한 (비건/할랄 등)',
    
    FOREIGN KEY (pref_user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT='사용자 프로필 및 선호도 (users와 1:1)';


-- 3. 식당 (restaurants) 테이블
CREATE TABLE restaurants (
    restaurant_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '비건/GF 식당 고유 ID',
    restaurant_name VARCHAR(255) NOT NULL COMMENT '상호명',
    restaurant_address VARCHAR(255) NOT NULL COMMENT '도로명 주소',
    restaurant_address_detail VARCHAR(255) COMMENT '상세 주소 (층, 호수 등)',
    restaurant_location POINT SRID 4326 NOT NULL COMMENT '위경도 좌표',
    restaurant_latitude DOUBLE NOT NULL COMMENT '위도 (지도 표시용)',
    restaurant_longitude DOUBLE NOT NULL COMMENT '경도 (지도 표시용)',
    restaurant_phone VARCHAR(50) COMMENT '전화번호',
    restaurant_category VARCHAR(50) NOT NULL COMMENT '음식 카테고리 (채소, 곡물류 등)',
    restaurant_sub_category VARCHAR(100) COMMENT '세부 분류 (예: 국밥, 분식)',
    restaurant_price_range VARCHAR(50) NOT NULL COMMENT '가격대',
    restaurant_business_hours JSON NOT NULL COMMENT '요일별 영업시간',
    restaurant_holidays VARCHAR(255) COMMENT '휴무일 (예: 매주 월요일, 명절 등)',
    restaurant_last_order_time TIME COMMENT '라스트 오더 시간',
    restaurant_avg_rating DOUBLE DEFAULT 0.0 COMMENT '평균 평점 (계산값)',
    restaurant_review_count INT DEFAULT 0 COMMENT '리뷰 개수 (계산값)',
    restaurant_has_parking TINYINT(1) DEFAULT 0 COMMENT '주차 가능 여부',
    restaurant_has_room TINYINT(1) DEFAULT 0 COMMENT '룸/단체석 여부',
    restaurant_has_delivery TINYINT(1) DEFAULT 0 COMMENT '배달 가능 여부',
    restaurant_has_reservation TINYINT(1) DEFAULT 0 COMMENT '예약 가능 여부',
    restaurant_payment_methods JSON COMMENT '결제 수단',
    restaurant_amenities JSON COMMENT '편의시설 (WiFi/콘센트 등)',
    restaurant_tags JSON COMMENT '해시태그',
    restaurant_atmosphere JSON COMMENT '분위기 태그',
    restaurant_sns_links JSON COMMENT 'SNS 링크',
    restaurant_status VARCHAR(20) NOT NULL COMMENT 'OPEN / TEMP_CLOSED / CLOSED',
    restaurant_is_verified TINYINT(1) DEFAULT 0 COMMENT '공식 검증 여부',
    restaurant_owner_id BIGINT COMMENT '점주 사용자 ID',
    restaurant_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '등록일시',
    restaurant_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL COMMENT '수정일시',
    
    SPATIAL INDEX idx_restaurant_location (restaurant_location),
    INDEX idx_restaurant_cat_status (restaurant_category, restaurant_status), 
    FOREIGN KEY (restaurant_owner_id) REFERENCES users(user_id) ON DELETE SET NULL
) COMMENT='비건/GF 식당 정보';


-- 4. 리뷰 (reviews) 테이블
CREATE TABLE reviews (
    review_id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '리뷰 고유 ID',
    review_restaurant_id BIGINT NOT NULL COMMENT '비건/GF 식당 ID',
    review_user_id BIGINT NOT NULL COMMENT '작성자 ID',
    review_rating DOUBLE NOT NULL COMMENT '종합 평점 (1.0~5.0)',
    review_taste_rating DOUBLE COMMENT '맛 평점',
    review_service_rating DOUBLE COMMENT '서비스 평점',
    review_atmosphere_rating DOUBLE COMMENT '분위기 평점',
    review_price_rating DOUBLE COMMENT '가성비 평점',
    review_content TEXT NOT NULL COMMENT '리뷰 본문',
    review_photos JSON COMMENT '첨부 사진 URL 목록',
    review_visit_date DATE COMMENT '방문 일자',
    review_companion_count INT COMMENT '방문 인원',
    review_recommended_menu VARCHAR(255) COMMENT '추천 메뉴',
    review_like_count INT DEFAULT 0 COMMENT '좋아요 수',
    review_sentiment_score DOUBLE COMMENT 'AI 감성 점수 (-1.0~1.0)',
    review_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL COMMENT '작성일시',
    
    FOREIGN KEY (review_restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (review_user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_review_restaurant_created (review_restaurant_id, review_created_at DESC),
    INDEX idx_review_user_created (review_user_id, review_created_at DESC)
) COMMENT='사용자 리뷰';