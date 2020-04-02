<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style type="text/css">
.pagingBox a{margin-left : 12px;font-size : 18px;}
.paingnBox em{margin-left : 16px;font-size : 18px; }
</style>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

<script>
	$(function(){
		$("#rega").change(function(){
			date($(this).attr("name"));
		});
		$("#regb").change(function(){
			date($(this).attr("name"));
		});
		$("#find").change(function(){
			if(check()){
				move();
			}
		});
		$("#search").click(function(){
			if(check()){
				move();
			}
		});
	});

function date(val){
	var dateChk = $("#"+val).val();
	var dd = dateChk.replace(/[^0-9]/g,'');
	dateChk = "";
	
	var year = dd.substr(0,4);
	var month = dd.substr(4,2);
	var day = dd.substr(6,2);
	
	if(((year<1990 || year>2020 ) || (month < 1 || month > 12) || (day < 1 || day > 31))){
		alert("년도는 1990년 이상 2020년 이하로 \n"+"달은 1월 이상 12월 이하로 \n"+"날짜는 1일 이상 31일 이하로");
		$("#"+val).val("");
	}else{
		dateChk += year+"-"+month+"-"+day;
		$("#"+val).val(dateChk);
	}
	console.log(year+"-"+month+"-"+day);
	console.log(dateChk);
	console.log(dd);
}

function move(cur,num){
	var input = $("form[name=selectForm]").serialize();
	if(cur!=null){
		input += "&currentPage="+cur;
	}
	var url="./Search.ino";
	if(num!=null){
		input +="&NUM="+num;
		//location.href="./FDetail.ino?"+input;
		url="./FDetail.ino";
	}
	goajax(input,url);
}

function goajax(input,url){
	//console.log(input);
	console.log(url+" : "+input);
	$.ajax({
		url : url,
		data : input,
		type : "POST",
	})
	.done(function(result){
		//console.log(result);
		if(url=="./FDetail.ino"){
			$(".body").empty();
			$(".body").append(result);
		}else{
			findList(result);				//리스트 출력
			pageList(result.web);		//페이징
			
		}
	})
	.fail(function(){
		alert("실패");
	});
}


function pageList(web){
	$(".pagingBox").empty();
	var page = "";
	if(web.currentPage != 1){
	page += " <a href=\"javascript:move(1)\" title=\"첫 페이지 이동합니다.\" >처음</a> "	}
	
	if(web.startPage > 1){
	page += " <a href=\"javascript:move("+(web.startPage-1)+")\" title=\"이전 10 페이지로 이동합니다.\" >이전</a>  ";	}
	
	for(var i=web.startPage; i<=web.endPage; i++){
	if(web.currentPage==i){
		page += "<em style='margin-left:17px;'>"+ i +"</em>" ;	}
		else{
		page += "<a href=\"javascript:move("+i+")\">"+i+"</a>";	}
	}
	if((web.endPage+1) <= web.totalPage){
	page += " <a href=\"javascript:move("+(web.endPage+1)+")\" title=\"다음 10페이지로 이동합니다.\">다음</a>  ";	}
	
	if(web.currentPage<web.totalPage){
	page += " <a href=\"javascript:move("+(web.totalPage)+")\" title=\"마지막 페이지로 이동합니다.\">마지막</a> ";	}

	$(".pagingBox").append(page);
}

//sss += "<div style=\"width: 300px; float: left;\" id=\"title\" name=\"title\"><a href=\"javascript:detailS("+value.NUM+","+result.web.currentPage+")\">"+value.TITLE+"</a></div>";

function findList(result){
	$("#LT").empty();
	var sss = "<hr style=\"width: 600px\">";
	$.each(result.FList, function(key,value){
		sss += "<div style=\"width: 50px; float: left;\"  >"+value.NUM+"</div>";
		sss += "<div style=\"width: 300px; float: left;\" class=\"detail\"><a href=\"javascript:move("+result.web.currentPage+","+value.NUM+")\">"+value.TITLE+"</a></div>";
		sss += "<div style=\"width: 150px; float: left;\" >"+value.NAME+"</div>";
		sss += "<div style=\"width: 150px; float: left;\" >"+value.REGDATE+"</div>";
		sss += "<hr style=\"width: 600px\">";
	});
	$("#LT").append(sss);
}

