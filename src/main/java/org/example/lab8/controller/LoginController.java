package org.example.lab8.controller;

import jakarta.servlet.http.HttpSession;
import org.example.lab8.model.User;
import org.example.lab8.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private UserService userService;

    @GetMapping
    public String showLoginForm(Model model) {
        model.addAttribute("user", new User());
        return "login";
    }

    @PostMapping
    public String processLogin(@ModelAttribute("user") User user, 
                             HttpSession session,
                             Model model) {
        if (userService.authenticate(user)) {
            User fullUser = userService.findByUsername(user.getUsername());
            session.setAttribute("user", fullUser);
            return "redirect:/dashboard";
        }
        model.addAttribute("error", "Invalid username or password");
        return "login";
    }
} 