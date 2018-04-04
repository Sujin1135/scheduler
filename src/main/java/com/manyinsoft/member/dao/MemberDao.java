package com.manyinsoft.member.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MemberDao {
	
	@Autowired
	private SqlSession sqlSession;
	
	public int insertMember (Map<String, Object> param) {
		return sqlSession.insert("com.manyinsoft.common.sql.MemberMapper.insert", param);
	}
	
	public Map<String, Object> loginMember (Map<String, Object> param) {
		return sqlSession.selectOne("com.manyinsoft.common.sql.MemberMapper.login", param);
	}
	
	public Map<String, Object> memberOne (int no) {
		return sqlSession.selectOne("com.manyinsoft.common.sql.MemberMapper.memberOne", no);
	}
	
	public int updateMember (Map<String, Object> param) {
		return sqlSession.update("com.manyinsoft.common.sql.MemberMapper.update", param);
	}
	
	public List<HashMap<String, Object>> searchMember (Map<String, Object> param) {
		return sqlSession.selectList("com.manyinsoft.common.sql.MemberMapper.searchMember", param);
	}
}
