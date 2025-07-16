package taskmanager.serv;

import java.io.File;    
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import taskmanager.util.TaskDBCon;

/**
 * Servlet implementation class getTaskList
 */
@WebServlet("/saveTaskList")
public class saveTaskList extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public saveTaskList() {
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
        
        //TaksList Class
        HashMap<String, String> ts = new HashMap<String, String>();
        HashMap<String, ArrayList<String>> fl = new HashMap<String, ArrayList<String>>();
        ArrayList<String> orgname = new ArrayList<String>();
        ArrayList<String> fname = new ArrayList<String>();
        ArrayList<String> fsize = new ArrayList<String>();
        ArrayList<String> fpath = new ArrayList<String>();
        
        try {
            
            //디스크상의 프로젝트 실제 경로얻기
            String contextRootPath = this.getServletContext().getRealPath("/"); 
            //1. 메모리나 파일로 업로드 파일 보관하는 FileItem의 Factory 설정
            DiskFileItemFactory diskFactory = new DiskFileItemFactory(); //디스크 파일 아이템 공장
            diskFactory.setSizeThreshold(4096); //업로드시 사용할 임시 메모리
            diskFactory.setRepository(new File(contextRootPath + "/attachfiles/temp")); //임시저장폴더
            //System.out.println(contextRootPath);
            //2. 업로드 요청을 처리하는 ServletFileUpload생성
            ServletFileUpload upload = new ServletFileUpload(diskFactory);
            upload.setSizeMax(10 * 1024 * 1024); //20MB : 전체 최대 업로드 파일 크기
           
            //3. 업로드 요청파싱해서 FileItem 목록구함​​
            List<FileItem> items = upload.parseRequest(request); 

            Iterator<FileItem> iter = items.iterator(); //반복자(Iterator)로 받기​            
            while(iter.hasNext()) { //반목문으로 처리​    
                FileItem item = (FileItem) iter.next(); //아이템 얻기
                 //4. FileItem이 폼 입력 항목인지 여부에 따라 알맞은 처리
                if(item.isFormField()){ //파일이 아닌경우
                    processFormField(ts, item);
                } else { //파일인 경우
                    processUploadFile(orgname,fname,fpath,fsize,item,contextRootPath);
                }
            }
            
        } catch(Exception e) {
            out.println("<PRE>");
            e.printStackTrace(out);
            out.println("</PRE>");
        }
        fl.put("orgname", orgname);
        fl.put("fname",fname);
        fl.put("fpath",fpath);
        fl.put("fsize",fsize);
        TaskDBCon db = new TaskDBCon();
        String sts = ts.get("sts");
        String result = "";
        switch (sts){
	    	case "new":
	    		ts.put("type", "T");
	    		result = db.insTaskList(ts, fl);
	    		break;
	    	case "edit":
	    		ts.put("type", "T");
	    		result = db.uptTaskList(ts, fl);
	    		break;
	    	case "requestForm":
	    		HttpSession session = request.getSession();
	    		if(!session.isNew()){
	    			ts.put("type", "R");
		    		ts.put("content", ts.get("requestMsg"));
		    		result = db.uptTaskList(ts, fl);
	    		}
	    		break;
	    	case "confirmForm":
	    		ts.put("type", "F");
	    		ts.put("content", ts.get("feedback"));
	    		result = db.uptTaskList(ts, fl);
	    		break;
	    }	
        out.print(result);
    }

    //업로드한 정보가 파일인경우 처리
    private void processUploadFile(ArrayList<String> orgname,ArrayList<String> fname,ArrayList<String> fpath,ArrayList<String> fsize, FileItem item, String contextRootPath) throws Exception {
		//String name = item.getFieldName(); //파일의 필드 이름 얻기
    	//String type = item.getContentType();
		String fileName = item.getName(); //파일명 얻기	
		long fileSize = item.getSize(); //파일의 크기 얻기
		String curYear = String.valueOf(Calendar.getInstance().get(Calendar.YEAR));
		String filepath = contextRootPath + "/attachfiles/"+curYear+"/";
		File folder = new File(filepath);
		if(!folder.exists()){
			//폴더가 존재하지 않으면 생성...
			folder.mkdirs();
		}
		
		//유니크한 업로드 파일명 생성...		
		String uploadedFileName = makeUniqueFileName(filepath,fileName);		
		//System.out.println(uploadedFileName);
		
		//저장할 절대 경로로 파일 객체 생성
		File uploadedFile = new File(filepath + uploadedFileName);
		System.out.println(filepath);
		item.write(uploadedFile); //파일 저장
		
		//========== 디비 저장 용 변수 세  =========//
		/*
		out.println("파라미터 이름:" + name + "<BR>");
		out.println("파일 이름:" + fileName + "<BR>");		
		out.println("파일 사이즈:" + fileSize + "<BR>");		      
		
		out.println("<HR>");
		out.println("실제저장경로 : "+uploadedFile.getPath()+"<BR>");
		out.println("<HR>");
		*/
		orgname.add(fileName);
		fname.add(uploadedFileName);
		fpath.add("/attachfiles/"+curYear+"/");
		fsize.add(String.valueOf(fileSize));
    }
    
    private void processFormField(HashMap<String, String> ts, FileItem item) 
        throws Exception{
        String name = item.getFieldName(); //필드명 얻기
        String value = item.getString("UTF-8"); //UTF-8형식으로 필드에 대한 값읽기
        if(name.equals("pw")){
        	ts.put(name, MD5(value));
        }else{
        	ts.put(name, value);
        }
        
    }
    
	public static String makeUniqueFileName(String serverPath, String fileName) {
		String extension = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
		String uniqueFileName = null;
		boolean flag = true;
		while (flag) {
			uniqueFileName = getUniqueFileName();
			flag = doCheckFileExists(serverPath + uniqueFileName + extension);
		}
		return uniqueFileName + extension;
	}

	private static boolean doCheckFileExists(String fullPath) {
		return new File(fullPath).exists();
	}

	private static String getUniqueFileName() { 
		return  UUID.randomUUID().toString();
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