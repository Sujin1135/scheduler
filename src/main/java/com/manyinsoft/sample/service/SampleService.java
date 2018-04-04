package com.manyinsoft.sample.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.manyinsoft.sample.dao.SampleDao;

@SuppressWarnings("unchecked")
@Service
public class SampleService implements SampleServiceImpl {

	@Autowired
	private SampleDao sampleDao;

	// 게시글 리스트를 보여준다
	public List<HashMap<String, Object>> searchSample(HashMap<String, Object> searchMap, String contextPath){
		List<HashMap<String, Object>> sampleList = sampleDao.searchSample(searchMap);
		for (HashMap<String, Object> sampleMap : sampleList) {
			sampleSettings(sampleMap, contextPath);
		}
		
		return sampleList;
	}
	
	// 게시글 등록한다
	public void insertSample(HashMap<String, Object> insertMap) throws Exception {
		try {
			int key = sampleDao.insertSample(insertMap);
			
			if(key == 0){
				throw new Exception("저장되지 않았습니다.");
			}
			
			int seq = Integer.parseInt(insertMap.get("SEQ").toString());
			List<Integer> addMemberList = (List<Integer>) insertMap.get("addMemberArr");
			
			// 일정을 함께할 멤버가 있을경우
			if (addMemberList != null) {
				int result = addMember(seq, addMemberList);
				
				if (result == 0) {
					throw new Exception("멤버가 추가되지 않았습니다.");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// 특정 게시글을 보여준다
	public List<HashMap<String, Object>> selectSample(HashMap<String, Object> selectMap, String contextPath){
		HashMap<String, Object> sampleMap = sampleDao.selectSample(selectMap);
		sampleSettings(sampleMap, contextPath);
		List<HashMap<String, Object>> sampleList = new ArrayList<>();
		sampleList.add(sampleMap);
		return sampleList;
	}
	
	// 해당 글의 작성자 pk를 알려준다
	public int sampleMemberNo (int no) {
		HashMap<String, Integer> sampleMap = sampleDao.sampleMemberNo(no);
		int memberNo = sampleMap.get("MEMBER_NO");
		return memberNo;
	}
	
	public List<HashMap<String, Object>> mySamples (HashMap<String, Object> param, String contextPath) {
		List<HashMap<String, Object>> sampleList = sampleDao.mySamples(param);
		
		for (HashMap<String, Object> sampleMap : sampleList) {
			sampleSettings(sampleMap, contextPath);
		}
		
		return sampleList;
	}
	
	// 게시글 수정한다
	public void updateSample(HashMap<String, Object> updateMap) throws Exception {
		if(sampleDao.updateSample(updateMap) == 0){
			throw new Exception("저장되지 않았습니다.");
		}
		
		int seq = Integer.parseInt(updateMap.get("SEQ").toString());
		List<Integer> addMemberList = (List<Integer>) updateMap.get("ADDMEMBERLIST");
		List<Integer> deleteMemberList = (List<Integer>) updateMap.get("DELETEMEMBERLIST");
		
		int addResult = addMember(seq, addMemberList);
		int deleteResult = deleteMember(seq, deleteMemberList);
	}
	
	// 게시글 삭제한다
	public void deleteSample(HashMap<String, Object> deleteMap) throws Exception {
		int result = sampleDao.deleteSample(deleteMap);
		if (result == 0) throw new Exception("게시글이 삭제되지 않았습니다.");
	}
	
	// 해당 일정에 참여하는 멤버 목록조회
	public List<HashMap<String, Object>> selectPartyMember (int no) {
		return sampleDao.selectPartyMember(no);
	}
	
	// 일정을 함께할 멤버를 등록하는 메서드
	private int addMember (int seq, List<Integer> addMemberList) {
		HashMap<String, Integer> addMemberMap = new HashMap<String, Integer>();
		
		for (int member : addMemberList) {
			addMemberMap.put("seq", seq);
			addMemberMap.put("memberNo", member);
			int result = sampleDao.insertSampleMember(addMemberMap);
			
			if (result == 0) {
				return 0;
			}
		}
		
		return 1;
	}
	
	// 일정을 함께하던 멤버 삭제
	private int deleteMember (int seq, List<Integer> deleteMemberList) {
		HashMap<String, Integer> deleteMemberMap = new HashMap<String, Integer>();
		
		for (int member : deleteMemberList) {
			deleteMemberMap.put("SEQ", seq);
			deleteMemberMap.put("memberNo", member);
			int result = sampleDao.deleteSampleMember(deleteMemberMap);
			
			if (result == 0) {
				return 0;
			}
		}
		
		return 1;
	}
	
	// 게시글의 정보를 풀캘린더에서 바로 읽어들일 수 있도록 세팅한다
	private void sampleSettings (HashMap<String, Object> map, String contextPath) {
		// 풀캘린더에서 데이터를 읽어들일수 있게 값 세팅
		map.put("id", map.get("SEQ"));
		map.put("memberNo", map.get("MEMBER_NO"));
		map.put("url", contextPath+ "/sample/sampleUpdateView?seq=" + map.get("SEQ"));
		map.put("textColor", "white");
		map.put("title", map.get("TITLE"));
		map.put("content", map.get("CONTENT"));
		map.put("start", map.get("START_DATE"));
		map.put("end", map.get("END_DATE"));
		map.put("name", map.get("NAME"));
		map.put("type", map.get("TYPE"));
		
		// 이전에 받아온 키 삭제
		map.remove("SEQ");
		map.remove("MEMBER_NO");
		map.remove("TITLE");
		map.remove("CONTENT");
		map.remove("START_DATE");
		map.remove("END_DATE");
		map.remove("NAME");
		map.remove("TYPE");
		if (map.get("type") != null) {
			int type = Integer.parseInt(map.get("type").toString());
			if (type == 1) {
				// 휴가
				map.put("color", "#00bfff");
			} else if (type == 2) {
				// 회의
				map.put("color", "#32cd32");
			} else if (type == 3) {
				// 교육
				map.put("color", "#088A68");
			} else if (type == 4) {
				// 야근
				map.put("color", "#7401DF");
			}
		}
	}
}