package com.kh.itda.common.controller;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

/*@CrossOrigin(origins = "http://localhost:8085/")*/
@Controller
@RequestMapping("/kakao")
public class KakaoController {

    @Value("${kakao.api.key}")
    private String kakaoApiKey;
    
    @PostConstruct
    public void init() {
    	  // 1) @Value 주입 체크
        System.out.println(">> @Value Kakao Key = " + kakaoApiKey);
    }

    @ResponseBody
    @GetMapping("/reverse")
    public Map<String, Object> reverseGeocode(@RequestParam("lat") String lat,
                                              @RequestParam("lng") String lng) {
        Map<String, Object> result = new HashMap<>();
        try {
            String url = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"
                       + "?x=" + URLEncoder.encode(String.valueOf(lng), "UTF-8")
                       + "&y=" + URLEncoder.encode(String.valueOf(lat), "UTF-8");

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "KakaoAK " + kakaoApiKey);
            HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

            RestTemplate restTemplate = new RestTemplate();
            ResponseEntity<String> response = restTemplate.exchange(
                    URI.create(url),
                    HttpMethod.GET,
                    requestEntity,
                    String.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode first = mapper.readTree(response.getBody())
                                       .path("documents").get(0);

                String region1 = first.path("region_1depth_name").asText();  // ex. "서울특별시"
                String region2 = first.path("region_2depth_name").asText();  // ex. "서초구"
                String region3 = first.path("region_3depth_name").asText();  // ex. "반포동"
                String fullAddr = String.join(" ", region1, region2, region3);

                result.put("address", fullAddr);
                result.put("sido",    region1);
                result.put("sigungu", region2);
            } else {
                result.put("address", "API 호출 실패");
            }
        } catch (Exception e) {
            result.put("address", "오류 발생: " + e.getMessage());
        }

        return result;
    }
}