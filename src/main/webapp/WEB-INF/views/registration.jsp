<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
        }
        .register-hero {
            background: linear-gradient(135deg, #f7971e 0%, #ffd200 100%);
            color: #fff;
            border-radius: 1.5rem;
            padding: 2.5rem 2rem 2rem 2rem;
            margin-top: 3rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            text-align: center;
        }
        .register-hero img {
            max-width: 100px;
            margin-bottom: 1rem;
        }
        .register-card {
            border-radius: 1rem;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="register-hero mb-4">
                    <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" alt="Register" />
                    <h2 class="mb-2">Create Your Account</h2>
                    <p class="mb-0">Join our library and start your reading journey today!</p>
                </div>
                <div class="card register-card">
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <form action="<c:url value='/register'/>" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="mb-3">
                                <label for="role" class="form-label">Role</label>
                                <select class="form-control" id="role" name="role">
                                    <option value="USER">User</option>
                                    <option value="ADMIN">Admin</option>
                                </select>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-warning btn-lg">Register</button>
                            </div>
                        </form>
                        <div class="mt-3 text-center">
                            <a href="<c:url value='/login'/>">Already have an account? Login</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 