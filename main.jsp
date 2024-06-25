<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib tagdir="/WEB-INF/tags" prefix="kim" %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <script src="https://cdn.tailwindcss.com"></script>
                    <meta charset="UTF-8">
                    <script>
                        tailwind.config = {
                            theme: {
                                extend: {
                                    colors: {
                                        clifford: '#da373d',
                                    }
                                }
                            }
                        }
                    </script>
                    <!--jQuery-->
                    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo="
                        crossorigin="anonymous"></script>
                    <!-- SweetAlert2 -->
                    <link rel="stylesheet"
                        href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>


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

                            margin-top: 50px;
                            margin-bottom: 30px;
                            letter-spacing: 2px;

                            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);

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

                        @keyframes bling-bling {

                            0%,
                            100% {
                                text-shadow: 0 0 10px rgba(255, 255, 255, 0.8),
                                    0 0 20px rgba(255, 255, 255, 0.5),
                                    0 0 30px rgba(255, 255, 255, 0.3);
                            }

                            50% {
                                text-shadow: 0 0 20px rgba(255, 255, 255, 0.8),
                                    0 0 30px rgba(255, 255, 255, 0.5),
                                    0 0 40px rgba(255, 255, 255, 0.3);
                            }
                        }

                        .bling:hover {
                            animation: bling-bling infinite 2s;
                            /* Change 'infinite' to the number of seconds you want the animation to last */
                        }
                        
                    </style>
                </head>

                <body>


                    <div class="flex h-screen w-full flex-col items-center justify-center bg-white">
                        <h1
                            class="text-6xl font-bold text-white tracking-wide uppercase bg-gradient-to-r from-indigo-900 to-green-500 text-white p-4 rounded-md shadow-lg italic transform skew-x-6 hover:transform hover:scale-110 transition-transform duration-300 bling">
                            SAEHIM LIBRARY
                        </h1>


                        <form class="mt-8 flex w-1/4 flex-col space-y-4" action="login" method="post">
                            <label for="mid" class="text-sm font-medium"></label>
                            <input type="text" name="mid"
                                class="flex h-10 w-full bg-background text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 border-2 border-gray-200 rounded-md p-2"
                                placeholder="아이디" required />

                            <label for="mpw" class="text-sm font-medium"></label>
                            <input type="password" name="mpw"
                                class="flex h-10 w-full bg-background text-sm ring-offset-background file:border-0 file:bg-transparent file:text-sm file:font-medium placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 border-2 border-gray-200 rounded-md p-2"
                                placeholder="비밀번호" required />

                            <!-- 로그인 버튼 -->
                            <input type="submit" value="로그인"
                                class="inline-flex items-center justify-center rounded-md text-sm font-medium ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 bg-gradient-to-r from-indigo-900 to-green-500 h-10 px-4 py-2 text-white hover:from-blue-400 hover:via-green-500 hover:to-blue-500 transition-all duration-500" />
                        </form>
                    </div>

                    <hr>
                </body>
                <script>
                    $(document).ready(function () {
                        var message = '${message}';
                        if (message === 'incorrectId') {
                            Swal.fire({
                                icon: 'error',
                                title: '로그인실패',
                                text: '등록되지 않은 사용자입니다',
                            });
                        }
                        if (message === 'incorrectPw') {
                            Swal.fire({
                                icon: 'error',
                                title: '로그인실패',
                                text: '잘못된 비밀번호 입니다 ',
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