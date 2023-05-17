<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%
	// OracleDB에 접속
	String driver = "oracle.jdbc.driver.OracleDriver";
	String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe";
	String dbUser = "hr";
	String dbPw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	System.out.println(conn + " <--grouping ");
	
	// grouping sets() 
	String groupSql = "";
	PreparedStatement groupStmt = null;
	ResultSet groupRs = null;
	
	groupSql = "SELECT department_Id departmentID, job_id jobId, COUNT(*) cnt from employees GROUP BY GROUPING SETS(department_id, job_id)";
	groupStmt = conn.prepareStatement(groupSql);
	groupRs = groupStmt.executeQuery();
	
	// ResultSet -> ArrayList
	ArrayList<HashMap<String, Object>> groupList = new ArrayList<HashMap<String, Object>>();
	while(groupRs.next()){
		HashMap<String, Object> g = new HashMap<String, Object>();
		g.put("departmentId", groupRs.getInt("departmentId"));
		g.put("jobId", groupRs.getString("jobId"));
		g.put("cnt", groupRs.getInt("cnt"));
		groupList.add(g);
	}
	System.out.println(groupList.size() + " <--group_by_function groupList.size()");
	
	// rollup()
	String rollSql = "";
	PreparedStatement rollStmt = null;
	ResultSet rollRs = null;
	
	rollSql = "SELECT department_Id departmentID, job_id jobId, COUNT(*) cnt from employees GROUP BY ROLLUP(department_id, job_id)";
	rollStmt = conn.prepareStatement(rollSql);
	rollRs = rollStmt.executeQuery();
	
	// ResultSet -> ArrayList
	ArrayList<HashMap<String, Object>> rollList = new ArrayList<HashMap<String, Object>>();
	while(rollRs.next()){
		HashMap<String, Object> r = new HashMap<String, Object>();
		r.put("departmentId", rollRs.getInt("departmentId"));
		r.put("jobId", rollRs.getString("jobId"));
		r.put("cnt", rollRs.getInt("cnt"));
		rollList.add(r);
	}
	System.out.println(rollList.size() + " <--group_by_function rollList.size()");
	
	// cube()
	String cubeSql = "";
	PreparedStatement cubeStmt = null;
	ResultSet cubeRs = null;
	
	cubeSql = "SELECT department_Id departmentID, job_id jobId, COUNT(*) cnt from employees GROUP BY CUBE(department_id, job_id)";
	cubeStmt = conn.prepareStatement(cubeSql);
	cubeRs = cubeStmt.executeQuery();
	
	// ResultSet -> ArrayList
	ArrayList<HashMap<String, Object>> cubeList = new ArrayList<HashMap<String, Object>>();
	while(cubeRs.next()){
		HashMap<String, Object> c = new HashMap<String, Object>();
		c.put("departmentId", cubeRs.getInt("departmentId"));
		c.put("jobId", cubeRs.getString("jobId"));
		c.put("cnt", cubeRs.getInt("cnt"));
		cubeList.add(c);
	}
	System.out.println(cubeList.size() + " <--group_by_function cubeList.size()");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>GROUP BY FUNCTION</title>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<h1>group by절 확장함수</h1>
	<div class="row">
		<div class="col-4">
		<h2>GROUPSETS()</h2>
		<table border="1">
			<tr>
				<th>부서Id</th>
				<th>직무Id</th>
				<th>인원</th>
			</tr>
			<%
				for(HashMap<String,Object> g : groupList){	
			%>
					<tr>
						<td><%=g.get("departmentId")%></td>
						<td><%=g.get("jobId")%></td>
						<td><%=g.get("cnt")%></td>
					</tr>
			<%
				}
			%>
			</table>
			</div>
			
			<div class="col-4">
			<h2>ROLLUP()</h2>
			<table border="1">
				<tr>
					<th>부서Id</th>
					<th>직무Id</th>
					<th>인원</th>
				</tr>
			<%
				for(HashMap<String,Object> r : rollList){	
			%>
					<tr>
						<td><%=r.get("departmentId")%></td>
						<td><%=r.get("jobId")%></td>
						<td><%=r.get("cnt")%></td>
					</tr>
			<%
				}
			%>
			</table>
			</div>
			
			<div class="col-4">
			<h2>CUBE()</h2>
			<table border="1">
			<tr>
				<th>부서Id</th>
				<th>직무Id</th>
				<th>인원</th>
			</tr>
			<%
				for(HashMap<String,Object> c : cubeList){	
			%>
					<tr>
						<td><%=c.get("departmentId")%></td>
						<td><%=c.get("jobId")%></td>
						<td><%=c.get("cnt")%></td>
					</tr>
			<%
				}
			%>
			</table>
			</div>
		</div>
</body>
</html>