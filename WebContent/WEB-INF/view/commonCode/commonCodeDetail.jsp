<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
form{width:100%; height:40px;}
hr{width:100%;border : 1px;height : 2px;background : #ccc; margin: 4px;}
table{width:100%;}
div{text-align: center;float: left; height:30px;}
input[type=text]{text-align: center;font-size: 16px;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

<!-- script 영역 -->
<script type="text/javascript">
$(function(){
	$(".add").click(function(){
		insertCode("${SS}");
	});
	$(".Req").click(function(){
		insertChk("save");
	});
	$(".chkup").click(function(){
		chkbox("chkup");
	});
	$(".chkdel").click(function(){
		chkbox("chkdel");
	});
});

function insertCode(code){
	var input = "<form class=\"chklist\">"; //inCode
	input += "<input type=\"hidden\" name=\"FLAG\" value=\"A\" />";
	input += "<input type=\"text\" name=\"CODE\" value="+code+" readonly style=\"margin-left:80px; width:160px;\" />";
	input += "<input type=\"text\" name=\"DECODE\" style=\"margin-left:20px; width:180px\" />";
	input += "<input type=\"hidden\" name=\"UPCODE\" value=\"empty\" />";
	input += "<input type=\"text\" name=\"DECODENAME\" style=\"margin-left:20px; width:180px\" />";
	input += "<input type=\"radio\" name=\"USEYN\" style=\"margin-left:70px; width:10px\" checked=\"checked\" value=\"Y\"/>Y";
	input += "<input type=\"radio\" name=\"USEYN\" style=\"margin-left:20px; width:10px\" value=\"N\"/>N";
	input += "</form>";
	input += "<br/>";
	$(".codeList").append(input);
};


function insertChk(attr){
	chkbox(attr);
	var url ="./CodeReq.ino";
	var CRUD = txtchk();
	console.log("CRUD",CRUD);
	if(!CRUD){
		return;
	}else{
		aj(CRUD,url);
	}
};

function aj(data, url){
	console.log(data);
	$.ajax({
		url : url,
		data : data,
		type : "POST",
	})
	.done(function(result){
		console.log(result);
		if(result.stat=="success"){
			location.href="./commonCodeDetail.ino?CODE=${SS}";
		}
	})
	.fail(function(result){
		alert("실패");
	})
};


function txtchk(){
	var txt =$(".chklist").serializeArray();
	if(txt.length==0){
		alert("뭐라도 하세요");
		return false;
	}
	$.each(txt,function(k,v){
		var bc = v.value;
		var i = Math.ceil(k/6);
		if(bc.trim()==""){
			alert("빈칸이 없게 해주세요.");
			txt=false;
			return false;
		}
	});
	return txt;
};

function chkbox(attr){
	var dcode = new Array();
	var codeName = new Array();
	var usyn = new Array();
	
	<c:forEach var="co" items="${list}" varStatus="status">
	var i = "${status.index}";
	dcode[i] = "${co.DECODE}";
	codeName[i] = "${co.DECODE_NAME}";
	usyn[i] = "${co.USE_YN}";
	</c:forEach>
	
	chkBox(dcode, codeName, usyn, attr);
};

function chkBox(dcode, codeName, usyn, attr){
	$("input:checkbox[name=FLAG]").each(function(k,v){
		if(attr!="save"){
	  		if(this.checked){
	  			
	  			if(attr=="chkdel"){
	  				if(this.value=="D"){
	  					this.value="N";
	  				}else{
						this.value="D";
	  				}
	  				
	  			}else if(attr=="chkup"){
	  				if(this.value=="U"){
	  					this.value="N";
	  				}else{
	  					this.value="U";
	  				}
	  			}
	  			
	  			this.checked=false;
	  			updateCode(dcode[k], codeName[k], usyn[k], this.value, k );
			}
		}else{
  			this.checked=false;
		}
	});
}

function updateCode(dcode, codeName, usyn , flag, k){
	var hide = "";
	if(flag=="D"){
	hide += "<hr style=\"width:90%; background: red; position:absolute; top:"+(140+k*40)+"px; left:50px; \"/>";
	}
	
	hide += "<input type=\"checkbox\" name=\"FLAG\" style=\"width:50px; float:left;\" value="+flag+" />"
	hide += "<div style=\"width:200px;\"> ${SS} </div>";
	hide += "<input type=\"hidden\" name=\"FLAG\" value="+flag+" />";
	hide += "<input type=\"hidden\" name=\"CODE\" value=${SS} />";
	hide += "<input type=\"hidden\" name=\"DECODE\" value="+dcode+" />";
	
	if(flag=="U"){
	hide += "<input type=\"text\" name=\"UPCODE\" style=\"width:195px; float: left; \" value="+dcode+" />";
	hide += "<input type=\"text\" name=\"DECODENAME\" style=\"width:195px; float: left;\" value="+codeName+" /> ";
	}else{
	hide += "<input type=\"hidden\" name=\"UPCODE\" value="+dcode+" />";
	hide += "<input type=\"hidden\" name=\"DECODENAME\" value="+codeName+" />";
	hide += "<div style=\"width:200px;\">"+dcode+"</div>"
	hide += "<div style=\"width:200px;\">"+codeName+"</div>"
	}
	hide += "<div style=\"width:200px;\">"+usyn+"</div>"
	hide += "<input type=\"hidden\" name=\"USEYN\" value="+usyn+" />";
	hide += "<hr/>";
	
	if(flag=="N"){
		hide = "<input type=\"checkbox\" name=\"FLAG\" style=\"width:50px; float:left;\" value="+flag+" />"
		hide += "<div style=\"width:200px;\"> ${SS} </div>";
		hide += "<div style=\"width:200px;\">"+dcode+"</div>"
		hide += "<div style=\"width:200px;\">"+codeName+"</div>"
		hide += "<div style=\"width:200px;\">"+usyn+"</div>"
		hide += "<hr/>";
	}
	
	$("."+dcode).empty();
	$("."+dcode).append(hide);
};

</script>

</head>
<body>
	<div style="height:90px;">
		<h1> ::: DETAIL CODE ::: ${SS }
		<input type="button" value="추가" class="add" style="width:50px; height:30px; position: relative; top:10px; left:20px;" />
		<input type="button" value="저장" class="Req" style="height:30px; position: relative; top:10px; left:20px;" />
		<input type="button" value="수정" class="chkup" style="width:50px; height:30px; position: relative; top:10px; left:20px;" />
		<input type="button" value="삭제" class="chkdel" style="width:50px; height:30px; position: relative; top:10px; left:20px;" />
		</h1>
	</div>
	<hr>
	<table style="width:850px; line-height: 15px;">
		<tr>
			<td style="width:50px;">분류</td>
			<th style="width:200px;">코드</th>
			<th style="width:200px;">코드명</th>
			<th style="width:200px;">디코드명</th>
			<th style="width:200px;">사용유무</th>
		</tr>
	</table>
	<hr>
	<c:forEach var="co" items="${list}" varStatus="st">
	<form style="width:100%;" class="chklist" >
	<div style="width:100%;" class="${co.DECODE }" >
		<input type="checkbox" name="FLAG" style="width:50px; float:left;" value="N" />
			<div style="width:200px;">${co.CODE }</div>
			<div style="width:200px;">${co.DECODE }</div>
			<div style="width:200px;">${co.DECODE_NAME }</div>
			<div style="width:200px;">${co.USE_YN }</div>
	<hr>
	</div>
	</form>
</c:forEach>
	<form class="codeList">
	</form>
</body>
</html>