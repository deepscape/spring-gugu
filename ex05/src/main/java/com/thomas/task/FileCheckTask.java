package com.thomas.task;

import com.thomas.domain.BoardAttachVO;
import com.thomas.mapper.BoardAttachMapper;
import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

@Log4j
@Component
public class FileCheckTask {

    @Setter(onMethod_ = { @Autowired })
    private BoardAttachMapper attachMapper;

    private String getFolderYesterDay() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        String str = sdf.format(cal.getTime());

        return str.replace("-", File.separator);
    }

    // 매일 18시 10분에 배치 처리
    @Scheduled(cron="0 10 18 * * *")
    public void checkFiles() throws Exception {
        log.warn("File Check Task Run .......................");
        log.warn("===========================================");

        // file list in DB
        List<BoardAttachVO> fileList = attachMapper.getOldFiles();

        // 어제 날짜로 보관되는 모든 첨부 파일의 목록 : fileListPaths
        List<Path> fileListPaths = fileList.stream()
                .map(vo -> Paths.get("/Users/hdkim/Documents/tmp",vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
                .collect(Collectors.toList());

        // 썸네일 이미지 리스트 추출
        fileList.stream().filter(vo -> vo.isFileType() == true)
                .map(vo -> Paths.get("/Users/hdkim/Documents/tmp",vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
                .forEach(p -> fileListPaths.add(p));

        log.warn("===========================================");

        fileListPaths.forEach(p -> log.warn(p));

        // files in yesterday dir
        File targetDir = Paths.get("/Users/hdkim/Documents/tmp", getFolderYesterDay()).toFile();

        // 실제 폴더에 있는 파일들의 목록에서 DB에 없는 파일들을 찾아서 목록으로 준비 : removeFiles
        // 하단 람다 식은 분석 필요함
        File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);

        log.warn("-------------------------------------------");

        // 파일 제거
        for (File file : removeFiles) {
            log.warn(file.getAbsolutePath());
            file.delete();
        }
    }
}