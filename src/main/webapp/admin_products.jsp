<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.furapskin.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="com.furapskin.model.Product" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Management | Admin HQ</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
        .font-serif { font-family: 'Playfair Display', serif; }
    </style>
</head>
<body class="bg-[#FFF8F6] text-zinc-800 min-h-screen flex flex-col antialiased">

    <div class="fixed top-0 inset-x-0 z-50 p-4">
        <header class="max-w-7xl mx-auto px-8 py-4 bg-zinc-900 backdrop-blur-md shadow-[0_8px_30px_rgb(0,0,0,0.2)] rounded-full flex items-center justify-between transition-all duration-300">
            <a href="<%= request.getContextPath() %>/index.jsp" class="font-serif tracking-wide text-white font-medium text-2xl">
                FurapSkin<span class="text-rose-400 text-sm align-top ml-1">ADMIN</span>
            </a>
            <nav class="hidden md:flex items-center space-x-6">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="text-zinc-400 hover:text-white transition-colors duration-300">Approvals</a>
                <a href="<%= request.getContextPath() %>/admin/products" class="text-rose-400 font-semibold tracking-wide border-b-2 border-rose-400 pb-1">Products</a>
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

    <main class="flex-grow max-w-[1400px] mx-auto w-full px-6 pt-32 pb-20 grid grid-cols-1 xl:grid-cols-12 gap-10">
        
        <div class="xl:col-span-4">
            <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-[2rem] p-8 sticky top-32">
                <h2 class="text-2xl font-serif font-bold text-zinc-900 mb-6">Add New Product</h2>
                
                <% if ("true".equals(request.getParameter("success"))) { %>
                    <div class="mb-6 p-4 bg-green-50 border border-green-200 text-green-700 rounded-2xl text-sm font-medium">Product uploaded!</div>
                <% } %>
                <% if ("true".equals(request.getParameter("updated"))) { %>
                    <div class="mb-6 p-4 bg-blue-50 border border-blue-200 text-blue-700 rounded-2xl text-sm font-medium">Product updated successfully!</div>
                <% } %>

                <form action="<%= request.getContextPath() %>/admin/add-product" method="post" enctype="multipart/form-data" class="space-y-4">
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Product Name</label>
                        <input type="text" name="name" required class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Brand</label>
                            <input type="text" name="brand" value="FurapSkin" required class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none">
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">BPOM ID</label>
                            <input type="text" name="bpomId" value="NA18220100000" required class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none">
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Category</label>
                            <select name="categoryId" class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none">
                                <% 
                                    List<com.furapskin.model.Category> categories = (List<com.furapskin.model.Category>) request.getAttribute("categories");
                                    if (categories != null) {
                                        for (com.furapskin.model.Category cat : categories) {
                                %>
                                <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                                <%      }
                                    }
                                %>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Stock</label>
                            <input type="number" name="stock" required class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Price (Rp)</label>
                        <input type="number" name="price" required class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none">
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Description</label>
                        <textarea name="description" rows="2" required class="w-full px-4 py-3 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none resize-none"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Image</label>
                        <input type="file" name="image" accept="image/*" required class="w-full px-4 py-2 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 outline-none text-sm file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-bold file:bg-zinc-900 file:text-white hover:file:bg-rose-500 cursor-pointer">
                    </div>
                    <button type="submit" class="w-full py-4 mt-2 bg-rose-600 text-white font-semibold tracking-wide rounded-full shadow-[0_8px_20px_rgb(225,29,72,0.2)] hover:bg-zinc-900 transition-all duration-300">
                        Upload Product
                    </button>
                </form>
            </div>
        </div>

        <div class="xl:col-span-8">
            <div class="bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-[2rem] overflow-hidden">
                <div class="p-8 border-b border-zinc-100 flex justify-between items-center">
                    <h2 class="text-2xl font-serif font-bold text-zinc-900">Product Inventory</h2>
                    <% if ("true".equals(request.getParameter("deleted"))) { %>
                        <span class="text-xs font-bold uppercase tracking-wider text-red-500 bg-red-50 px-3 py-1.5 rounded-full">Deleted</span>
                    <% } %>
                </div>
                
                <%
                    List<Product> products = (List<Product>) request.getAttribute("products");
                    if (products == null || products.isEmpty()) {
                %>
                    <div class="p-16 text-center">
                        <p class="text-xl font-serif text-zinc-900">No products found.</p>
                    </div>
                <% } else { %>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-[#FFF8F6] text-zinc-500 text-[10px] uppercase tracking-widest font-bold border-b border-zinc-100">
                                    <th class="p-4 pl-6">Product</th>
                                    <th class="p-4">BPOM ID</th>
                                    <th class="p-4">Price</th>
                                    <th class="p-4">Stock</th>
                                    <th class="p-4 text-right pr-6">Actions</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-zinc-50">
                                <% for (Product p : products) { %>
                                    <tr class="hover:bg-rose-50/20 transition-colors group">
                                        <td class="p-4 pl-6 flex items-center gap-4">
                                            <img src="<%= request.getContextPath() %>/<%= p.getImageUrl() %>" class="w-12 h-12 rounded-xl object-cover border border-zinc-100 shadow-sm">
                                            <div>
                                                <p class="font-bold text-zinc-900 text-sm"><%= p.getName() %></p>
                                                <p class="text-[11px] font-medium text-slate-500"><%= p.getBrand() %> &bull; <%= p.getCategory().getName() %></p>
                                            </div>
                                        </td>
                                        <td class="p-4">
                                            <span class="px-2 py-1 bg-slate-100 text-slate-600 rounded text-[10px] font-bold"><%= p.getBpomId() %></span>
                                        </td>
                                        <td class="p-4 font-bold text-rose-600 text-sm">Rp <%= String.format("%,d", (int)p.getPrice()) %></td>
                                        <td class="p-4">
                                            <span class="px-2 py-1 <%= p.getStock() < 5 ? "bg-red-100 text-red-600" : "bg-green-100 text-green-700" %> rounded text-[10px] font-bold"><%= p.getStock() %> Units</span>
                                        </td>
                                        <td class="p-4 text-right pr-6">
                                            <div class="flex items-center justify-end gap-2">
                                                <button onclick="openEditModal(<%= p.getId() %>, '<%= p.getName().replace("'", "\\'") %>', '<%= p.getBrand() %>', '<%= p.getBpomId() %>', <%= p.getPrice() %>, <%= p.getStock() %>, <%= p.getCategory().getId() %>, '<%= p.getDescription().replace("'", "\\'").replace("\n", " ") %>')" class="p-2 text-zinc-400 hover:text-blue-500 hover:bg-blue-50 rounded-full transition-colors">
                                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                                                </button>
                                                <form action="<%= request.getContextPath() %>/admin/delete-product" method="post" class="inline" onsubmit="return confirm('Delete this product?');">
                                                    <input type="hidden" name="id" value="<%= p.getId() %>">
                                                    <button type="submit" class="p-2 text-zinc-400 hover:text-red-500 hover:bg-red-50 rounded-full transition-colors">
                                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>

    </main>

    <!-- Edit Modal -->
    <div id="editModal" class="fixed inset-0 z-[60] bg-zinc-900/40 backdrop-blur-sm hidden flex items-center justify-center p-4">
        <div class="bg-white rounded-[2rem] shadow-2xl w-full max-w-lg overflow-hidden transform scale-95 opacity-0 transition-all duration-300" id="editModalContent">
            <div class="p-6 border-b border-zinc-100 flex justify-between items-center bg-[#FFF8F6]">
                <h3 class="text-xl font-serif font-bold text-zinc-900">Edit Product</h3>
                <button onclick="closeEditModal()" class="text-zinc-400 hover:text-zinc-600 bg-white rounded-full p-1 shadow-sm">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <div class="p-6">
                <form action="<%= request.getContextPath() %>/admin/update-product" method="post" enctype="multipart/form-data" class="space-y-4">
                    <input type="hidden" name="id" id="edit-id">
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Product Name</label>
                        <input type="text" name="name" id="edit-name" required class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-200 text-sm">
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Brand</label>
                            <input type="text" name="brand" id="edit-brand" required class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-200 text-sm">
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">BPOM ID</label>
                            <input type="text" name="bpomId" id="edit-bpom" required class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none focus:ring-2 focus:ring-blue-200 text-sm">
                        </div>
                    </div>
                    <div class="grid grid-cols-3 gap-4">
                        <div class="col-span-1">
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Category</label>
                            <select name="categoryId" id="edit-category" class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none text-sm">
                                <% 
                                    if (categories != null) {
                                        for (com.furapskin.model.Category cat : categories) {
                                %>
                                <option value="<%= cat.getId() %>"><%= cat.getName() %></option>
                                <%      }
                                    }
                                %>
                            </select>
                        </div>
                        <div class="col-span-1">
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Price</label>
                            <input type="number" name="price" id="edit-price" required class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none text-sm">
                        </div>
                        <div class="col-span-1">
                            <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Stock</label>
                            <input type="number" name="stock" id="edit-stock" required class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none text-sm">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">Description</label>
                        <textarea name="description" id="edit-desc" rows="2" required class="w-full px-4 py-2.5 bg-slate-50 border border-zinc-200 rounded-xl outline-none text-sm"></textarea>
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-slate-500 uppercase tracking-wider mb-1">New Image (Optional)</label>
                        <input type="file" name="image" accept="image/*" class="w-full text-sm file:mr-4 file:py-1.5 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-bold file:bg-blue-50 file:text-blue-700 hover:file:bg-blue-100 cursor-pointer">
                    </div>
                    <button type="submit" class="w-full py-3 mt-4 bg-zinc-900 text-white text-sm font-semibold tracking-wide rounded-full shadow-lg hover:bg-blue-600 transition-all duration-300">
                        Save Changes
                    </button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function openEditModal(id, name, brand, bpom, price, stock, categoryId, desc) {
            document.getElementById('edit-id').value = id;
            document.getElementById('edit-name').value = name;
            document.getElementById('edit-brand').value = brand;
            document.getElementById('edit-bpom').value = bpom;
            document.getElementById('edit-price').value = price;
            document.getElementById('edit-stock').value = stock;
            document.getElementById('edit-category').value = categoryId;
            document.getElementById('edit-desc').value = desc;
            
            const modal = document.getElementById('editModal');
            const content = document.getElementById('editModalContent');
            modal.classList.remove('hidden');
            setTimeout(() => {
                content.classList.remove('scale-95', 'opacity-0');
                content.classList.add('scale-100', 'opacity-100');
            }, 10);
        }

        function closeEditModal() {
            const modal = document.getElementById('editModal');
            const content = document.getElementById('editModalContent');
            content.classList.remove('scale-100', 'opacity-100');
            content.classList.add('scale-95', 'opacity-0');
            setTimeout(() => {
                modal.classList.add('hidden');
            }, 300);
        }
    </script>
</body>
</html>
