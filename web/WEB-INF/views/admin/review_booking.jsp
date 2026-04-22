<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.eventvenue.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Review Booking – Admin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
  <style>
    .decision-panel { display:grid; grid-template-columns:1fr 1fr 1fr; gap:1rem; margin-top:1.5rem; }
    .decision-card {
      border: 2px solid var(--border); border-radius:12px; padding:1.5rem; text-align:center;
      cursor:pointer; transition:all 0.2s; background:white;
    }
    .decision-card:hover { transform:translateY(-2px); }
    .decision-card.approve { border-color:#2d7a3a; }
    .decision-card.approve:hover { background:#f0faf3; }
    .decision-card.reject { border-color:#c0392b; }
    .decision-card.reject:hover { background:#fff5f5; }
    .decision-card.needs_info { border-color:#1a5276; }
    .decision-card.needs_info:hover { background:#eff7ff; }
    .decision-card .icon { font-size:2.5rem; margin-bottom:0.5rem; }
    .decision-card h4 { font-family:'Playfair Display',serif; font-size:1.1rem; margin-bottom:0.35rem; }
    .decision-card p { font-size:0.82rem; color:var(--text-muted); }
    .detail-row { display:flex; gap:0.5rem; margin-bottom:0.6rem; font-size:0.9rem; }
    .detail-label { font-weight:600; min-width:140px; color:var(--text-muted); }
  </style>
</head>
<body>

<jsp:include page="../navbar.jsp"/>

<div class="admin-layout">
  <jsp:include page="sidebar.jsp">
    <jsp:param name="active" value="pending"/>
  </jsp:include>

  <div class="admin-content">
    <%
      Booking b = (Booking) request.getAttribute("booking");
      if (b == null) {
    %>
      <div class="alert alert-danger">Booking not found.</div>
    <% } else { %>

    <a href="${pageContext.request.contextPath}/admin?action=pending" style="color:var(--primary);font-size:0.875rem;">← Back to Pending</a>

    <div class="section-title mt-2">Review Booking #<%= b.getId() %></div>
    <div class="section-subtitle">Review the details below and make a decision</div>

    <!-- Flowchart step indicator -->
    <div class="status-flow">
      <div class="status-step done"><div class="circle">1</div><div class="label">Submitted</div></div>
      <div class="status-line done"></div>
      <div class="status-step active"><div class="circle">2</div><div class="label">Is Purpose Legit?</div></div>
      <div class="status-line"></div>
      <div class="status-step"><div class="circle">3</div><div class="label">Notify User</div></div>
      <div class="status-line"></div>
      <div class="status-step"><div class="circle">4</div><div class="label">Mark Booked</div></div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:1.5rem;">
      <!-- Booking Details -->
      <div class="card">
        <div class="card-header"><strong>📋 Booking Details</strong></div>
        <div class="card-body">
          <div class="detail-row"><span class="detail-label">Event Name:</span><span><strong><%= b.getEventName() %></strong></span></div>
          <div class="detail-row"><span class="detail-label">Requested By:</span><span><%= b.getUserName() %> (<%= b.getUserEmail() %>)</span></div>
          <div class="detail-row"><span class="detail-label">Venue:</span><span><%= b.getRoomName() %> – <%= b.getRoomLocation() %></span></div>
          <div class="detail-row"><span class="detail-label">Event Date:</span><span><%= b.getEventDate() %></span></div>
          <div class="detail-row"><span class="detail-label">Time:</span><span><%= b.getStartTime().toString().substring(0,5) %> – <%= b.getEndTime().toString().substring(0,5) %></span></div>
          <div class="detail-row"><span class="detail-label">Attendees:</span><span>👥 <%= b.getAttendees() %></span></div>
          <div class="detail-row"><span class="detail-label">Submitted:</span><span><%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(b.getCreatedAt()) %></span></div>
        </div>
      </div>

      <!-- Purpose & Details -->
      <div class="card">
        <div class="card-header"><strong>🎯 Event Purpose</strong></div>
        <div class="card-body">
          <p style="font-size:0.9rem;line-height:1.7;margin-bottom:1rem;"><%= b.getEventPurpose() %></p>
          <% if (b.getAdditionalDetails() != null && !b.getAdditionalDetails().isEmpty()) { %>
            <hr style="border:none;border-top:1px solid var(--border);margin-bottom:1rem;">
            <strong style="font-size:0.85rem;">Additional Details:</strong>
            <p style="font-size:0.875rem;color:var(--text-muted);margin-top:0.4rem;"><%= b.getAdditionalDetails() %></p>
          <% } %>
        </div>
      </div>
    </div>

    <!-- Decision Section -->
    <div class="card mt-3">
      <div class="card-header">
        <strong>⚖️ Make a Decision</strong>
        <p style="font-size:0.82rem;color:var(--text-muted);margin-top:3px;">Choose an action — the user will be notified immediately.</p>
      </div>
      <div class="card-body">
        <div class="decision-panel">
          <div class="decision-card approve" onclick="selectDecision('approved')">
            <div class="icon">✅</div>
            <h4>Approve</h4>
            <p>Purpose is legitimate. Mark room as booked and notify user.</p>
          </div>
          <div class="decision-card needs_info" onclick="selectDecision('needs_info')">
            <div class="icon">ℹ️</div>
            <h4>Request Info</h4>
            <p>Additional details are needed before a final decision can be made.</p>
          </div>
          <div class="decision-card reject" onclick="selectDecision('rejected')">
            <div class="icon">❌</div>
            <h4>Reject</h4>
            <p>Purpose is not legitimate or venue is unavailable for this event.</p>
          </div>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin" id="decisionForm">
          <input type="hidden" name="action" value="updateBooking">
          <input type="hidden" name="bookingId" value="<%= b.getId() %>">
          <input type="hidden" name="status" id="statusInput" value="">

          <div class="form-group mt-3" id="notesGroup" style="display:none;">
            <label class="form-label">
              <span id="notesLabel">Admin Notes / Reason</span>
              <span style="color:#c0392b;">*</span>
            </label>
            <textarea name="adminNotes" id="adminNotes" class="form-control" rows="3"
              placeholder="Provide a reason or notes for the user..."></textarea>
          </div>

          <div style="margin-top:1.25rem;display:flex;gap:1rem;" id="submitArea" style="display:none;">
            <button type="submit" class="btn btn-primary btn-lg" id="submitBtn" style="display:none;">
              Submit Decision →
            </button>
            <a href="${pageContext.request.contextPath}/admin?action=pending" class="btn btn-outline btn-lg">Cancel</a>
          </div>
        </form>
      </div>
    </div>
    <% } %>
  </div>
</div>

<script>
function selectDecision(status) {
  document.getElementById('statusInput').value = status;

  // Highlight selected card
  document.querySelectorAll('.decision-card').forEach(c => c.style.background = '');
  var map = {approved:'#f0faf3', needs_info:'#eff7ff', rejected:'#fff5f5'};
  event.currentTarget.style.background = map[status];

  var notesGroup = document.getElementById('notesGroup');
  var notesLabel = document.getElementById('notesLabel');
  var submitBtn = document.getElementById('submitBtn');
  var submitArea = document.getElementById('submitArea');

  notesGroup.style.display = 'block';
  submitBtn.style.display = 'inline-flex';
  submitArea.style.display = 'flex';

  if (status === 'approved') {
    notesLabel.textContent = 'Notes for User (Optional)';
    document.getElementById('adminNotes').placeholder = 'Any instructions or information for the user...';
    submitBtn.textContent = '✅ Approve Booking →';
    submitBtn.className = 'btn btn-success btn-lg';
  } else if (status === 'needs_info') {
    notesLabel.textContent = 'What additional info is needed? *';
    document.getElementById('adminNotes').placeholder = 'Specify what additional information or documents are required...';
    submitBtn.textContent = 'ℹ️ Request More Info →';
    submitBtn.className = 'btn btn-primary btn-lg';
  } else {
    notesLabel.textContent = 'Reason for Rejection *';
    document.getElementById('adminNotes').placeholder = 'Provide a clear reason for rejecting this booking...';
    submitBtn.textContent = '❌ Reject Booking →';
    submitBtn.className = 'btn btn-danger btn-lg';
  }
}
</script>

</body>
</html>
