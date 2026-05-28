-- ============================================================
-- 테스트 데이터 삽입 스크립트
-- 대상: users, user_preferences, restaurants, reviews
-- ※ 재실행 시 기존 데이터를 삭제 후 재삽입합니다.
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE reviews;
TRUNCATE TABLE user_preferences;
TRUNCATE TABLE restaurants;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------
-- 1. users
-- -------------------------------------------------------
INSERT INTO users (user_email, user_password, user_nickname, user_profile_image_url, user_bio, user_provider, user_role, user_created_at, user_last_login_at) VALUES
('admin@greenfork.kr',    '$2b$12$hashedpw001', '관리자',     'https://cdn.greenfork.kr/profiles/admin.jpg',   '그린포크 운영팀입니다.',       'LOCAL',  'ADMIN', '2024-01-01 09:00:00', '2025-05-20 10:00:00'),
('owner1@vegieplace.kr',  '$2b$12$hashedpw002', '채식당주인1', 'https://cdn.greenfork.kr/profiles/owner1.jpg',  '비건 식당을 운영하고 있습니다.', 'LOCAL',  'OWNER', '2024-02-10 11:30:00', '2025-05-19 08:45:00'),
('owner2@soulgreen.kr',   '$2b$12$hashedpw003', '채식당주인2', 'https://cdn.greenfork.kr/profiles/owner2.jpg',  '서울 비건 맛집 운영 중.',       'KAKAO',  'OWNER', '2024-03-05 14:00:00', '2025-05-18 12:00:00'),
('user1@gmail.com',       '$2b$12$hashedpw004', '비건여정',   'https://cdn.greenfork.kr/profiles/user1.jpg',   '채식 3년차, 맛집 탐방 중 🌿',   'GOOGLE', 'USER',  '2024-04-01 10:00:00', '2025-05-21 07:30:00'),
('user2@naver.com',       '$2b$12$hashedpw005', '글루텐프리',  'https://cdn.greenfork.kr/profiles/user2.jpg',   '밀 알러지 있어요. GF 전문가!',  'NAVER',  'USER',  '2024-04-15 09:15:00', '2025-05-20 18:00:00'),
('user3@kakao.com',       NULL,                 '초록밥상',   'https://cdn.greenfork.kr/profiles/user3.jpg',   '채식 입문 중입니다.',           'KAKAO',  'USER',  '2024-05-20 16:00:00', '2025-05-17 20:10:00'),
('user4@apple.com',       NULL,                 '플랜트베이스', 'https://cdn.greenfork.kr/profiles/user4.jpg',  '비건 1년차 도전!',              'APPLE',  'USER',  '2024-06-01 08:00:00', '2025-05-21 09:00:00'),
('user5@gmail.com',       '$2b$12$hashedpw008', '할랄탐방러',  'https://cdn.greenfork.kr/profiles/user5.jpg',   '할랄 음식 위주로 먹어요.',       'GOOGLE', 'USER',  '2024-07-10 11:00:00', '2025-05-16 14:30:00');


-- -------------------------------------------------------
-- 2. user_preferences
-- -------------------------------------------------------
INSERT INTO user_preferences (pref_user_id, pref_favorite_categories, pref_disliked_categories, pref_allergies, pref_spicy_level, pref_preferred_price_range, pref_dietary_restrictions) VALUES
(4, '["한식","카페"]',           '["패스트푸드"]',      '["우유","달걀"]',      2, '10000~20000', '["비건"]'),
(5, '["샐러드","브런치"]',       '["한식"]',            '["밀"]',               1, '15000~25000', '["글루텐프리"]'),
(6, '["한식","분식"]',           '[]',                  '[]',                   3, '8000~15000',  '["베지테리안"]'),
(7, '["지중해식","샐러드"]',     '["튀김류"]',          '["견과류"]',           0, '15000~30000', '["비건","글루텐프리"]'),
(8, '["중동식","할랄"]',         '["돼지고기요리"]',    '[]',                   2, '10000~20000', '["할랄"]');


