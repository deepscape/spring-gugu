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

<div class='row'>
    <div class="col-lg-12">
        <!-- /.panel -->
        <div class="panel panel-default">
            <div class="panel-heading">
                <i class="fa fa-comments fa-fw"></i> Reply
                <button id='addReplyBtn' class='btn btn-primary btn-xs pull-right'>New Reply</button>
            </div>

            <!-- /.panel-heading -->
            <div class="panel-body">
                <ul class="chat">
                    <!-- start reply -->
                    <!-- data-*가 없던 시절 getAttribute()를 사용 / dataset 객체를 통해 data 속성을 가져오기 위해서는 속성 이름의 data- 뒷 부분을 사용 -->
                    <li class="left clearfix" data-rno="12">
                        <div>
                            <div class="header">
                                <strong class="primary-font">user00</strong>
                                <small class="pull-right text-muted">2018-01-01 13:13</small>
                            </div>
                            <p>Good Job!</p>
                        </div>
                    </li>
                    <!-- end reply -->
                </ul>
                <!-- ./ end ul -->
            </div>
            <!-- /.panel .chat-panel -->
        </div>
    </div>
    <!-- ./ end row -->
</div>


<!-- Modal -->
<!-- 모달 창 코드는 SBADMIN2 의 pages 폴더 내 notifications.html 에 포함되어 있음 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label>Reply</label>
                    <input class="form-control" name='reply' value='New Reply!!!!'>
                </div>
                <div class="form-group">
                    <label>Replyer</label>
                    <input class="form-control" name='replyer' value='replyer'>
                </div>
                <div class="form-group">
                    <label>Reply Date</label>
                    <input class="form-control" name='replyDate' value='2018-01-01 13:13'>
                </div>

            </div>
            <div class="modal-footer">
                <button id='modalModBtn' type="button" class="btn btn-warning">Modify</button>
                <button id='modalRemoveBtn' type="button" class="btn btn-danger">Remove</button>
                <button id='modalRegisterBtn' type="button" class="btn btn-primary">Register</button>
                <button id='modalCloseBtn' type="button" class="btn btn-default">Close</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- /.modal -->


<script type="text/javascript" src="/resources/js/reply.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var bnoValue = '<c:out value="${board.bno}"/>';
        var replyUL = $(".chat");

        showList(1);

        function showList(page){
            replyService.getList({bno:bnoValue,page: page|| 1 }, function(list) {
                var str="";
                if(list == null || list.length == 0){
                    replyUL.html("");
                    return;
                }

                for (var i = 0, len = list.length || 0; i < len; i++) {
                    str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                    str +="  <div><div class='header'><strong class='primary-font'>["+list[i].rno+"] "+list[i].replyer+"</strong>";
                    str +="    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
                    str +="    <p>"+list[i].reply+"</p></div></li>";
                }

                replyUL.html(str);
            });//end function
        }//end showList

        <!-- reply modal control -->
        var modal = $(".modal");
        var modalInputReply = modal.find("input[name='reply']");
        var modalInputReplyer = modal.find("input[name='replyer']");
        var modalInputReplyDate = modal.find("input[name='replyDate']");

        var modalModBtn = $("#modalModBtn");
        var modalRemoveBtn = $("#modalRemoveBtn");
        var modalRegisterBtn = $("#modalRegisterBtn");

        $("#modalCloseBtn").on("click", function(e){
            modal.modal('hide');
        });

        $("#addReplyBtn").on("click", function(e){
            modal.find("input").val("");
            modalInputReplyDate.closest("div").hide();
            modal.find("button[id !='modalCloseBtn']").hide();
            modalRegisterBtn.show();
            $(".modal").modal("show");
        });

        modalRegisterBtn.on("click",function(e){
            var reply = {
                reply: modalInputReply.val(),
                replyer:modalInputReplyer.val(),
                bno:bnoValue
            };

            replyService.add(reply, function(result){
                alert(result);

                modal.find("input").val("");
                modal.modal("hide");

                showList(1);
            });
        });

    });
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
    /*replyService.get(7, function (data) {console.log(data);})*/

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