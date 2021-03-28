package com.thomas.mapper;

import com.thomas.domain.MemberVO;

public interface MemberMapper {

    public MemberVO read(String userId);
}
