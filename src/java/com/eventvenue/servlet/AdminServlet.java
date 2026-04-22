package com.eventvenue.servlet;

import com.eventvenue.dao.BookingDAO;
import com.eventvenue.dao.NotificationDAO;
import com.eventvenue.dao.RoomDAO;
import com.eventvenue.dao.UserDAO;
import com.eventvenue.model.Booking;
import com.eventvenue.model.Room;
import com.eventvenue.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private RoomDAO roomDAO = new RoomDAO();
    private UserDAO userDAO = new UserDAO();
    private NotificationDAO notifDAO = new NotificationDAO();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && user.isAdmin();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "dashboard";

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "bookings":
                showAllBookings(request, response);
                break;
            case "pending":
                showPendingBookings(request, response);
                break;
            case "rooms":
                showRooms(request, response);
                break;
            case "users":
                showUsers(request, response);
                break;
            case "review":
                showReviewBooking(request, response);
                break;
            case "addRoom":
                request.getRequestDispatcher("/WEB-INF/views/admin/add_room.jsp").forward(request, response);
                break;
            default:
                showDashboard(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateBooking".equals(action)) {
            handleUpdateBooking(request, response);
        } else if ("addRoom".equals(action)) {
            handleAddRoom(request, response);
        } else if ("deleteRoom".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            roomDAO.deleteRoom(roomId);
            response.sendRedirect("admin?action=rooms&msg=deleted");
        }
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("totalRooms", roomDAO.getAllRooms().size());
        request.setAttribute("pendingCount", bookingDAO.countByStatus("pending"));
        request.setAttribute("approvedCount", bookingDAO.countByStatus("approved"));
        request.setAttribute("rejectedCount", bookingDAO.countByStatus("rejected"));
        request.setAttribute("recentBookings", bookingDAO.getAllBookings().subList(0, Math.min(5, bookingDAO.getAllBookings().size())));
        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }

    private void showAllBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("bookings", bookingDAO.getAllBookings());
        request.getRequestDispatcher("/WEB-INF/views/admin/bookings.jsp").forward(request, response);
    }

    private void showPendingBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("bookings", bookingDAO.getPendingBookings());
        request.getRequestDispatcher("/WEB-INF/views/admin/pending_bookings.jsp").forward(request, response);
    }

    private void showRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("rooms", roomDAO.getAllRooms());
        request.getRequestDispatcher("/WEB-INF/views/admin/rooms.jsp").forward(request, response);
    }

    private void showUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("users", userDAO.getAllUsers());
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    private void showReviewBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = bookingDAO.getBookingById(bookingId);
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/WEB-INF/views/admin/review_booking.jsp").forward(request, response);
    }

    private void handleUpdateBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String status = request.getParameter("status");
        String adminNotes = request.getParameter("adminNotes");

        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            response.sendRedirect("admin?action=pending");
            return;
        }

        bookingDAO.updateBookingStatus(bookingId, status, adminNotes);

        // Notify user based on decision
        String message;
        switch (status) {
            case "approved":
                message = "🎉 Your booking for '" + booking.getEventName() + "' at " + booking.getRoomName() + " has been APPROVED!";
                roomDAO.updateRoomStatus(booking.getRoomId(), "booked");
                break;
            case "rejected":
                message = "❌ Your booking for '" + booking.getEventName() + "' has been rejected. Reason: " + (adminNotes != null ? adminNotes : "Not specified");
                break;
            case "needs_info":
                message = "ℹ️ Additional information needed for your booking '" + booking.getEventName() + "': " + adminNotes;
                break;
            default:
                message = "Your booking '" + booking.getEventName() + "' status has been updated to: " + status;
        }
        notifDAO.createNotification(booking.getUserId(), bookingId, message);

        response.sendRedirect("admin?action=pending&msg=updated");
    }

    private void handleAddRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Room room = new Room();
        room.setName(request.getParameter("name"));
        room.setCapacity(Integer.parseInt(request.getParameter("capacity")));
        room.setLocation(request.getParameter("location"));
        room.setDescription(request.getParameter("description"));
        room.setAmenities(request.getParameter("amenities"));

        if (roomDAO.addRoom(room)) {
            response.sendRedirect("admin?action=rooms&msg=added");
        } else {
            request.setAttribute("error", "Failed to add room.");
            request.getRequestDispatcher("/WEB-INF/views/admin/add_room.jsp").forward(request, response);
        }
    }
}
