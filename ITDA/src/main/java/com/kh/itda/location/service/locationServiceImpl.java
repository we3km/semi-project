package com.kh.itda.location.service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collector;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.common.LocationUtils;
import com.kh.itda.location.dao.locationDao;
import com.kh.itda.location.model.vo.Location;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class locationServiceImpl implements locationService {
	@Autowired
	private locationDao dao;

	@Override
	@Transactional(rollbackFor = Exception.class)
	public Long findOrCreate(String sido, String sigungu) {

		if (LocationUtils.SIDO_MAP.containsKey(sido)) {
			sido = LocationUtils.SIDO_MAP.get(sido); // "서울" → "서울특별시"
		}
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
				loc.getSido(),
				loc.getSigungu());

		dao.insertLocation(loc);

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

	@Override
	public List<String> findSigunListBySido(String sido) {
		List<String> sigunguList = dao.findSigunguBySido(sido);

		List<String> sigunList = sigunguList.stream().filter(s -> s.contains(" ")) // 시 군 형식만
				.map(s -> s.split(" ")[0]) // 앞부분만 자름 → 수원시
				.distinct().collect(Collectors.toList());

		return sigunList;
	}

	@Override
	public List<String> findGuListBySigun(String sido, String sigun) {
		List<String> sigunguList = dao.findSigunguBySido(sido);

		return sigunguList.stream().filter(s -> s.startsWith(sigun + " ")).map(s -> s.split(" ")[1]) // "수원시 팔달구" →"팔달구"
																										
				.distinct().collect(Collectors.toList());
	}

	@Override
	public List<String> findGuListBySidoIfDirect(String sido) {
		return dao.findGuListBySidoIfDirect(sido);
	}

}
