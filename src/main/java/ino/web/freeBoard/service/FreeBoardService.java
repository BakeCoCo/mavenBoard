package ino.web.freeBoard.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FreeBoardService {

	List<HashMap<String, Object>> listTest(Map<String, Object> map);

	int freeBoardTotalCount(Map<String, Object> map);

	Map<String, Object> getDetailByNum(Map<String, Object> map);

	int freeBoardInsertPro(Map<String, Object> map);

	int freeBoardModify(Map<String, Object> map);

	int freeBoardDelete(Map<String, Object> map);

	String stat(int result);

}
