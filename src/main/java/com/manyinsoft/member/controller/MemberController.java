package com.manyinsoft.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.manyinsoft.member.service.MemberService;

@Controller
public class MemberController {
	MemberService memberService;
	
	@Autowired
	public void setMemberService (MemberService memberService) {
		this.memberService = memberService;
	}
	
	@Autowired
	private HttpSession session;
	
	// 회원가입폼
	@RequestMapping(value="/member/createView", method=RequestMethod.GET)
	public String memberCreateView () {
		if (session.getAttribute("member") != null) return "/sample/sampleListView";
		return "/member/memberCreateView";
	}
	
	// 회원가입
	@ResponseBody
	@RequestMapping(value="/member/createMember.do", method=RequestMethod.POST)
	public HashMap<String, Object> createMember (@RequestParam HashMap<String, Object> requestParam) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		int gender = Integer.parseInt((String)requestParam.get("gender"));
		int dept = Integer.parseInt((String)requestParam.get("dept"));
		int classes = Integer.parseInt((String)requestParam.get("classes"));
		
		requestParam.put("gender", gender);
		requestParam.put("dept", dept);
		requestParam.put("classes", classes);
		
		try {
			memberService.insertMember(requestParam);
			resultMap.put("result", "SUCCESS");
		} catch (Exception e) {
			resultMap.put("result", "FAIL");
			resultMap.put("errMsg", e.getMessage());
		}
		
		return resultMap;
	}
	
	// 회원정보 수정폼
	@RequestMapping(value="/member/updateView", method=RequestMethod.GET)
	public String memberUpdateView() {
		if (session.getAttribute("member") == null) return "/member/memberLoginView";
		return "/member/memberUpdateView";
	}
	
	// 회원정보 수정
	@ResponseBody
	@RequestMapping(value="/member/update.do", method=RequestMethod.POST)
	public Map<String, Object> memberUpdate(@RequestParam HashMap<String, Object> requestParam) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			memberService.updateMember(requestParam);
			resultMap.put("result", "SUCCESS");
		} catch (Exception e) {
			resultMap.put("result", "FAIL");
		}
		return resultMap;
	}
	
	// 로그인폼
	@RequestMapping(value="/member/loginView", method=RequestMethod.GET)
	public String memberLoginView() {
		if (session.getAttribute("member") != null) return "/sample/sampleListView";
		return "/member/memberLoginView";
	}
	
	// 로그인
	@ResponseBody
	@RequestMapping(value="/member/loginMember.do", method=RequestMethod.POST)
	public HashMap<String, Object> loginMember (@RequestParam HashMap<String, Object> requestParam) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		int result = memberService.loginMember(requestParam);
		
		if (result > 0) {
			// 로그인 성공
			session.setAttribute("member", memberService.loginMember(requestParam));
			resultMap.put("result", "SUCCESS");
		} else if (result == -1) {
			// 아이디가 다를경우
			resultMap.put("result", "IDFAIL");
		} else if (result == 0) {
			// 비밀번호가 다를경우
			resultMap.put("result", "PWDFAIL");
		}
		
		return resultMap;
	}
	
	// 멤버정보 가져오기
	@ResponseBody
	@RequestMapping(value="/member/memberOne", method=RequestMethod.GET)
	public Map<String, Object> memberOne (@RequestParam int no) {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		
		try {
			resultMap = memberService.memberOne(no);
			resultMap.put("result", "SUCCESS");
		} catch (Exception e) {
			resultMap.put("errMsg", e.getMessage());
		}
		
		return resultMap;
	}
	
	// 로그아웃
	@ResponseBody
	@RequestMapping(value="/member/logoutMember", method=RequestMethod.GET)
	public HashMap<String, Object> logoutMember () {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
	
		if (session.getAttribute("member") != null) {
			session.removeAttribute("member");
			resultMap.put("result", "SUCCESS");
		} else {
			System.out.println("FAIL");
			resultMap.put("result", "FAIL");
		}
		
		return resultMap;
	}
	
	// 멤버 이름으로 조회
	@ResponseBody
	@RequestMapping(value="/member/searchMember", method=RequestMethod.GET)
	public HashMap<String, Object> searchMember (@RequestParam HashMap<String, Object> requestParam) {
		List<HashMap<String, Object>> memberList = memberService.searchMember(requestParam);
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		resultMap.put("memberList", memberList);
		return resultMap;
	}
}
