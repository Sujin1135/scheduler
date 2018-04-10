package com.manyinsoft.sample.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manyinsoft.sample.service.SampleServiceImpl;

@Controller
public class SampleController {
	// 로그 출력할 때 사용한다.
	Logger logger = LoggerFactory.getLogger(SampleController.class);
	
	@Autowired
	private SampleServiceImpl sampleService;
	
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
	public HashMap<String, Object> searchSample(HttpServletRequest request, @RequestParam HashMap<String, Object> requestParam) throws Exception {
		
		// key값이 likeTitle로 넘어온 값을 받아서 likeTitle에 저장한다.
		String likeTitle = (String) requestParam.get("likeTitle");
		String contextPath = request.getContextPath();
		
		HashMap<String, Object> searchMap = new HashMap<String, Object>();
		
		// likeTitle이 값이 있을때
		if(likeTitle != null && !"".equals(likeTitle)){
			searchMap.put("LIKE_TITLE", "%" + likeTitle.toUpperCase() + "%");
		}
		
		searchMap.put("TYPE_SELECT", requestParam.get("typeSelect"));
		searchMap.put("CALENDAR_SELECT", requestParam.get("calendarSelect"));
		searchMap.put("start", requestParam.get("start"));
		searchMap.put("end", requestParam.get("end"));
		
		// 결과정보를 저장할 HashMap
		HashMap<String, Object> responseBody = new HashMap<String, Object>();

		// 조회 목록을 저장할 List
		List<HashMap<String, Object>> sampleList = sampleService.searchSample(searchMap, contextPath);
		
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
	public HashMap<String, Object> insertSample(@RequestBody HashMap<String, Object> requestParam){
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
	
	// 내 일정
	@RequestMapping(value = "/sample/mySamplesView", method = RequestMethod.GET)
	public String mySamplesView (@RequestParam("seq") int seq) {
		int memberNo = Integer.parseInt(session.getAttribute("member").toString());
		if (memberNo != seq) return "/sample/sampleListView";
		return "/sample/mySamplesView";
	}
	
	// 내 일정 받아오기
	@ResponseBody
	@RequestMapping(value = "/sample/mySamples.do", method = RequestMethod.POST)
	public List<HashMap<String, Object>> mySamples (HttpServletRequest request, @RequestParam HashMap<String, Object> requestParam) {
		String contextPath = request.getContextPath();
		List<HashMap<String, Object>> sampleList = sampleService.mySamples(requestParam, contextPath);
		return sampleList;
	}
	
	// 달력으로 보기
	@RequestMapping(value = "/sample/sampleCalendarView", method=RequestMethod.GET)
	public String sampleCalendar() {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "/sample/sampleCalendarView";
	}
	
	// 게시물 상세보기
	@RequestMapping(value="/sample/sampleOneView", method=RequestMethod.GET)
	public String sampleOneView() {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "/sample/sampleOneView";
	}
	
	// 게시물 수정화면
	@RequestMapping(value = "/sample/sampleUpdateView", method = RequestMethod.GET)
	public String scrinDetailView(HttpServletRequest request, @RequestParam("seq") int seq) {
		// 비로그인자가 접근할경우 방지
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		int sampleMemberNo = sampleService.sampleMemberNo(seq);
		int memberNo = Integer.parseInt(session.getAttribute("member").toString());
		
		// 해당 글작성자 이외의 다른 멤버가 수정권한에 접근할 경우를 방지
		if (memberNo != sampleMemberNo) return "sample/sampleListView";
		return "sample/sampleUpdateView";
	}
	
	// 게시물 수정
	@ResponseBody
	@RequestMapping(value = "/sample/selectSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> scrinUpdateView(HttpServletRequest request, @RequestParam HashMap<String, Object> requestParam) {
		HashMap<String, Object> responseBody = new HashMap<String, Object>();
		String contextPath = request.getContextPath();
		
		responseBody.put("sampleList", sampleService.selectSample(requestParam, contextPath));
		return responseBody;
	}
	
	// 게시물 상세보기
	@ResponseBody
	@RequestMapping(value = "/sample/oneSample.do", method=RequestMethod.POST)
	public HashMap<String, Object> scrinDetailView(HttpServletRequest request, @RequestParam HashMap<String, Object> requestParam) {
		HashMap<String, Object> responseBody = new HashMap<String, Object>();
		String contextPath = request.getContextPath();
		
		// 쿼리 실행결과를 받아온다
		responseBody.put("sampleList", sampleService.selectSample(requestParam, contextPath));
		
		return responseBody;
	}
	
	// 게시물 수정
	@ResponseBody
	@RequestMapping(value = "/sample/updateSample.do", method = RequestMethod.POST)
	public HashMap<String, Object> updateSample(@RequestBody HashMap<String, Object> requestParam) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try{
			int sessionNo = Integer.parseInt(session.getAttribute("member").toString());
			int requestNo = Integer.parseInt(requestParam.get("MEMBERNO").toString());
			
			// 글 작성자의 pk와 현재 로그인한 멤버의 pk 정보가 다를경우
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
			
			int memberNo = Integer.parseInt(requestParam.get("memberNo").toString());
			int sessionMemberNo = Integer.parseInt(session.getAttribute("member").toString());
			if (memberNo != sessionMemberNo) throw new Exception("사용자 정보가 다름");
			sampleService.deleteSample(requestParam);
			
			resultMap.put("result", "SUCCESS");
		}catch(Exception e){
			resultMap.put("result", "FAIL");
			resultMap.put("errorMsg", e.getMessage());
		}
		
		return resultMap;
	}
	
	// 해당 일정에 참여하는 멤버조회
	@ResponseBody
	@RequestMapping(value = "/sample/partyMember.do", method = RequestMethod.POST)
	public List<HashMap<String, Object>> selectPartyMember (@RequestParam("no") int no) {
		return sampleService.selectPartyMember(no);
	}
	
	// 댓글 목록
	@ResponseBody
	@RequestMapping(value = "/sample/replyList.do", method = RequestMethod.POST)
	public List<HashMap<String, Object>> replyList (@RequestParam("seq") int seq) {
		return sampleService.replyList(seq);
	}
	
	// 댓글 등록
	@ResponseBody
	@RequestMapping(value = "/sample/addReply.do", method = RequestMethod.POST)
	public HashMap<String, Object> addReply (@RequestParam HashMap<String, Object> requestParam) {
		// 결과정보를 반환할 맵
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			sampleService.addReply(requestParam);
			resultMap.put("result", "SUCCESS");
		} catch (NullPointerException e) {
			resultMap.put("result", "FAIL");
			resultMap.put("errMsg", e.getMessage());
		}
		return resultMap;
	}
	
