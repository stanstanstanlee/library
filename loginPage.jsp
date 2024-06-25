
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="kim" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인페이지</title>
<style>
    @import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap');
    .container {
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: flex-start;
    }

    .greeting,
    .permission,
    .mypage-link {
        margin-right: 10px;
    }

    .greeting {
        font-size: 16px;
        color: #333;
        font-weight: bold;
    }

    .permission {
        font-size: 16px;
        color: #333;
    }

    .mypage-link {
    display: inline-block;
    padding: 10px 15px;
    background-color: #2196F3; 
    color: white; 
    text-decoration: none;
    border-radius: 4px;
    font-family: '나눔고딕', sans-serif;
    transition: background-color 0.3s; 
    }
.mypage-link:hover {
    background-color: #0b7dda; 
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
        margin-right: 10px; 
        font-weight: bold;
    }
  
      a.logout-link {
          background-color: #f44336;
          color: white;
          padding: 10px 20px;
          text-decoration: none;
          display: inline-block;
          border-radius: 4px;
        }

        a.logout-link:hover {
          background-color: #d32f2f;
        }
        .link-margin {
         margin-right: 70px; 
        }
        .container {
        display: flex;
        flex-direction: row;
        align-items: center;
        justify-content: flex-end; 
    }
 
    .menu-container {
        display: flex;
        width: 100%;
        justify-content: space-between;
    }

</style>
</head>
<body>
    <p>SAEHIM LIBRARY</p>
    <div class="container">
        
        <p class="greeting">${member}님 안녕하세요!</p>
        <p class="permission">권한: ${auth}</p>
        <a href="check?mid=${member}" class="mypage-link link-margin">마이페이지</a>
        <a href="logout" class="logout-link">로그아웃</a>

    </div>
    <br>
    <br>
     <!-- 권한이 "admin"인 경우에만  관리 메뉴를 표시 -->
     <c:if test="${auth eq 'admin'}">
        <div class="menu-container">
            <a href="userlistPage" class="menu-button">사용자관리</a>
            <a href="bookPage" class="menu-button">책정보관리</a>
            <a href="rentBookPage" class="menu-button">책 대여</a>
            <a href="returnBookPage" class="menu-button">책 반납</a>
            <a href="goToOverdueBooksPage" class="menu-button">책 연체 관리</a>
            <a href="rentalAndReturnSearchPage" class="menu-button">책 대여 및 반납 이력관리</a>
            <a href="gotoReturnConditionSettingDetailPage" class="menu-button">반납 점검이력관리</a>
        </div>
    </c:if>
    
    <br>
    <br>
    <br>
    <br>
    
<hr>

<br>


</body>
</html>

