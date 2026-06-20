<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.User" %>
<%@ page import="com.furapskin.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page import="com.furapskin.dao.OrderDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | FurapSkin</title>
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
                <span class="text-rose-950/80 font-semibold transition-colors duration-300">My Dashboard</span>
                <a href="auth/logout" class="px-6 py-2.5 rounded-full bg-zinc-100 border border-zinc-200 text-zinc-600 font-medium hover:bg-rose-50/50 hover:text-rose-600 transition-all duration-300 ease-in-out hover:-translate-y-0.5">
                    Logout
                </a>
            </nav>
        </header>
    </div>

    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect("login.jsp");
            return;
        }
    %>

    <main class="flex-grow max-w-5xl mx-auto w-full px-6 pt-32 pb-20">
        
        <div class="mb-12 flex flex-col md:flex-row md:items-end justify-between gap-6">
            <div>
                <p class="text-rose-600 font-medium mb-1 tracking-wider text-sm uppercase">Welcome back,</p>
                <h1 class="font-serif tracking-tight text-zinc-900 text-4xl font-bold"><%= user.getFullName() %></h1>
            </div>
            <a href="catalog" class="inline-flex items-center justify-center py-3 px-6 bg-zinc-900 text-white font-medium rounded-full shadow-md hover:bg-rose-500 transition-all duration-300 ease-in-out hover:-translate-y-1">
                Continue Shopping
            </a>
        </div>

        <% if ("true".equals(request.getParameter("orderSuccess"))) { %>
            <div class="mb-10 p-5 bg-green-50/80 border border-green-200 text-green-700 rounded-3xl shadow-sm flex items-center gap-4">
                <div class="bg-green-100 p-2 rounded-full">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                </div>
                <div>
                    <p class="font-bold">Order placed successfully!</p>
                    <p class="text-sm font-light">Your order is now pending admin approval.</p>
                </div>
            </div>
        <% } %>

        <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-[2rem] p-8 lg:p-12 transition-all duration-300">
            <h2 class="text-2xl font-serif font-bold text-zinc-900 mb-8 flex items-center gap-3">
                <svg class="w-6 h-6 text-rose-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                Recent Orders
            </h2>
            
            <%
                OrderDAO orderDAO = new OrderDAO();
                List<Order> orders = orderDAO.getOrdersByCustomerId(user.getId());
                if (orders == null || orders.isEmpty()) {
            %>
            <div class="bg-[#FFF8F6]/50 rounded-2xl border border-zinc-100 p-10 text-center flex flex-col items-center">
                <div class="w-16 h-16 bg-rose-50 rounded-full flex items-center justify-center mb-4 text-rose-300">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <p class="text-lg font-medium text-zinc-900">No active orders found.</p>
                <p class="text-sm text-slate-500 font-light mt-1">Orders you place will appear here along with their status.</p>
            </div>
            <% } else { %>
            <div class="space-y-4">
                <% for (Order o : orders) { %>
                <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center p-6 border border-zinc-100 rounded-2xl hover:shadow-md transition-shadow bg-white">
                    <div class="mb-4 sm:mb-0">
                        <p class="text-sm text-slate-500 font-medium tracking-wide mb-1">ORDER #<%= o.getId() %></p>
                        <p class="text-lg font-serif font-bold text-zinc-900">Rp <%= String.format("%,d", (int)o.getTotalAmount()) %></p>
                        <p class="text-sm text-zinc-400 mt-1"><%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(o.getOrderDate()) %></p>
                    </div>
                    <div class="flex items-center gap-3">
                        <span class="px-4 py-1.5 rounded-full text-xs font-bold tracking-wider uppercase
                            <%= o.getStatus().name().equals("PENDING") ? "bg-amber-50 text-amber-600 border border-amber-200" :
                                o.getStatus().name().equals("COMPLETED") ? "bg-emerald-50 text-emerald-600 border border-emerald-200" :
                                "bg-rose-50 text-rose-600 border border-rose-200" %>">
                            <%= o.getStatus().name() %>
                        </span>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
        </div>

    </main>
</body>
</html>
