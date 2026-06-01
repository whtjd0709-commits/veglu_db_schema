# 🥦 Veglu DB & Backend Integration Guide

채식주의자(비건) 및 글루텐 프리(GF) 식당 큐레이션 서비스 **Veglu**의 데이터베이스(veglu_db) 스펙 및 백엔드 비즈니스 로직 가이드라인입니다.

---

## 🛠️ 1. 개발 환경 및 DB 사양
- **DBMS:** MySQL 8.0 이상 권장
- **공간 인덱스 필수:** 식당 위치 조회를 위해 `SPATIAL INDEX` 및 `SRID 4326(WGS 84)`을 사용합니다. MySQL 내장 공간 엔진 버전을 반드시 확인해 주세요.
- **Timezone:** `Asia/Seoul` (AWS RDS 인스턴스 생성 시 타임존 설정을 무조건 변경해 주세요. 미설정 시 UTC로 작동하여 생성/수정 시간이 9시간 느려집니다.)

---

## 💡 2. 핵심 비즈니스 로직 및 구현 가이드

### 📍 위치 기반 식당 검색 시 주의사항 (`restaurants`)
- `restaurant_location` 컬럼은 위경도 좌표를 저장하는 `POINT` 타입이며, `SRID 4326` 규격을 따릅니다.
- **🚨 중요 (위도/경도 순서 에러 방지):** MySQL의 `SRID 4326` 환경에서는 일반적인 지도 API와 반대로 **`POINT(위도 경도)` 즉, `POINT(Latitude Longitude)` 순서**로 데이터를 다루어야 합니다. 경도를 앞에 넣으면 `Latitude out of range (Error 3617)` 예외가 발생합니다.
- **반경 검색 쿼리 예시:** 내 주변 반경 3km 이내 식당을 가까운 순으로 조회할 때 내장 함수 `ST_Distance_Sphere`를 활용하세요.
  ```sql
  SELECT *, ST_Distance_Sphere(restaurant_location, ST_GeomFromText('POINT(현재위도 현재경도)', 4326)) AS distance
  FROM restaurants
  WHERE ST_Distance_Sphere(restaurant_location, ST_GeomFromText('POINT(현재위도 현재경도)', 4326)) <= 3000
  ORDER BY distance ASC;