package model;

import java.sql.Timestamp;

/**
 * Model cho lịch sử đổi điểm thưởng (đổi điểm lấy phần thưởng/mã giảm giá)
 */
public class PointRedemption {
    private Integer redemptionId;
    private Integer customerId;
    private Integer pointsUsed;
    private String rewardType; // Loại phần thưởng: VOUCHER, GIFT, DISCOUNT_CODE...
    private String rewardValue; // Giá trị phần thưởng (mã code, tên quà...)
    private Timestamp redeemedAt;
    private String status; // PENDING, SUCCESS, FAILED
    private String note;

    public PointRedemption() {
        this.redeemedAt = new Timestamp(System.currentTimeMillis());
        this.status = "SUCCESS";
    }

    public Integer getRedemptionId() { return redemptionId; }
    public void setRedemptionId(Integer redemptionId) { this.redemptionId = redemptionId; }

    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }

    public Integer getPointsUsed() { return pointsUsed; }
    public void setPointsUsed(Integer pointsUsed) { this.pointsUsed = pointsUsed; }

    public String getRewardType() { return rewardType; }
    public void setRewardType(String rewardType) { this.rewardType = rewardType; }

    public String getRewardValue() { return rewardValue; }
    public void setRewardValue(String rewardValue) { this.rewardValue = rewardValue; }

    public Timestamp getRedeemedAt() { return redeemedAt; }
    public void setRedeemedAt(Timestamp redeemedAt) { this.redeemedAt = redeemedAt; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
} 