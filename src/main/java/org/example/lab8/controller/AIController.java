package org.example.lab8.controller;

import jakarta.servlet.http.HttpSession;
import org.example.lab8.model.Book;
import org.example.lab8.model.User;
import org.example.lab8.service.AIService;
import org.example.lab8.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/ai")
public class AIController {

    @Autowired
    private AIService aiService;
    @Autowired
    private BookService bookService;

    @GetMapping("/chat")
    public String showAIChat(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        model.addAttribute("user", user);
        return "aiChat";
    }

    @PostMapping("/summary/{id}")
    public String bookSummary(@PathVariable("id") Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        Book book = bookService.getBookById(id);
        if (book == null) return "redirect:/books";
        try {
            String result = aiService.generateBookSummary(book);
            model.addAttribute("title", "AI Book Summary");
            model.addAttribute("content", result);
            return "aiResult";
        } catch (Exception e) {
            model.addAttribute("title", "AI Error");
            model.addAttribute("content", "Failed to generate summary: " + e.getMessage());
            return "aiResult";
        }
    }

    @PostMapping("/recommend/book/{id}")
    public String recommendationsByBook(@PathVariable("id") Long id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        Book book = bookService.getBookById(id);
        if (book == null) return "redirect:/books";
        try {
            String result = aiService.generateRecommendationsForBook(book);
            model.addAttribute("title", "AI Recommendations");
            model.addAttribute("content", result);
            return "aiResult";
        } catch (Exception e) {
            model.addAttribute("title", "AI Error");
            model.addAttribute("content", "Failed to generate recommendations: " + e.getMessage());
            return "aiResult";
        }
    }

    @PostMapping("/recommend/query")
    public String recommendationsByQuery(@RequestParam("q") String q, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/login";
        try {
            String result = aiService.generateRecommendationsByQuery(q);
            model.addAttribute("title", "AI Recommendations for '" + q + "'");
            model.addAttribute("content", result);
            return "aiResult";
        } catch (Exception e) {
            model.addAttribute("title", "AI Error");
            model.addAttribute("content", "Failed to generate recommendations: " + e.getMessage());
            return "aiResult";
        }
    }
}
