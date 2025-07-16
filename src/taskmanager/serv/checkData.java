package taskmanager.serv;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import taskmanager.util.Chnull;
import taskmanager.util.TaskDBCon;

/**
 * Servlet implementation class checkData
 */
@WebServlet("/checkData")
public class checkData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public checkData() {
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
		TaskDBCon db = new TaskDBCon();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		switch(sts){
	        case "taskpw" :
	        	String pw = Chnull.chNull(request.getParameter("pw"));
	    		out.print(db.checkTaskPw(taskno, pw));
	            break;
	        case "total" :
	        	out.print(db.getTotal());
	        	break;
	        case "checkstep":
	        	String step = Chnull.chNull(request.getParameter("step"));
	        	String pinc = Chnull.chNull(request.getParameter("pinc"));
	        	out.print(db.checkStep(taskno, step, pinc));
	        	break;
	        case "manualConfirm":
	        	out.print(db.manualConfirm(taskno));
	        	break;
	        case "step":
	        	out.print(db.getStep(taskno));
	        	break;
	    }
	}

}
