package com.thomas.mapper;

import com.thomas.domain.BoardAttachVO;

import java.util.List;

public interface BoardAttachMapper {

    public void insert(BoardAttachVO vo);
    public void delete(String uuid);
    public List<BoardAttachVO> findByBno(Long bno);
    public void deleteAll(Long bno);        // 게시물 삭제 시, 첨부파일도 삭제
    public List<BoardAttachVO> getOldFiles();       // 어제까지 쌓인 삭제 대상 파일 찾아서 삭제
}
