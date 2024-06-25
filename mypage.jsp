<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
   <!DOCTYPE html>
   <html>

   <head>
      <meta charset="UTF-8">
      <!--jQuery-->
      <script src="https://code.jquery.com/jquery-3.7.1.min.js"
         integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
      <!-- SweetAlert2 -->
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
      <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
      <title>마이페이지</title>
      <style>
         .menu-button {
            display: inline-block;
            padding: 5px 10px;
            background-color: #f1f1f1;
            color: #333;
            text-decoration: none;
            border-radius: 1px;
            border: 1px solid #333;
            font-family: 'Nanum Gothic', sans-serif;
            font-weight: bold;
         }

         .red-btn {
            background-color: #d33 !important;
            /* Set your preferred red color */
            color: #fff !important;
         }
      </style>
   </head>

   <body>

      <script type="text/javascript">
         function del() {
            // var ans=confirm("정말 회원탈퇴를 진행하시겠습니까?");
            // if(ans){
            //    location.href="deleteMemberSelf?mid=${member}";
            // }
            Swal.fire({
               title: "정말 회원탈퇴를 진행 하시겠습니까?",
               icon: "warning",
               showCancelButton: true,
               confirmButtonText: "확인",
               cancelButtonText: "취소",
               customClass: {
                  cancelButton: 'red-btn' // Add your custom class name for the cancel button
               }
            }).then((result) => {
               if (result.isConfirmed) {
                  location.href = "deleteMemberSelf?mid=${member}";
               }
            });
         }

         function validatePassword() {
            var newPassword = document.getElementById("newPassword").value;
            var confirmPassword = document.getElementById("confirmPassword").value;

            // if (/\s/.test(newPassword) || /\s/.test(confirmPassword)) {
            //    alert("비밀번호에 공백을 포함할 수 없습니다.");
            //    return false;
            // }

            // if (newPassword !== confirmPassword) {
            //    alert("새로운 비밀번호와 확인 비밀번호가 일치하지 않습니다.");
            //    return false;
            // }
            if (/\s/.test(newPassword) || /\s/.test(confirmPassword)) {
               Swal.fire({
                  icon: "error",
                  title: "공백",
                  text: "비밀번호에 공백을 포함할 수 없습니다."
               });
               return false;
            }

            if (newPassword !== confirmPassword) {
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
      <c:if test="${not empty member}">
         <p>${member}님의 마이페이지!</p>
         </if>
         <form action="updateMember" method="post" onsubmit="return validatePassword() && validateInputs();">
            아이디 <input type="text" name="mid" id="mid"value="${data.mid}" disabled> <br>
            이름 <input type="text" name="name" id="memberName" value="${data.memberName}" disabled> <br>
            <!-- 새로운 비밀번호 입력 : <input type="password" name="mpw" required> <br> -->

            새로운 비밀번호 입력 : <input type="password" name="mpw" id="newPassword" required placeholder="새로운 비밀번호"> <br>
            새로운 비밀번호 다시 입력 : <input type="password" id="confirmPassword" required placeholder="새로운 비밀번호 재입력"> <br>
            <input type="submit" value="비밀번호변경">&nbsp;&nbsp;&nbsp;<input type="button" onclick="del()" value="회원탈퇴">
         </form>
         <hr>

         <a href="menu" class="menu-button">취소</a>
   </body>

   </html>
   <script>
      $(document).ready(function () {
         var message = '${message}';
         if (message === 'delMemSuccess') {
            Swal.fire({
               icon: 'success',
               title: '삭제성공',
               text: '사용자 삭제 성공!',
            });
         }
         if (message === 'changePwFail') {
            Swal.fire({
               icon: 'success',
               title: '변경실패',
               text: '비밀번호 변경 실패',
            });
         }

      })
   </script>