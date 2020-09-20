<%@ page language="java" contentType="text/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
    
<%@ page import="javax.naming.Context" %>
<%@ page import="javax.naming.InitialContext" %>
<%@ page import="javax.naming.NamingException" %>

<%@ page import="javax.sql.DataSource" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>

<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
	request.setCharacterEncoding("utf-8");
	
	String seq = request.getParameter("seq");
	String m_subject = request.getParameter("m_subject");
	String m_writer = request.getParameter("m_writer");
	String m_mail = request.getParameter("m_mail");
	String m_password = request.getParameter("m_password");
	String m_content = request.getParameter("m_content");
	
	int flag = 1;

	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource)envCtx.lookup("jdbc/jquery");
		
		conn = dataSource.getConnection();
		
		String sql = "update jboard set subject=?, writer=?, mail=?, content=? where seq=? and password=?";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, m_subject);
		pstmt.setString(2, m_writer);
		pstmt.setString(3, m_mail);
		pstmt.setString(4, m_content);
		pstmt.setString(5, seq);
		pstmt.setString(6, m_password);
		
		if (pstmt.executeUpdate() == 1) {
			flag = 0;
		}
		
	} catch (NamingException e) {
		System.out.println("[에러] : " + e.getMessage());
	} catch (SQLException e) {
		System.out.println("[에러] : " + e.getMessage());
	} finally {
		if (pstmt != null) pstmt.close();
		if (conn != null) conn.close();
	}
	
	JSONObject result = new JSONObject();
	result.put("flag", flag);

	out.println(result);
%>