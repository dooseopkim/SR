<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.*,taskmanager.vo.*"       
%>
<%
request.setCharacterEncoding("utf-8");
HttpSession ses = request.getSession(true);
KidpMembers km = new KidpMembers();
km = (KidpMembers)ses.getAttribute("mem");
String loginName = "";
String loginId = "";
boolean isLogin = false;
int userno = 0;
if(km!=null){
	if(km.isLogin_chk()){
		loginName = km.getName();
		loginId = km.getEmp_code();
		userno = km.getUserno();
		isLogin = true;
	}	
}
String ua = request.getHeader("User-Agent");
boolean isChrome = false;
if(ua.contains("Chrome")){
	isChrome = true;
}
%> 
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>KCPASS 서비스 요청 게시판</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" href="#">
<link type="text/css" rel="stylesheet" href="../plugins/element-ui/v2.7.2/css/index.css" />
<link rel="stylesheet" type="text/css" href="../plugins/bootstrap-3.3.7/custom/css/bootstrap.min.css">
<link rel="stylesheet" href="../plugins/tippy/css/translucent.css"/>
<link rel="stylesheet" href="../plugins/contextmenu/css/jquery.contextMenu.css"/>
<link rel="stylesheet" href="../plugins/Clusterize/clusterize.css"/>
<script type="text/javascript" src="../plugins/js/es6-promise.min.js"></script>
<script type="text/javascript" src="../plugins/js/es6-promise.auto.min.js"></script>
<script type="text/javascript" src="../plugins/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="../plugins/Clusterize/clusterize.min.js"></script>
<script type="text/javascript" src="../plugins/vue/js/vue_v2.5.22.js"></script>
<script type="text/javascript" src="../plugins/element-ui/v2.7.2/js/index.js"></script>
<script type="text/javascript" src="../plugins/element-ui/v2.7.2/locale/ko.js"></script>
<script	type="text/javascript" src="../plugins/js/lodash.min.js"></script>
<script type="text/javascript" src="../plugins/js/moment.js"></script>
<script type="text/javascript" src="../plugins/contextmenu/js/jquery.contextMenu.js"></script>
<script type="text/javascript" src="../plugins/js/axios.min.js"></script>
<script type="text/javascript" src="../plugins/tippy/js/popper.min.js"></script>
<script type="text/javascript" src="../plugins/tippy/js/index.all.min.js"></script>
<script type="text/javascript" src="../plugins/js/shim.min.js"></script>
<script type="text/javascript" src="../plugins/js/xlsx.full.min.js"></script>
<style tyle="text/css">
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
.fr{
	float:right;
}
.fl{
	float:left;
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
.middle-title{
	border-bottom:1px solid #ccc;
	padding:5px 0px 13px 10px;
	font-size:14px;
}
.today {
	margin:3px 0px 0px 8px;
	color: #25396C;
	font-size:12px;
	font-weight:bold;
}
.login{
	position:absolute;
	right:42px;
	<%if(!isChrome){%>
		top:16px;
	<%}%>
}
.username{
	position:absolute;
	right:240px;
	<%if(!isChrome){%>
		top:20px;
	<%}%>
}
.useinfo{
	font-size:18px;
	position:absolute;
	right:12px;
	cursor:pointer;
	<%if(!isChrome){%>
		top:22px;
	<%}%>
}
.el-icon-info:before{
	color:#999;
}
/* menu */
.el-menu--collapse{
	width: 44px;
}
.el-menu-item, .el-submenu__title{
	padding: 0 20px 0 10px !important;
}
.el-icon-arrow-down:before {
    content: "";
}
.el-submenu__title, .el-submenu.is-disabled{
	height:59px !important;
	background:#f5f5f5 !important;
	opacity: 1 !important;
    cursor: pointer !important;
}
.el-main{
	background:#fff;
	padding:0px !important;
	height:100%;
	margin:0px !important;
	overflow-y:hidden;
}
.main-box{
	height:calc(100vh - 60px);
	padding:7px;
	overflow:hidden;
	background:#f5f5f5;
}
.main-div{
	background:#f5f5f5;
	background-image:url("../images/graylogo.png"); 
	background-position: bottom 46% right 50%;
  	background-repeat: no-repeat;
	width:100%;
	height:100%;
}	

.ctrbox {
	padding:0px 7px 7px 0px;	
}
#loading-box{
	display: flex;
  	align-items: center;
	padding-left:7px;
	background:#fff;
	height:35px;
}
.loading-status, .clusterize-no-data{
	color: #25396C;
    font-size: 12px;
    font-weight:bold;
}
.clusterize-no-data{
	height:60px;
}
.data-total{
	margin:0px 7px 0px 0px;
	display: inline-block;
    height: 20px;
    line-height: 19px;
    padding: 2px 7px 20px 7px;
    white-space: nowrap;
    border: 1px solid rgba(64, 158, 255, 0.2);
    border-radius: 4px;
    background-color: rgba(64, 158, 255, 0.1);
}
/*reload switch*/
.reload-box{
	position:absolute;
	right:15px;
}
.refresh-icon{
    position:relative;
    <%if(isChrome){%>
    	top:2px;
    <%}else{%>
    	bottom:8px;	
    <%}%>
    font-weight:bold;
    font-size:16px;
    color:#777;
    cursor:pointer;
}
.refresh-icon:hover{
	color: #409EFF;
}
.super {
	vertical-align:super;
	font-size: 10px;  
}
.super::before{
	content: '데이터 갱신'
}
/*filter*/
.filter-date{
	width:260px !important;
	margin-left:-7px;
	border-radius: 0px 4px 4px 0px;
}
.filter-duedate{
	width:130px !important;
	margin-left:-7px;
}
.filter-duedate .el-input__inner{
 	border-radius: 0px 4px 4px 0px;
}
.filter-checkbox{
	position: relative;
	vertical-align: middle;
	bottom: 1.5px;
	transform: scale(1.2);
	cursor: pointer;
}
.el-checkbox__label{
	font-size: 12px;
	padding-left:4px;
}
.el-checkbox{
	font-size:19px;
	margin-right:5px;
}
.el-checkbox__inner{
	border: 1px solid #999;
	width:15px;
	height:15px;
}
.el-checkbox__inner::after{
	left:5px;
	width:3px;
}
.filter-select{
	width: 300px;
	margin-left:-4px;
}
.filter-select .el-input__inner{
	border-radius:0px 4px 4px 0px;
	border-left:1px solid transparent;
}
.filter-select-field{
	width:102px !important;
}
.filter-date-select{
	width:120px;
}
.filter-custom-select{
	width:100px;
}
.filter-select-op{
	width:70px;
	margin:0px 3px 0px 3px;
}
.filter-select-op .el-input__inner{
    background-color: #DDD;
    font-weight:bold;
}
.filter-select-op .el-input__inner:focus {
    border-color: #DCDFE6 !important;
}
.filter-custom-select .el-input.is-disabled .el-input__inner{
	cursor:default;
}
.filter-custom-select .el-input__inner{
	border-radius:4px 0px 0px 4px;
	background-color: #f5f7fa;
    color: #909399 !important;
}
.filter-custom-select .el-input__suffix {
	display:none;
}
.filter-date-select .el-input__inner{
	border-radius:4px 0px 0px 4px;
	background-color: #f5f7fa;
    color: #909399;
}
.filter-date-select .el-input__inner:focus{
	border: 1px solid #DCDFE6 !important;
}
.filter-input{
	height: 28px;
    line-height: 28px;
    -webkit-appearance: none;
    background-color: #FFF;
    background-image: none;
    border-radius: 0px 4px 4px 0px;
    margin-left:-4px;
    border-top: 1px solid #DCDFE6;
    border-bottom: 1px solid #DCDFE6;
    border-right: 1px solid #DCDFE6;
    border-left: 1px solid transparent;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    color: #606266;
    display: inline-block;
    font-size: 12px;
    outline: 0;
    padding: 0 15px;
    -webkit-transition: border-color .2s cubic-bezier(.645,.045,.355,1);
    transition: border-color .2s cubic-bezier(.645,.045,.355,1);
	width:550px;
}
.filter-input .el-icon-circle-close{
	cursor:pointer;
}
.clearable{
  position: relative;
  display: inline-block;
}
.clearable__clear{
  position: absolute;
  right:5px; top:5px;
  user-select: none;
  cursor: pointer;
  color: #C0C4CC;
  font-size:10px;
  border:1px solid #E4E7ED;
  padding:1px 3px 1px 3px;
  border-radius:4px;
  background: #f5f7fa;
  opacity:0;
}
.clearable__clear:hover{
	opacity:1;
}
.filter-input:hover+.clearable__clear{
	opacity:1;
}
.clearable__clear::before{
	content:'초기화'
}
.clearable input::-ms-clear {  /* Remove IE default X */
  display: none;
}
.filter-sphere{
	width:550px;
	margin-left:-4px;
}
.filter-sphere .el-input__inner{
	border-radius:0px 4px 4px 0px;
	border-left:1px solid transparent;
}
.custom-border{
	border-left: 2px solid #CCC;
	margin:0px 8px 0px 3px;
}
/*tag*/
.tag{
	display: inline-block;
    height: 20px;
    <%if(isChrome){%>
    	line-height: 19px;	
    <%}else{%>
    	line-height: 17px;
    <%}%>
    padding: 0px 5px;
    font-size: 12px;
    white-space: nowrap;
    border: 1px solid rgba(64, 158, 255, 0.2);
    border-radius: 4px;	
    text-indent:0 !important;
    margin-right:7px;
    cursor:default;
}
.report-tag{
	cursor:pointer;
}
.report-tag:hover{
	background:#ddd;
}
.no-hover:hover > td {
	background-color: inherit !important;
}
.green{
	background-color: rgba(103,194,58,0.1);
    border-color: rgba(103,194,58,0.2);
    color: #67c23a;
}
.red{
	background-color: rgba(245,108,108,0.1);
    border-color: rgba(245,108,108,0.2);
    color: #f56c6c;
}
.blue{
	background-color: rgba(64, 158, 255, 0.1);
	border-color: rgba(64, 158, 255, 0.2);
	color: rgb(64, 158, 255);
}
.gray{
	background-color: rgba(144,147,153,0.1);
    border-color: rgba(144,147,153,0.2);
    color: #777;
}
.brown{
	background-color: rgba(230,162,60,0.1);
    border-color: rgba(230,162,60,0.2);
    color: #e6a23c;
}

/*custom btn*/
.btn{
	display: inline-block;
	height: 20px;
	line-height: 19px;
	padding: 0px 7px;
	text-indent:0 !important;
	cursor:pointer;
	border: 1px solid #bbb;
	overflow: visible;
	text-decoration: none;
	white-space: nowrap;
	color: #555;
	background-color: #ddd;
	background-image: -webkit-gradient(linear, left top, left bottom, from(rgba(255,255,255,1)), to(rgba(255,255,255,0)));
	background-image: -webkit-linear-gradient(top, rgba(255,255,255,1), rgba(255,255,255,0));
	background-image: -moz-linear-gradient(top, rgba(255,255,255,1), rgba(255,255,255,0));
	background-image: -ms-linear-gradient(top, rgba(255,255,255,1), rgba(255,255,255,0));
	background-image: -o-linear-gradient(top, rgba(255,255,255,1), rgba(255,255,255,0));
	background-image: linear-gradient(top, rgba(255,255,255,1), rgba(255,255,255,0));
	
	-webkit-transition: background-color .2s ease-out;
	-moz-transition: background-color .2s ease-out;
	-ms-transition: background-color .2s ease-out;
	-o-transition: background-color .2s ease-out;
	transition: background-color .2s ease-out;
	background-clip: padding-box; 
	-moz-border-radius: 3px;
	-webkit-border-radius: 3px;
	border-radius: 3px;
	-webkit-touch-callout: none;
	-webkit-user-select: none;
	-khtml-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;
}
.btn:active{
  background: #e9e9e9;
  position: relative;
  top: 1px;
  text-shadow: none;
  -moz-box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
  -webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
  box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
}
.excel-btn{
	height: 25px;
	line-height:22px;
	margin-left:10px;
	background: #f0f9eb url('../images/excel-icon.png') no-repeat;
	background-position:5px 3px;
   	color: #67c23a;
    border: 1px solid #c2e7b0;
}
.excel-btn:active{
	background: #e9e9e9 url('../images/excel-icon.png') no-repeat;
	background-position:5px 3px;
	position: relative;
	top: 1px;
	text-shadow: none;
	-moz-box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
	-webkit-box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .3) inset;
}
.excel-label{
	margin-left:17px;
}
.excel-label::after{
	position: relative;
	left: 1px;
	content:'\A\2913'
}
.square_btn{
    display: inline-block;
    box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.29);
    margin-right:2px;
}
.square_btn:active {
    box-shadow: inset 0 0 2px rgba(128, 128, 128, 0.1);
    transform: translateY(2px);
}
.manual-confirm-btn{
	margin-left:10px;
	font-size:12px;
}
/*custom-btn*/
.files{
	cursor: pointer;
	background-color: rgba(230,162,60,.1);
    border-color: rgba(230,162,60,.2);
    color: #e6a23c;
}
.files-download:hover{
	color: #fff;
    background-color: #e6a23c;
    border-color: #e6a23c;
}
.file-del:hover{
	color:#fff;
	background:#e6a23c;
	border-radius:6px;
}
.filebox{
	margin-top:10px;
	max-height:52px;
	overflow-x:hidden;
}
.custom-delete{
	color: #aaa;
	margin-left:4px;
	padding:0px 2px 0px 2px;
	font-size:11px;
}
.custom-delete:before {
    content: "\2715";
}
.custom-delete:hover {
	cursor: pointer;
	color: #fff;
	border-radius: 50%;
	background: #666;
}
/*el-card */
.el-card__body{
	padding:0px 15px;
}
/* el-dialog */
.el-dialog__body{
	padding:30px 40px 15px 0px;
}
#contentDialog .el-dialog__body{
	padding: 0px 40px 0px 0px !important;
}
.el-dialog__header,.el-dialog__footer{
	background:#f1f1f1;
}
.el-dialog__header{
	padding:15px 0px 15px 15px;
}
.el-dialog__footer{
	padding:15px 15px 15px 0px;
}
.dialog-title {
	font-size:16px;
}

.el-form-item--mini.el-form-item {
	margin-bottom:15px;
}
.time-passed{
    color: #f56c6c;
}
.memlist-box{
	width:100%;
	max-height:85px;
	overflow-x:hidden;
}
.memlist{
	width: 100%;
	cursor:pointer;
	font-size: 12px;
	padding:0px 5px;
}
.memlist:hover{
	background:rgba(222,249,222);
}
.select .el-input__inner{
	border-radius:4px 0px 0px 4px;
}
.select-div{
	position:relative;
}
.select-btn{
	position:absolute;
 	right: 0;
    top: 0;
    height: 100%;
	border-radius:0px 4px 4px 0px;
}
.upload{
	display:none !important;
}
/* inputs */
.custom-input{
	height: 28px;
    line-height: 28px;
    -webkit-appearance: none;
    background-color: #FFF;
    background-image: none;
    border-radius: 4px;
    border: 1px solid #DCDFE6;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    color: #606266;
    display: inline-block;
    font-size: 12px;
    outline: 0;
    padding: 0 15px;
    -webkit-transition: border-color .2s cubic-bezier(.645,.045,.355,1);
    transition: border-color .2s cubic-bezier(.645,.045,.355,1);
    width: 100%;
}
.custom-input:focus{
	outline: none;
    border-color: #409eff;
}
.custom-textarea{
	display: block;
    resize: vertical;
    padding: 5px;
    line-height: 1.5;
    box-sizing: border-box;
    width: 100%;
    font-size: 12px;
    color: #606266;
    background-color: #fff;
    background-image: none;
    border: 1px solid #dcdfe6;
    border-radius: 4px;
    transition: border-color .2s cubic-bezier(.645,.045,.355,1);
    overflow:hidden;
}
.custom-textarea:focus{
	outline: none;
    border-color: #409eff;
}
.readonly:focus{
    border-color: #ddd !important;
}
.readonly{
	resize: none !important;
}
.autosize { 
	min-height: 50px; 
}
.autosize2 { 
	min-height: 120px; 
}
::placeholder {
  color: #ccc;
}
.pw-field{
	width:49.5%;
}
.pw-notmatch{
	background-color: rgba(245,108,108,.1);
    border-color: rgba(245,108,108,.2);
}
.pw-notmatch:focus{
	border-color: rgba(245,108,108,.2);
}
.input-icon{
	position:absolute;
	top:0px;
	right:16px;
}
.enter-icon::before{
    content:'\21b5';
	font-size:20px;
	color:#ccc;
}
/* list table */
.clusterize{
	background:#f5f5f5;
	font-size:9pt;
	border:1px solid #ccc;
}
.header-div{
	overflow-y:scroll;
}
.list-div{
	overflow-y:scroll;
	overflow-x:hidden;
}
.task-div{
	max-height: 650px;
	margin: 0;
	overflow-x:hidden;
	padding-right:14px;
}
.info-dialog .el-dialog__body{
	padding:0px 20px 20px 20px;
}
.hr-line {
	display: flex;
	align-items: center;
	justify-content: center;
	white-space: nowrap;
}
.hr-line::before, .hr-line::after {
    content: '';
    background-color: #ccc;
    height: 1px;
    width: 50vw;
    margin: 10px;
}
.info-list{
	margin-top:25px;
}
.info-list li{
	margin-bottom:10px;
	font-size:12px;
}
.info-list li div{
	font-weight:bold;
	font-size:13px;
	margin-bottom:2px;
}
.el-timeline{
	font-size:12px;
}

