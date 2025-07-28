<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="content" value="books/edit" scope="request"/>
<c:set var="title" value="Edit Book" scope="request"/>
<jsp:include page="/WEB-INF/views/layout.jsp"/>

<h2>Edit Book</h2>
<form:form modelAttribute="book">
    <form:hidden path="id"/>
    <div class="mb-3">
        <form:label path="title" class="form-label">Title</form:label>
        <form:input path="title" class="form-control" required="true"/>
    </div>
    <div class="mb-3">
        <form:label path="author" class="form-label">Author</form:label>
        <form:input path="author" class="form-control" required="true"/>
    </div>
    <div class="mb-3">
        <form:label path="isbn" class="form-label">ISBN</form:label>
        <form:input path="isbn" class="form-control" required="true"/>
    </div>
    <div class="mb-3">
        <form:label path="publicationDate" class="form-label">Publication Date</form:label>
        <form:input path="publicationDate" type="date" class="form-control" required="true"/>
    </div>
    <button type="submit" class="btn btn-primary">Update</button>
</form:form>