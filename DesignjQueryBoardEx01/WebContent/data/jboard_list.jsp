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

	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	JSONArray jsonArray = new JSONArray();
	try {
		Context initCtx = new InitialContext();
		Context envCtx = (Context)initCtx.lookup("java:comp/env");
		DataSource dataSource = (DataSource)envCtx.lookup("jdbc/jquery");
		
		conn = dataSource.getConnection();
		
		String sql = "select seq, subject, writer, mail, content, date_format(wdate, '%Y-%m-%d (%H시 %m분)') wdate from jboard";
		pstmt = conn.prepareStatement(sql);
		
		rs = pstmt.executeQuery();
		while (rs.next()) {
			String seq = rs.getString("seq");
			String subject = rs.getString("subject");
			String writer = rs.getString("writer");
			String mail = rs.getString("mail");
			String content = rs.getString("content").replaceAll("\n", "<br>").replaceAll(" ", "&nbsp");
			String wdate = rs.getString("wdate");
			
			JSONObject obj = new JSONObject();
			obj.put("seq", seq);
			obj.put("subject", subject);
			obj.put("writer", writer);
			obj.put("mail", mail);
			obj.put("content", content);
			obj.put("wdate", wdate);
			
			jsonArray.add(obj);
		}
		
	} catch (NamingException e) {
		System.out.println("[에러] : " + e.getMessage());
	} catch (SQLException e) {
		System.out.println("[에러] : " + e.getMessage());
	} finally {
		if (rs != null) rs.close();
		if (pstmt != null) pstmt.close();
		if (conn != null) conn.close();
	}
	
	JSONObject result = new JSONObject();
	result.put("data", jsonArray);

	out.println(result);
%>