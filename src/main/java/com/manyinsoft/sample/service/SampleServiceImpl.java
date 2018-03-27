package com.manyinsoft.sample.service;

import java.util.HashMap;
import java.util.List;

public interface SampleServiceImpl {

	public List<HashMap<String, Object>> searchSample(HashMap<String, Object> searchMap);
	
	public void insertSample(HashMap<String, Object> insertMap) throws Exception;
	
	public HashMap<String, Object> selectSample(HashMap<String, Object> selectMap);
	
	public void updateSample(HashMap<String, Object> updateMap) throws Exception;
	
	public void deleteSample(HashMap<String, Object> deleteMap) throws Exception;
}