	// 댓글 수정
	@ResponseBody
	@RequestMapping(value = "/sample/updateReply.do", method = RequestMethod.POST)
	public HashMap<String, Object> updateReply (@RequestParam HashMap<String, Object> requestParam) {
		// 결과정보를 반환할 맵
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int sessionMember = Integer.parseInt(session.getAttribute("member").toString());
			int memberNo = Integer.parseInt(requestParam.get("memberNo").toString());
			
			if (sessionMember != memberNo) {
				throw new NullPointerException("잘못된 접근입니다.");
			}
			
			sampleService.updateReply(requestParam);
			resultMap.put("result", "SUCCESS");
		} catch (NullPointerException e) {
			e.printStackTrace();
			resultMap.put("result", e.getMessage());
		}
		
		return resultMap;
	}
	
	// 댓글 삭제
	@ResponseBody
	@RequestMapping(value = "/sample/deleteReply.do", method = RequestMethod.POST)
	public HashMap<String, Object> deleteReply (@RequestParam HashMap<String, Object> requestParam) {
		// 결과정보를 반환할 맵
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			int sessionMember = Integer.parseInt(session.getAttribute("member").toString());
			int memberNo = Integer.parseInt(requestParam.get("memberNo").toString());
			
			if (sessionMember != memberNo) throw new NullPointerException("잘못된 접근입니다.");
			
			int seq = Integer.parseInt(requestParam.get("seq").toString());
			sampleService.deleteReply(seq);
			resultMap.put("result", "SUCCESS");
		} catch (NullPointerException e) {
			resultMap.put("result", "FAIL");
			resultMap.put("errMsg", e.getMessage());
		}
		
		return resultMap;
	}
}