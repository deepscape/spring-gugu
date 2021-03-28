<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%@include file="../includes/header.jsp"%>
<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">Board Register</h1>
    </div>
    <!-- /.col-lg-12 -->
</div>
<!-- /.row -->

<style>
    .uploadResult {
        width: 100%;
        background-color: gray;
    }

    .uploadResult ul {
        display: flex;
        flex-flow: row;
        justify-content: center;
        align-items: center;
    }

    .uploadResult ul li {
        list-style: none;
        padding: 10px;
    }

    .uploadResult ul li img {
        width: 100px;
    }
</style>

<style>
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
    }

    .bigPicture {
        position: relative;
        display:flex;
        justify-content: center;
        align-items: center;
    }
</style>

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">Board Register</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <!-- 아래 name 속성은 BoardVO 클래스의 변수와 일치해야 한다. -->
                <form role="form" action="/board/register" method="post">
                    <!-- CSRF token -->
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div class="form-group">
                        <label>Title</label><input class="form-control" name='title'>
                    </div>
                    <div class="form-group">
                        <label>Text area</label>
                        <textarea class="form-control" rows="3" name='content'></textarea>
                    </div>
                    <div class="form-group">
                        <label>Writer</label>
                        <!-- 글을 작성할 때, 작성자 이름은 로그인 ID 를 자동 입력 -->
                        <input class="form-control" name='writer' value="<sec:authentication property='principal.username' />" readonly="readonly" />
                    </div>
                    <button type="submit" class="btn btn-default">Submit Button</button>
                    <button type="reset" class="btn btn-default">Reset Button</button>
                </form>
            </div>
            <!--  end panel-body -->
        </div>
        <!--  end panel panel-default -->
    </div>
    <!-- end panel -->
</div>
<!-- /.row -->

<div class="row">
    <div class="col-lg-12">
        <div class="panel panel-default">
            <div class="panel-heading">File Attach</div>
            <!-- /.panel-heading -->
            <div class="panel-body">
                <div class="form-group uploadDiv">
                    <input type="file" name='uploadFile' multiple>
                </div>
                <div class='uploadResult'>
                    <ul></ul>
                </div>
            </div>
            <!--  end panel-body -->
        </div>
        <!--  end panel panel-default -->
    </div>
    <!-- end panel -->
</div>
<!-- /.row -->

<script>
    $(document).ready(function(e){

        // <form> 태그 전송 처리
        var formObj = $("form[role='form']");
        $("button[type='submit']").on("click", function(e){
            e.preventDefault();
            console.log("submit clicked");

            var str = "";

            $(".uploadResult ul li").each(function(i, obj){
                var jobj = $(obj);

                console.dir(jobj);
                console.log("-------------------------");
                console.log(jobj.data("filename"));

                // BoardVO 는 attachList 라는 이름의 변수로 첨부파일 정보를 수집  -> attachList[index] 와 같은 이름을 사용한다.
                str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
                str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
                str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
                str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+ jobj.data("type")+"'>";
            });

            console.log(str);
            formObj.append(str).submit();
        });

        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        var maxSize = 5242880; //5MB

        // 파일 사이즈 및 파일 형식 체크
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

                // validation 통과한 파일에 대해, formData 객체에 추가
                formData.append("uploadFile", files[i]);
            }

            $.ajax({
                url: '/uploadAjaxAction',
                processData: false,
                contentType: false,
                beforeSend: function(xhr) { xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); },  // CSRF 토큰 전송
                data: formData,
                type: 'POST',
                dataType:'json',
                success: function(result){
                    console.log(result);
                    showUploadResult(result); //업로드 결과 처리 함수
                }
            }); //$.ajax
        });     // <input type='file'> 의 내용 변경 감지

        // 업로드된 결과를 화면에 썸네일 표출
        function showUploadResult(uploadResultArr){

            if(!uploadResultArr || uploadResultArr.length == 0){ return; }

            var uploadUL = $(".uploadResult ul");
            var str ="";

            $(uploadResultArr).each(function(i, obj){
                 //image type
                if(obj.image){
                    var fileCallPath =  encodeURIComponent( obj.uploadPath+ "/s_"+obj.uuid +"_"+obj.fileName);

                    // 게시물이 등록될 때 첨부파일과 관련된 자료를 같이 전송할 수 있도록 처리 / <form> 태그에서 처리
                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "' ><div>";
                    str += "<span> " + obj.fileName + "</span>";
                    // 파일 삭제를 위한 정보(경로, 데이터 타입)를 data- 태그 활용해서 보관
                    str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/display?fileName=" + fileCallPath + "'>";
                    str += "</div></li>";
                } else {
                    var fileCallPath =  encodeURIComponent( obj.uploadPath+"/"+ obj.uuid +"_"+obj.fileName);
                    var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

                    // 게시물이 등록될 때 첨부파일과 관련된 자료를 같이 전송할 수 있도록 처리
                    str += "<li data-path='" + obj.uploadPath + "' data-uuid='" + obj.uuid + "' data-filename='" + obj.fileName + "' data-type='" + obj.image + "' ><div>";
                    str += "<span> " + obj.fileName + "</span>";
                    // 파일 삭제를 위한 정보(경로, 데이터 타입)를 data- 태그 활용해서 보관
                    str += "<button type='button' data-file=\'" + fileCallPath + "\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
                    str += "<img src='/resources/img/attach.png'></a>";
                    str += "</div></li>";
                }

                uploadUL.append(str);
            });
        }       // end showUploadResult()

        // <input type='file'> 의 초기화 - 첨부 파일을 업로드한 뒤에, 복사된 객체를 <div> 에 추가해서 초기화
        var cloneObj = $(".uploadDiv").clone();

        // 'x' 아이콘 클릭하면, 첨부 파일 삭제 처리
        $(".uploadResult").on("click", "button", function(e) {
            console.log("delete file");

            var targetFile = $(this).data("file");
            var type = $(this).data("type");
            var targetLi = $(this).closest("li");       // 파일 삭제 후에, 화면 상의 썸네일 제거를 위한 변수 할당

            $.ajax({
                url: '/deleteFile',
                data: {fileName: targetFile, type: type},
                beforeSend: function(xhr) { xhr.setRequestHeader(csrfHeaderName, csrfTokenValue); },    // CSRF Token
                dataType:'text',
                type: 'POST',
                success: function(result){
                    alert(result);
                    targetLi.remove();      // 파일 삭제 후에, 화면 상의 썸네일 제거
                    $(".uploadDiv").html(cloneObj.html());      // 파일 삭제 후에, 파일 선택 버튼 초기화
                }
            }); //$.ajax
        });

    });
</script>

<%@include file="../includes/footer.jsp"%>