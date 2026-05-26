package com.ecommerce.dao;

import com.ecommerce.model.Order;
import com.ecommerce.model.OrderItem;
import com.ecommerce.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /** Sipariş oluşturur — oluşturulan sipariş ID'sini döndürür */
    public int save(Order order) throws SQLException {
        String sql = "INSERT INTO orders (user_id, total_amount, status) " +
                     "VALUES (?, ?, ?) RETURNING id";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, order.getUserId());
            ps.setBigDecimal(2, order.getTotalAmount());
            ps.setString(3, "Beklemede");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        }
        return -1;
    }

    /** Sipariş kalemi ekler (aynı bağlantıda çağrılır — transaction) */
    public void saveOrderItem(Connection conn, OrderItem item) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) " +
                     "VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getProductId());
            ps.setInt(3, item.getQuantity());
            ps.setBigDecimal(4, item.getUnitPrice());
            ps.setBigDecimal(5, item.getSubtotal());
            ps.executeUpdate();
        }
    }

    /**
     * Transaction içinde sipariş + kalemler + stok güncellemesini atomik kaydeder.
     */
    public int saveOrderWithItems(Order order, List<OrderItem> items) throws SQLException {
        String insertOrder = "INSERT INTO orders (user_id, total_amount, status) " +
                             "VALUES (?, ?, ?) RETURNING id";
        String insertItem  = "INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) " +
                             "VALUES (?, ?, ?, ?, ?)";
        String updateStock = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1) Sipariş kaydı
                int orderId;
                try (PreparedStatement ps = conn.prepareStatement(insertOrder)) {
                    ps.setInt(1, order.getUserId());
                    ps.setBigDecimal(2, order.getTotalAmount());
                    ps.setString(3, "Beklemede");
                    ResultSet rs = ps.executeQuery();
                    rs.next();
                    orderId = rs.getInt(1);
                }

                // 2) Kalemler + stok
                try (PreparedStatement psItem  = conn.prepareStatement(insertItem);
                     PreparedStatement psStock = conn.prepareStatement(updateStock)) {
                    for (OrderItem item : items) {
                        // Kalem ekle
                        psItem.setInt(1, orderId);
                        psItem.setInt(2, item.getProductId());
                        psItem.setInt(3, item.getQuantity());
                        psItem.setBigDecimal(4, item.getUnitPrice());
                        psItem.setBigDecimal(5, item.getSubtotal());
                        psItem.addBatch();

                        // Stok düşür
                        psStock.setInt(1, item.getQuantity());
                        psStock.setInt(2, item.getProductId());
                        psStock.setInt(3, item.getQuantity());
                        psStock.addBatch();
                    }
                    psItem.executeBatch();
                    psStock.executeBatch();
                }

                conn.commit();
                return orderId;

            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    /** Kullanıcıya ait siparişler */
    public List<Order> getByUserId(int userId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.user_id = ? ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Sipariş detayı (başlık) */
    public Order getById(int id) throws SQLException {
        String sql = "SELECT o.*, u.full_name FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        }
        return null;
    }

    /** Tüm siparişler (admin) */
    public List<Order> getAll() throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.full_name FROM orders o " +
                     "JOIN users u ON o.user_id = u.id " +
                     "ORDER BY o.order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    /** Sipariş kalemleri */
    public List<OrderItem> getOrderItems(int orderId) throws SQLException {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, p.name AS product_name, p.image_url FROM order_items oi " +
                     "JOIN products p ON oi.product_id = p.id " +
                     "WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderItem item = new OrderItem();
                item.setId(rs.getInt("id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setProductName(rs.getString("product_name"));
                item.setImageUrl(rs.getString("image_url"));
                item.setQuantity(rs.getInt("quantity"));
                item.setUnitPrice(rs.getBigDecimal("unit_price"));
                item.setSubtotal(rs.getBigDecimal("subtotal"));
                list.add(item);
            }
        }
        return list;
    }

    /** Sipariş durumunu günceller */
    public void updateStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    /** Toplam sipariş sayısı (dashboard) */
    public int getTotalCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    /** Bekleyen sipariş sayısı (dashboard) */
    public int getPendingCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Beklemede'";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    // ResultSet → Order
    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setUserId(rs.getInt("user_id"));
        o.setCustomerName(rs.getString("full_name"));
        Timestamp ts = rs.getTimestamp("order_date");
        if (ts != null) o.setOrderDate(ts.toLocalDateTime());
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setStatus(rs.getString("status"));
        return o;
    }
}
