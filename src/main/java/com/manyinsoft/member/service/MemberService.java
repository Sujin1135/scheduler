package com.manyinsoft.member.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manyinsoft.member.dao.MemberDao;

@Service
public class MemberService implements MemberServiceImpl {
	
	@Autowired
	private MemberDao memberDao;
	
	public void insertMember (Map<String, Object> param) throws Exception {
		if (memberDao.insertMember(param) == 0) throw new Exception ("회원 등록이 되지 않았습니다.");
	}
	
	public Map<String, Object> loginMember (Map<String, Object> param) throws Exception {
		Map<String, Object> resultMap = memberDao.loginMember(param);
		if (resultMap == null) throw new Exception ("아이디 & 비밀번호 불일치");
		return resultMap;
	}
	
	public Map<String, Object> memberOne (int no) throws Exception {
		Map<String, Object> resultMap = memberDao.memberOne(no);
		if (resultMap == null) {
			throw new Exception("멤버 정보 에러");
		}
		return resultMap;
	}
	
	public void updateMember (Map<String, Object> param) throws Exception {
		int result = memberDao.updateMember(param);
		
		if (result < 1) throw new Exception("수정 에러");
	}
}
 