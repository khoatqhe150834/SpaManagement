package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class SpaInformation {
    private int spaId;
    private String name;
    private String addressLine1;
    private String addressLine2;
    private String city;
    private String postalCode;
    private String country;
    private String phoneNumberMain;
    private String phoneNumberSecondary;
    private String emailMain;
    private String emailSecondary;
    private String websiteUrl;
    private String logoUrl;
    private String taxIdentificationNumber;
    private String cancellationPolicy;
    private String bookingTerms;
    private String aboutUsShort;
    private String aboutUsLong;
    private BigDecimal vatPercentage;
    private int defaultAppointmentBufferMinutes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Getters and Setters
    public int getSpaId() {
        return spaId;
    }
    public void setSpaId(int spaId) {
        this.spaId = spaId;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getAddressLine1() {
        return addressLine1;
    }
    public void setAddressLine1(String addressLine1) {
        this.addressLine1 = addressLine1;
    }
    public String getAddressLine2() {
        return addressLine2;
    }
    public void setAddressLine2(String addressLine2) {
        this.addressLine2 = addressLine2;
    }
    public String getCity() {
        return city;
    }
    public void setCity(String city) {
        this.city = city;
    }
    public String getPostalCode() {
        return postalCode;
    }
    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }
    public String getCountry() {
        return country;
    }
    public void setCountry(String country) {
        this.country = country;
    }
    public String getPhoneNumberMain() {
        return phoneNumberMain;
    }
    public void setPhoneNumberMain(String phoneNumberMain) {
        this.phoneNumberMain = phoneNumberMain;
    }
    public String getPhoneNumberSecondary() {
        return phoneNumberSecondary;
    }
    public void setPhoneNumberSecondary(String phoneNumberSecondary) {
        this.phoneNumberSecondary = phoneNumberSecondary;
    }
    public String getEmailMain() {
        return emailMain;
    }
    public void setEmailMain(String emailMain) {
        this.emailMain = emailMain;
    }
    public String getEmailSecondary() {
        return emailSecondary;
    }
    public void setEmailSecondary(String emailSecondary) {
        this.emailSecondary = emailSecondary;
    }
    public String getWebsiteUrl() {
        return websiteUrl;
    }
    public void setWebsiteUrl(String websiteUrl) {
        this.websiteUrl = websiteUrl;
    }
    public String getLogoUrl() {
        return logoUrl;
    }
    public void setLogoUrl(String logoUrl) {
        this.logoUrl = logoUrl;
    }
    public String getTaxIdentificationNumber() {
        return taxIdentificationNumber;
    }
    public void setTaxIdentificationNumber(String taxIdentificationNumber) {
        this.taxIdentificationNumber = taxIdentificationNumber;
    }
    public String getCancellationPolicy() {
        return cancellationPolicy;
    }
    public void setCancellationPolicy(String cancellationPolicy) {
        this.cancellationPolicy = cancellationPolicy;
    }
    public String getBookingTerms() {
        return bookingTerms;
    }
    public void setBookingTerms(String bookingTerms) {
        this.bookingTerms = bookingTerms;
    }
    public String getAboutUsShort() {
        return aboutUsShort;
    }
    public void setAboutUsShort(String aboutUsShort) {
        this.aboutUsShort = aboutUsShort;
    }
    public String getAboutUsLong() {
        return aboutUsLong;
    }
    public void setAboutUsLong(String aboutUsLong) {
        this.aboutUsLong = aboutUsLong;
    }
    public BigDecimal getVatPercentage() {
        return vatPercentage;
    }
    public void setVatPercentage(BigDecimal vatPercentage) {
        this.vatPercentage = vatPercentage;
    }
    public int getDefaultAppointmentBufferMinutes() {
        return defaultAppointmentBufferMinutes;
    }
    public void setDefaultAppointmentBufferMinutes(int defaultAppointmentBufferMinutes) {
        this.defaultAppointmentBufferMinutes = defaultAppointmentBufferMinutes;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
} 