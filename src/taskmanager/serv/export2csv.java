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
 * Servlet implementation class downloadAsExcel
 */
@WebServlet("/export2csv")
public class export2csv extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public export2csv() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		TaskDBCon db = new TaskDBCon();
		response.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		PrintWriter out = response.getWriter();
		String startDate = Chnull.chNull(request.getParameter("startDate"));
    	String endDate = Chnull.chNull(request.getParameter("endDate"));
    	String step = Chnull.chNull(request.getParameter("step"));
    	String dues = Chnull.chNull(request.getParameter("dues"));
    	String pinc = Chnull.chNull(request.getParameter("pinc"));
    	String duePassed = Chnull.chNull(request.getParameter("duePassed"));
    	String select = Chnull.chNull(request.getParameter("select"));
    	String text = Chnull.chNull(request.getParameter("text"));
    	String sphere = Chnull.chNull(request.getParameter("sphere"));
    	String checked = Chnull.chNull(request.getParameter("checked"));
    	String dateSelect = Chnull.chNull(request.getParameter("dateSelect"));
    	String dueDate = Chnull.chNull(request.getParameter("dueDate"));
    	String op = Chnull.chNull(request.getParameter("op"));
    	String updated = Chnull.chNull(request.getParameter("updated"));
    	String always = Chnull.chNull(request.getParameter("always"));
    	HttpSession session = request.getSession();
    	if(!session.isNew()){
    		out.print(db.export2csv(dueDate, op, dateSelect, startDate, endDate, step, pinc, dues, select, text, sphere, checked, duePassed, updated, always));
    	}else{
    		out.print("");
    	}
	}

}