function change(){
	$("#find").val("");
}

function check(){
	var sel = $("#selected").val();
	var no1 = $("#find").val().trim();
	if(sel=="DECODE001"){
		$("#find").val($("#find").val().replace(/[^0-9]/g,''));
		var no2 = $("#find").val().trim();
		if(no1!=no2){
			alert("숫자를 입력해주세요.");
			return false;
		}
	}
	if(sel=="전체"){
		return true;
	}
	if(no1==""){
		$("#find").val("");
		alert("제대로 입력해주세요.");
		return false;
	}
	return true;
}
</script>


</head>
<body class="body">

	<div>
		<h1 id="h1">자유게시판</h1>
	</div>
	<form name="selectForm">
	<div class ="listup" style="width:100%;" >
		<div style="padding: 0px 0px 0px 150px; width:500px; position:static" align="left">
		<select style="width:60px; padding: 4px; vertical-align: middle;" id="selected" name="selected" onchange="change()" >
				<option value="전체"  <c:if test="${select eq 'every'}">selected</c:if>>전체</option>
				<c:forEach items="${com }" var="c">
					<option value="${c.DECODE }" <c:if test="${select eq c.DECODE}">selected</c:if> >${c.DECODE_NAME }</option>
				</c:forEach>
				
		</select>
		<input hidden="hidden"/>
		<input type="text" name="find" id="find" value="${find}" style="padding:4px; vertical-align: middle;" />
		<input type="button" name="search" id="search" value="찾기" style="padding:4px; vertical-align: middle;" />
		</div>
		
		<div style="width:700px;" align="right">
			<a href="./freeBoardInsert.ino">글쓰기</a>
		</div>
	</div>
	<div style="width:600px; position:static;  padding: 4px;" align="center">
		<input type="text" id="rega" name="rega" value=${rega } >
		~
		<input type="text" id="regb" name="regb" value=${regb } >
	</div>
	</form>
	<div id="LT" name="LT">
	<hr style="width: 600px">
	<c:forEach items="${FList }" var="dto">
			<div style="width: 50px; float: left;" >${dto.NUM }</div>	
			<div style="width: 300px; float: left;" class="detail"><a href="javascript:move(${web.currentPage },${dto.NUM})">${dto.TITLE }</a></div>
			<div style="width: 150px; float: left;" >${dto.NAME }</div>
			<div style="width: 150px; float: left;">${dto.REGDATE }</div> 
		<hr style="width: 600px">
	</c:forEach>
	</div>
	
	<!-- 페이지 이동 버튼 -->
	<div class="pagingBox">
			<!-- 처음으로, 10 페이지 앞으로 -->
			<c:if test="${web.currentPage != 1}">
				<a href="javascript:move(1)" title="첫 페이지 이동합니다." >처음</a>
			</c:if>
			<c:if test="${web.currentPage > 10}">
				<a href="javascript:move(${web.startPage-10})" title="이전 10 페이지로 이동합니다." >이전</a>
			</c:if>

			<!-- 10 페이지 단위로 표시되는 페이지 이동 버튼 -->
			<c:forEach var="i" begin="${web.startPage}" end="${web.endPage}" step="1">
				<c:if test="${web.currentPage == i}">
						<em>${i}</em>
				</c:if>
				<c:if test="${web.currentPage != i}">
						<a href="javascript:move(${i})">${i}</a>
				</c:if>
			</c:forEach>

			<!--  10 페이지 뒤로, 마지막으로 -->
			<c:if test="${web.currentPage+10 < web.totalPage}">
				<a href="javascript:move(${web.endPage+1})" title="다음 10페이지로 이동합니다.">다음</a>
			</c:if>
			<c:if test="${web.currentPage < web.totalPage}">
				<a href="javascript:move(${web.totalPage})" title="마지막 페이지로 이동합니다.">마지막</a>
			</c:if>
			
		</div>
</body>
</html>