package com.eventvenue.dao;

import com.eventvenue.model.Booking;
import com.eventvenue.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public int createBooking(Booking booking) {
        String sql = "INSERT INTO bookings (user_id, room_id, event_name, event_purpose, event_date, start_time, end_time, attendees, additional_details, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 'pending')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getUserId());
            ps.setInt(2, booking.getRoomId());
            ps.setString(3, booking.getEventName());
            ps.setString(4, booking.getEventPurpose());
            ps.setDate(5, booking.getEventDate());
            ps.setTime(6, booking.getStartTime());
            ps.setTime(7, booking.getEndTime());
            ps.setInt(8, booking.getAttendees());
            ps.setString(9, booking.getAdditionalDetails());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as user_name, u.email as user_email, r.name as room_name, r.location as room_location " +
                     "FROM bookings b JOIN users u ON b.user_id = u.id JOIN rooms r ON b.room_id = r.id " +
                     "WHERE b.user_id = ? ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) bookings.add(mapBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as user_name, u.email as user_email, r.name as room_name, r.location as room_location " +
                     "FROM bookings b JOIN users u ON b.user_id = u.id JOIN rooms r ON b.room_id = r.id " +
                     "ORDER BY b.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) bookings.add(mapBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public List<Booking> getPendingBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name as user_name, u.email as user_email, r.name as room_name, r.location as room_location " +
                     "FROM bookings b JOIN users u ON b.user_id = u.id JOIN rooms r ON b.room_id = r.id " +
                     "WHERE b.status = 'pending' ORDER BY b.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) bookings.add(mapBooking(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    public Booking getBookingById(int id) {
        String sql = "SELECT b.*, u.full_name as user_name, u.email as user_email, r.name as room_name, r.location as room_location " +
                     "FROM bookings b JOIN users u ON b.user_id = u.id JOIN rooms r ON b.room_id = r.id WHERE b.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapBooking(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateBookingStatus(int bookingId, String status, String adminNotes) {
        String sql = "UPDATE bookings SET status = ?, admin_notes = ?, updated_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, adminNotes);
            ps.setInt(3, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelBooking(int bookingId, int userId) {
        String sql = "UPDATE bookings SET status = 'rejected' WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private Booking mapBooking(ResultSet rs) throws SQLException {
        Booking b = new Booking();
        b.setId(rs.getInt("id"));
        b.setUserId(rs.getInt("user_id"));
        b.setRoomId(rs.getInt("room_id"));
        b.setEventName(rs.getString("event_name"));
        b.setEventPurpose(rs.getString("event_purpose"));
        b.setEventDate(rs.getDate("event_date"));
        b.setStartTime(rs.getTime("start_time"));
        b.setEndTime(rs.getTime("end_time"));
        b.setAttendees(rs.getInt("attendees"));
        b.setAdditionalDetails(rs.getString("additional_details"));
        b.setStatus(rs.getString("status"));
        b.setAdminNotes(rs.getString("admin_notes"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));
        b.setUserName(rs.getString("user_name"));
        b.setUserEmail(rs.getString("user_email"));
        b.setRoomName(rs.getString("room_name"));
        b.setRoomLocation(rs.getString("room_location"));
        return b;
    }
}
