<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Booking" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>All Bookings – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="bookings"/>
  </jsp:include>

  <div class="admin-content">
    <div class="section-title">📋 All Bookings</div>
    <div class="section-subtitle">Complete history of all booking requests</div>

    <div class="table-wrapper mt-3">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>User</th>
            <th>Event Name</th>
            <th>Venue</th>
            <th>Date</th>
            <th>Time</th>
            <th>Attendees</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
        <%
          List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
          if (bookings != null) {
            for (Booking b : bookings) {
        %>
          <tr>
            <td style="color:var(--text-muted);font-size:0.8rem;">#<%= b.getId() %></td>
            <td><strong><%= b.getUserName() %></strong><br><small style="color:var(--text-muted);"><%= b.getUserEmail() %></small></td>
            <td><%= b.getEventName() %></td>
            <td><%= b.getRoomName() %></td>
            <td><%= b.getEventDate() %></td>
            <td style="font-size:0.85rem;"><%= b.getStartTime().toString().substring(0,5) %> – <%= b.getEndTime().toString().substring(0,5) %></td>
            <td>👥 <%= b.getAttendees() %></td>
            <td><span class="badge <%= b.getStatusBadgeClass() %>"><%= b.getStatus().replace("_"," ").toUpperCase() %></span></td>
            <td>
              <% if ("pending".equals(b.getStatus())) { %>
                <a href="${pageContext.request.contextPath}/admin?action=review&id=<%= b.getId() %>" class="btn btn-primary btn-sm">Review</a>
              <% } else { %>
                <span style="color:var(--text-muted);font-size:0.8rem;"><%= b.getAdminNotes() != null && !b.getAdminNotes().isEmpty() ? "📝 Has notes" : "—" %></span>
              <% } %>
            </td>
          </tr>
        <% }} %>
        </tbody>
      </table>
    </div>
  </div>
</div>

</body>
</html>
