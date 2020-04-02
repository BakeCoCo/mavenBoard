package ino.web.freeBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ino.web.freeBoard.common.util.PageMove;
import ino.web.freeBoard.dao.FreeBoardDAO;

@Service
public class FreeBoardServiceImpl implements FreeBoardService{
	
	@Autowired
	FreeBoardDAO FDAO;
	
	@Override
	public List<HashMap<String, Object>> listTest(Map<String, Object> map) {
		PageMove page = new PageMove();
		
		// 총 갯수 세기
		int total = FDAO.freeBoardTotalCount(map);
		
		//	화면에 출력할 글의 개수를 정한다. 기본 10개
		int pageSize = 10;
		try { pageSize =Integer.parseInt((String) map.get("pageSize"));}catch(Exception e) {}
		
		//	현재 페이지를 받는다. 기본 1페이지
		int currentPage = 1;
		try {	currentPage = Integer.parseInt((String) map.get("currentPage"));} catch(Exception e) { }
		
		page.FBoardPage(total, pageSize, currentPage);
		
		map.put("startNo", page.getStartNo());
		map.put("endNo", page.getEndNo());
		
		return FDAO.listTest(map);
	}

	@Override
	public int freeBoardTotalCount(Map<String, Object> map) {
		return FDAO.freeBoardTotalCount(map);
	}

	@Override
	public Map<String, Object> getDetailByNum(Map<String, Object> map) {
		return FDAO.getDetailByNum(map);
	}

	@Override
	public int freeBoardInsertPro(Map<String, Object> map) {
		return FDAO.freeBoardInsertPro(map);
	}

	@Override
	public int freeBoardModify(Map<String, Object> map) {
		return FDAO.freeBoardModify(map);
	}

	@Override
	public int freeBoardDelete(Map<String, Object> map) {
		return FDAO.freeBoardDelete(map);
	}

	@Override
	public String stat(int result) {
		String SF="";
		if(result==1) {
			SF="success";
		}else if(result==0) {
			SF="fail";
		}else if(result==100) {
			SF="cancel";
		}
		return SF;
	}
	
}
