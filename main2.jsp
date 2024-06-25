<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib tagdir="/WEB-INF/tags" prefix="kim" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <!--jQuery-->
                    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
                        crossorigin="anonymous"></script>
                    <!-- SweetAlert2 -->
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
                    <!-- Bootstrap CSS -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css"
                        rel="stylesheet">

                    <!-- Bootstrap JS (Bundle) -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js"></script>

                    <!-- Bootstrap icons-->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css"
                        rel="stylesheet" type="text/css" />

                    <title>메인페이지</title>
                    <style>
                        body {
                            font-family: 'Arial', sans-serif;
                            background-color: #f2f2f2;
                            text-align: center;
                            margin: 0;
                            padding: 0;
                        }

                        #main-title {
                            font-size: 50px;
                            font-weight: bold;
                            color: #333;
                            font-family: 'Nanum Gothic', sans-serif;
                            /* 나눔고딕 폰트 적용 */
                            margin-top: 50px;
                            margin-bottom: 30px;
                            letter-spacing: 2px;
                            /* 글자 간격 조절 */
                            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
                            /* 텍스트 그림자 추가 */
                        }

                        form {
                            background-color: #fff;
                            border: 1px solid #ddd;
                            padding: 20px;
                            width: 300px;
                            margin: 50px auto;
                            border-radius: 5px;
                            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                        }

                        body {
                            font-family: 'Arial', sans-serif;
                            background-color: #f2f2f2;
                            text-align: center;
                            margin: 0;
                            padding: 0;
                        }

                        form {
                            background-color: #fff;
                            border: 1px solid #ddd;
                            padding: 20px;
                            width: 300px;
                            margin: 50px auto;
                            border-radius: 5px;
                            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                        }

                        input[type="text"],
                        input[type="password"] {
                            width: 100%;
                            padding: 10px;
                            margin: 8px 0;
                            display: inline-block;
                            border: 1px solid #ccc;
                            box-sizing: border-box;
                            border-radius: 4px;
                        }

                        input[type="submit"] {
                            background-color: #4caf50;
                            color: white;
                            padding: 10px 15px;
                            margin: 8px 0;
                            border: none;
                            border-radius: 4px;
                            cursor: pointer;
                        }

                        input[type="submit"]:hover {
                            background-color: #45a049;
                        }
                    </style>
                </head>

                <body>
                    <!-- 제목 추가 -->
                    <div id="main-title">SAEHIM LIBRARY</div>

                    <form action="login" method="post">
                        <h2>로그인</h2>
                        <label for="mid">아이디</label>
                        <input type="text" name="mid" required> <br>
                        <label for="mpw">비밀번호</label>
                        <input type="password" name="mpw" required> <br>
                        <input type="submit" value="로그인">
                    </form>
                    <hr>
                </body>
                <script>
                    $(document).ready(function () {
                        var message = '${message}';
                        if (message === 'incorrect') {
                            Swal.fire({
                                icon: 'error',
                                title: '로그인실패',
                                text: '회원 정보 불일치',
                            });
                        }
                        if (message === 'changePwSuccess') {
                            Swal.fire({
                                icon: 'success',
                                title: '비밀번호 변경 성공',
                                text: '다시 로그인 하세요',
                            });
                        }

                    })
                </script>

                </html>