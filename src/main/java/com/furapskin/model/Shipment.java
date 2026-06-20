package com.furapskin.model;

import java.sql.Timestamp;

public class Shipment {
    private int id;
    private int orderId;
    private String trackingNumber;
    private String carrier;
    private ShipmentStatus status;
    private String shippingAddress;
    private Timestamp shippedDate;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getTrackingNumber() { return trackingNumber; }
    public void setTrackingNumber(String trackingNumber) { this.trackingNumber = trackingNumber; }

    public String getCarrier() { return carrier; }
    public void setCarrier(String carrier) { this.carrier = carrier; }

    public ShipmentStatus getStatus() { return status; }
    public void setStatus(ShipmentStatus status) { this.status = status; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public Timestamp getShippedDate() { return shippedDate; }
    public void setShippedDate(Timestamp shippedDate) { this.shippedDate = shippedDate; }
}
