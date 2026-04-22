<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Users – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="users"/>
  </jsp:include>

  <div class="admin-content">
    <div class="section-title">👥 Registered Users</div>
    <div class="section-subtitle">All users who have registered on the system</div>

    <div class="table-wrapper mt-3">
      <table>
        <thead>
          <tr>
            <th>#</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Role</th>
            <th>Registered</th>
          </tr>
        </thead>
        <tbody>
        <%
          List<User> users = (List<User>) request.getAttribute("users");
          if (users != null) {
            for (User u : users) {
        %>
          <tr>
            <td style="color:var(--text-muted);">#<%= u.getId() %></td>
            <td><strong><%= u.getFullName() %></strong></td>
            <td><%= u.getEmail() %></td>
            <td><%= u.getPhone() != null ? u.getPhone() : "—" %></td>
            <td>
              <span class="badge <%= u.isAdmin() ? "badge-approved" : "badge-info" %>">
                <%= u.getRole().toUpperCase() %>
              </span>
            </td>
            <td style="font-size:0.82rem;color:var(--text-muted);">
              <%= u.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd MMM yyyy").format(u.getCreatedAt()) : "—" %>
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