-- -------------------------------------------------------
-- 3. restaurants
-- -------------------------------------------------------
INSERT INTO restaurants (
    restaurant_name, restaurant_address, restaurant_address_detail,
    restaurant_location, restaurant_latitude, restaurant_longitude,
    restaurant_phone, restaurant_category, restaurant_sub_category,
    restaurant_price_range, restaurant_business_hours, restaurant_holidays,
    restaurant_last_order_time, restaurant_avg_rating, restaurant_review_count,
    restaurant_has_parking, restaurant_has_room, restaurant_has_delivery,
    restaurant_has_reservation, restaurant_payment_methods, restaurant_amenities,
    restaurant_tags, restaurant_atmosphere, restaurant_sns_links,
    restaurant_status, restaurant_is_verified, restaurant_owner_id
) VALUES
(
    '초록밥상',
    '서울특별시 마포구 연남로 45',
    '1층',
    ST_GeomFromText('POINT(37.5632 126.9235)', 4326),
    37.5632, 126.9235,
    '02-1234-5678',
    '채소',
    '한식',
    '10000~20000',
    '{"월":{"open":"11:00","close":"21:00"},"화":{"open":"11:00","close":"21:00"},"수":{"open":"11:00","close":"21:00"},"목":{"open":"11:00","close":"21:00"},"금":{"open":"11:00","close":"21:30"},"토":{"open":"10:30","close":"21:30"},"일":{"open":"10:30","close":"20:00"}}',
    '매주 화요일',
    '20:00',
    4.5, 23,
    0, 1, 0, 1,
    '["카드","현금","카카오페이"]',
    '["WiFi","콘센트"]',
    '["#비건","#한식","#연남동맛집","#채식"]',
    '["조용한","아늑한","감성적인"]',
    '{"instagram":"https://instagram.com/chokrokbapsang","blog":"https://blog.naver.com/chokrok"}',
    'OPEN', 1, 2
),
(
    '그린가든 샐러드바',
    '서울특별시 강남구 테헤란로 212',
    '지하 1층',
    ST_GeomFromText('POINT(37.5045 127.0490)', 4326),
    37.5045, 127.0490,
    '02-2345-6789',
    '채소',
    '샐러드',
    '15000~25000',
    '{"월":{"open":"10:00","close":"22:00"},"화":{"open":"10:00","close":"22:00"},"수":{"open":"10:00","close":"22:00"},"목":{"open":"10:00","close":"22:00"},"금":{"open":"10:00","close":"22:00"},"토":{"open":"11:00","close":"21:00"},"일":{"open":"11:00","close":"20:00"}}',
    '명절 연휴',
    '21:30',
    4.2, 18,
    1, 0, 1, 0,
    '["카드","현금","네이버페이","카카오페이"]',
    '["WiFi","주차","포장용기"]',
    '["#샐러드바","#강남맛집","#글루텐프리","#건강식"]',
    '["밝은","캐주얼한","깔끔한"]',
    '{"instagram":"https://instagram.com/greengarden_seoul"}',
    'OPEN', 1, 3
),
(
    '플랜트키친',
    '서울특별시 용산구 이태원로 180',
    '2층',
    ST_GeomFromText('POINT(37.5344 126.9942)', 4326),
    37.5344, 126.9942,
    '02-3456-7890',
    '채소',
    '서양식',
    '20000~35000',
    '{"월":{"open":"12:00","close":"22:00"},"화":{"open":"12:00","close":"22:00"},"수":{"open":"12:00","close":"22:00"},"목":{"open":"12:00","close":"22:00"},"금":{"open":"12:00","close":"23:00"},"토":{"open":"11:30","close":"23:00"},"일":{"open":"11:30","close":"21:00"}}',
    '매주 월요일',
    '21:30',
    4.7, 41,
    0, 1, 0, 1,
    '["카드","카카오페이","애플페이"]',
    '["WiFi","콘센트","룸서비스"]',
    '["#플랜트베이스","#이태원맛집","#비건","#서양식"]',
    '["트렌디한","로맨틱한","고급스러운"]',
    '{"instagram":"https://instagram.com/plantkitchen_it","naver":"https://blog.naver.com/plantkitchen"}',
    'OPEN', 1, 2
),
(
    '두부명가',
    '서울특별시 종로구 인사동길 32',
    '본관 1층',
    ST_GeomFromText('POINT(37.5745 126.9853)', 4326),
    37.5745, 126.9853,
    '02-4567-8901',
    '두부/콩류',
    '한식',
    '12000~22000',
    '{"월":{"open":"11:00","close":"21:00"},"화":{"open":"11:00","close":"21:00"},"수":{"open":"11:00","close":"21:00"},"목":{"open":"11:00","close":"21:00"},"금":{"open":"11:00","close":"21:00"},"토":{"open":"10:30","close":"21:30"},"일":{"open":"10:30","close":"20:30"}}',
    '설날, 추석',
    '20:30',
    4.3, 56,
    0, 1, 0, 1,
    '["카드","현금"]',
    '["WiFi","단체석"]',
    '["#두부","#사찰음식","#인사동","#전통"]',
    '["전통적인","조용한","고즈넉한"]',
    '{"blog":"https://blog.naver.com/doubumyungga"}',
    'OPEN', 1, NULL
),
(
    '얼스카페 성수',
    '서울특별시 성동구 성수이로 93',
    '1층',
    ST_GeomFromText('POINT(37.5444 127.0557)', 4326),
    37.5444, 127.0557,
    '02-5678-9012',
    '카페',
    '비건카페',
    '6000~12000',
    '{"월":{"open":"09:00","close":"20:00"},"화":{"open":"09:00","close":"20:00"},"수":{"open":"09:00","close":"20:00"},"목":{"open":"09:00","close":"20:00"},"금":{"open":"09:00","close":"21:00"},"토":{"open":"10:00","close":"21:00"},"일":{"open":"10:00","close":"19:00"}}',
    '연중무휴',
    '19:30',
    4.6, 34,
    0, 0, 0, 0,
    '["카드","카카오페이","네이버페이"]',
    '["WiFi","콘센트","반려동물동반"]',
    '["#비건카페","#성수동","#오트라떼","#디저트"]',
    '["힙한","캐주얼한","아늑한"]',
    '{"instagram":"https://instagram.com/earthcafe_seongsu"}',
    'OPEN', 1, 3
);


