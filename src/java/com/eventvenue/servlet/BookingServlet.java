package com.eventvenue.servlet;

import com.eventvenue.dao.BookingDAO;
import com.eventvenue.dao.NotificationDAO;
import com.eventvenue.dao.RoomDAO;
import com.eventvenue.model.Booking;
import com.eventvenue.model.Room;
import com.eventvenue.model.User;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private RoomDAO roomDAO = new RoomDAO();
    private NotificationDAO notifDAO = new NotificationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("form".equals(action)) {
            // Show booking form
            String roomId = request.getParameter("roomId");
            if (roomId != null) {
                Room room = roomDAO.getRoomById(Integer.parseInt(roomId));
                request.setAttribute("room", room);
            }
            request.getRequestDispatcher("/WEB-INF/views/booking_form.jsp").forward(request, response);

        } else if ("my".equals(action)) {
            // Show user's bookings
            List<Booking> bookings = bookingDAO.getBookingsByUser(user.getId());
            request.setAttribute("bookings", bookings);
            request.getRequestDispatcher("/WEB-INF/views/my_bookings.jsp").forward(request, response);

        } else if ("cancel".equals(action)) {
            // Cancel a booking
            int bookingId = Integer.parseInt(request.getParameter("id"));
            bookingDAO.cancelBooking(bookingId, user.getId());
            response.sendRedirect("booking?action=my&msg=cancelled");
        } else {
            response.sendRedirect("rooms");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            Booking booking = new Booking();
            booking.setUserId(user.getId());
            booking.setRoomId(Integer.parseInt(request.getParameter("roomId")));
            booking.setEventName(request.getParameter("eventName"));
            booking.setEventPurpose(request.getParameter("eventPurpose"));
            booking.setEventDate(Date.valueOf(request.getParameter("eventDate")));
            booking.setStartTime(Time.valueOf(request.getParameter("startTime") + ":00"));
            booking.setEndTime(Time.valueOf(request.getParameter("endTime") + ":00"));
            booking.setAttendees(Integer.parseInt(request.getParameter("attendees")));
            booking.setAdditionalDetails(request.getParameter("additionalDetails"));

            int bookingId = bookingDAO.createBooking(booking);

            if (bookingId > 0) {
                // Notify user that request was submitted
                notifDAO.createNotification(user.getId(), bookingId,
                    "Your booking request for '" + booking.getEventName() + "' has been submitted and is pending review.");
                response.sendRedirect("booking?action=my&msg=success");
            } else {
                request.setAttribute("error", "Booking failed. Please try again.");
                request.getRequestDispatcher("/WEB-INF/views/booking_form.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid input. Please check all fields.");
            request.getRequestDispatcher("/WEB-INF/views/booking_form.jsp").forward(request, response);
        }
    }
}
