<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
    <title>체크페이지</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
        }

        form {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        p {
            font-size: 18px;
            margin-bottom: 20px;
        }

        input[type="password"] {
            padding: 10px;
            margin-bottom: 20px;
            width: 100%;
            box-sizing: border-box;
        }

        input[type="submit"],
        a.menu-button {
            display: inline-block;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-family: 'Arial', sans-serif;
            transition: background-color 0.3s;
            cursor: pointer;
        }

        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        a.menu-button {
            background-color: #f44336;
            color: white;
            margin-left: 10px;
        }

        a.menu-button:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <form action="mypage" method="post">
        <input type="hidden" name="mid" value="${member}">
        <p>${member}님의 마이페이지로 이동하기 전에</p>
        비밀번호를 다시 입력해 주세요:
        <br>
        <br>
        <input type="password" name="mpw2" required placeholder="비밀번호">
        <br>
        <br>
        <input type="submit" value="확인">
        <a href="menu" class="menu-button">취소</a>
    </form>

    <script>
        $(document).ready(function() {
            var message = '${message}';
            if (message === 'incorrectPw') {
                Swal.fire({
                    icon: 'error',
                    title: '비밀번호 재확인 실패',
                    text: '비밀번호 정보 불일치',
                });
            }
        });
    </script>
</body>
</html>
