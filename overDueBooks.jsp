<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>책연체관리</title>
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
                table {
                    font-family: arial, sans-serif;
                    border-collapse: collapse;
                    width: 100%;
                }

                td,
                th {
                    border: 1px solid #dddddd;
                    text-align: left;
                    padding: 8px;
                }

                tr:nth-child(even) {
                    background-color: #dddddd;
                }

                .menu-button {
                    display: inline-block;
                    padding: 10px 20px;
                    background-color: #f1f1f1;
                    color: #333;
                    text-decoration: none;
                    border-radius: 2px;
                    border: 2px solid #333;
                    font-family: 'Nanum Gothic', sans-serif;
                    font-weight: bold;
                }

                tbody tr {
                    cursor: pointer;
                }

                tbody tr:hover {
                    background-color: #f5f5f5;
                }
                .midRed {
                    color: red;
                }

                .rentalDateYellow {
                    background-color: lemonchiffon;
                }

                .returnDueDateRed {
                    background-color: pink;
                    color: red;
                }
                .overdueDays {
                    color: red;
                }
                
            </style>
            <script>

            </script>
        </head>

        <body>
            <h3>책 연체 관리</h3>

            <h4>연체된 도서 목록</h4>

            <h4>오늘 날짜 : </h4>
            <%
                java.util.Date today = new java.util.Date();
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                String formattedDate = sdf.format(today);
            %>
            <!-- 오늘의 날짜를 출력 -->
            <h4><%= formattedDate %></h4>
            <br>

            <div style="display: left;">
                <div style="flex: 1;  margin-right: -150px;">
                    <table id="bookTable" style="border: 1px solid black;">
                        <thead>
                            <tr>
                                <th>대여자 ID</th>
                                <th>대여 번호</th>
                                <th class="rentalDateYellow">대여 날짜</th>
                                <th class="returnDueDateRed">대여 만기일</th>
                                <th> 열체일수 </th>
                                <th>도서 번호</th>
                                <th>재고 번호</th>
                                <th>도서 제목</th>
                                <th>도서 작가</th>
                                <th>도서 등록일</th>

                            </tr>
                        </thead>
                        <tbody id="bookTableBody">
                            <c:forEach var="book" items="${bookList}">
                                <tr class='<c:if test="${book.overDue}">overDue</c:if>'>
                                    <td class="midRed">${book.mid}</td>
                                    <td>${book.rentalNum}</td>
                                    <td class="rentalDateYellow">${book.rentalDate}</td>
                                    <td class="returnDueDateRed">${book.returnDueDate}</td>
                                    <td class="overdueDays">${book.overdueDays}</td>
                                    <td>${book.bookNum}</td>
                                    <td>${book.bookStkNum}</td>
                                    <td>${book.bookTitle}</td>
                                    <td>${book.bookAuthor}</td>
                                    <td>${book.bookRegisterDate}</td>

                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>


            <form action="closeToReturnDateList" method="get" >
                <button type="submit">반납기한이 임박한 대여 목록 보기</button>
            </form>
            <br>
            <br>
            <a href="menu" class="menu-button">메뉴화면으로 이동하기</a>


        </body>

        </html>