<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@include file="../includes/header.jsp"%>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Read</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Read Page</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="form-group">
                    <label>Bno</label> <input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
                </div>
                <div class="form-group">
                    <label>Title</label> <input class="form-control" name='title' value='<c:out value="${board.title }"/>' readonly="readonly">
                </div>
                <div class="form-group">
                    <label>Text area</label>
                    <textarea class="form-control" rows="3" name='content' readonly="readonly"><c:out value="${board.content}" /></textarea>
                </div>
                <div class="form-group">
                    <label>Writer</label> <input class="form-control" name='writer' value='<c:out value="${board.writer }"/>' readonly="readonly">
                </div>

                <%-- 		<button data-oper='modify' class="btn btn-default">
                        <a href="/board/modify?bno=<c:out value="${board.bno}"/>">Modify</a></button>
                        <button data-oper='list' class="btn btn-info">
                        <a href="/board/list">List</a></button> --%>

                <button data-oper='modify' class="btn btn-default">Modify</button>
                <button data-oper='list' class="btn btn-info">List</button>

<%--                <form id='operForm' action="/board/modify" method="get">
                  <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
                </form> --%>

                <form id='operForm' action="/board/modify" method="get">
                    <input type='hidden' id='bno' name='bno' value='<c:out value="${board.bno}"/>'>
                    <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
                    <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
                    <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>
                    <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
                </form>
            </div>
            <!--  end panel-body -->
        </div>
        <!--  end panel-body -->
    </div>
    <!-- end panel -->
</div>
<!-- /.row -->

<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">

</script>
<script type="text/javascript">     // 댓글 등록
    /*$(document).ready(function() {
        console.log(replyService);
    });*/

    console.log("=================");
    console.log("JS TEST");

    var bnoValue = '<c:out value="${board.bno}"/>';

    //for replyService add test
    /*replyService.add(
        {reply:"JS Test", replyer:"tester", bno:bnoValue},          // reply
        function(result){                                           // callback
            alert("RESULT: " + result);
        }
    );*/

    //for replyService getList test
    /*replyService.getList(
        {bno:bnoValue, page:1},
        function(list) {
            for(var i=0, len=list.length||0; i<len; i++) {
                console.log(list[i]);
            }   // for end
        }   // function end
    );*/

    //for replyService delete test
    /*replyService.remove(5, function (count) {
        console.log(count);
        if (count === "success") {alert("REMOVED");}
    }, function(err) {
        alert('ERROR...');
    });*/

    //for replyService update test
    /*replyService.update(
        {rno:7, bno:bnoValue, reply: "Modified......"},
        function(result) {alert("수정 완료");
    })*/

    //for replyService get test
    replyService.get(7, function (data) {console.log(data);})

</script>
<script type="text/javascript">
    $(document).ready(function() {
        // 조회 페이지 -> 수정-삭제 페이지 링크 처리를 위해 필요한 작업
        var operForm = $("#operForm");

        // 수정 버튼을 클릭하면 bno 값을 같이 전달한다.
        $("button[data-oper='modify']").on("click", function(e){
            operForm.attr("action","/board/modify").submit();
        });

        // 삭제 버튼을 클릭하면, bno 태그를 지우고 리스트 페이지로 이동
        $("button[data-oper='list']").on("click", function(e){
            operForm.find("#bno").remove();
            operForm.attr("action","/board/list")
            operForm.submit();
        });
    });
</script>

<%@include file="../includes/footer.jsp"%>