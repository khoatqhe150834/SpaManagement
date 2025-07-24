package model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Model cho quy tắc đổi điểm thưởng (reward_point_rules)
 */
public class RewardPointRule {
    private Integer ruleId;
    private Integer moneyPerPoint;
    private Date startDate;
    private Date endDate;
    private Boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String note;

    public RewardPointRule() {}

    public Integer getRuleId() { return ruleId; }
    public void setRuleId(Integer ruleId) { this.ruleId = ruleId; }

    public Integer getMoneyPerPoint() { return moneyPerPoint; }
    public void setMoneyPerPoint(Integer moneyPerPoint) { this.moneyPerPoint = moneyPerPoint; }

    public Date getStartDate() { return startDate; }
    public void setStartDate(Date startDate) { this.startDate = startDate; }

    public Date getEndDate() { return endDate; }
    public void setEndDate(Date endDate) { this.endDate = endDate; }

    public Boolean getIsActive() { return isActive; }
    public void setIsActive(Boolean isActive) { this.isActive = isActive; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
} 