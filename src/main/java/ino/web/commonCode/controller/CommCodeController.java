package ino.web.commonCode.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


import ino.web.commonCode.service.CommCodeService;

@Controller
public class CommCodeController {
	
	@Autowired
	private DataSourceTransactionManager txManager;
	
	@Autowired
	private CommCodeService commCodeService;
	
	@RequestMapping("/commonCode.ino")
	public ModelAndView commonCode(HttpServletRequest req){
		
		ModelAndView mav = new ModelAndView();
		
		List<HashMap<String,Object>> list = commCodeService.selectCommonCodeList();
		
		mav.addObject("list" , list);
		mav.setViewName("commonCodeMain");
		
		return mav;
	}
	
	@RequestMapping("/commonCodeDetail.ino")
	public ModelAndView commonCodeDetail(@RequestParam Map<String, Object> map) {
		ModelAndView mav = new ModelAndView();
		System.out.println("comDetail :=: "+map);
		List<HashMap<String,Object>> list = commCodeService.DetailCodeList(map);
		
		mav.addObject("list" , list);
		mav.addObject("SS",list.get(0).get("CODE"));
		
		mav.setViewName("detailCode");
		return mav;
	}
	
	@RequestMapping("/commonCodeMapping.ino")
	public ModelAndView commonCodeMapping() {
		ModelAndView mav = new ModelAndView();
		List <HashMap<String, Object>> glist = commCodeService.GList();
		mav.addObject("gList",glist);
		mav.setViewName("mappingCode");
		return mav;
	}
	
	@ResponseBody
	@RequestMapping("/maping.ino")
	public Map<String, Object> maping(@RequestParam Map<String, Object> map,HttpServletRequest req){
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		List<HashMap<String, Object>> mapList  = new ArrayList<HashMap<String, Object>>();
		try {
			list = commCodeService.obList(map);
			mapList = commCodeService.mapList(map);
		} catch (Exception e) {
			e.printStackTrace();
		}
		map.put("OBList", list);
		map.put("MapList", mapList);
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/grantUP.ino")
	public Map<String, Object> grantUpdate(HttpServletRequest req){
		Map<String, Object> map = null;
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		List<HashMap<String, Object>> mapList  = new ArrayList<HashMap<String, Object>>();
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setName("example-transaction");
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		
		TransactionStatus status = txManager.getTransaction(def);
		int result =0;
		try {
			String GID[] = req.getParameterValues("GID");
			String OBID[] = req.getParameterValues("OBID");
			String OBNAME[] = req.getParameterValues("OBNAME");
			String DEPTH[] = req.getParameterValues("DEPTH");
			String HIGH[] = req.getParameterValues("HIGH");
			String USCHK[] = req.getParameterValues("USCHK");
			
			for(int i=0; i<GID.length; i++) {
				map=new HashMap<String, Object>();
				map.put("GID", GID[i]);
				map.put("OBID", OBID[i]);
				map.put("OBNAME", OBNAME[i]);
				map.put("DEPTH", DEPTH[i]);
				map.put("HIGH", HIGH[i]);
				map.put("USCHK", USCHK[i]);
				map.put("GSEL", GID[i]);
				System.out.println(map);
				if(USCHK[i].equals("A")) {
					insertList.add(map);
				}else if(USCHK[i].equals("D")) {
					deleteList.add(map);
				}else {
				}
			}
			
			if(deleteList.size()!=0) {
				result = commCodeService.deleteMap(deleteList);
			}
			
			if(insertList.size()!=0) {
				result = commCodeService.insertMap(insertList);
			}
			
			if(result!=0) {
				System.out.println(result);
				map.put("stat", "success");
			}
			
			list = commCodeService.obList(map);
			mapList = commCodeService.mapList(map);
			
			map.put("OBList", list);
			map.put("MapList", mapList);
			
		} catch (Exception e) {
			e.printStackTrace();
			map.put("stat", "fail");
			System.out.println("롤백 간드아~~");
			txManager.rollback(status);
		}
		txManager.commit(status);
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/CodeReq.ino")
	public Map<String, Object> chkCode(HttpServletRequest req) {
		Map<String, Object> map=null;
		List<Map<String, Object>> insertList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> deleteList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> updateList = new ArrayList<Map<String, Object>>();
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setName("example-transaction");
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		
		TransactionStatus status = txManager.getTransaction(def);
		int chk=0;
		try {
			
			System.out.println("RequestParameter");
			String CODE[] = req.getParameterValues("CODE");
			String DECODE[] = req.getParameterValues("DECODE"); 
			String DECODENAME[] = req.getParameterValues("DECODENAME");
			String USEYN[] = req.getParameterValues("USEYN");
			String FLAG[] = req.getParameterValues("FLAG");
			String UPCODE[] = req.getParameterValues("UPCODE");
			
			for(int i=0; i<CODE.length; i++) {
				map = new HashMap<String, Object>();
				map.put("CODE",CODE[i]);
				map.put("DECODE",DECODE[i]);
				map.put("DECODENAME",DECODENAME[i]);
				map.put("USEYN",USEYN[i]);
				map.put("UPCODE",UPCODE[i]);
				map.put("FLAG", FLAG[i]);
				if(FLAG[i].equals("U")) {
					updateList.add(map);
				}else if(FLAG[i].equals("A")){
					insertList.add(map);
				}else if(FLAG[i].equals("D")) {
					deleteList.add(map);
				}else if(FLAG[i].equals("N")) {
					System.out.println("뭘봐");
				}
				System.out.println(map);
			}
			
			if(deleteList.size()!=0) {
				chk = commCodeService.deleteCode(deleteList);
			}
			
			if(updateList.size()!=0) {
				chk = commCodeService.updateCode(updateList);
			}
			
			if(insertList.size()!=0) {
				chk = commCodeService.insertCode(insertList);
			}
			
			if(chk!=0) {
				System.out.println(chk);
				map.put("stat", "success");
			}
			
			txManager.commit(status);
		} catch (Exception e) {
			map.put("stat", "fail");
			System.out.println("롤백 간드아~~");
			txManager.rollback(status);
		}
		return map;
	}
}
