<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String redirectParam = request.getParameter("redirect");
    String roomIdParam   = request.getParameter("roomId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-header">
      <div class="logo">🏛️</div>
      <h2>Event Venue System</h2>
      <% if ("booking".equals(redirectParam)) { %>
        <p>Sign in to complete your booking</p>
      <% } else { %>
        <p>Sign in to manage your bookings</p>
      <% } %>
    </div>
    <div class="auth-body">

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">⚠️ ${error}</div>
      <% } %>
      <% if (request.getAttribute("success") != null) { %>
        <div class="alert alert-success">✅ ${success}</div>
      <% } %>

      <form method="post" action="${pageContext.request.contextPath}/login">
        <%-- Carry redirect params through POST so booking flow works --%>
        <% if (redirectParam != null) { %>
          <input type="hidden" name="redirect" value="<%= redirectParam %>">
        <% } %>
        <% if (roomIdParam != null) { %>
          <input type="hidden" name="roomId" value="<%= roomIdParam %>">
        <% } %>

        <div class="form-group">
          <label class="form-label">Email Address</label>
          <input type="email" name="email" class="form-control"
                 placeholder="you@example.com" required autofocus>
        </div>
        <div class="form-group">
          <label class="form-label">Password</label>
          <input type="password" name="password" class="form-control"
                 placeholder="Enter your password" required>
        </div>
        <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:0.5rem;">
          Sign In →
        </button>
      </form>

      <div class="text-center mt-2">
        <p class="text-muted">Don't have an account?
          <a href="${pageContext.request.contextPath}/register" style="color:var(--primary);font-weight:600;">Register here</a>
        </p>
        <p class="text-muted mt-1">
          <a href="${pageContext.request.contextPath}/rooms" style="color:var(--text-muted);font-size:0.82rem;">← Back to browsing venues</a>
        </p>
      </div>

      <div class="alert alert-info mt-2" style="font-size:0.8rem;">
        <strong>Admin login:</strong> admin@eventvenue.com / admin123
      </div>
    </div>
  </div>
</div>
</body>
</html>
