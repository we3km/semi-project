package com.kh.itda.common.vo;

public class File {
    private int fileId;
    private int pathNum;
    private String fileName;
    private int refNo;           // CS_NUM (문의글 번호)
    private int fileAssortment;  // 7 for 문의하기
    
	public File(int fileId, int pathNum, String fileName, int refNo, int fileAssortment) {
		super();
		this.fileId = fileId;
		this.pathNum = pathNum;
		this.fileName = fileName;
		this.refNo = refNo;
		this.fileAssortment = fileAssortment;
	}
	
	public File() {
	}

	public int getFileId() {
		return fileId;
	}

	public void setFileId(int fileId) {
		this.fileId = fileId;
	}

	public int getPathNum() {
		return pathNum;
	}

	public void setPathNum(int pathNum) {
		this.pathNum = pathNum;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public int getRefNo() {
		return refNo;
	}

	public void setRefNo(int refNo) {
		this.refNo = refNo;
	}

	public int getFileAssortment() {
		return fileAssortment;
	}

	public void setFileAssortment(int fileAssortment) {
		this.fileAssortment = fileAssortment;
	}
    
}