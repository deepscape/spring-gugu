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

<!-- 첨부 파일-이미지 원본 미리보기 영역 -->
<div class='bigPictureWrapper'>
    <div class='bigPicture'></div>
</div>

<!-- 첨부 파일 영역 스타일 -->
<style>
    .uploadResult {
        width:100%;
        background-color: gray;
    }
    .uploadResult ul{
        display:flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }
    .uploadResult ul li {
        list-style: none;
        padding: 10px;
        align-content: center;
        text-align: center;
    }
    .uploadResult ul li img{
        width: 100px;
    }
    .uploadResult ul li span {
        color:white;
    }
    .bigPictureWrapper {
        position: absolute;
        display: none;
        justify-content: center;
        align-items: center;
        top:0%;
        width:100%;
        height:100%;
        background-color: gray;
        z-index: 100;
        background:rgba(255,255,255,0.5);
    }
    .bigPicture {
        position: relative;
        display:flex;
        justify-content: center;
        align-items: center;
    }
    .bigPicture img {
        width:600px;
    }
</style>

<!-- 첨부 파일 영역 -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class='uploadResult'>
                    <ul></ul>
                </div>
            </div> <!--  end panel-body -->
        </div><!--  end panel panel-default -->
    </div> <!-- end panel -->
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
            <div class="panel-footer">      <!-- 댓글 페이지 번호 출력 -->
            </div>
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

        /*function showList(page){
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
        }//end showList*/


        function showList(page){
            console.log("show list: " +page);

            replyService.getList({bno:bnoValue,page: page|| 1 }, function(replyCnt, list) {

                console.log("replyCnt: " + replyCnt);
                console.log("list: " + list);
                console.log(list);

                if(page == -1) {
                    pageNum = Math.ceil(replyCnt/10.0);
                    showList(pageNum);
                    return;
                }

                var str="";

                if(list == null || list.length == 0){return;}

                for (var i = 0, len = list.length || 0; i < len; i++) {
                    str +="<li class='left clearfix' data-rno='"+list[i].rno+"'>";
                    str +="  <div><div class='header'><strong class='primary-font'>["+list[i].rno+"] "+list[i].replyer+"</strong>";
                    str +="    <small class='pull-right text-muted'>"+replyService.displayTime(list[i].replyDate)+"</small></div>";
                    str +="    <p>"+list[i].reply+"</p></div></li>";
                }

                replyUL.html(str);

                showReplyPage(replyCnt);        // 댓글 목록을 출력하고 나서, 댓글 페이지를 출력
            });//end function
        }//end showList


        // 댓글 페이지 번호를 출력하는 코드
        var pageNum = 1;
        var replyPageFooter = $(".panel-footer");

        function showReplyPage(replyCnt){
            var endNum = Math.ceil(pageNum / 10.0) * 10;
            var startNum = endNum - 9;
            var prev = startNum != 1;
            var next = false;

            if(endNum * 10 >= replyCnt){ endNum = Math.ceil(replyCnt/10.0); }
            if(endNum * 10 < replyCnt){ next = true; }

            var str = "<ul class='pagination pull-right'>";

            if(prev){ str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>"; }

            for(var i = startNum ; i <= endNum; i++){
                var active = pageNum == i ? "active" : "";
                str+= "<li class='page-item "+active+" '><a class='page-link' href='"+i+"'>"+i+"</a></li>";
            }

            if(next){ str+= "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>"; }

            str += "</ul></div>";

            console.log(str);

            replyPageFooter.html(str);
        }

        // 댓글 페이지 번호 클릭 이벤트 처리
        replyPageFooter.on("click","li a", function(e){
            e.preventDefault();     // 댓글의 페이지 번호는 <a> 태그 내에 존재하므로, 이벤트 처리에서는 <a> 태그의 기본 동작을 제한한다.
            console.log("page click");

            var targetPageNum = $(this).attr("href");

            console.log("targetPageNum: " + targetPageNum);

            pageNum = targetPageNum;
            showList(pageNum);
        });

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

        // 댓글 등록
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

                // showList(1);
                showList(-1);       // 새 댓글을 추가하면, 마지막 페이지를 호출해서 이동시켜야 한다.
            });
        });

        // 댓글 조회 클릭 이벤트 처리
        // event delegation - 동적으로 Ajax 를 통해서 <li>가 만들어지면, 이후에 이벤트를 등록해야 하기 때문에 이벤트 위임 형태로 작성해야 한다.
        // jQuery 는 on()으로 쉽게 처리
        $(".chat").on("click", "li", function(e){
            let rno = $(this).data("rno");
            // console.log(rno);

            replyService.get(rno, function(reply) {
              modalInputReply.val(reply.reply);
              modalInputReplyer.val(reply.replyer);
              modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly","readonly");
              modal.data("rno", reply.rno);

              modal.find("button[id != 'modalCloseBtn']").hide();
              modalModBtn.show();
              modalRemoveBtn.show();

              $(".modal").modal("show");
            });
        })

        // 댓글 수정
        modalModBtn.on("click", function(e){
            var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};

            replyService.update(reply, function(result){
                alert(result);
                modal.modal("hide");
                showList(pageNum);
            });
        });

        // 댓글 삭제
        modalRemoveBtn.on("click", function (e) {
            var rno = modal.data("rno");

            replyService.remove(rno, function (result) {
                alert(result);
                modal.modal("hide");
                showList(pageNum);
            });
        });     // modalRemove end

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

<script>
    $(document).ready(function() {
        (function() {
            var bno = '<c:out value="${board.bno}" />';

            // 서버에서 첨부 파일 목록 로딩
            $.getJSON("/board/getAttachList", {bno: bno}, function(arr){
                console.log(arr);
                var str = "";

                $(arr).each(function(i, attach){
                    //image type
                    if(attach.fileType){
                        var fileCallPath =  encodeURIComponent( attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
                        str += "<img src='/display?fileName="+fileCallPath+"'>";
                        str += "</div></li>";
                    }else{
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
                        str += "<span> "+ attach.fileName+"</span><br/>";
                        str += "<img src='/resources/img/attach.png'></a>";
                        str += "</div></li>";
                    }
                });

                $(".uploadResult ul").html(str);
            });//end getjson
        })();       // end function , 즉시 실행

        // 첨부 파일 클릭 이벤트 처리
        $(".uploadResult").on("click","li", function(e){
            console.log("view image");

            var liObj = $(this);
            var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_" + liObj.data("filename"));

            if(liObj.data("type")){
                showImage(path.replace(new RegExp(/\\/g),"/"));
            }else {     //download
                self.location ="/download?fileName="+path;
            }
        });

        // 첨부 파일-이미지 : 이미지 클릭하면 원본 이미지 표출
        function showImage(fileCallPath){
            alert(fileCallPath);

            $(".bigPictureWrapper").css("display","flex").show();

            $(".bigPicture")
                .html("<img src='/display?fileName="+fileCallPath+"' >")
                .animate({width:'100%', height: '100%'}, 1000);
        }

        // 원본 이미지를 다시 클릭하면 창 닫기
        $(".bigPictureWrapper").on("click", function(e){
            $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
            setTimeout(function(){
                $('.bigPictureWrapper').hide();
            }, 1000);
        });

    })      // end
</script>

<%@include file="../includes/footer.jsp"%>