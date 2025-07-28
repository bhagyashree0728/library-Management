package org.example.lab8.controller;

import jakarta.servlet.http.HttpSession;
import org.example.lab8.model.User;
import org.example.lab8.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/users")
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping
    public String listUsers(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }
        List<User> users = userService.getAllUsers();
        model.addAttribute("users", users);
        return "users";
    }

    @GetMapping("/edit/{username}")
    public String showEditUser(@PathVariable String username, HttpSession session, Model model) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            return "redirect:/dashboard";
        }
        User user = userService.findByUsername(username);
        if (user == null) {
            return "redirect:/users";
        }
        model.addAttribute("userToEdit", user);
        return "editUser";
    }

    @PostMapping("/edit/{username}")
    public String editUser(@PathVariable String username, @ModelAttribute("userToEdit") User user, HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            return "redirect:/dashboard";
        }
        userService.updateUser(user);
        return "redirect:/users";
    }

    @PostMapping("/delete/{username}")
    public String deleteUser(@PathVariable String username, HttpSession session) {
        User admin = (User) session.getAttribute("user");
        if (admin == null || !"ADMIN".equals(admin.getRole())) {
            return "redirect:/dashboard";
        }
        userService.deleteUser(username);
        return "redirect:/users";
    }

    @GetMapping("/profile")
    public String viewProfile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        model.addAttribute("profile", user);
        return "profile";
    }

    @PostMapping("/profile")
    public String editProfile(@ModelAttribute("profile") User updated, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        updated.setRole(user.getRole()); // Prevent role change
        userService.updateUser(updated);
        session.setAttribute("user", updated);
        return "redirect:/users/profile";
    }
} 