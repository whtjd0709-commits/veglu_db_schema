-- ============================================================
-- veglu_db 테이블 생성 SQL 스크립트
-- ============================================================

CREATE DATABASE IF NOT EXISTS veglu_db;
USE veglu_db;


-- ============================================================
-- 1. 유저 (users) 테이블
-- ============================================================
CREATE TABLE users (
    user_id                 BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT '사용자 고유 ID',
    user_email              VARCHAR(255) NOT NULL                      COMMENT '이메일 (로그인 ID)',
    user_password           VARCHAR(255)                               COMMENT '비밀번호 (소셜 로그인 시 NULL)',
    user_nickname           VARCHAR(100) NOT NULL                      COMMENT '닉네임',
    user_phone              VARCHAR(20)                                COMMENT '전화번호',      
    user_profile_image_url  VARCHAR(500)                               COMMENT '프로필 사진 URL',
    user_bio                VARCHAR(500)                               COMMENT '자기소개',
    user_provider           ENUM('LOCAL','KAKAO','NAVER','GOOGLE','APPLE') NOT NULL COMMENT '로그인 제공처',
    user_role               ENUM('USER','OWNER','ADMIN') NOT NULL      COMMENT '사용자 권한',
    user_is_active          TINYINT(1) NOT NULL DEFAULT 1              COMMENT '계정 활성화 여부 (1=활성, 0=탈퇴/비활성)',
    user_created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입일시',
    user_last_login_at      TIMESTAMP                                  COMMENT '마지막 로그인일시',
    user_deleted_at         TIMESTAMP                                  COMMENT '탈퇴일시 (soft delete 참고용)',

    UNIQUE KEY uidx_user_email    (user_email),
    UNIQUE KEY uidx_user_nickname (user_nickname)
) COMMENT='사용자 정보';


