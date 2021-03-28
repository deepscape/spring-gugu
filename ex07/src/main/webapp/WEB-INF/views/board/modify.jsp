<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp"%>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Modify</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">

            <div class="panel-heading">Board Modify</div>
            <!-- /.panel-heading -->
            <div class="panel-body">

                <form role="form" action="/board/modify" method="post">
                    <!-- CSRF token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <input type='hidden' name='pageNum' value='<c:out value="${cri.pageNum}"/>'>
                    <input type='hidden' name='amount' value='<c:out value="${cri.amount}"/>'>
                    <input type='hidden' name='type' value='<c:out value="${cri.type}"/>'>
                    <input type='hidden' name='keyword' value='<c:out value="${cri.keyword}"/>'>

                    <div class="form-group">
                        <label>Bno</label>
                        <input class="form-control" name='bno' value='<c:out value="${board.bno}"/>' readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Title</label>
                        <input class="form-control" name='title' value='<c:out value="${board.title}"/>' >
                    </div>

                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content' ><c:out value="${board.content}"/></textarea>
                    </div>

                    <div class="form-group">
                        <label>Writer</label>
                        <input class="form-control" name='writer' value='<c:out value="${board.writer}"/>' readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>RegDate</label>
                        <!-- 등록일과 수정일은 BoardVO 로 수집되어야 하므로 날짜 포맷을 맞춰야 한다. -->
                        <input class="form-control" name='regDate' value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.regdate}" />' readonly="readonly">
                    </div>

                    <div class="form-group">
                        <label>Update Date</label>
                        <input class="form-control" name='updateDate' value='<fmt:formatDate pattern = "yyyy/MM/dd" value = "${board.updateDate}" />' readonly="readonly">
                    </div>

                    <sec:authentication property="principal" var="pinfo" />
                    <sec:authorize access="isAuthenticated()" >     <!-- 인증된 사용자만 -->
                        <c:if test="${pinfo.username eq board.writer}">     <!-- 본인만 수정 가능 -->
                            <button type="submit" data-oper='modify' class="btn btn-default">Modify</button>
                            <button type="submit" data-oper='remove' class="btn btn-danger">Remove</button>
                        </c:if>
                    </sec:authorize>
                    <button type="submit" data-oper='list' class="btn btn-info">List</button>
                </form>
            </div> <!--  end panel-body -->
        </div> <!-- panel panel-default -->
    </div> <!-- end panel -->
</div>
<!-- /.row -->

<!-- 첨부 파일-원본 이미지 표출 영역 -->
<div class='bigPictureWrapper'>
    <div class='bigPicture'></div>
</div>

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

<!-- 첨부 파일 표출 영역 -->
<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Files</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <!-- 수정 화면에서는 첨부 파일을 등록하는 버튼이 필요 -->
                    <input type="file" name='uploadFile' multiple="multiple">
                </div>
                <div class='uploadResult'>
                    <ul></ul>
                </div>
            </div>  <!--  end panel-body -->
        </div>  <!--  end panel panel-default -->
    </div> <!-- end panel -->
</div>
<!-- /.row -->


<script type="text/javascript">
    $(document).ready(function() {
        var formObj = $("form");

        $('button').on("click", function(e){
            // <form> 태그의 모든 버튼은 기본적으로 submit 으로 처리하기 때문에 e.preventDefault(); 로 기본 동작을 막고 마지막에 직접 formObj.submit(); 수행
            e.preventDefault();

            var operation = $(this).data("oper");
            console.log(operation);

            if(operation === 'remove'){
                formObj.attr("action", "/board/remove");
            } else if(operation === 'list'){
                //move to list
                formObj.attr("action", "/board/list").attr("method","get");

                var pageNumTag = $("input[name='pageNum']").clone();
                var amountTag = $("input[name='amount']").clone();
                var keywordTag = $("input[name='keyword']").clone();
                var typeTag = $("input[name='type']").clone();

                // /board/list 로의 이동은 아무런 파라미터가 없기 때문에 <form> 태그의 모든 내용은 삭제한 상태에서 formObj.submit(); 진행
                formObj.empty();

                formObj.append(pageNumTag);
                formObj.append(amountTag);
                formObj.append(keywordTag);
                formObj.append(typeTag);
            } else if(operation === 'modify'){
                console.log("submit clicked");
                var str = "";

                $(".uploadResult ul li").each(function(i, obj){
                    var jobj = $(obj);
                    console.dir(jobj);

                    str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                    str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
                });

                // 게시물 수정 버튼을 최종 클릭하면, 파일을 삭제할 수 있도록 hidden 정보를 서버에 제공
                formObj.append(str).submit();
            }

            formObj.submit();
        });

    });
