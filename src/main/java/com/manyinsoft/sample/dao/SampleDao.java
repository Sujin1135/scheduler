package com.manyinsoft.sample.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class SampleDao {

	@Autowired
	private SqlSession sqlSession;
	
	// 검색
	public List<HashMap<String, Object>> searchSample(HashMap<String, Object> hashMap) {
		return sqlSession.selectList("com.manyinsoft.common.sql.SampleMapper.searchSample", hashMap);
	}
	
	// 등록
	public int insertSample(HashMap<String, Object> hashMap) {
		return sqlSession.insert("com.manyinsoft.common.sql.SampleMapper.insertSample", hashMap);
	}
	
	// 상세정보 조회
	public HashMap<String, Object> selectSample(HashMap<String, Object> selectMap) {
		return sqlSession.selectOne("com.manyinsoft.common.sql.SampleMapper.selectSample", selectMap);
	}
	
	// 수정
	public int updateSample(HashMap<String, Object> hashMap) {
		return sqlSession.update("com.manyinsoft.common.sql.SampleMapper.updateSample", hashMap);
	}
	
	// 삭제
	public int deleteSample(HashMap<String, Object> hashMap) {
		return sqlSession.update("com.manyinsoft.common.sql.SampleMapper.deleteSample", hashMap);
	}
}