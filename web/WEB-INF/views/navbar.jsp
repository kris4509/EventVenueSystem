<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.User" %>
<%@ page import="com.eventvenue.dao.NotificationDAO" %>
<%
    HttpSession navSession = request.getSession(false);
    User navUser = (navSession != null) ? (User) navSession.getAttribute("user") : null;
    int unreadCount = 0;
    if (navUser != null && !navUser.isAdmin()) {
        NotificationDAO nDao = new NotificationDAO();
        unreadCount = nDao.countUnread(navUser.getId());
    }
%>
<nav class="navbar">
  <a href="${pageContext.request.contextPath}/rooms" class="navbar-brand">
    <span class="icon">🏛️</span>
    <span>EventVenue</span>
  </a>

  <div class="nav-links">

    <%-- ADMIN LINKS --%>
    <% if (navUser != null && navUser.isAdmin()) { %>
      <a href="${pageContext.request.contextPath}/admin?action=dashboard">📊 <span>Dashboard</span></a>
      <a href="${pageContext.request.contextPath}/admin?action=pending">⏳ <span>Pending</span></a>
      <a href="${pageContext.request.contextPath}/admin?action=rooms">🏠 <span>Rooms</span></a>
      <a href="${pageContext.request.contextPath}/admin?action=users">👥 <span>Users</span></a>
      <a href="${pageContext.request.contextPath}/logout" class="btn-accent">🚪 Logout</a>

    <%-- LOGGED IN USER LINKS --%>
    <% } else if (navUser != null) { %>
      <a href="${pageContext.request.contextPath}/rooms">🏠 <span>Venues</span></a>
      <a href="${pageContext.request.contextPath}/booking?action=my">📋 <span>My Bookings</span></a>
      <a href="${pageContext.request.contextPath}/notifications">
        🔔 <span>Notifications</span>
        <% if (unreadCount > 0) { %><span class="notif-badge"><%= unreadCount %></span><% } %>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="btn-accent">
        👤 <%= navUser.getFullName().split(" ")[0] %> · Logout
      </a>

    <%-- GUEST (NOT LOGGED IN) LINKS --%>
    <% } else { %>
      <a href="${pageContext.request.contextPath}/rooms">🏠 <span>Venues</span></a>
      <a href="${pageContext.request.contextPath}/login">🔑 <span>Login</span></a>
      <a href="${pageContext.request.contextPath}/register" class="btn-accent">Register</a>
    <% } %>

  </div>
</nav>
