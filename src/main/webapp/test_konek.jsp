<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Uji Koneksi Database | FurapSkin</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-neutral-50 text-zinc-800 flex items-center justify-center min-h-screen">
    <div class="bg-white p-10 rounded-2xl shadow-sm border border-zinc-100 w-full max-w-lg text-center">
        <div class="mb-6 inline-flex items-center justify-center w-20 h-20 rounded-full bg-rose-50 text-rose-500">
            <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7v10c0 2.21 3.582 4 8 4s8-1.79 8-4V7M4 7c0 2.21 3.582 4 8 4s8-1.79 8-4M4 7c0-2.21 3.582-4 8-4s8 1.79 8 4m0 5c0 2.21-3.582 4-8 4s-8-1.79-8-4"></path></svg>
        </div>
        
        <h2 class="text-3xl font-extrabold text-zinc-900 mb-8 tracking-tight">Status Koneksi</h2>

        <%
            String status = (String) request.getAttribute("status");
            String error = (String) request.getAttribute("error");
            
            if ("CONNECTED".equals(status)) {
        %>
            <div class="bg-green-50 border border-green-200 text-green-700 px-6 py-8 rounded-xl shadow-sm">
                <div class="flex flex-col items-center gap-4">
                    <svg class="w-12 h-12 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span class="text-xl font-bold">Koneksi Database Berhasil!</span>
                    <span class="text-sm font-medium text-green-600">(Tomcat 10 &rarr; MySQL Sukses)</span>
                </div>
            </div>
        <%
            } else if ("FAILED".equals(status)) {
        %>
            <div class="bg-red-50 border border-red-200 text-red-700 px-6 py-8 rounded-xl shadow-sm">
                <div class="flex flex-col items-center gap-4">
                    <svg class="w-12 h-12 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span class="text-xl font-bold">Koneksi Database Gagal!</span>
                    <div class="text-sm font-medium text-red-600 mt-2 bg-white p-3 rounded-md w-full text-left overflow-x-auto break-all">
                        Error: <%= error != null ? error : "Unknown error" %>
                    </div>
                </div>
            </div>
        <%
            } else {
        %>
            <p class="text-zinc-500 font-medium">Status koneksi tidak diketahui. Harap jalankan dari path /test-db.</p>
        <%
            }
        %>
        
        <div class="mt-10">
            <a href="index.jsp" class="text-rose-500 font-bold hover:text-rose-600 transition-colors">Kembali ke Beranda</a>
        </div>
    </div>
</body>
</html>
