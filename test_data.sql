USE veglu_db;

-- 기존 데이터 초기화 (외래키 체크를 잠시 끄고 안전하게 비웁니다)
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE notices;
TRUNCATE TABLE favorites;
TRUNCATE TABLE review_reports;
TRUNCATE TABLE review_replies;
TRUNCATE TABLE reviews;
TRUNCATE TABLE menus;
TRUNCATE TABLE restaurants;
TRUNCATE TABLE user_preferences;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;


-- ============================================================
-- 1. 유저 (users) 데이터 (총 5명: 일반유저3, 점주1, 관리자1)
-- ============================================================
INSERT INTO users (user_id, user_email, user_password, user_nickname, user_phone, user_profile_image_url, user_bio, user_provider, user_role, user_is_active)
VALUES 
(1, 'vegan_love@veglu.com', 'hashed_pass_1', '비건바라기', '010-1234-5678', 'https://example.com/profiles/1.png', '맛있는 비건 탐방이 취미입니다.', 'LOCAL', 'USER', 1),
(2, 'green_step@veglu.com', 'hashed_pass_2', '초록발자국', '010-2345-6789', NULL, '건강과 환경을 생각하는 페스코 테리언입니다.', 'KAKAO', 'USER', 1),
(3, 'clean_eat@veglu.com', 'hashed_pass_3', '깔끔식단', '010-3456-7890', 'https://example.com/profiles/3.png', '글루텐프리 선호자입니다.', 'GOOGLE', 'USER', 1),
(4, 'owner_kim@veglu.com', 'hashed_pass_4', '김점주', '010-5555-5555', NULL, '베글루 식당 1호점 사장입니다.', 'LOCAL', 'OWNER', 1),
(5, 'admin@veglu.com', 'hashed_pass_5', '최고관리자', '010-9999-9999', NULL, '베글루 시스템 관리자계정', 'LOCAL', 'ADMIN', 1);


-- ============================================================
-- 2. 유저 선호도 (user_preferences) 데이터
-- ============================================================
INSERT INTO user_preferences (pref_user_id, pref_favorite_categories, pref_disliked_categories, pref_allergies, pref_spicy_level, pref_preferred_price_range, pref_dietary_restrictions)
VALUES
-- 비건바라기: 한식/양식 선호, 견과류 알러지, 비건식 지향
(1, '["한식", "양식"]', '["일식"]', '["PEANUT", "WALNUT"]', 2, '1만원대', '["VEGAN"]'),
-- 초록발자국: 일식/샐러드 선호, 매운것 싫어함, 페스코
(2, '["일식", "샐러드"]', '["중식"]', '[]', 1, '1만~2만원대', '["PESCO"]'),
-- 깔끔식단: 디저트 선호, 밀가루(글루텐) 알러지
(3, '["디저트", "카페"]', '[]', '["GLUTEN", "WHEAT"]', 0, '1만원 이하', '["GLUTEN_FREE"]');


-- ============================================================
-- 3. 식당 (restaurants) 데이터 (Point 내장 함수 사용 최종 안정 버전)
-- ============================================================
INSERT INTO restaurants (restaurant_id, restaurant_owner_id, restaurant_name, restaurant_address, restaurant_address_detail, restaurant_location, restaurant_phone, restaurant_category, restaurant_sub_category, restaurant_price_range, restaurant_business_hours, restaurant_holidays, restaurant_last_order_time, restaurant_avg_rating, restaurant_review_count, restaurant_has_parking, restaurant_has_room, restaurant_has_delivery, restaurant_has_reservation, restaurant_payment_methods, restaurant_amenities, restaurant_tags, restaurant_atmosphere, restaurant_sns_links, restaurant_status, restaurant_is_verified)
VALUES
-- 1번 식당: 홍대입구역 근처 (Point 함수 사용: 경도, 위도 순서로 입력)
(1, 4, '그린키친 홍대점', '서울 마포구 양화로 161', '3층', ST_SRID(Point(126.9244, 37.5567), 4326), '02-123-4567', '양식', '파스타/스테이크', '1만~2만원대', 
 '{"MON": {"open": "11:00", "close": "21:00", "break_start": "15:00", "break_end": "17:00"}, "TUE": {"open": "11:00", "close": "21:00", "break_start": "15:00", "break_end": "17:00"}, "WED": {"open": "11:00", "close": "21:00", "break_start": "15:00", "break_end": "17:00"}, "THU": {"open": "11:00", "close": "21:00", "break_start": "15:00", "break_end": "17:00"}, "FRI": {"open": "11:00", "close": "22:00", "break_start": "15:00", "break_end": "17:00"}, "SAT": {"open": "11:00", "close": "22:00", "break_start": null, "break_end": null}, "SUN": {"open": "11:00", "close": "20:00", "break_start": null, "break_end": null}}', 
 '연중무휴', '20:30:00', 4.50, 2, 1, 0, 1, 1, '["신용카드", "네이버페이", "카카오페이"]', '["무선인터넷", "반려동물동반"]', '["비건인증", "분위기맛집", "친환경"]', '["모던한", "조용한"]', '{"instagram": "https://instagram.com/green_kitchen"}', '영업중', 1),

