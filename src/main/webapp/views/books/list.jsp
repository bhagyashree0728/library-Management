<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="content" value="books/list" scope="request"/>
<c:set var="title" value="Books" scope="request"/>
<jsp:include page="/WEB-INF/views/layout.jsp"/>

<h2>Book List</h2>
<a href="<c:url value='/books/add' />" class="btn btn-primary mb-3">Add Book</a>

<table class="table table-striped">
    <thead>
        <tr>
            <th>ID</th>
            <th>Title</th>
            <th>Author</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach items="${books}" var="book">
            <tr>
                <td>${book.id}</td>
                <td>${book.title}</td>
                <td>${book.author}</td>
                <td>
                    <a href="<c:url value='/books/view/${book.id}' />" class="btn btn-sm btn-info">View</a>
                    <a href="<c:url value='/books/edit/${book.id}' />" class="btn btn-sm btn-warning">Edit</a>
                    <a href="<c:url value='/books/delete/${book.id}' />" class="btn btn-sm btn-danger"
                       onclick="return confirm('Delete this book?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>