-- -------------------------------------------------------
-- 4. reviews
-- -------------------------------------------------------
INSERT INTO reviews (
    review_restaurant_id, review_user_id,
    review_rating, review_taste_rating, review_service_rating, review_atmosphere_rating, review_price_rating,
    review_content, review_photos, review_visit_date, review_companion_count,
    review_recommended_menu, review_like_count, review_sentiment_score
) VALUES
-- 초록밥상 (restaurant_id=1)
(1, 4, 5.0, 5.0, 4.5, 5.0, 4.5,
 '연남동에서 이렇게 맛있는 비건 한식을 먹을 수 있다니 정말 놀랐어요. 나물 비빔밥이 특히 맛있었고 된장찌개도 100% 채소로 만들었는데 전혀 아쉽지 않았어요. 분위기도 아늑해서 데이트하기에도 딱 좋아요!',
 '["https://cdn.greenfork.kr/review/r1_1.jpg","https://cdn.greenfork.kr/review/r1_2.jpg"]',
 '2025-05-10', 2, '나물비빔밥, 된장찌개 세트', 12, 0.92),

(1, 6, 4.0, 4.5, 4.0, 4.0, 3.5,
 '채식 입문하고 처음 간 가게인데 생각보다 훨씬 맛있어서 깜짝 놀랐어요. 직원분도 친절하게 메뉴 추천해 주셔서 좋았습니다. 가격이 조금 있긴 한데 퀄리티 생각하면 납득돼요.',
 '["https://cdn.greenfork.kr/review/r1_3.jpg"]',
 '2025-04-22', 1, '채소된장찌개 정식', 7, 0.78),

(1, 8, 4.5, 4.5, 5.0, 4.5, 4.0,
 '할랄 여부를 물어봤더니 친절하게 설명해 주셨어요. 완전한 할랄 인증은 아니지만 돼지고기와 주류를 사용하지 않아서 안심하고 먹었습니다. 맛도 훌륭해요.',
 '[]',
 '2025-05-01', 3, '버섯전골', 5, 0.85),

-- 그린가든 샐러드바 (restaurant_id=2)
(2, 5, 4.0, 4.0, 4.0, 3.5, 4.5,
 '글루텐프리 옵션이 따로 있어서 정말 좋았어요. 샐러드 재료도 신선하고 드레싱 종류가 많아서 매번 다르게 즐길 수 있어요. 강남 직장인 점심으로 강추합니다!',
 '["https://cdn.greenfork.kr/review/r2_1.jpg","https://cdn.greenfork.kr/review/r2_2.jpg","https://cdn.greenfork.kr/review/r2_3.jpg"]',
 '2025-05-15', 1, 'GF 그레인볼 + 발사믹 드레싱', 9, 0.80),

(2, 7, 4.5, 4.5, 4.0, 4.5, 4.5,
 '플랜트베이스 식단을 시작하고 자주 찾게 된 곳이에요. 다양한 채소와 견과류를 직접 고를 수 있는 점이 마음에 들고, 영양 정보도 잘 표시되어 있어요.',
 '["https://cdn.greenfork.kr/review/r2_4.jpg"]',
 '2025-05-08', 1, '비건 파워볼', 6, 0.88),

(2, 4, 3.5, 3.5, 4.0, 3.0, 4.0,
 '재료는 신선한데 맛이 좀 심심한 편이에요. 드레싱을 더 다양하게 늘려주셨으면 좋겠어요. 직원분들은 친절하셔서 좋았습니다.',
 '[]',
 '2025-03-30', 2, '클래식 그린볼', 2, 0.35),

-- 플랜트키친 (restaurant_id=3)
(3, 4, 5.0, 5.0, 5.0, 5.0, 4.0,
 '이태원에서 찾은 최고의 비건 레스토랑! 파스타부터 피자까지 모두 비건으로 즐길 수 있어요. 플레이팅도 예쁘고 맛도 훌륭해서 비건이 아닌 친구들도 모두 만족했어요. 기념일에 다시 방문하고 싶어요.',
 '["https://cdn.greenfork.kr/review/r3_1.jpg","https://cdn.greenfork.kr/review/r3_2.jpg","https://cdn.greenfork.kr/review/r3_3.jpg","https://cdn.greenfork.kr/review/r3_4.jpg"]',
 '2025-05-03', 2, '버섯 트러플 파스타, 비건 티라미수', 24, 0.97),

