package com.eventvenue.servlet;

import com.eventvenue.dao.RoomDAO;
import com.eventvenue.model.Room;
import com.eventvenue.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/rooms")
public class RoomServlet extends HttpServlet {

    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Rooms are publicly viewable — no login required
        // Login is only required when the user tries to book
        List<Room> rooms = roomDAO.getAllAvailableRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/WEB-INF/views/rooms.jsp").forward(request, response);
    }
}
