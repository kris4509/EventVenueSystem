<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Room" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Manage Rooms – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="rooms"/>
  </jsp:include>

  <div class="admin-content">
    <div class="d-flex justify-between align-center mb-2">
      <div>
        <div class="section-title">🏠 Manage Rooms / Venues</div>
        <div class="section-subtitle">Add, view, or remove event venues</div>
      </div>
      <a href="${pageContext.request.contextPath}/admin?action=addRoom" class="btn btn-primary">+ Add New Room</a>
    </div>

    <% String msg = request.getParameter("msg"); %>
    <% if ("added".equals(msg)) { %><div class="alert alert-success">✅ Room added successfully!</div><% } %>
    <% if ("deleted".equals(msg)) { %><div class="alert alert-warning">Room deleted.</div><% } %>

    <div class="table-wrapper">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Room Name</th>
            <th>Location</th>
            <th>Capacity</th>
            <th>Amenities</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
        <%
          List<Room> rooms = (List<Room>) request.getAttribute("rooms");
          if (rooms != null) {
            for (Room r : rooms) {
        %>
          <tr>
            <td style="color:var(--text-muted);">#<%= r.getId() %></td>
            <td><strong><%= r.getName() %></strong></td>
            <td>📍 <%= r.getLocation() %></td>
            <td>👥 <%= r.getCapacity() %></td>
            <td style="font-size:0.8rem;max-width:180px;color:var(--text-muted);"><%= r.getAmenities() != null ? r.getAmenities() : "—" %></td>
            <td><span class="badge badge-<%= r.getStatus() %>"><%= r.getStatus().toUpperCase() %></span></td>
            <td>
              <form method="post" action="${pageContext.request.contextPath}/admin" style="display:inline;" onsubmit="return confirm('Delete this room?')">
                <input type="hidden" name="action" value="deleteRoom">
                <input type="hidden" name="roomId" value="<%= r.getId() %>">
                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
              </form>
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
