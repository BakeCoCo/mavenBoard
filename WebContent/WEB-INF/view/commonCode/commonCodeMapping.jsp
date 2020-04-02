<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>

<style>

.openMenu {width : 0px;top:180px;left:200px;}
.openMenu {  height: 0;  width: 0;  position: absolute;  z-index: 1;  top: 170px;  left: 160px;  background-color: #111;  overflow-x: hidden;  transition: 0.5s;  padding-top: 60px;}
.openMenu th{  padding: 15px 0px 0px 0px;  text-decoration: none; font-size: 14px; color: #818181; transition: 0.3s;}
.openMenu a:hover { color: #f1f1f1;}
.openMenu .closebtn {  position: absolute; text-decoration: none;top: 0; right: 25px;font-size: 36px;margin-left: 50px;}
@media screen and (max-height: 450px) { .openMenu {padding-top: 15px;} .openMenu a {font-size: 16px;}}
.glist{color:#818181;}
.GL th, .GT th , .openMenu th{width:200px;padding : 10px 0px 0px 0px;}
hr {width:600px;}

</style>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>권한부여임마</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>

<!-- script 영역 -->
<script type="text/javascript">

function groupList(){
	document.getElementById("groupMenu").style.height = "500px";
	document.getElementById("groupMenu").style.width = "600px";
};

function closeList(){
	document.getElementById("groupMenu").style.height = "0px";
	document.getElementById("groupMenu").style.width = "0px";
};

function selectG(id){
	document.getElementById("groupMenu").style.height = "0px";
	document.getElementById("groupMenu").style.width = "0px";
	// 누르면 사용여부 Y로 업데이트.
	// 사용여부 Y인 목록이 화면에 출력되야함.
	var k = "GSEL="+id;
	var link = "./maping.ino";
	aj(k,link);
};

function aj(data,link){
	$.ajax({
		url : link,
		data : data,
		type : "POST",
	})
	.done(function(result){
		console.log(result);
		mapList(result);
	})
	.fail(function(result){
		console.log("실패");
	})
};

function mapList(data){
	$(".GT").empty();
	var ob = "";
	var gr = "";
	var use = "";
	var usyn = new Array();
	
	$.each(data.MapList, function(k,v){usyn[k] = v.OBID;});
	$.each(data.OBList, function(key,value){
		gr = value.GROUPNAME;
		ob += "<tr class='obob"+key+"' style='background:white'>";
		ob += "<th><form class='gchk"+key+"'>";
		
		if(JSON.stringify(usyn).includes(value.OBID)){
			use = "사용";
			ob += "<input type='checkbox' id='USCHK' name='USCHK' checked='checked' value='A' onclick='chkClick("+JSON.stringify(data.OBList)+",\""+value.HIGH_OB+"\","+key+")'>";
		}else{
			use = "미사용";
			ob += "<input type='checkbox' id='USCHK' name='USCHK' value='D' onclick='chkClick("+JSON.stringify(data.OBList)+",\""+value.HIGH_OB+"\","+key+")'>";
		}
		
		if(value.HIGH_OB==undefined){value.HIGH_OB='';}
		ob += "<input type='hidden' name='GID' value="+value.GROUPID+">";
		ob += "<input type='hidden' name='OBID' value="+value.OBID+">";
		ob += "<input type='hidden' name='OBNAME' value="+value.OBNAME+">";
		ob += "<input type='hidden' name='DEPTH' value="+value.DEPTH+">";
		ob += "<input type='hidden' name='HIGH' value="+value.HIGH_OB+">";
		ob += "</form></th>";
		
		if(value.HIGH_OB==''){value.HIGH_OB='TOP';}
		ob += "<th>"+use+"</th>"; 
		ob += "<th>"+value.OBID+"</th>";
		ob += "<th>"+value.OBNAME+"</th>";
		ob += "<th>"+value.DEPTH+"</th>";
		ob += "<th>"+value.HIGH_OB+"</th>";
		ob += "</tr>";
	});
	
	$(".GT").append(ob);
	$(".GR").empty();
	var gname = "<h1> 그룹 이름 : "+gr+"</h1>";
	$(".GR").append(gname);
};

function chkClick(a,b,c){// JSON.stringify 값을 넘겨받아서 체크가 되어있나 안되어있나 비교를 해야하는듯한데 흠.. 
	console.log("JSON.Stringify");
	
	var s=0;
	var TF= true;
	
	$(".obob"+c).css("background",'white');
	$("input:checkbox[name=USCHK]").each(function(k,v){
		if(TF){
			if(a[c].HIGH_OB==undefined){
				if(a[c].OBID==a[k].HIGH_OB){
					if(this.checked){
						TF = false;
						s=0;
						$(".obob"+k).css('background','red');
						return TF;
					}else{
						s=1;
					}
				}
			}else{
				if(a[c].HIGH_OB==a[k].OBID){
					if(this.checked){
						s=1;
					}else{
						TF=false;
						s=0;
						$(".obob"+k).css('background','red');
						return TF;
					}
				}else if(a[c].OBID==a[k].HIGH_OB){
					if(this.checked){
						TF=false;
						s=0;
						$(".obob"+k).css('background','red');
						return TF;
					}
				}
			}
		}
	});
	
	if(s==1){
		console.log("가능.");
	}else{
		alert(c+"번째 때문에 불가능.");
		$("input:checkbox[name=USCHK]").each(function(k,v){
			if(c==k){
				if(this.checked){
					this.checked=false;
				}else{
					this.checked=true;
				}
			}
		});
	}
}


function grantUp(){
	var list = "";
	var link = "./grantUP.ino";
	$("input:checkbox[name=USCHK]").each(function(k,v){
		if(this.checked){
			if(this.value=="A" || this.value=="U" ){
				this.value="U";
			}else{
				this.value="A";
			}
		}else{
			this.value="D";
		}
		this.checked=true;
		
		
		list +="&";
		list += $(".gchk"+k).serialize();
		
		
		if(this.value=="U" || this.value=="A"){
			this.checked=true;
		}else{
			this.checked=false;
		}
	});
	aj(list,link);
}

</script>

<body>
	<div>
		<h1>권한 부여</h1>
	</div>
	<div style="position:absolute; top:110px; left:180px;" class="GR">
		
	</div>
	<div style="width:750px;" align="right">
		<a href="javascript:grantUp()"> 권한저장 </a>
	</div>
	
	<span align="left" style="width:100px; position:absolute; left:40px; top:180px; padding-right:1px solid black;
	font-size:20px; cursor:pointer" onclick="groupList()">그룹목록</span>
	
	<div id="groupMenu" class="openMenu">
		<a href="javascript:void(0)" class="closebtn" onclick="closeList()";>&times;</a>
		
		<table style="width:500px; color:#818181;">
			<tr>
				<th>그룹ID</th>
				<th>그룹이름</th>
				<th>사용여부</th>
			</tr>
		</table>
		
		<table style="width:500px; color:#818181;" class="GIDList">
		<c:forEach var="nn" items="${gList}">
			<tr>
				<th>${nn.GROUPID}</th>
				<th style="cursor:pointer;" onclick="selectG(${nn.GROUPID})">${nn.GROUPNAME}</th>
				<th>${nn.USE_YN}</th>
			</tr>
			<form class = "GHide">
				<input type="hidden" name="GID" value="${nn.GROUPID }">
			</form>
		</c:forEach>
		</table>
	</div>
	
	<hr>
	
	<table style="width: 700px; position:absolute; left:170px; top:180px;" class="GL">
		<tr>
			<th>체크박스</th>
			<th>사용여부</th>
			<th>객체ID</th>
			<th>객체이름</th>
			<th>DEPTH</th>
			<th>하위오브젝트</th>
		</tr>
	</table>

	<table style="width:700px; position:absolute; left:170px; top:210px;" class="GT" id="GT"></table>
	
</body>
</html>