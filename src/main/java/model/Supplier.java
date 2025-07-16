package model;

public class Supplier {
    private int supplierId;
    private String name;
    private String contactInfo;
    private boolean isActive;

    public Supplier() {}

    public Supplier(int supplierId, String name, String contactInfo, boolean isActive) {
        this.supplierId = supplierId;
        this.name = name;
        this.contactInfo = contactInfo;
        this.isActive = isActive;
    }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }

    @Override
    public String toString() {
        return "Supplier{" +
                "supplierId=" + supplierId +
                ", name='" + name + '\'' +
                ", contactInfo='" + contactInfo + '\'' +
                ", isActive=" + isActive +
                '}';
    }
} 