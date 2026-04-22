<%@ page contentType="text/html;charset=UTF-8" %>
<div class="sidebar">
  <div class="sidebar-section-title" style="padding:0 1.5rem;color:rgba(255,255,255,0.4);font-size:0.7rem;text-transform:uppercase;letter-spacing:1px;margin-bottom:0.5rem;">
    Admin Panel
  </div>
  <div style="padding:0 0.75rem;">
    <a href="${pageContext.request.contextPath}/admin?action=dashboard"
       class="<%= "dashboard".equals(request.getParameter("active")) ? "active" : "" %>">
      📊 Dashboard
    </a>
    <a href="${pageContext.request.contextPath}/admin?action=pending"
       class="<%= "pending".equals(request.getParameter("active")) ? "active" : "" %>">
      ⏳ Pending Reviews
    </a>
    <a href="${pageContext.request.contextPath}/admin?action=bookings"
       class="<%= "bookings".equals(request.getParameter("active")) ? "active" : "" %>">
      📋 All Bookings
    </a>
    <a href="${pageContext.request.contextPath}/admin?action=rooms"
       class="<%= "rooms".equals(request.getParameter("active")) ? "active" : "" %>">
      🏠 Manage Rooms
    </a>
    <a href="${pageContext.request.contextPath}/admin?action=users"
       class="<%= "users".equals(request.getParameter("active")) ? "active" : "" %>">
      👥 Users
    </a>
    <hr style="border:none;border-top:1px solid rgba(255,255,255,0.1);margin:1rem 0;">
    <a href="${pageContext.request.contextPath}/logout" style="color:rgba(255,100,100,0.8);">
      🚪 Logout
    </a>
  </div>
</div>
