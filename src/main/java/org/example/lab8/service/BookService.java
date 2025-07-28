package org.example.lab8.service;

import org.example.lab8.model.Book;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.io.*;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

@Service
public class BookService {
    private final List<Book> books = new ArrayList<>();
    private final AtomicLong idGenerator = new AtomicLong(1);
    private static final String BOOKS_FILE = "books.json";
    private final Gson gson = new Gson();

    public BookService() {
        List<Book> loaded = loadBooksFromFile();
        if (loaded.isEmpty()) {
            addBook(new Book("The Great Gatsby", "F. Scott Fitzgerald", "978-0743273565", 9.99));
            addBook(new Book("To Kill a Mockingbird", "Harper Lee", "978-0446310789", 12.99));
            addBook(new Book("1984", "George Orwell", "978-0451524935", 8.99));
            saveBooksToFile();
        } else {
            books.addAll(loaded);
            // set idGenerator to max existing id + 1
            long maxId = books.stream().mapToLong(b -> b.getId() != null ? b.getId() : 0).max().orElse(0L);
            idGenerator.set(maxId + 1);
        }
    }

    private List<Book> loadBooksFromFile() {
        try (Reader reader = new FileReader(BOOKS_FILE)) {
            return gson.fromJson(reader, new TypeToken<List<Book>>(){}.getType());
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    private void saveBooksToFile() {
        try (Writer writer = new FileWriter(BOOKS_FILE)) {
            gson.toJson(books, writer);
        } catch (Exception e) {
            // log error
        }
    }

    public List<Book> getAllBooks() {
        return new ArrayList<>(books);
    }

    public Book getBookById(Long id) {
        return books.stream()
                .filter(book -> book.getId().equals(id))
                .findFirst()
                .orElse(null);
    }

    public void addBook(Book book) {
        book.setId(idGenerator.getAndIncrement());
        books.add(book);
        saveBooksToFile();
    }

    public void updateBook(Book book) {
        for (int i = 0; i < books.size(); i++) {
            if (books.get(i).getId().equals(book.getId())) {
                books.set(i, book);
                saveBooksToFile();
                break;
            }
        }
    }

    public void deleteBook(Long id) {
        books.removeIf(book -> book.getId().equals(id));
        saveBooksToFile();
    }

    public boolean borrowBook(Long bookId, String username) {
        Book book = getBookById(bookId);
        if (book != null && book.getBorrowedBy() == null) {
            book.setBorrowedBy(username);
            LocalDate due = LocalDate.now().plusDays(7);
            book.setDueDate(due.format(DateTimeFormatter.ISO_DATE));
            saveBooksToFile();
            return true;
        }
        return false;
    }

    public boolean returnBook(Long bookId, String username) {
        Book book = getBookById(bookId);
        if (book != null && username.equals(book.getBorrowedBy())) {
            book.setBorrowedBy(null);
            book.setDueDate(null);
            saveBooksToFile();
            return true;
        }
        return false;
    }

    public List<Book> getBooksBorrowedBy(String username) {
        List<Book> borrowed = new ArrayList<>();
        for (Book book : books) {
            if (username.equals(book.getBorrowedBy())) {
                borrowed.add(book);
            }
        }
        return borrowed;
    }

    public List<Book> searchBooks(String query) {
        List<Book> result = new ArrayList<>();
        for (Book book : books) {
            if ((book.getTitle() != null && book.getTitle().toLowerCase().contains(query.toLowerCase())) ||
                (book.getAuthor() != null && book.getAuthor().toLowerCase().contains(query.toLowerCase())) ||
                (book.getIsbn() != null && book.getIsbn().toLowerCase().contains(query.toLowerCase()))) {
                result.add(book);
            }
        }
        return result;
    }

    public List<Book> filterBooksByPrice(double minPrice, double maxPrice) {
        List<Book> result = new ArrayList<>();
        for (Book book : books) {
            if (book.getPrice() >= minPrice && book.getPrice() <= maxPrice) {
                result.add(book);
            }
        }
        return result;
    }

    public List<Book> sortBooks(List<Book> bookList, String sortBy, boolean ascending) {
        bookList.sort((b1, b2) -> {
            int cmp = 0;
            switch (sortBy) {
                case "title":
                    cmp = b1.getTitle().compareToIgnoreCase(b2.getTitle());
                    break;
                case "author":
                    cmp = b1.getAuthor().compareToIgnoreCase(b2.getAuthor());
                    break;
                case "price":
                    cmp = Double.compare(b1.getPrice(), b2.getPrice());
                    break;
            }
            return ascending ? cmp : -cmp;
        });
        return bookList;
    }

    public List<Book> getOverdueBooks(String username) {
        List<Book> overdue = new ArrayList<>();
        LocalDate today = LocalDate.now();
        for (Book book : books) {
            if (username.equals(book.getBorrowedBy()) && book.getDueDate() != null) {
                LocalDate due = LocalDate.parse(book.getDueDate());
                if (due.isBefore(today)) {
                    overdue.add(book);
                }
            }
        }
        return overdue;
    }

    public List<Book> getBooksPage(List<Book> books, int page, int size) {
        int fromIndex = Math.max(0, (page - 1) * size);
        int toIndex = Math.min(books.size(), fromIndex + size);
        if (fromIndex > toIndex) return new ArrayList<>();
        return books.subList(fromIndex, toIndex);
    }
} 