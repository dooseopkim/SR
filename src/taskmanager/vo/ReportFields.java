package taskmanager.vo;

import java.util.ArrayList;

public class ReportFields {
	String dueRange;
	double score;
	int total;
	int step0; 
	int step1; 
	int step2;  
	int step3;  
	int rate; 
	int rateCNT; 
	int onTime; 
	String[] taskNOs; 
	double onTimeRatio; 
	double rateAVG;
	double penalty;	
	ArrayList<DueData> dueData;
	int duePassedCnt;
	public String getDueRange() {
		return dueRange;
	}
	public void setDueRange(String dueRange) {
		this.dueRange = dueRange;
	}
	public double getScore() {
		return score;
	}
	public void setScore(double score) {
		this.score = score;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public int getStep0() {
		return step0;
	}
	public void setStep0(int step0) {
		this.step0 = step0;
	}
	public int getStep1() {
		return step1;
	}
	public void setStep1(int step1) {
		this.step1 = step1;
	}
	public int getStep2() {
		return step2;
	}
	public void setStep2(int step2) {
		this.step2 = step2;
	}
	public int getStep3() {
		return step3;
	}
	public void setStep3(int step3) {
		this.step3 = step3;
	}
	public int getRate() {
		return rate;
	}
	public void setRate(int rate) {
		this.rate = rate;
	}
	public int getRateCNT() {
		return rateCNT;
	}
	public void setRateCNT(int rateCNT) {
		this.rateCNT = rateCNT;
	}
	public int getOnTime() {
		return onTime;
	}
	public void setOnTime(int onTime) {
		this.onTime = onTime;
	}
	public String[] getTaskNOs() {
		return taskNOs;
	}
	public void setTaskNOs(String[] taskNOs) {
		this.taskNOs = taskNOs;
	}
	public double getOnTimeRatio() {
		return onTimeRatio;
	}
	public void setOnTimeRatio(double onTimeRatio) {
		this.onTimeRatio = onTimeRatio;
	}
	public double getRateAVG() {
		return rateAVG;
	}
	public void setRateAVG(double rateAVG) {
		this.rateAVG = rateAVG;
	}
	public double getPenalty() {
		return penalty;
	}
	public void setPenalty(double penalty) {
		this.penalty = penalty;
	}
	public ArrayList<DueData> getDueData() {
		return dueData;
	}
	public void setDueData(ArrayList<DueData> dueData) {
		this.dueData = dueData;
	}
	public int getDuePassedCnt() {
		return duePassedCnt;
	}
	public void setDuePassedCnt(int duePassedCnt) {
		this.duePassedCnt = duePassedCnt;
	}
}
