package com.thomas.domain;

import lombok.Data;

@Data
public class BoardAttachVO {

    private String uuid;
    private String uploadPath;
    private String fileName;
    private boolean fileType;       // default 'I'

    private Long bno;
}
