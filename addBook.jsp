<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>신규 도서 등록</title>
        <!--jQuery-->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
        <!-- SweetAlert2 -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
        <style>
            body {
                font-family: 'Arial', sans-serif;
                background-color: #f4f4f4;
                text-align: center;
                margin: 50px;
            }

            form {
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                width: 300px;
                margin: auto;
            }

            input,
            select {
                margin: 8px 0;
                padding: 8px;
                width: 100%;
                box-sizing: border-box;
            }

            select {
                width: calc(100% - 16px);
            }

            input[type="submit"] {
                background-color: #4CAF50;
                color: #fff;
                border: none;
                padding: 10px;
                cursor: pointer;
                border-radius: 4px;
            }

            button {
                background-color: #ff3333;
                color: #fff;
                border: none;
                padding: 10px;
                cursor: pointer;
                border-radius: 4px;
            }
        </style>
    </head>

    <body>

        <script>
            function validateSpace() {
                var bookTitle = document.getElementById("bookTitle").value.trim();
                var bookAuthor = document.getElementById("bookAuthor").value.trim();
                var isbn = document.getElementById("bookNum").value.trim();

                if (bookTitle === "") {
                    //    alert("공백을 포함할 수 없습니다.");
                    //    return false;
                    Swal.fire({
                        icon: "error",
                        title: "공백",
                        text: "도서제목은 공백일 수 없습니다."
                    });
                    return false;
                }

                if (bookAuthor === "") {
                    //    alert("공백을 포함할 수 없습니다.");
                    //    return false;
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
                // ISBN은 숫자로만 이루어져 있고, 알파벳 X를 포함할 경우 마지막 자리에만 허용되어야 함
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

            function setCurrentDate() {
                var currentDate = new Date().toISOString().slice(0, 10);
                document.getElementById("bookRegisterDate").value = currentDate;
            }

            // Set the registration date on page load
            window.onload = function () {
                setCurrentDate();
            };
        </script>
        <script>
            function limitQuantity(input) {
                // 최소값을 1로 설정
                if (parseInt(input.value, 10) < 1) {
                    input.value = 1;
                }

                // 입력값이 세 자릿수를 넘어가면 제한
                if (input.value.length > 3) {
                    input.value = input.value.slice(0, 3);
                }
            }
        </script>
        <form action="insertBook" method="POST" enctype='multipart/form-data' onsubmit="return validateSpace();">
            <h2>도서 등록</h2>

            <label for="bookNum">ISBN</label>
            <input type="text" name="bookNum" id="bookNum" required> <br>

            <label for="bookTitle">도서 이름</label>
            <input type="text" name="bookTitle" id="bookTitle" required> <br>

            <label for="bookAuthor">도서 저자</label>
            <input type="text" name="bookAuthor" id="bookAuthor" required> <br>

            <label for="bookQty">수량</label>
            <input type="number" id="bookQty" name="bookQty" value="1" required oninput="limitQuantity(this)">

            <label for="bookRegisterDate">도서 등록일</label>
            <input type="text" name="bookRegisterDate" id="bookRegisterDate" readonly> <br>

            <label for="bookImgFile">도서 이미지</label>
            <input type="file" name="bookImgFile" id="bookImgFile" accept="image/gif, image/jpeg, image/png"
                onchange="validateFileType()"> <br>
            <br>

            <input type="submit" value="도서 등록" onclick="setCurrentDate()">
        </form>

        <br> <br>
        <button type="button" onclick="location.href='bookPage'">취소</button>

        <img src="/image/noimage.jpg" alt="기본이미지" id="file-preview"
            style="position: absolute; top: 200px; right: 400px; width:300px; height: 400px;">
    </body>

    </html>

    <script>
        // history.replaceState({},null,null);
        // history.state

        $(document).ready(function () {
            var message = '${message}';
            if (message === 'addBookDuplicate') {
                Swal.fire({
                    icon: 'error',
                    title: '추가실패',
                    text: '해당 저자의 같은 이름의 도서가 이미 등록 되어 있습니다',
                });
            }
            if (message === 'addBookFail') {
                Swal.fire({
                    icon: 'error',
                    title: '추가실패',
                    text: '도서 추가 실패',
                });
            }


            // image preview
            const input = document.getElementById('bookImgFile');
            const previewPhoto = () => {
                const file = input.files;
                if (file) {
                    const fileReader = new FileReader();
                    const preview = document.getElementById('file-preview');
                    fileReader.onload = function (event) {
                        preview.setAttribute('src', event.target.result);
                    }
                    fileReader.readAsDataURL(file[0]);
                }
            }
            input.addEventListener("change", previewPhoto);

        })

        function validateFileType() {
            var fileName = document.getElementById("bookImgFile").value;
            var idxDot = fileName.lastIndexOf(".") + 1;
            var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();

            if (extFile != "jpg" && extFile != "jpeg" && extFile != "png" && extFile != "gif") {
                Swal.fire({
                    icon: 'error',
                    title: '파일 유형 오류',
                    text: 'jpg, jpeg, png, gif 파일만 선택 가능합니다',
                });
                document.getElementById("bookImgFile").value = null;
            }
        }

        // history.replaceState({},null,null);
        // history.state


        $(document).ready(function () {
            if (message === 'addBookSuccess') {
                Swal.fire({
                    icon: 'success',
                    title: '추가 성공',
                    text: '도서 추가 성공!',
                });
            }
            var message = '${message}';
            if (message === 'deleteBookSuccess') {
                Swal.fire({
                    icon: 'success',
                    title: '삭제 성공',
                    text: '도서 삭제 성공!',
                });
            }
        })


    </script>