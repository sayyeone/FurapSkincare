package com.furapskin.model;

public class Customer extends User {
    private String phoneNumber;
    private String address;

    public Customer() {
        this.setRole("CUSTOMER");
    }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}
