<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FurapSkin | Premium Aesthetic Care</title>
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
            
            <!-- Logo -->
            <a href="index.jsp" class="font-serif tracking-wide text-rose-950/80 font-medium text-2xl hover:opacity-80 transition-opacity">
                FurapSkin.
            </a>

            <!-- Desktop Nav -->
            <nav class="hidden md:flex items-center space-x-10">
                <a href="catalog" class="text-zinc-500 font-medium hover:text-rose-950/80 transition-colors duration-300">Catalog</a>
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

    <!-- Asymmetrical Fluid Hero Section -->
    <main class="flex-grow flex items-center pt-32 pb-20 lg:pt-40 lg:pb-24 overflow-hidden relative">
        
        <!-- Decorative Ambient Blurs -->
        <div class="absolute top-10 left-10 w-96 h-96 bg-rose-200/20 rounded-full blur-3xl -z-10 mix-blend-multiply"></div>
        <div class="absolute bottom-10 right-10 w-[500px] h-[500px] bg-orange-100/30 rounded-full blur-3xl -z-10 mix-blend-multiply"></div>

        <div class="max-w-7xl mx-auto px-6 w-full grid grid-cols-1 lg:grid-cols-12 gap-16 items-center">
            
            <!-- Left Text Content (7 cols) -->
            <div class="lg:col-span-6 space-y-10 max-w-2xl z-10 pl-4 lg:pl-8">
                
                <div class="inline-flex items-center space-x-2 px-4 py-2 rounded-full bg-white/60 backdrop-blur-sm border border-white/40 shadow-sm">
                    <span class="w-2 h-2 rounded-full bg-rose-400 animate-pulse"></span>
                    <span class="text-xs font-semibold text-zinc-600 tracking-widest uppercase">The Modern Ritual</span>
                </div>
                
                <h1 class="font-serif tracking-tight text-zinc-900 text-6xl lg:text-8xl leading-[1.1]">
                    Reveal <br/> 
                    <span class="italic text-rose-950/80 font-light">Luminous</span> <br/>
                    Skin
                </h1>
                
                <p class="text-lg lg:text-xl text-slate-500 leading-relaxed font-light max-w-lg">
                    Elevate your daily routine with nature-infused, science-backed formulas. 
                    Experience profound <span class="text-zinc-800 font-medium">rejuvenation</span>, 
                    deep <span class="text-zinc-800 font-medium">hydration</span>, 
                    and ultimate <span class="text-zinc-800 font-medium">protection</span>.
                </p>
                
                <div class="pt-4 flex items-center space-x-6">
                    <a href="catalog" class="inline-flex items-center justify-center py-4 px-8 bg-rose-400/80 text-white font-medium tracking-wide rounded-full shadow-[0_8px_30px_rgb(2fb,113,133,0.3)] transition-all duration-300 ease-in-out hover:-translate-y-1 hover:shadow-lg hover:bg-rose-500/90">
                        Shop Collection
                    </a>
                </div>
                
                <!-- Micro Features -->
                <div class="pt-12 grid grid-cols-2 gap-8 border-t border-zinc-200/50">
                    <div class="flex items-center space-x-4">
                        <div class="bg-rose-50/50 p-4 rounded-full text-rose-600/80 border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)]">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"></path></svg>
                        </div>
                        <span class="text-sm font-medium text-zinc-600">Clean Formula</span>
                    </div>
                    <div class="flex items-center space-x-4">
                        <div class="bg-rose-50/50 p-4 rounded-full text-rose-600/80 border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.02)]">
                            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19.428 15.428a2 2 0 00-1.022-.547l-2.387-.477a6 6 0 00-3.86.517l-.318.158a6 6 0 01-3.86.517L6.05 15.21a2 2 0 00-1.806.547M8 4h8l-1 1v5.172a2 2 0 00.586 1.414l5 5c1.26 1.26.367 3.414-1.415 3.414H4.828c-1.782 0-2.674-2.154-1.414-3.414l5-5A2 2 0 009 10.172V5L8 4z"></path></svg>
                        </div>
                        <span class="text-sm font-medium text-zinc-600">Dermatologist Tested</span>
                    </div>
                </div>

            </div>

            <!-- Right Image Content (5 cols) -->
            <div class="lg:col-span-6 relative h-[600px] lg:h-[750px] w-full flex items-center justify-center p-4">
                
                <!-- Main Glass Container for Image -->
                <div class="relative w-full h-full bg-white/40 backdrop-blur-xl border border-white/80 shadow-[0_20px_60px_rgb(0,0,0,0.05)] rounded-3xl overflow-hidden group transition-all duration-700 hover:shadow-[0_30px_80px_rgb(0,0,0,0.08)] hover:-translate-y-2">
                    
                    <img src="https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80" 
                         alt="Aesthetic Serum Bottle" 
                         class="absolute inset-0 w-full h-full object-cover opacity-95 group-hover:scale-105 transition-transform duration-1000 ease-out" />
                    
                    <!-- Lighting overlay -->
                    <div class="absolute inset-0 bg-gradient-to-t from-rose-900/10 via-transparent to-white/20 mix-blend-overlay"></div>
                </div>

                <!-- Floating Abstract Review Card -->
                <div class="absolute bottom-12 -left-8 lg:-left-16 bg-white/80 backdrop-blur-md border border-white/60 shadow-[0_8px_30px_rgb(0,0,0,0.04)] p-6 rounded-2xl w-64 transition-all duration-300 ease-in-out hover:-translate-y-2">
                    <div class="flex items-center space-x-1 mb-3">
                        <svg class="w-4 h-4 text-rose-400 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        <svg class="w-4 h-4 text-rose-400 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        <svg class="w-4 h-4 text-rose-400 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        <svg class="w-4 h-4 text-rose-400 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                        <svg class="w-4 h-4 text-rose-400 fill-current" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                    </div>
                    <p class="text-sm text-zinc-600 font-medium leading-relaxed italic">"My skin has never felt this plump and hydrated. Truly a holy grail."</p>
                    <p class="text-xs text-slate-400 mt-2">— Sarah K.</p>
                </div>

            </div>
            
        </div>
    </main>

</body>
</html>
