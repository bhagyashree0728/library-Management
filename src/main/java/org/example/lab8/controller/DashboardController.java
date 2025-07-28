package org.example.lab8.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.example.lab8.service.BookService;
import org.example.lab8.service.UserService;
import org.example.lab8.model.User;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private BookService bookService;
    @Autowired
    private UserService userService;

    @GetMapping
    public String showDashboard(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if ("ADMIN".equals(user.getRole())) {
            model.addAttribute("totalBooks", bookService.getAllBooks().size());
            model.addAttribute("totalUsers", userService.getAllUsers().size());
        }
        model.addAttribute("user", user);
        return "dashboard";
    }
} 