<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.furapskin.model.Order" %>
<%@ page import="com.furapskin.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report | Admin HQ</title>
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
        <header class="max-w-7xl mx-auto px-8 py-4 bg-zinc-900 backdrop-blur-md shadow-[0_8px_30px_rgb(0,0,0,0.2)] rounded-full flex items-center justify-between transition-all duration-300">
            <a href="<%= request.getContextPath() %>/index.jsp" class="font-serif tracking-wide text-white font-medium text-2xl">
                FurapSkin<span class="text-rose-400 text-sm align-top ml-1">ADMIN</span>
            </a>
            <nav class="hidden md:flex items-center space-x-6">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="text-zinc-400 hover:text-white transition-colors duration-300">Approvals</a>
                <a href="<%= request.getContextPath() %>/admin/products" class="text-zinc-400 hover:text-white transition-colors duration-300">Products</a>
                <a href="<%= request.getContextPath() %>/admin/sales" class="text-rose-400 font-semibold tracking-wide border-b-2 border-rose-400 pb-1">Sales Report</a>
                <a href="<%= request.getContextPath() %>/auth/logout" class="ml-4 px-6 py-2.5 rounded-full bg-white/10 text-white font-medium hover:bg-rose-500 transition-all duration-300 ease-in-out hover:-translate-y-0.5">
                    Logout
                </a>
            </nav>
        </header>
    </div>

    <%
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        List<Order> paidOrders = (List<Order>) request.getAttribute("orders");
        List<Product> lowStock = (List<Product>) request.getAttribute("lowStockProducts");
        Double totalRevObj = (Double) request.getAttribute("totalRevenue");
        Integer totalOrdObj = (Integer) request.getAttribute("totalOrders");
        
        double totalRevenue = (totalRevObj != null) ? totalRevObj : 0;
        int totalOrdersCount = (totalOrdObj != null) ? totalOrdObj : 0;
    %>

    <main class="flex-grow max-w-7xl mx-auto w-full px-6 pt-32 pb-20">
        
        <div class="mb-10 flex flex-col md:flex-row justify-between items-end gap-6">
            <div>
                <h1 class="font-serif tracking-tight text-zinc-900 text-4xl font-bold">Sales Report</h1>
                <p class="text-slate-500 mt-2 font-light">Comprehensive overview of store health.</p>
            </div>
            
            <div class="flex gap-4">
                <!-- Total Orders Card -->
                <div class="bg-white/80 backdrop-blur-md border border-white/60 text-zinc-900 p-6 rounded-3xl shadow-[0_8px_30px_rgb(0,0,0,0.02)] min-w-[150px] text-right">
                    <p class="text-slate-500 text-[10px] font-bold uppercase tracking-widest mb-1">Total Orders</p>
                    <p class="font-serif text-3xl font-bold"><%= totalOrdersCount %></p>
                </div>

                <!-- Revenue Card -->
                <div class="bg-rose-600 text-white p-6 rounded-3xl shadow-[0_10px_40px_rgb(225,29,72,0.3)] min-w-[250px] text-right relative overflow-hidden">
                    <div class="absolute -right-6 -top-6 w-24 h-24 bg-white/10 rounded-full blur-xl"></div>
                    <p class="text-rose-200 text-[10px] font-bold uppercase tracking-widest mb-1 relative z-10">Total Revenue</p>
                    <p class="font-serif text-3xl font-bold relative z-10">Rp <%= String.format("%,d", (int)totalRevenue) %></p>
                </div>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
            <!-- Left: Low Stock Alert -->
            <div class="lg:col-span-1">
                <div class="bg-white/80 backdrop-blur-md border border-red-100/50 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-[2rem] overflow-hidden">
                    <div class="p-6 bg-red-50/50 border-b border-red-100/50 flex items-center gap-3">
                        <div class="w-8 h-8 rounded-full bg-red-100 text-red-600 flex items-center justify-center">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"></path></svg>
                        </div>
                        <h3 class="font-serif font-bold text-red-900">Low Stock Alerts</h3>
                    </div>
                    <div class="p-4">
                        <% if (lowStock == null || lowStock.isEmpty()) { %>
                            <p class="text-sm text-slate-500 text-center py-6 font-medium">Inventory is healthy.</p>
                        <% } else { %>
                            <ul class="space-y-3">
                                <% for (Product p : lowStock) { %>
                                    <li class="flex items-center justify-between p-3 rounded-xl bg-[#FFF8F6] border border-rose-50 hover:border-red-200 transition-colors">
                                        <div class="flex items-center gap-3">
                                            <img src="<%= request.getContextPath() %>/<%= p.getImageUrl() %>" class="w-10 h-10 rounded-lg object-cover">
                                            <div>
                                                <p class="text-sm font-bold text-zinc-900 leading-tight"><%= p.getName() %></p>
                                                <p class="text-[10px] text-slate-500 uppercase tracking-wider"><%= p.getBrand() %></p>
                                            </div>
                                        </div>
                                        <div class="text-right">
                                            <span class="px-2 py-1 bg-red-100 text-red-600 font-bold rounded text-xs"><%= p.getStock() %> left</span>
                                        </div>
                                    </li>
                                <% } %>
                            </ul>
                        <% } %>
                    </div>
                </div>
            </div>

            <!-- Right: Recent Order Stream -->
            <div class="lg:col-span-2">
                <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-[2rem] overflow-hidden transition-all duration-300 h-full flex flex-col">
                    <div class="p-6 border-b border-zinc-100">
                        <h3 class="font-serif font-bold text-zinc-900">Recent Order Stream</h3>
                    </div>
                    
                    <% if (paidOrders == null || paidOrders.isEmpty()) { %>
                        <div class="p-16 text-center flex-grow flex flex-col justify-center items-center">
                            <p class="text-lg font-serif text-zinc-400">No sales data yet.</p>
                        </div>
                    <% } else { %>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-[#FFF8F6] text-zinc-500 text-[10px] uppercase tracking-widest font-bold border-b border-zinc-100">
                                        <th class="p-4 pl-6">Order ID</th>
                                        <th class="p-4">Customer</th>
                                        <th class="p-4 text-right">Amount</th>
                                        <th class="p-4 text-center">Status</th>
                                        <th class="p-4 text-right pr-6">Action</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-zinc-50">
                                    <% 
                                        // Take max 10
                                        int count = 0;
                                        for (Order o : paidOrders) { 
                                            if (count++ >= 10) break;
                                    %>
                                        <tr class="hover:bg-rose-50/20 transition-colors">
                                            <td class="p-4 pl-6">
                                                <p class="font-bold text-zinc-900">#<%= o.getId() %></p>
                                                <p class="text-[10px] text-slate-400"><%= o.getOrderDate() %></p>
                                            </td>
                                            <td class="p-4 font-medium text-sm text-slate-700"><%= o.getCustomer().getFullName() %></td>
                                            <td class="p-4 text-right font-bold text-rose-600 text-sm">Rp <%= String.format("%,d", (int)o.getTotalAmount()) %></td>
                                            <td class="p-4 text-center">
                                                <span class="px-3 py-1 bg-green-50 text-green-600 border border-green-100 rounded-full text-[10px] font-bold tracking-wide">
                                                    <%= o.getStatus() %>
                                                </span>
                                            </td>
                                            <td class="p-4 text-right pr-6 space-x-2">
                                                <% if (com.furapskin.model.OrderStatus.PAID.equals(o.getStatus())) { %>
                                                    <form action="<%= request.getContextPath() %>/admin/ship-order" method="post" class="inline">
                                                        <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                                        <button type="submit" class="px-4 py-1.5 bg-zinc-900 text-white rounded-full text-xs font-bold hover:bg-rose-500 transition-colors">
                                                            Ship Order
                                                        </button>
                                                    </form>
                                                <% } %>
                                                <a href="<%= request.getContextPath() %>/customer/invoice?id=<%= o.getId() %>" class="px-4 py-1.5 bg-rose-50 text-rose-600 border border-rose-200 rounded-full text-xs font-bold hover:bg-rose-100 transition-colors inline-block">
                                                    Invoice
                                                </a>
                                            </td>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>

    </main>
</body>
</html>
