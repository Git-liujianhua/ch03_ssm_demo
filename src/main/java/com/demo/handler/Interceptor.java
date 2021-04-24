package com.demo.handler;

import com.demo.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Interceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        String url = request.getRequestURI();
        if(!url.contains("loginUser.do")) {
            User user = (User) request.getSession().getAttribute("user");
            if(user==null) {
                response.sendRedirect(request.getContextPath() + "/pages/user/login.jsp");
                return false;
            }
        }
        return true;
    }
}
