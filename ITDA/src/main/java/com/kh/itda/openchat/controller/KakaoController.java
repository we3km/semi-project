package com.kh.itda.openchat.controller;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/kakao")
public class KakaoController {

    @Value("${kakao.api.key}")
    private String kakaoApiKey;

    @ResponseBody
    @GetMapping("/reverse")
    public Map<String, Object> reverseGeocode(@RequestParam("lat") double lat,
                                              @RequestParam("lng") double lng) {
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
                JsonNode root = mapper.readTree(response.getBody());
                JsonNode documents = root.path("documents");

                if (documents.isArray() && documents.size() > 0) {
                    JsonNode first = documents.get(0);
                    String regionName = first.path("region_1depth_name").asText() + " "
                                      + first.path("region_2depth_name").asText() + " "
                                      + first.path("region_3depth_name").asText();

                    result.put("address", regionName);
                } else {
                    result.put("address", "주소 없음");
                }
            } else {
                result.put("address", "API 호출 실패");
            }
        } catch (Exception e) {
            result.put("address", "오류 발생: " + e.getMessage());
        }

        return result;
    }
}
