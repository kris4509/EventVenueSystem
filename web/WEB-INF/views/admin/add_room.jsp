<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Add Room – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="rooms"/>
  </jsp:include>

  <div class="admin-content">
    <a href="${pageContext.request.contextPath}/admin?action=rooms" style="color:var(--primary);font-size:0.875rem;">← Back to Rooms</a>

    <div class="section-title mt-2">+ Add New Venue / Room</div>
    <div class="section-subtitle">Fill in the details to add a new bookable venue</div>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-danger">⚠️ ${error}</div>
    <% } %>

    <div class="card mt-2" style="max-width:700px;">
      <div class="card-body">
        <form method="post" action="${pageContext.request.contextPath}/admin">
          <input type="hidden" name="action" value="addRoom">

          <div class="form-group">
            <label class="form-label">Room / Venue Name *</label>
            <input type="text" name="name" class="form-control" placeholder="e.g. Grand Conference Hall" required>
          </div>

          <div class="form-group">
            <label class="form-label">Capacity (persons) *</label>
            <input type="number" name="capacity" class="form-control" placeholder="e.g. 200" min="1" required>
          </div>


          <div class="form-group">
            <label class="form-label">Location *</label>
            <input type="text" name="location" class="form-control" placeholder="e.g. Main Building, Ground Floor" required>
          </div>

          <div class="form-group">
            <label class="form-label">Description</label>
            <textarea name="description" class="form-control" rows="2" placeholder="Brief description of the venue..."></textarea>
          </div>

          <div class="form-group">
            <label class="form-label">Amenities (comma-separated)</label>
            <input type="text" name="amenities" class="form-control" placeholder="e.g. Projector, WiFi, AC, Microphone, Whiteboard">
          </div>

          <div style="display:flex;gap:1rem;margin-top:1rem;">
            <button type="submit" class="btn btn-primary btn-lg">Save Room →</button>
            <a href="${pageContext.request.contextPath}/admin?action=rooms" class="btn btn-outline btn-lg">Cancel</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>

</body>
</html>
