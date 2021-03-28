package com.thomas.controller;

import com.thomas.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLConnection;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

import static sun.net.www.protocol.http.HttpURLConnection.userAgent;

@Controller
@Log4j
public class UploadController {

    @GetMapping("/uploadForm")
    public void uploadForm() {
        log.info("upload form");
    }

    @PostMapping("uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model) {

        // Linux file location 형식 지킬 것
        String uploadFolder = "/Users/hdkim/Documents/tmp";

        for (MultipartFile multipartFile : uploadFile) {
            log.info("------------------------");
            log.info("Upload File Name: " + multipartFile.getOriginalFilename());
            log.info("Upload File Size: " + multipartFile.getSize());

            File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

            try {
                multipartFile.transferTo(saveFile);
            } catch (Exception e) {
                log.error(e.getMessage());
            }   // end catch
        }   // end for
    }

    @GetMapping("/uploadAjax")
    public void uploadAjax() {
        log.info("upload ajax");
    }

    private String getFolder() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);

        return str.replace("-", File.separator);
    }

    // 이미지 파일 여부 판단
    private boolean checkImageType(File file) {
        // String contentType = Files.probeContentType(file.toPath());          <- 동작 안 함
        // String mimeType = URLConnection.guessContentTypeFromName("/Users/hdkim/Documents/tmp/2021/03/17/f5e701b0-317b-4620-9991-d22d6a21f050_ddd.png");

        // MIMETYPE 확인하는 과정에서 많은 오류 있었음
        // 하단 MIME TYPE 없는 경우, NullPointerException 주의할 것
        String mimeType = "" + URLConnection.guessContentTypeFromName(file.toPath().toString());
        if (mimeType.contains("image")) { return true; } else { return false; }
    }

    @PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
        log.info("update ajax post......");

        List<AttachFileDTO> list = new ArrayList<>();
        String uploadFolder = "/Users/hdkim/Documents/tmp";
        String uploadFolderPath = getFolder();

        // make folder --------
        File uploadPath = new File(uploadFolder, getFolder());
        log.info("upload path: " + uploadPath);

        if (uploadPath.exists() == false) { uploadPath.mkdirs(); }
        // make yyyy/MM/dd folder

        for(MultipartFile multipartFile : uploadFile) {
            log.info("------------------------");
            log.info("Upload File Name: " + multipartFile.getOriginalFilename());
            log.info("Upload File Size: " + multipartFile.getSize());

            AttachFileDTO attachFileDTO = new AttachFileDTO();

            String uploadFileName = multipartFile.getOriginalFilename();

            // IE has file path
            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
            log.info("only file name: " + uploadFileName);
            attachFileDTO.setFileName(uploadFileName);

            // 중복 방지를 위한 UUID 적용
            UUID uuid = UUID.randomUUID();
            uploadFileName = uuid.toString()+ "_" + uploadFileName;

            try {
                // File saveFile = new File(uploadFolder, uploadFileName);
                File saveFile = new File(uploadPath, uploadFileName);

                // 지정된 폴더로 파일 저장
                multipartFile.transferTo(saveFile);

                attachFileDTO.setUuid(uuid.toString());
                attachFileDTO.setUploadPath(uploadFolderPath);

                // check image type file -> Thumbnail creation
                if(checkImageType(saveFile)) {
                    attachFileDTO.setImage(true);
                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
                    // 썸내일 이미지 생성
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
                    thumbnail.close();
                }

                // add to List
                list.add(attachFileDTO);

            } catch (Exception e) {
                e.printStackTrace();
                // log.error("error: " + e.getMessage());
            } // end catch

        } // end for

        return new ResponseEntity<>(list, HttpStatus.OK);
    }   // uploadAjaxPost method end

    @GetMapping("/display")
    @ResponseBody
    public ResponseEntity<byte[]> getFile(String fileName) {

        log.info("fileName: " + fileName);
        File file = new File("/Users/hdkim/Documents/tmp/" + fileName);
        log.info("file: " + file);

        ResponseEntity<byte[]> result = null;

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.add("Content-Type", URLConnection.guessContentTypeFromName(file.toPath().toString()));

            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), headers, HttpStatus.OK);
        } catch (Exception exception) {
            exception.printStackTrace();
        }

        return result;
    }

    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(String fileName) {

        log.info("download file: " + fileName);

        Resource resource = new FileSystemResource("/Users/hdkim/Documents/tmp/" + fileName);
        log.info("resource: " + resource);

        if (resource.exists() == false) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        String resourceName = resource.getFilename();

        // remove UUID
        String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);

        HttpHeaders headers = new HttpHeaders();

        try {
            String downloadName = null;

            if (userAgent.contains("Trident")) {
                log.info("IE browser");
                downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", "");
            } else if (userAgent.contains("Edge")) {
                log.info("Edge browser");
                downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
                log.info("Edge name: " + downloadName);
            } else {
                log.info("Chrome browser");
                downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
            }

            // browser 종류에 맞게 처리
            headers.add("Content-Disposition", "attachment; filename=" + downloadName);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    }       // end download file

    @PostMapping("/deleteFile")
    @ResponseBody
    public ResponseEntity<String> deleteFile(String fileName, String type) {

        log.info("deleteFile: " + fileName);

        File file;

        try {
            file = new File("/Users/hdkim/Documents/tmp/" + URLDecoder.decode(fileName, "UTF-8"));
            file.delete();

            // <span> 의 data-type 속성으로 판단
            if (type.equals("image")) {
                String largeFileName = file.getAbsolutePath().replace("s_", "");

                log.info("largeFileName: " + largeFileName);

                file = new File(largeFileName);
                file.delete();
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<String>("deleted", HttpStatus.OK);
    }

}