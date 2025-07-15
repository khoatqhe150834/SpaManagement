package model;

import java.util.Date;

public class Certificate {
    private int certificateId;
    private int staffUserId;
    private String certificateName;
    private String certificateNumber;
    private Date issuedDate;
    private Date expiryDate;
    private String fileUrl;
    private String note;

    public Certificate() {
    }

    public Certificate(int certificateId, int staffUserId, String certificateName, String certificateNumber,
                       Date issuedDate, Date expiryDate, String fileUrl, String note) {
        this.certificateId = certificateId;
        this.staffUserId = staffUserId;
        this.certificateName = certificateName;
        this.certificateNumber = certificateNumber;
        this.issuedDate = issuedDate;
        this.expiryDate = expiryDate;
        this.fileUrl = fileUrl;
        this.note = note;
    }

    public int getCertificateId() {
        return certificateId;
    }

    public void setCertificateId(int certificateId) {
        this.certificateId = certificateId;
    }

    public int getStaffUserId() {
        return staffUserId;
    }

    public void setStaffUserId(int staffUserId) {
        this.staffUserId = staffUserId;
    }

    public String getCertificateName() {
        return certificateName;
    }

    public void setCertificateName(String certificateName) {
        this.certificateName = certificateName;
    }

    public String getCertificateNumber() {
        return certificateNumber;
    }

    public void setCertificateNumber(String certificateNumber) {
        this.certificateNumber = certificateNumber;
    }

    public Date getIssuedDate() {
        return issuedDate;
    }

    public void setIssuedDate(Date issuedDate) {
        this.issuedDate = issuedDate;
    }

    public Date getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(Date expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
} 