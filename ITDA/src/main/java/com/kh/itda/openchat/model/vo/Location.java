package com.kh.itda.openchat.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Location {
    private Long locationId;
    private Double lat;
    private Double lng;
    private String sido;
    private String sigungu;
    private String emd;
}