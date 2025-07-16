<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.util.*,taskmanager.util.*, taskmanager.vo.*"
%>
<%
request.setCharacterEncoding("utf-8");
String loginsts = Chnull.chNull(request.getParameter("loginsts"));
String loginid = Chnull.chNull(request.getParameter("loginid"));
if(loginsts.equals("")) loginsts = "login";
boolean isFirst = false;
if(loginsts.equals("login")){
	isFirst = false;
}else{
	isFirst = true;
}	
session.invalidate();
%> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KCPASS 서비스 요청 게시판</title>
<link rel="shortcut icon" href="#">
<link rel="stylesheet" type="text/css" href="../plugins/element-ui/v2.7.2/css/index.css" />
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.7/dist/css/bootstrap.min.css">
<script type="text/javascript" src="../plugins/js/es6-promise.min.js"></script>
<script type="text/javascript" src="../plugins/js/es6-promise.auto.min.js"></script>
<script type="text/javascript" src="../plugins/vue/js/vue_v2.5.22.js"></script>
<script type="text/javascript" src="../plugins/element-ui/v2.7.2/js/index.js"></script>
<script type="text/javascript" src="../plugins/js/axios.min.js"></script>
<style type="text/css">
html{
	overflow-y:hidden;
}
body{
	font-family: Tahoma,Geneva,sans-serif;
	margin:0px;
	font-size: 14px;
	color: #606266;
}
span:focus, td:focus{
	outline:none;
}
[v-cloak]{
	display:none;
}
/* LAYOUT */
/* - Internet Explorer 10–11
   - Internet Explorer Mobile 10-11 */
:-ms-input-placeholder {
    color: #bbb !important;
    font-weight: 400 !important;
}
.el-header{
	padding-left:10px;
	width: 100%;
	display: flex;
  	align-items: center;
  	background:#fff;
  	border-bottom:1px solid #ccc;
}
.logo{
	height:20%;
	margin-left:-10px;
}
.title{
	margin-left:2px;
	font-size:20px;
	font-weight:bold;
	color:#0F1D41;
}
.sub-title{
	font-size:18px;
	font-weight:bold;
	color:#0F1D41;
	cursor:pointer;
}
/* menu */
.el-submenu__title, .el-submenu.is-disabled{
	height:59px !important;
	background:#f5f5f5 !important;
	opacity: 1 !important;
	cursor:default !important;
}
.el-submenu__title{
	padding-left:10px !important;
}
.el-menu--collapse{
	width:46px;
}
.el-main{
	background:#fff;
	padding:0px;
	height:100%;
	margin:0px !important;
	overflow-y:hidden;
}
.main-box{
	height:calc(100vh - 59px);
	padding:7px;
	overflow:hidden;
	background: #f5f5f5;
}
.main-div{
	background-image:url("../images/graylogo.png"); 
	background-position: bottom 0% right 50%;
  	background-repeat: no-repeat;
	width:100%;
	height:100%;
}
/* Start styles in form */
*{
  -ms-box-sizing: border-box;
	-moz-box-sizing: border-box;
	-webkit-box-sizing: border-box;
	box-sizing: border-box;
  margin: 0;
  padding: 0;
  border: 0;
}

.login{
  position: relative;
  top: 45%;
  width: 380px;
  display: table;
  margin: -150px auto 0 auto;
  background: #fff;
  border-radius: 4px;
}

