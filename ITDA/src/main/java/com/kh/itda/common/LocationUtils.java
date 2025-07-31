package com.kh.itda.common;

import java.util.*;

public class LocationUtils {
    public static final Map<String, String> SIDO_MAP;

    static {
        SIDO_MAP = new HashMap<>();
        SIDO_MAP.put("서울", "서울특별시");
        SIDO_MAP.put("부산", "부산광역시");
        SIDO_MAP.put("대구", "대구광역시");
        SIDO_MAP.put("인천", "인천광역시");
        SIDO_MAP.put("광주", "광주광역시");
        SIDO_MAP.put("대전", "대전광역시");
        SIDO_MAP.put("울산", "울산광역시");
        SIDO_MAP.put("세종", "세종특별자치시");
        SIDO_MAP.put("경기", "경기도");
        SIDO_MAP.put("강원", "강원도");
        SIDO_MAP.put("충북", "충청북도");
        SIDO_MAP.put("충남", "충청남도");
        SIDO_MAP.put("전북", "전라북도");
        SIDO_MAP.put("전남", "전라남도");
        SIDO_MAP.put("경북", "경상북도");
        SIDO_MAP.put("경남", "경상남도");
        SIDO_MAP.put("제주", "제주특별자치도");
    }
}
