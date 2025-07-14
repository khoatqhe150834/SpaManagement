package model;

public class ServiceMaterial {
    private int serviceMaterialId;
    private int serviceId;
    private int inventoryItemId;
    private int quantityPerService;

    public ServiceMaterial() {}

    public ServiceMaterial(int serviceMaterialId, int serviceId, int inventoryItemId, int quantityPerService) {
        this.serviceMaterialId = serviceMaterialId;
        this.serviceId = serviceId;
        this.inventoryItemId = inventoryItemId;
        this.quantityPerService = quantityPerService;
    }

    public int getServiceMaterialId() { return serviceMaterialId; }
    public void setServiceMaterialId(int serviceMaterialId) { this.serviceMaterialId = serviceMaterialId; }
    public int getServiceId() { return serviceId; }
    public void setServiceId(int serviceId) { this.serviceId = serviceId; }
    public int getInventoryItemId() { return inventoryItemId; }
    public void setInventoryItemId(int inventoryItemId) { this.inventoryItemId = inventoryItemId; }
    public int getQuantityPerService() { return quantityPerService; }
    public void setQuantityPerService(int quantityPerService) { this.quantityPerService = quantityPerService; }

    @Override
    public String toString() {
        return "ServiceMaterial{" +
                "serviceMaterialId=" + serviceMaterialId +
                ", serviceId=" + serviceId +
                ", inventoryItemId=" + inventoryItemId +
                ", quantityPerService=" + quantityPerService +
                '}';
    }
} 