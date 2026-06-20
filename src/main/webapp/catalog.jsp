<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.furapskin.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalog | FurapSkin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
        .font-serif { font-family: 'Playfair Display', serif; }
    </style>
</head>
<body class="bg-[#FFF8F6] text-zinc-800 min-h-screen flex flex-col antialiased selection:bg-rose-200 selection:text-rose-900">

    <!-- Premium Floating Header -->
    <div class="fixed top-0 inset-x-0 z-50 p-4">
        <header class="max-w-7xl mx-auto px-8 py-4 bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-full flex items-center justify-between transition-all duration-300">
            <a href="index.jsp" class="font-serif tracking-wide text-rose-950/80 font-medium text-2xl hover:opacity-80 transition-opacity">
                FurapSkin.
            </a>
            <nav class="hidden md:flex items-center space-x-10">
                <a href="catalog" class="text-rose-950/80 font-semibold transition-colors duration-300">Catalog</a>
                <a href="cart.jsp" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300 flex items-center gap-2">
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

    <!-- Decorative Ambient Blurs -->
    <div class="fixed top-20 left-20 w-96 h-96 bg-rose-200/20 rounded-full blur-3xl -z-10 mix-blend-multiply pointer-events-none"></div>

    <main class="flex-grow max-w-7xl mx-auto w-full px-6 pt-32 pb-20">
        
        <div class="mb-12 text-center space-y-4">
            <h1 class="font-serif tracking-tight text-zinc-900 text-5xl font-medium">Curated Collection</h1>
            <p class="text-slate-500 font-light max-w-2xl mx-auto">Discover our range of meticulously crafted skincare essentials designed to nourish, protect, and illuminate.</p>
        </div>

        <%
            List<Product> products = (List<Product>) request.getAttribute("products");
            if (products == null || products.isEmpty()) {
        %>
            <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl p-16 text-center transition-all duration-300">
                <p class="text-slate-500 font-medium">No products available at the moment. Please check back later.</p>
            </div>
        <%
            } else {
        %>
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                <% for (Product p : products) { %>
                    <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-3xl overflow-hidden group transition-all duration-500 ease-in-out hover:-translate-y-2 hover:shadow-[0_20px_40px_rgb(0,0,0,0.06)] flex flex-col">
                        
                        <!-- Product Image -->
                        <div class="h-64 bg-white flex items-center justify-center relative overflow-hidden p-0 group-hover:opacity-90 transition-opacity">
                            <img src="<%= request.getContextPath() %>/<%= p.getImageUrl() %>" alt="<%= p.getName() %>" class="w-full h-full object-cover transform group-hover:scale-105 transition-transform duration-700 ease-in-out">
                        </div>

                        <!-- Product Details -->
                        <div class="p-6 flex flex-col flex-grow">
                            <div class="flex justify-between items-start mb-2">
                                <h3 class="text-lg font-serif font-bold text-zinc-900 leading-tight group-hover:text-rose-600 transition-colors"><%= p.getName() %></h3>
                                <span class="bg-rose-50/50 text-rose-600/80 text-xs font-bold px-3 py-1 rounded-full border border-rose-100/50 whitespace-nowrap ml-3">
                                    Rp <%= String.format("%,d", (int)p.getPrice()) %>
                                </span>
                            </div>
                            
                            <p class="text-sm text-slate-500 font-light mb-6 flex-grow line-clamp-2"><%= p.getDescription() %></p>
                            
                            <div class="flex items-center justify-between border-t border-zinc-100 pt-4 mt-auto">
                                <span class="text-xs font-medium text-zinc-400 uppercase tracking-wider">Stock: <%= p.getStock() %></span>
                                
                                <form action="cart/add" method="post" class="flex items-center gap-2">
                                    <input type="hidden" name="productId" value="<%= p.getId() %>">
                                    <input type="number" name="quantity" value="1" min="1" max="<%= p.getStock() %>" class="w-16 h-10 px-3 bg-[#FFF8F6] border border-zinc-200 rounded-full text-sm text-center focus:ring-2 focus:ring-rose-200 focus:border-rose-300 transition-all outline-none">
                                    <button type="submit" class="w-10 h-10 flex items-center justify-center rounded-full bg-zinc-900 text-white hover:bg-rose-500 hover:shadow-lg transition-all duration-300 ease-in-out hover:-translate-y-0.5">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"></path></svg>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </main>
</body>
</html>
