package taskmanager.vo;

public class KidpMembers {
	private int userno;
	private String emp_code;	
	private String name;
	private String phone;
	private String e_mail;
	private String dept1;
	private String dept2;
	private String dept3;
	private String pos_name;
	private String login_passwd;
	private boolean login_chk;
	private String isFirstLogin;
	
	//get, set...
	public int getUserno() {
		return userno;
	}
	public void setUserno(int userno) {
		this.userno = userno;
	}
	public String getEmp_code() {
		return emp_code;
	}
	public void setEmp_code(String emp_code) {
		this.emp_code = emp_code;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getE_mail() {
		return e_mail;
	}
	public void setE_mail(String e_mail) {
		this.e_mail = e_mail;
	}
	public String getDept1() {
		return dept1;
	}
	public void setDept1(String dept1) {
		this.dept1 = dept1;
	}
	public String getDept2() {
		return dept2;
	}
	public void setDept2(String dept2) {
		this.dept2 = dept2;
	}
	public String getDept3() {
		return dept3;
	}
	public void setDept3(String dept3) {
		this.dept3 = dept3;
	}
	public String getPos_name() {
		return pos_name;
	}
	public void setPos_name(String pos_name) {
		this.pos_name = pos_name;
	}
	public String getLogin_passwd() {
		return login_passwd;
	}
	public void setLogin_passwd(String login_passwd) {
		this.login_passwd = login_passwd;
	}
	public boolean isLogin_chk() {
		return login_chk;
	}
	public void setLogin_chk(boolean login_chk) {
		this.login_chk = login_chk;
	}
	public String getIsFirstLogin() {
		return isFirstLogin;
	}
	public void setIsFirstLogin(String isFirstLogin) {
		this.isFirstLogin = isFirstLogin;
	}
}
