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
</body>
</html> 