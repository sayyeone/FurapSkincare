<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up | FurapSkin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,500;0,600;1,400&family=Outfit:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Outfit', sans-serif; }
        .font-serif { font-family: 'Playfair Display', serif; }
    </style>
</head>
<body class="bg-[#FFF8F6] text-zinc-800 min-h-screen flex flex-col antialiased relative overflow-hidden">

    <!-- Premium Floating Header -->
    <div class="fixed top-0 inset-x-0 z-50 p-4">
        <header class="max-w-7xl mx-auto px-8 py-4 bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)] rounded-full flex items-center justify-between transition-all duration-300">
            <a href="index.jsp" class="font-serif tracking-wide text-rose-950/80 font-medium text-2xl hover:opacity-80 transition-opacity">
                FurapSkin.
            </a>
            <nav class="hidden md:flex items-center space-x-10">
                <a href="catalog" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300">Catalog</a>
                <a href="login.jsp" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300">Login</a>
                <a href="register.jsp" class="px-6 py-2.5 rounded-full bg-rose-50/50 border border-rose-200/50 text-rose-600/80 font-medium hover:bg-rose-100/50 transition-all duration-300 ease-in-out hover:-translate-y-0.5 ring-1 ring-rose-400">
                    Sign Up
                </a>
            </nav>
        </header>
    </div>

    <!-- Ambient Blurs -->
    <div class="absolute bottom-0 right-0 w-[600px] h-[600px] bg-rose-200/20 rounded-full blur-3xl -z-10 mix-blend-multiply"></div>
    <div class="absolute top-20 left-10 w-[400px] h-[400px] bg-orange-100/30 rounded-full blur-3xl -z-10 mix-blend-multiply"></div>

    <main class="flex-grow flex items-center justify-center p-6 pt-32 pb-20">
        <div class="w-full max-w-md bg-white/80 backdrop-blur-xl border border-white/80 shadow-[0_20px_60px_rgb(0,0,0,0.05)] rounded-[2.5rem] p-10 lg:p-12 transition-all duration-500 hover:shadow-[0_30px_80px_rgb(0,0,0,0.08)] hover:-translate-y-1">
            
            <div class="text-center mb-10">
                <h1 class="font-serif text-3xl font-bold text-zinc-900 tracking-tight">Create Account</h1>
                <p class="text-sm text-slate-500 mt-2 font-light">Join us to experience premium skincare.</p>
            </div>

            <% if ("true".equals(request.getParameter("error"))) { %>
                <div class="mb-6 p-4 bg-red-50/80 border border-red-100 text-red-500 rounded-2xl text-center text-sm font-medium">
                    Email already exists or invalid data.
                </div>
            <% } %>

            <form action="auth/register" method="post" class="space-y-6">
                <div>
                    <label class="block text-sm font-medium text-slate-600 mb-2">Full Name</label>
                    <input type="text" name="name" required class="w-full px-5 py-3.5 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 focus:border-rose-400 outline-none transition-all placeholder:text-zinc-400" placeholder="Jane Doe">
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-600 mb-2">Email Address</label>
                    <input type="email" name="email" required class="w-full px-5 py-3.5 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 focus:border-rose-400 outline-none transition-all placeholder:text-zinc-400" placeholder="you@example.com">
                </div>
                <div>
                    <label class="block text-sm font-medium text-slate-600 mb-2">Password</label>
                    <div class="relative">
                        <input type="password" id="password" name="password" required class="w-full px-5 py-3.5 bg-[#FFF8F6]/50 border border-zinc-200 rounded-2xl focus:ring-2 focus:ring-rose-200 focus:border-rose-400 outline-none transition-all placeholder:text-zinc-400 pr-12" placeholder="••••••••">
                        <button type="button" onclick="togglePassword('password', 'eye-icon-register')" class="absolute right-4 top-1/2 -translate-y-1/2 text-zinc-400 hover:text-rose-500 transition-colors focus:outline-none">
                            <svg id="eye-icon-register" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path></svg>
                        </button>
                    </div>
                </div>
                <button type="submit" class="w-full py-4 mt-4 bg-rose-400/90 text-white font-semibold tracking-wide rounded-full shadow-[0_8px_30px_rgb(2fb,113,133,0.3)] hover:bg-rose-500/90 hover:shadow-lg transition-all duration-300 ease-in-out hover:-translate-y-1">
                    Create Account
                </button>
            </form>

            <p class="text-center mt-8 text-zinc-500 text-sm font-light">
                Already have an account? 
                <a href="login.jsp" class="text-rose-600 font-semibold hover:text-rose-700 transition-colors underline underline-offset-4 decoration-rose-200 hover:decoration-rose-500">Sign in</a>
            </p>
        </div>
    </main>

    <script>
        function togglePassword(inputId, iconId) {
            const input = document.getElementById(inputId);
            const icon = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l18 18"></path>';
            } else {
                input.type = 'password';
                icon.innerHTML = '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"></path>';
            }
        }
    </script>
</body>
</html>
