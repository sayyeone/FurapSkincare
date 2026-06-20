<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.Cart" %>
<%@ page import="com.furapskin.model.CartItem" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart | FurapSkin</title>
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
                <a href="cart.jsp" class="text-rose-950/80 font-semibold transition-colors duration-300 flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
                    Cart
                </a>
                <a href="login.jsp" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300">Login</a>
                <a href="register.jsp" class="px-6 py-2.5 rounded-full bg-rose-50/50 border border-rose-200/50 text-rose-600/80 font-medium hover:bg-rose-100/50 transition-all duration-300 ease-in-out hover:-translate-y-0.5">
                    Sign Up
                </a>
            </nav>
        </header>
    </div>

    <!-- Ambient Blurs -->
    <div class="fixed top-40 right-20 w-[600px] h-[600px] bg-rose-100/30 rounded-full blur-3xl -z-10 mix-blend-multiply pointer-events-none"></div>

    <main class="flex-grow max-w-4xl mx-auto w-full px-6 pt-32 pb-20">
        
        <div class="mb-10 text-center">
            <h1 class="font-serif tracking-tight text-zinc-900 text-4xl font-medium">Your Ritual Bag</h1>
        </div>

        <%
            Cart cart = (Cart) session.getAttribute("cart");
            if (cart == null || cart.getItems().isEmpty()) {
        %>
            <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl p-16 text-center transition-all duration-300">
                <div class="w-20 h-20 bg-rose-50/50 rounded-full flex items-center justify-center mx-auto mb-6 text-rose-300">
                    <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </div>
                <p class="text-xl font-serif text-zinc-900 mb-2">Your bag is empty.</p>
                <p class="text-slate-500 font-light mb-8">Discover our premium collection and start your glowing journey.</p>
                <a href="catalog" class="inline-flex items-center justify-center py-3.5 px-8 bg-zinc-900 text-white font-medium rounded-full hover:bg-rose-500 hover:shadow-lg transition-all duration-300 ease-in-out hover:-translate-y-1">
                    Shop Collection
                </a>
            </div>
        <%
            } else {
        %>
            <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl overflow-hidden transition-all duration-300">
                <div class="p-8 space-y-6">
                    <% for (CartItem item : cart.getItems()) { %>
                        <div class="flex items-center justify-between py-4 border-b border-zinc-100 last:border-0 group">
                            <div class="flex items-center gap-6">
                                <div class="w-16 h-20 bg-[#FFF8F6] rounded-2xl flex items-center justify-center border border-zinc-100 shadow-sm group-hover:shadow-md transition-shadow">
                                    <div class="text-[8px] font-serif text-rose-800/40 uppercase tracking-widest text-center">Furap<br>Skin</div>
                                </div>
                                <div>
                                    <h3 class="text-lg font-serif font-bold text-zinc-900"><%= item.getProduct().getName() %></h3>
                                    <p class="text-sm text-slate-500 font-light mt-1">Rp <%= String.format("%,d", item.getProduct().getPrice()) %> <span class="text-zinc-300 mx-2">|</span> Qty: <%= item.getQuantity() %></p>
                                </div>
                            </div>
                            <div class="text-right">
                                <p class="text-lg font-bold text-rose-600/90">Rp <%= String.format("%,d", item.getSubtotal()) %></p>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <div class="bg-[#FFF8F6]/50 p-8 border-t border-zinc-100">
                    <div class="flex justify-between items-end mb-8">
                        <div>
                            <p class="text-sm text-slate-500 font-medium uppercase tracking-wider mb-1">Total Amount</p>
                            <p class="text-3xl font-serif font-bold text-zinc-900">Rp <%= String.format("%,d", cart.getTotalPrice()) %></p>
                        </div>
                        <form action="cart/clear" method="post">
                            <button type="submit" class="text-sm font-medium text-zinc-400 hover:text-red-500 transition-colors underline underline-offset-4">Clear Bag</button>
                        </form>
                    </div>
                    
                    <a href="checkout.jsp" class="block w-full text-center py-4 bg-rose-400/90 text-white font-semibold tracking-wide rounded-full shadow-[0_8px_30px_rgb(2fb,113,133,0.3)] hover:bg-rose-500/90 hover:shadow-lg transition-all duration-300 ease-in-out hover:-translate-y-1">
                        Proceed to Secure Checkout
                    </a>
                </div>
            </div>
        <% } %>
    </main>
</body>
</html>
