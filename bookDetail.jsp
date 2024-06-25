<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>책 상세</title>
            <!--jQuery-->
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
            <!-- SweetAlert2 -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>


            <style>
                h1 {
                    text-align: right;
                }
            </style>
        </head>

        <body>

            <script type="text/javascript">
                function del() {
                    Swal.fire({
                        title: "${data.bookNum}번 책, \"${data.bookTitle}\"을(를) 정말 삭제 하시겠습니까?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.href = "deleteBook?bookNum=${data.bookNum}";
                        }
                    });
                }

                function validateSpace() {
                    var bookTitle = document.getElementById("bookTitle").value.trim();
                    var bookAuthor = document.getElementById("bookAuthor").value.trim();
                    if (bookTitle === "") {
                        Swal.fire({
                            icon: "error",
                            title: "공백",
                            text: "도서제목은 공백일 수 없습니다."
                        });
                        return false;
                    }
                    else if (bookAuthor === "") {

                        Swal.fire({
                            icon: "error",
                            title: "공백",
                            text: "도서 저자는 공백일 수 없습니다."
                        });
                        return false;
                    }
                    if (bookTitle.trim() !== document.getElementById("bookTitle").value) {
                        Swal.fire({
                            icon: "error",
                            title: "공백",
                            text: "공백으로 시작 할 수 없습니다."
                        });
                        return false;
                    }
                    if (bookAuthor.trim() !== document.getElementById("bookAuthor").value) {
                        Swal.fire({
                            icon: "error",
                            title: "공백",
                            text: "공백으로 시작 할 수 없습니다."
                        });
                        return false;
                    }
                    if (!/^\d+(?:[Xx])?$/.test(isbn)) {
                        Swal.fire({
                            icon: "error",
                            title: "ISBN 형식 오류",
                            text: "ISBN은 숫자로 이루어져야 하며, 유일하게 허용되는 문자 X는 만약 포함되어야 한다면 마지막 자리에만 허용됩니다."
                        });
                        return false;
                    }
                    return true;
                }
            </script>
            <h1>도서 상세</h1>
            <c:if test="${empty data}">
                <h1>존재 하지 않는 도서</h1>
            </c:if>
            <c:if test="${not empty data}">
                <form action="updateBook" method="POST" enctype='multipart/form-data'
                    onsubmit="return validateSpace();">

                    <input type="hidden" name="bookNum" value="${data.bookNum}">

                    ISBN : <span id="bookNum">${data.bookNum}</span><br><br>

                    도서제목 : <input type="text" name="bookTitle" id="bookTitle" required value="${data.bookTitle}">
                    <br><br>

                    도서저자 : <input type="text" name="bookAuthor" id="bookAuthor" required value="${data.bookAuthor}">
                    <br><br>

                    재고 : <span id="bookQty">${data.bookQty}</span>
                    <button type="button" onclick="navigateToStockDetails('${data.bookNum}')"> 재고상세</button><br><br>

                    도서등록일 : <span>${data.bookRegisterDate}</span> <br><br>

                    <label for="bookImgFile">도서 이미지 : </label>
                    <input type="file" name="bookImgFile" id="bookImgFile" onchange="displayImage(this)"> <br><br>

                    <c:choose>
                        <c:when test="${not empty data.bookImg}">
                            <img id="bookImagePreview" src="/display?fileName=${data.bookImg}" alt="도서 이미지"
                                style="position: absolute; top: 50px; right: 1200px; width:300px; height: 400px;"><br><br>
                        </c:when>
                        <c:otherwise>
                            <!-- 기본 이미지 -->
                            <img id="bookImagePreview" src="/display?fileName=noImage.jpg" alt="기본 이미지"
                                style="position: absolute; top: 50px; right: 1200px; width:300px; height: 400px;"><br><br>
                        </c:otherwise>
                    </c:choose>

                    <br><br>


                    <input type="submit" value="도서수정">&nbsp;&nbsp;&nbsp;<input type="button" onclick="del()"
                        value="도서 삭제">

                </form>
            </c:if>
            <hr>
            <button type="button" onclick="location.href='bookPage'"> 취소 </button>

        </body>

        </html>

        <script>
            function navigateToStockDetails(bookNum) {
                var url = 'stockDetail?bookNum=' + bookNum;
                window.location.href = url;
            }
        </script>
        <script>
            function displayImage(input) {
                var preview = document.getElementById('bookImagePreview');
                var file = input.files[0];
                var reader = new FileReader();

                // 허용 가능한 파일 확장자 목록
                var allowedExtensions = ['jpg', 'jpeg', 'png', 'gif'];

                // 파일의 확장자 확인
                var fileName = file.name;
                var idxDot = fileName.lastIndexOf(".") + 1;
                var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();

                // 허용 가능한 확장자인지 확인
                if (allowedExtensions.indexOf(extFile) === -1) {
                    Swal.fire({
                        icon: 'error',
                        title: '파일 유형 오류',
                        text: 'jpg, jpeg, png, gif 파일만 선택 가능합니다',
                    });

                    // 파일 인풋 초기화
                    input.value = null;

                    return; // 미리보기 초기화를 건너뛰기 위해 추가
                }

                reader.onloadend = function () {
                    preview.src = reader.result;
                }

                if (file) {
                    reader.readAsDataURL(file);
                } else {
                    preview.src = "";
                }
            }
            $(document).ready(function () {
                var message = '${message}';
                if (message === 'updateBookSuccess') {
                    Swal.fire({
                        icon: 'success',
                        title: '변경성공',
                        text: '도서 정보 변경 성공!',
                    });
                }
                if (message === 'updateBookFail') {
                    Swal.fire({
                        icon: 'error',
                        title: '변경실패',
                        text: '도서 정보 변경 실패',
                    });
                }
                if (message === 'updateBookFailDuplicate') {
                    Swal.fire({
                        icon: 'error',
                        title: '변경실패',
                        text: '해당 저자의 같은 이름의 도서가 이미 등록 되어 있습니다',
                    });
                }
                if (message === 'deleteBookFail') {
                    Swal.fire({
                        icon: 'error',
                        title: '삭제실패',
                        text: '도서 정보 삭제 실패 ',
                    });
                }
                if (message === 'deleteStkFail') {
                    Swal.fire({
                        icon: 'error',
                        title: '삭제실패',
                        text: '재고 정보 삭제 실패 ',
                    });
                }

            })
        </script>