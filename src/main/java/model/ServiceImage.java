/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class ServiceImage {
    private int id;
    private int serviceId;
    private String imageUrl;

    public ServiceImage() {
    }

    public ServiceImage(int serviceId, String imageUrl) {
        this.serviceId = serviceId;
        this.imageUrl = imageUrl;
    }

    public ServiceImage(int id, int serviceId, String imageUrl) {
        this.id = id;
        this.serviceId = serviceId;
        this.imageUrl = imageUrl;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }
    
    
    
}