</script>

<!-- 첨부 파일 처리 영역 -->
<script>
    $(document).ready(function() {
        (function(){
            var bno = '<c:out value="${board.bno}"/>';

            $.getJSON("/board/getAttachList", {bno: bno}, function(arr){
                console.log(arr);
                var str = "";

                $(arr).each(function(i, attach){
                    //image type    , 첨부 파일의 삭제가 가능하도록 처리
                    if(attach.fileType){
                        var fileCallPath =  encodeURIComponent(attach.uploadPath+ "/s_"+attach.uuid +"_"+attach.fileName);
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
                        str +=" data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
                        str += "<span> "+ attach.fileName+"</span>";
                        str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' ";
                        str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src='/display?fileName="+fileCallPath+"'>";
                        str += "</div></li>";
                    }else{
                        str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' ";
                        str += "data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' ><div>";
                        str += "<span> "+ attach.fileName+"</span><br/>";
                        str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
                        str += " class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                        str += "<img src='/resources/img/attach.png'></a>";
                        str += "</div></li>";
                    }
                });

                $(".uploadResult ul").html(str);
            });//end getjson
        })();//end function

        // 사용자가 파일을 삭제한 상태에서, 게시물을 수정하지 않고 빠져 나갔을 때를 대비 : 최종 컨펌 전까지는 파일 삭제를 하지 않음
        $(".uploadResult").on("click", "button", function(e){
            console.log("delete file");

            if(confirm("Remove this file? ")){
                var targetLi = $(this).closest("li");
                targetLi.remove();
            }
        });

        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        var maxSize = 5242880; //5MB

        function checkExtension(fileName, fileSize){
            if(fileSize >= maxSize){ alert("파일 사이즈 초과"); return false; }
            if(regex.test(fileName)){ alert("해당 종류의 파일은 업로드할 수 없습니다."); return false; }
            return true;
        }

        // 첨부 파일 서버에 전송
        var csrfHeaderName = "${_csrf.headerName}";
        var csrfTokenValue = "${_csrf.token}";

        $("input[type='file']").change(function(e){
            var formData = new FormData();
            var inputFile = $("input[name='uploadFile']");
            var files = inputFile[0].files;

            for(var i = 0; i < files.length; i++){
                if(!checkExtension(files[i].name, files[i].size) ){ return false; }
                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url: '/uploadAjaxAction',
                processData: false,
                contentType: false,
                beforeSend: function(xhr) { xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); },  // CSRF 토큰 전송
                data:formData,
                type: 'POST',
                dataType:'json',
                success: function(result){
                    console.log(result);
                    showUploadResult(result); //업로드 결과 처리 함수
                }
            }); //$.ajax

        });

        function showUploadResult(uploadResultArr){
            if(!uploadResultArr || uploadResultArr.length == 0){ return; }

            var uploadUL = $(".uploadResult ul");
            var str ="";

            $(uploadResultArr).each(function(i, obj){
                if(obj.image){
                    var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);
                    str += "<li data-path='"+obj.uploadPath+"'";
                    str +=" data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'" +" ><div>";
                    str += "<span> "+ obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' ";
                    str += "data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/display?fileName="+fileCallPath+"'>";
                    str += "</div></li>";
                }else{
                    var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
                    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                    str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' ><div>";
                    str += "<span> "+ obj.fileName+"</span>";
                    str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' ";
                    str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/resources/img/attach.png'></a>";
                    str += "</div></li>";
                }
            });

            uploadUL.append(str);
        }
    });
</script>

<%@include file="../includes/footer.jsp"%>