<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbuser = "sqld";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	System.out.println(conn);
	
	// null 관련 함수
	// nvl()
	String nvlSql = "select 이름, nvl(일분기, 0) 일분기실적 from 실적";
	PreparedStatement nvlStmt = conn.prepareStatement(nvlSql);
	System.out.println(nvlStmt);
	ResultSet nvlRs = nvlStmt.executeQuery();

	ArrayList<HashMap<String, Object>> nvlList = new ArrayList<HashMap<String, Object>>();
	
	while (nvlRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("이름", nvlRs.getString("이름"));
		m.put("일분기실적", nvlRs.getInt("일분기실적"));
		nvlList.add(m);
	}
	
	System.out.println(nvlList);

	// nvl2()
	String nvl2Sql = "select 이름, nvl2(일분기, 'success', 'fail') 일분기실적여부 from 실적";
	PreparedStatement nvl2Stmt = conn.prepareStatement(nvl2Sql);
	System.out.println(nvl2Stmt);
	ResultSet nvl2Rs = nvl2Stmt.executeQuery();

	ArrayList<HashMap<String, Object>> nvl2List = new ArrayList<HashMap<String, Object>>();
	
	while (nvl2Rs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("이름", nvl2Rs.getString("이름"));
		m.put("일분기실적여부", nvl2Rs.getString("일분기실적여부"));
		nvl2List.add(m);
	}
	
	System.out.println(nvl2List);
	
	// nullif()
	String nullifSql = "select 이름, nullif(사분기, 100) \"사분기실적(100제외)\" from 실적";
	PreparedStatement nullifStmt = conn.prepareStatement(nullifSql);
	System.out.println(nullifStmt);
	ResultSet nullifRs = nullifStmt.executeQuery();

	ArrayList<HashMap<String, Object>> nullifList = new ArrayList<HashMap<String, Object>>();
	
	while (nullifRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("이름", nullifRs.getString("이름"));
		m.put("사분기실적(100제외)", nullifRs.getInt("사분기실적(100제외)"));
		nullifList.add(m);
	}
	
	System.out.println(nullifList);
	
	// coalesce()
	String coalesceSql = "select 이름, coalesce(일분기, 이분기, 삼분기, 사분기) 첫실적 from 실적";
	PreparedStatement coalesceStmt = conn.prepareStatement(coalesceSql);
	System.out.println(coalesceStmt);
	ResultSet coalesceRs = coalesceStmt.executeQuery();

	ArrayList<HashMap<String, Object>> coalesceList = new ArrayList<HashMap<String, Object>>();
	
	while (coalesceRs.next()){
		HashMap<String, Object> m = new HashMap<String, Object>();
		m.put("이름", coalesceRs.getString("이름"));
		m.put("첫실적", coalesceRs.getInt("첫실적"));
		coalesceList.add(m);
	}
	
	System.out.println(coalesceList);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>실적 table NVL Test</h1>
	<table>
		<tr>
			<td>이름</td>
			<td>일분기실적</td>
		</tr>
	<%
			for(HashMap<String, Object> m : nvlList){
	%>
				<tr>
					<td><%=(String)(m.get("이름"))%></td>
					<td><%=(Integer)(m.get("일분기실적"))%></td>
				</tr>
	<%
				
			}
	%>
	</table>
	<hr>
	<h1>실적 table NVL2 Test</h1>
	<table>
		<tr>
			<td>이름</td>
			<td>일분기실적여부</td>
		</tr>
	<%
			for(HashMap<String, Object> m : nvl2List){
	%>
				<tr>
					<td><%=(String)(m.get("이름"))%></td>
					<td><%=(String)(m.get("일분기실적여부"))%></td>
				</tr>
	<%
				
			}
	%>
	</table>
	<hr>
	<h1>실적 table NULLIF Test</h1>
	<table>
		<tr>
			<td>이름</td>
			<td>사분기실적(100제외)</td>
		</tr>
	<%
			for(HashMap<String, Object> m : nullifList){
	%>
				<tr>
					<td><%=(String)(m.get("이름"))%></td>
					<td><%=(Integer)(m.get("사분기실적(100제외)"))%></td>
				</tr>
	<%
				
			}
	%>
	</table>
	<hr>
	<h1>실적 table COALESCE Test</h1>
	<table>
		<tr>
			<td>이름</td>
			<td>첫실적</td>
		</tr>
	<%
			for(HashMap<String, Object> m : coalesceList){
	%>
				<tr>
					<td><%=(String)(m.get("이름"))%></td>
					<td><%=(Integer)(m.get("첫실적"))%></td>
				</tr>
	<%
				
			}
	%>
	</table>
	<hr>
</body>
</html>