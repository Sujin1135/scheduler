package com.manyinsoft.member.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface MemberService {
	public void insertMember (Map<String, Object> param) throws Exception;
	public int loginMember (Map<String, Object> param);
	public Map<String, Object> memberOne (int no) throws Exception;
	public void updateMember (Map<String, Object> param) throws Exception;
	public List<HashMap<String, Object>> searchMember (Map<String, Object> param);
}
