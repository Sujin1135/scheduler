package com.manyinsoft.member.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manyinsoft.member.dao.MemberDao;

@Service
public class MemberService implements MemberServiceImpl {
	
	@Autowired
	private MemberDao memberDao;
	
	// 회원 등록
	public void insertMember (Map<String, Object> param) throws Exception {
		if (memberDao.insertMember(param) == 0) throw new Exception ("아이디가 중복되었습니다.");
	}
	
	// 로그인
	public int loginMember (Map<String, Object> param) {
		Map<String, Object> resultMap = memberDao.loginMember(param);
		
		// 아이디 불일치
		if (resultMap == null) return -1;
		
		// 비밀번호 불일치
		if (resultMap.get("PW_VALID_CHECK") == null) return 0;
		
		// 로그인 성공
		return (int)resultMap.get("NO");
	}
	
	// 회원 상세정보
	public Map<String, Object> memberOne (int no) throws Exception {
		Map<String, Object> resultMap = memberDao.memberOne(no);
		if (resultMap == null) {
			throw new Exception("멤버 정보 에러");
		}
		return resultMap;
	}
	
	// 회원정보 수정
	public void updateMember (Map<String, Object> param) throws Exception {
		int result = memberDao.updateMember(param);
		
		if (result == 0) throw new Exception("수정 에러");
	}
	
	// 회원 이름으로 검색
	public List<HashMap<String, Object>> searchMember (Map<String, Object> param) {
		return memberDao.searchMember(param);
	}
}
 