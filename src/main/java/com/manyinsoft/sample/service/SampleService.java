package com.manyinsoft.sample.service;

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

	public List<HashMap<String, Object>> searchSample(HashMap<String, Object> searchMap){
		return sampleDao.searchSample(searchMap);
	}
	
	public void insertSample(HashMap<String, Object> insertMap) throws Exception {
		if(sampleDao.insertSample(insertMap) == 0){
			throw new Exception("저장되지 않았습니다.");
		}
	}
	
	public HashMap<String, Object> selectSample(HashMap<String, Object> selectMap){
		return sampleDao.selectSample(selectMap);
	}
	
	public void updateSample(HashMap<String, Object> updateMap) throws Exception {
		if(sampleDao.updateSample(updateMap) == 0){
			throw new Exception("저장되지 않았습니다.");
		}
	}
	
	public void deleteSample(HashMap<String, Object> deleteMap) throws Exception {
		List<HashMap<String, Object>> sampleList = (List<HashMap<String, Object>>) deleteMap.get("sampleList");

		for(HashMap<String, Object> sample : sampleList){
			if(sampleDao.deleteSample(sample) == 0){
				throw new Exception("삭제되지 않았습니다.");
			}
		}
	}
}