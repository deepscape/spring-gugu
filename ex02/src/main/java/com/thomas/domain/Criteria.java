package com.thomas.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@ToString
@Setter
@Getter
public class Criteria {

    private int pageNum;
    private int amount;

    private String type;
    private String keyword;

    public Criteria() {
        this(1, 10);
    }

    public Criteria(int pageNum, int amount) {
        this.pageNum = pageNum;
        this.amount = amount;
    }

    public String[] getTypeArr() {
        return type == null ? new String[] {} : type.split("");
    }

    // UriComponentsBuilder <- 여러 개의 파라미터들을 연결해서 URL의 형태로 만들어주는 기능

}
