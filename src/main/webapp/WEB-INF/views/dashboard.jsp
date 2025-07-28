<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/resources/css/style.css'/>" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
        }
        .dashboard-hero {
            background: linear-gradient(135deg, #43cea2 0%, #185a9d 100%);
            color: #fff;
            border-radius: 1.5rem;
            padding: 2.5rem 2rem 2rem 2rem;
            margin-top: 2rem;
            box-shadow: 0 8px 32px rgba(0,0,0,0.12);
            text-align: center;
        }
        .dashboard-hero img {
            max-width: 120px;
            margin-bottom: 1rem;
        }
        .dashboard-stats {
            display: flex;
            gap: 2rem;
            justify-content: center;
            margin-bottom: 2rem;
        }
        .dashboard-stat-card {
            background: #fff;
            color: #333;
            border-radius: 0.75rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            padding: 1.5rem 2rem;
            min-width: 180px;
            text-align: center;
        }
        #dashboard-charts {
            background: #fff;
            border-radius: 0.75rem;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            padding: 2rem;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="#">Dashboard</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="<c:url value='/books'/>">Books</a>
                <a class="nav-link" href="<c:url value='/logout'/>">Logout</a>
            </div>
        </div>
    </nav>
    <div class="container">
        <div class="dashboard-hero mb-4">
            <img src="https://cdn-icons-png.flaticon.com/512/2991/2991108.png" alt="Library Dashboard" />
            <h1 class="mb-2">Welcome, ${user.username}!</h1>
            <p class="mb-0">
                <c:choose>
                    <c:when test="${user.role == 'ADMIN'}">Admin Dashboard: Manage and analyze your library.</c:when>
                    <c:otherwise>Your personal library dashboard.</c:otherwise>
                </c:choose>
            </p>
        </div>
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card mb-4">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${user.role == 'ADMIN'}">
                                <div class="dashboard-stats">
                                    <div class="dashboard-stat-card">
                                        <h4>Total Books</h4>
                                        <div style="font-size:2rem; font-weight:bold;">${totalBooks}</div>
                                    </div>
                                    <div class="dashboard-stat-card">
                                        <h4>Total Users</h4>
                                        <div style="font-size:2rem; font-weight:bold;">${totalUsers}</div>
                                    </div>
                                </div>
                                <div id="dashboard-charts">
                                    <div class="row">
                                        <div class="col-md-6 mb-4 mb-md-0">
                                            <canvas id="adminBooksChart" height="120"></canvas>
                                        </div>
                                        <div class="col-md-6">
                                            <canvas id="adminUsersChart" height="120"></canvas>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center mb-3">
                                    <a href="<c:url value='/users'/>" class="btn btn-warning me-2">Manage Users</a>
                                    <a href="<c:url value='/books'/>" class="btn btn-primary">Go to Books</a>
                                </div>
                                <div class="mt-4 text-center">
                                    <h5>About the Library</h5>
                                    <p>Our library system helps you manage books, users, and borrowing efficiently. Analyze trends and make data-driven decisions with our dashboard tools.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="dashboard-stats justify-content-center">
                                    <div class="dashboard-stat-card">
                                        <h4>My Borrowed Books</h4>
                                        <div style="font-size:2rem; font-weight:bold;">-</div>
                                    </div>
                                </div>
                                <div id="dashboard-charts">
                                    <div class="row justify-content-center">
                                        <div class="col-md-8">
                                            <canvas id="userBooksChart" height="120"></canvas>
                                        </div>
                                    </div>
                                </div>
                                <div class="text-center mb-3">
                                    <a href="<c:url value='/users/profile'/>" class="btn btn-info me-2">Edit Profile</a>
                                    <a href="<c:url value='/books/borrowed'/>" class="btn btn-primary me-2">My Borrowed Books</a>
                                    <a href="<c:url value='/books'/>" class="btn btn-success">Browse Books</a>
                                </div>
                                <div class="mt-4 text-center">
                                    <h5>About the Library</h5>
                                    <p>Discover, borrow, and enjoy books. Your reading journey starts here!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    // Chart rendering for admin and user
    var userRole = '${user.role}';
    var totalUsers = parseInt('${totalUsers}');
    if (userRole === 'ADMIN') {
        new Chart(document.getElementById('adminBooksChart').getContext('2d'), {
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
        new Chart(document.getElementById('adminUsersChart').getContext('2d'), {
            type: 'pie',
            data: {
                labels: ['Admins', 'Users'],
                datasets: [{
                    data: [1, totalUsers > 1 ? totalUsers - 1 : 0],
                    backgroundColor: ['#185a9d', '#43cea2']
                }]
            },
            options: {
                plugins: { legend: { position: 'bottom' } }
            }
        });
    }
    if (userRole === 'USER') {
        new Chart(document.getElementById('userBooksChart').getContext('2d'), {
            type: 'doughnut',
            data: {
                labels: ['Borrowed', 'Available'],
                datasets: [{
                    data: [2, 18], // Demo data, replace with real borrowed/available counts
                    backgroundColor: ['#185a9d', '#43cea2']
                }]
            },
            options: {
                plugins: { legend: { position: 'bottom' } }
            }
        });
    }
    </script>
</body>
</html> 