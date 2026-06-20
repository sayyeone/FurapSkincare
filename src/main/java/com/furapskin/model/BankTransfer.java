package com.furapskin.model;

public class BankTransfer extends Payment {
    private String buktiBayar;

    public BankTransfer() {
        this.setPaymentMethod("BANK_TRANSFER");
    }

    public String getBuktiBayar() { return buktiBayar; }
    public void setBuktiBayar(String buktiBayar) { this.buktiBayar = buktiBayar; }

    @Override
    public void prosesPembayaran() {
        // Immediate PENDING for mock-based architecture
        this.setStatus(PaymentStatus.PENDING);
        // Dummy representation info
        this.setBuktiBayar("dummy_bank_instructions.txt");
    }
}
