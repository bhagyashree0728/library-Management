<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Library Assistant</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .chat-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }
        .chat-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px 20px 0 0;
            padding: 20px;
        }
        .chat-messages {
            height: 500px;
            overflow-y: auto;
            padding: 20px;
            background: #f8f9fa;
        }
        .message {
            margin-bottom: 15px;
            display: flex;
            align-items: flex-start;
        }
        .message.user {
            flex-direction: row-reverse;
        }
        .message-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            font-size: 18px;
        }
        .message.user .message-avatar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .message.ai .message-avatar {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .message-content {
            max-width: 70%;
            padding: 12px 16px;
            border-radius: 18px;
            word-wrap: break-word;
        }
        .message.user .message-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .message.ai .message-content {
            background: white;
            border: 1px solid #e9ecef;
            color: #333;
        }
        .typing-indicator {
            display: none;
            padding: 12px 16px;
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 18px;
            margin-left: 50px;
        }
        .typing-dots {
            display: inline-block;
        }
        .typing-dots span {
            display: inline-block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #999;
            margin: 0 2px;
            animation: typing 1.4s infinite ease-in-out;
        }
        .typing-dots span:nth-child(2) { animation-delay: 0.2s; }
        .typing-dots span:nth-child(3) { animation-delay: 0.4s; }
        @keyframes typing {
            0%, 60%, 100% { transform: translateY(0); opacity: 0.4; }
            30% { transform: translateY(-10px); opacity: 1; }
        }
        .chat-input-container {
            padding: 20px;
            background: white;
            border-radius: 0 0 20px 20px;
        }
        .quick-actions {
            margin-bottom: 15px;
        }
        .quick-action-btn {
            margin: 2px;
            font-size: 12px;
            padding: 6px 12px;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="chat-container">
                    <div class="chat-header text-center">
                        <h3><i class="fas fa-robot me-2"></i>AI Library Assistant</h3>
                        <p class="mb-0">Your intelligent guide to the world of books</p>
                    </div>
                    
                    <div class="chat-messages" id="chat-messages">
                        <div class="message ai">
                            <div class="message-avatar">
                                <i class="fas fa-robot"></i>
                            </div>
                            <div class="message-content">
                                Hello! I'm your AI library assistant. I can help you with:
                                <ul class="mb-0 mt-2">
                                    <li>Book recommendations and summaries</li>
                                    <li>Finding books by genre or interest</li>
                                    <li>Library policies and procedures</li>
                                    <li>Reading suggestions and tips</li>
                                </ul>
                                How can I assist you today?
                            </div>
                        </div>
                    </div>
                    
                    <div class="typing-indicator" id="typing-indicator">
                        <div class="typing-dots">
                            <span></span>
                            <span></span>
                            <span></span>
                        </div>
                        AI is typing...
                    </div>
                    
                    <div class="chat-input-container">
                        <div class="quick-actions">
                            <button class="btn btn-outline-primary btn-sm quick-action-btn" onclick="sendQuickMessage('Recommend mystery novels')">Mystery</button>
                            <button class="btn btn-outline-primary btn-sm quick-action-btn" onclick="sendQuickMessage('Show me science fiction books')">Sci-Fi</button>
                            <button class="btn btn-outline-primary btn-sm quick-action-btn" onclick="sendQuickMessage('Programming books for beginners')">Programming</button>
                            <button class="btn btn-outline-primary btn-sm quick-action-btn" onclick="sendQuickMessage('Romance novels')">Romance</button>
                            <button class="btn btn-outline-primary btn-sm quick-action-btn" onclick="sendQuickMessage('How do I borrow a book?')">Borrowing</button>
                        </div>
                        
                        <div class="input-group">
                            <input type="text" id="chat-input" class="form-control" placeholder="Ask me anything about books, genres, or the library..." onkeypress="handleKeyPress(event)">
                            <button class="btn btn-primary" onclick="sendMessage()">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="<c:url value='/books'/>" class="btn btn-outline-secondary btn-sm me-2">
                                <i class="fas fa-books"></i> Browse Books
                            </a>
                            <a href="<c:url value='/dashboard'/>" class="btn btn-outline-secondary btn-sm">
                                <i class="fas fa-tachometer-alt"></i> Dashboard
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        let chatHistory = [];
        
        function sendQuickMessage(message) {
            document.getElementById('chat-input').value = message;
            sendMessage();
        }
        
        function handleKeyPress(event) {
            if (event.key === 'Enter') {
                sendMessage();
            }
        }
        
        function sendMessage() {
            const input = document.getElementById('chat-input');
            const message = input.value.trim();
            if (!message) return;
            
            // Add user message
            addMessage('user', message);
            input.value = '';
            
            // Show typing indicator
            showTypingIndicator();
            
            // Simulate AI response
            setTimeout(() => {
                hideTypingIndicator();
                const aiResponse = generateAIResponse(message);
                addMessage('ai', aiResponse);
            }, 1500 + Math.random() * 1000);
        }
        
        function addMessage(type, content) {
            const chatMessages = document.getElementById('chat-messages');
            const messageDiv = document.createElement('div');
            messageDiv.className = 'message ' + type;
            
            const avatar = document.createElement('div');
            avatar.className = 'message-avatar';
            avatar.innerHTML = (type === 'user') ? '<i class="fas fa-user"></i>' : '<i class="fas fa-robot"></i>';
            
            const messageContent = document.createElement('div');
            messageContent.className = 'message-content';
            messageContent.innerHTML = content;
            
            messageDiv.appendChild(avatar);
            messageDiv.appendChild(messageContent);
            chatMessages.appendChild(messageDiv);
            
            // Scroll to bottom
            chatMessages.scrollTop = chatMessages.scrollHeight;
            
            // Store in history
            chatHistory.push({ type: type, content: content, timestamp: new Date() });
        }
        
        function showTypingIndicator() {
            document.getElementById('typing-indicator').style.display = 'block';
            document.getElementById('chat-messages').scrollTop = document.getElementById('chat-messages').scrollHeight;
        }
        
        function hideTypingIndicator() {
            document.getElementById('typing-indicator').style.display = 'none';
        }
        
        function generateAIResponse(userMessage) {
            const lowerMessage = userMessage.toLowerCase();
            
            // Enhanced responses with more personality
            if (lowerMessage.includes('hello') || lowerMessage.includes('hi') || lowerMessage.includes('hey')) {
                return "Hello there! 👋 I'm excited to help you discover amazing books today. What would you like to explore?";
            }
            
            if (lowerMessage.includes('mystery') || lowerMessage.includes('thriller')) {
                return "🔍 Great choice! Mystery and thriller novels are perfect for keeping you on the edge of your seat. I'd recommend checking out authors like Agatha Christie, Dan Brown, or Gillian Flynn. Would you like me to suggest some specific titles?";
            }
            
            if (lowerMessage.includes('science fiction') || lowerMessage.includes('sci-fi') || lowerMessage.includes('scifi')) {
                return "🚀 Science fiction opens up incredible worlds! From classics like 'Dune' by Frank Herbert to modern gems like 'The Martian' by Andy Weir, there's something for every sci-fi fan. Are you interested in space exploration, time travel, or dystopian futures?";
            }
            
            if (lowerMessage.includes('programming') || lowerMessage.includes('coding') || lowerMessage.includes('computer')) {
                return "💻 Programming books are essential for tech enthusiasts! For beginners, I'd suggest 'Python Crash Course' or 'Head First Java'. For more advanced topics, try 'Clean Code' by Robert Martin. What's your current skill level?";
            }
            
            if (lowerMessage.includes('romance') || lowerMessage.includes('love story')) {
                return "💕 Romance novels have the power to warm your heart! From contemporary romance to historical fiction, there are countless love stories waiting for you. Authors like Nicholas Sparks, Colleen Hoover, and Julia Quinn are popular choices. What type of romance interests you?";
            }
            
            if (lowerMessage.includes('borrow') || lowerMessage.includes('check out') || lowerMessage.includes('loan')) {
                return "📚 Borrowing books is easy! Simply click the 'Borrow' button next to any available book. You'll have 7 days to enjoy it, and you can return it anytime using the 'Return' button. Check 'My Borrowed Books' to see what you currently have borrowed.";
            }
            
            if (lowerMessage.includes('genre') || lowerMessage.includes('type') || lowerMessage.includes('category')) {
                return "📖 We have a diverse collection across many genres: Fiction, Non-Fiction, Science, History, Mystery, Romance, Programming, Business, Self-Help, and more! Each genre offers unique perspectives and experiences. What interests you most?";
            }
            
            if (lowerMessage.includes('recommend') || lowerMessage.includes('suggestion') || lowerMessage.includes('suggest')) {
                return "🎯 I love making book recommendations! To get personalized suggestions, try using the recommendation form on the books page, or tell me more about what you're looking for. What genres, themes, or authors do you enjoy?";
            }
            
            if (lowerMessage.includes('thank')) {
                return "You're very welcome! 😊 I'm here to help make your library experience amazing. Is there anything else you'd like to know about our books or services?";
            }
            
            // Default response with suggestions
            return "That's an interesting question! 🤔 I can help you with book recommendations, summaries, finding specific genres, or explaining how our library works. Try asking me about mystery novels, programming books, or how to borrow books. What would you like to explore?";
        }
    </script>
</body>
</html>
