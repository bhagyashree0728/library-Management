package org.example.lab8.controller;

import jakarta.servlet.http.HttpSession;
import org.example.lab8.model.Book;
import org.example.lab8.model.User;
import org.example.lab8.service.BookService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/books")
public class BookController {

    @Autowired
    private BookService bookService;

    @GetMapping
    public String listBooks(@RequestParam(value = "query", required = false) String query,
                            @RequestParam(value = "minPrice", required = false) Double minPrice,
                            @RequestParam(value = "maxPrice", required = false) Double maxPrice,
                            @RequestParam(value = "sortBy", required = false) String sortBy,
                            @RequestParam(value = "order", required = false) String order,
                            @RequestParam(value = "page", required = false, defaultValue = "1") int page,
                            @RequestParam(value = "size", required = false, defaultValue = "5") int size,
                            Model model, HttpSession session) {
        if (session.getAttribute("user") == null) {
            return "redirect:/login";
        }
        List<Book> books = bookService.getAllBooks();
        if (query != null && !query.isEmpty()) {
            books = bookService.searchBooks(query);
        }
        if (minPrice != null && maxPrice != null) {
            books = bookService.filterBooksByPrice(minPrice, maxPrice);
        }
        if (sortBy != null && !sortBy.isEmpty()) {
            books = bookService.sortBooks(books, sortBy, "asc".equalsIgnoreCase(order));
        }
        int totalBooks = books.size();
        int totalPages = (int) Math.ceil((double) totalBooks / size);
        books = bookService.getBooksPage(books, page, size);
        model.addAttribute("books", books);
        model.addAttribute("book", new Book());
        model.addAttribute("query", query);
        model.addAttribute("minPrice", minPrice);
        model.addAttribute("maxPrice", maxPrice);
        model.addAttribute("sortBy", sortBy);
        model.addAttribute("order", order);
        model.addAttribute("user", session.getAttribute("user"));
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("currentPage", page);
        model.addAttribute("pageSize", size);
        return "books";
    }

    @PostMapping
    public String addBook(@ModelAttribute("book") Book book, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }
        bookService.addBook(book);
        return "redirect:/books";
    }

    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable("id") Long id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }
        model.addAttribute("book", bookService.getBookById(id));
        return "editBook";
    }

    @PostMapping("/edit/{id}")
    public String updateBook(@PathVariable("id") Long id, @ModelAttribute("book") Book book, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }
        book.setId(id);
        bookService.updateBook(book);
        return "redirect:/books";
    }

    @GetMapping("/delete/{id}")
    public String deleteBook(@PathVariable("id") Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }
        if (!"ADMIN".equals(user.getRole())) {
            return "redirect:/dashboard";
        }
        bookService.deleteBook(id);
        return "redirect:/books";
    }

    @PostMapping("/borrow/{id}")
    public String borrowBook(@PathVariable("id") Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"USER".equals(user.getRole())) {
            return "redirect:/login";
        }
        bookService.borrowBook(id, user.getUsername());
        return "redirect:/books";
    }

    @PostMapping("/return/{id}")
    public String returnBook(@PathVariable("id") Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"USER".equals(user.getRole())) {
            return "redirect:/login";
        }
        bookService.returnBook(id, user.getUsername());
        return "redirect:/books/borrowed";
    }

    @GetMapping("/borrowed")
    public String myBorrowedBooks(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"USER".equals(user.getRole())) {
            return "redirect:/login";
        }
        List<Book> borrowed = bookService.getBooksBorrowedBy(user.getUsername());
        List<Book> overdue = bookService.getOverdueBooks(user.getUsername());
        model.addAttribute("borrowedBooks", borrowed);
        model.addAttribute("overdueBooks", overdue);
        return "myBorrowedBooks";
    }
} 