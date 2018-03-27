package com.manyinsoft.sample.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.manyinsoft.sample.service.SampleService;

@Controller
public class SampleController {
	// 로그 출력할 때 사용한다.
	Logger logger = LoggerFactory.getLogger(SampleController.class);
	
	@Autowired
	private SampleService sampleService;
	
	@Autowired
	private HttpSession session;
	
	// 해당 url 주소로 접근할 경우 views/sample/sampleListView.jsp 를 호출한다.
	@RequestMapping(value = "/sample/sampleListView", method = RequestMethod.GET)
	public String sampleListView(HttpServletRequest request) {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "/sample/sampleListView";
	}
	
	// 비동기 통신을 하는 RequestMapping
	@ResponseBody
	@RequestMapping(value = "/sample/searchSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> searchSample(@RequestParam HashMap<String, Object> requestParam) throws Exception {
		
		// key값이 likeTitle로 넘어온 값을 받아서 likeTitle에 저장한다.
		String likeTitle = (String) requestParam.get("likeTitle");
		
		HashMap<String, Object> searchMap = new HashMap<String, Object>();
		System.out.println("calenderSelect: " + requestParam.get("calendarSelect"));
		// likeTitle이 값이 있을때
		if(likeTitle != null && !"".equals(likeTitle)){
			searchMap.put("LIKE_TITLE", "%" + likeTitle.toUpperCase() + "%");
		}
		searchMap.put("TYPE_SELECT", requestParam.get("typeSelect"));
		searchMap.put("CALENDAR_SELECT", requestParam.get("calendarSelect"));
		
		// 결과정보를 저장할 HashMap
		HashMap<String, Object> responseBody = new HashMap<String, Object>();
		
		// 조회 목록을 저장할 List
		List<HashMap<String, Object>> sampleList = sampleService.searchSample(searchMap);
		
		// 반환할 HashMap에 결과 List 저장
		responseBody.put("sampleList", sampleList);
				
		return responseBody;
	}
	
	// 게시물 작성화면
	@RequestMapping(value = "/sample/sampleCreateView", method = RequestMethod.GET)
	public String sampleCreateView(HttpServletRequest request) {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "sample/sampleCreateView";
	}
	
	// 게시물 등록
	@ResponseBody
	@RequestMapping(value = "/sample/insertSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> insertSample(@RequestParam HashMap<String, Object> requestParam){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			sampleService.insertSample(requestParam);
			resultMap.put("result", "SUCCESS");
		}catch(Exception e){
			resultMap.put("result", "FAIL");
			resultMap.put("errorMsg", e.getMessage());
		}

		return resultMap;
	}	
	
	// 게시물 수정화면
	@RequestMapping(value = "/sample/sampleUpdateView", method = RequestMethod.GET)
	public String scrinDetailView(HttpServletRequest request) {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "sample/sampleUpdateView";
	}
	
	@RequestMapping(value = "/sample/sampleOneView", method = RequestMethod.GET)
	public String scrinOneView() {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "sample/sampleOneView";
	}
	
	// 게시물 상세보기
	@ResponseBody
	@RequestMapping(value = "/sample/selectSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> scrinDetailView(HttpServletRequest request, @RequestParam HashMap<String, Object> requestParam) {
		
		HashMap<String, Object> responseBody = new HashMap<String, Object>();
		
		responseBody.put("sample", sampleService.selectSample(requestParam));
				
		return responseBody;
	}
	
	// 게시물 수정
	@ResponseBody
	@RequestMapping(value = "/sample/updateSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> updateSample(@RequestParam HashMap<String, Object> requestParam) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			Map<String, Object> member = (HashMap<String, Object>)session.getAttribute("member");
			int sessionNo = Integer.parseInt(member.get("NO").toString());
			int requestNo = Integer.parseInt(requestParam.get("MEMBERNO").toString());
			System.out.println(sessionNo);
			System.out.println(requestNo);
			if (sessionNo != requestNo) throw new Exception("멤버 정보가 다름");
			sampleService.updateSample(requestParam);
			
			resultMap.put("result", "SUCCESS");
		}catch(Exception e){
			resultMap.put("result", "FAIL");
			resultMap.put("errorMsg", e.getMessage());
		}
		
		return resultMap;
	}
	
	// 게시물 삭제
	@ResponseBody
	@RequestMapping(value = "/sample/deleteSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> deleteSample(@RequestParam HashMap<String, Object> requestParam) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			if (session.getAttribute("member") == null) throw new Exception("비로그인 상태");
			
			String sampleList = (String) requestParam.get("sampleList");
			
			ObjectMapper objectMapper = new ObjectMapper();
			
			HashMap<String, Object> deleteMap = new HashMap<String, Object>();
			deleteMap.put("sampleList", objectMapper.readValue(sampleList, List.class));
			
			sampleService.deleteSample(deleteMap);
			
			resultMap.put("result", "SUCCESS");
		}catch(Exception e){
			resultMap.put("result", "FAIL");
			resultMap.put("errorMsg", e.getMessage());
		}
		
		return resultMap;
	}
}