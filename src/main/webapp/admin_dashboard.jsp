<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.furapskin.model.Order" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin HQ | FurapSkin</title>
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
            <a href="index.jsp" class="font-serif tracking-wide text-white font-medium text-2xl">
                FurapSkin<span class="text-rose-400 text-sm align-top ml-1">ADMIN</span>
            </a>
            <nav class="hidden md:flex items-center space-x-6">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="text-rose-400 font-semibold tracking-wide border-b-2 border-rose-400 pb-1">Approvals</a>
                <a href="<%= request.getContextPath() %>/admin/products" class="text-zinc-400 hover:text-white transition-colors duration-300">Products</a>
                <a href="<%= request.getContextPath() %>/admin/sales" class="text-zinc-400 hover:text-white transition-colors duration-300">Sales Report</a>
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
    %>

    <main class="flex-grow max-w-7xl mx-auto w-full px-6 pt-32 pb-20">
        
        <div class="mb-10">
            <h1 class="font-serif tracking-tight text-zinc-900 text-4xl font-bold">Pending Approvals</h1>
            <p class="text-slate-500 mt-2 font-light">Review and authorize incoming payments.</p>
        </div>

        <% if ("true".equals(request.getParameter("success"))) { %>
            <div class="mb-8 p-4 bg-green-50 border border-green-200 text-green-700 rounded-2xl shadow-sm font-medium">
                Payment approved successfully. Order status updated to PAID.
            </div>
        <% } %>

        <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-[2rem] overflow-hidden transition-all duration-300">
            
            <%
                List<Order> pendingOrders = (List<Order>) request.getAttribute("pendingOrders");
                if (pendingOrders == null || pendingOrders.isEmpty()) {
            %>
                <div class="p-16 text-center flex flex-col items-center">
                    <div class="w-20 h-20 bg-rose-50/50 rounded-full flex items-center justify-center mb-6 text-rose-300">
                        <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                    <p class="text-xl font-serif text-zinc-900">All caught up!</p>
                    <p class="text-slate-500 font-light mt-1">There are no pending payments requiring authorization.</p>
                </div>
            <%
                } else {
            %>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-[#FFF8F6] text-zinc-500 text-sm uppercase tracking-wider font-semibold border-b border-zinc-100">
                                <th class="p-6">Order ID</th>
                                <th class="p-6">Customer</th>
                                <th class="p-6">Total Amount</th>
                                <th class="p-6">Payment Method</th>
                                <th class="p-6">Status</th>
                                <th class="p-6 text-right">Action</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-zinc-50">
                            <% for (Order o : pendingOrders) { %>
                                <tr class="hover:bg-rose-50/20 transition-colors group">
                                    <td class="p-6 font-bold text-zinc-900">#<%= o.getId() %></td>
                                    <td class="p-6 text-slate-600"><%= o.getCustomer().getFullName() %></td>
                                    <td class="p-6 font-bold text-rose-600">Rp <%= String.format("%,d", o.getTotalAmount()) %></td>
                                    <td class="p-6 text-slate-600 font-medium"><%= o.getPayment().getClass().getSimpleName() %></td>
                                    <td class="p-6">
                                        <span class="px-3 py-1 bg-amber-50 text-amber-600 border border-amber-200/50 rounded-full text-xs font-bold tracking-wide">
                                            <%= o.getPayment().getStatus() %>
                                        </span>
                                    </td>
                                    <td class="p-6 text-right">
                                        <form action="admin/approve-payment" method="post" class="inline">
                                            <input type="hidden" name="orderId" value="<%= o.getId() %>">
                                            <button type="submit" class="px-5 py-2 bg-zinc-900 text-white text-sm font-semibold rounded-full hover:bg-green-500 hover:shadow-lg transition-all duration-300 ease-in-out hover:-translate-y-0.5">
                                                Approve
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>

    </main>
</body>
</html>