.el-timeline-item__timestamp {
	color:#303133;
}
::-webkit-scrollbar,::-webkit-scrollbar,::-webkit-scrollbar {
    width: 8px;
}
::-webkit-scrollbar-thumb,::-webkit-scrollbar-thumb,::-webkit-scrollbar-thumb {
    border-radius: 5px;
    -webkit-box-shadow: inset 0 0 10px #999; 
}
.header-div{
	background: #DDD;
}
.header-tbl, .header-tbl th{
	border-collapse:collapse;
}
.list-tbl, .list-tbl td{
	border-collapse:collapse;
}
.header-tbl th{
	text-align:left;
}
.header-tbl th, #contentArea td{
	text-indent: 7px;
	height: 30px;
}
.header-tbl th:not(:last-child), #contentArea td:not(:last-child){
	border-right:1px solid #ccc !important;
}
.clusterize-scroll{
	max-height:calc(100vh - 200px)
}
#contentArea tr:nth-child(even){
	background:#f7f7f7;
}
#contentArea tr:nth-child(odd){
	background:#fff;
}
.task-no{
	width:8.5%;
}
.task-date{
	width:7.5%;
}
.task-donedate{
	width:7.5%;
}
.task-stage{
	width:4.5%;
}
.task-requestor{
	width:5%;
}
.task-confirm{
	width:4.5%;
} 
.task-due{
	width:7%;
}
.task-sphere{
	width:17%;
}
.task-sphere .ellipsis{
	overflow: hidden; 
  	text-overflow: ellipsis;
  	white-space: nowrap; 
  	width: 310px;/*310, 292*/
}
.task-sphere div:focus, .task-title div:focus{
	outline:none;
}
.task-title{
	width:23.5%;
}
.task-title .ellipsis{
	overflow: hidden; 
  	text-overflow: ellipsis;
  	white-space: nowrap; 
  	width: 420px; /*420, 390*/
  	cursor:default;
  	float:left;
}
.task-title .attach-icon{
	position:relative;
	top:4px;
	right:7px;
  	float:right; 
  	color:#409EFF;
}
.task-pinc{
	width:8%;
}
.task-request{
	width:5%;
}

.row:hover:not(.row-selected){
	background: #EFEFEF !important;
}
.row-selected {
	background: #E8F2FE !important;
}
@keyframes blinking {
	0%{
		background-color: none;
	}
	100%{
		<%if(!isChrome){%>
			background-color: lightyellow;
		<%}else{%>
			background-color: rgb(173,255,47,0.3);
		<%}%>
	}
}
.row-updated{
	animation: blinking 0.5s infinite;
}

