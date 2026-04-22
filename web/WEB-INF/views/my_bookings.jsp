<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Booking" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>My Bookings – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="page-header">
  <div class="container">
    <h1>📋 My Bookings</h1>
    <p>Track and manage all your venue booking requests</p>
  </div>
</div>

<div class="container">
  <% String msg = request.getParameter("msg"); %>
  <% if ("success".equals(msg)) { %>
    <div class="alert alert-success mt-2">✅ Your booking request has been submitted successfully! You'll be notified once it's reviewed.</div>
  <% } else if ("cancelled".equals(msg)) { %>
    <div class="alert alert-warning mt-2">⚠️ Booking has been cancelled.</div>
  <% } %>

  <div class="d-flex justify-between align-center mt-3 mb-2">
    <div>
      <div class="section-title">Your Booking Requests</div>
      <div class="section-subtitle">All your submitted booking requests and their current status</div>
    </div>
    <a href="${pageContext.request.contextPath}/booking?action=form" class="btn btn-primary">+ New Booking</a>
  </div>

  <%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null || bookings.isEmpty()) {
  %>
    <div class="card text-center" style="padding:3rem;">
      <div style="font-size:3rem;margin-bottom:1rem;">📭</div>
      <h3 style="font-family:'Playfair Display',serif;margin-bottom:0.5rem;">No bookings yet</h3>
      <p class="text-muted mb-2">You haven't made any booking requests.</p>
      <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">Browse Venues →</a>
    </div>
  <% } else { %>
    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Event Name</th>
            <th>Venue</th>
            <th>Date</th>
            <th>Time</th>
            <th>Attendees</th>
            <th>Status</th>
            <th>Admin Notes</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
        <% for (Booking b : bookings) { %>
          <tr>
            <td style="color:var(--text-muted);font-size:0.8rem;">#<%= b.getId() %></td>
            <td><strong><%= b.getEventName() %></strong></td>
            <td>
              <%= b.getRoomName() %><br>
              <small style="color:var(--text-muted);">📍 <%= b.getRoomLocation() %></small>
            </td>
            <td><%= b.getEventDate() %></td>
            <td><%= b.getStartTime().toString().substring(0,5) %> – <%= b.getEndTime().toString().substring(0,5) %></td>
            <td>👥 <%= b.getAttendees() %></td>
            <td>
              <span class="badge <%= b.getStatusBadgeClass() %>">
                <%= b.getStatus().replace("_", " ").toUpperCase() %>
              </span>
            </td>
            <td style="font-size:0.82rem;max-width:200px;">
              <%= b.getAdminNotes() != null ? b.getAdminNotes() : "—" %>
            </td>
            <td>
              <% if ("pending".equals(b.getStatus())) { %>
                <a href="${pageContext.request.contextPath}/booking?action=cancel&id=<%= b.getId() %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Cancel this booking?')">Cancel</a>
              <% } else { %>
                <span style="color:var(--text-muted);font-size:0.8rem;">—</span>
              <% } %>
            </td>
          </tr>
        <% } %>
        </tbody>
      </table>
    </div>
  <% } %>
</div>

</body>
</html>
