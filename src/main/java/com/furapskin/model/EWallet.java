package com.furapskin.model;

import java.util.UUID;

public class EWallet extends Payment {
    private String transactionId;

    public EWallet() {
        this.setPaymentMethod("E_WALLET");
    }

    public String getTransactionId() { return transactionId; }
    public void setTransactionId(String transactionId) { this.transactionId = transactionId; }

    @Override
    public void prosesPembayaran() {
        // Immediate PENDING for mock-based architecture
        this.setStatus(PaymentStatus.PENDING);
        // Generate dummy transaction ID
        this.setTransactionId("EWALLET-TX-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
    }
}
