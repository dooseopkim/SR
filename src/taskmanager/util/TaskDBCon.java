package taskmanager.util;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;

import org.apache.commons.io.output.FileWriterWithEncoding;
import org.json.JSONArray;
import org.json.JSONObject;

import com.opencsv.CSVWriter;

import taskmanager.vo.DueData;
import taskmanager.vo.KidpMembers;
import taskmanager.vo.ReportFields;

public class TaskDBCon {

	private Connection con;	
	private PreparedStatement pstmt;
	private ResultSet rs;
	private ResultSet rs2;	
	private void setConn() throws ClassNotFoundException, SQLException{
	    
		Class.forName("com.mysql.jdbc.Driver");
		//String url = "jdbc:mysql://localhost:3307/taskmanager?autoReconnect=true&useSSL=false&zeroDateTimeBehavior=convertToNull";
		//String username = "nibpsys";
		//String password = "Dusaod23@";
		String url = "jdbc:mysql://192.168.1.116:3306/taskmanager?useSSL=false&;useUnicode=true&characterEncoding=utf8";
		String username = "taskmanager";
		String password = "D@ebak12#$";
	    
	    if(con==null){
	    	con = DriverManager.getConnection(url, username, password);
	    }	    	    
	    System.out.println("�뵒鍮꾩젒�냽�꽦怨�!!");
	}
	public void mariadb_test(){
		try {
			setConn();			
			String sql=""; 
			sql+=" select * from kcpass_dept ";	
			pstmt = con.prepareStatement(sql);
			if( rs.next() ){				
				System.out.println(rs.getString("dept_name"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public ArrayList<KidpMembers> getMember(String name,String wh){
		ArrayList<KidpMembers> list = new ArrayList<KidpMembers>();
		try {
			setConn();			
			String sql=""; 
			sql+=" select a.userno,a.emp_code,a.name,a.phone,a.e_mail,ifnull(d1.dept_name,'') as dept1,ifnull(d2.dept_name,'') as dept2,ifnull(d3.dept_name,'') as dept3,p.pos_name ";
			sql+=" from kcpass_member a left join kcpass_dept d1 on (a.dept_id1 = d1.dept_id) ";
			sql+=" left join kcpass_dept d2 on (a.dept_id2 = d2.dept_id) ";
			sql+=" left join kcpass_dept d3 on (a.dept_id3 = d3.dept_id) ";
			sql+=" left join kcpass_pos p on (a.pos_id=p.pos_id) ";
			if(!wh.equals("pinc")){
				sql+=" where a.name like ? ";
			}else{
				sql+=" where a.incharge='y' ";
			}			
			pstmt = con.prepareStatement(sql);
			if(!wh.equals("pinc")) {
				pstmt.setString(1, "%"+name+"%");
			}
			rs=pstmt.executeQuery();
			KidpMembers km;			
			while( rs.next() ){				
				km = new KidpMembers();
				km.setUserno(rs.getInt("userno"));
				km.setEmp_code(rs.getString("emp_code"));
				km.setName(rs.getString("name"));
				km.setPhone(rs.getString("phone"));
				km.setE_mail(rs.getString("e_mail"));
				km.setPos_name(rs.getString("pos_name"));
				km.setDept1(rs.getString("dept1"));
				km.setDept2(rs.getString("dept2"));
				km.setDept3(rs.getString("dept3"));				
				list.add(km);
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}	
	public ArrayList<Integer> getTotal(){
		ArrayList<Integer> list = new ArrayList<Integer>();
		try {
			setConn();
			String sql=""; 
			sql+=" select count(taskno) as total from task_list_new where delflag = 'N' ";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				list.add(rs.getInt("total"));
			}
			sql=""; 
			sql+=" select count(taskno) as total from task_list_new where delflag = 'N' and step='0'";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				list.add(rs.getInt("total"));
			}
			sql=""; 
			sql+=" select count(taskno) as total from task_list_new where delflag = 'N' and step='1'";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				list.add(rs.getInt("total"));
			}
			sql=""; 
			sql+=" select count(taskno) as total from task_list_new where delflag = 'N' and (step='2' or step='3')";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				list.add(rs.getInt("total"));
			}
			sql="";
			sql+=" select count(*) as total from "
					+ "(SELECT CASE WHEN ISNULL(requestDate) THEN DATEDIFF(now(), dueDate) "
					+ "ELSE DATEDIFF(requestDate, dueDate) "
					+ "END AS duepassed "
					+ "FROM taskmanager.task_list_new "
					+ "WHERE delflag = 'N' ) a where a.duepassed > 0 ";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				list.add(rs.getInt("total"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public String manualConfirm(String taskno){
		String result = "";
		try {
			setConn();			
			String sql = " select taskno from task_list_new ";
			sql+= " WHERE step = '2' AND requestDate IS NOT NULL ";
			sql+= " AND delflag = 'N' ";
			sql+= " AND taskno = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			rs=pstmt.executeQuery();
			if( rs.next() ){
				sql= "";
				sql+= " UPDATE task_list_new ";
				sql+= " set step = '3', confirmDate = now(), rate='5' ";
				sql+= " WHERE taskno = '"+taskno+"' ";
				pstmt = con.prepareStatement(sql);
				pstmt.executeUpdate();
				
				sql="";
				sql=" insert into task_message_new (msgno,type,taskno,task,regdate) ";
				sql+=" value( ";
				sql+=" null,?,?,?,now()) ";
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "F");
				pstmt.setString(2, taskno);
				pstmt.setString(3, "�엫�쓽 �셿猷뚰솗�씤 泥섎━�맂 �뾽臾댁엯�땲�떎. (�떆�뒪�뀥 硫붿꽭吏�)");
				pstmt.executeUpdate();
				result = "success";
			}else{
				result = "fail";
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	public ArrayList<Object> getSphere(){
		ArrayList<Object> list = new ArrayList<Object>();
		try {
			setConn();			
			String sql=""; 
			sql+=" select json_object('sphereno', sphereno, 'sphere', sphere, 'delflag', delflag) as jsonObj from task_sphere_new ";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			while( rs.next() ){				
				list.add(rs.getObject("jsonObj"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public int getStep(String taskno){
		int result = 0;
		try {
			setConn();			
			String sql=""; 
			sql+=" select step from task_list_new where taskno = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				result = rs.getInt("step");
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	public ArrayList<Object> getDueDate(String taskno){
		ArrayList<Object> list = new ArrayList<Object>();
		try {
			setConn();			
			String sql=""; 
			sql+=" select json_object('due', due, 'duedate', DATE_FORMAT(duedate, '%Y-%m-%d %H:%i:%s'), "
					+ "'name', (select name from kcpass_member where userno = pinc),'pinc',pinc,'type',type,'regdate', DATE_FORMAT(regdate, '%Y-%m-%d %H:%i:%s')) as jsonObj "
					+ "from task_duedate where taskno = ? "
					+ "order by duedateno desc ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			rs=pstmt.executeQuery();
			while( rs.next() ){				
				list.add(rs.getObject("jsonObj"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<Object> getContents(String taskno, String type){
		ArrayList<Object> list = new ArrayList<Object>();
		try {
			setConn();			
			String sql=""; 
			sql+=" select json_object('msgno', msgno, 'type', type, 'taskno', CAST(taskno as char(45)), 'task', task, ";
			sql+="'regdate', DATE_FORMAT(regdate, '%Y-%m-%d %H:%i:%s')) as jsonObj from task_message_new ";
			sql+=" where taskno = ? and delflag = 'N' ";
			if(!type.equals("A")){
				sql+=" and type = ? ";
			}
			sql+=" order by msgno desc ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			if(!type.equals("A")){
				pstmt.setString(2, type);
			}
			rs=pstmt.executeQuery();
			while( rs.next() ){				
				list.add(rs.getObject("jsonObj"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<Object> getFileList(String msgno){
		ArrayList<Object> list = new ArrayList<Object>();
		try {
			setConn();			
			String sql=""; 
			sql+=" select json_object('fileno',fileno,'type',type,'taskno',CAST(taskno as char(45)), 'msgno',msgno, 'name',SUBSTRING_INDEX(orgname, '\\\\', -1), 'filename',filename, 'filepath',filepath, 'filesize',filesize) as jsonObj from task_file_new ";
			sql+=" where msgno = ? and delflag = 'N' order by fileno asc ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, msgno);
			rs=pstmt.executeQuery();
			while( rs.next() ){				
				list.add(rs.getObject("jsonObj"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public String checkTaskPw(String taskno, String pw){
		String result = "fail";
		try {
			setConn();			
			String sql=""; 
			sql+=" select pw from task_list_new where taskno = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			rs=pstmt.executeQuery();
			if( rs.next() ){				
				if(MD5(pw).equals(rs.getString("pw"))){
					result = "success";
				}else{
					result = "fail";
				}
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	public ArrayList<Object> getTaskList(String dueDate, String op, String dateSelect, String startDate, String endDate, String step, String select, String text, String sphere, String always){
		ArrayList<Object> list = new ArrayList<Object>();
		try {
			setConn();		
			if(step.equals("")) step="-1";
			String sql="";
			sql+=" SELECT JSON_OBJECT(";
			sql+=" 'step',a.step,";
			sql+=" 'taskno',CAST(a.taskno as char(45)),";
			sql+=" 'userno',a.userno,";
			sql+=" 'name',a.name,";
			sql+=" 'dept',a.dept,";
			sql+=" 'pos',a.pos,";
			sql+=" 'tel',a.tel,";
			sql+=" 'email',a.email,";
			sql+=" 'date',DATE_FORMAT(a.date, '%Y-%m-%d %H:%i:%s'),";
			sql+=" 'title',a.title,";
            sql+=" 'due',a.due,";
            sql+=" 'duePassed', (case when isNull(a.requestDate) then DATEDIFF(now(), a.dueDate) else DATEDIFF(a.requestDate, a.dueDate) end), ";
            sql+=" 'sphere',a.sphere,";
            sql+=" 'pinc',a.pinc,";
            sql+=" 'pincDate',DATE_FORMAT(a.pincDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'requestPinC', a.requestPinC,";
            sql+=" 'requestDate',DATE_FORMAT(a.requestDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'confirmDate',DATE_FORMAT(a.confirmDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'isConfirm',a.isConfirm,";
            sql+=" 'dueDate',DATE_FORMAT(a.dueDate,'%Y-%m-%d'),";
            sql+=" 'updatedDate',DATE_FORMAT(a.updatedDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'rate',rate,";
            sql+=" 'period',a.period,";
            sql+=" 'fileYN', (select fileno from task_file_new where taskno = a.taskno and delflag = 'N' limit 1) ";
            sql+=" ) AS jsonObj FROM task_list_new a";
            sql+=" where a.delflag = 'N' AND (";
            if(always.equals("true")){
            	sql+="a.step in (0,1,2) or";
            }
            sql+=" (a.step in ("+step+") ";
            if(text.length() > 0 && select.length() > 0){
				switch (select){
					case "taskno":
						sql+=" and a.taskno like '%"+text+"%'";
						break;
	    			case "requestor":
	    				sql+=" and a.name like '%"+text+"%'";
	    				break;
	    			case "title":
	    				sql+=" and a.title like '%"+text+"%'";
	    				break;
	    			case "pinc":
	    				sql+=" and a.pinc ='"+text+"'";
	    				break;
				}
            }
            if(sphere.length() > 0){
				String[] temp = sphere.split(",");
				sql+=" and ( ";
				for(int i=0;i<temp.length;i++){
					sql+=" a.sphere like '%"+temp[i]+"%' or a.sphere like '%"+temp[i]+",%' or a.sphere like '%,"+temp[i]+"%'";
					if(i<temp.length-1) sql+=" or ";
				}
				sql+=" ) ";
			}else{
				sql+= " and a.sphere = '"+sphere+"'";
			}
            sql+=" and ( ";
            if(!dueDate.equals("")){
				sql+=" a.dueDate <= STR_TO_DATE('"+dueDate+"', '%W %M %d %Y %H:%i:%s') "+op;
			}
			sql+=" ( "; 
            if(!startDate.equals("")){
            	sql+=" a."+dateSelect+" between ";
            	sql+=" STR_TO_DATE('"+startDate+"', '%W %M %d %Y %H:%i:%s') "; 
            	sql+=" and STR_TO_DATE('"+endDate+"', '%W %M %d %Y %H:%i:%s') ";
            }
            sql+=" )))) ";
            sql+=" order by a.date desc, a.taskno desc ";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			while( rs.next() ){
				list.add(rs.getObject("jsonObj"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<Object> getTask(String taskno){
		ArrayList<Object> list = new ArrayList<Object>();
		try {
			setConn();
			String sql="";
			sql+=" SELECT JSON_OBJECT(";
			sql+=" 'step',a.step,";
			sql+=" 'taskno',CAST(a.taskno as char(45)),";
			sql+=" 'userno',a.userno,";
			sql+=" 'name',a.name,";
			sql+=" 'dept',a.dept,";
			sql+=" 'pos',a.pos,";
			sql+=" 'tel',a.tel,";
			sql+=" 'email',a.email,";
			sql+=" 'date',DATE_FORMAT(a.date, '%Y-%m-%d %H:%i:%s'),";
			sql+=" 'title',a.title,";
            sql+=" 'due',a.due,";
            sql+=" 'duePassed', (case when isNull(a.requestDate) then DATEDIFF(now(), a.dueDate) else DATEDIFF(a.requestDate, a.dueDate) end), ";
            sql+=" 'sphere',a.sphere,";
            sql+=" 'pinc',a.pinc,";
            sql+=" 'pincDate',DATE_FORMAT(a.pincDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'requestPinC', a.requestPinC,";
            sql+=" 'requestDate',DATE_FORMAT(a.requestDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'confirmDate',DATE_FORMAT(a.confirmDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'isConfirm',a.isConfirm,";
            sql+=" 'dueDate',DATE_FORMAT(a.dueDate,'%Y-%m-%d'),";
            sql+=" 'updatedDate',DATE_FORMAT(a.updatedDate, '%Y-%m-%d %H:%i:%s'),";
            sql+=" 'rate',rate,";
            sql+=" 'period',DATE_FORMAT(a.period, '%H:%i:%s'),";
            sql+=" 'fileYN', (select fileno from task_file_new where taskno = a.taskno and delflag = 'N' limit 1) ";
            sql+=" ) AS jsonObj FROM task_list_new a";
            sql+=" where a.delflag = 'N'";
            sql+=" and taskno = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			rs=pstmt.executeQuery();
			if( rs.next() ){
				list.add(rs.getObject("jsonObj"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return list;
	}
	public String export2csv(String dueDate, String op, String dateSelect, String startDate, String endDate, String step, String pinc, String dues, String select, String text, String sphere, String checked, String duePassed, String updated, String always){
		String result = "fail";
		String[] sqlArray = {
				" k.taskno as '�뾽臾대쾲�샇' ",
				" k.date as '�벑濡앹씪�떆' ",
				" k.step as '吏꾪뻾�긽�솴' ",
				" k.name as '�슂泥��옄' ",
				" k.dept as '遺��꽌' ",
				" k.pos as '吏곴툒' ",
				" k.tel as '�뿰�씫泥�'",
				" k.email as '�씠硫붿씪' ",
				" k.due_date as '泥섎━湲고븳 (�궇吏�)' ",
				" k.due as '泥섎━湲고븳 (�씪�닔)' ",
				" case when isNull(k.request_date) then "
				+ "case when DATEDIFF(now(), k.due_date) > 0 then "
				+ "DATEDIFF(now(), k.due_date) else 0 end "
				+ "else case when DATEDIFF(k.request_date, k.due_date) > 0 then "
				+ "DATEDIFF(k.request_date, k.due_date) else 0 end end as '珥� 湲고븳寃쎄낵 (�씪�닔)' ",
				" k.sphere as '�뾽臾닿뎄遺�' ",
				" k.title as '�뾽臾댁젣紐�' ",
				" k.content as '�뾽臾대궡�슜' ",
				" k.content_file as '�뾽臾대궡�슜 泥⑤��뙆�씪' ",
				" k.pinc as '�떞�떦�옄' ",
				" k.pinc_date as '�떞�떦�옄 吏��젙�씪�떆' ",
				" k.request_pinc as '�셿猷뚯슂泥��옄' ",
				" k.request_date as '�셿猷뚯슂泥��씪�떆' ",
				" k.request_msg as '�셿猷뚯슂泥��궡�슜' ",
				" k.request_file as '�셿猷뚯슂泥� 泥⑤��뙆�씪' ",
				" k.confirm_date as '�셿猷뚯씪�떆' ",
				" k.feedback as '�뵾�뱶諛�' ",
				" k.rate as '留뚯”�룄 (�젏)' ",
				" k.period as '�뾽臾댁쿂由ъ냼�슂�떆媛� (�떆:遺�:珥�)' "
			};
		String[] checkedColumns = checked.split(",");
		ArrayList<String> sqlArrayList = new ArrayList<String>();
		for(int i=0;i<checkedColumns.length;i++){
			sqlArrayList.add(sqlArray[Integer.parseInt(checkedColumns[i])]);
		}
		String sqlStr = sqlArrayList.toString().replace("[", "").replace("]", "");
		try {
			setConn();			
			String sql=""; 
			sql+=" select ";
			sql+=sqlStr;
			sql+=" from ( ";
			sql+=" select "; 
			sql+=" taskno, ";
			sql+=" DATE_FORMAT(date, '%Y-%m-%d %H:%i:%s') as 'date', ";
			sql+=" (case a.step when 0 then '�젒�닔' when 1 then '吏꾪뻾 以�' when 2 then '�셿猷뚯슂泥�' when 3 then '�셿猷�' end) as 'step', ";
			sql+=" name, ";
			sql+=" dept, ";
			sql+=" pos, ";
			sql+=" tel, ";
			sql+=" email, ";
			sql+=" due, ";
			sql+=" DATE_FORMAT(dueDate, '%Y-%m-%d %H:%i:%s') as 'due_date', ";
			sql+=" (select GROUP_CONCAT(sphere) from task_sphere_new where FIND_IN_SET(sphereno, a.sphere)) as 'sphere', ";
			sql+=" title, ";
			sql+=" (select task from task_message_new where taskno = a.taskno and type = 'T' and delflag = 'N' order by msgno desc limit 1) as 'content', ";
			sql+=" (select GROUP_CONCAT(SUBSTRING_INDEX(orgname, '\\\\', -1)) from task_file_new where taskno = a.taskno and type='T') as 'content_file', ";
			sql+=" (select name from kcpass_member where userno = a.pinc) as 'pinc', ";
			sql+=" DATE_FORMAT(pincDate, '%Y-%m-%d %H:%i:%s') as 'pinc_date', ";
			sql+=" (select name from kcpass_member where userno = a.requestPinC) as 'request_pinc', ";
			sql+=" DATE_FORMAT(requestDate, '%Y-%m-%d %H:%i:%s') as 'request_date', ";
			sql+=" (select task from task_message_new where taskno = a.taskno and type = 'R' and delflag = 'N' order by msgno desc limit 1) as 'request_msg', ";
			sql+=" (select GROUP_CONCAT(SUBSTRING_INDEX(orgname, '\\\\', -1)) from task_file_new where taskno = a.taskno and type='R') as 'request_file', ";
			sql+=" DATE_FORMAT(confirmDate, '%Y-%m-%d %H:%i:%s') as 'confirm_date', ";
			sql+=" (select task from task_message_new where taskno = a.taskno and type = 'F' and delflag = 'N' order by msgno desc limit 1) as 'feedback', ";
			sql+=" rate, ";
			sql+=" period ";
			sql+=" FROM ";
			sql+=" task_list_new a ";
			sql+=" where a.delflag = 'N' ";
			if(updated.equals("true")){
				sql+=" and ( HOUR(TIMEDIFF(NOW(), a.date)) < 24 or HOUR(TIMEDIFF(NOW(), a.updatedDate)) < 24 ) ";
			}
			if(duePassed.equals("true")){
				sql+=" and (CASE WHEN ISNULL(a.requestDate) THEN NOW() > a.dueDate ELSE a.requestDate > a.dueDate END) ";
			}
			if(!pinc.equals("")){
				sql+=" and a.pinc = '"+pinc+"' ";
			}
			sql+=" and (";
			if(always.equals("true")){
            	sql+="a.step in (0,1) or";
            }
			sql+=" (a.step in ("+step+") ";
            if(text.length() > 0 && select.length() > 0){
				switch (select){
					case "taskno":
						sql+=" and a.taskno like '%"+text+"%'";
						break;
	    			case "requestor":
	    				sql+=" and a.name like '%"+text+"%'";
	    				break;
	    			case "title":
	    				sql+=" and a.title like '%"+text+"%'";
	    				break;
	    			case "pinc":
	    				sql+=" and a.pinc ='"+text+"'";
	    				break;
				}
            }
            if(sphere.length() > 0){
				String[] temp = sphere.split(",");
				sql+=" and ( ";
				for(int i=0;i<temp.length;i++){
					sql+=" a.sphere like '%"+temp[i]+"%' or a.sphere like '%"+temp[i]+",%' or a.sphere like '%,"+temp[i]+"%'";
					if(i<temp.length-1) sql+=" or ";
				}
				sql+=" ) ";
			}else{
				sql+= " and a.sphere = '"+sphere+"'";
			}
			sql+=" and ( ";
			if(!dueDate.equals("")){
				sql+=" a.dueDate <= STR_TO_DATE('"+dueDate+"', '%W %M %d %Y %H:%i:%s') "+op;
			}
			sql+=" ( ";			
            if(!startDate.equals("")){
            	sql+=" a."+dateSelect+" between ";
            	sql+=" STR_TO_DATE('"+startDate+"', '%W %M %d %Y %H:%i:%s') "; 
            	sql+=" and STR_TO_DATE('"+endDate+"', '%W %M %d %Y %H:%i:%s') ";
            }
            sql+=" )))) ";
			sql+=" order by a.taskno asc ";
			sql+=" ) k ";
			pstmt = con.prepareStatement(sql);
			rs=pstmt.executeQuery();
			File temp = File.createTempFile("tempfile", ".tmp");
			CSVWriter writer = new CSVWriter(new FileWriterWithEncoding(temp, "MS949"));
            writer.writeAll(rs, true);
            writer.close();
			result = temp.getAbsolutePath();
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	public JSONArray getReportList(String taskNOs){
		JSONArray json = new JSONArray();
		String[] sqlArray = {
				" k.taskno"," k.date"," k.step"," k.name"," k.dept ",
				" k.pos "," k.tel "," k.email "," k.due_date "," k.due ",
				" case when isNull(k.request_date) then "
				+ "case when DATEDIFF(now(), k.due_date) > 0 then "
				+ "DATEDIFF(now(), k.due_date) else 0 end "
				+ "else case when DATEDIFF(k.request_date, k.due_date) > 0 then "
				+ "DATEDIFF(k.request_date, k.due_date) else 0 end end as 'due_passed' ",
				" k.sphere "," k.title "," k.content "," k.content_file "," k.pinc ",
				" k.pinc_date "," k.request_pinc "," k.request_date "," k.request_msg "," k.request_file ",
				" k.confirm_date "," k.feedback "," k.rate "," k.period "
			};
		
		String sqlStr = String.join(",", sqlArray);
		try {
			setConn();			
			String sql=""; 
			sql+=" select ";
			sql+=sqlStr;
			sql+=" from ( ";
			sql+=" select "; 
			sql+=" taskno, ";
			sql+=" DATE_FORMAT(date, '%Y-%m-%d %H:%i:%s') as 'date', ";
			sql+=" (case a.step when 0 then '�젒�닔' when 1 then '吏꾪뻾 以�' when 2 then '�셿猷뚯슂泥�' when 3 then '�셿猷�' end) as 'step', ";
			sql+=" name, ";
			sql+=" dept, ";
			sql+=" pos, ";
			sql+=" tel, ";
			sql+=" email, ";
			sql+=" due, ";
			sql+=" DATE_FORMAT(dueDate, '%Y-%m-%d %H:%i:%s') as 'due_date', ";
			sql+=" (select GROUP_CONCAT(sphere) from task_sphere_new where FIND_IN_SET(sphereno, a.sphere)) as 'sphere', ";
			sql+=" title, ";
			sql+=" (select task from task_message_new where taskno = a.taskno and type = 'T' and delflag = 'N' order by msgno desc limit 1) as 'content', ";
			sql+=" (select GROUP_CONCAT(SUBSTRING_INDEX(orgname, '\\\\', -1)) from task_file_new where taskno = a.taskno and type='T') as 'content_file', ";
			sql+=" (select name from kcpass_member where userno = a.pinc) as 'pinc', ";
			sql+=" DATE_FORMAT(pincDate, '%Y-%m-%d %H:%i:%s') as 'pinc_date', ";
			sql+=" (select name from kcpass_member where userno = a.requestPinC) as 'request_pinc', ";
			sql+=" DATE_FORMAT(requestDate, '%Y-%m-%d %H:%i:%s') as 'request_date', ";
			sql+=" (select task from task_message_new where taskno = a.taskno and type = 'R' and delflag = 'N' order by msgno desc limit 1) as 'request_msg', ";
			sql+=" (select GROUP_CONCAT(SUBSTRING_INDEX(orgname, '\\\\', -1)) from task_file_new where taskno = a.taskno and type='R') as 'request_file', ";
			sql+=" DATE_FORMAT(confirmDate, '%Y-%m-%d %H:%i:%s') as 'confirm_date', ";
			sql+=" (select task from task_message_new where taskno = a.taskno and type = 'F' and delflag = 'N' order by msgno desc limit 1) as 'feedback', ";
			sql+=" rate, ";
			sql+=" period ";
			sql+=" FROM ";
			sql+=" task_list_new a ";
			sql+=" where a.delflag = 'N' ";
			sql+=" and a.taskno in ("+taskNOs+")";
			sql+=" order by a.date, a.taskno asc ";
			sql+=" ) k ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			JSONObject obj;
			ResultSetMetaData rsmd = rs.getMetaData();
			int numColumns = rsmd.getColumnCount();
			while(rs.next()) {
			  obj = new JSONObject();
			  for (int i=1; i<=numColumns; i++) {
			    String column_name = rsmd.getColumnName(i);
			    obj.put(column_name, rs.getObject(column_name));
			  }
			  json.put(obj);
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json;
	}
	public String insTaskList(HashMap<String, String> ts, HashMap<String, ArrayList<String>> fl){
		try {
			setConn();
			String sql=" insert into task_list_new (taskno, step, name, dept, pos, tel, email, date, ";
			sql+="title, due, dueDate, sphere, pw, userno ) ";
			sql+=" values( ";					
			sql+=" null,?,?,?,?,?,?,now(),?,?,?,?,?,?) ";		
			con.setAutoCommit(false);		
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, ts.get("step"));
			pstmt.setString(2, ts.get("name"));
			pstmt.setString(3, ts.get("dept"));
			pstmt.setString(4, ts.get("pos"));
			pstmt.setString(5, ts.get("tel"));
			pstmt.setString(6, ts.get("email"));
			pstmt.setString(7, ts.get("title"));
			pstmt.setString(8, ts.get("due"));
			pstmt.setString(9, ts.get("dueDate"));
			pstmt.setString(10, ts.get("sphere"));
			pstmt.setString(11, ts.get("pw"));
			pstmt.setString(12, ts.get("userno"));
			pstmt.executeUpdate();
			
			sql = " SELECT LAST_INSERT_ID() as taskno ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ts.put("taskno", rs.getString("taskno"));
			}
			
			sql =" insert into task_duedate (duedateno,taskno,due,duedate,pinc,regdate,iscurrent,type) ";
			sql+=" value( ";
			sql+=" null,?,?,?,?,now(),'Y',?) ";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, ts.get("taskno"));
			pstmt.setString(2, ts.get("due"));
			pstmt.setString(3, ts.get("dueDate"));
			pstmt.setString(4, ts.get("userno"));
			pstmt.setString(5, "R");
			pstmt.executeUpdate();
			
			sql =" insert into task_message_new (msgno,type,taskno,task,regdate) ";
			sql+=" value( ";
			sql+=" null,?,?,?,now()) ";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, ts.get("type"));
			pstmt.setString(2, ts.get("taskno"));
			pstmt.setString(3, ts.get("content"));
			pstmt.executeUpdate();
			
			sql = " SELECT LAST_INSERT_ID() as msgno ";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				ts.put("msgno", rs.getString("msgno"));
			}
			
			for (int i=0;i<fl.get("orgname").size();i++){
				sql =" insert into task_file_new (fileno,type,taskno,msgno,orgname,filename,filepath,filesize,regdate) ";
				sql+=" value( ";
				sql+=" null,?,?,?,?,?,?,?,now()) ";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, ts.get("type"));
				pstmt.setString(2, ts.get("taskno"));
				pstmt.setString(3, ts.get("msgno"));
				pstmt.setString(4, fl.get("orgname").get(i));
				pstmt.setString(5, fl.get("fname").get(i));
				pstmt.setString(6, fl.get("fpath").get(i));
				pstmt.setString(7, fl.get("fsize").get(i));
				pstmt.executeUpdate();
			}
			con.commit();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return ts.get("taskno");
	}
	
	public String uptTaskList(HashMap<String, String> ts, HashMap<String, ArrayList<String>> fl){
		try {
			setConn();
			String  sql= " update task_list_new set";
			if(ts.get("type").equals("R")){
				sql+=" step = '2', ";
				sql+=" requestPinC = ?, ";
				sql+=" requestDate = now(), ";
				sql+=" period = ROUND(TIMESTAMPDIFF(MINUTE,pincDate,requestDate)/60,2), ";
			}else if(ts.get("type").equals("F")){	
				sql+=" step = '3', ";
				sql+=" confirmDate = now(), ";
				sql+=" isConfirm = '1', ";
				sql+=" rate = ?, ";
			}else if(ts.get("type").equals("T")){
				sql+=" name = ?, ";
				sql+=" dept = ?, ";
				sql+=" pos = ?, ";
				sql+=" tel = ?, ";
				sql+=" email = ?, ";
				sql+=" title = ?, ";
				sql+=" due = ?, ";
				sql+=" dueDate = ?, ";
				sql+=" sphere = ?, ";
				sql+=" pw = ?, ";
			}
			sql+=" updatedDate = now() ";
			sql+=" where taskno = ? ";
			con.setAutoCommit(false);		
			pstmt=con.prepareStatement(sql);
			if(ts.get("type").equals("R")){
				pstmt.setString(1, ts.get("requestPinC"));
				pstmt.setString(2, ts.get("taskno"));
			}else if(ts.get("type").equals("F")){
				pstmt.setString(1, ts.get("rate"));
				pstmt.setString(2, ts.get("taskno"));
			}else if(ts.get("type").equals("T")){
				pstmt.setString(1, ts.get("name"));
				pstmt.setString(2, ts.get("dept"));
				pstmt.setString(3, ts.get("pos"));
				pstmt.setString(4, ts.get("tel"));
				pstmt.setString(5, ts.get("email"));
				pstmt.setString(6, ts.get("title"));
				pstmt.setString(7, ts.get("due"));
				pstmt.setString(8, ts.get("dueDate"));
				pstmt.setString(9, ts.get("sphere"));
				pstmt.setString(10, ts.get("pw"));
				pstmt.setString(11, ts.get("taskno"));
			}
			
			pstmt.executeUpdate();
			if(!ts.get("msgno").equals("") && !ts.get("type").equals("F")){
				sql =" update task_message_new set task = ?, regdate = now() where msgno = ? ";		
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, ts.get("content"));
				pstmt.setString(2, ts.get("msgno"));
				pstmt.executeUpdate();
			}else{
				sql =" insert into task_message_new (msgno,type,taskno,task,regdate) ";
				sql+=" value( ";
				sql+=" null,?,?,?,now()) ";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, ts.get("type"));
				pstmt.setString(2, ts.get("taskno"));
				pstmt.setString(3, ts.get("content"));
				pstmt.executeUpdate();				
				sql = " SELECT LAST_INSERT_ID() as msgno ";
				pstmt = con.prepareStatement(sql);
				rs = pstmt.executeQuery();
				if(rs.next()){
					ts.put("msgno", rs.getString("msgno"));
				}
			}
			if(ts.get("type").equals("T")){
				sql =" update task_duedate ";
				sql+=" set due = ?, duedate = ?, pinc = ?, regdate = now() ";
				sql+=" where taskno = ? and iscurrent = 'Y' and type = 'R' ";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, ts.get("due"));
				pstmt.setString(2, ts.get("dueDate"));
				pstmt.setString(3, ts.get("userno"));
				pstmt.setString(4, ts.get("taskno"));
				int count = pstmt.executeUpdate();
				if(count==0){
					sql =" insert into task_duedate (duedateno,taskno,due,duedate,pinc,regdate,iscurrent,type) ";
					sql+=" value( ";
					sql+=" null,?,?,?,?,now(),'Y',?) ";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1, ts.get("taskno"));
					pstmt.setString(2, ts.get("due"));
					pstmt.setString(3, ts.get("dueDate"));
					pstmt.setString(4, ts.get("userno"));
					pstmt.setString(5, "R");
					pstmt.executeUpdate();
				}
			}
			for (int i=0;i<fl.get("orgname").size();i++){
				sql =" insert into task_file_new (fileno,type,taskno,msgno,orgname,filename,filepath,filesize,regdate) ";
				sql+=" value( ";
				sql+=" null,?,?,?,?,?,?,?,now()) ";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1, ts.get("type"));
				pstmt.setString(2, ts.get("taskno"));
				pstmt.setString(3, ts.get("msgno"));
				pstmt.setString(4, fl.get("orgname").get(i));
				pstmt.setString(5, fl.get("fname").get(i));
				pstmt.setString(6, fl.get("fpath").get(i));
				pstmt.setString(7, fl.get("fsize").get(i));
				pstmt.executeUpdate();
			}
			
			con.commit();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return ts.get("taskno");
	}
	
	public String deleteTask(String tn){
		String result = "fail";
		try {
			setConn();
			String sql=" update task_list_new set delflag='Y' where taskno = ? ";		
			con.setAutoCommit(false);		
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, tn);			
			pstmt.executeUpdate();
			
			sql=" update task_message_new set delflag='Y' where taskno = ? ";					
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, tn);			
			pstmt.executeUpdate();
			
			sql=" update task_file_new set delflag='Y' where taskno = ? ";					
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, tn);			
			pstmt.executeUpdate();			
			con.commit();
			pstmt.close();
			con.close();
			result = "success";
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}
	
	public String deleteFile(String taskno, String fileno){
		String result = "fail";
		try {
			setConn();
			con.setAutoCommit(false);
			String sql=" update task_file_new set delflag='Y' where fileno = ? ";					
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, fileno);			
			pstmt.executeUpdate();
			sql=" update task_list_new set updatedDate = now() where taskno = ? ";					
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, taskno);			
			pstmt.executeUpdate();			
			con.commit();
			pstmt.close();
			con.close();
			result = "success";
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}
	
	public String setPinc(String taskno, String pinc, String due, String dueDate, String sphere){
		String result = "fail";
		try {
			setConn();
			String sql=" update task_list_new set pinc = ?, sphere = ?, step = 1, due = ?, dueDate = ?, pincDate = now(), updatedDate = now() where taskno = ? ";		
			con.setAutoCommit(false);		
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, pinc);
			pstmt.setString(2, sphere);
			pstmt.setString(3, due);
			pstmt.setString(4, dueDate);
			pstmt.setString(5, taskno);
			pstmt.executeUpdate();
			
			sql =" update task_duedate set iscurrent = 'N' ";
			sql+=" where taskno = ? ";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			pstmt.executeUpdate();
			
			sql =" insert into task_duedate (duedateno,taskno,due,duedate,pinc,regdate,iscurrent,type) ";
			sql+=" value( ";
			sql+=" null,?,?,?,?,now(),'Y',?) ";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			pstmt.setString(2, due);
			pstmt.setString(3, dueDate);
			pstmt.setString(4, pinc);
			pstmt.setString(5, "C");
			pstmt.executeUpdate();
			
			con.commit();
			pstmt.close();
			con.close();
			result = "success";
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}
	public String checkStep(String taskno, String step, String pinc){
		String result = "";
		try {
			setConn();			
			String sql = " select * from task_list_new ";
			sql+= " WHERE taskno = ? ";
			if(step.equals("0") || step.equals("1") || step.equals("2") ){
				sql+= " AND step = '"+step+"'";
			}
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			rs=pstmt.executeQuery();
			if( rs.next() ){
				if(rs.getString("delflag").equals("N")){
					if(step.equals("pinc")){
						String checkPinC = rs.getString("pinc");
						if(checkPinC==null){
							result = "allowed";
						}else{
							result = "notallowed";
						}
					}else if(step.equals("reset")){
						String checkPinC = rs.getString("pinc");
						if(checkPinC==null){
							result = "already";
						}else{
							if(checkPinC.equals(pinc)){
								result = "allowed";
							}else{
								result = "notallowed";
							}
						}
					}else{
						result = "allowed";
					}
				}else{
					result = "deleted";
				}
			}else{
				result = "notallowed";
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	public String resetPinc(String taskno, String pinc){
		String result = "fail";
		try {
			setConn();
			String sql=" update task_list_new set pinc = null, pincDate = null, step = 0, updatedDate = now() where taskno = ? ";		
			con.setAutoCommit(false);		
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			pstmt.executeUpdate();
			sql = " update task_duedate set iscurrent = 'N' where taskno = ? ";
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, taskno);
			pstmt.executeUpdate();
			con.commit();
			pstmt.close();
			con.close();
			result = "success";
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}
	public KidpMembers loginCheck(KidpMembers km){
		km.setLogin_chk(false);
		try {
			setConn();
			String sql=""; 
			sql+=" select a.userno,a.emp_code,a.name,a.phone,a.e_mail,a.isfirst,ifnull(d1.dept_name,'') as dept1,ifnull(d2.dept_name,'') as dept2,ifnull(d3.dept_name,'') as dept3,p.pos_name ";
			sql+=" from kcpass_member a left join kcpass_dept d1 on (a.dept_id1 = d1.dept_id) ";
			sql+=" left join kcpass_dept d2 on (a.dept_id2 = d2.dept_id) ";
			sql+=" left join kcpass_dept d3 on (a.dept_id3 = d3.dept_id) ";
			sql+=" left join kcpass_pos p on (a.pos_id=p.pos_id) ";
			sql+=" where a.emp_code = ? and a.login_passwd = ? ";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1,km.getEmp_code());
			pstmt.setString(2,km.getLogin_passwd());
			rs=pstmt.executeQuery();			
			if (rs.next()){
				km.setUserno(rs.getInt("userno"));				
				km.setName(rs.getString("name"));
				km.setPhone(rs.getString("phone"));
				km.setE_mail(rs.getString("e_mail"));
				km.setPos_name(rs.getString("pos_name"));
				km.setDept1(rs.getString("dept1"));
				km.setDept2(rs.getString("dept2"));
				km.setDept3(rs.getString("dept3"));
				km.setLogin_passwd("");
				km.setLogin_chk(true);
				km.setIsFirstLogin(rs.getString("isfirst"));
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		return km;
	}
	public String changePw(String userid, String pw){
		String result = "";
		try {
			setConn();
			String sql=" update kcpass_member set login_passwd = ?, isfirst = 'n' where emp_code = ? ";	
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1, pw);			
			pstmt.setString(2, userid);		
			int r = pstmt.executeUpdate();
			if(r>0){
				result = "success";
			}else{
				result = "fail";
			}
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return result;
	}
	public ArrayList<ReportFields> getReport(String year){
		ArrayList<ReportFields> list = new ArrayList<ReportFields>();
		
		try {
			setConn();
			String sql = "SELECT *, IFNULL(ROUND((t.onTime) / t.total * 100, 1), 0) AS 'onTimeRatio', "
					+ "IFNULL(ROUND((t.step2+t.step3) / t.total * 100, 1), 0) AS 'score',"
					+ "IFNULL(ROUND(t.rate / t.rateCNT, 1), 0) AS 'rateAVG' FROM "
					+ "(SELECT DATE_FORMAT(dueDate, '%Y-%m') AS 'dueRange',COUNT(taskno) AS total, "
					+ "SUM(CASE WHEN step = '0' THEN 1 ELSE 0 END) AS 'step0',"
					+ "SUM(CASE WHEN step = '1' THEN 1 ELSE 0 END) AS 'step1',"
					+ "SUM(CASE WHEN step = '2' THEN 1 ELSE 0 END) AS 'step2',"
					+ "SUM(CASE WHEN step = '3' THEN 1 ELSE 0 END) AS 'step3',"
					+ "IFNULL(SUM(rate), 0) AS rate,"
					+ "SUM(CASE WHEN NOT ISNULL(rate) THEN 1 ELSE 0 END) AS 'rateCNT',"
					+ "IFNULL(SUM(CASE WHEN ISNULL(requestDate) THEN 0 ELSE CASE WHEN requestDate <= dueDate THEN 1 ELSE 0 END END), 0) AS 'onTime',"
					+ "GROUP_CONCAT(taskno ORDER BY taskno ASC) AS 'taskNOs' "
					+ "FROM task_list_new "
					+ "WHERE delflag = 'N' "
					+ "AND DATE_FORMAT(dueDate,'%Y-%m') <= DATE_FORMAT(now(), '%Y-%m') "
					+ "AND YEAR(dueDate) = '"+year+"' "
					+ "GROUP BY dueRange) t";
			pstmt=con.prepareStatement(sql);		
			rs = pstmt.executeQuery();
			ReportFields rf;
			while(rs.next()){
				rf = new ReportFields();
				rf.setDueRange(rs.getString("dueRange"));
				rf.setTotal(rs.getInt("total"));
				rf.setStep0(rs.getInt("step0"));
				rf.setStep1(rs.getInt("step1"));
				rf.setStep2(rs.getInt("step2"));
				rf.setStep3(rs.getInt("step3"));
				rf.setRate(rs.getInt("rate"));
				rf.setRateCNT(rs.getInt("rateCNT"));
				rf.setOnTime(rs.getInt("onTime"));
				if(rs.getString("taskNOs")!=null) rf.setTaskNOs(rs.getString("taskNOs").split(","));
				rf.setOnTimeRatio(rs.getDouble("onTimeRatio"));
				rf.setRateAVG(rs.getDouble("rateAVG"));
				try {
					rf.setDueData(getScore(rf.getDueRange()));
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				double totalScore = rs.getDouble("score");
				double totalPenalty = 0;
				for( DueData d : rf.getDueData()){
					totalScore-=d.getPenalty();
					totalPenalty+=d.getPenalty();
				}
				rf.setDuePassedCnt(rf.getDueData().size());
				rf.setScore(totalScore);
				rf.setPenalty(totalPenalty);
				list.add(rf);
			}
			rs.close();
			pstmt.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
		return list;
	}
	public ArrayList<DueData> getScore(String dueRange) throws ParseException{
		ArrayList<DueData> result = new ArrayList<DueData>();
		try {
			setConn();
			String sql = "SELECT dueDate, taskno, ( "
					+ "CASE WHEN NOT ISNULL(requestDate) THEN "
					+ "CASE WHEN DATE_FORMAT(dueDate, '%Y-%m') = DATE_FORMAT(requestDate, '%Y-%m') THEN "
					+ "DATEDIFF(requestDate, dueDate) "
					+ "ELSE CASE WHEN DATE_FORMAT(dueDate, '%Y-%m') = '"+dueRange+"' THEN "
					+ "DATEDIFF(LAST_DAY('"+dueRange+"-01'), dueDate) "
					+ "ELSE CASE WHEN DATE_FORMAT(dueDate, '%Y-%m') = DATE_FORMAT(requestDate, '%Y-%m') THEN "
					+ "DATEDIFF(requestDate, DATE_FORMAT(requestDate, '%Y-%m-01')) + 1 "
					+ "ELSE CASE WHEN requestDate > LAST_DAY('"+dueRange+"-01') THEN "
					+ "DATEDIFF(LAST_DAY('"+dueRange+"-01'), '"+dueRange+"-01') + 1 "
					+ "ELSE DATEDIFF(requestDate, DATE_FORMAT(requestDate, '%Y-%m-01')) + 1 END END END END "
					+ "ELSE CASE WHEN DATE_FORMAT(dueDate, '%Y-%m') = DATE_FORMAT(NOW(), '%Y-%m') THEN "
					+ "DATEDIFF(NOW(), dueDate) "
					+ "ELSE CASE WHEN DATE_FORMAT(dueDate, '%Y-%m') = '"+dueRange+"' THEN "
					+ "DATEDIFF(LAST_DAY('"+dueRange+"-01'), dueDate) "
					+ "ELSE CASE WHEN NOW() > LAST_DAY('"+dueRange+"-01') THEN "
					+ "DATEDIFF(LAST_DAY('"+dueRange+"-01'), '"+dueRange+"-01') + 1 "
					+ "ELSE DATEDIFF(NOW(), DATE_FORMAT(NOW(), '%Y-%m-01')) + 1 END END END END) AS 'duePassed' "
					+ "FROM taskmanager.task_list_new "
					+ "WHERE delflag = 'N' "
					+ "AND (DATE_FORMAT(dueDate, '%Y-%m') = '"+dueRange+"' or "
					+ "DATE_FORMAT(requestDate, '%Y-%m') = '"+dueRange+"' or "
					+ "(isNull(requestDate) and DATE_FORMAT(dueDate, '%Y-%m') <= '"+dueRange+"') or "
					+ "(not isNull(requestDate) "
					+ "and DATE_FORMAT(dueDate, '%Y-%m') != DATE_FORMAT(requestDate, '%Y-%m') "
					+ "and DATE_FORMAT(dueDate, '%Y-%m') <='"+dueRange+"')) "
					+ "order by dueDate asc";
			pstmt=con.prepareStatement(sql);
			rs2 = pstmt.executeQuery();
			DateFormat formatter = new SimpleDateFormat("yyyy-MM");
			DueData dt;
			while(rs2.next()){
				dt = new DueData();
				java.util.Date date1 = (java.util.Date)formatter.parse(dueRange);
				java.util.Date date2 = (java.util.Date)formatter.parse(rs2.getString("dueDate"));
				int compare = date1.compareTo(date2);
		        if(compare > 0){
		        	dt.setGubun((date2.getMonth()+1)+"�썡");
		        	dt.setPassed(1);
		        }else if(compare == 0){
		        	dt.setGubun("�떦�썡");
		        	dt.setPassed(0);
		        }
		        dt.setDays(rs2.getDouble("duePassed"));
		        if(dt.getDays() > 0 && compare >= 0){
		        	double temp = Math.ceil(dt.getDays()/5)*0.5;
		        	dt.setPenalty(temp);
		        	dt.setTaskno(rs2.getString("taskno"));
		        	result.add(dt);
		        }
			}
			rs2.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			try {				
				con.rollback();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			e.printStackTrace();
		}
			
		return result;
	}
	public static void main(String[] args) {
		TaskDBCon db = new TaskDBCon();		
		System.out.println(db.MD5("1111"));
	}
	public String MD5(String md5) {
		try {
			java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
			byte[] array = md.digest(md5.getBytes());
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < array.length; ++i) {
				sb.append(Integer.toHexString((array[i] & 0xFF) | 0x100).substring(1, 3));
			}
			return sb.toString();
		} catch (java.security.NoSuchAlgorithmException e) {
		}
		return null;
	}
}
