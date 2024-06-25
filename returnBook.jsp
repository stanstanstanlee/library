<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>책 반납</title>
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
            <h3>책 반납</h3>
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
            <form onsubmit="return searchAndDisplayUserRentalInfo();">
                <label for="searchText"></label>
                <input type="text" id="searchText" name="searchText" placeholder="사용자 ID">
                <button type="submit">사용자 대여정보 확인</button>
            </form>
            <span>대여중 : </span>

            <!-- 검색 결과 표시 -->
            <table id="userRentalInfoTable" style="border: 1px solid black;">
                <thead>
                    <th>
                        <tr>
                            <th>사용자아이디</th>
                            <th>대여번호</th>
                            <th>도서번호</th>
                            <th>재고번호</th>
                            <th>대여일</th>
                            <th>반납 예정일</th>
                        </tr>
                    </th>
                <tbody id="userRentalInfoTableBody">
                </tbody>
                </thead>
            </table>
            <br>
            <br>
            <br>
            <form id="bookForm" method="post" onsubmit="addBook(); return false;" style="display: none;">
                <br>
                <label for="bookStkNumInput">반납 할 도서 재고번호 입력:</label>
                <input type="number" id="bookStkNumInput" name="bookStkNumInput" placeholder="도서 재고번호" required
                    oninput="limitQuantity(this)">
                <button type="submit">반납할 도서 추가</button>
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

            <form action="/returnConfirmationPage" method="post">
                <input type="hidden" name="mid" id="mid" value="{userId}" />
                <input type="hidden" name="bookStkNums" id="bookStkNums" value="{books}" />
                <button type="submit" id="returnButton" style="display:none" onclick="return confirmReturn()">
                    반납확인</button>
            </form>

            <br> <br>
            <a href="menu" class="menu-button">메뉴화면으로 이동하기</a>
            <hr>

            <script>
                //전역변수
                var currentUser;
                var rentedBookStkNums = [];

                function searchAndDisplayUserRentalInfo() {
                    var userId = document.getElementById('searchText').value;

                    // 이전에 추가한 도서 목록 초기화
                    addedBookStkNums = [];
                    addedBookCount = 0;

                    // 테이블의 내용 지우기
                    var tbody = document.getElementById('bookTableBody');
                    tbody.innerHTML = '';

                    // userRentalInfoTable의 내용도 초기화
                    var userRentalInfoTable = document.getElementById('userRentalInfoTable');
                    userRentalInfoTable.style.display = 'none'; // 테이블 숨김

                    var mid = document.getElementById('searchText').value;
                    // 서버에 사용자 정보 요청
                    $.ajax({
                        type: 'POST',
                        url: '/returnBookGetMemberRentalInfo',
                        contentType: 'application/json',
                        data: JSON.stringify({ "mid": mid }),
                        success: function (response) {
                            console.log(response);

                            // 서버로부터 받은 대여 정보 리스트 처리
                            if (response && response.bRentalDTO && response.bRentalDTO.length > 0) {
                                rentedBookStkNums = [];
                                var userRentalInfoTable = document.getElementById('userRentalInfoTable');
                                userRentalInfoTable.style.display = 'block'; // 테이블 표시

                                var tbody = userRentalInfoTable.getElementsByTagName('tbody')[0];
                                tbody.innerHTML = ''; // 테이블 내용 초기화

                                // 각 대여 정보를 테이블에 추가
                                response.bRentalDTO.forEach(function (rentalInfo) {
                                    // 대여한 도서의 재고번호를 배열에 저장
                                    rentedBookStkNums.push(rentalInfo.bookStkNum);
                                    currentUser = rentalInfo.mid;
                                    console.log("currentUser : " + currentUser)
                                    console.log("rentedBookStkNums : " + rentedBookStkNums);
                                    var row = '<tr>' +
                                        '<td>' + rentalInfo.mid + '</td>' +
                                        '<td>' + rentalInfo.rentalNum + '</td>' +
                                        '<td>' + rentalInfo.bookNum + '</td>' +
                                        '<td>' + rentalInfo.bookStkNum + '</td>' +
                                        '<td>' + rentalInfo.rentalDate + '</td>' +
                                        '<td>' + rentalInfo.returnDueDate + '</td>' +
                                        '</tr>';
                                    tbody.innerHTML += row;

                                    // 표시되는 div와 도서 추가 폼 보이도록 설정
                                    var bookForm = document.getElementById('bookForm');
                                    bookForm.style.display = 'block';
                                    // 대여 확인 버튼 보이도록 설정
                                    var returnButton = document.getElementById('returnButton');
                                    if (returnButton) returnButton.style.display = 'block';

                                });
                            } else {
                                // 사용자 정보가 없는 경우 처리
                                console.log("else");
                                Swal.fire({
                                    icon: 'warning',
                                    title: '대여정보없음',
                                    text: '대여정보를 찾을 수 없습니다.',
                                });
                            }
                        },
                        error: function (error) {
                            console.error('에러 발생: ', error);
                        }
                    });

                    // 폼 전송 방지
                    return false;
                }




                //추가된 도서 재고번호를 저장할 배열 
                var addedBookStkNums = [];
                var addedBookCount = 0;
                // 각 요소를 문자열로 변환하여 새 배열 생성



                function addBook() {
                    if (currentUser != null) {
                        var bookStkNumInput = document.getElementById('bookStkNumInput');
                        var bookStkNum = bookStkNumInput.value;
                        console.log("bookStkNum : " + bookStkNum);
                        if (bookStkNum.trim() === "") {
                            Swal.fire({
                                icon: 'warning',
                                title: '빈 재고번호',
                                text: '도서 재고번호를 입력해주세요.',
                            });
                            return false;
                        }
                        rentedBookStkNums = rentedBookStkNums.map(function (item) {
                            return item.toString();
                        });
                        // 대여한 도서의 재고번호와 비교
                        if (!rentedBookStkNums.includes(bookStkNum)) {
                            Swal.fire({
                                icon: 'warning',
                                title: '잘못된 재고번호',
                                text: '입력한 재고번호가 사용자가 대여한 도서의 재고번호가 아닙니다.',
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
                                        icon: 'warning',
                                        title: '도서정보없음',
                                        text: '도서정보를 찾을 수 없습니다. 재고 번호를 다시 확인 해 주세요',
                                    });
                                }
                            },
                            error: function (error) {
                                Swal.fire({
                                    icon: 'warning',
                                    title: '도서정보없음',
                                    text: '도서정보를 찾을 수 없습니다. 재고 번호를 다시 확인 해 주세요',
                                });
                            }
                        });
                    } else {
                        // 사용자 정보가 없는 경우 
                        Swal.fire({
                            icon: 'warning',
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

                function confirmReturn() {
                    // 도서 목록이 비어 있는지 확인
                    if (addedBookStkNums.length === 0) {
                        Swal.fire({
                            icon: 'warning',
                            title: '도서 목록이 비어 있음',
                            text: '반납할 도서를 추가해주세요',
                        });
                        return false; // 폼 제출 취소
                    }

                    if (currentUser != null) {
                        var userId = currentUser;
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
               <script>
                $(document).ready(function () {
                    var message = '${message}';
                    if (message === 'rentalSuccess') {
                        Swal.fire({
                            icon: 'success',
                            title: '대여승인',
                            text: '대여 완료',
                        });
                    }
                })
            </script>
        </body>

        </html>

     