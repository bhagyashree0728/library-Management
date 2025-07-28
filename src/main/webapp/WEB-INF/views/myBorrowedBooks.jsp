<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Borrowed Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-10">
                <div class="card">
                    <div class="card-header">
                        <h3 class="text-center">My Borrowed Books</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty overdueBooks}">
                            <div class="alert alert-danger">You have overdue books! Please return them as soon as possible.</div>
                        </c:if>
                        <c:if test="${empty borrowedBooks}">
                            <div class="alert alert-info">You have not borrowed any books.</div>
                        </c:if>
                        <c:if test="${not empty borrowedBooks}">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Author</th>
                                    <th>ISBN</th>
                                    <th>Price</th>
                                    <th>Due Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${borrowedBooks}" var="book">
                                    <tr>
                                        <td>${book.title}</td>
                                        <td>${book.author}</td>
                                        <td>${book.isbn}</td>
                                        <td>$${book.price}</td>
                                        <td>${book.dueDate}</td>
                                        <td>
                                            <form action="<c:url value='/books/return/${book.id}'/>" method="post" style="display:inline;">
                                                <button type="submit" class="btn btn-warning btn-sm">Return</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                        </c:if>
                        <a href="<c:url value='/books'/>" class="btn btn-secondary mt-3">Back to Books</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 