(3, 5, 5.0, 4.5, 5.0, 5.0, 4.0,
 '글루텐프리 파스타도 주문 가능해서 정말 행복했어요. 셰프님이 직접 나와서 알러지 확인해 주시는 세심함에 감동받았습니다. 조금 비싸지만 특별한 날에 오기 딱 좋아요.',
 '["https://cdn.greenfork.kr/review/r3_5.jpg","https://cdn.greenfork.kr/review/r3_6.jpg"]',
 '2025-04-18', 2, 'GF 크림파스타', 19, 0.95),

(3, 7, 4.5, 4.5, 5.0, 5.0, 3.5,
 '인테리어가 너무 예뻐서 사진 찍기 좋아요. 비건 와인도 있어서 식사와 함께 즐기기 좋았습니다. 다만 예약이 꽉 차서 한 달 전부터 예약해야 한다는 점이 아쉬워요.',
 '["https://cdn.greenfork.kr/review/r3_7.jpg"]',
 '2025-05-12', 4, '비건 버거 플레이트', 15, 0.89),

-- 두부명가 (restaurant_id=4)
(4, 6, 4.5, 5.0, 4.0, 4.5, 4.5,
 '인사동에 이런 맛집이 있었다니! 두부 요리를 이렇게 다양하게 즐길 수 있다는 게 신기해요. 두부 김치찌개와 연두부 샐러드가 환상의 조합이었어요. 어머니 모시고 오기 딱 좋은 곳이에요.',
 '["https://cdn.greenfork.kr/review/r4_1.jpg","https://cdn.greenfork.kr/review/r4_2.jpg"]',
 '2025-04-05', 4, '두부전골, 연두부 샐러드', 11, 0.91),

(4, 8, 4.0, 4.0, 4.0, 4.5, 4.5,
 '할랄 인증은 없지만 돼지고기와 알코올을 사용하지 않는 메뉴들이 많아서 이용하기 좋아요. 사찰음식 스타일이라 깔끔하고 건강한 맛입니다. 관광객도 많이 오는 것 같아요.',
 '["https://cdn.greenfork.kr/review/r4_3.jpg"]',
 '2025-03-20', 2, '순두부 정식', 8, 0.77),

(4, 4, 4.0, 4.0, 3.5, 4.0, 4.5,
 '두부 요리 전문점답게 메뉴가 정말 다양해요. 가격도 합리적이고 양도 푸짐합니다. 다만 점심시간엔 줄이 꽤 길어요. 오픈 시간에 맞춰 가는 걸 추천합니다.',
 '[]',
 '2025-05-07', 1, '두부 비빔밥', 4, 0.72),

-- 얼스카페 성수 (restaurant_id=5)
(5, 7, 5.0, 5.0, 5.0, 5.0, 5.0,
 '성수동 최고의 비건 카페! 오트밀크 라떼가 너무 맛있어요. 케이크도 비건인데 일반 케이크보다 맛있어서 깜짝 놀랐어요. 강아지도 입장 가능해서 반려동물 가진 분들께 특히 추천해요. 단골됩니다!',
 '["https://cdn.greenfork.kr/review/r5_1.jpg","https://cdn.greenfork.kr/review/r5_2.jpg","https://cdn.greenfork.kr/review/r5_3.jpg"]',
 '2025-05-18', 1, '오트밀크 라떼, 비건 당근 케이크', 21, 0.98),

(5, 5, 4.5, 5.0, 4.5, 4.5, 4.5,
 '글루텐프리 베이킹 옵션이 있어서 정말 좋아요. 대부분의 음료가 오트/아몬드/코코넛 밀크로 대체 가능하고 추가 요금도 합리적이에요. 공간도 넓고 콘센트도 많아서 작업하기 좋아요.',
 '["https://cdn.greenfork.kr/review/r5_4.jpg"]',
 '2025-05-14', 1, '아몬드 아이스 아메리카노', 14, 0.90),

(5, 6, 4.5, 4.5, 5.0, 4.5, 4.0,
 '처음 비건 카페를 가봤는데 편견이 완전히 깨졌어요! 직원분이 메뉴 하나하나 설명해 주셔서 처음 온 사람도 주문하기 편했어요. 다음엔 친구들도 데려와야겠어요.',
 '["https://cdn.greenfork.kr/review/r5_5.jpg","https://cdn.greenfork.kr/review/r5_6.jpg"]',
 '2025-05-20', 2, '비건 크로플', 9, 0.87);
