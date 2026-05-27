-- 샘플 테스트 데이터 삽입 스크립트

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE reviews;
TRUNCATE TABLE user_preferences;
TRUNCATE TABLE restaurants;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================
-- 1. users (사용자) - 무료 아바타 프로필 사진 반영
-- ==========================================
INSERT INTO users (user_id, user_email, user_password, user_nickname, user_profile_image_url, user_bio, user_provider, user_role, use_yn)
VALUES 
(1, 'vegan_love@gmail.com', '$2a$10$E2UPv7vYZq9u6jQ1K6pYIuXzMvM1xS6Z6G6z6z6z6z6z6z6z6z6z', '비건바라기', 'https://api.dicebear.com/7.x/avataaars/svg?seed=vegan_love', '맛있는 비건 음식을 찾는 실천가입니다.', 'LOCAL', 'USER', 'Y'),
(2, 'glutenfree_life@naver.com', '$2a$10$E2UPv7vYZq9u6jQ1K6pYIuXzMvM1xS6Z6G6z6z6z6z6z6z6z6z6z', '밀가루아웃', 'https://api.dicebear.com/7.x/avataaars/svg?seed=glutenfree', '글루텐프리 빵지순례 전문 블로거', 'NAVER', 'USER', 'Y'),
(6, 'owner_gangnam@naver.com', '$2a$10$E2UPv7vYZq9u6jQ1K6pYIuXzMvM1xS6Z6G6z6z6z6z6z6z6z6z6z', '강남사장', 'https://api.dicebear.com/7.x/identicon/svg?seed=owner1', '강남에서 비건 레스토랑을 운영 중입니다.', 'LOCAL', 'OWNER', 'Y');

-- ==========================================
-- 2. user_preferences (취향 프로필)
-- ==========================================
INSERT INTO user_preferences (pref_user_id, pref_favorite_categories, pref_disliked_categories, pref_allergies, pref_spicy_level, pref_preferred_price_range, pref_dietary_restrictions)
VALUES 
(1, '["VEGAN_BAKERY", "WESTERN", "SALAD"]', '["KOREAN_TRADITIONAL"]', '["PEANUT"]', 2, 'MEDIUM', '["VEGAN"]'),
(2, '["VEGAN_BAKERY", "DESSERT"]', '["CHINESE"]', '["WHEAT", "BARLEY"]', 1, 'LOW', '["GLUTEN_FREE"]');

-- ==========================================
-- 3. restaurants (비건/GF 식당)
-- ==========================================
INSERT INTO restaurants (restaurant_id, restaurant_name, restaurant_address, restaurant_location, restaurant_latitude, restaurant_longitude, restaurant_phone, restaurant_category, restaurant_sub_category, restaurant_price_range, restaurant_status, restaurant_is_verified, restaurant_owner_id) 
VALUES 
(1, '그린키친 강남점', '서울 강남구 테헤란로 123', ST_PointFromText('POINT(127.0276 37.4979)', 4326), 37.4979, 127.0276, '02-123-4567', 'SALAD', '보울 & 샐러드랩', 'MEDIUM', 'OPEN', 1, 6),
(2, '제로밀 글루텐프리 베이커리', '서울 강남구 강남대로 456', ST_PointFromText('POINT(127.0250 37.5015)', 4326), 37.5015, 127.0250, '02-987-6543', 'VEGAN_BAKERY', '쌀식빵 & 구움과자', 'LOW', 'OPEN', 1, 6);

-- ==========================================
-- 4. reviews (리뷰) - 카테고리별 고화질 음식 이미지 완전 매칭
-- ==========================================
INSERT INTO reviews (review_id, review_restaurant_id, review_user_id, review_rating, review_content, review_photos, review_visit_date, review_recommended_menu, review_like_count, review_sentiment_score) 
VALUES 
-- 1번 식당 (샐러드 맛집 이미지)
(1, 1, 1, 5.0, '강남 한복판에서 이렇게 깔끔하고 맛있는 비건 보울을 먹을 수 있다니 감동입니다!', '["https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=600", "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=600"]', '2026-05-10', '아보카도 템페 보울', 12, 0.95),
-- 2번 식당 (글루텐프리 빵집 이미지)
(4, 2, 2, 5.0, '밀가루 알러지 있어서 빵 끊고 살았는데 속이 진짜 편하고 쫄깃해요!', '["https://images.unsplash.com/photo-1509440159596-0249088772ff?w=600"]', '2026-05-12', '유기농 쌀식빵', 25, 0.98),
-- 3번 식당 (비건 이탈리안 파스타 이미지)
(6, 3, 1, 4.0, '분위기가 너무 좋아서 데이트 코스로 강추합니다. 비건 파스타 풍미가 깊어요.', '["https://images.unsplash.com/photo-1563379091339-03b21ab4a4f8?w=600"]', '2026-05-18', '트러플 오일 버섯 파스타', 6, 0.45);
