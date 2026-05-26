package com.ecommerce.util;

import com.ecommerce.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Admin paneline yetkisiz erişimi engelleyen Filter.
 * /admin/login ve /admin/login/* hariç tüm /admin/* URL'lerine uygulanır.
 */
public class AdminAuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();

        // Admin login sayfası filtreye takılmamalı
        if (uri.equals(contextPath + "/admin/login") ||
            uri.equals(contextPath + "/admin/login/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("adminUser") : null;

        if (adminUser != null && "admin".equals(adminUser.getRole())) {
            chain.doFilter(request, response);
        } else {
            resp.sendRedirect(contextPath + "/admin/login");
        }
    }
}
