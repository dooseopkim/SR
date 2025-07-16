package taskmanager.util;

import java.io.UnsupportedEncodingException;

public class Chnull {
// Chnull.chAKor() ==> �ѱ۹迭ó��, null-->"" ..
	public static String[] chAKor(String[] s){
		String[] ret={""};
		if(s!=null){
			ret=new String[s.length];
			for(int idx=0;idx<s.length;idx++){
				ret[idx]=chKor(s[idx]);
			}	
		}
			
	return ret;
	}
		
	public static String chKor(String s){
		String ret="";
		if(s!=null){
			try {
				ret=new String(s.getBytes("8859_1"),"utf-8");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				ret="";
			}
		}	
		return ret;
	}
	
	//��Ĺ8.0 �ѱ� ���� --null ���� ����ֱ�..
	//�迭..
	public static String[] chAnull(String[] s){
		String[] ret=new String[s.length];
		if(s!=null){
			for(int idx=0;idx<s.length;idx++){
				ret[idx]=chNull(s[idx]);
			}	
		}
			
	return ret;
	}	
	//���ڿ�..
	public static String chNull(String s){
		String ret="";
		if(s!=null){
			ret=s;
		}	
		return ret;
	}
	
	// null ==> 0, ���������ڹ迭==> ����ó��
		public static int[] chAInt(String s[]){
			int[] ret={0};     //new int[s.length]
			if(s!=null){
				ret=new int[s.length];
				for(int idx=0;idx<s.length;idx++){
					ret[idx]=chInt(s[idx]);
				}
			}
			return ret;
		}
	// null ==> 0, ���������ڿ�==> ����ó��
	public static int chInt(String s){
		int ret=0;
		if(s!=null){
			try{
				ret=Integer.parseInt(s);
			}catch(Exception e){
				System.out.println(e.getMessage());
			}
		}
		return ret;
	}
	// null ==> 0, ���������ڿ�==> �Ǽ�ó��
	public static double chDbl(String s){
		double ret=0;
		if(s!=null){
			try{
				ret=Double.parseDouble(s);
			}catch(Exception e){
				System.out.println(e.getMessage());
			}
		}
		return ret;
	}	
	
}
