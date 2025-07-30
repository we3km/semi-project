package com.kh.itda.security.repository;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

public class CustomPersistentTokenRepository implements PersistentTokenRepository{

	private final SqlSession sqlSession;
	
	public CustomPersistentTokenRepository(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	@Override
	public void createNewToken(PersistentRememberMeToken token) {
		sqlSession.insert("security.insertToken", token);
	}

	@Override
	public void updateToken(String series, String tokenValue, Date lastUsed) {
		Map<String, Object> param = new HashMap<>();
		param.put("series", series);
		param.put("tokenValue", tokenValue);
		param.put("lastUsed", lastUsed);
		sqlSession.update("security.updateToken", param);
	}

	@Override
	public PersistentRememberMeToken getTokenForSeries(String seriesId) {
		return sqlSession.selectOne("security.selectToken", seriesId);
	}

	@Override
	public void removeUserTokens(String userNum) {
		sqlSession.delete("security.deleteTokensByUserNum", userNum);
	}

}
