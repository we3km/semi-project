package com.kh.itda.location.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.location.dao.locationDao;
import com.kh.itda.location.model.vo.Location;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class locationServiceImpl implements locationService{
	@Autowired
	private locationDao dao;
	
	@Override
	@Transactional(rollbackFor = Exception.class)
	public Long findOrCreate(String sido, String sigungu) {
        // 1) 기존에 있는지 조회
       Location loc = dao.findBySidoSigungu(sido, sigungu);
        if (loc != null) {
            return loc.getLocationId();
        }
        // 2) 없으면 새로 생성
        loc = new Location();
        loc.setSido(sido);
        loc.setSigungu(sigungu);
        
        log.debug("[insertLocation] loc.sido='{}', loc.sigungu='{}'", 
                loc.getSido(), loc.getSigungu());
        
        dao.insertLocation(loc);
        // insertLocation 에 useGeneratedKeys="true" keyProperty="locationId" 가 설정되어 있으면
        // loc.getLocationId() 에 방금 생성된 PK 값이 채워집니다.
        return loc.getLocationId();
    }

	@Override
	public List<String> findAllSido() {
		
		List<String> sidoList = dao.findAllSido();
		
		return sidoList;
	}

	@Override
	public List<String> findSigunguBySido(String sido) {
		List<String> sigunguList = dao.findSigunguBySido(sido);
		
		return sigunguList;
	}

}
