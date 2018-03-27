package com.manyinsoft.member.service;

import java.util.Map;

public interface MemberServiceImpl {
	public void insertMember (Map<String, Object> param) throws Exception;
	public Map<String, Object> loginMember (Map<String, Object> param) throws Exception;
	public Map<String, Object> memberOne (int no) throws Exception;
	public void updateMember (Map<String, Object> param) throws Exception;
}
