package ino.web.commonCode.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommCodeService {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	
	public List<HashMap<String, Object>> selectCommonCodeList() {
		return sqlSessionTemplate.selectList("selectCommonCodeList");
	}
	
	public List<HashMap<String, Object>> common(Map<String, Object> map){
		return sqlSessionTemplate.selectList("common",map);
	}

	public List<HashMap<String, Object>> DetailCodeList(Map<String, Object> map) {
		return sqlSessionTemplate.selectList("DetailCodeList",map);
	}

	public int insertCode(List<Map<String, Object>> insertList){
		//System.out.println("insert :: "+insertList);
		int result=0;
		try {
			result = sqlSessionTemplate.insert("insertCode",insertList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public int deleteCode(List<Map<String, Object>> deleteList) {
		//System.out.println("delete :: "+deleteList);
		int result=0;
		try {
			result = sqlSessionTemplate.delete("deleteCode",deleteList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public int updateCode(List<Map<String, Object>> updateList) {
		//System.out.println("update :: "+updateList);
		int result=0;
		try {
			result = sqlSessionTemplate.update("updateCode",updateList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public String resultSET(int result) {
		String status = "";
		if(result==1) {
			status="success";
		}else {
			status="fail";
		}
		return status;
	}

	public List<HashMap<String, Object>> GList() {
		List<HashMap<String, Object>> list =null;
		try {
			 list = sqlSessionTemplate.selectList("GList");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; 
	}


/*	public int selGL(List<Map<String, Object>> selGList) {
		int result =0;
		try {
			result = sqlSessionTemplate.update("selGL",selGList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}*/

	public List<HashMap<String, Object>> obList(Map<String, Object> map) {
		return sqlSessionTemplate.selectList("obList",map);
	}
	public List<HashMap<String, Object>> mapList(Map<String, Object> map) {
		return sqlSessionTemplate.selectList("mapList",map);
	}

	public int deleteMap(List<Map<String, Object>> deleteList) {
		//System.out.println("delete :: "+deleteList);
		int result=0;
		try {
			result = sqlSessionTemplate.delete("deleteMap",deleteList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	public int insertMap(List<Map<String, Object>> insertList) {
		//System.out.println("insert :: "+insertList);
		int result=0;
		try {
			result = sqlSessionTemplate.insert("insertMap",insertList);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}
