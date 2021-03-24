package com.thomas.mapper;

import com.thomas.domain.BoardAttachVO;

import java.util.List;

public interface BoardAttachMapper {

    public void insert(BoardAttachVO vo);
    public void delete(String uuid);
    public List<BoardAttachVO> findByBno(Long bno);
    public void deleteAll(Long bno);        // 게시물 삭제 시, 첨부파일도 삭제
}