@keyframes blinking-del {
	0%{
		background-color: none;
	}
	100%{
		background-color: #FFD8D8;
	}
}
.row-deleted{
	animation: blinking-del 0.7s infinite;
}
/*new, updated Task*/
.new-task::before{
	content:'\Anew';
	color: #f56c6c;
}
.updated-task::before{
	content:'\Aupdated';
	color: #f56c6c;
}
.progress-tbl{
	width: 100%;
}
.progress-tbl tr{
	border:1px solid #ddd;
}
.progress-tbl td:first-child{
	width:70px !important;
	background:#f1f1f1;
}
.progress-tbl td{
	padding: 7px;
}
.duedate-list{
	width:100%;
}
.duedate-list td{
	border:1px solid #ccc;
}
.duedate-list tr:nth-child(2) td{
	background: #E8F2FE !important;
}
.PopoverTable .csvTitle{
	font-weight:bold;
	font-size:0.83em
}
.PopoverTable td {
    width:360px;
    padding-top:10px;
}
.PopoverTable .columnTitle {
	font-size: 12px;
	height: 28px;
	line-height: 28px;
	width: 78px;
	background-color: #f5f7fa;
	color: #909399;
	position: relative;
	border: 1px solid #dcdfe6;
	border-radius: 4px 4px 0px 0px;
	border-bottom: none;
	text-align: center;
}
.columnList {
	border:1px solid #dcdfe6;
	border-radius: 0px 4px 4px 4px;
	padding:10px;
}
.el-rate{
	line-height:1.5;
}
</style>
</head>
<body>
<div id="app" v-cloak>
	<el-container>
		<el-side>
			<el-menu 
				default-active="2"
				mode = "vertical"
				:collapse="isCollapse" 
				background-color="#0F1D41"
				text-color="rgb(191, 203, 217)"
      			active-text-color="#fff"
				style="height:100%;">
			  <el-submenu index="1" disabled @click.native="isCollapse = !isCollapse">
			    <template slot="title">
			      <img class="logo" src="../images/logo.png"/>
			      <span class="title">KCPASS</span>
			    </template>			    
			  </el-submenu>
			  <el-tooltip :disabled="!isCollapse" class="item" effect="dark" content="요청업무 관리" placement="right" >
				  <el-menu-item index="2" @click="handlePage('list')">
				  	<i class="el-icon-edit-outline"></i>
				  	<span>요청업무 관리</span>
				  </el-menu-item>
			  </el-tooltip>
			  <!-- 
			  <el-tooltip :disabled="!isCollapse" class="item" effect="dark" content="SLA보고서 관리" placement="right" v-show="login.isLogin">
				  <el-menu-item index="3" @click="handlePage('report')">
				  	<i class="el-icon-news"></i>
				  	<span>SLA보고서 관리</span>
				  </el-menu-item>
			  </el-tooltip>
			   -->
			</el-menu>
		</el-side>
		<el-main>
			<el-header>
				<span class="sub-title" @click="handleRedirection('main')">서비스 요청 게시판</span>
				<div v-if="today.date" class="today">{{ today.date }} {{ today.time }}</div>
				<%if(!isLogin){%>
					<el-button size="mini" plain class="login" @click="go_login('login')">로그인</el-button>
				<%}else{%>
					<span class="username today"><%=loginName%> (<%=loginId%>)님 환영합니다.</span>
					<el-button-group class="login">
  						<el-button size="mini" plain @click="go_logout">로그아웃</el-button>
  						<el-button size="mini" plain @click="go_login('change')">비밀번호변경</el-button>
					</el-button-group>
				<%}%>
				<span class='el-icon-info useinfo' @click='howToUse'></span>
			</el-header>
			<div class="main-box">
				<div class="main-div" v-show="project.pageMode=='list'">
					<div class="ctrbox">
						<el-button size="mini" type="primary" :disabled = "onLoad" @click="regTask" class="square_btn">업무등록</el-button>
						<el-select 
							v-model="filter.dueSelect" 
							slot="prepend"								
							size="mini"
							class="filter-custom-select"
							disabled>
							<el-option label="처리기한" value="dueDate"></el-option>
						</el-select>
						<el-date-picker
						    v-model="filter.dueDate"
      						type="date"
      						format="yyyy-MM-dd"
      						:clearable="true"
						    size="mini"
      						placeholder="날짜 선택"
      						@change="handleDateChange"
      						class="filter-duedate">
						</el-date-picker>
						<el-select 
							v-model="filter.op" 
							slot="prepend"								
							size="mini"
							class="filter-select-op"
							@change="handleDateChange"
							@keydown.native="$event.preventDefault()">
							<el-option v-for="field in filter.opArr" :key="field.value" :label="field.label" :value="field.value"></el-option>
						</el-select>
						<el-select 
							v-model="filter.dateSelect" 
							slot="prepend"								
							size="mini"
							@change="handleDateChange"
							class="filter-date-select"
							@keydown.native="$event.preventDefault()">
							<el-option v-for="field in filter.dateField" :key="field.value" :label="field.label" :value="field.value"></el-option>
						</el-select>
						<el-date-picker
							v-show="filter.dateSelect=='date'"
						    v-model="filter.date"
						    :clearable="true"
						    :picker-options="pickerOptions"
						    size="mini"
						    type="daterange"
						    format="yyyy-MM-dd"
						    unlink-panels
						    start-placeholder="검색시작일"
						    end-placeholder="검색종료일"
						    :disabled="onLoad"
						    @change="handleDateChange"
						    class="filter-date">
						</el-date-picker>
						<el-date-picker
							v-show="filter.dateSelect=='requestDate'"
						    v-model="filter.requestDate"
						    :clearable="true"
						    :picker-options="pickerOptions"
						    size="mini"
						    type="daterange"
						    format="yyyy-MM-dd"
						    unlink-panels
						    start-placeholder="검색시작일"
						    end-placeholder="검색종료일"
						    :disabled="onLoad"
						    @change="handleDateChange"
						    class="filter-date">
						</el-date-picker>
						<span class="custom-border"></span>
						<el-select 
							v-model="filter.stepSelect" 
							slot="prepend"								
							size="mini"
							class="filter-custom-select"
							disabled>
							<el-option label="진행상황" value="steps"></el-option>
						</el-select>
						<el-select 
							v-model="filter.step" 
							multiple 
							placeholder="진행상황"
							size="mini"
							@change="handleFilterChange('step')"
							:disabled="onLoad"
							class="filter-select">
						    <el-option
						      v-for="(s,i) in statusArr.step" 
						      :label="s" 
						      :key="i"
						      :value="i">
						    </el-option>
						</el-select>
						<el-select 
							v-model="filter.select" 
							slot="prepend"
							placeholder="검색필드"								
							size="mini"
							class="filter-date-select filter-select-field"
							@keydown.native="$event.preventDefault()">
							<el-option v-for="field in filter.field" :key="field.value" :label="field.label" :value="field.value"></el-option>
						</el-select>
						<el-select v-show="filter.select=='sphere'" 
							v-model="filter.sphere" 
							multiple 
							placeholder="업무구분"
							size="mini"
							@change="handleFilterChange('sphere')"
						  	:disabled="onLoad"
							class="filter-sphere">
						    <el-option
						      v-for="item in sphereArr"
						      :key="item.sphereno"
						      :label="item.sphere"
						      :value="item.sphereno">
						    </el-option>
						</el-select>
						<span v-show="filter.select!='sphere'" class="clearable">
							<input
								v-model="filter.input"
								placeholder="검색필드 선택, 검색어를 입력하고 엔터를 눌러주세요..."
								:disabled="onLoad"
								class="filter-input"
								@keyup.13="handleFilterTextChange"
								@focus="dialogOpen=true"
								@blur="dialogOpen=false"/>
							<span class="clearable__clear" @click="resetSearch"></span>
						</span>
					</div>
					<div id="loading-box">
						<el-popover
						    placement="bottom-start"
						    width="240"
						    trigger="hover">
						    <div style="font-size:12px;">완료전인 업무는 검색결과와 상관없이 리스트에 출력합니다.</div>
						    <div class="loading-status data-total" slot="reference">
								<input
									type="checkbox" 
									v-model="filter.always" 
									:disabled="onLoad" 
									class="filter-checkbox"
									@change="handleFilterChange('')"/>&nbsp;완료전 업무
							</div>
						</el-popover>
						
						<div class="loading-status" style="margin-right:7px;">/</div>
						<div class="loading-status" v-html="loadingStatus"></div>
						<!-- <el-popover
							v-if="datacnt > 0 && !onLoad && login.isLogin"
						    placement="bottom-start"
						    width="300"
						    trigger="hover">
						    <div style="font-size:12px;">완료요청 이후 완료확인이 되지 않은 업무에 대해 완료확인 처리를 진행합니다.<br>(피드백: 시스템 메세지, 만족도: 5점)</div>
						    <span slot="reference" class='btn manual-confirm-btn' @click="manualConfirm">임의완료확인</span>
						</el-popover> -->
						<el-Popover
							v-if="datacnt > 0 && !onLoad && login.isLogin"
						    v-model="popoverVisible"
						    placement="right"
						    trigger="click"
						    @show="dialogOpen=true"
						    @hide="dialogOpen=false">
						    <table class="PopoverTable">
						      <tr>
						        <td style="padding-bottom:10px;">
						          <span class="csvTitle"><i class="el-icon-info"></i> 검색 결과를 CSV파일로 다운로드 합니다.</span>
						        </td>
						      </tr>
						       <tr>
						        <td>
						          <el-input ref="csvFileName" v-model="fileNameWithDate" size="mini" placeholder="파일명" clearable>
						            <template slot="prepend">파일명</template>
						            <template slot="append">.csv</template>
						          </el-input>
						        </td>
						      </tr>
						      <tr>
						        <td>
						          <div class="columnTitle">컬럼</div>
						          <el-row class="columnList">
						            <el-checkbox :indeterminate="isIndeterminate" v-model="checkAll" @change="handleCheckAllChange"><span style="font-size:12px;">전체</span></el-checkbox>
						            <el-checkbox-group v-model="checkedColumns" @change="handleCheckedColumnsChange">
						              <el-col v-for="column in columns.csv" :key="column.value" :span="12">
						                <el-checkbox :label="column.value">{{ column.label }}</el-checkbox>
						              </el-col>
						            </el-checkbox-group>
						          </el-row>
						        </td>
						      </tr>
						      <tr>
						        <td style="text-align:right;">
						          <el-button size="mini" type="text" @click="popoverVisible = false">취소</el-button>
						          <el-button size="mini" type="success" plain @click="export2csv">다운로드</el-button>
						        </td>
						      </tr>
						    </table>
						    <span slot="reference" class='btn excel-btn' @click="setPopoverData"><span class='excel-label'>CSV</span></span>
						</el-Popover>
						<div class='reload-box'>
							<i class="el-icon-refresh refresh-icon" @click="refreshData">
								<span class="super"></span>
							</i>
						</div>
					</div>
					<div class="clusterize">
						<div class="header-div">
							<table class='header-tbl' width="100%">
								<tr>
									<th :class='columns.cls[0]'>
										<label class="checkbox-label">{{ columns.list[0] }}</label>
										(&nbsp;<input type="checkbox" 
											v-model="filter.isUpdated" 
											:disabled="onLoad" 
											class="filter-checkbox"
											@change="handleFilterChange('')"/>&nbsp;updated&nbsp;)
									</th>
									<th :class='columns.cls[1]'>{{ columns.list[1] }}</th>
									<th :class='columns.cls[2]'>{{ columns.list[2] }}</th>
									<th :class='columns.cls[3]'>{{ columns.list[3] }}</th>
									<th :class='columns.cls[4]'>{{ columns.list[4] }}</th>
									<th :class='columns.cls[5]'>{{ columns.list[5] }}</th>
									<th :class='columns.cls[6]'>
										<label class="checkbox-label">{{ columns.list[6] }}</label>
										(&nbsp;<input type="checkbox" 
											v-model="filter.duePassed" 
											:disabled="onLoad" 
											class="filter-checkbox"
											@change="handleFilterChange('')"/>&nbsp;경과&nbsp;)
									</th>
									<th :class='columns.cls[7]'>{{ columns.list[7] }}</th>
									<th :class='columns.cls[8]'><div>{{ columns.list[8] }}</div></th>
									<th :class='columns.cls[9]'>
										<label class="checkbox-label">{{ columns.list[9] }}</label>
										<span v-if="login.isLogin">(&nbsp;<input type="checkbox"
											v-model="filter.pinc" 
											:disabled="onLoad" 
											class="filter-checkbox"
											@change="handleFilterChange('')"/>&nbsp;내 업무만&nbsp;)</span>
									</th>	
									<th :class='columns.cls[10]'>{{ columns.list[10] }}</th>
								</tr>
							</table>
						</div>
						<div id="scrollArea" class="list-div clusterize-scroll" @scroll = 'handleScroll($event)'>
						    <table class='list-tbl' width="100%">
								<tbody id="contentArea" class="clusterize-content">
									<tr class="clusterize-no-data">
										<td>Loading...</td>
									</tr>
								</tbody>
						    </table>
						</div>  
					</div>
				</div>
				<div class="main-div" v-show="project.pageMode=='report'">
					<div class="sub-title middle-title">
						<span>[ SLA보고서 ]</span>
						<span style="margin-left:10px;">
							<el-date-picker
								v-model="report.year"
								type="year"
								size="mini"
								placeholder="연도선택"
								style="width:110px;"
								@change = 'getReport(report.year)'>
						    </el-date-picker>
						</span>
						<span style="margin-left:7px;font-weight:normal;">
							<span v-for="i in statusArr.index">
								<span class="tag" :class="statusArr['color'][i]">{{ statusArr['step'][i] }}</span>
								<span v-if="i < 3" class="glyphicon glyphicon-arrow-right" style="margin-right:10px;color:#ccc;"></span>
							</span>
						</span>
					</div>
					<el-table 
						:data="report.data" 
						border 
						header-cell-style ="background:#DDD;color:#606266;font-weight:bold;"
						row-class-name="no-hover" 
						max-height="820" 
						style="width: 100%" 
						size="mini" 
						empty-text ="검색된 데이터가 없습니다...">
					    <el-table-column prop="dueRange" label="처리기한" align="center" width="70"></el-table-column>
					    <el-table-column label="점수" align="center" width="70">
					    	<template scope="scope">
								<span>{{scope.row.score}}점</span>
							</template>
					    </el-table-column>
					    <el-table-column label="이월 / 기한경과" align="center" width="302">
					    	<template scope="scope">
					    		<div v-if="scope.row.dueData.length > 0">
									<el-table
									:data="scope.row.dueData" 
									border 
									header-cell-style ="background:#f5f7fa;color:#606266;"
									row-class-name="no-hover"
									size="mini">
										<el-table-column label="업무번호" align="center" width="70">
											<template scope="scope2">
												<span :class="getStep(scope2.row.taskno)" class="tag report-tag" @click="getTask(scope2.row.taskno)">{{ scope2.row.taskno }}</span>
											</template>
										</el-table-column>
										<el-table-column label="구분" align="center" width="70">
											<template scope="scope">
												<span>{{scope.row.gubun}}</span>
											</template>
										</el-table-column>
										<el-table-column label="지연일수" align="center" width="70">
											<template scope="scope">
												<span>{{scope.row.days}}일</span>
											</template>
										</el-table-column>
										<el-table-column label="페널티" align="center" width="70">
											<template scope="scope">
												<span>-{{scope.row.penalty}}점</span>
											</template>
										</el-table-column>
									</el-table>
									<div style="font-size:11px;margin-bottom:-5px;">{{ scope.row.duePassedCnt}}건 / -{{ scope.row.penalty}}점</div>
								</div>
								<div v-else style="background:#fff;">-</div>
							</template>
					    </el-table-column>
					    <el-table-column label="적기처리율 (건수)" align="center" width="120">
							<template scope="scope">
								<span>{{scope.row.onTimeRatio}}% ({{scope.row.onTime}}건)</span>
							</template>
					    </el-table-column>
					    <el-table-column label="만족도평균 (총점)" align="center" width="120">
					    	<template scope="scope">
								<span>{{scope.row.rateAVG}}점 ({{scope.row.rate}}점)</span>
							</template>
					    </el-table-column>
					    <el-table-column label="전체" align="center" width="70">
					    	<template scope="scope">
								<span>{{scope.row.total}}건</span>
							</template>
					    </el-table-column>
					    <el-table-column label="완료" align="center" width="70">
					    	<template scope="scope">
								<span>{{scope.row.step3}}건</span>
							</template>
					    </el-table-column>
					    <el-table-column label="완료요청" align="center" width="70">
					    	<template scope="scope">
								<span>{{scope.row.step2}}건</span>
							</template>
					    </el-table-column>
					    <el-table-column label="진행중" align="center" width="70">
					    	<template scope="scope">
								<span>{{scope.row.step1}}건</span>
							</template>
					    </el-table-column>
					    <el-table-column label="접수" align="center" width="70">
					    	<template scope="scope">
								<span>{{scope.row.step0}}건</span>
							</template>
					    </el-table-column>
					    <el-table-column label="업무번호">
					    	<template scope="scope">
								<span :class="getStep(no)" class="tag report-tag" v-for="no in scope.row.taskNOs" @click="getTask(no)">{{ no }}</span>
							</template>
					    </el-table-column>
					    <el-table-column align="center" label="다운로드" width="100">
					    	<template scope="scope">
								<span class='btn' @click="reportDownLoad(scope.row.dueRange)">다운로드</span>
							</template>
					    </el-table-column>
					</el-table>
				</div>
			</div>
			<!-- task modal -->
			<el-dialog :visible.sync="taskDialogVisible" width="35%" top="60px" :close-on-click-modal="false" :close-on-press-escape ="false" @open = "beforeOpen" @opened = "setFocus('name')" @close="resetOption('taskForm')">
				<span slot="title" class="dialog-title"><span :class="{'glyphicon glyphicon-edit': taskMode == 'new', 'el-icon-edit': taskMode == 'edit'}"></span> {{ taskMode | modeText }} <span v-if="taskMode == 'edit'"> : {{ project.title }}-{{ newTask.taskno }}</span></span>
				<el-form 
					:model="newTask" 
					:rules="rules" 
					ref="taskForm" 
					label-width="120px" 
					size="mini" 
					id="taskForm"
					method="POST" 
					enctype="multipart/form-data">
					<div class="task-div">
					  <el-form-item label="성명" prop="name">
					  	<div style="position:relative">
					  		<span class="input-icon enter-icon"></span>
						    <input 
						    	ref="name" 
						    	v-model="newTask.name" 
						    	placeholder="성명을 입력해 주세요..." 
						    	@keyup.13 = "$refs.name.blur()"
						    	@blur = "getMemInfoByName(newTask.name)"
						    	class="custom-input"/>
					    </div>
					    <div class="memlist-box">
					    	<div v-for="(mem,i) in memInfoList.view" :key="mem" class="memlist" @click="selMem(i)">
								{{ mem }}
							</div>
						</div>
					  </el-form-item>
					  <el-form-item label="부서" prop="dept">
					    <input class="custom-input" v-model="newTask.dept">
					  </el-form-item>						
					  <el-form-item label="직급" prop="pos">
					    <input class="custom-input" v-model="newTask.pos"/>
					  </el-form-item>						
					  <el-form-item label="연락처" prop="tel">
					    <input class="custom-input" v-model="newTask.tel"/>
					  </el-form-item>
					  <el-form-item label="이메일" prop="email">
					    <input class="custom-input" v-model="newTask.email">
					  </el-form-item>
					  <el-form-item label="처리기한" prop="due">
					  	<el-date-picker
      						v-model="newTask.dueDate"
      						type="date"
      						format="yyyy-MM-dd"
      						:clearable="true"
						    :picker-options="pickerOptions2"
						    size="mini"
      						placeholder="날짜 선택"
      						@change="handleDue(newTask.dueDate)">
    					</el-date-picker>&nbsp;/&nbsp;<span>{{ newTask.due}}일</span>
					  </el-form-item>	
					  <el-form-item label="업무구분" prop="sphere">
					  	<div class="select-div">
						  	<el-select		
								v-model = "newTask.sphere"
							    multiple
							    filterable
							    default-first-option
							    placeholder="중복가능..."
							    no-match-text="일치하는 데이터가 없습니다."
							    class="select"
							    style="width:89%;">
							    <el-option
							      v-for="item in sphereArrFiltered"
							      :key="item.sphereno"
							      :label="item.sphere"
							      :value="item.sphereno">
							    </el-option>
							</el-select>
							<el-button size="mini" class="select-btn">확인</el-button>
						</div>
					  </el-form-item>
					  <el-form-item label="업무제목" prop="title">
					    <textarea ref="taskTitle" class="custom-textarea autosize" v-model="newTask.title" @focus="resize($event)" @keydown="resize($event)" @keyup="resize($event)" placeholder="업무 제목을 입력해주세요..."></textarea>
					  </el-form-item>
					  <el-form-item label="업무내용" prop="content">
					    <textarea ref="taskContent" class="custom-textarea autosize2" v-model="newTask.content" @focus="resize($event)" @keydown="resize($event)" @keyup="resize($event)" placeholder="업무 내용을 입력해주세요..."></textarea>
					  </el-form-item>
					  <el-form-item label="첨부파일" prop="fileList">
					  	<el-button size="mini" type="primary" @click="$refs.upload1.click()">파일선택</el-button>
					  	<input type="file" multiple="multiple" ref="upload1" id="fileList" class="upload" @change="uploadFieldChange($event, 'fileList')">
					  	<div class="filebox">
					  		<span v-if="taskMode=='new'" v-for="file in newTask.fileList" :key="file.name" class="tag files">{{ file.name + ' (' + Number((file.size / 1024 ).toFixed(1)) + 'KB)' }} <span class="el-icon-close file-del" @click="removeAttachment(file.name, '0', '0')"></span></span>
					  		<span v-if="taskMode=='edit'" v-for="file in newTask.fileList" :key="file.name" class="tag files">{{ file.name }} ({{ file.filesize }}KB) <span class="el-icon-close file-del" @click="removeAttachment(file.name, file.fileno, newTask.taskno)"></span></span>
					  	</div>
					  </el-form-item>
					  <el-form-item label="비밀번호" prop="pw">
					    <input class="custom-input pw-field" type="password" v-model="newTask.pw" @keypress = "limitInput($event)" @keyup="$refs.pwMatchInput.value='';confirmPw = false" placeholder="문서 비밀번호를 설정해 주세요...">
					    <input ref="pwMatchInput" :class="{'pw-notmatch': !confirmPw}" class="custom-input pw-field" type="password" @keypress = "limitInput($event)" @keyup = "pwMatch($event)" placeholder="비밀번호 확인...">
					  </el-form-item>
					</div>
				</el-form>
				<div slot="footer" class="dialog-footer">
					<el-button size="mini" type="text" @click="taskDialogVisible = false">취소</el-button>
					<el-button size="mini" type="primary" @click="submitTask('taskForm')">저장</el-button>
					<el-popover
					  v-if="taskMode == 'edit'"
					  placement="top"
					  width="230"
					  v-model="deleteTaskVisible">
					  <p>해당 업무를 삭제 하시겠습니까?</p>
					  <div style="text-align: right; margin: 0">
					    <el-button size="mini" type="text" @click="deleteTaskVisible = false">취소</el-button>
					    <el-button type="primary" size="mini" @click="deleteTaskVisible = false;deleteTask(newTask.taskno)">삭제</el-button>
					  </div>
					  <el-button slot="reference" size="mini" type="danger" plain>삭제</el-button>
					</el-popover>
				</div>
			</el-dialog>
			<!-- pinc dialog -->
			<el-dialog :visible.sync="pincDialogVisible" width="35%" top="60px" :close-on-click-modal="false" @open = "dialogOpen = true" :close-on-press-escape ="false" @close="resetOption('pincForm')">
				<span slot="title" class="dialog-title"><span class="glyphicon glyphicon-user"></span> 담당자 배정 : {{ project.title }}-{{ newTask.taskno }}</span>
		 		  <el-form :model="newTask" ref="pincForm" label-width="120px" size="mini">
						<el-form-item label="처리기한 :" prop="due">
							<el-date-picker 
								v-model="newTask.dueDate" 
								type="date" 
								format="yyyy-MM-dd" 
								:clearable="true" 
								:picker-options="pickerOptions2" 
								size="mini" 
								placeholder="날짜 선택"
								@change="handleDue(newTask.dueDate)">
							</el-date-picker>&nbsp;/&nbsp;<span>{{ newTask.due}}일</span>
						</el-form-item>
						<el-form-item label="업무구분 :" prop="sphere">
		 		  			<div class="select-div">
							  	<el-select		
									v-model = "newTask.sphere"
								    multiple
								    filterable
								    default-first-option
								    placeholder="중복가능..."
								    no-match-text="일치하는 데이터가 없습니다."
								    class="select"
								    style="width:89.1%;">
								    <el-option
								      v-for="item in sphereArrFiltered"
								      :key="item.sphereno"
								      :label="item.sphere"
								      :value="item.sphereno">
								    </el-option>
								</el-select>
								<el-button size="mini" class="select-btn">확인</el-button>
							</div>
					    </el-form-item>
						<el-form-item label="담당자 :" prop="pinc">
							<el-select		
								v-model = "newTask.pinc"
								style="width:220px;">
							    <el-option
							      v-for="item in pincArr"
							      :key="item.userno"
							      :label="item.name"
							      :value="item.userno">
							    </el-option>
							</el-select>
						</el-form-item>
		  		  </el-form>
			  	<div slot="footer" class="dialog-footer">
			  		<el-button size="mini" type="text" @click="pincDialogVisible = false">취소</el-button>
					<el-button size="mini" type="primary" @click="submitPinC()">저장</el-button>
				</div>
			</el-dialog>
			<!-- request dialog -->
			<el-dialog :visible.sync="requestDialogVisible" width="35%" top="60px" :close-on-click-modal="false" @open = "dialogOpen = true" @opened = "setFocus('request')" :close-on-press-escape ="false" @close="resetOption('requestForm')">
				<span slot="title" class="dialog-title"><span class="glyphicon glyphicon-share"></span> 완료요청 : {{ project.title }}-{{ newTask.taskno }}</span>
				<div class="task-div">
		 		  <el-form :model="newTask" :rules="requestRules" ref="requestForm" label-width="120px" size="mini">
					<el-form-item label="요청자 :" prop="requestPinC">
						<span>{{ newTask.requestPinC | pincText(pincArr) }}</span>
					</el-form-item>
					<el-form-item label="내용 :" prop="requestMsg">
						<textarea ref="request" class="custom-textarea autosize" v-model="newTask.requestMsg" @focus="resize($event)" @keydown="resize($event)" @keyup="resize($event)" placeholder="완료요청 내용을 입력해주세요..."></textarea>
					</el-form-item>
					<el-form-item label="첨부파일 :" prop="fileList">
					  	<el-button size="mini" type="primary" @click="$refs.upload2.click()">파일선택</el-button>
					  	<input type="file" multiple="multiple" ref="upload2" id="requestFileList" class="upload" @change="uploadFieldChange($event, 'requestFileList')">
					  	<div class="filebox">
					  		<span v-if="taskMode=='new'" v-for="file in newTask.fileList" :key="file.name" class="tag files">{{ file.name + ' (' + Number((file.size / 1024 ).toFixed(1)) + 'KB)' }} <span class="el-icon-close file-del" @click="removeAttachment(file.name, '0', '0')"></span></span>
					  		<span v-if="taskMode=='edit'" v-for="file in newTask.fileList" :key="file.name" class="tag files">{{ file.name }} ({{ file.filesize }}KB) <span class="el-icon-close file-del" @click="removeAttachment(file.name, file.fileno, newTask.taskno)"></span></span>
					  	</div>
					</el-form-item>
		  		  </el-form>
		  		</div>
			  	<div slot="footer" class="dialog-footer">
			  		<el-button size="mini" type="text" @click="requestDialogVisible = false">취소</el-button>
					<el-button size="mini" type="primary" @click="submitRequest('requestForm')">저장</el-button>
				</div>
			</el-dialog>
			<!-- confirm dialog -->
			<el-dialog :visible.sync="confirmDialogVisible" width="35%" top="60px" :close-on-click-modal="false" :close-on-press-escape ="false" @open = "dialogOpen = true" @opened="setFocus('confirm')" @close="resetOption('confirmForm')">
				<span slot="title" class="dialog-title"><span class="glyphicon glyphicon-check"></span> 완료확인: {{ project.title }}-{{ newTask.taskno }}</span>
		 		<div class="task-div">  
		 		  <el-form :model="newTask" :rules="confirmRules" ref="confirmForm" label-width="120px" size="mini">
					<el-form-item label="요청자 :" prop="requestPinC">
						<div>{{ newTask.requestPinC | pincText(pincArr) }}</div>
						<div v-html="getPinCInfo(newTask.requestPinC)"></div>
					</el-form-item>
					<el-form-item label="일시 :" prop="requestDate">
						<span>{{ newTask.requestDate }}</span>
					</el-form-item>
					<el-form-item label="내용  :" prop="requestMsg">
						<textarea ref="confirm" class="custom-textarea readonly autosize" v-model="newTask.requestMsg" @focus="resize($event)" readonly @keydown="$event.preventDefault()"></textarea>
					</el-form-item>
					<el-form-item v-if="newTask.requestFileList.length > 0" label="첨부파일 :" prop="fileList">
						<div>
							<span v-for="f in newTask.requestFileList" :key="f.fileno" class="tag files files-download" @click="filedown(f.name,f.filename,f.filepath)" style="margin:3px 5px 3px 0px;">{{ f.name }} ({{ f.filesize }}KB) <span class="el-icon-download"></span></span>
						</div>
					</el-form-item>
					<el-form-item label="피드백  :" prop="feedback">
						<textarea ref="confirm" class="custom-textarea autosize" v-model="newTask.feedback" @focus="resize($event)" @keydown="resize($event)" @keyup="resize($event)" placeholder="피드백..."></textarea>
					</el-form-item>
					<el-form-item label="만족도  :" prop="rate">
						<el-rate
						    v-model="newTask.rate"
						    :colors="rateColors"
						    :texts="rateTexts"
  							show-text>
						</el-rate>
					</el-form-item>
		  		  </el-form>
		  		</div>
			  	<div slot="footer" class="dialog-footer">			  		
			  		<el-checkbox v-model="newTask.isConfirm" label="완료되었음을 확인합니다."></el-checkbox>
			  		<el-button size="mini" type="text" @click="confirmDialogVisible = false">취소</el-button>
					<el-button size="mini" type="primary" @click="confirmTask('confirmForm')">저장</el-button>
				</div>
			</el-dialog>
			<!-- progress dialog -->
			<el-dialog :visible.sync="progressDialogVisible" width="35%" top="60px" @open = "dialogOpen = true" @opened = "taskMode='progress';setFocus('')" @close="resetOption('')">
				<span slot="title" class="dialog-title"><span class="el-icon-plus"></span> 상세보기: {{ project.title }}-{{ newTask.taskno }}</span>
		 		<div class="task-div">
			 		<el-timeline>
			 			<el-timeline-item v-if="newTask.step > 2" :timestamp="newTask.confirmDate" placement="top" type="success">
							<el-card>
								<h4>완료</h4>
								<p>
									<table class="progress-tbl">
										<tr>
											<td valign="top">피드백</td>
											<td>
												<textarea ref="feedback" class="custom-textarea readonly autosize" v-model="newTask.feedback" @focus="resize($event)" readonly @keydown="$event.preventDefault()"> </textarea>
											</td>
										</tr>
										<tr>
											<td valign="top">만족도</td>
											<td>
												<el-rate
												    v-model="newTask.rate"
												    disabled
												    :colors="rateColors"
												    :texts="rateTexts"
						  							show-text>
												</el-rate>
											</td>
										</tr>
									</table>
								</p>
							</el-card>
						</el-timeline-item>
						<el-timeline-item v-if="newTask.step > 1" :timestamp="newTask.requestDate" placement="top" type="danger">
							<el-card>
								<h4>완료요청 <span v-if="newTask.period">(소요시간: {{ newTask.period }}시간<span v-if="newTask.duePassed > 0">&nbsp;/&nbsp;<span class="time-passed">총 기한경과 일수: {{ newTask.duePassed }}일</span></span></span>)</span></h4>
								<p>
									<table class="progress-tbl">
										<tr>
											<td valign="top">내용</td>
											<td>
												<textarea ref="request" class="custom-textarea readonly autosize" v-model="newTask.requestMsg" @focus="resize($event)" readonly @keydown="$event.preventDefault()"></textarea>
											</td>
										</tr>
										<tr v-if="newTask.requestFileList.length > 0">
											<td valign="top">첨부파일</td>
											<td>
												<span v-for="f in newTask.requestFileList" :key="f.fileno" class="tag files files-download" @click="filedown(f.name,f.filename,f.filepath)" style="margin:3px 5px 3px 0px;">{{ f.name }} ({{ f.filesize }}KB) <span class="el-icon-download"></span></span>
											</td>
										</tr>
									</table>
								</p>
							</el-card>
						</el-timeline-item>
						<el-timeline-item v-if="newTask.step > 0" :timestamp="newTask.pincDate" placement="top" type="primary">
							<el-card>
								<h4>진행 중</h4>
								<p>
									<table class='progress-tbl duedate-list'>
										<colgroup>
											<col width="69%"/>
											<col width="31%"/>
										</colgroup>
										<tr>
											<td>담당자</td>
											<td style="background:#f1f1f1">배정일시</td>
										</tr>
										<tr v-for="(item,i) in pincObj" :key="i">
											<td style="background:#fff">{{ item.name }}<div v-html="getPinCInfo(item.pinc)"></div></td>
											<td style="background:#fff">{{ item.regdate }}</td>
										</tr>
									</table>
								</p>
							</el-card>
						</el-timeline-item>
						<el-timeline-item :timestamp="newTask.date" placement="top" type="warning">
							<el-card>
							  	<h4>접수</h4>
							  	<p>
									<table class="progress-tbl">
										<tr>
											<td valign="top">요청자</td>
											<td>{{ newTask.name }}
												<div v-html="getRequestorInfo(newTask.dept, newTask.pos, newTask.tel, newTask.email)"></div>
											</td>
										</tr>
										<tr>
											<td valign="top">처리기한</td>
											<td>
												<div v-if="newTask.duePassed > 0" class="time-passed" style="margin-bottom:7px;">
													<span class="el-icon-warning"></span> 총 기한경과 일수: {{ newTask.duePassed}}일
												</div>
												<table class='duedate-list'>
													<tr>
														<td>등록자</td>
														<td style="background:#f1f1f1">처리기한</td>
														<td style="background:#f1f1f1">등록일시</td>
													</tr>
													<tr v-for="(item,i) in dueDateObj" :key="i">
														<td style="background:#fff">{{ item.name }}</td>
														<td style="background:#fff">{{ item.due }}일 / {{ item.duedate }}</td>
														<td style="background:#fff">{{ item.regdate }}</td>
													</tr>
												</table>
											</td>
										</tr>
										<tr>
											<td valign="top">업무구분</td>
											<td>{{ sphereText2(newTask.sphere.join(",")) }}</td>
										</tr>
										<tr>
											<td valign="top">제목</td>
											<td>
												<textarea ref="title" class="custom-textarea readonly autosize" v-model="newTask.title" @focus="resize($event)" readonly @keydown="$event.preventDefault()"></textarea>
											</td>
										</tr>
										<tr>
											<td valign="top">내용</td>
											<td>
												<textarea ref="content" class="custom-textarea readonly autosize" v-model="newTask.content" @focus="resize($event)" readonly @keydown="$event.preventDefault()"></textarea>
											</td>
										</tr>
										<tr v-if="newTask.fileList.length > 0">
											<td valign="top">첨부파일</td>
											<td>
												<span v-for="f in newTask.fileList" :key="f.fileno" class="tag files files-download" @click="filedown(f.name,f.filename,f.filepath)" style="margin:3px 5px 3px 0px;">{{ f.name }} ({{ f.filesize }}KB) <span class="el-icon-download"></span></span>
											</td>
										</tr>
									</table>
								</p>
						</el-card>
					</el-timeline-item>
				</el-timeline> 
				</div> 	
				<div slot="footer" class="dialog-footer">
					<el-button size="mini" type="primary" @click="progressDialogVisible = false">확인</el-button>
				</div>
			</el-dialog>
			<!-- info dialog -->
			<el-dialog :visible.sync="infoDialogVisible" width="35%" top="60px" @open = "dialogOpen = true" @close="resetOption('')" class="info-dialog">
				<span slot="title" class="dialog-title"><span class="el-icon-info"></span> 도움말</span> 	
				<div>
					<h4 class="hr-line">업무절차 및 사용방법</h4>
					<el-steps :active="4" align-center style="margin-top:25px;">
					  <el-step title="접수" description="(수정, 삭제 가능)"></el-step>
					  <el-step title="진행" description="(담당자 배정)"></el-step>
					  <el-step title="완료요청" description="(담당자 요청)"></el-step>
					  <el-step title="완료확인" description="(요청자 확인)"></el-step>
					</el-steps>
					<ul class="info-list">
						<li><div>접수</div>업무등록 버튼 또는 단축키 'W'를 눌러 진행 가능합니다.</li>
						<li><div>업무 상세보기</div>리스트에서 각 업무를 선택 후 마우스 우 클릭 메뉴선택 또는 단축키 'R'을 누르시면 됩니다.</li>
						<li><div>수정 및 삭제</div>업무진행 이전에만 가능하며, 업무 선택 후 마우스 우 클릭 메뉴선택 또는 단축키 'E'를 누른 후 해당 업무의 비밀번호를 입력하여 진행가능 합니다.</li>
						<li><div>담당자 배정</div>담당자로 등록되어 있는 사용자에 한해 로그인 후, 담당자 배정 버튼을 눌러 진행 가능합니다.</li>
						<li><div>완료요청</div>담당자로 등록되어 있는 사용자에 한해 로그인 후, 완료요청 버튼을 눌러 진행 가능합니다.</li>
						<li><div>완료확인</div>완료확인 버튼을 눌러 진행 가능하며, 해당 업무의 비밀번호를 입력해야 합니다.</li>
						<!-- <li><div>임의완료확인</div>로그인 후 버튼이 노출되며, 완료요청된 업무에 대해 (피드백: 시스템 메세지, 만족도: 5점) 완료확인 처리 할 수 있습니다.</li> -->
						<li><div>CSV파일로 다운로드</div>로그인 후 버튼이 노출되며, 필터링 된 업무 리스트에 대해 CSV파일로 다운로드 가능합니다.</li>
						<li>
							<div>필터링 및 검색</div>
							처리기한, 등록일/완료(요청)일은 'or' 또는 'and' 조건으로 필터링이 가능하며 진행상황 및 검색은 'and' 조건으로 검색이 가능합니다.<br><br>
							- <strong>완료전 업무</strong> : 완료전 업무는 검색결과와 상관없이 항상 업무리스트에 출력합니다.<br>
							- <strong>updated</strong> : 신규 또는 업데이트된 업무만 출력<br>
							- <strong>경과</strong> : 처리기한 경과된 업무만 출력<br>
							- <strong>내 업무만</strong> : 로그인한 담당자 업무만 출력
						</li>
					</ul>
				</div>
				<div slot="footer" class="dialog-footer">
					<el-button size="mini" type="primary" @click="infoDialogVisible = false">확인</el-button>
				</div>
			</el-dialog>
		</el-main>
	</el-container>
