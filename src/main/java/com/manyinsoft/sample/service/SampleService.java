package com.manyinsoft.sample.service;

import java.util.HashMap;
import java.util.List;

public interface SampleService {

	public List<HashMap<String, Object>> searchSample(HashMap<String, Object> searchMap, String contextPath);
	
	public void insertSample(HashMap<String, Object> insertMap) throws Exception;
	
	public List<HashMap<String, Object>> selectSample(HashMap<String, Object> selectMap, String contextPath);
	
	public void updateSample(HashMap<String, Object> updateMap) throws Exception;
	
	public void deleteSample(HashMap<String, Object> deleteMap) throws Exception;
	
	public int sampleMemberNo (int no);
	
	public List<HashMap<String, Object>> mySamples (HashMap<String, Object> param, String contextPath);

	public List<HashMap<String, Object>> replyList (int no);
	
	public void addReply (HashMap<String, Object> param) throws NullPointerException;
	
	public void updateReply (HashMap<String, Object> param) throws NullPointerException;
	
	public void deleteReply (int no) throws NullPointerException;
}