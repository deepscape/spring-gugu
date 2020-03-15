package com.thomas.mapper;

import com.thomas.domain.BoardVO;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface BoardMapper {

    // @Select("select * from tbl_board where bno > 0")
    List<BoardVO> getList();

    void insert(BoardVO board);
    void insertSelectKey(BoardVO board);
    BoardVO read(Long bno);
    int delete(Long bno);
    int update(BoardVO board);
}