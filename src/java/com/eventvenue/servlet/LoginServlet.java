package com.eventvenue.servlet;

import com.eventvenue.dao.UserDAO;
import com.eventvenue.model.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Already logged in? Redirect appropriately
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.isAdmin()) {
                response.sendRedirect("admin?action=dashboard");
            } else {
                response.sendRedirect("rooms");
            }
            return;
        }
        // Pass through any redirect params so the form can keep them
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email    = request.getParameter("email");
        String password = request.getParameter("password");
        // Optional redirect params from the rooms page "Login to Book" button
        String redirect = request.getParameter("redirect");
        String roomId   = request.getParameter("roomId");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(email.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getId());
            session.setAttribute("userName", user.getFullName());
            session.setAttribute("userRole", user.getRole());

            // Admin always goes to dashboard
            if (user.isAdmin()) {
                response.sendRedirect("admin?action=dashboard");
            }
            // If user clicked "Login to Book" from the rooms page, send them straight to the form
            else if ("booking".equals(redirect) && roomId != null && !roomId.isEmpty()) {
                response.sendRedirect("booking?action=form&roomId=" + roomId);
            }
            // Otherwise go to venues list
            else {
                response.sendRedirect("rooms");
            }
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}
