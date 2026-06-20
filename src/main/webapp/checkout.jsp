<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.Cart" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | FurapSkin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
        .font-serif { font-family: 'Playfair Display', serif; }
    </style>
</head>
<body class="bg-[#FFF8F6] text-zinc-800 min-h-screen flex flex-col antialiased">

    <!-- Premium Floating Header -->
    <div class="fixed top-0 inset-x-0 z-50 p-4">
        <header class="max-w-7xl mx-auto px-8 py-4 bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-full flex items-center justify-between transition-all duration-300">
            <a href="index.jsp" class="font-serif tracking-wide text-rose-950/80 font-medium text-2xl hover:opacity-80 transition-opacity">
                FurapSkin.
            </a>
            <nav class="hidden md:flex items-center space-x-10">
                <a href="catalog" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300">Catalog</a>
                <a href="cart.jsp" class="relative text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300 flex items-center gap-2">
                    <div class="relative">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                        <%
                            com.furapskin.model.Cart cartNav = (com.furapskin.model.Cart) session.getAttribute("cart");
                            int cartCount = 0;
                            if (cartNav != null) {
                                for (com.furapskin.model.CartItem ci : cartNav.getItems()) {
                                    cartCount += ci.getQuantity();
                                }
                            }
                            if (cartCount > 0) {
                        %>
                        <span class="absolute -top-2 -right-2 bg-rose-500 text-white text-[9px] font-bold px-1.5 py-0.5 rounded-full flex items-center justify-center min-w-[1.25rem]"><%= cartCount %></span>
                        <% } %>
                    </div>
                    Cart
                </a>
                <%
                    com.furapskin.model.User currentUser = (com.furapskin.model.User) session.getAttribute("user");
                    if (currentUser == null) {
                %>
                <a href="login.jsp" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300">Login</a>
                <a href="register.jsp" class="px-6 py-2.5 rounded-full bg-rose-50/50 border border-rose-200/50 text-rose-600/80 font-medium hover:bg-rose-100/50 transition-all duration-300 ease-in-out hover:-translate-y-0.5">
                    Sign Up
                </a>
                <% } else { %>
                <a href="<%= "ADMIN".equals(currentUser.getRole()) ? "admin_dashboard.jsp" : "customer_dashboard.jsp" %>" class="text-rose-900 font-semibold hover:text-rose-600 transition-colors duration-300">My Dashboard</a>
                <a href="<%= request.getContextPath() %>/auth/logout" class="px-6 py-2.5 rounded-full bg-zinc-100 border border-zinc-200 text-zinc-600 font-medium hover:bg-zinc-200 transition-all duration-300 ease-in-out">
                    Logout
                </a>
                <% } %>
            </nav>
        </header>
    </div>

    <!-- Ambient Blurs -->
    <div class="fixed top-1/4 -left-20 w-[400px] h-[400px] bg-rose-200/20 rounded-full blur-3xl -z-10 mix-blend-multiply pointer-events-none"></div>

    <main class="flex-grow max-w-6xl mx-auto w-full px-6 pt-32 pb-20">
        
        <div class="mb-10 text-center">
            <h1 class="font-serif tracking-tight text-zinc-900 text-4xl font-medium">Secure Checkout</h1>
            <p class="text-slate-500 font-light mt-3">Please complete your shipping and payment details.</p>
        </div>

        <%
            Cart cart = (Cart) session.getAttribute("cart");
            java.util.List<Integer> selectedIds = (java.util.List<Integer>) session.getAttribute("selectedCartItems");
            
            if (cart == null || cart.getItems().isEmpty() || selectedIds == null || selectedIds.isEmpty()) {
                response.sendRedirect("cart.jsp");
                return;
            }
            
            int totalSelectedItems = 0;
            double totalSelectedPrice = 0;
            for (com.furapskin.model.CartItem item : cart.getItems()) {
                if (selectedIds.contains(item.getProduct().getId())) {
                    totalSelectedItems += item.getQuantity();
                    totalSelectedPrice += item.getSubtotal();
                }
            }
            
            if (totalSelectedItems == 0) {
                response.sendRedirect("cart.jsp");
                return;
            }
        %>

        <% if ("true".equals(request.getParameter("error"))) { %>
            <div class="mb-8 p-4 bg-red-50 border border-red-200 text-red-600 rounded-2xl text-center text-sm font-medium shadow-sm">
                Error processing your order. Please try again or check your details.
            </div>
        <% } %>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-10 items-start">
            
            <!-- Left: Checkout Form -->
            <div class="lg:col-span-7 bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl p-8 lg:p-10 transition-all duration-300">
                <form action="checkout" method="post" class="space-y-8">
                    
                    <!-- Shipping Section -->
                    <div>
                        <div class="flex items-center gap-3 mb-6">
                            <div class="bg-rose-50/80 p-2.5 rounded-full text-rose-600">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                            </div>
                            <h2 class="text-xl font-serif font-bold text-zinc-900">Shipping Details</h2>
                        </div>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium text-slate-600 mb-2">Complete Address</label>
                                <textarea name="address" required rows="3" class="w-full px-5 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 focus:border-rose-400 outline-none transition-all resize-none" placeholder="123 Luxury Avenue, Suite 45..."></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Section -->
                    <div class="pt-6 border-t border-zinc-100">
                        <div class="flex items-center gap-3 mb-6">
                            <div class="bg-rose-50/80 p-2.5 rounded-full text-rose-600">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path></svg>
                            </div>
                            <h2 class="text-xl font-serif font-bold text-zinc-900">Payment Method</h2>
                        </div>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <!-- Bank Transfer Option -->
                            <label class="relative flex flex-col p-5 border border-zinc-200 rounded-2xl cursor-pointer hover:bg-rose-50/30 hover:border-rose-200 transition-colors group has-[:checked]:bg-rose-50/50 has-[:checked]:border-rose-400 has-[:checked]:ring-1 has-[:checked]:ring-rose-400">
                                <input type="radio" name="paymentMethod" value="BANK_TRANSFER" checked class="sr-only">
                                <span class="font-bold text-zinc-900 mb-1">Bank Transfer</span>
                                <span class="text-xs text-slate-500">Manual verification required</span>
                            </label>

                            <!-- E-Wallet Option -->
                            <label class="relative flex flex-col p-5 border border-zinc-200 rounded-2xl cursor-pointer hover:bg-rose-50/30 hover:border-rose-200 transition-colors group has-[:checked]:bg-rose-50/50 has-[:checked]:border-rose-400 has-[:checked]:ring-1 has-[:checked]:ring-rose-400">
                                <input type="radio" name="paymentMethod" value="EWALLET" class="sr-only">
                                <span class="font-bold text-zinc-900 mb-1">E-Wallet</span>
                                <span class="text-xs text-slate-500">QRIS / Instant payment</span>
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="w-full mt-6 py-4 bg-zinc-900 text-white font-semibold tracking-wide rounded-full shadow-[0_8px_30px_rgb(0,0,0,0.1)] hover:bg-rose-500 hover:shadow-[0_8px_30px_rgb(2fb,113,133,0.3)] transition-all duration-300 ease-in-out hover:-translate-y-1">
                        Confirm & Place Order
                    </button>
                </form>
            </div>

            <!-- Right: Order Summary -->
            <div class="lg:col-span-5">
                <div class="bg-rose-50/40 backdrop-blur-md border border-rose-100/50 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl p-8 sticky top-32 transition-all duration-300">
                    <h2 class="text-lg font-serif font-bold text-zinc-900 mb-6">Order Summary</h2>
                    
                    <div class="space-y-4 mb-6">
                        <div class="flex justify-between text-sm text-slate-600">
                            <span>Subtotal (<%= totalSelectedItems %> items)</span>
                            <span class="font-medium text-zinc-900">Rp <%= String.format("%,d", (int)totalSelectedPrice) %></span>
                        </div>
                        <div class="flex justify-between text-sm text-slate-600">
                            <span>Shipping</span>
                            <span class="font-medium text-green-600">Complimentary</span>
                        </div>
                        <div class="flex justify-between text-sm text-slate-600">
                            <span>Taxes</span>
                            <span class="font-medium text-zinc-900">Included</span>
                        </div>
                    </div>
                    
                    <div class="pt-6 border-t border-rose-200/50 flex justify-between items-end">
                        <span class="text-sm font-medium text-slate-500 uppercase tracking-wider">Total</span>
                        <span class="text-3xl font-serif font-bold text-rose-600">Rp <%= String.format("%,d", (int)totalSelectedPrice) %></span>
                    </div>
                    
                    <div class="mt-8 bg-white/60 rounded-2xl p-4 flex items-start gap-3 border border-white">
                        <svg class="w-5 h-5 text-rose-400 mt-0.5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                        <p class="text-xs text-slate-500 leading-relaxed">Transactions are encrypted and secured. Your privacy is our priority.</p>
                    </div>
                </div>
            </div>

        </div>
    </main>
</body>
</html>
