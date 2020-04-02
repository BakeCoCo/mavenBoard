<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
	$(function(){
		$("#name").change(function(){
			var val = $(this).attr("name");
			byteChk(val);
		});
		$("#title").change(function(){
			var val = $(this).attr("name");
			byteChk(val);
		});
		$("#content").change(function(){
			var val = $(this).attr("name");
			byteChk(val);
		});
		
		$("#write").click(function(){
			write();
		});
		$("#cancel").click(function(){
			back();
		});
	});

function back(){
	location.replace("./main.ino");
}

function write(){
	if(check()){
		var yesno = confirm('작성하시겠습니까?');
		if(yesno){
			ajax();
		}else{
			return yesno;
		}
	}else{
		return false;
	}
}


function ajax(){
	var input = $("form[name=put]").serialize();
	input +="&do=insert";
	$.ajax({
		url : "./IMD.ino",
		data : input,
		type : "POST",
	})
	.done(function(result){
		console.log(result);
		if(result.stat=="success"){
			alert("입력성공");
			back();
		}else{
			alert("입력실패");
		}
	})
	.fail(function(){
		alert("실패");
	})
	.always(function(result){
	});
}

function check(){
	var names = $("#name").val();
	var titles = $("#title").val();
	var contents = $("#content").val();
	var TF = true;
	if(!names.trim()){
		alert("name 제대로 입력해주세요");
		$("#name").val("");
		TF=false;
	}else if(!titles.trim()){
		alert("title 제대로 입력해주세요");
		$("#title").val("");
		TF=false;
	}else if(!contents.trim()){
		alert("content 제대로 입력해주세요");
		$("#content").val("");
		TF=false;
	}
	return TF;
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
		limitByte=4000;
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


</head>
<body>
	<div>
		<h1>자유게시판</h1>
	</div>
	<div style="width:650px;" align="right">
		<a href="./main.ino">리스트로</a>
	</div>
	<hr style="width: 600px">
	<!--<form action="./freeBoardInsertPro.ino"> -->
	<form name="put" id="put" onsubmit="return check()" >
		<div style="width: 150px; float: left;">이름 :</div>
		<div style="width: 500px; float: left;" align="left">
			<input id="name" type="text" name="name" />
		</div>
		
		<div style="width: 150px; float: left;">제목 :</div>
		<div style="width: 500px; float: left;" align="left">
			<input id="title" type="text" name="title"/>
		</div>
	
		<div style="width: 150px; float: left;">내용 :</div>
		<div style="width: 500px; float: left;" align="left">
			<textarea id="content" name="content" rows="25" cols="65"  ></textarea>
		</div>
		<div align="right">
		<input type="button" value="글쓰기" id="write" name="write"/>
		<input type="button" value="다시쓰기" onclick="reset()"/>
		<input type="button" value="취소"  id="cancel" name="cancel">
		&nbsp;&nbsp;&nbsp;
		</div>
	
	</form>
	
	
	
</body>
</html>