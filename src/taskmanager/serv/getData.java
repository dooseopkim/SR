package taskmanager.serv;

import java.io.IOException; 
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

import taskmanager.util.Chnull;
import taskmanager.util.TaskDBCon;

/**
 * Servlet implementation class MemDataAjax
 */
@WebServlet("/getData")
public class getData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getData() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String sts = Chnull.chNull(request.getParameter("sts"));
		String taskno = Chnull.chNull(request.getParameter("taskno"));
		String type = Chnull.chNull(request.getParameter("type"));
		TaskDBCon db = new TaskDBCon();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		switch(sts){
	        case "mem" :
	        	String name = Chnull.chNull(request.getParameter("name"));
	        	String wh = Chnull.chNull(request.getParameter("wh"));
	    		out.print(new Gson().toJson(db.getMember(name, wh)));
	            break;
	        case "sphere" : 
	        	out.print(db.getSphere());
	            break;
	        case "duedate" : 
	        	out.print(db.getDueDate(taskno));
	            break;    
	        case "list" :
	        	String startDate = Chnull.chNull(request.getParameter("startDate"));
	        	String endDate = Chnull.chNull(request.getParameter("endDate"));
	        	String step = Chnull.chNull(request.getParameter("step"));
	        	String select = Chnull.chNull(request.getParameter("select"));
	        	String text = Chnull.chNull(request.getParameter("text"));
	        	String sphere = Chnull.chNull(request.getParameter("sphere"));
	        	String dateSelect = Chnull.chNull(request.getParameter("dateSelect"));
	        	String dueDate = Chnull.chNull(request.getParameter("dueDate"));
	        	String op = Chnull.chNull(request.getParameter("op"));
	        	String always = Chnull.chNull(request.getParameter("always"));
	        	out.print(db.getTaskList(dueDate, op, dateSelect, startDate, endDate, step, select, text, sphere, always));
	            break;
	        case "content" :	        	
	        	out.print(db.getContents(taskno, type));
	            break;  
	        case "contentfiles" :
	        	String msgno = Chnull.chNull(request.getParameter("msgno"));
	        	out.print(db.getFileList(msgno));
	        	break;
	        case "report":
	        	String year = Chnull.chNull(request.getParameter("year"));
	        	out.println(new Gson().toJson(db.getReport(year)));
	        	break;
	        case "task":
	        	out.print(db.getTask(taskno));
	        	break;
	        case "report_list":
	        	String taskNOs = Chnull.chNull(request.getParameter("taskNOs"));
	        	out.print(db.getReportList(taskNOs));
	        	break;
	    }
		
	}
}
