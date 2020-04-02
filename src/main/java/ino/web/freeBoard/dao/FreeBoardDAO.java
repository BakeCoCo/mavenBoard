package ino.web.freeBoard.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("BoardDao")
public class FreeBoardDAO {
	
	@Autowired
	private SqlSessionTemplate sqlSession;
	
	public List<HashMap<String, Object>> listTest(Map<String, Object> map){
		return sqlSession.selectList("listTest",map);
	}
	
	public Map<String, Object> getDetailByNum(Map<String, Object> map){
		return sqlSession.selectOne("freeBoardDetailByNum", map);
	}
	
	public int freeBoardInsertPro(Map<String, Object> map) {
		int result = sqlSession.insert("freeBoardInsertPro",map);
		return result;
	}
	
	public int freeBoardModify(Map<String, Object> map){
		int result =sqlSession.update("freeBoardModify",map);
		return result;
	}
	
	public int freeBoardDelete (Map<String, Object> map) {
		int result =sqlSession.delete("freeBoardDelete", map);
		return result;
	}
	
	public int freeBoardTotalCount(Map<String, Object> map) {
		return sqlSession.selectOne("freeBoardTotalCount",map);
	}
	
	public int getNewNum(){
		return sqlSession.selectOne("freeBoardNewNum");
	}
}
