<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Booking" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="dashboard"/>
  </jsp:include>

  <div class="admin-content">
    <div class="section-title">Admin Dashboard</div>
    <div class="section-subtitle">Overview of the Event Venue Allocation System</div>

    <!-- Stats -->
    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">🏠</div>
        <div class="stat-info">
          <h3>${totalRooms}</h3>
          <p>Total Venues</p>
        </div>
      </div>
      <div class="stat-card warning">
        <div class="stat-icon">⏳</div>
        <div class="stat-info">
          <h3>${pendingCount}</h3>
          <p>Pending Reviews</p>
        </div>
      </div>
      <div class="stat-card accent">
        <div class="stat-icon">✅</div>
        <div class="stat-info">
          <h3>${approvedCount}</h3>
          <p>Approved Bookings</p>
        </div>
      </div>
      <div class="stat-card danger">
        <div class="stat-icon">❌</div>
        <div class="stat-info">
          <h3>${rejectedCount}</h3>
          <p>Rejected Bookings</p>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div class="d-flex gap-2 mb-3">
      <a href="${pageContext.request.contextPath}/admin?action=pending" class="btn btn-primary">
        ⏳ Review Pending Bookings
      </a>
      <a href="${pageContext.request.contextPath}/admin?action=addRoom" class="btn btn-accent">
        + Add New Room
      </a>
    </div>

    <!-- Recent Bookings -->
    <div class="card">
      <div class="card-header d-flex justify-between align-center">
        <strong>Recent Booking Requests</strong>
        <a href="${pageContext.request.contextPath}/admin?action=bookings" style="font-size:0.85rem;color:var(--primary);">View all →</a>
      </div>
      <div class="table-wrapper" style="box-shadow:none;border-radius:0;">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>User</th>
              <th>Event</th>
              <th>Venue</th>
              <th>Date</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
          <%
            List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
            if (recentBookings != null) {
              for (Booking b : recentBookings) {
          %>
            <tr>
              <td style="color:var(--text-muted);font-size:0.8rem;">#<%= b.getId() %></td>
              <td><strong><%= b.getUserName() %></strong><br><small style="color:var(--text-muted);"><%= b.getUserEmail() %></small></td>
              <td><%= b.getEventName() %></td>
              <td><%= b.getRoomName() %></td>
              <td><%= b.getEventDate() %></td>
              <td><span class="badge <%= b.getStatusBadgeClass() %>"><%= b.getStatus().toUpperCase() %></span></td>
              <td>
                <% if ("pending".equals(b.getStatus())) { %>
                  <a href="${pageContext.request.contextPath}/admin?action=review&id=<%= b.getId() %>" class="btn btn-primary btn-sm">Review</a>
                <% } else { %>—<% } %>
              </td>
            </tr>
          <% }} %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

</body>
</html>
