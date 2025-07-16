package taskmanager.util;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;     

public class DeptDBCon {

	private Connection con;		
	private PreparedStatement pstmt;	
	private ResultSet rs;	

	private void setConn() throws ClassNotFoundException, SQLException{		 
	    Class.forName("com.mysql.jdbc.Driver");        
	    String url = "jdbc:mysql://192.168.1.116:3306/taskmanager?useSSL=false&;useUnicode=true&characterEncoding=utf8";
	    String username = "taskmanager";
	    String password = "D@ebak12#$";
	    if(con==null){
	    	con = DriverManager.getConnection(url, username, password);
	    }	    	    
	    //System.out.println("�뵒鍮꾩젒�냽�꽦怨�!!");
	}
		
	public void getNestedList(){
		String result = "";
		try {
			setConn();			
			String sql = ""; 
			sql += " SELECT REPEAT('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;', COUNT(parent.id) - 1) as indent, node.name ";
			sql += " FROM nested_dept AS node,nested_dept AS parent ";
			sql += " WHERE node.lft BETWEEN parent.lft AND parent.rgt ";
			sql += " GROUP BY node.id ";
			sql += " ORDER BY node.lft ";			
			pstmt = con.prepareStatement(sql);			
			rs=pstmt.executeQuery();
			while( rs.next() ){	
				result+= "<tr><td>"+rs.getString("indent")+"<button class='btn btn-default btn-sm'>"+rs.getString("name") + "</button></td></tr>";				
			}
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("<table>"+result+"</table>");
	}
	
	public String getNestedTree(){
		StringBuffer sbf = new StringBuffer();
		try {
			setConn();			
			String sql = ""; 
			sql+=" SELECT node.id, node.Name, (COUNT( parent.id ) -1) AS depth FROM nested_dept AS node "; 
			sql+=" CROSS JOIN nested_dept AS parent "; 
			sql+=" WHERE node.lft BETWEEN parent.lft AND parent.rgt ";
			sql+=" GROUP BY node.id "; 
			sql+=" ORDER BY node.lft ";					
			pstmt = con.prepareStatement(sql);			
			rs=pstmt.executeQuery();	
			
			ArrayList<Integer> id = new ArrayList<Integer>();
			ArrayList<Integer> depth = new ArrayList<Integer>();
			ArrayList<String> name = new ArrayList<String>();	
			
			while (rs.next()) {			    
			    id.add(rs.getInt("id"));
			    depth.add(rs.getInt("depth"));
			    name.add(rs.getString("name"));				
			}			
			int currDepth = 0;
			int lastNodeIndex = id.size();
			boolean isFirst = true;
			// Level down? (or the first)
			for(int i=0, l = id.size();i<l;i++){
				if(id.get(i)==1){
					sbf.append("<ul class='treeView'>");
				}else{
					if(depth.get(i)>currDepth){
						if(isFirst){
							sbf.append("<ul class='collapsibleList'>");
							isFirst = false;
						}else{
							sbf.append("<ul>");
						}				    	
				    }
				}				
			    
			    //Level up?
			    if(depth.get(i)<currDepth){
			    	sbf.append(String.join("", Collections.nCopies(currDepth-depth.get(i), "</ul></li>")));
			    }
			   
			    sbf.append("<li>"+name.get(i)+"&nbsp;<input type='checkbox' class='chb' id='"+id.get(i)+"'/>");
			    
			    // Check if there's children
			    if ((id.get(i) != lastNodeIndex && depth.get(i+1) <= depth.get(i)) || id.get(i)==lastNodeIndex) {
			    	sbf.append("</li>"); // If not, close the <li>
			    }
			    
			    // Adjust current depth
			    currDepth = depth.get(i);			    
			    if (id.get(i) == lastNodeIndex) {
			    	sbf.append("</ul>"+String.join("", Collections.nCopies(currDepth, "</li></ul>")));
			    }		
			}		    
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sbf.toString();
	}
	
	public void getAuthDept(int id){
		String result = "";
		try {
			setConn();			
			String sql = ""; 
			sql+=" SELECT parent.id, parent.name, parent.auth ";
			sql+=" FROM nested_dept AS node, nested_dept AS parent ";
			sql+=" WHERE node.lft BETWEEN parent.lft AND parent.rgt ";
			sql+=" AND node.id = ? ";
			sql+=" ORDER BY parent.lft desc ";	
			pstmt = con.prepareStatement(sql);	
			pstmt.setInt(1,id);
			rs=pstmt.executeQuery();
			
			while( rs.next() ){			
				if(rs.getString("auth").equals("y")){
					result = rs.getInt("id") + " : " + rs.getString("name");;
					break;
				}
			}
			System.out.println(result);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void getRegDept(int id){
		String result = "";
		try {
			setConn();			
			String sql = ""; 
			sql+=" SELECT parent.name ";
			sql+=" FROM nested_dept AS node, nested_dept AS parent ";
			sql+=" WHERE node.lft BETWEEN parent.lft AND parent.rgt ";
			sql+=" AND node.id = ? ";
			sql+=" ORDER BY parent.lft asc ";
			sql+=" LIMIT 1,10 ";			
			pstmt = con.prepareStatement(sql);	
			pstmt.setInt(1,id);
			rs=pstmt.executeQuery();			
			while( rs.next() ){			
				if(result.equals("")){
					result = rs.getString("name");
				}else{
					result = result + " > " + rs.getString("name");
				}
			}
			System.out.println(result);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public static void main(String[] args) {
		DeptDBCon db = new DeptDBCon();		
		//db.getAuthDept(14);
		//db.getRegDept(10);
		//System.out.println(db.getNestedTree());
	}
}
