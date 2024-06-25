<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>상세페이지</title>
            <!--jQuery-->
            <script src="https://code.jquery.com/jquery-3.7.1.min.js"
                integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
            <!-- SweetAlert2 -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

        </head>

        <body>

            <script type="text/javascript">
                function del() {
                    // var ans=confirm("${data.mid} 사용자를 정말 삭제하시겠습니까?");
                    // if(ans){
                    //    location.href="deleteMember?mid=${data.mid}";
                    // }
                    Swal.fire({
                        title: "${data.mid} 님의 계정을 정말 삭제 하시겠습니까?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '삭제',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.href = "deleteMember?mid=${data.mid}";
                        }
                    });
                }

            </script>
            <script type="text/javascript">
                function resetPw() {
                    // var ans=confirm("${data.mid} 님의 비밀번호를 초기화 하시겠습니끼?");
                    // if(ans){
                    //    location.href="resetPw?mid=${data.mid}";
                    // }
                    Swal.fire({
                        title: "${data.mid} 님의 비밀번호를 초기화 하시겠습니까?",
                        icon: 'warning',
                        showCancelButton: true,
                        confirmButtonColor: '#3085d6',
                        cancelButtonColor: '#d33',
                        confirmButtonText: '초기화',
                        cancelButtonText: '취소'
                    }).then((result) => {
                        if (result.isConfirmed) {
                            location.href = "resetPw?mid=${data.mid}";
                        }
                    });
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

            <c:if test="${empty data}">
                <h1>해당 사용자는 존재 하지 않습니다.</h1>
            </c:if>
            <c:if test="${not empty data}">
                <form action="updateMemberNew" method="post" onsubmit="return validateInputs();">
                    사용자ID <input type="text" name="mid" id="mid" value="${data.mid}" readonly> <br>
                    사용자 이름 <input type="text" name="memberName" id="memberName" value="${data.memberName}"> <br><br>

                    <div>
                        사용자권한:
                        <!-- <select name="auth">
         <option value="user" <c:if test ="${data.auth eq 'user'}">selected="selected"</c:if> >일반사용자</option>
         <option value="admin" <c:if test ="${data.auth eq 'admin'}">selected="selected"</c:if> >관리자</option>
      </select> -->
                        <select name="auth">
                            <c:choose>
                                <c:when test="${data.auth eq 'user'}">
                                    <option value="user" selected>일반사용자</option>
                                    <option value="admin">관리자</option>
                                    <option value="overdue"> 연체자</option>
                                </c:when>
                                <c:when test="${data.auth eq 'admin'}">
                                    <option value="user">일반사용자</option>
                                    <option value="admin" selected>관리자</option>
                                    <option value="overdue"> 연체자</option>
                                </c:when>
                                <c:when test="${data.auth eq 'overdue'}">
                                    <option value="user">일반사용자</option>
                                    <option value="admin">관리자</option>
                                    <option value="overdue" selected> 연체자</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="user">일반사용자</option>
                                    <option value="admin">관리자</option>
                                    <option value="overdue">연체자</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </div>
                    <div>대여가능권수: <span>${data.rentCap}</span></div>
                    <div>대여가능일수: <span>${data.rentPeriod}</span></div>
                    <input type="submit" value="사용자 수정">
                    <!-- <input type="button" onclick="del()" value="사용자 삭제"> -->
                    <c:if
                        test="${not empty data and not empty sessionScope.member and sessionScope.member ne data.mid}">
                        <input type="button" onclick="del()" value="사용자 삭제">
                    </c:if>
                    <input type="button" onclick="resetPw()" value="비밀번호 초기화">
                </form>
            </c:if>
            <hr>

            <br><br><br><br><br>
            <button type="button" onclick="location.href='userlistPage'"> 취소</button>

        </body>

        </html>

        <script>
            $(document).ready(function () {
                var message = '${message}';
                if (message === 'changedMember') {
                    Swal.fire({
                        icon: 'success',
                        title: '변경성공',
                        text: '사용자 변경 성공!',
                    });
                }

                if (message === 'memberChangeFail') {
                    Swal.fire({
                        icon: 'error',
                        title: '변경실패',
                        text: '사용자 변경 실패',
                    });
                }

                if (message === 'delMemFail') {
                    Swal.fire({
                        icon: 'error',
                        title: '삭제실패',
                        text: '사용자 삭제 실패',
                    });
                }
                if (message === 'resetPwSuccess') {
                    Swal.fire({
                        icon: 'success',
                        title: '리셋성공',
                        text: '사용자 비밀번호 초기화 성공!',
                    });
                }
                if (message === 'resetPwFail') {
                    Swal.fire({
                        icon: 'error',
                        title: '리셋실패',
                        text: '사용자 비밀번호 초기화 실패',
                    });
                }
            })
        </script>