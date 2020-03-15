package com.thomas.domain;

import lombok.Data;
import java.util.Date;

/*
    영속 계층 작업 순서
    (1) VO 생성
    (2) Mapper 인터페이스 작성 / XML 처리
    (3) Mapper 인터페이스 테스트
*/

@Data
public class BoardVO {

    private Long bno;
    private String title;
    private String content;
    private String writer;
    private Date regdate;
    private Date updateDate;
}