package ino.web.freeBoard.controller;

import ino.web.freeBoard.common.util.PageMove;
import ino.web.freeBoard.service.FreeBoardService;
import ino.web.commonCode.service.CommCodeService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class freeBoardControllerimpl implements freeBoardController{
	
	private final Logger logger = Logger.getLogger(freeBoardControllerimpl.class);
	
	@Autowired
	private CommCodeService commonService;
	
	@Autowired
	private FreeBoardService FService;
	
	@RequestMapping("/main.ino")
	public ModelAndView Tmain(@RequestParam Map<String, Object> map 
											, @RequestParam(defaultValue= "") String rega
											, @RequestParam(defaultValue= "") String regb
											, @RequestParam(defaultValue= "") String selected
											, @RequestParam(defaultValue= "") String find){
		ModelAndView mav = new ModelAndView();
		PageMove page = new PageMove();
		List<HashMap<String, Object>> list = null;
		map.put("selected", selected);
		map.put("find", find);
		map.put("rega", rega.replace("-", ""));
		map.put("regb", regb.replace("-", ""));
		map.put("CODE", "COM001");
		map.put("USEYN", "Y");
		
		list = FService.listTest(map);
		
		mav.setViewName("boardMain");
		mav.addObject("FList",list);
		mav.addObject("com",commonService.common(map));
		mav.addObject("select",selected);
		mav.addObject("find",find);
		mav.addObject("web",page);
		mav.addObject("rega",rega);
		mav.addObject("regb",regb);
		mav.addObject("stat","");
		
		
		try {
			logger.info(list);
		} catch (Exception e) {
			// TODO: handle exception
			logger.error("got error",e);
		}
		
		return mav;
	}
	
	@RequestMapping("/freeBoardInsert.ino")
	public ModelAndView FInsert(@RequestParam Map<String, Object> map){
		ModelAndView mav = new ModelAndView();
		mav.setViewName("freeBoardInsert");
		return mav;
	}
	
	@RequestMapping("/FDetail.ino")
	public ModelAndView FDetail(HttpServletRequest req,@RequestParam Map<String, Object> map){
		ModelAndView mav = new ModelAndView();
		Object find = "";
		if(req.getParameter("find").equals("")) {
			map.put("find", find);
		}
		map.put("selected", map.get("selected"));
		mav.addObject("look", FService.getDetailByNum(map));
		mav.addObject("web",map);
		mav.setViewName("freeBoardDetail");
		return mav;
	}
	
	@ResponseBody
	@RequestMapping("/IMD.ino")
	public Map<String, Object> IMD(HttpServletRequest req,@RequestParam Map<String, Object> map
			, @RequestParam(defaultValue= "") String rega
			, @RequestParam(defaultValue= "") String regb
			, @RequestParam(defaultValue= "") String selected
			, @RequestParam(defaultValue= "") String find){
		PageMove page = new PageMove();
//		System.out.println(":::::: IMD ::::::: ");
		map.put("find", find);
		map.put("selected", selected);
		map.put("rega", rega);
		map.put("regb", regb);
		
		Object doit = map.get("do");
		String status="";
		int result = 0;
		try {
		if(doit.equals("insert")) {
			result =FService.freeBoardInsertPro(map);
		}else if(doit.equals("modify")) {
			result = FService.freeBoardModify(map);
		}else if(doit.equals("delete")) {
			result = FService.freeBoardDelete(map);
		}else if(doit.equals("cancel")) {
			result = 100;
		}
		} catch (Exception e) {status="fail"; 	}
		
		status = FService.stat(result);
		
		map.put("stat", status);
		map.put("web", page);
		
		return map;
	}
	
	
	@ResponseBody
	@RequestMapping("/Search.ino")
	public Map<String, Object> test(@RequestParam Map<String, Object> map 
												, @RequestParam(defaultValue= "") String rega
												, @RequestParam(defaultValue= "") String regb
												, @RequestParam(defaultValue= "") String selected
												, @RequestParam(defaultValue= "") String find) {
		PageMove page = new PageMove();
		List<HashMap<String, Object>> list = null;
		map.put("selected", selected);
		map.put("find", find);
		map.put("rega", rega.replace("-", ""));
		map.put("regb", regb.replace("-", ""));
		map.put("CODE", "COM001");
		map.put("USEYN", "Y");
		
		list = FService.listTest(map);
		map.put("FList", list);
		
		list = commonService.common(map);
		map.put("com", list);
		
		map.put("web", page);
		
		return map;
	}
}