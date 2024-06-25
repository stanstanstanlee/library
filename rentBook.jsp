<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>책 대여</title>
            <!-- jQuery -->
            <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

            <!-- jQuery UI -->
            <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
            <!-- SweetAlert2 -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

            <script type="text/javascript">

            </script>
            <h3>책 대여</h3>
        </head>

        <body>
            <script type="text/javascript">
                function validateSpace() {
                    // 검색어 입력란의 값을 가져오기
                    var searchText = document.getElementById("searchInput").value.trim();

                    // 검색어가 빈 문자열인지 확인
                    if (searchText === "") {
                        Swal.fire({
                            icon: "error",
                            title: "공백",
                            text: "공백을 검색할 수 없습니다."
                        });
                        return false;
                    }
                    return true;
                }
                function limitQuantity(input) {
                    // 최소값을 1로 설정
                    if (parseInt(input.value, 10) < 1) {
                        input.value = "";
                    }
                    if (input.value.length > 7) {
                        input.value = input.value.slice(0, 7);
                    }
                }
                
            </script>


            <p>${member}님 안녕하세요!</p> <br>


            <!-- 사용자 검색-->
            <form onsubmit="return searchAndDisplayUser();">
                <label for="searchText"></label>
                <input type="text" id="searchText" name="searchText" placeholder="사용자 ID">
                <button type="submit">사용자 확인</button>
            </form>

            <!-- 검색 결과 표시 -->
            <div id="userInfoDiv" style="display: none;">
                <p>사용자아이디: <span id="userIdDisplay"></span></p>
                <p>사용자이름: <span id="userNameDisplay"></span></p>
                <p>사용자권한: <span id="userAuthDisplay"></span></p>
                <p>대여가능최대개수: <span id="userRentCapDisplay"></span></p>
                <p>대여기간: <span id="userRentPeriodDisplay"></span></p>
                <p>현재 대여중인 도서 수: <span id="currentRentalCountDisplay"></span></p>
                <p>남은 대여 가능 수: <span id="remainingRentalCountDisplay"></span></p>
            </div>

            <br>
            <br>
            <br>
            <form id="bookForm" method="post" onsubmit="addBook(); return false;" style="display: none;">
                <br>
                <label for="bookStkNumInput">도서 재고번호 입력:</label>
                <input type="number" id="bookStkNumInput" name="bookStkNumInput" placeholder="도서 재고번호" required
                    oninput="limitQuantity(this)">
                <button type="submit">도서 추가</button>
            </form>
            <br>
            <br>

            <!-- 도서 목록을 표시할 테이블 -->
            <table id="bookTable" style="border: 1px solid black;">
                <thead>
                    <tr>
                        <th>도서 번호</th>
                        <th>재고 번호</th>
                        <th>도서 제목</th>
                        <th>도서 작가</th>
                        <th>등록일</th>
                        <th>도서 빼기</th>
                    </tr>
                </thead>
                <tbody id="bookTableBody">
                </tbody>
            </table>


            <form action="/rentalConfirmationPage" method="post">
                <input type="hidden" name="mid" id="mid" value="{userId}" />
                <input type="hidden" name="bookStkNums" id="bookStkNums" value="{books}" />
                <button type="submit" id="rentalButton" style="display:none" onclick="return confirmRental()">대여
                    확인</button>
            </form>


            <br> <br>
            <a href="menu" class="menu-button">메뉴화면으로 이동하기</a>
            <hr>


            <script>
                function hideUserDisplay() {
                    var userInfoDiv = document.getElementById('userInfoDiv');
                    if (userInfoDiv) {
                        userInfoDiv.style.display = 'none';
                    }
                }
                //전역변수
                var reamainingRentalCountGlobal;
                var currentUser;

                function searchAndDisplayUser() {
                    var userId = document.getElementById('searchText').value;

                    // 이전에 추가한 도서 목록 초기화
                    addedBookStkNums = [];
                    addedBookCount = 0;

                    // 테이블의 내용 지우기
                    var tbody = document.getElementById('bookTableBody');
                    tbody.innerHTML = '';

                    var userId = document.getElementById('searchText').value;
                    // 서버에 사용자 정보 요청
                    $.ajax({
                        type: 'POST',
                        url: '/rentBookGetMemberInfo',
                        contentType: 'application/json',
                        data: JSON.stringify({ "mid": userId }),
                        success: function (response) {
                            // 사용자 정보 업데이트
                            currentUser = response.user;
                            if (currentUser != null) {
                                var message = response.message;
                                if (message === "overdue") {
                                    Swal.fire({
                                        icon: 'error',
                                        title: '해당 사용자는 반납기한을 넘긴 도서가 있습니다',
                                        text: '연체자는 대여할 수 없습니다',
                                    });
                                    return false;  // 도서 대여가 불가능한 경우 함수 종료
                                }


                                // 사용자 정보를 화면에 표시
                                var userIdDisplayElement = document.getElementById('userIdDisplay');
                                var userNameDisplayElement = document.getElementById('userNameDisplay');
                                var userAuthDisplayElement = document.getElementById('userAuthDisplay');
                                var userRentCapDisplayElement = document.getElementById('userRentCapDisplay');
                                var userRentPeriodDisplayElement = document.getElementById('userRentPeriodDisplay');
                                var currentRentalCountDisplayElement = document.getElementById('currentRentalCountDisplay');
                                var remainingRentalCountDisplayElement = document.getElementById('remainingRentalCountDisplay');

                                // 표시되는 div 업데이트
                                if (userIdDisplayElement) userIdDisplayElement.innerText = currentUser.mid;
                                if (userNameDisplayElement) userNameDisplayElement.innerText = currentUser.memberName;
                                if (userAuthDisplayElement) userAuthDisplayElement.innerText = currentUser.auth;
                                if (userRentCapDisplayElement) userRentCapDisplayElement.innerText = currentUser.rentCap;
                                if (userRentPeriodDisplayElement) userRentPeriodDisplayElement.innerText = currentUser.rentPeriod;
                                if (currentRentalCountDisplayElement) currentRentalCountDisplayElement.innerText = currentUser.currentRentalCount;

                                // 남은 대여 가능 수 계산 및 표시
                                var remainingRentalCount = currentUser.rentCap - currentUser.currentRentalCount;
                                if (remainingRentalCountDisplayElement) remainingRentalCountDisplayElement.innerText = remainingRentalCount;
                                if (remainingRentalCountDisplayElement) reamainingRentalCountGlobal = remainingRentalCount;

                                // 표시되는 div와 도서 추가 폼 보이도록 설정
                                var userInfoDiv = document.getElementById('userInfoDiv');
                                var bookForm = document.getElementById('bookForm');
                                userInfoDiv.style.display = 'block';
                                bookForm.style.display = 'block';
                                // 대여 확인 버튼 보이도록 설정
                                var rentalButton = document.getElementById('rentalButton');
                                if (rentalButton) rentalButton.style.display = 'block';
                            } else {

                                // 사용자 정보가 없는 경우 처리
                                Swal.fire({
                                    icon: 'error',
                                    title: '사용자정보없음',
                                    text: '사용자정보를 찾을 수 없습니다. 사용자의 ID를 다시 확인 해 주세요',
                                });
                                hideUserDisplay();
                            }
                        },
                        error: function (error) {
                            console.error('에러 발생: ', error);
                            hideUserDisplay();
                        }
                    });

                    // 폼 전송 방지
                    return false;
                }

                //추가된 도서 재고번호를 저장할 배열 
                var addedBookStkNums = [];
                var addedBookCount = 0;

                function addBook() {
                    if (currentUser != null) {
                        var bookStkNumInput = document.getElementById('bookStkNumInput');
                        var bookStkNum = bookStkNumInput.value;
                        if (bookStkNum.trim() === "") {
                            Swal.fire({
                                icon: 'warning',
                                title: '빈 재고번호',
                                text: '도서 재고번호를 입력해주세요.',
                            });
                            return false;
                        }
                        // 이미 추가된 도서 재고번호인지 확인
                        if (addedBookStkNums.includes(bookStkNum)) {
                            Swal.fire({
                                icon: 'warning',
                                title: '중복된 도서',
                                text: '이미 추가된 도서 재고번호입니다.',
                            });
                            bookStkNumInput.value = '';
                            return false;
                        }
                        if (addedBookCount >= reamainingRentalCountGlobal) {
                            console.log("reamainingRentalCountGlobal" + reamainingRentalCountGlobal);
                            Swal.fire({
                                icon: 'error',
                                title: '최대대여초과',
                                text: '더 이상 도서를 추가할 수 없습니다. 현재 대여 가능 수를 확인해주세요.',
                            });
                            return false;
                        }
                        // 사용자가 입력한 도서의 정보를 서버에 요청하여 가져오기
                        $.ajax({
                            type: 'POST',
                            url: '/rentBookGetBookInfo',
                            contentType: 'application/json',
                            data: JSON.stringify({ "bookStkNum": bookStkNum }),

                            success: function (response) {
                                if (response) {
                                    var bookInfo = response.bookInfo;
                                    var message = response.message;
                                    if (message === "notAvailable") {
                                        Swal.fire({
                                            icon: 'warning',
                                            title: '도서 대여 불가',
                                            text: '이 도서는 현재 대여가 불가능합니다.',
                                        });
                          
                                        return false;  // 도서 대여가 불가능한 경우 함수 종료
                                    }

                                    if (bookInfo != null) {
                                        // 가져온 도서 정보를 화면에 추가
                                        var tbody = document.getElementById('bookTableBody');
                                        var row = '<tr>' +
                                            '<td>' + bookInfo.bookNum + '</td>' +
                                            '<td>' + bookInfo.bookStkNum + '</td>' +
                                            '<td>' + bookInfo.bookTitle + '</td>' +
                                            '<td>' + bookInfo.bookAuthor + '</td>' +
                                            '<td>' + bookInfo.bookRegisterDate + '</td>' +
                                            '<td><button onclick="removeSingleBook(this)">도서빼기</button></td>' +
                                            '</tr>';
                                        tbody.innerHTML += row;

                                        // 이미 추가된 도서 재고번호를 배열에 추가
                                        addedBookStkNums.push(bookStkNum);

                                        // 도서 재고번호 입력 필드를 비워줌
                                        bookStkNumInput.value = '';
                                    }
                                    addedBookCount++;

                                    console.log("addedBookCount : " + addedBookCount);
                                } else {
                                    Swal.fire({
                                        icon: 'error',
                                        title: '도서정보없음',
                                        text: '도서정보를 찾을 수 없습니다. 재고 번호를 다시 확인 해 주세요',
                                    });
                                }
                            },
                            error: function (error) {
                                Swal.fire({
                                    icon: 'error',
                                    title: '도서정보없음',
                                    text: '도서정보를 찾을 수 없습니다. 재고 번호를 다시 확인 해 주세요',
                                });
                            }
                        });
                    } else {
                        // 사용자 정보가 없는 경우 
                        Swal.fire({
                            icon: 'error',
                            title: '사용자정보없음',
                            text: '사용자정보를 추가해주세요',
                        });
                    }
                    return false;
                }

                // 도서빼기 버튼을 클릭했을 때 해당 도서를 화면에서 제거
                function removeSingleBook(button) {
                    var row = $(button).closest('tr');
                    var bookStkNum = row.find("td:nth-child(2)").text();

                    // 도서 재고번호를 배열에서 제거
                    var index = addedBookStkNums.indexOf(bookStkNum);
                    if (index !== -1) {
                        addedBookStkNums.splice(index, 1);

                        // 화면에서 해당 도서 삭제
                        row.remove();
                        addedBookCount--;
                        console.log("addedBookCount : " + addedBookCount);
                        console.log("addedBookStkNums: ", addedBookStkNums);
                    } else {
                        console.log("도서 재고번호가 배열에 존재하지 않습니다.");
                    }
                }

                $(document).ready(function () {
                    var message = '${message}';
                    if (message === 'failedFindingUser') {
                        Swal.fire({
                            icon: 'error',
                            title: '검색 실패',
                            text: '존재하지 않는 사용자 입니다.',
                        });
                    }

                })

                function confirmRental() {
                    // 도서 목록이 비어 있는지 확인
                    if (addedBookStkNums.length === 0) {
                        Swal.fire({
                            icon: 'warning',
                            title: '도서 목록이 비어 있음',
                            text: '대여할 도서를 추가해주세요',
                        });
                        return false; // 폼 제출 취소
                    }

                    if (currentUser != null) {
                        var userId = currentUser.mid;
                        var books = addedBookStkNums;

                        // 폼의 값을 설정
                        document.getElementById("mid").value = userId;
                        document.getElementById("bookStkNums").value = books;

                        return true; // 폼을 계속해서 제출
                    } else {
                        console.log('User information is null');
                        Swal.fire({
                            icon: 'warning',
                            title: '사용자정보없음',
                            text: '사용자 정보를 추가해주세요',
                        });
                        return false; // 폼 제출 취소
                    }
                }

                
            </script>
        </body>

        </html>