package taskmanager.serv;

import java.io.BufferedReader;
import java.io.IOException; 
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import taskmanager.util.Chnull;
import taskmanager.util.TaskDBCon;
import taskmanager.vo.KidpMembers;

/**
 * Servlet implementation class loginCtrl
 */
@WebServlet("/loginCtrl")
public class loginCtrl extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public loginCtrl() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		StringBuffer jb = new StringBuffer();
		String line = null;
		try {
			BufferedReader reader = request.getReader();
			while ((line = reader.readLine()) != null)
				jb.append(line);
		} catch (Exception e) {}
		JsonParser parser = new JsonParser();
		JsonObject json = parser.parse(jb.toString()).getAsJsonObject();
		String status = Chnull.chNull(json.get("status").getAsString());
        HttpSession session = request.getSession();
        TaskDBCon db = new TaskDBCon();
        if(status.equals("login")){
        	String userid = Chnull.chNull(json.get("userid").getAsString());
    		String password = Chnull.chNull(json.get("password").getAsString());
    		KidpMembers km = new KidpMembers();
    		km.setEmp_code(userid);
    		km.setLogin_passwd(MD5(password));
    		KidpMembers result = new KidpMembers();
    		result = db.loginCheck(km);	
    		if(result.isLogin_chk()){    			
    			if(result.getIsFirstLogin().equals("y")){
    				out.print("first");
    			}else{
    				session.setAttribute("mem", result);
        			session.setMaxInactiveInterval(60*60*8);
    				out.print("success");
    			}
    		}else{
    			out.print("fail");
    		}
    		
        }else if(status.equals("logout")){
        	session.invalidate();
        	out.print("success");
        }else if(status.equals("change")){
        	String userid = Chnull.chNull(json.get("userid").getAsString());
        	String changepw = Chnull.chNull(json.get("changepw").getAsString());
        	out.print(db.changePw(userid, MD5(changepw)));
        }
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
		} catch (java.security.NoSuchAlgorithmException e) {}
		return null;
	}
}
