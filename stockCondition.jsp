<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>대여 확인</title>
            <!-- jQuery -->
            <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

            <!-- jQuery UI -->
            <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
            <!-- SweetAlert2 -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
            <style>
                #bookTable,
                #bookStkNumTable {
                    border: 1px solid black;
                    display: inline-block;
                    vertical-align: top;
                    margin-right: 20px;
                    /* 오른쪽 여백 조절 */
                }
            </style>
       
        </head>

        <body>
            <h2>재고 상태</h2>
            <table style="border: 1px solid black;">
                <thead>
                    <tr>
                        <th>책 번호</th>
                        <th>외부 상태</th>
                        <th>내부 상태</th>
                        <th>외부 상태 표시</th>
                        <th>내부 상태 표시</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${bStkDTOList}" var="bStkDTO">
                        <tr>
                            <td>
                                <c:out value="${bStkDTO.bookNum}" />
                            </td>
                            <td>
                                <c:out value="${bStkDTO.exteriorCondition}" />
                            </td>
                            <td>
                                <c:out value="${bStkDTO.interiorCondition}" />
                            </td>
                            <td>
                                <c:out value="${bStkDTO.exteriorConditionDisplay}" />
                            </td>
                            <td>
                                <c:out value="${bStkDTO.interiorConditionDisplay}" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

        </body>

        </html>