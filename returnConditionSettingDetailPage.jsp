<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>반납점검이력관리</title>
            <!--jQuery-->
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
            <!-- SweetAlert2 -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
            <h3>반납 점검 이력 관리</h3>
        </head>

        <body>
            <h4>점검 항목 수정 : </h4>
            <form action="updateConditionSetting" method="post">
                <table>
                    <thead>
                        <tr>
                            <th>외부상태ID</th>
                            <th>내부상태ID</th>
                            <th>외부상태 내용</th>
                            <th>내부상태 내용</th>
                       
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="rCondition" items="${rConditionDTOList}">
                            <tr>
                                <td>
                                    <c:out value="${rCondition.exteriorConditionId}" />
                                    <input type="hidden" name="exteriorConditionId" value="<c:out value="${rCondition.exteriorConditionId}" />">
                                </td>
                                <td>
                                    <c:out value="${rCondition.interiorConditionId}" />
                                    <input type="hidden" name="interiorConditionId" value="<c:out value="${rCondition.interiorConditionId}" />">
                                </td>
                                <td><input type="text" name="exteriorConditionDisplay" 
                                    value="<c:out value="${rCondition.exteriorConditionDisplay}" />"></td>
                                <td><input type="text" name="interiorConditionDisplay" 
                                    value="<c:out value="${rCondition.interiorConditionDisplay}" />"></td>
                               
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <button type="submit">점검 내용 변경</button>
                <br>
                
            </form>
            <hr>
            <br><br>
            <a href="returnConditionHistoryPage">반납할 때 점검한 이력 조회</a>
            <br><br><br>
            <a href="menu" class="menu-button">메뉴화면으로 이동하기</a>
          
            <script>      
             var message = '${message}'; 
                $(document).ready(function () {
                    if (message === 'returnConditionsChanged') {
                        Swal.fire({
                            icon: 'success',
                            title: '변경 성공',
                            text: '점검 항목 내용이 변경 되었습니다',
                        });
                    }
                })
                </script>
        </body>

  
        </html>