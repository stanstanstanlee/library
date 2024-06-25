<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>재고 탐색</title>
    <!--jQuery-->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <!-- SweetAlert2 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
    <style>
        table {
            font-family: arial, sans-serif;
            border-collapse: collapse;
            width: 100%;
        }

        td,
        th {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }

        tr:nth-child(even) {
            background-color: #dddddd;
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

        tbody tr {
            cursor: pointer;
        }

        tbody tr:hover {
            background-color: #f5f5f5;
        }
        h1 {
            text-align: right;
        }
    </style>
</head>
<body>

<script type="text/javascript">

</script>
<h1>재고 탐색</h1>

<form action="searchStock" method="post" id="searchForm"  onsubmit="searchStock(event);">
    <label for="searchText">재고 검색: </label>
    <input type="number" id="searchText" name="searchText" placeholder="재고번호" onkeydown="if (event.keyCode == 13) { event.preventDefault(); searchStock(); }" oninput="preventNegative()">
</form>



<button onclick="checkAll()">일괄선택</button>
<button onclick="uncheckAll()">일괄선택취소</button>
<button onclick="disposeAll()">폐기</button>
<table>
    <thead>
        <tr>
            <th>선택</th>
            <th>재고번호</th>
            <th>ISBN</th>
            <th>대여상태</th>
            <th>폐기여부</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="bookStk" items="${bStkList}">

            <tr>
                <td><input type="checkbox" class="bookCheckbox" value="${bookStk.bookNum}" /></td>
                <td>
                    ${bookStk.bookStkNum}</td>
                <td>
                    ${bookStk.bookNum}
                </td>
                <td>
                    ${bookStk.rented}</td>
                <td>
                    ${bookStk.disposed}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<hr>
<button type="button" onclick="cancelAction('${data.bookNum}')">취소</button>
<script>
   function cancelAction(bookNum) {
      location.href = 'bookPage';
   }
   function preventNegative() {
        var searchTextInput = document.getElementById('searchText');
        if (searchTextInput.value < 0) {
            searchTextInput.value = 0;
        }
    }
</script>

</body>
</html>
<script>

    function searchStock() {
    var searchText = document.getElementById('searchText').value;
    var bookNum = "${data.bookNum}";

    // 입력값이 비어있는 경우 전체 재고를 다시 불러오기
    if (searchText.trim() === "") {
        searchText = null; // 빈 문자열을 null로 설정하여 서버에서 처리하도록 함
    }

    $.ajax({
        type: 'POST',
        url: '/searchStock',
        data: {
            bookNum: bookNum,
            searchText: searchText
        },
        success: function(response) {
            updatePage(response);
        },
        error: function(error) {
            console.error('에러 발생: ', error);
        }
    });
    return false;
}
$(document).ready(function() {
    $('#searchText').on('input', function() {
        // 검색어 입력 상자의 값이 변경될 때마다 자동으로 검색 실행
        searchStock();
    });
});
    function updatePage(response) {
        // 받은 JSON 데이터를 이용하여 페이지 업데이트 로직을 작성
        var bStkList = response.bStkList;
        // 예를 들어, 테이블의 tbody를 갱신
        var tbody = document.querySelector('table tbody');
        tbody.innerHTML = '';
    
        for (var i = 0; i < bStkList.length; i++) {
            var row = '<tr>' +
                '<td><input type="checkbox" class="bookCheckbox" value="' + bStkList[i].bookNum + '" /></td>' +
                '<td>' + bStkList[i].bookStkNum + '</td>' +
                '<td>' + bStkList[i].bookNum + '</td>' +
                '<td>' + bStkList[i].rented + '</td>' +
                '<td>' + bStkList[i].disposed + '</td>' +
                '</tr>';
            tbody.innerHTML += row;
        }
    }
    </script>
<script>
    $(document).ready(function() {
    $('#searchText').keydown(function(event) {
        if (event.keyCode == 13) {
            searchStock();
        }
    });
});

   $(document).ready(function() {
       var message = '${message}';
       if(message === 'updateBookSuccess') {
           Swal.fire({
           icon: 'success',
           title: '변경성공',
           text: '도서 정보 변경 성공!',
           });
       }
   })
</script>