-- 2번 식당: 강남역 근처 (Point 함수 사용: 경도, 위도 순서로 입력)
(2, NULL, '베리베건 카페', '서울 강남구 강남대로 396', '1층', ST_SRID(Point(127.0276, 37.4979), 4326), '02-987-6543', '카페/디저트', '베이커리', '1만원 이하', 
 '{"MON": {"open": "09:00", "close": "20:00"}, "TUE": {"open": "09:00", "close": "20:00"}, "WED": {"open": "09:00", "close": "20:00"}, "THU": {"open": "09:00", "close": "20:00"}, "FRI": {"open": "09:00", "close": "21:00"}, "SAT": {"open": "10:00", "close": "21:00"}, "SUN": {"is_closed": true}}', 
 '매주 일요일 정기휴무', '19:30:00', 5.00, 1, 0, 0, 0, 0, '["신용카드", "제로페이"]', '["콘센트", "주차가능"]', '["글루텐프리", "쌀빵", "디저트맛집"]', '["아늑한", "인스타감성"]', '{"blog": "https://blog.naver.com/very_vegan"}', '영업중', 0);


-- ============================================================
-- 4. 메뉴 (menus) 데이터
-- ============================================================
INSERT INTO menus (menu_id, menu_restaurant_id, menu_name, menu_price, menu_description, menu_category, menu_vegan_type, menu_allergens, menu_is_available, menu_is_active, menu_is_seasonal, menu_sort_order)
VALUES
-- 1번 식당 메뉴
(1, 1, '비건 라구 파스타', 16500, '식물성 대체육으로 깊은 맛을 낸 토마토 라구 파스타', '메인', '비건', '["대두", "밀"]', 1, 1, 0, 1),
(2, 1, '아보카도 가든 샐러드', 13000, '신선한 아보카도와 계절 야채가 어우러진 샐러드', '사이드', '비건', '[]', 1, 1, 0, 2),
(3, 1, '제철 딸기 타르트', 7500, '겨울-봄 한정 식물성 크림 딸기 타르트', '디저트', '락토오보', '["우유", "계란"]', 1, 1, 1, 3),

-- 2번 식당 메뉴
(4, 2, '현미 쌀 식빵', 5500, '글루텐프리 100% 현미가루로 만든 쫄깃한 식빵', '메인', '비건', '[]', 1, 1, 0, 1),
(5, 2, '오트밀 라떼', 6000, '귀리우유를 사용하여 고소함을 더한 비건 라떼', '음료', '비건', '[]', 1, 1, 0, 2),
(6, 2, '초코 비건 브라우니', 4800, '밀가루와 버터 없이 만든 꾸덕한 브라우니 (품절 테스트용)', '디저트', '비건', '["대두"]', 0, 1, 0, 3);


