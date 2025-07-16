package taskmanager.serv;

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import taskmanager.util.Chnull;

/**
 * Servlet implementation class fileDownLoad
 */
@WebServlet("/fileDownLoad")
public class fileDownLoad extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public fileDownLoad() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub		
		request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();		 
		
        // 실제 파일명
        String orgname = Chnull.chNull(request.getParameter("orgname"));
        // 서버에 실제 저장된 파일명
        String filename = Chnull.chNull(request.getParameter("filename"));
        String filepath = Chnull.chNull(request.getParameter("filepath"));
        
        // CSV 다운로드 파일
        String csvfile = Chnull.chNull(request.getParameter("csvfile"));
	    // 파일 업로드된 경로	    
	    String savePath = request.getSession().getServletContext().getRealPath(filepath);
	    
	    InputStream in = null;
	    OutputStream os = null;
	    File file = null;
	    boolean skip = false;
	    String client = "";
	 
	    try{
	        // 파일을 읽어 스트림에 담기
	        try{
	        	if(csvfile.equals("")){
	        		file = new File(savePath, filename);
	        	}else{
	        		file = new File(csvfile);
	        		orgname = Chnull.chNull(request.getParameter("csvfileName"))+".csv";
	        	}
	            in = new FileInputStream(file);
	        }catch(FileNotFoundException fe){
	            skip = true;
	        }
	         
	        client = request.getHeader("User-Agent");
	 
	        // 파일 다운로드 헤더 지정
	        response.reset() ;
	        response.setContentType("application/octet-stream");
	        response.setHeader("Content-Description", "JSP Generated Data");	 
	 
	        if(!skip){	 
	             
	            // IE
	            if(client.indexOf("MSIE") != -1 || client.indexOf("Trident") !=-1){
	                response.setHeader ("Content-Disposition", "attachment; filename="+new String(orgname.getBytes("KSC5601"),"ISO8859_1"));
	 
	            }else{
	                // 한글 파일명 처리
	                orgname = new String(orgname.getBytes("utf-8"),"iso-8859-1");
	 
	                response.setHeader("Content-Disposition", "attachment; filename=\"" + orgname + "\"");
	                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");
	            }  
	             
	            response.setHeader ("Content-Length", ""+file.length() );
	 
	            os = response.getOutputStream();
	            byte b[] = new byte[(int)file.length()];
	            int leng = 0;
	             
	            while( (leng = in.read(b)) > 0 ){
	                os.write(b,0,leng);
	            }
	 
	        }else{
	            response.setContentType("text/html;charset=UTF-8");
	            out.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
	        }
	         
	        in.close();
	        os.close();
	    }catch(Exception e){
	      e.printStackTrace();
	    }
	}

}
