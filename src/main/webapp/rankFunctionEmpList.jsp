<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
   int currentPage = 1;
   if(request.getParameter("currentPage") != null) {
      currentPage = Integer.parseInt(request.getParameter("currentPage"));
   }
   
   String driver = "oracle.jdbc.driver.OracleDriver";
   String dburl = "jdbc:oracle:thin:@localhost:1521:xe";
   String dbuser = "hr";
   String dbpw = "java1234";
   Class.forName(driver);
   Connection conn = DriverManager.getConnection(dburl, dbuser, dbpw);
   System.out.println(conn);
   
	// 전체 행의 수
   int totalRow = 0;
   String totalRowSql = "select count(*) from employees";
   PreparedStatement totalRowStmt = conn.prepareStatement(totalRowSql);
   ResultSet totalRowRs = totalRowStmt.executeQuery();
   if(totalRowRs.next()) {
      totalRow = totalRowRs.getInt(1); // totalRowRs.getInt("count(*)")
   }
   
	// 페이지당 출력 행의 수 
	int rowPerPage = 10;
	// 페이지당 시작 행 계산
	int beginRow = (currentPage-1) * rowPerPage + 1;
	// 페이지당 끝행 계산
	int endRow = beginRow + (rowPerPage - 1);
	if(endRow > totalRow) {
	     endRow = totalRow;
   }
   /*
	select 번호, ID, 이름, 급여, 급여순위 
	from (select rownum 번호, ID, 이름, 급여, 급여순위 
   		from (select employee_id ID, last_name 이름, salary 급여, rank() over(order by salary desc) 급여순위 
        		from employees)) 
	where 번호 between 1 and 10
   */
   String sql = "select 번호, ID, 이름, 급여, 급여순위 from (select rownum 번호, ID, 이름, 급여, 급여순위 from (select employee_id ID, last_name 이름, salary 급여, rank() over(order by salary desc) 급여순위 from employees)) where 번호 between ? and ?";
   PreparedStatement stmt = conn.prepareStatement(sql);
   stmt.setInt(1, beginRow);
   stmt.setInt(2, endRow);
   ResultSet rs = stmt.executeQuery();
   
   ArrayList<HashMap<String, Object>> list = new ArrayList<>();
   while(rs.next()) {
      HashMap<String, Object> m = new HashMap<String, Object>();
      m.put("번호", rs.getInt("번호"));
      m.put("ID", rs.getString("ID"));
      m.put("이름", rs.getString("이름"));
      m.put("급여", rs.getInt("급여"));
      m.put("급여순위", rs.getInt("급여순위"));
      list.add(m);
   }
   System.out.println(list.size() + " <- list.size()");
   
	// 라스트 페이지 번호
	int lastPage = totalRow / rowPerPage;
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage+1;
	}
	// 페이지 네비게이션 페이징
	int pagePerPage = 10;
	// 네비게이션 바 첫번째 페이지 숫자
	int minPage = ((currentPage -1) / pagePerPage * pagePerPage) + 1;
	// 네비게이션 바 마지막 페이지 숫자
	int maxPage = minPage + (pagePerPage -1);
	// 네비게이션 바 마지막 페이지 숫자와 데이터 끝 페이지 비교
	if(maxPage > lastPage) {
		maxPage = lastPage;
	}
		
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
   <table border="1">
      <tr>
         <td>번호</td>
         <td>직원ID</td>
         <td>이름</td>
         <td>급여</td>
         <td>급여순위</td>
      </tr>
      <%
         for(HashMap<String, Object> m : list) {
      %>
            <tr>
               <td><%=(Integer)(m.get("번호"))%></td>
               <td><%=(String)(m.get("ID"))%></td>
               <td><%=(String)(m.get("이름"))%></td>
               <td><%=(Integer)(m.get("급여"))%></td>
               <td><%=(Integer)(m.get("급여순위"))%></td>
            </tr>
      <%      
         }
      %>
   </table>
   <%// 네비게이션 바 첫번째 페이지 숫자가 1 보다 크면 이전 버튼 표시
   	 if(minPage > 1) {
   %>    
   	 	<a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage-pagePerPage%>">이전</a>   
   <%
      }
	  // 네비게이션 바 마지막 페이지 숫자보다 i가 작으면 그 사이 숫자를 표시
      for(int i = minPage; i<=maxPage; i=i+1) {
         if(i == currentPage) {
   %>
            <span><%=i%></span>&nbsp;
   <%         
         } else {      
   %>
            <a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=i%>"><%=i%></a>&nbsp;   
   <%   
         }
      }
  	  // 네비게이션 바 마지막 페이지 숫자와 라스트페이지 비교하여 다음 버튼 표시
      if(maxPage != lastPage) {
   %>
         <!--  maxPage + 1 -->
         <a href="<%=request.getContextPath()%>/rankFunctionEmpList.jsp?currentPage=<%=minPage+pagePerPage%>">다음</a>
   <%
      }
   %>

</body>
</html>