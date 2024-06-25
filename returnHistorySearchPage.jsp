<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>책</title>
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
            </style>
            <script>

            </script>
        </head>

        <body>
            <h3>대여 및 반납 정보 관리</h3>
            <a href="rentalAndReturnSearchPage">뒤로가기</a><br><br><br>

            <p>반납 내역</p>

            <form action="returnHistorySearchPage" method="post" id="searchForm">
                <label for="searchDate">반납일:</label>
                <select class="searchDate" name="searchDate">
                    <option value="all">전체</option>
                    <option value="period">기간설정</option>
                </select>
                <label for="startDate">From:</label>
                <input type="text" id="startDate" class="date-range" name="startDate">

                <label for="endDate">To:</label>
                <input type="text" id="endDate" class="date-range" name="endDate">
                <br>
                <label for="searchText">반납자 ID:</label>
                <input type="text" id="searchText" name="searchText" placeholder="반납자 ID로 검색">
                <button type="submit">검색</button>
            </form>
            
           

            <form action="returnHistorySearchPage" method="get">
                <button type="submit">전체반납조회</button>
            </form>

            <form action="" method="get">
                <button type="submit"></button>
            </form>

            <br>
            <br>

  
            <div style="display: left;">
                <div style="flex: 1;  margin-right: -150px;">
                    <table id="bookTable" style="border: 1px solid black;">
                        <thead>
                            <tr>
                                <th>반납자 ID</th>
                                <th>대여 번호</th>
                                <th class="rentalDateYellow">대여 날짜</th>
                                <th class="returnDueDateRed">대여 만기일</th>
                                <th>반납일</th>
                                <th>반납 받은 관리자</th>
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
                                    <td>${book.returnedDate}</td>
                                    <td>${book.returnAdminMid}</td>
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
            <br> <br>


            <br> <br>
            <a href="menu" class="menu-button">메뉴화면으로 이동하기</a>
            <hr>

            <script>
                function navigateToDetail(bookNum, bookRegisterDate) {
                    var url = 'bookDetail?bookNum=' + bookNum + '&bookRegisterDate=' + bookRegisterDate;
                    window.location.href = url;
                }
            </script>
            <script>

                /* datePicker 날짜 */
                $(function () {
                    // jQuery UI의 datepicker를 초기화
                    $(".date-range").datepicker({
                        dateFormat: "yy-mm-dd",
                        onSelect: function (dateText, inst) {
                            // 선택된 날짜를 가져와서 시작 날짜 또는 종료 날짜에 설정
                            var selectedDate = new Date(dateText);
                            if (inst.id === 'startDate') {
                                // 시작 날짜가 선택된 경우, 종료 날짜의 최소값을 선택된 날짜로 설정
                                $("#endDate").datepicker("option", "minDate", selectedDate);
                            } else if (inst.id === 'endDate') {
                                // 종료 날짜가 선택된 경우, 시작 날짜의 최대값을 선택된 날짜로 설정
                                $("#startDate").datepicker("option", "maxDate", selectedDate);
                            }
                        },
                        yearRange: "1900:+1", // 시작 년도부터 현재 년도까지의 범위 지정
                        changeYear: true, // 년도 선택 가능하도록 설정
                    });
                });

                $(function () {
                    // 등록일 선택 옵션 변경 시 이벤트 핸들러
                    $(".searchDate").change(function () {
                        var selectedOption = $(this).val();
                        if (selectedOption === "date") {
                            $(".date-range").datepicker("option", "maxDate", null); // 선택된 날짜만 사용하도록 설정
                            $(".date-range").datepicker("enable");
                            $("#endDate").prop("disabled", true); // 날짜선택(date) 옵션 선택 시 종료날짜 입력 비활성화
                            $("#endDate").val("");
                        } else if (selectedOption === "period") {
                            $(".date-range").datepicker("enable");
                            $("#endDate").prop("disabled", false); // 기간설정(period) 옵션 선택 시 종료날짜 입력 활성화
                        } 
                        else {
                            $(".date-range").datepicker("disable");
                            $("#startDate").val("");
                            $("#endDate").val(""); // 전체 'all' 옵션 선택 시 종료날짜 입력 초기화
                        }
                    });

                    // 기본적으로 datepicker는 비활성화 상태로 시작
                    $(".date-range").datepicker("disable");

                });

                /*---------일괄 삭제---------------- */
                function uncheckAllBooks() {
                    // 모든 도서 체크박스의 체크를 해제
                    $('.bookCheckbox').prop('checked', false);
                }
                // 일괄 삭제 버튼 클릭 이벤트 핸들러
                function deleteSelectedBooks() {
                    var selectedBooks = [];

                    // 체크된 도서들을 배열에 추가
                    $('.bookCheckbox:checked').each(function () {
                        selectedBooks.push($(this).val());
                    });

                    // 체크된 도서가 없으면 경고창을 띄우고 함수 종료
                    if (selectedBooks.length === 0) {
                        Swal.fire({
                            icon: 'warning',
                            title: '삭제할 도서를 선택하세요.',
                        });
                        return;
                    }// 일괄선택취소 버튼 클릭 이벤트 핸들러

                    var selectedBooksString = selectedBooks.join(',');

                    Swal.fire({
                        title: '정말로 삭제하시겠습니까?',
                        text: '선택한 도서들이 영구적으로 삭제됩니다.',
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            $.ajax({
                                url: '/deleteSelectedBooks',
                                method: 'POST',
                                contentType: 'application/json; charset=utf-8',
                                data: JSON.stringify(selectedBooks),
                                success: function (response) {
                                    Swal.fire({
                                        icon: 'success',
                                        title: '삭제 성공',
                                        text: '선택한 도서들이 삭제되었습니다!',
                                    }).then((result) => {
                                        location.reload();
                                    });
                                },
                                error: function (error) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: '삭제 실패',
                                        text: '도서 삭제 중 오류가 발생했습니다.',
                                    });
                                }
                            });
                        }
                    });
                }
            </script>

            <!--메세지-->
            <script>
                // history.replaceState({},null,null);
                // history.state


                $(document).ready(function () {

                    var message = '${message}';
                    if (message === 'returnSuccess') {
                        Swal.fire({
                            icon: 'success',
                            title: '반납 성공',
                            text: '반납 승인 완료',
                        });
                    }
                })

            </script>
        </body>

        </html>