-- ============================================================
-- 5. 리뷰 (reviews) 데이터 (평점 집계 보정을 위해 3개 입력)
-- ============================================================
INSERT INTO reviews (review_id, review_restaurant_id, review_user_id, review_rating, review_taste_rating, review_service_rating, review_atmosphere_rating, review_price_rating, review_content, review_photos, review_visit_date, review_companion_count, review_recommended_menu, review_is_hidden)
VALUES
-- 1번 식당 리뷰 2개 (평균 평점 4.5)
(1, 1, 1, 5.0, 5.0, 5.0, 5.0, 4.0, '라구 파스타 소스가 진짜 고기 같아서 놀랐어요! 매장 분위기도 너무 포근하고 좋아서 재방문 의사 100%입니다.', '["https://example.com/reviews/r1_1.jpg", "https://example.com/reviews/r1_2.jpg"]', '2026-05-10', 2, '비건 라구 파스타', 0),
(2, 1, 2, 4.0, 4.0, 4.0, 5.0, 3.0, '맛은 훌륭한데 가격대가 살짝 있는 편이에요. 그래도 분위기가 좋아서 데이트 코스로 강추합니다.', '[]', '2026-05-15', 2, '아보카도 가든 샐러드', 0),

-- 2번 식당 리뷰 1개 (평균 평점 5.0)
(3, 2, 3, 5.0, 5.0, 5.0, 5.0, 5.0, '밀가루 알러지가 있어서 빵 먹기 힘들었는데 속도 편하고 너무 맛있어요ㅠㅠ 단골 예약입니다!', '["https://example.com/reviews/r2_1.jpg"]', '2026-05-20', 1, '현미 쌀 식빵', 0);


-- ============================================================
-- 6. 점주 답글 (review_replies) 데이터
-- ============================================================
INSERT INTO review_replies (reply_id, reply_review_id, reply_user_id, reply_content)
VALUES
-- 1번 리뷰에 대해 4번 점주가 단 답글
(1, 1, 4, '안녕하세요 비건바라기님! 만족스러운 식사가 되셨다니 정말 기쁩니다. 앞으로도 건강하고 맛있는 음식 대접할 수 있도록 노력하겠습니다. 또 방문해 주세요! 😊');


-- ============================================================
-- 7. 리뷰 신고 (review_reports) 데이터
-- ============================================================
INSERT INTO review_reports (report_id, report_review_id, report_user_id, report_category, report_detail, report_status, report_admin_id, report_admin_note, report_resolved_at)
VALUES
-- 2번 유저가 3번 리뷰를 잘못 신고한 가상 상황 (처리완료 상태)
(1, 3, 2, '허위리뷰', '개인적인 원한으로 작성된 리뷰로 의심됩니다.', '처리완료', 5, '확인 결과 정상적인 영수증 인증 리뷰로 판단되어 반려함.', '2026-05-22 14:00:00');


-- ============================================================
-- 8. 즐겨찾기 (favorites) 데이터
-- ============================================================
INSERT INTO favorites (fav_user_id, fav_restaurant_id, fav_created_at)
VALUES
(1, 1, '2026-05-11 10:30:00'), -- 비건바라기 -> 그린키친 홍대점
(1, 2, '2026-05-12 11:15:00'), -- 비건바라기 -> 베리베건 카페
(2, 1, '2026-05-16 18:20:00'); -- 초록발자국 -> 그린키친 홍대점


-- ============================================================
-- 9. 공지사항 (notices) 데이터
-- ============================================================
INSERT INTO notices (notice_id, notice_author_id, notice_title, notice_content, notice_category, notice_is_pinned, notice_is_visible, notice_view_count)
VALUES
(1, 5, '[안내] 베글루 앱 서비스 런칭 공지', '안녕하세요. 채식주의자를 위한 올인원 가이드 Veglu가 정식 서비스를 시작합니다! 많은 관심 부탁드립니다.', '업데이트', 1, 1, 125),
(2, 5, '[점검] 데이터베이스 정기 점검 안내 (06/15)', '안정적인 서비스 제공을 위해 2026년 6월 15일 새벽 2시부터 4시까지 정기 점검이 진행될 예정입니다.', '점검', 0, 1, 45);

-- 데이터 확인용 쿼리
SELECT 'SUCCESS' AS 'status';