<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
        }
        .login-hero {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            color: #fff;
            border-radius: 1.5rem;
            padding: 2.5rem 2rem 2rem 2rem;
            margin-top: 3rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            text-align: center;
        }
        .login-hero img {
            max-width: 100px;
            margin-bottom: 1rem;
        }
        .login-card {
            border-radius: 1rem;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-7">
                <div class="login-hero mb-4">
                    <img src="https://cdn-icons-png.flaticon.com/512/3064/3064197.png" alt="Login" />
                    <h2 class="mb-2">Login to Your Account</h2>
                    <p class="mb-0">Access your library dashboard and manage your books.</p>
                </div>
                <div class="card login-card">
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <form action="<c:url value='/login'/>" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" class="form-control" id="username" name="username" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" class="form-control" id="password" name="password" required>
                            </div>
                            <div class="d-grid">
                                <button type="submit" class="btn btn-warning btn-lg">Login</button>
                            </div>
                        </form>
                        <div class="mt-3 text-center">
                            <a href="<c:url value='/register'/>">Don't have an account? Register</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 