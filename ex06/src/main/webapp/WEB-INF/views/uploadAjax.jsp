<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Insert title here</title>
</head>
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

    .bigPicture img {
        width:600px;
    }
</style>

<body>
    <h1>Upload with Ajax</h1>
    <div class='bigPictureWrapper'>
        <div class='bigPicture'></div>
    </div>
    <div class='uploadDiv'>
        <input type='file' name='uploadFile' multiple />
    </div>
    <div class='uploadResult'>
        <ul></ul>
    </div>
    <button id='uploadBtn'>Upload</button>

    <script src="https://code.jquery.com/jquery-3.3.1.min.js"
            integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
            crossorigin="anonymous">
    </script>

    <script>

        // 썸네일 이미지를 클릭하면, 원본 이미지를 볼 수 있게 처리
        function showImage(fileCallPath) {
            // alert(fileCallPath);

            $(".bigPictureWrapper").css("display", "flex").show();
            $(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width:'100%', height: '100%'}, 1000);
            $(".bigPictureWrapper").on("click", function(e){
                $(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
                // 하단 lambda 함수는 IE11 에서 제대로 동작하지 않는다는 점을 주의할 것
                setTimeout(() => {$(this).hide();}, 1000);
            });

            // <span>x</span> 태그 , 즉 삭제 버튼 클릭 처리
            $(".uploadResult").on("click","span", function(e){
                var targetFile = $(this).data("file");
                var type = $(this).data("type");

                console.log(targetFile);

                $.ajax({
                    url: '/deleteFile',
                    data: {fileName: targetFile, type:type},
                    dataType:'text',
                    type: 'POST',
                    success: function(result){
                        alert(result);
                    }
                }); //$.ajax
            });

        }       // end showImage()

        var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
        var maxSize = 5242880;      // 5MB

        function checkExtension(fileName, fileSize) {
            if(fileSize >= maxSize) {
                alert("파일 사이즈 초과");
                return false;
            }

            if(regex.test(fileName)) {
                alert("해당 종류의 파일은 업로드할 수 없습니다.");
                return false;
            }

            return true;
        }

        // <input type='file'> 의 초기화 - 첨부 파일을 업로드한 뒤에, 복사된 객체를 <div> 에 추가해서 초기화
        var cloneObj = $(".uploadDiv").clone();

        $("#uploadBtn").on("click", function(e) {
            // Ajax file 전송 - ForData 객체가 핵심
            var formData = new FormData();
            var inputFile = $("input[name='uploadFile']");
            var files = inputFile[0].files;

            console.log(files);

            // add filedata to formdata
            for(var i=0; i<files.length; i++) {
                if(!checkExtension(files[i].name, files[i].size)) { return false; }
                formData.append("uploadFile", files[i]);
            }

            // 파일 이름 출력
            var uploadResult = $(".uploadResult ul");

            function showUploadedFile(uploadResultArr) {
                var str = "";

                $(uploadResultArr).each(function (i, obj) {
                    // 이미지가 아닌 경우, 지정된 첨부파일 이미지 출력
                    if(!obj.image) {
                        // attach.png 파일을 클릭하면 다운로드 가능하도록 <a> 태그 활용
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
                        str += "<li><a href='/download?fileName=" + fileCallPath + "'>" + "<img src='/resources/img/attach.png'>" + obj.fileName + "</a>" +
                               "<span data-file=\'" + fileCallPath + "\' data-type='file'> x </span>" + "<div></li>";
                    } else {    // 이미지 -> 썸네일 호출
                        // str += "<li>" + obj.fileName + "</li>";
                        var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);

                        var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
                        originPath = originPath.replace(new RegExp(/\\/g),"/");

                        // 썸네일 클릭 시 showImage() 호출
                        str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\">" + "<img src='display?fileName=" + fileCallPath + "'></a>" +
                               "<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span>" + "<li>";

                        // str += "<li><img src='/display?fileName=" + fileCallPath + "'></li>";

                        console.log(str);
                    }
                });

                uploadResult.append(str);
            }

            // ajax request
            $.ajax({
                url: 'uploadAjaxAction',
                processData: false,
                contentType: false,
                data: formData,
                type: 'POST',
                dataType: 'json',
                success: function(result) {
                    // alert("Uploaded");
                    console.log("result: " + result);

                    showUploadedFile(result);     // 파일 목록 화면 출력
                    $(".uploadDiv").html(cloneObj.html());      // 파일 업로드 후 초기화
                }
            });     // $.ajax end
        });     // $("#uploadBtn") end

    </script>
</body>
</html>