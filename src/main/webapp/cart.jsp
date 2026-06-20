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
                <a href="cart.jsp" class="relative text-rose-950/80 font-semibold transition-colors duration-300 flex items-center gap-2">
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
            <!-- Floating Toasts -->
            <div id="toast-container" class="fixed top-24 left-1/2 transform -translate-x-1/2 z-50 flex flex-col gap-3 w-[90%] max-w-md pointer-events-none">
                <% if ("stock".equals(request.getParameter("error"))) { %>
                <div class="p-4 bg-rose-50/95 border border-rose-200 rounded-2xl flex items-start text-rose-600 font-medium shadow-lg transition-all duration-500 toast-alert">
                    <svg class="w-5 h-5 mr-3 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                    <p class="text-sm">Oops! Stok produk ini hanya tersisa <%= request.getParameter("limit") %>, Anda tidak bisa menambahkan lebih banyak.</p>
                </div>
                <% } else if ("empty_selection".equals(request.getParameter("error"))) { %>
                <div class="p-4 bg-orange-50/95 border border-orange-200 rounded-2xl flex items-start text-orange-600 font-medium shadow-lg transition-all duration-500 toast-alert">
                    <p class="text-sm">Silakan pilih setidaknya satu produk untuk di-checkout.</p>
                </div>
                <% } %>
            </div>
            
            <script>
                document.addEventListener('DOMContentLoaded', () => {
                    const toasts = document.querySelectorAll('.toast-alert');
                    if (toasts.length > 0) {
                        setTimeout(() => {
                            toasts.forEach(t => {
                                t.style.opacity = '0';
                                t.style.transform = 'translateY(-10px)';
                                setTimeout(() => t.remove(), 500);
                            });
                        }, 5000);
                    }
                });
            </script>
            <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl overflow-hidden transition-all duration-300">
                <form id="checkoutForm" action="cart/checkout_prepare" method="post">
                <div class="p-8 space-y-6">
                    <% for (CartItem item : cart.getItems()) { %>
                        <div class="flex items-center justify-between py-4 border-b border-zinc-100 last:border-0 group">
                            <div class="flex items-center gap-6">
                                <!-- Checkbox -->
                                <label class="relative flex items-center justify-center w-6 h-6 rounded-md border-2 border-zinc-300 cursor-pointer hover:border-rose-400 has-[:checked]:bg-rose-500 has-[:checked]:border-rose-500 transition-colors">
                                    <input type="checkbox" name="selectedItems" value="<%= item.getProduct().getId() %>" class="sr-only item-checkbox" onchange="updateTotal()">
                                    <svg class="w-4 h-4 text-white opacity-0 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                                </label>
                                
                                <div class="w-16 h-20 bg-[#FFF8F6] rounded-2xl flex items-center justify-center border border-zinc-100 shadow-sm group-hover:shadow-md transition-shadow">
                                    <div class="text-[8px] font-serif text-rose-800/40 uppercase tracking-widest text-center">Furap<br>Skin</div>
                                </div>
                                <div>
                                    <h3 class="text-lg font-serif font-bold text-zinc-900"><%= item.getProduct().getName() %></h3>
                                    <p class="text-sm text-slate-500 font-light mt-1">Rp <%= String.format("%,d", (int)item.getProduct().getPrice()) %></p>
                                </div>
                            </div>
                            
                            <div class="flex items-center gap-8">
                                <!-- Quantity controls -->
                                <div class="flex items-center border border-zinc-200 rounded-full bg-[#FFF8F6]">
                                    <button type="button" onclick="document.getElementById('form-dec-<%= item.getProduct().getId() %>').submit()" class="w-8 h-8 flex items-center justify-center text-zinc-500 hover:text-rose-500 transition-colors">-</button>
                                    <span class="w-8 text-center text-sm font-medium"><%= item.getQuantity() %></span>
                                    <button type="button" onclick="document.getElementById('form-inc-<%= item.getProduct().getId() %>').submit()" class="w-8 h-8 flex items-center justify-center text-zinc-500 hover:text-rose-500 transition-colors">+</button>
                                </div>
                                
                                <div class="text-right w-24">
                                    <p class="text-lg font-bold text-rose-600/90 item-subtotal" data-subtotal="<%= item.getSubtotal() %>">Rp <%= String.format("%,d", (int)item.getSubtotal()) %></p>
                                </div>

                                <!-- Remove button -->
                                <button type="button" onclick="document.getElementById('form-rem-<%= item.getProduct().getId() %>').submit()" class="w-8 h-8 flex items-center justify-center text-zinc-400 hover:bg-red-50 hover:text-red-500 rounded-full transition-all">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                </button>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <div class="bg-[#FFF8F6]/50 p-8 border-t border-zinc-100">
                    <div class="flex justify-between items-end mb-8">
                        <div class="flex items-center gap-6">
                            <label class="relative flex items-center justify-center w-6 h-6 rounded-md border-2 border-zinc-300 cursor-pointer hover:border-rose-400 has-[:checked]:bg-rose-500 has-[:checked]:border-rose-500 transition-colors">
                                <input type="checkbox" id="selectAll" class="sr-only" onchange="toggleAll(this)">
                                <svg class="w-4 h-4 text-white opacity-0 transition-opacity" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path></svg>
                            </label>
                            <span class="text-sm font-medium text-slate-600">Select All</span>
                            
                            <button type="button" onclick="document.getElementById('form-clear').submit()" class="text-sm font-medium text-zinc-400 hover:text-red-500 transition-colors underline underline-offset-4 ml-4">Clear Bag</button>
                        </div>
                        <div class="text-right">
                            <p class="text-sm text-slate-500 font-medium uppercase tracking-wider mb-1">Total Amount (<span id="selectedCount">0</span> items)</p>
                            <p class="text-3xl font-serif font-bold text-zinc-900" id="totalDisplay">Rp 0</p>
                        </div>
                    </div>
                    
                    <button type="submit" class="block w-full text-center py-4 bg-rose-400/90 text-white font-semibold tracking-wide rounded-full shadow-[0_8px_30px_rgb(2fb,113,133,0.3)] hover:bg-rose-500/90 hover:shadow-lg transition-all duration-300 ease-in-out hover:-translate-y-1">
                        Proceed to Secure Checkout
                    </button>
                </div>
                </form>
            </div>
            
            <!-- Hidden forms for actions -->
            <% for (CartItem item : cart.getItems()) { %>
                <form id="form-inc-<%= item.getProduct().getId() %>" action="cart/update" method="post" class="hidden">
                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                    <input type="hidden" name="action" value="increment">
                </form>
                <form id="form-dec-<%= item.getProduct().getId() %>" action="cart/update" method="post" class="hidden">
                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                    <input type="hidden" name="action" value="decrement">
                </form>
                <form id="form-rem-<%= item.getProduct().getId() %>" action="cart/remove" method="post" class="hidden">
                    <input type="hidden" name="productId" value="<%= item.getProduct().getId() %>">
                </form>
            <% } %>
            <form id="form-clear" action="cart/clear" method="post" class="hidden"></form>

            <script>
                function toggleAll(master) {
                    document.querySelectorAll('.item-checkbox').forEach(cb => {
                        cb.checked = master.checked;
                    });
                    updateTotal();
                }
                
                function updateTotal() {
                    let total = 0;
                    let count = 0;
                    let allChecked = true;
                    let anyExists = false;
                    
                    document.querySelectorAll('.item-checkbox').forEach(cb => {
                        anyExists = true;
                        if (cb.checked) {
                            const subtotal = parseInt(cb.closest('.group').querySelector('.item-subtotal').dataset.subtotal);
                            total += subtotal;
                            count++;
                        } else {
                            allChecked = false;
                        }
                    });
                    
                    document.getElementById('totalDisplay').textContent = 'Rp ' + total.toLocaleString('id-ID');
                    document.getElementById('selectedCount').textContent = count;
                    
                    if (anyExists) {
                        document.getElementById('selectAll').checked = allChecked;
                    }
                    
                    // CSS hack to make checked SVGs visible
                    document.querySelectorAll('input[type="checkbox"]').forEach(cb => {
                        const svg = cb.nextElementSibling;
                        if (cb.checked) svg.classList.remove('opacity-0');
                        else svg.classList.add('opacity-0');
                    });
                }
                
                document.addEventListener("DOMContentLoaded", updateTotal);
            </script>
        <% } %>
    </main>
</body>
</html>
