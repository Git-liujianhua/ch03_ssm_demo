package com.demo.controller;

import com.demo.entity.User;
import com.demo.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/user/")
public class UserController {

    @Resource
    private UserService userService;

    @RequestMapping("registerUser.do")
    public String registerUser(User user,Model model){
        // 根据用户名查询数据库是否已经存在
        User u = userService.queryUserByUsername(user.getUsername());
        if (u != null) {
            model.addAttribute("tips", "用户名已存在！");
            return "pages/user/register";
        }
        // 用户不存在，进行添加
        userService.addUser(user);
        model.addAttribute("tips", "恭喜用户【"+user.getUsername()+"】注册成功！");
        return "redirect:/pages/user/login.jsp";
    }

    @RequestMapping("loginUser.do")
    public String loginUser(User user, Model model, HttpSession session){
        // 根据用户名和密码查询到用户
        User u = userService.queryUserByUsername(user.getUsername());
        // 如果u为空，说明这个用户不存在，提示用户
        if (u == null) {
            model.addAttribute("tips", "用户名或密码错误！");
            return "pages/user/login";
        } else {
            // 存在，比对u的密码和user是否相同，如果不同，登录失败
            if (!u.getPassword().equals(user.getPassword())) {
                model.addAttribute("tips", "用户名或密码错误！");
                return "pages/user/login";
            }
        }
        // 登录成功，放到session
        session.setAttribute("user", u);
        model.addAttribute("tips", "恭喜【"+ user.getUsername() + "】登录成功！！！");
        // 重定向到首页
        return "redirect:/pages/views/listStudent.jsp";
    }

}
