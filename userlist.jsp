<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>회원목록 페이지</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>

    <style>
.new-user {
    display: inline-block;
    padding: 10px 15px;
    background-color: #4CAF50; /* 초록색 배경 */
    color: white; /* 글자 색상 */
    text-decoration: none;
    border-radius: 4px;
    border: 1px solid #4CAF50; /* 초록색 테두리 */
    font-family: '나눔고딕', sans-serif;
    transition: background-color 0.3s; /* 호버 효과를 부드럽게 만들기 위한 transition 속성 */
}

.new-user:hover {
    background-color: #45a049; /* 호버 시 색상 변경 */
}
        table {
          font-family: arial, sans-serif;
          border-collapse: collapse;
          width: 100%;
        }
        
        td, th {
          border: 1px solid #dddddd;
          text-align: left;
          padding: 8px;
        }
        
        tr:nth-child(even) {
          background-color: #dddddd;
        }
        .hidden-column {
        display: none;
    }
    .menu-button {
        display: inline-block;
        padding: 10px 20px;
        background-color: #f1f1f1;
        color: #333;
        text-decoration: none;
        border-radius: 2px;
        border: 2px solid #333;
        font-family: 'Nanum Gothic', sans-serif; 
        font-weight: bold;
    }

    .menu-button:hover {
        background-color: #ddd;
    }
    /* 사용자검색버튼 */
    form {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }

    label {
        margin-right: 10px;
        font-weight: bold;
    }

    #searchInput {
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
    }

    button {
        padding: 8px 15px;
        background-color: #b68f25;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    button:hover {
        background-color: #756a02;
    }
    </style>

</head>

<body>
    <h3>사용자 관리</h3>
    <p>${member}님 안녕하세요!</p> <br>
    

     <a href="signupPage" class="new-user">신규사용자 등록</a><br><br><br> 
     

    <!-- 사용자 검색-->
    <form action="userlistPage" method="post" >
        <label for="searchInput">사용자 검색:</label>
        <input type="text" id="searchInput" name="searchText" placeholder="사용자 ID 또는 이름">
        <button type="submit">검색/전체조회</button>
    </form>
    <br><br><br> 
    <p>사용자 목록</p>
    
    <table>
        
        <thead>
            <tr>
                <th>사용자 ID</th>
                <th class="hidden-column">비밀번호</th>
                <th>사용자 이름</th>
                <th>권한</th>
            </tr>
        </thead>


        <tbody>
            <!-- <c:forEach var="user" items="${list}">
                <tr>
                    <td><a href ="userDetail?mid=${user.mid}">${user.mid}</a></td>
                    <td class="hidden-column">${user.mpw}</td>
                    <td>${user.memberName}</td>
                    <td>${user.auth}</td>
                </tr>
            </c:forEach> -->
            <c:forEach var="user" items="${list}">
                <tr>
                    <td><a href="userDetail?mid=${user.mid}">${user.mid}</a></td>
                    <td class="hidden-column">${user.mpw}</td>
                    <td>${user.memberName}</td>
                    <td>
                        <c:choose>
                            <c:when test="${user.auth eq 'user'}">일반사용자</c:when>
                            <c:when test="${user.auth eq 'admin'}">관리자</c:when>
                            <c:otherwise>
                                기타<!-- 다른 auth 값이 있을 경우에 대한 예시 -->
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
        <br>
        <a href="menu" class="menu-button">메뉴화면으로이동하기</a>
    </body>
</html>

<script>
    $(document).ready(function() {
        var message = '${message}';
        if(message === 'joined') {
            Swal.fire({
            icon: 'success',
            title: '가입성공',
            text: '신규 사용자 추가 성공!',
            });
        }
        if(message === 'delMemSuccess') {
            Swal.fire({
            icon: 'success',
            title: '삭제성공',
            text: '사용자 삭제 성공!',
            });
        }
    })
</script>