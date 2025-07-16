package taskmanager.serv;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import taskmanager.util.Chnull;
import taskmanager.util.TaskDBCon;

/**
 * Servlet implementation class updateData
 */
@WebServlet("/updateData")
public class updateData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public updateData() {
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
		String pinc = Chnull.chNull(request.getParameter("pinc"));
		String due = Chnull.chNull(request.getParameter("due"));
		String dueDate = Chnull.chNull(request.getParameter("dueDate"));
		String sphere = Chnull.chNull(request.getParameter("sphere"));
		TaskDBCon db = new TaskDBCon();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		HttpSession session = request.getSession();
		switch(sts){
			case "delete" :
	        	out.print(db.deleteTask(taskno));
	        	break;
	        case "delfile" :
	        	String fileno = Chnull.chNull(request.getParameter("fileno"));
	        	out.print(db.deleteFile(taskno, fileno));
	        	break;
	        case "setpinc" :
	        	if(session.isNew()){
	        		out.print("fail");
	        	}else{
	        		out.print(db.setPinc(taskno, pinc, due, dueDate, sphere));
	        	}
	        	break;
	        case "resetpinc" :
	        	if(session.isNew()){
	        		out.print("fail");
	        	}else{
	        		out.print(db.resetPinc(taskno, pinc));
	        	}
	        	break;
	    }
	}

}
