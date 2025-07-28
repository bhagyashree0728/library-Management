<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/resources/css/style.css'/>" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
        }
        .welcome-hero {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            color: #fff;
            border-radius: 1.5rem;
            padding: 3rem 2rem 2rem 2rem;
            margin-top: 3rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            text-align: center;
        }
        .welcome-hero img {
            max-width: 160px;
            margin-bottom: 1.5rem;
        }
        .welcome-charts {
            background: #fff;
            border-radius: 1rem;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
            padding: 2rem;
            margin-top: 2rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-hero">
            <img src="https://cdn-icons-png.flaticon.com/512/2991/2991108.png" alt="Library" />
            <h1 class="display-4 mb-3">Welcome to Library Management System</h1>
            <p class="lead mb-4">Your gateway to a world of books, knowledge, and analytics. Manage, explore, and analyze your library with ease.</p>
            <a href="<c:url value='/login'/>" class="btn btn-lg btn-warning px-5 py-2">Login</a>
        </div>
        <div class="welcome-charts mt-5">
            <h3 class="mb-4">Library Insights (Demo)</h3>
            <div class="row">
                <div class="col-md-6">
                    <canvas id="welcomeBooksChart" height="180"></canvas>
                </div>
                <div class="col-md-6">
                    <canvas id="welcomeUsersChart" height="180"></canvas>
                </div>
            </div>
        </div>
        <div class="text-center mt-5">
            <h5>Why Choose Our Library?</h5>
            <p class="text-muted">Modern analytics, easy management, and a beautiful user experience. Start your reading journey today!</p>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // Demo data for charts
    const booksChart = new Chart(document.getElementById('welcomeBooksChart').getContext('2d'), {
        type: 'bar',
        data: {
            labels: ['Fiction', 'Non-Fiction', 'Science', 'History', 'Other'],
            datasets: [{
                label: 'Books by Genre',
                data: [12, 9, 7, 5, 3],
                backgroundColor: ['#43cea2', '#185a9d', '#f7971e', '#f44336', '#8e44ad']
            }]
        },
        options: {
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true } }
        }
    });
    const usersChart = new Chart(document.getElementById('welcomeUsersChart').getContext('2d'), {
        type: 'pie',
        data: {
            labels: ['Admins', 'Users'],
            datasets: [{
                data: [1, 15],
                backgroundColor: ['#185a9d', '#43cea2']
            }]
        },
        options: {
            plugins: { legend: { position: 'bottom' } }
        }
    });
    </script>
</body>
</html>