</div>	
<form id="downform" method="post">
	<input type="hidden" value="" name="orgname" id="orgname"/>
	<input type="hidden" value="" name="filename" id="filename"/>
	<input type="hidden" value="" name="filepath" id="filepath"/>
	<input type="hidden" value="" name="csvfile" id="csvfile"/>
	<input type="hidden" value="" name="csvfileName" id="csvfileName"/>
</form>
<form id="loginform" method="post">
	<input type="hidden" value="" name="loginsts" id="loginsts"/>
	<input type="hidden" value="" name="loginid" id="loginid"/>
</form>
<script>
//한글
ELEMENT.locale(ELEMENT.lang.ko);
//전역변수
var ctx = "${pageContext.request.contextPath}";
const validateTitle = function validateTitle(rule, value, callback){
	if(value.trim().length == 0){
		callback(new Error());
	}else{
		callback();
	}
}
const validateContent = function validateContent(rule, value, callback){
	if(value.trim().length == 0){
		callback(new Error());
	}else{
		callback();
	}
}	
const validateTel = function validateTel(rule, value, callback){
	if (value.length) {
		var pattern = new RegExp(/^(\d+-?)+\d+$/);
		if(!pattern.test(value)){
			callback(new Error());
		}else{
			callback();	
		}
	} else {
		callback();
	}
}
const validateEmail = function validateEmail(rule, value, callback){
	if (value.length) {
		var pattern = new RegExp(/[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?/);
		if(!pattern.test(value)){
			callback(new Error());
		}else{
			callback();
		}
	} else {
			callback();
	}
}
const validateConfirm = function validateConfirm(rule, value, callback){
	if(!value){
		callback(new Error());
	}else{
		callback();
	}
}
const validateRequestMsg = function validateRequestMsg(rule, value, callback){
	if(value.trim().length == 0){
		callback(new Error());
	}else{
		callback();
	}
}	
const validateFeedback = function validateFeedback(rule, value, callback){
	if(value.trim().length == 0){
		callback(new Error());
	}else{
		callback();
	}
}
const validateRate = function validateRate(rule, value, callback){
	if(value == 0){
		callback(new Error());
	}else{
		callback();
	}
}
var app = new Vue({
	el: "#app",
	data:{
		project:{
			"title": "업무",
			"pageMode": 'list'
		},	
		statusArr:{
			"step":['접수', '진행 중', '완료요청', '완료'],
			"color":['brown','blue','red','green'],
			"index":[0,1,2,3]
		},
		rateColors: ['#99A9BF', '#F7BA2A', '#FF9900'],
		rateTexts: ['1점', '2점', '3점', '4점', '5점'],
		login:{
			"userno": <%=userno%>,				
			"isLogin": <%=isLogin%>,
			"loginid": "<%=loginId%>"
		},
		newTask: {
			"step": "0",
			"taskno": "",
			"userno": "",
			"name":"",
			"dept":"",
			"pos":"",
			"tel":"",
			"email":"",
			"date": "",
			"title": "",
			"msgno": "",
			"content": "",
			"due": "1",
			"sphere": [],
			"pinc": [],
			"pincDate":"",
			"fileList": [],
			"requestFileList": [],
			"pw": "",
			"requestPinC": "",
			"requestDate": "",
			"confirmDate": "",
			"isConfirm": 0,
			"requestMsg": "",
			"feedback":"",
			"dueDate":"",
			"duePassed":0,
			"rate":null,
			"period":""
		},			 
		rules: {
			name: [
				{ required: true, message: "성명을 입력해 주세요.", trigger: "blur" }
			],
			title: [
			  	{ required: true, message: "업무 제목을 입력해 주세요.", validator: validateTitle, trigger: "blur" }
			],
			tel: [
				{ message: "전화번호 형식이 유효하지 않습니다.",  validator: validateTel, trigger: "blur"}
			],
			email: [
				{ message: "메일 형식이 유효하지 않습니다.",  validator: validateEmail, trigger: "blur"}
			],
			content: [
			  	{ required: true, message: "업무 내용을 입력해 주세요.", validator: validateContent, trigger: "blur" }
			],
			due: [
				{ required: true, message: "처리기한을 입력해 주세요." }
			],
			dueDate: [
				{ required: true, message: "처리기한을 입력해 주세요." }
			],
			sphere: [
				{ type: "array", required: true, message: "업무구분은 반드시 한개 이상 선택하셔야 합니다.", trigger: "blur" }
			],
			pw: [
				{ required: true, message: "문서 비밀번호를 설정해 주세요. 수정, 삭제, 완료시 사용됩니다.", trigger: "blur" }
			]
	    },
	    requestRules: {
	    	requestMsg:[
				{ required: true, message: "완료요청 내용을 입력해 주세요.", validator: validateRequestMsg, trigger: "blur" }
			]
	    },
	    confirmRules: {
	    	feedback:[
				{ required: true, message: "피드백을 입력해 주세요.", validator: validateFeedback, trigger: "blur" }
			],
			rate:[
				{ required: true, message: "만족도를 선택해 주세요.", validator: validateRate, trigger: "blur" }
			]
	    },
		sphereArr: [],
		sphereArrFiltered: [],
	    pincArr:[],
		sideBarClose: true,
		loadingStatus: "",
		datacnt: 0,
		curStatus: "",
		taskMode: "load",
		dialogOpen: false,
		taskDialogVisible: false,
		deleteTaskVisible: false,
		requestDialogVisible: false,
		pincDialogVisible: false,
		confirmDialogVisible: false,
		progressDialogVisible: false,
		msgDuration: 1000,
		msgPosition: 'top-right',
		msgOffset:125,
		isCollapse: true,
		today: {"date":"", "time": ""},
		clock: null,
		memInfoList: {
			view: [],
			data: []
		},
		upload:{
			data: new FormData()
		},
		confirmMem: false,
		confirmPw: false,
		filter: {
			date:[moment().startOf("month"), moment().endOf("month")],
			requestDate:[moment().startOf("month"), moment().endOf("month")],
			dueDate:moment().endOf("month"),
			opArr:[
				{label:"or", value:"or"},
				{label:"and", value:"and"}
			],
			op:"and",
			step:[0,1,2,3],
			pinc:false,
			field:[
				{label:"업무번호", value:"taskno"},
				{label:"요청자", value:"requestor"},
				{label:"업무구분", value:"sphere"},
				{label:"제목", value:"title"},
				{label:"담당자", value:"pinc"}
			],
			select:"",
			dateField:[
				{label:"등록일", value:"date"},
				{label:"완료(요청)일", value:"requestDate"}
			],
			dateSelect:"date",
			dueSelect:"dueDate",
			stepSelect:"steps",
			input:"",
			text:"",
			sphere:[1,2,3,4,5,6,7,8,9,99],
			duePassed: false,
			isUpdated: false,
			always: true
		},
		selectedTaskNo:"",
		closeOnSave: false,
		onLoad: false,
		pickerOptions: {
			shortcuts: [
			  {
			    text: '오늘',
			    onClick:function(picker) {
					const start = moment().startOf('day');
					const end = moment().endOf('day');
					picker.$emit('pick', [start, end])
			    }
			  },{
			    text: '이번주',
			    onClick:function(picker) {
					var start = moment().startOf("week");
					var end = moment().endOf("week");		
					picker.$emit('pick', [start, end])
			    }
			  }, {
			    text: '이번달',
			    onClick:function(picker) {
			    	const start = moment().startOf('month');
			    	const end   = moment().endOf('month');
			      	picker.$emit('pick', [start, end])
			    }
			  }, {
			    text: '올해',
			    onClick:function(picker) {
			    	const start = moment().startOf('year');
			    	const end   = moment().endOf('year');
			      	picker.$emit('pick', [start, end])
			    }
			  }
			]
		},
		pickerOptions2: {
			disabledDate:function(date) {
				day = moment(date).day();
				var isWeekend = (day === 6) || (day === 0);
		    	return isWeekend || (date < new Date())
		    }
		},
		clusterize: null,
		popoverVisible: false,
	    fileNameWithDate: '',
	    columns: {
	    	list:["업무번호","등록일시","완료(요청)일시","진행상태","요청자","완료확인","처리기한","업무구분","제목","담당자","완료요청"],
	    	cls:["task-no","task-date","task-donedate","task-stage","task-requestor","task-confirm","task-due","task-sphere","task-title","task-pinc","task-request"],
	    	csv:[
		    		{label:"업무번호", value:0},
		    		{label:"등록일시", value:1},
		    		{label:"진행상태", value:2},
		    		{label:"요청자", value:3},
		    		{label:"부서", value:4},
		    		{label:"직급", value:5},
		    		{label:"연락처", value:6},
		    		{label:"이메일", value:7},
		    		{label:"처리기한 (날짜)", value:8},
		    		{label:"처리기한 (일수)", value:9},
		    		{label:"총 기한경과 (일수)", value:10},
		    		{label:"업무구분", value:11},
		    		{label:"제목", value:12},
		    		{label:"업무내용", value:13},
		    		{label:"업무 첨부파일", value:14},
		    		{label:"담당자", value:15},
		    		{label:"담당자 지정일시", value:16},
		    		{label:"완료요청자", value:17},
		    		{label:"완료요청일시", value:18},
		    		{label:"완료요청내용", value:19},
		    		{label:"완료요청 첨부파일", value:20},
		    		{label:"완료일시", value:21},
		    		{label:"피드백", value:22},
		    		{label:"만족도", value:23},
		    		{label:"업무처리소요시간", value:24}
	    		]
	    },
	    checkedColumns: [],
	    checkAll: true,
	    isIndeterminate: false,
	    dueDateObj:{},
	    pincObj:{},
	    infoDialogVisible: false,
	    report:{
	    	year:moment().endOf("year"),
	    	data:[]
	    },
	    savePressed: false
	},
	filters: {
		modeText: function(value){
			return value == 'new' ? "등록":"수정"
		},
		pincText: function(value, options){
			if(value) var find = _.find(options, {"userno":parseInt(value)}); 
			return find ? find.name : null;
		}
	},
	created:function(){
		this.init();
	},
	watch:{
		'filter.date': function(date){
			if(date==null){
				this.filter.date = [moment().startOf("month"), moment().endOf("month")]; 	
			}
		},
		'filter.requestDate': function(date){
			if(date==null){
				this.filter.requestDate = [moment().startOf("month"), moment().endOf("month")]; 	
			}
		},
		'filter.dueDate': function(date){
			if(date==null){
				this.filter.dueDate = moment().endOf("month"); 	
			}
		},
		'report.year': function(year){
			if(year==null){
				this.report.year = moment().endOf("year");
				this.getReport(this.report.year);
			}
		},
		'isCollapse': function(val){
			if(val){
				$(".task-sphere .ellipsis").css("width","310px");
				$(".task-title .ellipsis").css("width","420px");
				$(".filter-input").css("width","550px");
				$(".filter-sphere").css("width","550px");
			}else{
				$(".task-sphere .ellipsis").css("width","292px");
				$(".task-title .ellipsis").css("width","395px");
				$(".filter-input").css("width","435px");
				$(".filter-sphere").css("width","435px");
			}
		}
	},
	mounted: function(){
		const vm = this;
		vm.loadData();
		window.addEventListener("keydown", function(e){
			if(vm.dialogOpen || vm.onLoad || vm.project.pageMode == "report") return;
			if(e.which == 69 || e.which == 82){
				if(vm.selectedTaskNo != ""){
					switch(e.which) {			
						case 69:
							vm.editTask();
							break;
						case 82:
							vm.showProgress();							
							break;	
  					}	
				}else{
					vm.dialogOpen = true;
					vm.$notify({ 
						title: 'Warning', 
						message: '선택하신 업무가 없습니다.', 
						type: 'warning',
						duration: vm.msgDuration,
						position: vm.msgPosition,
						offset: vm.msgOffset,
						onClose:function(){
							vm.dialogOpen = false;
						}
					});
					return;
				}	
			}else if(e.which == 87){
				vm.regTask();
			}
		});
	},
	methods: {
		init: function(){
			this.getSphere();
			this.getPinC();
			if(this.clock) clearInterval(this.clock);
			this.clock = setInterval(this.updateTime, 1000);
		},
		getMemInfoByName: function(name){	
			const vm = this;			
			vm.memInfoList.view = [];
			vm.memInfoList.data = [];
			vm.newTask.name = "";
			vm.newTask.dept = "";
			vm.newTask.pos = "";
			vm.newTask.tel = "";
			vm.newTask.email = "";
			vm.newTask.name = name.trim();
			console.log(vm.newTask.name)
			if(vm.newTask.name == "") return;
			$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"mem", "name":vm.newTask.name, "wh":""},
				success:function(obj){
					console.log(obj)
					var len = obj.length;				
					if(len>0){
						for(var j in obj){
							var dept1 = obj[j].dept1;
							var dept2 = obj[j].dept2;
							var dept3 = obj[j].dept3;
							var dept = "";
							var deli = " ";
							if(dept1!=""){
								dept = dept1;
								if(dept2!=""){
									dept+=deli+dept2;
									if(dept3!=""){
										dept+=deli+dept3;
									}
								}else{
									if(dept3!=""){
										dept+=deli+dept3;
									}
								}
							}else{
								if(dept2!=""){
									dept = dept2;
									if(dept3!=""){
										dept+=deli+dept3;
									}
								}else{
									if(dept3!=""){
										dept=dept3;
									}
								}
							}
							if (len==1){		
								vm.newTask.userno = obj[j].userno;
								vm.newTask.name = obj[j].name;
								vm.newTask.dept = dept;
								vm.newTask.pos = obj[j].pos_name;
								vm.newTask.tel = obj[j].phone;
								vm.newTask.email = obj[j].e_mail;
							}else if(len>1){
								vm.memInfoList.view.push(obj[j].name+" ("+dept+" "+obj[j].pos_name+")");
								vm.memInfoList.data.push({userno: obj[j].userno, name: obj[j].name, dept: dept, pos: obj[j].pos_name, tel: obj[j].phone, email: obj[j].e_mail});
							}
						}
						vm.confirmMem = true;
					}else{
						vm.$notify({ 
							title: 'Warning', 
							message: '등록된 직원이 아닙니다.', 
							type: 'warning',
							duration: vm.msgDuration,
							position: vm.msgPosition,
							offset: vm.msgOffset
						});
						vm.$refs.name.focus();
						vm.confirmMem = false;
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
		},	
		getPinC: function(){
			const vm = this;
			$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"mem", "name":"", "wh":"pinc"},
				success:function(obj){
					console.log(obj)
					vm.pincArr = obj;
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
		},
		getSphere: function(){
			const vm = this;
			$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"sphere"},
				success:function(obj){
					vm.sphereArr = obj;
					vm.sphereArrFiltered = _.filter(obj, ['delflag', 'N']);
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
		},
		getDueDate: function(taskno){
			const vm = this;
			$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"duedate", "taskno":taskno},
				success:function(obj){
					vm.dueDateObj = obj;
					vm.pincObj = _.filter(obj,function(o){
						return o.type == 'C';
					})
				},
				error:function(request,status,error){		
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
		},
		sphereText: function(value){
			var ret = "";
			if(value){
				var temp = value.split(",");
				for(var i=0;i<temp.length;i++){
					var find = _.find(this.sphereArr, {"sphereno":parseInt(temp[i])});
					if(find){
						ret+="<span class='tag gray'>"+find.sphere+"</span>";
					}
				}
			}
			return ret ? ret : "";
		},
		sphereText2: function(value){
			var ret = [];
			if(value){
				var temp = value.split(",");
				for(var i=0;i<temp.length;i++){
					var find = _.find(this.sphereArr, {"sphereno":parseInt(temp[i])});
					if(find) ret.push(find.sphere);
				}
			}
			return ret ? ret.join(", ") : "";
		},
		statusText: function(value){
			if(value) var find = this.statusArr['step'][value]; 
			return find ? find : null;
		},
		pincText2: function(value){
			if(value) var find = _.find(this.pincArr, {"userno":parseInt(value)}); 
			return find ? find.name : null;
		},
		getContents: function(type, taskno){
			const vm = this;
			$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"content", "taskno":taskno, "type": type},
				async:false,
				success:function(obj){
					if(obj.length > 0){
						switch (type){
							case "T":
								vm.newTask.content = obj[0].task;
								vm.newTask.msgno = obj[0].msgno;
								vm.newTask.fileList = vm.getFileList(vm.newTask.msgno);
								break;
							case "R":
								vm.newTask.requestMsg = obj[0].task;
								vm.newTask.msgno = obj[0].msgno;
								vm.newTask.requestFileList = vm.getFileList(vm.newTask.msgno);
								break;
							case "F":
								vm.newTask.feedback = obj[0].task;
								break;
						}
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
		},
		getFileList: function(msgno){
			const vm = this;
			var ret = null;
			$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"contentfiles", "msgno":msgno},
				async:false,
				success:function(obj){
					ret = obj;
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
			return ret;
		},
		checkPwFromDb: function(taskno, pw){
			var ret = false;
			const vm = this;
			$.ajax({
				url:ctx+"/checkData",
				type:"post",
				dataType:"text",
				data:{"sts":"taskpw", "taskno":taskno, "pw":pw},		
				async: false,
				cache: false,
				success:function(msg){
					if(msg==="success"){
						ret = true;
					}else{
						ret = false;
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
			return ret;
		},	
		setPinC: function(taskno){
			if(!this.login.isLogin){
				this.go_login('login');
				return;
			}
			if(this.onLoad) return;
			if(!this.checkTaskStep("pinc")) return;
			this.newTask.pinc = this.login.userno;
			this.pincDialogVisible = true;
		},
		submitPinC: function(){
			const vm = this;
			if(vm.savePressed) return;
			vm.savePressed = true;
			$.ajax({
				url:ctx+"/updateData",
				type:"post",
				dataType:"text",
				data:{
					"sts":"setpinc", 
					"taskno":vm.newTask.taskno, 
					"due": vm.newTask.due, 
					"dueDate": moment(vm.newTask.dueDate).endOf("day").format("YYYY-MM-DD HH:mm:ss"), 
					"pinc": vm.newTask.pinc,
					"sphere": _.sortBy(vm.newTask.sphere.slice(0)).join(",")
				},
				async: false,
				cache: false,
				success:function(ret){
					if(ret=="success"){
	                	vm.selectedTaskNo = vm.newTask.taskno;
						vm.taskMode = "edit";
						var tempStep = vm.filter.step.slice(0);
	                	tempStep.push(1);
	                	vm.filter.step =_.uniqBy(_.sortBy(tempStep));
	                	var tempSphere = vm.filter.sphere.slice(0);
	                	tempSphere = _.concat(tempSphere, vm.newTask.sphere.slice(0));
	                	vm.filter.sphere = _.uniqBy(_.sortBy(tempSphere));
	                	vm.closeOnSave = true;
	                	vm.pincDialogVisible = false;
						vm.$notify({ 
	    					title: 'Success', 
	    					message: '저장되었습니다.', 
	    					type: 'success',
	    					duration: vm.msgDuration,
	    					position: vm.msgPosition,
							offset: vm.msgOffset,
	    					onClose: function(){
			                	vm.loadData();
			                	vm.dialogOpen = false;
			                	vm.closeOnSave = false;
			                	vm.savePressed = false;
	    					}
	    				});
					}else{
						vm.sessionInvalid();
						vm.savePressed = false;
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
					vm.savePressed = false;
				}
			});
		},
		resetPinC: function(taskno){
			const vm = this;
			if(vm.onLoad) return;
			if(!vm.checkTaskStep("reset")) return;
			if(vm.savePressed) return;
			vm.dialogOpen = true;
			vm.$confirm('담당자 배정을 취소하고 업무를 접수상태로 되돌리시겠습니까?', 'Warning', {
		        confirmButtonText: '확인',
		        cancelButtonText: '취소',
		        type: 'warning'
		      }).then(function(){
		    	  vm.savePressed = true;
		    	  $.ajax({
						url:ctx+"/updateData",
						type:"post",
						dataType:"text",
						data:{"sts":"resetpinc", "taskno":taskno},		
						async: false,
						cache: false,
						success:function(ret){
							if(ret=="success"){
								vm.$notify({ 
									title: 'Success', 
									message: '저장되었습니다.', 
									type: 'success',
									duration: vm.msgDuration,
									position: vm.msgPosition,
									offset: vm.msgOffset,
									onClose: function(){
										vm.taskMode = "edit";
										var tempStep = vm.filter.step.slice(0);
					                	tempStep.push(0);
					                	vm.filter.step =_.uniqBy(_.sortBy(tempStep));
					                	if(vm.filter.pinc || (vm.filter.select=='pinc' && vm.filter.text !='')){
					                		vm.selectedTaskNo = "";
					                		$(".row").removeClass("row-selected");
					                	}
										vm.loadData();	
										vm.dialogOpen = false;
										vm.savePressed = false;
									}
								});
							}else{
								vm.sessionInvalid();
								vm.savePressed = false;
							}
						},
						error:function(request,status,error){						
							console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
							vm.savePressed = false;
						}
					  });
		      }).catch(function(){
					vm.dialogOpen = false;
					vm.savePressed = false;
		      });
		},
		setRequest: function(sts){
			if(!this.login.isLogin){
				this.go_login('login');
				return;
			}
			if(!this.checkTaskStep("1")) return;
			this.taskMode = sts;
			this.newTask.requestPinC = this.newTask.pinc;
			this.requestDialogVisible = true;
		},
		setConfirm: function(){
			if(!this.checkTaskStep("2")) return;
			this.getContents('R', this.newTask.taskno);
			this.checkPw('confirm');
		},
		manualConfirm: function(){
			const vm = this;   
			vm.dialogOpen = true;
			vm.$prompt('* 완료요청된 업무만 가능합니다', '임의 완료확인 처리', {
				closeOnClickModal: false,
				closeOnHashChange: false,
				confirmButtonText: '확인',
				cancelButtonText: '취소',
				inputPlaceholder: '완료할 업무번호를 입력해주세요...',
				beforeClose: function(action, instance, done){
		            if (action === 'confirm') {							
						if(instance.inputValue){
							done();
						}else{
							vm.$notify({ 
								title: 'Warning', 
								message: '문서번호를 입력해 주세요', 
								type: 'warning',
								duration: vm.msgDuration,
								position: vm.msgPosition,
								offset: vm.msgOffset
							});
						}
		            }else{
		            	done();
		            } 
		        }
	        }).then(function(_ref){
	        	var value = _ref.value.trim();
	        	$.ajax({
					url:ctx+"/checkData",
					type:"post",
					async: false,
					dataType:"text",
					data:{"sts":"manualConfirm", "taskno":value},
					success:function(ret){
						if(ret=="success"){
							vm.$notify({ 
								title: 'Success', 
								message: '완료처리 되었습니다.', 
								type: 'success',
								duration: vm.msgDuration,
								position: vm.msgPosition,
								offset: vm.msgOffset,
								onClose: function(){
				                	vm.dialogOpen = false;
				                	vm.closeOnSave = false;
				                	vm.loadData();
								}
							});	
						}else{
							vm.$notify({ 
								title: 'Warning', 
								message: '완료요청된 업무만 임의 완료확인 처리가 가능합니다.', 
								type: 'warning',
								duration: vm.msgDuration,
								position: vm.msgPosition,
								offset: vm.msgOffset,
								onClose: function(){
				                	vm.dialogOpen = false;
				                	vm.closeOnSave = false;
				                	vm.loadData();
								}
							});	
						}
					},
					error:function(request,status,error){						
						console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
					}
				});
	        }).catch(function(){
	        	vm.dialogOpen = false;
	        });
        },
		checkPw: function(sts){
			const vm = this;
			vm.dialogOpen = true;
			vm.$prompt('비밀번호 확인', '업무 - '+ vm.newTask.taskno, {
				closeOnClickModal: false,
				closeOnHashChange: false,
				inputType: "password",
				confirmButtonText: '확인',
				cancelButtonText: '취소',
				inputPlaceholder: '문서 비밀번호를 입력해주세요...',
				beforeClose: function(action, instance, done){
		            if (action === 'confirm') {							
						if(vm.checkPwFromDb(vm.newTask.taskno, instance.inputValue)){
							done();
						}else{
							vm.$notify({ 
								title: 'Error', 
								message: '비밀번호가 일치하지 않습니다.', 
								type: 'error',
								duration: vm.msgDuration,
								position: vm.msgPosition,
								offset: vm.msgOffset
							});
						}
		            }else{
		            	done();
		            } 
		        }
	        }).then(function(_ref){
	        	var value = _ref.value;
	       		vm.$notify({ 
	       			title: 'Success', 
	       			message: '확인되었습니다.', 
	       			type: 'success',
	       			duration: vm.msgDuration,
					position: vm.msgPosition,
					offset: vm.msgOffset,
	       			onClose: function(){
	       				switch(sts) {
							case "edit":
								vm.taskMode = "edit";
								vm.confirmMem = true;
								vm.taskDialogVisible = true;
								break;
							case "confirm":
								vm.taskMode = "new";
								vm.confirmDialogVisible = true;
								break;
		  				}	
	       			}
	       		});
	        }).catch(function(){
	        	vm.dialogOpen = false;
	        });
		},
		resetOption: function(form){
			if(form !=""){
				this.$refs[form].resetFields();	
			}
			if(form == "taskForm"){
				this.$refs.pwMatchInput.value='';
			}
			if(!this.closeOnSave) this.dialogOpen = false;	
		},
		resetTask: function(){
			this.newTask = {
				"step": "0",
				"taskno": "",
				"userno": "",
				"name":"",
				"dept":"",
				"pos":"",
				"tel":"",
				"email":"",
				"date": "",
				"title": "",
				"msgno": "",
				"content": "",
				"due": "1",
				"sphere": [],
				"pinc": [],
				"pincDate":"",
				"fileList": [],
				"requestFileList": [],
				"pw": "",
				"requestPinC": "",
				"requestDate": "",
				"confirmDate": "",
				"isConfirm": 0,
				"requestMsg": "",
				"feedback":"",
				"dueDate":moment().add('days',1),
				"duePassed": 0,
				"rate": null,
				"period":""
			};
			this.upload.data = new FormData();
			this.newTask.msgno = "";
            this.newTask.content = "";
            this.newTask.requestPinC = "";
            this.newTask.fileList = [];
            this.confirmMem = false;
			this.confirmPw = false;
			this.memInfoList.data = [];
			this.memInfoList.view = [];
			$(".row").removeClass("row-selected row-updated");
		},
		regTask: function(){
			this.taskMode = 'new';
			this.selectedTaskNo = "";
			this.taskDialogVisible = true;
		},
		beforeOpen: function(){
			if(this.taskMode == 'new') this.resetTask();
			this.dialogOpen = true;
			var temp = "시스템(프로그램) 수정(개발) 요청\n\n";
			temp+="수정/요청 프로그램:\n";
			temp+="요청 목적(사유):\n";
			temp+="요청 내용(최대한 자세하게):\n";
			if(this.newTask.content=="") this.newTask.content = temp;
		},
		setFocus: function(ref){
			if(this.taskMode =="new" || this.taskMode == "edit"){
				if(this.taskMode == "new"){
					this.$refs[ref].focus();	
				}else{
					this.$refs["taskTitle"].focus();
					this.$refs["taskContent"].focus();	
				}	
			}else if(this.taskMode == "progress"){
				this.$refs["content"].focus();
				this.$refs["title"].focus();
				this.$refs["title"].blur();
				if(this.newTask.step == 2){
					this.$refs["request"].focus();
				}else if(this.newTask.step == 3){
					this.$refs["request"].focus();
					this.$refs["feedback"].focus();
					this.$refs["feedback"].blur();
				}
			}else{
				this.$refs[ref].focus();
			}
			$(".task-div").scrollTop(0);
		},
		submitTask: function(form){
			const vm = this;
			if(vm.savePressed) return;
			if(vm.memInfoList.view.length > 0){
				vm.$notify({ 
					title: 'Warning', 
					message: '직원을 선택해 주세요.', 
					type: 'warning',
					duration: vm.msgDuration,
					position: vm.msgPosition,
					offset: vm.msgOffset
				});
				vm.$refs.name.focus();
				return;
			}
			this.$refs[form].validate(function(valid){
				if (valid) {
					if(!vm.confirmMem) return;
					if(!vm.confirmPw){
						vm.$refs[form].fields[10].validateState = 'error'
				        vm.$refs[form].fields[10].validateMessage = '비밀번호를 확인해주세요.'
				        vm.$refs.pwMatchInput.focus();
						return;
					}else{
						vm.$refs[form].fields[10].validateState = null
				        vm.$refs[form].fields[10].validateMessage = null
					}
					vm.prepareFields(vm.taskMode);
		            var config = {
		                headers: { 'Content-Type': 'multipart/form-data' }
		            };
		            vm.savePressed = true;
		            axios({
						method: 'post',
						url: ctx+'/saveTaskList',
						data: vm.upload.data,
						config: config
					 }).then(function (response) {
		                if (response) {
		                	if(vm.taskMode=='new'){
		                		vm.filter.date = null;
		                		vm.filter.requestDate = null;
		                		vm.filter.dueDate = null;
		                		vm.filter.op = "and";
			                	vm.filter.pinc = false;
		                	}
		                	
		                	vm.filter.duePassed = false;
		                	vm.filter.select = "";
		                	vm.filter.input = "";
		                	vm.filter.text = "";
		                	
		                	vm.selectedTaskNo = response.data;
		                	var tempStep = vm.filter.step.slice(0);
		                	tempStep.push(parseInt(vm.newTask.step));
		                	vm.filter.step =_.uniqBy(_.sortBy(tempStep));
		                	var tempSphere = vm.filter.sphere.slice(0);
		                	tempSphere = _.concat(tempSphere, vm.newTask.sphere.slice(0));
		                	vm.filter.sphere = _.uniqBy(_.sortBy(tempSphere));
		                	vm.closeOnSave = true;
		                	vm.taskDialogVisible = false;
							vm.$notify({ 
		    					title: 'Success', 
		    					message: '저장되었습니다.', 
		    					type: 'success',
		    					duration: vm.msgDuration,
		    					position: vm.msgPosition,
								offset: vm.msgOffset,
		    					onClose: function(){
				                	vm.loadData();
				                	vm.dialogOpen = false;
				                	vm.closeOnSave = false;
				                	vm.savePressed = false;
		    					}
		    				});
		                } else {
		                    console.log('error upload');
		                    vm.savePressed = false;
		                }
		    	    });
				}else {
					console.log("error submit!!");
					vm.savePressed = false;
				  	return false;
				}
			})
		},
		submitRequest: function(form){
			const vm = this;
			if(vm.savePressed) return;
			vm.$refs[form].validate(function(valid){
				if (valid) {
					vm.prepareFields(form);
		            var config = {
		                headers: { 'Content-Type': 'multipart/form-data' }
		            };
		            vm.savePressed = true;
					axios({
						method: 'post',
						url: ctx+'/saveTaskList',
						data: vm.upload.data,
						config: config
					 }).then(function (response) {
		                if (response) {
		                	if(response.data){
		                		vm.selectedTaskNo = response.data;
			                	vm.closeOnSave = true;
			                	vm.requestDialogVisible = false;
								vm.$notify({ 
			    					title: 'Success', 
			    					message: '저장되었습니다.', 
			    					type: 'success',
			    					duration: vm.msgDuration,
			    					position: vm.msgPosition,
									offset: vm.msgOffset,
			    					onClose: function(){
			    						vm.taskMode = "edit";
			    						var tempStep = vm.filter.step.slice(0);
					                	tempStep.push(2);
					                	vm.filter.step =_.uniqBy(_.sortBy(tempStep));
					                	vm.loadData();
					                	vm.dialogOpen = false;
					                	vm.closeOnSave = false;
					                	vm.savePressed = false;
			    					}
			    				});
		                	}else{
		                		vm.sessionInvalid();
		                		vm.savePressed = false;
		                	}
		                	
		                } else {
		                    console.log('error upload');
		                    vm.savePressed = false;
		                }
		    	    });
				} else {
					console.log("error submit!!");
					vm.savePressed = false;
				  	return false;
				}
			});
		},
		confirmTask: function(form){
			const vm = this;
			if(vm.savePressed) return;
			vm.$refs[form].validate(function(valid){
				if (valid) {
					if(!vm.newTask.isConfirm){
						vm.$notify({ 
							title: 'Warning', 
							message: '완료확인을 체크해주시기 바랍니다.', 
							type: 'warning',
							duration: vm.msgDuration,
							position: vm.msgPosition
						});
						return;
					}
					vm.prepareFields(form);
		            var config = {
		                headers: { 'Content-Type': 'multipart/form-data' }
		            };
		            vm.savePressed = true;
		            axios({
						method: 'post',
						url: ctx+'/saveTaskList',
						data: vm.upload.data,
						config: config
					 }).then(function (response) {
		                if (response) {
		                	vm.selectedTaskNo = response.data;
							vm.confirmDialogVisible = false;
							vm.$notify({ 
								title: 'Success', 
								message: '저장되었습니다.', 
								type: 'success',
								duration: vm.msgDuration,
								position: vm.msgPosition,
								offset: vm.msgOffset,
								onClose: function(){
									vm.taskMode = "edit";
									var tempStep = vm.filter.step.slice(0);
				                	tempStep.push(3);
				                	vm.filter.step =_.uniqBy(_.sortBy(tempStep));
									vm.loadData();	
									vm.savePressed = false;
								}
							});
		                } else {
		                    console.log('error upload');
		                    vm.savePressed = false;
		                }
		    	    });	
				}else {
					console.log("error submit!!");
					vm.savePressed = false;
				  	return false;
				}
			});
		},
		editTask: function(){
			if(this.onLoad) return;
			if(!this.checkTaskStep("0")) return;
			this.getContents('T', this.newTask.taskno);
			this.checkPw('edit');
		},
		checkTaskStep: function(step){
			const vm = this;
			var isValid = false;
			$.ajax({
				url:ctx+"/checkData",
				type:"post",
				dataType:"text",
				data:{"sts":"checkstep", "taskno":vm.selectedTaskNo, "step":step, "pinc": vm.newTask.pinc},
				async:false,
				success:function(ret){
					if(ret=="allowed"){
						isValid = true;
					}else{
						var msg = "";
						if(ret!="deleted"){
							switch (step){
								case "0":
									msg = "접수 상태에서만 수정, 삭제하실 수 있습니다.";
									break;
								case "1":
								case "2":
									msg = "이미 처리되었습니다.";
									break;
								case "pinc":
									msg = "이미 담당자가 배정된 상태입니다."
									break;
								case "reset":
									if(ret=="already"){
										msg = "이미 취소된 상태입니다.";
									}else{
										msg = "잘못된 접근입니다.";
									}
									break;
							}	
						}else{
							msg = "삭제된 업무 입니다.";
							vm.taskMode="del";
						}
						isValid = false;
						vm.dialogOpen = true;
						vm.$notify({ 
							title: 'Warning', 
							message: msg, 
							type: 'warning',
							duration: vm.msgDuration,
							position: vm.msgPosition,
							offset: vm.msgOffset,
							onClose: function(){
								vm.dialogOpen = false;
								vm.closeOnSave = false;
								vm.loadData();
							}
						});
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
			return isValid;
		},
		deleteTask: function(taskno){
			const vm = this;
			if(vm.savePressed) return;
			vm.savePressed = true;
			$.ajax({
				url:ctx+"/updateData",
				type:"post",
				dataType:"text",
				data:{"sts":"delete", "taskno":taskno},
				success:function(ret){
					if(ret=="success"){
						vm.selectedTaskNo = taskno;
						vm.taskDialogVisible = false;
						vm.$notify({ 
							title: 'Success', 
							message: '삭제되었습니다.', 
							type: 'success',
							duration: vm.msgDuration,
							position: vm.msgPosition,
							offset: vm.msgOffset,
							onClose: function(){
								vm.taskMode = "del";
								vm.loadData();
								vm.savePressed = false;
							}
						});
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);  
					vm.savePressed = false;
				}
			});
		},
		showProgress: function(){
			if(this.onLoad) return;
			if(!this.checkTaskStep("del")) return;
			this.getContents('T', this.newTask.taskno);
			this.getContents('R', this.newTask.taskno);
			this.getContents('F', this.newTask.taskno);
			this.getDueDate(this.newTask.taskno);
			this.progressDialogVisible = true;
		},
		checkDate: function(due, requestDate, date, updatedDate){
			var now = moment();
			var isNew = false;
			var isUpdated = false;
			//new, updated --> 24시간 이내...
			if(updatedDate){
				var temp = now.diff(moment(updatedDate),'h');
				isUpdated = temp < 24 ? true:false;
			}else{
				var temp = now.diff(moment(date),'h');
				isNew = temp < 24 ? true:false;
			}
			var dueDate = moment(due).endOf('day');
			var diffTime = null;
			diffTime = {
				check: moment.duration(dueDate.diff(now)),								
				day: Math.abs(moment.duration(dueDate.diff(now)).days()),	
				hour: Math.abs(moment.duration(dueDate.diff(now)).hours()),
				minute: Math.abs(moment.duration(dueDate.diff(now)).minutes()),
				second: Math.abs(moment.duration(dueDate.diff(now)).seconds())
			};
			var remain =  diffTime.check < 0 ? "경과" : "남음";
			var retmsg = "<table>";
			retmsg+="<tr>";
			retmsg+="<td style='text-align:right;'>처리기한:&nbsp;</td>";
			retmsg+="<td style='text-align:left;'>"+dueDate.format("YYYY-MM-DD HH:mm:ss")+"</td>";
			retmsg+="</tr>";
			retmsg+="<tr>";
			retmsg+="<td style='text-align:right;'>남은기한:&nbsp;</td>";
			if(requestDate == null){
				retmsg+="<td style='text-align:left'>"+diffTime.day+"일 "+diffTime.hour+"시간 "+diffTime.minute+"분 "+diffTime.second+"초 "+remain+"</td>";
			}else{
				retmsg+="<td style='text-align:left'>완료요청 ("+requestDate+")</td>";
			}
			retmsg+="</tr>";
			retmsg+="</table>";
			return [retmsg, isNew, isUpdated];			
		},
		selMem: function(index){
			this.newTask.name = this.memInfoList.data[index].name;
			this.newTask.dept = this.memInfoList.data[index].dept;
			this.newTask.pos = this.memInfoList.data[index].pos;
			this.newTask.tel = this.memInfoList.data[index].tel;
			this.newTask.email = this.memInfoList.data[index].email;
			this.memInfoList.view = [];
			this.memInfoList.data = [];
		},
		getStatusInfo: function(list, arr){
			var ret = "<table>";
			for(var i=parseInt(list);i>=0;i--){
				ret+="<tr><td style='text-align:right;'>"+this.statusArr.step[i]+":&nbsp;</td><td>"+arr[i]+"</td></tr>";
			}
			ret+="</table>"
			return ret;
		},
		getRequestorInfo: function(dept, pos, tel, email){
			var ret = dept;
			if(pos!="undefined") ret+=" "+pos;
			if(tel || email){
				ret+="<br>";
				ret+=tel;
				if(tel && email) ret+=", ";
				ret+=email;
			}
			return ret;
		},
		getPinCInfo: function(c){
			var ret = "";
			var find = _.find(this.pincArr, {userno: parseInt(c)});			
			if(find){
				var dept1 = find.dept1;
				var dept2 = find.dept2;
				var dept3 = find.dept3;
				var dept = "";
				var deli = " ";
				if(dept1!=""){
					dept = dept1;
					if(dept2!=""){
						dept+=deli+dept2;
						if(dept3!=""){
							dept+=deli+dept3;
						}
					}else{
						if(dept3!=""){
							dept+=deli+dept3;
						}
					}
				}else{
					if(dept2!=""){
						dept = dept2;
						if(dept3!=""){
							dept+=deli+dept3;
						}
					}else{
						if(dept3!=""){
							dept=dept3;
						}
					}
				}
				ret = dept+" "+find.pos_name;
				if(find.phone || find.e_mail){
					ret+="<br>";
					ret+=find.phone;
					if(find.phone && find.e_mail) ret+=", ";
					ret+=find.e_mail;
				}
			}	
			return ret
		},
		updateTime: function() {
			var week = ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'];
			var cd = moment();
			this.today.date = cd.format("YYYY년 MM월 DD일")+" ("+week[cd.day()]+")";
		    this.today.time = cd.format("HH:mm:ss");
		},
		getAttachmentSize: function() {
            this.upload_size = 0;
            this.newTask.fileList.map(function(item){ this.upload_size += parseInt(item.size); });
            this.upload_size = Number((this.upload_size).toFixed(1));
            this.$forceUpdate();
        },
        prepareFields: function(sts) {
        	this.upload.data = new FormData(); 
            if (this.newTask.fileList.length > 0) {
                for (var i = 0; i < this.newTask.fileList.length; i++) {
                    let attachment = this.newTask.fileList[i];
                    this.upload.data.append('files[]', attachment);
                }
            }
            this.newTask.sts = sts;
            this.newTask.sphere = _.sortBy(this.newTask.sphere.slice(0));
            this.newTask.dueDate = moment(this.newTask.dueDate).endOf("day").format("YYYY-MM-DD HH:mm:ss");
            const vm = this;
            $.each(this.newTask, function(key, value){
            	vm.upload.data.append(key, value);
           	})
        },
        uploadFieldChange: function(e, id) {
            var files = e.target.files || e.dataTransfer.files;
            if (!files.length) return;
            var duplicates = [];
            for (var i = files.length - 1; i >= 0; i--) {
                var find = _.find(this.newTask.fileList, {name:files[i].name});
            	if(find){
            		duplicates.push(files[i].name);
            	}else{
            		this.newTask.fileList.push(files[i]);	
            	}
            }
            if(duplicates.length){
            	const vm = this;
        		vm.$notify({ 
    				title: 'Warning', 
    				message: duplicates.join(", ")+' 은(는) 이미 선택하신 파일입니다.',
    				type: 'warning',
    				duration: vm.msgDuration,
    				position: vm.msgPosition,
					offset: vm.msgOffset
    			});	
            }
            document.getElementById(id).value = [];
        },
        removeAttachment: function(attachment, fileno, taskno) {
        	const vm = this;
        	vm.$confirm(attachment+' 파일을 삭제 요청하셨습니다. 계속 진행하시겠습니까?', 'Warning', {
                confirmButtonText: '확인',
                cancelButtonText: '취소',
                type: 'warning'
            }).then(function(){
               if(vm.taskMode=="edit"){
            	   $.ajax({
	      				url:ctx+"/updateData",
	      				type:"post",
	      				dataType:"text",
	      				data:{"sts":"delfile", "fileno":fileno, "taskno":taskno},
	      				success:function(ret){
	      					console.log(ret);
	      				},
	      				error:function(request,status,error){						
	      					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
	      				}
            	   })
               }
			   vm.$notify({ 
					title: 'Success', 
					message: '삭제되었습니다.',
					type: 'success',
					duration: vm.msgDuration,
					position: vm.msgPosition,
					offset: vm.msgOffset
			   });	
			   vm.newTask.fileList.splice(vm.newTask.fileList.indexOf(attachment), 1);
			   vm.getAttachmentSize();
            }).catch(function(){});
        },
        resize: function(e){
        	e.target.style.height = "1px";
        	e.target.style.height = (e.target.scrollHeight)+"px";
        },
        pwMatch: function(e){
        	if(e.target.value.length > 0 && e.target.value == this.newTask.pw){
        		this.confirmPw = true;
        		this.$refs['taskForm'].fields[10].validateState = null
		        this.$refs['taskForm'].fields[10].validateMessage = null
		        this.$refs.pwMatchInput.blur();
        	}else{
        		this.confirmPw = false;
        	}
        },
        limitInput: function(e){
        	if(e.which == 32){
        		e.preventDefault();
        	}
        },
        getTotal: function(){
        	const vm = this;
        	$.ajax({
				url:ctx+"/checkData",
				type:"post",
				dataType:"json",
				data:{"sts":"total"},		
				async:false,
				success:function(ret){
					vm.curStatus = '<span class="data-total">전체: '+ret[0]+' 건</span>';
					vm.curStatus+='<span class="data-total">접수: '+ret[1]+' 건</span>';
					vm.curStatus+='<span class="data-total">진행 중: '+ret[2]+' 건</span>';
					vm.curStatus+='<span class="data-total">완료(요청): '+ret[3]+' 건</span>';
					vm.curStatus+='<span class="data-total">처리기한 경과: '+ret[4]+' 건</span>';
					vm.loadingStatus = vm.curStatus;
					vm.getList();	
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); 
					vm.loadingStatus = "";
					vm.datacnt = 0;
				}
			});
        },
        refreshData: function(){
        	if(this.onLoad) return;
        	this.taskMode = "refresh";
        	this.loadData();
        },
        loadData: function(){
        	const vm = this;
        	vm.onLoad = true;
        	vm.loadingStatus = "Loading....";
        	if(vm.taskMode=='load') $("#contentArea").html('<tr class="clusterize-no-data"><td>Loading...</td></tr>')
    		if(vm.selectedTaskNo){
    			if(vm.taskMode=="del"){
    				$("."+vm.selectedTaskNo).addClass("row-deleted");
    			}else if(vm.taskMode=="edit"){
    				$("."+vm.selectedTaskNo).addClass("row-updated");
    			}
    		}
        	vm.$notify({ 
        		title: 'Success', 
        		message: '데이터를 불러오는 중입니다.', 
        		type: 'success',
        		duration: vm.msgDuration,
				position: vm.msgPosition,
				offset: vm.msgOffset,
				onClose:function(){
					vm.getTotal();
				}
        	})
        },
        getList: function(){
        	const vm = this;        	
    		var startDate = "";
        	var endDate = "";
        	switch(vm.filter.dateSelect){
	    		case "date":
	    			if(vm.filter.date){
	            		startDate = moment(vm.filter.date[0]).startOf('day').toString();
	                	endDate = moment(vm.filter.date[1]).endOf("day").toString();
	            	}
	    			break;
	    		case "requestDate":
	    			if(vm.filter.requestDate){
	            		startDate = moment(vm.filter.requestDate[0]).startOf('day').toString();
	                	endDate = moment(vm.filter.requestDate[1]).endOf("day").toString();
	            	}
	    			break;
	    	}
	    	var dueDate = "";
	    	if(vm.filter.dueDate){
	    		dueDate = moment(vm.filter.dueDate).endOf("day").toString();
	    	}
        	$.ajax({
        		url:ctx+"/getData",
        		type:"post",
        		dataType:"json",
        		data:{
       				"sts":"list",
					"dueDate": dueDate,
					"dateSelect": vm.filter.dateSelect,
       				"startDate":startDate,
       				"endDate":endDate,
       				"op":vm.filter.op,
       				"step":vm.filter.step.join(","),
       				"select":vm.filter.select,
       				"text":vm.filter.text,
       				"sphere":vm.filter.sphere.join(","),
       				"always":vm.filter.always
        		},
        		async: false,
        		success:function(obj){
        			var data = [];
        			var filtered = [];
        			var selectedTaskData = null;
        			var dueDate = [];
        			_.forEach(obj,function(o){
        				var requestBtn = "";
        				var confirmBtn = "";
        				if(o.taskno == vm.selectedTaskNo) selectedTaskData = o;
        				dueDate = vm.checkDate(o.dueDate,o.requestDate,o.date,o.updatedDate);
        				var taskno = "업무-"+("000000" + o.taskno).slice(-7);
        				if(dueDate[1]){
        					taskno += "<span class='new-task super' onmouseover='showInfo(&quot;new&quot;,this,&quot;"+o.date+"&quot;)''></span>";
        				}else{
        					if(dueDate[2]) taskno += "<span class='updated-task super' onmouseover='showInfo(&quot;updated&quot;,this,&quot;"+o.updatedDate+"&quot;)'></span>";	
        				}
        				var requestor = "<span class='tag gray' onmouseover='showInfo(&quot;requestor&quot;,this,"+JSON.stringify(o)+")'>"+o.name+"</span>";
        				if(o.step=="2")	confirmBtn="<span class='btn' onclick='app.setConfirm(&quot;&quot;)'>확인하기</span>";
        				var pinc = vm.pincText2(o.pinc);
        				if(pinc){
        					pinc = "<span class='tag gray'><span onmouseover='showInfo(&quot;pinc&quot;,this,&quot;"+o.pinc+"&quot;)'>"+pinc+"</span>";
        					if(vm.login.isLogin && o.step=="1") pinc+="<span class='custom-delete' onclick='app.resetPinC("+o.taskno+")'></span>";
        					pinc+="</span>";	
        					if(vm.login.isLogin && o.step=="1") requestBtn ="<span class='btn' onclick='app.setRequest(&quot;new&quot;)'>요청하기</span>";
        				}else{
        					if(o.step == "0" && vm.login.isLogin){
        						pinc="<span class='btn' onclick='app.setPinC("+o.taskno+")'>담당자 배정</span>";	
        					}else{
        						pinc="<span style='color:#bbb;'>미정</span>";	
        					}
        				}
        				var due = "<span class='tag brown' onmouseover='showInfo(&quot;due&quot;,this,&quot;"+escape(dueDate[0])+"&quot;)'>"+o.due+"일</span>";
        				if(o.duePassed > 0){
        					due +="<span class='tag red fr' onmouseover='showInfo(&quot;passed&quot;,this,&quot;"+o.duePassed+"&quot;)'>기한경과</span>";
        				}else{
        					due +="<span class='fr' style='margin-right:7px;line-height:18px;'>"+o.dueDate+"</span>";
        				}
        				var title = "";
        				if(o.fileYN!=null){
        					title = "<div class='ellipsis' style='width:395px;' onmouseover='showInfo(&quot;title&quot;,this,&quot;"+escape(o.title)+"&quot;)'>"+o.title+"</div>";
        					title+="<div class='glyphicon glyphicon-paperclip attach-icon'></div>";
        				}else{
        					title = "<div class='ellipsis' style='width:420px;' onmouseover='showInfo(&quot;title&quot;,this,&quot;"+escape(o.title)+"&quot;)'>"+o.title+"</div>";
        				}
        				var requestDate = o.requestDate == null ? "" : o.requestDate;
        				var isDataValid = true;
        				if(vm.filter.isUpdated){
        					if(!dueDate[1] && !dueDate[2]) isDataValid = false;
        				}
        				if(vm.filter.duePassed){
        					if(o.duePassed <= 0) isDataValid = false;
        				}
        				if(vm.filter.pinc){
        					if(o.pinc != vm.login.userno) isDataValid = false;
        				}
        				if(isDataValid){
            				data.push([
            					taskno,
            					o.date,
            					requestDate,
            					"<span class='tag "+vm.statusArr['color'][o.step]+"' onmouseover='showInfo(&quot;status&quot;,this,"+JSON.stringify(o)+")'>"+vm.statusText(o.step)+"</span>",
            					requestor,
            					confirmBtn,
            					due,
            					"<div onmouseover='showInfo(&quot;sphere&quot;,this,&quot;"+o.sphere+"&quot;)' class='ellipsis'>"+vm.sphereText(o.sphere)+"</div>",
            					title,
            					pinc,
            					requestBtn
            				]);	
    						filtered.push(o);
            			}
        			})
        			if(!vm.clusterize){
        				vm.clusterize = new Clusterize({
    						rows: vm.getRows(data, filtered),
    						scrollId: 'scrollArea',
    						contentId: 'contentArea'
            			});	
        			}else{
        				vm.clusterize.update(vm.getRows(data, filtered));
        			}
        			if(vm.taskMode =="refresh" || vm.taskMode == "filter" || vm.taskMode == 'del'){
        				vm.selectedTaskNo = "";
        				$(".row").removeClass("row-selected");
        			}else{
        				var duration = 0;
        				if(vm.taskMode == 'new'){
        					$(".list-div").scrollTop(0);
        					$("."+vm.selectedTaskNo).addClass("row-updated");
        					duration = 1000;
        				}
        				setTimeout(function(){
        					if(vm.selectedTaskNo) rowSelected(vm.selectedTaskNo, JSON.stringify(selectedTaskData));	
    					},duration);
        			}
        			vm.datacnt = filtered.length;
        			vm.curStatus+= "<span> / "+vm.datacnt+" 건이 검색되었습니다.</span>";
					vm.loadingStatus = vm.curStatus;
        			vm.taskMode = "";
        			vm.onLoad = false;
        			if(vm.datacnt == 0){
            			vm.selectedTaskNo = "";
            			$("#contentArea").html('<tr class="clusterize-no-data"><td>No data</td></tr>');
            			vm.clusterize = null;	
        			}
        		},
        		error:function(request,status,error){	
        			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
        			vm.loadingStatus = "";
        			vm.datacnt = 0;
        		}
        	});
        },
        getRows: function(data, filtered){
        	const vm = this;
        	var ret = data.map(function(row,i) {
				return "<tr class='row context-menu-one "+filtered[i].taskno+"' onmousedown='rowSelected(this,"+JSON.stringify(filtered[i])+")'>" +
				row.map(function(col, i) {
					return "<td class='"+vm.columns.cls[i]+"'>" + col + "</td>";
				}).join(" ") + "</tr>"
			})
			return ret;
        },
        handleDateChange: function(){
        	this.taskMode = "filter";
        	this.loadData();
        },
        handleFilterChange: function(type){
        	if(type!='') this.filter[type] = _.sortBy(this.filter[type]);
        	this.taskMode = "filter";
        	this.loadData();
        },
        handleFilterTextChange: function(){
        	if(!this.filter.select){
        		const vm = this;
        		vm.$notify({ 
					title: 'Warning', 
					message: '검색필드를 선택해주세요.', 
					type: 'warning',
					duration: vm.msgDuration,
					position: vm.msgPosition,
					offset: vm.msgOffset
				});
        		return;
        	}
        	var isValid = false;
			this.filter.input = this.filter.input.trim();
        	if(this.filter.input.length > 0){
        		switch (this.filter.select){
        			case "taskno":
        			case "requestor":
        			case "title":
        				console.log(this.filter.input)
        				this.filter.text = this.filter.input;
        				isValid = true;
        				break;
        			case "pinc":
        				const vm = this;
        				for(var i=0;i<vm.pincArr.length;i++){
        					if(vm.pincArr[i].name == vm.filter.input){
        						vm.filter.input = vm.pincArr[i].name;
        						vm.filter.text = vm.pincArr[i].userno;
        						isValid = true;
        						break;
        					}
        				};
        				if(!isValid){
        					vm.$notify({ 
        						title: 'Warning', 
        						message: '등록된 담당자가 아닙니다.', 
        						type: 'warning',
        						duration: vm.msgDuration,
        						position: vm.msgPosition,
        						offset: vm.msgOffset
        					});
        				}
        				break;
        		}
        		if(isValid){
        			this.taskMode = "filter";
                	this.loadData();	
        		}
        	}
        },
        resetSearch: function(){
        	this.filter.select = "";
        	this.filter.input = "";
        	this.filter.text = "";
        	this.taskMode = "filter";
        	this.loadData();	
        },
        handleScroll: function(e){
        	if(this.selectedTaskNo!=""){
        		$("."+this.selectedTaskNo).addClass("row-selected");
        	}else{
        		$(".row").removeClass("row-selected");
        	}
        },
        filedown: function(orgname,filename,filepath){
        	this.$confirm(orgname+'을(를) 다운로드 하시겠습니까?', 'Info', {
                confirmButtonText: '확인',
                cancelButtonText: '취소',
                type: 'info'
            }).then(function(){
				$("#orgname").val(orgname);
				$("#filename").val(filename);
				$("#filepath").val(filepath);
				$("#csvfile").val("");
				$("#downform").attr("action",ctx+"/fileDownLoad")
				$("#downform").submit();
            }).catch(function(){});
        },
        go_login: function(sts){
        	$("#loginsts").val(sts);
        	$("#loginid").val(this.login.loginid);
        	$("#loginform").attr("action",ctx+"/taskManagerView/login.jsp");
        	$("#loginform").submit();
        },
        go_logout: function(){
        	const vm = this;
        	axios({
			   	method: 'post',
			   	url: ctx+"/loginCtrl",
			   	data:{status: "logout"}
			}).then(function (result) {
				if(result.data=="success"){
					vm.handleRedirection("main");
				}
    	    });
        },
        setPopoverData: function() {
            const vm = this;
            vm.fileNameWithDate = '업무리스트_' + moment(new Date()).format('YYYYMMDDHHmmss');
            vm.checkedColumns = _.map(vm.columns.csv, "value");
            vm.checkAll = true;
            vm.isIndeterminate = false;
            vm.$nextTick(function() {
            	vm.$refs.csvFileName.focus();
            })
        },
        handleCheckAllChange: function(value) {
            this.checkedColumns = value ? _.map(this.columns.csv, "value") : [];
            this.isIndeterminate = false;
        },
        handleCheckedColumnsChange: function(value) {
            const checkedCount = value.length;
            this.checkAll = checkedCount === this.columns.csv.length;
            this.isIndeterminate = checkedCount > 0 && checkedCount < this.columns.csv.length;
        },
        export2csv: function(){
			const vm = this;	
			vm.fileNameWithDate = vm.fileNameWithDate.trim();
			if (vm.fileNameWithDate === '') {
				vm.$notify({ title: 'Warning', message: '파일명을 입력해주세요.', type: 'warning', duration: vm.msgDuration, position: vm.msgPosition, offset: vm.msgOffset});
				vm.$refs.csvFileName.focus();
				return;
			}
			if (vm.checkedColumns.length === 0) {
				vm.$notify({ title: 'Warning', message: '선택한 컬럼이 없습니다.', type: 'warning', duration: vm.msgDuration, position: vm.msgPosition, offset: vm.msgOffset});
				return;
			}
			var startDate = "";
        	var endDate = "";
        	switch(vm.filter.dateSelect){
	    		case "date":
	    			if(vm.filter.date){
	            		startDate = moment(vm.filter.date[0]).startOf('day').toString();
	                	endDate = moment(vm.filter.date[1]).endOf("day").toString();
	            	}
	    			break;
	    		case "requestDate":
	    			if(vm.filter.requestDate){
	            		startDate = moment(vm.filter.requestDate[0]).startOf('day').toString();
	                	endDate = moment(vm.filter.requestDate[1]).endOf("day").toString();
	            	}
	    			break;
	    	}
	    	var dueDate = "";
	    	if(vm.filter.dueDate){
	    		dueDate = moment(vm.filter.dueDate).endOf("day").toString();
	    	}
        	var notify = null;
			$.ajax({
        		url:ctx+"/export2csv",
        		type:"post",
        		dataType:"text",
        		data:{  
        			"updated": vm.filter.isUpdated,
        			"dueDate": dueDate,					
					"dateSelect":vm.filter.dateSelect,					
					"startDate":startDate,
					"endDate":endDate,
					"op":vm.filter.op,
       				"step":vm.filter.step.join(","),
       				"pinc":(vm.filter.pinc && vm.login.isLogin) ? vm.login.userno : "",
       				"duePassed":vm.filter.duePassed,		
       				"select":vm.filter.select,
       				"text":vm.filter.text,
       				"sphere":vm.filter.sphere.join(","),
       				"checked":vm.checkedColumns.join(","),
       				"always":vm.filter.always
        		},
        		beforeSend:function(){
        			vm.onLoad = true;
        			vm.dialogOpen = true;
        			notify = vm.$notify({ 
        				title: 'Info', 
        				message: 'CSV 데이터를 구성 중입니다.', 
        				type: 'info',
        				duration: 0,
        				position: vm.msgPosition,
        				offset: vm.msgOffset
        			});
        		},
        		complete: function(){
        			setTimeout(function(){notify.close()},vm.msgDuration);
        		},
        		success:function(result){
        			if(result){
        				$("#csvfile").val(result);
        				$("#csvfileName").val(vm.fileNameWithDate);
            			$("#downform").attr("action",ctx+"/fileDownLoad")
        				$("#downform").submit();
        			}else{
        				notify.close();
        				vm.sessionInvalid();
        			}
        			vm.popoverVisible = false;
        			vm.onLoad = false;
        			vm.dialogOpen = false;
        		},
        		error:function(request,status,error){	
        			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
        		}
        	});	
        },
        sessionInvalid: function(){
        	const vm = this;
        	vm.$notify({ 
				title: 'Warning', 
				message: '유효하지 않은 세션입니다. 다시 로그인 후 이용하시기 바랍니다.', 
				type: 'warning',
				duration: vm.msgDuration * 2,
				position: vm.msgPosition,
				offset: vm.msgOffset,
				onClose: function(){
					vm.go_login('login');
				}
			});
        },
        handleRedirection: function(loc){
        	switch (loc){
        		case "main":
        			window.location.replace(ctx+"/taskManagerView/view.jsp");
        			break;
        	}
        },
        howToUse: function(){
        	this.infoDialogVisible = true;
        },
        handlePage: function(loc){
        	this.resetTask();
        	this.selectedTaskNo = "";
        	if(loc=="report") this.getReport(this.report.year);
        	this.project.pageMode = loc;
        },
        disabledDates: function(date){
        	if(moment(date)===moment()){
        		return true;
        	}else{
        		return false;
        	}
        },
        handleDue: function(date){
        	if(date==null){
        		this.$nextTick(function() {
        			this.newTask.dueDate = moment().add('days',1);
    				this.newTask.due = "1";
        	    });
			}else{
				var diff = Math.ceil(moment.duration(moment(date).diff(moment())).asDays());
	            this.newTask.due = diff;
			}
        },
        getReport: function(year){
        	const vm = this;
        	$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"report", "year":moment(year).year()},
				success:function(obj){
					vm.report.data = obj;
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
        },
        getStep: function(no){
        	const vm = this;
        	var result = "";
        	$.ajax({
				url:ctx+"/checkData",
				type:"post",
				dataType:"text",
				async:false,
				data:{"sts":"step", "taskno":no},
				success:function(ret){
					result = vm.statusArr['color'][ret];
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});	
        	return result;
        },
        getTask: function(no){
        	const vm = this;
        	$.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"task","taskno":no},
				success:function(obj){
					var data = obj[0];
					if(obj.length > 0){
						_.forEach(Object.keys(data),function(o){
							vm.newTask[o] = data[o];
						})	
					    if(vm.newTask.sphere.length) vm.newTask.sphere = vm.newTask.sphere.split(",").map(function(item) {return parseInt(item, 10);});	
						vm.selectedTaskNo = vm.newTask.taskno;	
						vm.showProgress();
					}
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
        },
        reportDownLoad: function(dueRange){
        	var data = JSON.parse(JSON.stringify(_.find(this.report.data, {dueRange:dueRange})));
        	var dueData = data.dueData;
        	data.dueData = _.map(dueData, function(o){
        		return o.taskno;
        	}).join(",");
        	var taskNOs = "";
        	if(data.dueData !=""){
        		taskNOs = _.union(data.dueData.split(","), data.taskNOs).join(",");
        	}else{
        		taskNOs = data.taskNOs.join(",");
        	}
			var wb = XLSX.utils.book_new();
			var passed = [];
			var passedTotal = 0;
            _.forEach(dueData, function(o){
            	var obj = {};
            	obj['업무번호'] = o.taskno;
            	obj['구분'] = o.gubun;
            	obj['지연일수'] = o.days+"일";
            	obj['페널티'] = "-"+o.penalty+"점";
            	passedTotal+=o.passed;
            	passed.push(obj);
            })
            
			var report = {};
			report['처리기한'] = data.dueRange;
			report['점수'] = data.score+'점';
			report['이월'] = passedTotal+'건';
			report['기한경과'] = dueData.length+'건';
			report['적기처리율 (건수)'] = data.onTimeRatio+"% ("+data.onTime+"건)";
			report['만족도평균 (총점)'] = data.rateAVG+"점 ("+data.rate+"점)";
			report['전체'] = data.total+"건";
			report['완료'] = data.step3+"건";
			report['완료요청'] = data.step2+"건";
			report['진행중'] = data.step1+"건";
			report['접수'] = data.step0+"건";

            XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet([report]), '보고서')
			XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(passed), '기한경과')
            $.ajax({
				url:ctx+"/getData",
				type:"post",
				dataType:"json",
				data:{"sts":"report_list", "taskNOs":taskNOs},
				async:false,
				success:function(ret){
					var list = [];
					_.forEach(ret, function(o){
		            	var obj = {};
		            	obj['업무번호'] = o.taskno;
		            	obj['등록일시'] = o.date;
						obj['진행상황'] = o.step;
						obj['요청자'] = o.name;
						obj['부서'] = o.dept;
						obj['직급'] = o.pos;
						obj['연락처'] = o.tel;
						obj['이메일'] = o.email;
						obj['처리기한 (날짜)'] = o.due_date;
						obj['처리기한 (일수)'] = o.due;
						obj['총 기한경과 (일수)'] = o.due_passed;
						obj['업무구분'] = o.sphere;
						obj['업무제목'] = o.title;
						obj['업무내용'] = o.content;
						obj['업무내용 첨부파일'] = o.content_file;
						obj['담당자'] = o.pinc;
						obj['완료요청자'] = o.request_pinc;
						obj['완료요청일시'] = o.request_date;
						obj['완료요청내용'] = o.request_msg;
						obj['완료요청 첨부파일'] = o.request_file;
						obj['완료일시'] = o.confirm_date;
						obj['피드백'] = o.feedback;
						obj['만족도 (점)'] = o.rate;
						obj['업무처리소요시간 (시:분:초)'] = o.period;
		            	list.push(obj);
		            })
		            //console.log(list);
					XLSX.utils.book_append_sheet(wb, XLSX.utils.json_to_sheet(list), '업무리스트')
		            XLSX.writeFile(wb, 'SLA보고서('+dueRange+')_'+moment(new Date()).format('YYYYMMDDHHmmss')+'.xlsx');
				},
				error:function(request,status,error){						
					console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);        
				}
			});
        }
	}
})
$(function() {
    $.contextMenu({
        selector: '.context-menu-one',
        build: function($trigger) {
			var options = {
				callback: function(key, options) {	
					switch(key){
						case "detail":
							app.showProgress();
							break;
						case "edit":
							app.editTask();
							break; 
					}
			  	},
			  	items: {}
			};
			options.items.detail = {name: "상세보기", icon:"add"};
			if (app.newTask.step=="0") options.items.edit = {name: "업무수정", icon:"edit"};
			options.items.sep1 = "---------";
            options.items.quit = {name: "나가기", icon: function(){return;}}
			return options;
        }
    });  
});
function rowSelected(obj, data){
	app.resetTask();	
	if(typeof obj !== 'object'){
		$("."+obj).addClass("row-selected");
		data = JSON.parse(data);
	}else{
		$(obj).addClass("row-selected");	
	}
	_.forEach(Object.keys(data),function(o){
		app.newTask[o] = data[o];
	})	
    if(app.newTask.sphere.length) app.newTask.sphere = app.newTask.sphere.split(",").map(function(item) {return parseInt(item, 10);});	
	app.selectedTaskNo = app.newTask.taskno;
}
var instance = null;
function showInfo(type, id, obj){
	if(instance!=null) instance.destroy();
	switch(type){
		case "new":
			instance = tippy(id, {
				content: obj,
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})
			break;
		case "updated":
			instance = tippy(id, {
				content: obj,
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})
			break;
		case "status":
			instance = tippy(id, {
				content: app.getStatusInfo(obj.step,[obj.date, obj.pincDate, obj.requestDate, obj.confirmDate]),
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})	
			break;		
		case "requestor":
			instance = tippy(id, {
				content: app.getRequestorInfo(obj.dept, obj.pos, obj.tel, obj.email),
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})	
			break;
		case "pinc":
			instance = tippy(id, {
				content: app.getPinCInfo(obj),
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			}) 
			break;
		case "due":
			instance = tippy(id, {
				content: unescape(obj),
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})
			break;
		case "sphere":
			instance = tippy(id, {
				content: app.sphereText2(obj),
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})	
			break;
		case "title":
			instance = tippy(id, {
				content: unescape(obj),
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})	
			break;
		case "passed":
			instance = tippy(id, {
				content: obj+"일",
				followCursor:true,
				arrow:true,
				theme: 'translucent',
				animation: 'fade',
				maxWidth:500
			})	
			break;
	} 
}
</script>
</body>
</html>