-- ============================================================
-- 2. 유저 선호도 (user_preferences) 테이블
-- ============================================================
CREATE TABLE user_preferences (
    pref_user_id               BIGINT PRIMARY KEY   COMMENT '사용자 ID (FK)',
    pref_favorite_categories   JSON                 COMMENT '선호 카테고리',
    pref_disliked_categories   JSON                 COMMENT '비선호 카테고리',
    pref_allergies             JSON                 COMMENT '알러지 정보',
    pref_spicy_level           INT                  COMMENT '선호 매운맛 단계 (0~5)',
    pref_preferred_price_range VARCHAR(50)           COMMENT '선호 가격대',
    pref_dietary_restrictions  JSON                 COMMENT '식이 제한 (비건/할랄 등)',

    FOREIGN KEY (pref_user_id) REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT='사용자 프로필 및 선호도';


-- ============================================================
-- 3. 식당 (restaurants) 테이블
-- ============================================================
CREATE TABLE restaurants (
    restaurant_id              BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '식당 고유 ID',
    restaurant_owner_id        BIGINT                            COMMENT '점주 user_id (FK)',
    restaurant_name            VARCHAR(255) NOT NULL             COMMENT '상호명',
    restaurant_address         VARCHAR(255) NOT NULL             COMMENT '도로명 주소',
    restaurant_address_detail  VARCHAR(255)                      COMMENT '상세 주소 (층, 호수 등)',
    restaurant_location        POINT NOT NULL SRID 4326          COMMENT '위경도 좌표 (WGS84)',
    restaurant_phone           VARCHAR(50)                       COMMENT '가게 전화번호',
    restaurant_category        VARCHAR(50)                       COMMENT '음식 카테고리',
    restaurant_sub_category    VARCHAR(100)                      COMMENT '세부 분류',
    restaurant_price_range     VARCHAR(50)                       COMMENT '가격대',
    restaurant_business_hours  JSON NOT NULL                     COMMENT '요일별 영업시간',
    restaurant_holidays        VARCHAR(255)                      COMMENT '휴무일',
    restaurant_last_order_time TIME                              COMMENT '라스트 오더 시간',
    restaurant_avg_rating      DECIMAL(3,2) DEFAULT 0.00         COMMENT '평균 평점 (집계값, 예: 4.58)',
    restaurant_review_count    INT          DEFAULT 0            COMMENT '리뷰 개수 (집계값)',
    restaurant_has_parking     TINYINT(1)   DEFAULT 0            COMMENT '주차 가능 여부',
    restaurant_has_room        TINYINT(1)   DEFAULT 0            COMMENT '룸/단체석 여부',
    restaurant_has_delivery    TINYINT(1)   DEFAULT 0            COMMENT '배달 가능 여부',
    restaurant_has_reservation TINYINT(1)   DEFAULT 0            COMMENT '예약 가능 여부',
    restaurant_payment_methods JSON                              COMMENT '결제 수단',
    restaurant_amenities       JSON                              COMMENT '편의시설 (WiFi/콘센트 등)',
    restaurant_tags            JSON                              COMMENT '해시태그',
    restaurant_atmosphere      JSON                              COMMENT '분위기 태그',
    restaurant_sns_links       JSON                              COMMENT 'SNS 링크',
    restaurant_status          ENUM('영업중', '휴업', '영업종료') NOT NULL COMMENT '영업 상태',
    restaurant_is_verified     TINYINT(1)   DEFAULT 0            COMMENT '공식 검증 여부',
    restaurant_created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    restaurant_updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    SPATIAL INDEX idx_restaurant_location   (restaurant_location),
    INDEX         idx_restaurant_cat_status (restaurant_category, restaurant_status),
    FOREIGN KEY (restaurant_owner_id) REFERENCES users(user_id) ON DELETE SET NULL
) COMMENT='비건/GF 식당 정보';


-- ============================================================
-- 4. 메뉴 (menus) 테이블
-- ============================================================
CREATE TABLE menus (
    menu_id            BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '메뉴 고유 ID',
    menu_restaurant_id BIGINT NOT NULL                   COMMENT '가게 ID (FK)',
    menu_name          VARCHAR(255) NOT NULL              COMMENT '메뉴명',
    menu_price         INT NOT NULL                       COMMENT '가격 (원)',
    menu_description   TEXT                               COMMENT '메뉴 설명',
    menu_category      ENUM('메인','사이드','음료','디저트') COMMENT '메뉴 분류',
    menu_vegan_type    ENUM('비건','락토','오보','락토오보','페스코') NOT NULL COMMENT '채식 단계',
    menu_allergens     JSON                               COMMENT '알레르기 성분 (땅콩, 글루텐 등)',
    menu_is_available  TINYINT(1) NOT NULL DEFAULT 1      COMMENT '판매 가능 여부 (품절 처리용)',
    menu_is_active     TINYINT(1) NOT NULL DEFAULT 1      COMMENT '사용 여부 (메뉴 노출 on/off)',
    menu_is_seasonal   TINYINT(1) DEFAULT 0               COMMENT '계절 메뉴 여부',
    menu_sort_order    INT DEFAULT 0                      COMMENT '정렬 순서',
    menu_created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    menu_updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    FOREIGN KEY (menu_restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    INDEX idx_menu_restaurant (menu_restaurant_id, menu_is_available, menu_is_active)
) COMMENT='식당 메뉴';


-- ============================================================
-- 5. 리뷰 (reviews) 테이블
-- ============================================================
CREATE TABLE reviews (
    review_id                BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '리뷰 고유 ID',
    review_restaurant_id     BIGINT NOT NULL                   COMMENT '식당 ID (FK)',
    review_user_id           BIGINT NOT NULL                   COMMENT '작성자 user_id (FK)',
    review_rating            DECIMAL(2,1) NOT NULL             COMMENT '종합 평점 (1.0~5.0)',
    review_taste_rating      DECIMAL(2,1)                      COMMENT '맛 평점',
    review_service_rating    DECIMAL(2,1)                      COMMENT '서비스 평점',
    review_atmosphere_rating DECIMAL(2,1)                      COMMENT '분위기 평점',
    review_price_rating      DECIMAL(2,1)                      COMMENT '가성비 평점',
    review_content           TEXT NOT NULL                     COMMENT '리뷰 본문',
    review_photos            JSON                              COMMENT '첨부 사진 URL 목록',
    review_visit_date        DATE                              COMMENT '방문 일자',
    review_companion_count   INT                               COMMENT '방문 인원',
    review_recommended_menu  VARCHAR(255)                      COMMENT '추천 메뉴',
    review_is_hidden         TINYINT(1) DEFAULT 0              COMMENT '숨김 여부 (신고 인정 시 1로 변경)',
    review_created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',

    FOREIGN KEY (review_restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (review_user_id)       REFERENCES users(user_id)              ON DELETE CASCADE,
    INDEX idx_review_restaurant_created (review_restaurant_id, review_created_at DESC),
    INDEX idx_review_user_created       (review_user_id,       review_created_at DESC),
    INDEX idx_review_hidden             (review_is_hidden)
) COMMENT='사용자 리뷰';


-- ============================================================
-- 6. 점주 답글 (review_replies) 테이블
-- ============================================================
CREATE TABLE review_replies (
    reply_id          BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '답글 고유 ID',
    reply_review_id   BIGINT NOT NULL UNIQUE            COMMENT '대상 리뷰 ID (FK, 1:1 관계 유지)',
    reply_user_id     BIGINT NOT NULL                   COMMENT '작성 점주 ID (FK)',
    reply_content     TEXT NOT NULL                     COMMENT '답글 내용',
    reply_created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    reply_updated_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    FOREIGN KEY (reply_review_id) REFERENCES reviews(review_id) ON DELETE CASCADE,
    FOREIGN KEY (reply_user_id)   REFERENCES users(user_id) ON DELETE CASCADE
) COMMENT='리뷰에 대한 점주 답글';


-- ============================================================
-- 7. 리뷰 신고 (review_reports) 테이블
-- ============================================================
CREATE TABLE review_reports (
    report_id           BIGINT AUTO_INCREMENT PRIMARY KEY          COMMENT '신고 고유 ID',
    report_review_id    BIGINT NOT NULL                            COMMENT '신고 대상 리뷰 ID (FK)',
    report_restaurant_id BIGINT NOT NULL                           COMMENT '신고 대상 식당 ID (FK)',
    report_user_id      BIGINT NOT NULL                            COMMENT '신고자 user_id (FK)',
    report_category     ENUM('욕설/비방', '허위리뷰', '광고/홍보', '무관한내용') NOT NULL COMMENT '신고 카테고리',
    report_detail       TEXT                                       COMMENT '신고 상세 사유 (선택 입력)',
    report_status       ENUM('대기중', '처리중', '처리완료') NOT NULL DEFAULT '대기중' COMMENT '처리 상태',
    report_admin_id     BIGINT                                     COMMENT '처리한 관리자 user_id (FK, 미처리 시 NULL)',
    report_admin_note   TEXT                                       COMMENT '관리자 처리 메모',
    report_created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '신고 접수일시',
    report_resolved_at  TIMESTAMP                                  COMMENT '처리 완료일시',

    FOREIGN KEY (report_review_id)     REFERENCES reviews(reviews_id)    ON DELETE CASCADE,
    FOREIGN KEY (report_restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (report_user_id)       REFERENCES users(user_id)          ON DELETE CASCADE,
    FOREIGN KEY (report_admin_id)      REFERENCES users(user_id)          ON DELETE SET NULL,

    UNIQUE KEY uidx_report_review_user  (report_review_id, report_user_id),
    INDEX idx_report_status_created     (report_status, report_created_at DESC),
    INDEX idx_report_review             (report_review_id),
    INDEX idx_report_restaurant         (report_restaurant_id), -- 식당별 신고 통계/조회용 인덱스 추가
    INDEX idx_report_user               (report_user_id)
) COMMENT='리뷰 신고 내역';


-- ============================================================
-- 8. 즐겨찾기 (favorites) 테이블
-- ============================================================
CREATE TABLE favorites (
    fav_user_id        BIGINT NOT NULL                            COMMENT '즐겨찾기 한 유저 ID (FK)',
    fav_restaurant_id  BIGINT NOT NULL                            COMMENT '즐겨찾기 대상 식당 ID (FK)',
    fav_created_at     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '즐겨찾기 등록일시',

    PRIMARY KEY (fav_user_id, fav_restaurant_id),
    FOREIGN KEY (fav_user_id)       REFERENCES users(user_id)       ON DELETE CASCADE,
    FOREIGN KEY (fav_restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,

    -- 유저별 즐겨찾기 목록 조회 (최신순)
    INDEX idx_fav_user_created      (fav_user_id, fav_created_at DESC),
    -- 식당별 즐겨찾기 수 집계용
    INDEX idx_fav_restaurant        (fav_restaurant_id)
) COMMENT='유저 즐겨찾기 식당';


-- ============================================================
-- 9. 공지사항 (notices) 테이블
-- ============================================================
CREATE TABLE notices (
    notice_id         BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '공지 고유 ID',
    notice_author_id  BIGINT                            COMMENT '작성자 user_id (관리자, FK)',
    notice_title      VARCHAR(255) NOT NULL             COMMENT '공지 제목',
    notice_content    TEXT NOT NULL                     COMMENT '공지 본문',
    notice_category   ENUM('서비스', '점검', '업데이트', '기타') NOT NULL DEFAULT '서비스' COMMENT '공지 카테고리',
    notice_is_pinned  TINYINT(1) DEFAULT 0              COMMENT '상단 고정 여부',
    notice_is_visible TINYINT(1) DEFAULT 1              COMMENT '노출 여부 (0=숨김)',
    notice_view_count INT DEFAULT 0                     COMMENT '조회수',
    notice_created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일시',
    notice_updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',

    FOREIGN KEY (notice_author_id) REFERENCES users(user_id) ON DELETE SET NULL,
    INDEX idx_notice_visible_pinned (notice_is_visible, notice_is_pinned, notice_created_at DESC)
) COMMENT='공지사항';

