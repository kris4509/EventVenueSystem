<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Notification" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Notifications – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="page-header">
  <div class="container">
    <h1>🔔 Notifications</h1>
    <p>Stay updated on all your booking activity</p>
  </div>
</div>

<div class="container" style="max-width:760px;">
  <div class="mt-3">
    <%
      List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
      if (notifications == null || notifications.isEmpty()) {
    %>
      <div class="card text-center" style="padding:3rem;">
        <div style="font-size:3rem;margin-bottom:1rem;">🔔</div>
        <h3 style="font-family:'Playfair Display',serif;">All caught up!</h3>
        <p class="text-muted">No notifications yet.</p>
      </div>
    <% } else {
       for (Notification n : notifications) { %>
      <div class="notif-item <%= n.isRead() ? "" : "unread" %>">
        <div class="notif-icon">
          <% if (n.getMessage().contains("APPROVED")) { %> ✅
          <% } else if (n.getMessage().contains("rejected")) { %> ❌
          <% } else if (n.getMessage().contains("Additional")) { %> ℹ️
          <% } else { %> 📩 <% } %>
        </div>
        <div>
          <div class="notif-msg"><%= n.getMessage() %></div>
          <div class="notif-time">
            <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(n.getCreatedAt()) %>
            <% if (!n.isRead()) { %> &nbsp;<span class="badge badge-pending">NEW</span><% } %>
          </div>
        </div>
      </div>
    <% }} %>
  </div>
</div>

</body>
</html>
