<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Booking" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Pending Bookings – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="pending"/>
  </jsp:include>

  <div class="admin-content">
    <div class="section-title">⏳ Pending Booking Requests</div>
    <div class="section-subtitle">Review and process booking requests from users</div>

    <% String msg = request.getParameter("msg"); %>
    <% if ("updated".equals(msg)) { %>
      <div class="alert alert-success">✅ Booking status updated and user notified!</div>
    <% } %>

    <%
      List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
      if (bookings == null || bookings.isEmpty()) {
    %>
      <div class="card text-center" style="padding:3rem;">
        <div style="font-size:3rem;margin-bottom:1rem;">🎉</div>
        <h3 style="font-family:'Playfair Display',serif;">All clear!</h3>
        <p class="text-muted">No pending booking requests at this time.</p>
      </div>
    <% } else { %>
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>Requested By</th>
              <th>Event Name</th>
              <th>Venue</th>
              <th>Date & Time</th>
              <th>Attendees</th>
              <th>Submitted</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
          <% for (Booking b : bookings) { %>
            <tr>
              <td style="color:var(--text-muted);font-size:0.8rem;">#<%= b.getId() %></td>
              <td>
                <strong><%= b.getUserName() %></strong><br>
                <small style="color:var(--text-muted);"><%= b.getUserEmail() %></small>
              </td>
              <td><%= b.getEventName() %></td>
              <td><%= b.getRoomName() %></td>
              <td>
                <%= b.getEventDate() %><br>
                <small style="color:var(--text-muted);"><%= b.getStartTime().toString().substring(0,5) %> – <%= b.getEndTime().toString().substring(0,5) %></small>
              </td>
              <td>👥 <%= b.getAttendees() %></td>
              <td style="font-size:0.8rem;color:var(--text-muted);">
                <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(b.getCreatedAt()) %>
              </td>
              <td>
                <a href="${pageContext.request.contextPath}/admin?action=review&id=<%= b.getId() %>"
                   class="btn btn-primary btn-sm">Review →</a>
              </td>
            </tr>
          <% } %>
          </tbody>
        </table>
      </div>
    <% } %>
  </div>
</div>

</body>
</html>
