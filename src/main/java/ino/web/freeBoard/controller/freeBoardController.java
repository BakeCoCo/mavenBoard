package ino.web.freeBoard.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

public interface freeBoardController {
	public ModelAndView Tmain(@RequestParam Map<String, Object> map 
											, @RequestParam(defaultValue= "") String rega
											, @RequestParam(defaultValue= "") String regb
											, @RequestParam(defaultValue= "") String selected
											, @RequestParam(defaultValue= "") String find) throws Exception;
	
	public Map<String, Object> test(@RequestParam Map<String, Object> map 
			, @RequestParam(defaultValue= "") String rega
			, @RequestParam(defaultValue= "") String regb
			, @RequestParam(defaultValue= "") String selected
			, @RequestParam(defaultValue= "") String find) throws Exception;
	
	public ModelAndView FInsert(@RequestParam Map<String, Object> map) throws Exception;
	public ModelAndView FDetail(HttpServletRequest req,@RequestParam Map<String, Object> map) throws Exception;
	public Map<String, Object> IMD(HttpServletRequest req,@RequestParam Map<String, Object> map
			, @RequestParam(defaultValue= "") String rega
			, @RequestParam(defaultValue= "") String regb
			, @RequestParam(defaultValue= "") String selected
			, @RequestParam(defaultValue= "") String find) throws Exception;
	
	
}
