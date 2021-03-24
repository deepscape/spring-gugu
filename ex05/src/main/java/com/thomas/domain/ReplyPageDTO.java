package com.thomas.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor         // replyCnt 와 list 를 생성자의 파라미터로 처리
public class ReplyPageDTO {

    private int replyCnt;
    private List<ReplyVO> list;
}