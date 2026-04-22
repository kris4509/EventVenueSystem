package com.eventvenue.servlet;

import com.eventvenue.dao.NotificationDAO;
import com.eventvenue.model.Notification;
import com.eventvenue.model.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

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
        List<Notification> notifications = notifDAO.getNotificationsByUser(user.getId());
        notifDAO.markAllRead(user.getId());

        request.setAttribute("notifications", notifications);
        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }
}
