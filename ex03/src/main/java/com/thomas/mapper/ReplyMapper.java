package com.thomas.mapper;

import com.thomas.domain.Criteria;
import com.thomas.domain.ReplyVO;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ReplyMapper {

    public int insert(ReplyVO vo);
    public ReplyVO read(Long bno);
    public int delete (Long rno);
    public int update (ReplyVO reply);

    // 2개 이상의 데이터를 파라미터로 전달하려면 1) 별도의 객체 2) Map 3) @Param
    public List<ReplyVO> getListWithPaging(@Param("cri") Criteria cri, @Param("bno") Long bno);
    public int getCountByBno(Long bno);
}