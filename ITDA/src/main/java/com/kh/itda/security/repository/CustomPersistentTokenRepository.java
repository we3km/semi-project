package com.kh.itda.security.repository;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.security.web.authentication.rememberme.PersistentRememberMeToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenRepository;

public class CustomPersistentTokenRepository  implements PersistentTokenRepository {

	private final SqlSession sqlSession;
	
	public CustomPersistentTokenRepository(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	@Override
	public void createNewToken(PersistentRememberMeToken token) {
		Map<String, Object> param = new HashMap<>();
	    param.put("series", token.getSeries());
	    param.put("username", token.getUsername()); // 실제로는 userNum이 문자열로 들어옴
	    param.put("token", token.getTokenValue());
	    param.put("lastUsed", token.getDate());
	    sqlSession.insert("security.insertToken", param);
	}

	@Override
	public void updateToken(String series, String token, Date lastUsed) {
		Map<String, Object> param = new HashMap<>();
		param.put("series", series);
		param.put("token", token);
		param.put("lastUsed", lastUsed);
		sqlSession.update("security.updateToken", param);
	}

	@Override
	public PersistentRememberMeToken getTokenForSeries(String seriesId) {
		return sqlSession.selectOne("security.selectToken", seriesId);
	}

	@Override
	public void removeUserTokens(String userNum) {
		sqlSession.delete("security.deleteTokensByUserNum", Map.of("username", userNum));
	}

}
