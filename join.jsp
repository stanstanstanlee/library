<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>신규 사용자 등록</title>
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
            function validatePassword() {
                var mpw = document.getElementById("mpw").value;
                var confirmMpw = document.getElementById("confirmMpw").value;

                if (/\s/.test(mpw) || /\s/.test(confirmMpw)) {
                    //alert("비밀번호에 공백을 포함할 수 없습니다.");
                    //return false;
                    Swal.fire({
                        icon: "error",
                        title: "공백",
                        text: "비밀번호에 공백을 포함할 수 없습니다."
                    });
                    return false;
                }

                if (mpw !== confirmMpw) {
                    //alert("비밀번호가 일치하지 않습니다.");
                    Swal.fire({
                        icon: "error",
                        title: "불일치",
                        text: "비밀번호와 비밀번호 확인이 일치 하지 않습니다."
                    });
                    return false;
                }
                return true;
            }
            function validateInputs() {
                var userId = document.getElementById("mid").value;
                var userName = document.getElementById("memberName").value;
                
                var userNameRegex = /^[가-힣A-Za-z]+$/;
            
                var userIdRegex = /^[가-힣A-Za-z0-9]+$/;

                if (!userIdRegex.test(userId)) {
                    Swal.fire({
                        icon: "error",
                        title: "잘못된 입력",
                        text: "아이디에는 특수문자를 사용할 수 없습니다."
                    });
                    return false;
                }

                if (!userNameRegex.test(userName)) {
                    Swal.fire({
                        icon: "error",
                        title: "잘못된 입력",
                        text: "사용자 이름에는 특수문자와 숫자를 사용할 수 없습니다."
                    });
                    return false;
                }

                return true;
            }
        </script>

        <form action="signup" method="POST" onsubmit="return validatePassword() && validateInputs();">
            <h2>신규 사용자 등록</h2>
            <label for="mid">사용자 ID</label>
            <input type="text" name="mid" id="mid" required placeholder="ID"> <br><br>

            <label for="mpw">비밀번호</label>
            <input type="password" name="mpw" id="mpw" required placeholder="비밀번호"> <br><br>

            <label for="confirmMpw">비밀번호 확인</label>
            <input type="password" name="confirmMpw" id="confirmMpw" required placeholder="비밀번호 확인"> <br><br>

            <label for="memberName">사용자 이름</label>
            <input type="text" name="memberName" id="memberName" required placeholder="이름"> <br><br>

            <label for="auth">사용자 유형</label>
            <select name="auth" id="auth" required>
                <option value="">--사용자 유형 select--</option>
                <option value="user">일반사용자</option>
                <option value="admin">관리자</option>
            </select>

            <br>

            <input type="submit" value="신규사용자 등록">
        </form>

        <br> <br>
        <button type="button" onclick="location.href='userlistPage'">취소</button>
    </body>
    <script>
        $(document).ready(function () {
            var message = '${message}';
            if (message === 'duplicate') {
                Swal.fire({
                    icon: 'error',
                    title: '사용자등록실패',
                    text: '중복된 아이디 입니다!',
                });
            }
        })
    </script>

    </html>