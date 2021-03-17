package com.thomas.controller;

import com.thomas.domain.AttachFileDTO;
import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.activation.MimetypesFileTypeMap;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLConnection;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.*;

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
        String mimeType = URLConnection.guessContentTypeFromName(file.toPath().toString());
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
                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
                    // 썸내일 이미지 생성
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
                    thumbnail.close();
                }

                // add to List
                list.add(attachFileDTO);

            } catch (Exception e) {
                log.error(e.getMessage());
            } // end catch

        } // end for

        return new ResponseEntity<>(list, HttpStatus.OK);
    }   // uploadAjaxPost method end

}