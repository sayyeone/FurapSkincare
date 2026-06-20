<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.Order" %>
<%@ page import="com.furapskin.model.OrderItem" %>
<%@ page import="com.furapskin.model.Shipment" %>
<%@ page import="com.furapskin.model.Payment" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Invoice | FurapSkin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
        .font-serif { font-family: 'Playfair Display', serif; }
        @media print {
            .no-print { display: none !important; }
            body { background: white; }
            .print-border { border: 1px solid #e4e4e7 !important; box-shadow: none !important; }
        }
    </style>
</head>
<body class="bg-zinc-100 text-zinc-800 min-h-screen p-4 md:p-8 flex items-center justify-center antialiased">
    <%
        Order o = (Order) request.getAttribute("order");
        if (o == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
        Shipment s = o.getShipment();
        Payment p = o.getPayment();
    %>
    
    <div class="max-w-3xl w-full bg-white print-border shadow-[0_20px_50px_rgba(0,0,0,0.05)] rounded-2xl overflow-hidden relative">
        <!-- Floating Actions -->
        <div class="absolute top-6 right-6 no-print flex gap-3">
            <button onclick="window.print()" class="p-2.5 bg-zinc-100 hover:bg-zinc-200 text-zinc-600 rounded-full transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"></path></svg>
            </button>
            <button onclick="history.back()" class="p-2.5 bg-zinc-100 hover:bg-zinc-200 text-zinc-600 rounded-full transition-colors">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
            </button>
        </div>

        <!-- Header -->
        <div class="p-10 border-b border-zinc-100 flex flex-col md:flex-row justify-between items-start md:items-end gap-6 bg-[#FFF8F6]">
            <div>
                <h1 class="font-serif tracking-wide text-zinc-900 font-bold text-3xl mb-1">FurapSkin</h1>
                <p class="text-xs text-slate-500 tracking-wider uppercase font-semibold">Official Receipt</p>
            </div>
            <div class="text-left md:text-right">
                <p class="text-sm font-bold text-zinc-900">INVOICE #<%= o.getId() %></p>
                <p class="text-xs text-slate-500 mt-1"><%= sdf.format(o.getOrderDate()) %></p>
            </div>
        </div>

        <div class="p-10 space-y-8">
            <!-- Billing & Shipping Details -->
            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                <div>
                    <h3 class="text-[10px] font-bold tracking-widest text-zinc-400 uppercase mb-3">Billed To</h3>
                    <p class="font-semibold text-zinc-800 text-sm"><%= o.getCustomer().getFullName() %></p>
                    <p class="text-slate-500 text-xs mt-1"><%= o.getCustomer().getEmail() %></p>
                </div>
                <div>
                    <h3 class="text-[10px] font-bold tracking-widest text-zinc-400 uppercase mb-3">Shipping Details</h3>
                    <p class="font-medium text-zinc-800 text-sm whitespace-pre-wrap"><%= s != null ? s.getShippingAddress() : "-" %></p>
                    <% if (s != null && s.getTrackingNumber() != null) { %>
                    <div class="mt-3 inline-block px-3 py-1.5 bg-blue-50 border border-blue-100 rounded-lg">
                        <p class="text-[10px] font-bold text-blue-600 uppercase">Tracking: <%= s.getCarrier() %></p>
                        <p class="text-sm font-mono text-zinc-900"><%= s.getTrackingNumber() %></p>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- Payment Status -->
            <div class="p-4 bg-zinc-50 rounded-xl flex justify-between items-center border border-zinc-100">
                <div>
                    <p class="text-[10px] font-bold tracking-widest text-zinc-400 uppercase">Payment Method</p>
                    <p class="font-medium text-zinc-800 text-sm mt-0.5"><%= p != null ? p.getPaymentMethod().replace("_", " ") : "N/A" %></p>
                </div>
                <div class="text-right">
                    <p class="text-[10px] font-bold tracking-widest text-zinc-400 uppercase mb-1">Status</p>
                    <span class="px-2.5 py-1 bg-green-100 text-green-700 rounded text-[10px] font-bold tracking-wide uppercase">
                        <%= o.getStatus().name() %>
                    </span>
                </div>
            </div>

            <!-- Order Items -->
            <div>
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="border-b border-zinc-200">
                            <th class="py-3 text-[10px] font-bold tracking-widest text-zinc-400 uppercase">Item Description</th>
                            <th class="py-3 text-[10px] font-bold tracking-widest text-zinc-400 uppercase text-center">Qty</th>
                            <th class="py-3 text-[10px] font-bold tracking-widest text-zinc-400 uppercase text-right">Price</th>
                            <th class="py-3 text-[10px] font-bold tracking-widest text-zinc-400 uppercase text-right">Total</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-zinc-100">
                        <% for (OrderItem item : o.getItems()) { %>
                        <tr>
                            <td class="py-4 font-medium text-sm text-zinc-800"><%= item.getProduct().getName() %></td>
                            <td class="py-4 text-sm text-slate-500 text-center"><%= item.getQuantity() %></td>
                            <td class="py-4 text-sm text-slate-500 text-right">Rp <%= String.format("%,d", (int)item.getPrice()) %></td>
                            <td class="py-4 text-sm font-bold text-zinc-800 text-right">Rp <%= String.format("%,d", (int)(item.getPrice() * item.getQuantity())) %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Totals -->
            <div class="flex justify-end pt-4 border-t border-zinc-200">
                <div class="w-full md:w-1/2 space-y-3">
                    <div class="flex justify-between text-sm">
                        <span class="text-slate-500">Subtotal</span>
                        <span class="font-medium text-zinc-800">Rp <%= String.format("%,d", (int)o.getTotalAmount()) %></span>
                    </div>
                    <div class="flex justify-between text-sm">
                        <span class="text-slate-500">Shipping</span>
                        <span class="font-medium text-green-600">Free</span>
                    </div>
                    <div class="flex justify-between items-center pt-3 border-t border-zinc-200 mt-3">
                        <span class="text-sm font-bold text-zinc-900 uppercase tracking-wide">Total Paid</span>
                        <span class="font-serif text-2xl font-bold text-rose-600">Rp <%= String.format("%,d", (int)o.getTotalAmount()) %></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="bg-zinc-50 p-6 text-center border-t border-zinc-100">
            <p class="text-xs text-slate-400 font-medium tracking-wide">Thank you for shopping with FurapSkin!</p>
            <p class="text-[10px] text-slate-400 mt-1">If you have any questions, contact support@furapskin.com</p>
        </div>
    </div>
</body>
</html>
