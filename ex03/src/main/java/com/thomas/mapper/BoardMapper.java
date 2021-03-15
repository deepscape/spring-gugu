package com.thomas.mapper;

import com.thomas.domain.BoardVO;
import com.thomas.domain.Criteria;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

public interface BoardMapper {

    // @Select("select * from tbl_board where bno > 0")
    List<BoardVO> getList();

    // Paging
    List<BoardVO> getListWithPaging(Criteria cri);

    void insert(BoardVO board);
    void insertSelectKey(BoardVO board);
    BoardVO read(Long bno);
    int delete(Long bno);
    int update(BoardVO board);

    // 전체 데이터 개수 처리
    int getTotalCount(Criteria cri);

    void updateReplyCnt(@Param("bno") Long bno, @Param("amount") int amount);
}