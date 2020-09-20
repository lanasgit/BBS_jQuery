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
	
	String w_subject = request.getParameter("w_subject");
	String w_writer = request.getParameter("w_writer");
	String w_mail = request.getParameter("w_mail");
	String w_password = request.getParameter("w_password");
	String w_content = request.getParameter("w_content");
	
	int flag = 1;

	Connection conn = null;
	PreparedStatement pstmt = null;
	
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource)envCtx.lookup("jdbc/jquery");
		
		conn = dataSource.getConnection();
		
		String sql = "alter table jboard auto_increment = 1";
		pstmt = conn.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
		
		sql = "insert into jboard values (0, ?, ?, ?, ?, ?, now())";
		pstmt = conn.prepareStatement(sql);
		pstmt.setString(1, w_subject);
		pstmt.setString(2, w_writer);
		pstmt.setString(3, w_mail);
		pstmt.setString(4, w_password);
		pstmt.setString(5, w_content);
		
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