<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="content" value="books/view" scope="request"/>
<c:set var="title" value="Book Details" scope="request"/>
<jsp:include page="/WEB-INF/views/layout.jsp"/>

<h2>${book.title}</h2>
<p><strong>Author:</strong> ${book.author}</p>
<p><strong>ISBN:</strong> ${book.isbn}</p>
<p><strong>Publication Date:</strong> ${book.publicationDate}</p>

<a href="<c:url value='/books' />" class="btn btn-secondary">Back</a>
<a href="<c:url value='/books/edit/${book.id}' />" class="btn btn-primary">Edit</a>