.legend{
  position: relative;
  width: 100%;
  display: block;
  background: #0F1D41;
  padding: 15px;
  color: #fff;
  font-size: 20px;
  border-radius: 4px 4px 0px 0px;
}
.input{
  position: relative;
  width: 90%;
  margin: 15px auto;
}
.input span{
	position: absolute;
	display: block;
	color: darken(#EDEDED, 10%);
	left: 10px;
	top: 10px;
	font-size: 16px;
}
  
.input input{
    width: 100%;
    padding: 10px 5px 10px 40px;
    display: block;
    border-radius: 4px;
    transition: 0.2s ease-out;
    color: darken(#EDEDED, 30%);
}
.input-default {
	border: 1px solid #EDEDED;
}
.input input:focus{
	padding: 10px 5px 10px 10px;
	outline: 0;
	border-color: #0F1D41;
}
.submit{
	width: 45px;
	height: 45px;
	display: block;
	margin: 0 auto -15px auto;
	border-radius: 100%;
	font-size: 22px;
	cursor: pointer;
	box-shadow: 0px 0px 0px 8px #fff;
	transition: 0.2s ease-out;
	padding-left:2px;
}
.submit-default{
	background: #0F1D41;
	color: #fff;
}

.check-sign{
	font-weight:bold;
	font-size:25px;
}
.submit-default:focus, .success:focus, .fail:focus{
	outline: 0;
}
.success{
	background:#2ecc71;
	border:1px solid #2ecc71;
	color:#fff;
}
.success2{
	border: 1px solid #2ecc71;
}
.fail{
	background: lightpink;
    border: 1px solid #ff3708;
    color: #ff3708;
}
.fail2{
	border: 1px solid #ff3708;
}
.success3{
	color: #2ecc71;
}
.fail3{
	color: #ff3708;
}
.focusin{
	opacity:0;
}
.focusout{
	opacity:1;
}
.return-message{
	text-align:center;
	margin-bottom:10px;
	font-size:12px;
}
</style>
</head>
<body>
<div id="app" v-cloak>
	<el-container>
		<el-side>
			<el-menu 
				mode = "vertical"
				collapse="true" 
				background-color="#0F1D41"
				style="height:100%;">
			  <el-submenu index="1" disabled>
			    <template slot="title">
			      <img class="logo" src="../images/logo.png"/>
			      <span class="title">KCPASS</span>
			    </template>			    
			  </el-submenu>
			</el-menu>
		</el-side>
		<el-main>
			<el-header>
				<span class="sub-title" @click="go_main">서비스 요청 게시판</span>				
			</el-header>
			<div class="main-box">
				<div class="main-div">
					<form class="login" id="login" v-if="!isFirst">
					  <fieldset>
					  	<legend class="legend">Login</legend>
					    <div class="input">
					    	<input 
					    		ref="idInput" 
					    		v-model = "id" 
					    		@focus = "focusId=true" 
					    		@blur = "focusId=false" 
					    		type="text" 
					    		:class="{'input-default':!response, 'success2':response && login, 'fail2': response && !login}" 
					    		placeholder="이메일 아이디" 
					    		@keyup="checkInput($event, id,'pwInput')" 
					    		required/>
					      	<span :class="{'focusin':focusId, 'focusout':!focusId}"><i class="glyphicon glyphicon-user"></i></span>
					    </div>
					    <div class="input">
					    	<input 
					    		ref="pwInput" 
					    		v-model = "pw" 
					    		@focus = "focusPw=true" 
					    		@blur = "focusPw=false" 
					    		type="password" 
					    		:class="{'input-default':!response, 'success2':response && login, 'fail2': response && !login}" 
					    		placeholder="비밀번호" 
					    		@keyup.13="go_login" 
					    		required/>
					      	<span :class="{'focusin':focusPw, 'focusout':!focusPw}"><i class="glyphicon glyphicon-lock"></i></span>
					    </div>
					    <div v-if="retmsg" :class="{'success3':login, 'fail3':!login}" class="return-message">{{ retmsg }}</div>
					    <button type="button" :class="{'submit-default': !response, 'success': response && login, 'fail': response && !login}" class="submit" @click="go_login">
					    	<i v-if="!response" class='glyphicon glyphicon-arrow-right'></i>
					    	<i v-else :class="{'check-sign el-icon-check': login, 'check-sign el-icon-close': !login}"></i>
					    </button>
					  </fieldset>
					</form>
					<form class="login" id="login" v-else>
					  <fieldset>
					  	<legend class="legend">비밀번호변경</legend>
					    <div class="input">
					    	<input 
					    		ref="changePwInput" 
					    		v-model = "changepw" 
					    		@focus = "focusChangePw=true" 
					    		@blur = "focusChangePw=false" 
					    		type="password"  
					    		placeholder="새 비밀번호"
					    		@keyup = "checkInput($event, changepw, 'confirmPwInput')"
					    		class="input-default"
					    		required/>
					      	<span :class="{'focusin':focusChangePw, 'focusout':!focusChangePw}"><i class="glyphicon glyphicon-lock"></i></span>
					    </div>
					    <div class="input">
					    	<input 
					    		ref="confirmPwInput" 
					    		v-model = "confirmpw" 
					    		@focus = "focusConfirmPw=true" 
					    		@blur = "focusConfirmPw=false" 
					    		type="password"  
					    		placeholder="비밀번호 확인"
					    		@keyup="checkPw" 
					    		@keyup.13="go_change" 
					    		class="input-default"
					    		required/>
					      	<span :class="{'focusin':focusConfirmPw, 'focusout':!focusConfirmPw}"><i class="glyphicon glyphicon-ok"></i></span>
					    </div>
					    <div v-if="retmsg" :class="{'success3':isConfirm, 'fail3':!isConfirm}" class="return-message">{{ retmsg }}</div>
					    <button type="button" :class="{'submit-default': !response, 'success': response}" class="submit" @click="go_change">
					    	<i v-if="!response" class='glyphicon glyphicon-arrow-right'></i>
					    	<i v-else class="check-sign el-icon-check"></i>
					    </button>
					  </fieldset>
					</form>
				</div>
			</div>
		</el-main>
	</el-container>
</div>	
<script>
var ctx = "${pageContext.request.contextPath}";
var app = new Vue({
	el: "#app",
	data:{
		id:"",
		pw:"",
		changepw:"",
		confirmpw:"",
		retmsg: "",
		response: false,
		login: false,
		focusId: false,
		focusPw: false,
		focusChangePw:false,
		focusConfirmPw: false,
		isFirst: <%=isFirst%>,
		isConfirm: false
	},
	methods:{
		go_login:function(){
			const vm = this;
			vm.retmsg = "";
			vm.response = false;
			vm.$refs.idInput.blur();
			vm.$refs.pwInput.blur();
			axios({
			   	method: 'post',
			   	url: ctx+"/loginCtrl",
			   	data:{status: "login", userid: this.id, password: this.pw}
			}).then(function (result) {
				vm.response = true
				if(result.data == "first"){
					vm.retmsg = "최초접속! 비밀번호를 변경해주세요...";
					vm.isFirst = true;
					vm.response = false;
					vm.$nextTick(function(){
						vm.$refs.changePwInput.focus();	
					})
				}else if(result.data == "success"){
					vm.login = true;
					vm.retmsg = "로그인 성공! 이동합니다...";
					setTimeout(vm.go_main, 500);
				}else{
					vm.login = false;
					vm.retmsg = "아이디 또는 비밀번호가 일치하지 않습니다.";
				}
    	    });
		},
		checkInput:function(event,val,ref){
			val = val.trim();
			if(event.which == 13){
				if(val.length > 0) this.$refs[ref].focus();	
			}else{
				if(ref=="confirmPwInput") this.confirmpw = "";
			}
		},
		checkPw:function(){
			if(this.changepw == this.confirmpw){
				this.isConfirm = true;
				this.retmsg = "확인되었습니다.";
			}else{
				this.isConfirm = false;
				this.retmsg = "일치하지 않습니다.";
			}
		},
		go_change:function(){
			if(!this.isConfirm){
				this.retmsg = "일치하지 않습니다.";
				return;
			}
			const vm = this;
			vm.$refs.changePwInput.blur();
			vm.$refs.confirmPwInput.blur();
			if(vm.id=="") vm.id = "<%=loginid%>";
			axios({
			   	method: 'post',
			   	url: ctx+"/loginCtrl",
			   	data:{status: "change", userid: vm.id, changepw: vm.changepw}
			}).then(function (result) {
				if(result.data == "success"){
					vm.retmsg = "변경되었습니다!";
					vm.response = true;
					setTimeout(function(){
						vm.id = "";
						vm.pw = "";
						vm.retmsg = "";
						vm.response = false;
						vm.login = false;
						vm.focusId = false;
						vm.focusPw = false;
						vm.isFirst = false;
						vm.$nextTick(function(){
							vm.$refs.idInput.focus();	
						})	
					}, 500);
				}
    	    });
		},
		go_main:function(){
			window.location.replace(ctx+"/taskManagerView/view.jsp");
		}
	},
	mounted:function(){
		if(this.isFirst){
			this.$refs.changePwInput.focus();	
		}else{
			this.$refs.idInput.focus();	
		}
	}
})
</script>
</body>
</html>