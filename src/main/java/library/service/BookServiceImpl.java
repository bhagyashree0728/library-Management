package library.service;

import library.model.Book;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

@Service
public class BookServiceImpl implements BookService {
    private final List<Book> books = new ArrayList<>();
    private final AtomicLong counter = new AtomicLong();

    public BookServiceImpl() {
        // Initialize with sample data
        addBook(new Book(counter.incrementAndGet(), "The Great Gatsby", "F. Scott Fitzgerald", "9780743273565", "1925-04-10"));
        addBook(new Book(counter.incrementAndGet(), "To Kill a Mockingbird", "Harper Lee", "9780061120084", "1960-07-11"));
    }

    @Override public List<Book> getAllBooks() { return new ArrayList<>(books); }
    @Override public Book getBookById(Long id) { return books.stream().filter(b -> b.getId().equals(id)).findFirst().orElse(null); }
    @Override public void addBook(Book book) { book.setId(counter.incrementAndGet()); books.add(book); }
    @Override public void updateBook(Book book) { int index = books.indexOf(getBookById(book.getId())); if (index != -1) books.set(index, book); }
    @Override public void deleteBook(Long id) { books.removeIf(b -> b.getId().equals(id)); }
    @Override public boolean isIsbnUnique(String isbn) { return books.stream().noneMatch(b -> b.getIsbn().equals(isbn)); }
}