<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Room" %>
<%@ page import="com.eventvenue.dao.RoomDAO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Book a Venue – Event Venue System</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="navbar.jsp"/>

<div class="page-header">
  <div class="container">
    <h1>📋 Book a Venue</h1>
    <p>Fill in the details below to submit your booking request</p>
  </div>
</div>

<div class="container" style="max-width:760px;">

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger mt-2">⚠️ ${error}</div>
  <% } %>

  <%
    Room selectedRoom = (Room) request.getAttribute("room");
    RoomDAO roomDAO = new RoomDAO();
    List<Room> allRooms = roomDAO.getAllAvailableRooms();
  %>

  <div class="card mt-3">
    <div class="card-header">
      <h3 style="font-family:'Playfair Display',serif;">Booking Request Form</h3>
    </div>
    <div class="card-body">
      <form method="post" action="${pageContext.request.contextPath}/booking">

        <!-- Room Selection -->
        <div class="form-group">
          <label class="form-label">Select Venue *</label>
          <select name="roomId" class="form-control" required onchange="updateRoomInfo(this)">
            <option value="">-- Choose a venue --</option>
            <% for (Room r : allRooms) { %>
              <option value="<%= r.getId() %>"
                data-capacity="<%= r.getCapacity() %>"
                data-location="<%= r.getLocation() %>"
                <%= (selectedRoom != null && selectedRoom.getId() == r.getId()) ? "selected" : "" %>>
                <%= r.getName() %> – Capacity: <%= r.getCapacity() %>
              </option>
            <% } %>
          </select>
        </div>

        <!-- Room info box -->
        <div id="roomInfo" style="display:none; background:#f0faf3; border:1px solid #b7dfbf; border-radius:8px; padding:0.85rem 1rem; margin-bottom:1rem; font-size:0.875rem;">
          📍 <span id="roomLocation"></span> &nbsp;|&nbsp;
          👥 Max capacity: <span id="roomCapacity"></span> guests
        </div>

        <div class="form-group">
          <label class="form-label">Event Name *</label>
          <input type="text" name="eventName" class="form-control" placeholder="e.g. Annual Staff Meeting 2025" required>
        </div>

        <div class="form-group">
          <label class="form-label">Event Purpose / Description *</label>
          <textarea name="eventPurpose" class="form-control" rows="3"
            placeholder="Describe the purpose and nature of your event..." required></textarea>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Event Date *</label>
            <input type="date" name="eventDate" class="form-control" required
              min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
          </div>
          <div class="form-group">
            <label class="form-label">Number of Attendees *</label>
            <input type="number" name="attendees" class="form-control" placeholder="e.g. 50" min="1" required>
          </div>
        </div>

        <div class="form-row">
          <div class="form-group">
            <label class="form-label">Start Time *</label>
            <input type="time" name="startTime" class="form-control" required>
          </div>
          <div class="form-group">
            <label class="form-label">End Time *</label>
            <input type="time" name="endTime" class="form-control" required>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Additional Details / Special Requirements</label>
          <textarea name="additionalDetails" class="form-control" rows="2"
            placeholder="Any special setup, equipment or accessibility requirements..."></textarea>
        </div>

        <div style="display:flex; gap:1rem; margin-top:1rem;">
          <button type="submit" class="btn btn-primary btn-lg">
            📤 Submit Booking Request
          </button>
          <a href="${pageContext.request.contextPath}/rooms" class="btn btn-outline btn-lg">Cancel</a>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
function updateRoomInfo(sel) {
  var opt = sel.options[sel.selectedIndex];
  var info = document.getElementById('roomInfo');
  if (opt.value) {
    document.getElementById('roomLocation').textContent = opt.dataset.location;
    document.getElementById('roomCapacity').textContent = opt.dataset.capacity;
    info.style.display = 'block';
  } else {
    info.style.display = 'none';
  }
}
// Auto-show if room pre-selected
window.onload = function() {
  var sel = document.querySelector('select[name=roomId]');
  if (sel && sel.value) updateRoomInfo(sel);
};
</script>

</body>
</html>
