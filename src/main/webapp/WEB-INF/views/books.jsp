<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Books</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="<c:url value='/dashboard'/>">Dashboard</a>
                <a class="nav-link" href="<c:url value='/ai/chat'/>">🤖 AI Chat</a>
                <a class="nav-link" href="<c:url value='/logout'/>">Logout</a>
                <c:if test="${user.role == 'USER'}">
                    <a class="nav-link" href="<c:url value='/books/borrowed'/>">My Borrowed Books</a>
                </c:if>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <form class="row mb-3" method="get" action="<c:url value='/books'/>">
            <div class="col-md-3">
                <input type="text" class="form-control" name="query" placeholder="Search by title, author, ISBN" value="${query != null ? query : ''}">
            </div>
            <div class="col-md-2">
                <input type="number" step="0.01" class="form-control" name="minPrice" placeholder="Min Price" value="${minPrice != null ? minPrice : ''}">
            </div>
            <div class="col-md-2">
                <input type="number" step="0.01" class="form-control" name="maxPrice" placeholder="Max Price" value="${maxPrice != null ? maxPrice : ''}">
            </div>
            <div class="col-md-2">
                <select class="form-control" name="sortBy">
                    <option value="">Sort By</option>
                    <option value="title" ${sortBy == 'title' ? 'selected' : ''}>Title</option>
                    <option value="author" ${sortBy == 'author' ? 'selected' : ''}>Author</option>
                    <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Price</option>
                </select>
            </div>
            <div class="col-md-1">
                <select class="form-control" name="order">
                    <option value="asc" ${order == 'asc' ? 'selected' : ''}>Asc</option>
                    <option value="desc" ${order == 'desc' ? 'selected' : ''}>Desc</option>
                </select>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">Search/Filter</button>
            </div>
        </form>
        <div class="row">
            <div class="col-md-12">
                <div class="card">
                    <div class="card-header">
                        <h3>Add New Book</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${user.role == 'ADMIN'}">
                        <form action="<c:url value='/books'/>" method="post">
                            <div class="row">
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Title</label>
                                        <input type="text" class="form-control" id="title" name="title" required>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="author" class="form-label">Author</label>
                                        <input type="text" class="form-control" id="author" name="author" required>
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <div class="mb-3">
                                        <label for="isbn" class="form-label">ISBN</label>
                                        <input type="text" class="form-control" id="isbn" name="isbn" required>
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="mb-3">
                                        <label for="price" class="form-label">Price</label>
                                        <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                                    </div>
                                </div>
                                <div class="col-md-1">
                                    <div class="mb-3">
                                        <label class="form-label">&nbsp;</label>
                                        <button type="submit" class="btn btn-primary w-100">Add</button>
                                    </div>
                                </div>
                            </div>
                        </form>
                        </c:if>
                    </div>
                </div>

                <!-- AI Chatbot and Recommendations Section -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">🤖 AI Library Assistant</h5>
                            </div>
                            <div class="card-body">
                                <div id="chat-messages" style="height: 200px; overflow-y: auto; border: 1px solid #ddd; padding: 10px; margin-bottom: 15px; background: #f8f9fa;">
                                    <div class="text-muted text-center">Ask me about books, genres, or get recommendations!</div>
                                </div>
                                <div class="input-group">
                                    <input type="text" id="chat-input" class="form-control" placeholder="Ask about books, genres, authors...">
                                    <button class="btn btn-primary" onclick="sendChatMessage()">Send</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">📚 Get AI Recommendations</h5>
                            </div>
                            <div class="card-body">
                                <form action="<c:url value='/ai/recommend/query'/>" method="post">
                                    <div class="mb-3">
                                        <label for="recommendation-query" class="form-label">What are you interested in?</label>
                                        <input type="text" class="form-control" id="recommendation-query" name="q" 
                                               placeholder="e.g., science fiction, mystery novels, programming books, romance" required>
                                    </div>
                                    <button type="submit" class="btn btn-info w-100">Get AI Recommendations</button>
                                </form>
                                <div class="mt-3">
                                    <small class="text-muted">
                                        💡 Try: "books like Harry Potter", "programming for beginners", "mystery novels", "romance books"
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header">
                        <h3>Book List</h3>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th><a href="?sortBy=title&order=${order == 'asc' ? 'desc' : 'asc'}">Title</a></th>
                                        <th><a href="?sortBy=author&order=${order == 'asc' ? 'desc' : 'asc'}">Author</a></th>
                                        <th>ISBN</th>
                                        <th><a href="?sortBy=price&order=${order == 'asc' ? 'desc' : 'asc'}">Price</a></th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${books}" var="book">
                                        <tr>
                                            <td>${book.id}</td>
                                            <td>${book.title}</td>
                                            <td>${book.author}</td>
                                            <td>${book.isbn}</td>
                                            <td>$${book.price}</td>
                                            <td>
                                                <c:if test="${user.role == 'ADMIN'}">
                                                    <a href="<c:url value='/books/edit/${book.id}'/>" class="btn btn-sm btn-primary">Edit</a>
                                                    <a href="<c:url value='/books/delete/${book.id}'/>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this book?')">Delete</a>
                                                </c:if>
                                                <c:if test="${user.role == 'USER'}">
                                                    <c:choose>
                                                        <c:when test="${empty book.borrowedBy}">
                                                            <form action="<c:url value='/books/borrow/${book.id}'/>" method="post" style="display:inline;">
                                                                <button type="submit" class="btn btn-success btn-sm">Borrow</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${book.borrowedBy == user.username}">
                                                            <form action="<c:url value='/books/return/${book.id}'/>" method="post" style="display:inline;">
                                                                <button type="submit" class="btn btn-warning btn-sm">Return</button>
                                                            </form>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Not available</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <form action="<c:url value='/ai/summary/${book.id}'/>" method="post" style="display:inline;">
                                                    <button type="submit" class="btn btn-outline-secondary btn-sm">AI Summary</button>
                                                </form>
                                                <form action="<c:url value='/ai/recommend/book/${book.id}'/>" method="post" style="display:inline;">
                                                    <button type="submit" class="btn btn-outline-info btn-sm">AI Recs</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <nav aria-label="Book pagination">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}&query=${query}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&order=${order}">Previous</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${i}&size=${pageSize}&query=${query}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&order=${order}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}&query=${query}&minPrice=${minPrice}&maxPrice=${maxPrice}&sortBy=${sortBy}&order=${order}">Next</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Chatbot JavaScript -->
    <script>
        let chatHistory = [];
        
        function sendChatMessage() {
            const input = document.getElementById('chat-input');
            const message = input.value.trim();
            if (!message) return;
            
            // Add user message to chat
            addChatMessage('You', message, 'user');
            input.value = '';
            
            // Simulate AI response (you can replace this with actual API calls)
            setTimeout(() => {
                const aiResponse = generateAIResponse(message);
                addChatMessage('AI Assistant', aiResponse, 'ai');
            }, 1000);
        }
        
        function addChatMessage(sender, message, type) {
            const chatMessages = document.getElementById('chat-messages');
            const messageDiv = document.createElement('div');
            messageDiv.className = 'mb-2 ' + (type === 'user' ? 'text-end' : '');
            
            const badge = document.createElement('span');
            badge.className = 'badge ' + (type === 'user' ? 'bg-primary' : 'bg-success') + ' me-2';
            badge.textContent = sender;
            
            const textSpan = document.createElement('span');
            textSpan.className = 'bg-white p-2 rounded border';
            textSpan.style.display = 'inline-block';
            textSpan.style.maxWidth = '80%';
            textSpan.style.wordWrap = 'break-word';
            textSpan.textContent = message;
            
            messageDiv.appendChild(badge);
            messageDiv.appendChild(textSpan);
            chatMessages.appendChild(messageDiv);
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Store in history
            chatHistory.push({ sender, message, type });
        }
        
        function generateAIResponse(userMessage) {
            const lowerMessage = userMessage.toLowerCase();
            
            if (lowerMessage.includes('hello') || lowerMessage.includes('hi')) {
                return "Hello! I'm your AI library assistant. I can help you find books, get recommendations, and answer questions about our collection. What would you like to know?";
            }
            
            if (lowerMessage.includes('recommend') || lowerMessage.includes('suggestion')) {
                return "Great! I can recommend books based on your interests. Try using the recommendation form on the right, or ask me about specific genres like 'mystery novels' or 'science fiction'.";
            }
            
            if (lowerMessage.includes('genre') || lowerMessage.includes('type')) {
                return "We have books across many genres: Fiction, Non-Fiction, Science, History, Mystery, Romance, Programming, and more. What interests you?";
            }
            
            if (lowerMessage.includes('borrow') || lowerMessage.includes('check out')) {
                return "To borrow a book, simply click the 'Borrow' button next to any available book. You can return it later using the 'Return' button. Books are typically due in 7 days.";
            }
            
            if (lowerMessage.includes('return') || lowerMessage.includes('due date')) {
                return "You can return books by clicking the 'Return' button. Check 'My Borrowed Books' to see what you have borrowed and when they're due.";
            }
            
            if (lowerMessage.includes('search') || lowerMessage.includes('find')) {
                return "Use the search and filter options above to find specific books. You can search by title, author, ISBN, or filter by price range.";
            }
            
            if (lowerMessage.includes('admin') || lowerMessage.includes('manage')) {
                return "Admin users can add, edit, and delete books, as well as manage users. Regular users can borrow/return books and get recommendations.";
            }
            
            // Default response
            return "I'm here to help with your library needs! You can ask me about books, genres, borrowing, or use the recommendation form for personalized suggestions.";
        }
        
        // Enter key support for chat
        document.getElementById('chat-input').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                sendChatMessage();
            }
        });
        
        // Add welcome message
        window.addEventListener('load', function() {
            setTimeout(() => {
                addChatMessage('AI Assistant', "Welcome to the Library! I'm your AI assistant. How can I help you today?", 'ai');
            }, 500);
        });
    </script>
</body>
</html> 