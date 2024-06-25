<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>반납 확인</title>
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

                }

                .overDue {
                    background-color: red;
                }

                .currentCondition {
                    color: red;
                }

            </style>
        </head>

        <body>
            <script>
                var bookStkNums = "${bookStkNums}";
                console.log("bookStkNums : " + "${bookStkNums}");

            </script>
            <div>
                <h1>반납 확인</h1>

                <p>반납자 아이디: ${member.mid}</p>
                <!--<p>책 재고 번호: ${bookStkNums}</p> -->
                <p>반납자 이름 : ${member.memberName}</p>
                <p>반납자 권한 :
                    <c:choose>
                        <c:when test="${member.auth eq 'user'}">일반 사용자</c:when>
                        <c:when test="${member.auth eq 'admin'}">관리자</c:when>
                    </c:choose>
                </p>
                <p>현재 대여중인 도서 개수 : ${member.currentRentalCount}</p>

                <h1>반납 할 책 목록 : </h1>

                <table id="bookStkNumTable" style="border: 1px solid black;">
                    <thead>
                        <tr>
                            <th class="currentCondition">마지막 점검 외부상태</th>
                            <th class="currentCondition">마지막 점검 내부상태</th>
                            <th>외부 상태확인</th>
                            <th>내부 상태확인</th>
                            <th>재고번호</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="book" items="${bStkDTOList}">
                            <tr>
                                <td class="currentCondition">

                                    <c:forEach var="condition" items="${exConditionList}">
                                        <c:if test="${book.exteriorConditionId eq condition.exteriorConditionId}">
                                            ${condition.exteriorConditionDisplay}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td class="currentCondition">

                                    <c:forEach var="condition" items="${inConditionList}">
                                        <c:if test="${book.interiorConditionId eq condition.interiorConditionId}">
                                            ${condition.interiorConditionDisplay}
                                        </c:if>
                                    </c:forEach>
                                </td>
                                <td class="currentCondition">
                                    <select name="exCondition">
                                        <c:forEach var="condition" items="${exConditionList}" varStatus="status">
                                            <option <c:if test="${status.first}">selected</c:if>
                                                value="${condition.exteriorConditionId}">${condition.exteriorConditionDisplay}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td class="currentCondition">
                                    <select name="inCondition">
                                        <c:forEach var="condition" items="${inConditionList}" varStatus="status">
                                            <option <c:if test="${status.first}">selected</c:if>
                                                value="${condition.interiorConditionId}">${condition.interiorConditionDisplay}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </td>
                                <td>
                                    ${book.bookStkNum}
                                    <input type="hidden" name="bookStkNum" value="${book.bookStkNum}" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div style="display: left;">
                    <div style="flex: 1;  margin-right: -150px;">
                        <table id="bookTable" style="border: 1px solid black;">
                            <thead>
                                <tr>
                                    <th>도서 번호</th>
                                    <th>도서 제목</th>
                                    <th>도서 작가</th>
                                    <th>등록일</th>
                                    <th>반납 예정일</th>
                                </tr>
                            </thead>
                            <tbody id="bookTableBody">
                                <c:forEach var="book" items="${bookList}">
                                    <tr class='<c:if test="${book.overDue}">overDue</c:if>' >
                                        <td>${book.bookNum}</td>
                                        <td>${book.bookTitle}</td>
                                        <td>${book.bookAuthor}</td>
                                        <td>${book.bookRegisterDate}</td>
                                        <td>${book.returnDueDate}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

            <p>반납자 서명 : </p>
            <form id="returnForm" action="checkRenterIdAndPw" method="post">

                <label for="userInputMid">반납자ID</label>
                <input type="text" name="userInputMid" id="userInputMid" required placeholder="반납자ID"> <br><br>

                <label for="userInputMpw">비밀번호</label>
                <input type="password" name="userInputMpw" id="userInputMpw" required placeholder="비밀번호"> <br><br>

                <!-- 기존에 이미 넘어온 mid 값도 함께 전송 -->
                <input type="hidden" name="mid" value="${member.mid}">
                <input type="submit" id="signatureBtn" value="반납자 서명">
            </form>

            <p>관리자 서명 : </p>
            <form id="returnAdminForm" action="checkAdminIdAndPw" method="post" style="display: none;">

                <label for="userInputAdminMid">관리자ID</label>
                <input type="text" name="userInputAdminMid" id="userInputAdminMid" required placeholder="관리자ID">
                <br><br>

                <label for="userInputAdminMpw">비밀번호</label>
                <input type="password" name="userInputAdminMpw" id="userInputAdminMpw" required placeholder="비밀번호">
                <br><br>

                <input type="submit" id="signatureBtnAdmin" value="관리자 서명">
            </form>

            <form id="finalReturnForm" style="display: none;" action="confirmReturnFinal" method="post"
                onsubmit="onSubmitReturnForm()">
                <input type="hidden" name="mid" value="${member.mid}">
                <button type="submit">최종 반납 승인</button>
            </form>

            <!-- 취소 버튼 -->
            <button id="cancelButton">취소</button>

            <script>

                function onSubmitReturnForm() {
                    let html = "";
                    $('#bookStkNumTable > tbody > tr').each(function (index, el) {
                        html += "<input type='hidden' name='returnItems[" + index + "].exConditionId' value='" + $(el).find('[name=exCondition]').val() + "' >";
                        html += "<input type='hidden' name='returnItems[" + index + "].inConditionId' value='" + $(el).find('[name=inCondition]').val() + "' >";
                        html += "<input type='hidden' name='returnItems[" + index + "].bookStkNum' value='" + $(el).find('[name=bookStkNum]').val() + "' >";
                    })
                    html += "<input type='hidden' name='mid' value='${member.mid}'>";
                    html += '<button type="submit">최종 반납 승인</button>';
                    $('#finalReturnForm').html(html);
                }

                document.addEventListener("DOMContentLoaded", function () {

                    var today = new Date();
                    var dd = String(today.getDate()).padStart(2, '0');
                    var mm = String(today.getMonth() + 1).padStart(2, '0'); //1월은 숫자 0부터 시작
                    var yyyy = today.getFullYear();

                    today = yyyy + '-' + mm + '-' + dd;

                    // 포맷된 날짜를 rentalDate 입력 필드에 설정.
                    document.getElementById('finalReturnForm').rentalDate.value = today;

                });
            </script>
            <script>
                function collectBookStkNums() {
                    var bookStkNums = [];
                    $('#bookStkNumTable tbody tr').each(function () {
                        var bookStkNum = parseInt($(this).find('td:first').text());
                        if (!isNaN(bookStkNum)) {
                            bookStkNums.push(bookStkNum);
                        }
                    });
                    return bookStkNums.join(","); // 배열을 쉼표로 구분된 문자열로 변환
                }

                $('#finalReturnForm').on('submit', function () {
                    var bookStkNumsStr = collectBookStkNums();
                    $('input[name="bookStkNums"]').val(bookStkNumsStr); // 쉼표로 구분된 문자열을 input 값으로 설정
                });

                function collectBookNums() {
                    var bookNums = [];
                    $('#bookTableBody tr').each(function () {
                        var bookNum = $(this).find('td:first').text(); // 첫 번째 td 요소에서 도서 번호 추출
                        bookNums.push(bookNum);
                    });
                    return bookNums.join(","); // 배열을 쉼표로 구분된 문자열로 변환
                }

                $('#finalReturnForm').on('submit', function () {
                    var bookNumsStr = collectBookNums();
                    $('input[name="bookNums"]').val(bookNumsStr); // 쉼표로 구분된 문자열을 input 값으로 설정
                });

            </script>

        </body>

        <script>
            var mid = "${mid}";
            $(document).ready(function () {
                $("#cancelButton").click(function () {
                    window.location.href = "returnBookPage"; // rentBookPage에 대한 URL로 이동
                });
                $("#returnForm").submit(function (event) {
                    // 기본 폼 제출 동작을 막습니다.
                    event.preventDefault();

                    // 사용자가 입력한 값을 추출합니다.
                    var userInputMid = $("#userInputMid").val();
                    var userInputMpw = $("#userInputMpw").val();

                    // 기존에 이미 넘어온 mid 값을 추출합니다.
                    var mid = "${member.mid}";

                    // 추출한 값들을 서버로 전송합니다.
                    $.ajax({
                        type: "POST",
                        url: "checkRenterIdAndPw",
                        contentType: 'application/json',
                        data: JSON.stringify({
                            mid: mid,
                            userInputMid: userInputMid,
                            userInputMpw: userInputMpw
                        }),
                        success: function (data) {
                            if (data && data.message) {
                                var message = data.message;
                                // 성공 시 처리
                                if (data.success) {
                                    // 성공적인 응답 처리
                                    console.log(data.message);
                                    Swal.fire({
                                        icon: 'success',
                                        title: '사용자 일치',
                                        text: '사용자 서명 확인',
                                    });
                                    // 사용자 일치 시 입력 창 및 버튼 비활성화
                                    $("#userInputMid, #userInputMpw, #signatureBtn").prop("disabled", true);

                                    $("#returnAdminForm").show();
                                } else {
                                    // 실패 시 처리
                                    console.log(data.message);
                                    Swal.fire({
                                        icon: 'error',
                                        title: '사용자 불일치',
                                        text: '사용자 서명 실패',
                                    });
                                }
                            } else {
                                // 서버 응답이 유효하지 않을 경우 처리
                                console.log("console.log : 사용자 서명 실패.");
                                Swal.fire({
                                    icon: 'error',
                                    title: '사용자 불일치',
                                    text: '사용자 서명 실패',
                                });
                            }
                        },
                        error: function (error) {
                            // 실패 시 처리
                            console.log(error.responseJSON.message);
                            Swal.fire({
                                icon: 'error',
                                title: '사용자 불일치',
                                text: '사용자 서명 실패',
                            });
                        }
                    });
                });


            });


            $(document).ready(function () {

                $("#returnAdminForm").submit(function (event) {

                    event.preventDefault();

                    // 사용자가 입력한 값을 추출
                    var userInputAdminMid = $("#userInputAdminMid").val();
                    var userInputAdminMpw = $("#userInputAdminMpw").val();

                    // 추출한 값들을 서버로 전송합
                    $.ajax({
                        type: "POST",
                        url: "checkAdminIdAndPw",
                        contentType: 'application/json',
                        data: JSON.stringify({
                            userInputAdminMid: userInputAdminMid,
                            userInputAdminMpw: userInputAdminMpw
                        }),
                        success: function (data) {
                            if (data && data.message) {
                                var message = data.message;
                                // 성공 시 처리
                                if (data.success) {
                                    // 성공적인 응답 처리
                                    console.log(data.message);
                                    Swal.fire({
                                        icon: 'success',
                                        title: '관리자 일치',
                                        text: '관리자 서명 확인',
                                    });
                                    // 관리자 일치 시 입력 창 및 버튼 비활성화
                                    $("#userInputAdminMid, #userInputAdminMpw, #signatureBtnAdmin").prop("disabled", true);
                                    //최종 반납 버튼 활성화
                                    $("#finalReturnForm").show();
                                } else {
                                    // 실패 시 처리
                                    console.log(data.message);
                                    Swal.fire({
                                        icon: 'error',
                                        title: '관리자 불일치',
                                        text: '관리자 서명 실패',
                                    });
                                }
                            } else {
                                // 서버 응답이 유효하지 않을 경우 처리
                                console.log("console.log : 관리자 서명 실패.");
                                Swal.fire({
                                    icon: 'error',
                                    title: '관리자 불일치',
                                    text: '관리자 서명 실패',
                                });
                            }
                        },
                        error: function (error) {
                            // 실패 시 처리
                            console.log(error.responseJSON.message);
                            Swal.fire({
                                icon: 'error',
                                title: '관리자 불일치',
                                text: '관리자 서명 실패',
                            });
                        }
                    });
                });
            });



        </script>



        </html>