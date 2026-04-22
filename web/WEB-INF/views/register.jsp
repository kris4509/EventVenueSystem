<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrapper">
  <div class="auth-card">
    <div class="auth-header">
      <div class="logo">🏛️</div>
      <h2>Create Account</h2>
      <p>Register to start booking venues</p>
    </div>
    <div class="auth-body">

      <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">⚠️ ${error}</div>
      <% } %>

      <form method="post" action="${pageContext.request.contextPath}/register">
        <div class="form-group">
          <label class="form-label">Full Name</label>
          <input type="text" name="fullName" class="form-control" placeholder="John Doe" required autofocus>
        </div>
        <div class="form-group">
          <label class="form-label">Email Address</label>
          <input type="email" name="email" class="form-control" placeholder="you@example.com" required>
        </div>
        <div class="form-group">
          <label class="form-label">Phone Number</label>
          <input type="tel" name="phone" class="form-control" placeholder="+254700000000">
        </div>
        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" placeholder="Min 6 chars" required>
          </div>
          <div class="form-group">
            <label class="form-label">Confirm Password</label>
            <input type="password" name="confirmPassword" class="form-control" placeholder="Repeat password" required>
          </div>
        </div>
        <button type="submit" class="btn btn-primary btn-block btn-lg">
          Create Account →
        </button>
      </form>

      <div class="text-center mt-2">
        <p class="text-muted">Already have an account?
          <a href="${pageContext.request.contextPath}/login" style="color:var(--primary);font-weight:600;">Sign in here</a>
        </p>
      </div>
    </div>
  </div>
</div>
</body>
</html>
