<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Room" %>
<%@ page import="com.eventvenue.model.User" %>
<%@ page import="java.util.List" %>
<%
    HttpSession roomSession = request.getSession(false);
    User currentUser = (roomSession != null) ? (User) roomSession.getAttribute("user") : null;
    boolean isGuest = (currentUser == null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Available Venues – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="page-header">
  <div class="container">
    <h1>🏛️ Available Venues</h1>
    <p>Browse our premium event spaces — no account needed to look around</p>
  </div>
</div>

<div class="container">

  <% if (isGuest) { %>
  <div class="alert alert-info mt-2" style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;">
    <span>👋 <strong>Welcome!</strong> You're browsing as a guest. <a href="${pageContext.request.contextPath}/login" style="color:var(--primary);font-weight:700;">Login</a> or <a href="${pageContext.request.contextPath}/register" style="color:var(--primary);font-weight:700;">Register</a> to book a venue.</span>
    <div style="display:flex;gap:0.5rem;">
      <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-sm">Login</a>
      <a href="${pageContext.request.contextPath}/register" class="btn btn-accent btn-sm">Register Free</a>
    </div>
  </div>
  <% } %>

  <%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    if (rooms == null || rooms.isEmpty()) {
  %>
    <div class="alert alert-warning mt-3">No venues are currently available. Please check back later.</div>
  <% } else { %>
    <div class="rooms-grid">
    <% for (Room room : rooms) {
       String[] emojis = {"🏛️","🎭","🎪","🏟️","🎨","🌿","📽️","📚"};
       int idx = room.getId() % emojis.length;
    %>
      <div class="room-card">
        <div class="room-card-img">
          <%= emojis[idx] %>
          <span class="capacity-badge">👥 <%= room.getCapacity() %> guests</span>
        </div>
        <div class="room-card-body">
          <h3><%= room.getName() %></h3>
          <div class="room-location">📍 <%= room.getLocation() %></div>
          <p style="font-size:0.85rem;color:var(--text-muted);margin-bottom:0.75rem;">
            <%= room.getDescription() != null ? room.getDescription() : "" %>
          </p>

          <div class="amenities-list">
            <% if (room.getAmenities() != null) {
               for (String a : room.getAmenities().split(",")) { %>
              <span class="amenity-tag"><%= a.trim() %></span>
            <% }} %>
          </div>
        </div>
        <div class="room-card-footer">
          <% if (isGuest) { %>
            <%-- Guest: clicking Book takes them to login page --%>
            <a href="${pageContext.request.contextPath}/login?redirect=booking&roomId=<%= room.getId() %>"
               class="btn btn-outline"
               title="Login to book this venue">
              🔑 Login to Book
            </a>
          <% } else { %>
            <%-- Logged-in user: go straight to booking form --%>
            <a href="${pageContext.request.contextPath}/booking?action=form&roomId=<%= room.getId() %>"
               class="btn btn-primary">
              Book This Venue →
            </a>
          <% } %>
        </div>
      </div>
    <% } %>
    </div>
  <% } %>
</div>

</body>
</html>
