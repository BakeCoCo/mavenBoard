<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
	$(function(){
		$("#title").keyup(function(){
			var val = $(this).attr("name");
			byteChk(val);
		});
		$("#content").keyup(function(){
			var val = $(this).attr("name");
			byteChk(val);
		});
		
		$("#write").click(function(){
			if(cross($(this).val())){
				if(check()){
					var modify = "modify";
					input(modify);
				}
			}
		});
		$("#cancel").click(function(){
			if(cross($(this).val())){
				var can = "cancel";
				input(can);
			}
		});
		$("#del").click(function(){
			if(cross($(this).val())){
				var del = "del";
				input(del);
			}
		});
	});
	
function cross(a){
	return confirm(a+" 합니까?"); 
}

function check(){
	var names = $("#name").val();
	var titles = $("#title").val();
	var contents = $("#content").val();;
	var TF = true;
	if(!names.trim()){
		alert("이름 제대로 입력해주세요");
		TF=false;
	}else if(!titles.trim()){
		alert("제목 제대로 입력해주세요");
		TF=false;
	}else if(!contents.trim()){
		alert("내용 제대로 입력해주세요");
		TF=false;
	}
	return TF;
}

function input(doit){
	var input =$("form[name=put]").serialize();
	input += "&selected=${web.selected}&find=${web.find}&currentPage=${web.currentPage}";
	input += "&rega=${web.rega}&regb=${web.regb}";
	var url = "./IMD.ino";
	if(doit=="del"){
		input +="&do=delete";
	}else if(doit=="cancel"){
		input +="&do=cancel";
	}else if(doit=="modify"){
		input += "&do=modify";
	}
	console.log(input);
	ajax(input,url);
}


function ajax(input, url){
	$.ajax({
		url : url,
		data : input,
		type : "POST",
	})
	.done(function(result){
		var main = "./main.ino";
		
		if(result.stat=="success"){
			alert("성공");
			ajax(input,main);
			//location.href = "./main.ino?"+input+"&rega=${web.rega}&regb=${web.regb}";
		}else if(result.stat=="cancel"){
			console.log("취소");
			ajax(input,main);
			//location.href = "./main.ino?"+input+"&rega=${web.rega}&regb=${web.regb}";
		}else if(result.stat=="fail"){
			alert("실패");
		}else{
			$(".body").empty();
			$(".body").append(result);
		}
	})
	.fail(function(){
		alert("실패");
	});
}

//한글 3바이트, 영어 1바이트, 특수문자 1바이트, 숫자 1바이트
function byteChk(val){
	var limitByte = 0;
	var limitLength = 0;
	var countByte =0;
	var chkByte = $("#"+val).val();
	if(val=="name"){
		limitByte=20;
	}else if(val=="title"){
		limitByte=100;
	}else if(val=="content"){
		limitByte=1000;
	}
	for(var i=0; i<chkByte.length; i++){
		var cbyte = chkByte.charAt(i);
		if(escape(cbyte).length==6){
			countByte +=3;
		}else{
			countByte++;
		}
		if(limitByte>=countByte){
			limitLength++;
		}
	}
	if(countByte>limitByte){
		alert("내용입력 제한을 초과하셨습니다. \r\n 입력제한 : "+limitByte+" 바이트");
		$("#"+val).val($("#"+val).val().substr(0,limitLength));
		return false;
	}
	return true;
}


</script>

<body class="body">

	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="./main.ino">리스트로</a>
	</div>
	<hr style="width: 600px">
	
	<form name="put" id="put">
		<input type="hidden" name="num" value="${look.NUM }" />
		
		<div style="width: 150px; float: left;">이름 :</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" id="name" name="name" value="${look.NAME }" readonly/></div>
		
		<div style="width: 150px; float: left;">제목 :</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" id="title" name="title"  value="${look.TITLE }"/></div>
	
		<div style="width: 150px; float: left;">작성날자</div>
		<div style="width: 500px; float: left;" align="left"><input type="text" id="regdate" name="regdate"  value="${look.REGDATE }" readonly/></div>
	
		<div style="width: 150px; float: left;">내용 :</div>
		<div style="width: 500px; float: left;" align="left"><textarea id="content" name="content" rows="25" cols="65"  >${look.CONTENT }</textarea></div>
		<div align="right">
		<input type="button" value="수정" id="write" name="write">
		<input type="button" value="삭제" id="del" name="del">
		<input type="button" value="취소" id="cancel" name="cancel">
		&nbsp;&nbsp;&nbsp;
		</div>
	</form>
	<form name="web" id="web">
	<input type="hidden" name="num" value="${web.rega }" />
	<input type="hidden" name="num" value="${web.regb }" />
	<input type="hidden" name="num" value="${web }" />
	</form>
	
</body>
</html>