package com.thomas.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {

    private int startPage;
    private int endPage;
    private boolean prev, next;

    private int total;
    private Criteria cri;

    public PageDTO(Criteria cri, int total) {

        this.cri = cri;
        this.total = total;

        // 페이지를 계산할 때, 끝 번호를 먼저 계산해 두는 것이 수월하다.
        // 페이지 번호가 10개씩 보인다고 가정 - 1 페이지의 경우 10 페이지가 끝, 11 페이지의 경우 20 페이지가 끝
        this.endPage = (int) (Math.ceil(cri.getPageNum() / 10.0)) * 10;
        this.startPage = this.endPage - 9;

        // total : 전체 데이터 수 ,  amount : 끝 페이지 번호 x 데이터 수    <- 만약 8페이지가 끝이면 8x10 = 80
        // 전체 데이터 187개, 끝 페이지가 10   <- 187/10 = 18.7     <- 19
        int realEnd = (int) (Math.ceil((total * 1.0) / cri.getAmount()));

        // 끝 페이지 번호(endPage)와 한 페이지당 출력되는 데이터 수(amount)의 곱이 전체 데이터 수(total)보다 크면, 끝 번호는 다시 계산
        // 끝 페이지 번호가 10 이면, 19 > 10 이므로, 다시 계산할 필요 없음
        // 끝 페이지 번호가 20 이면, 19 <= 20 이므로, 다시 계산할 필요 있음
        if (realEnd <= this.endPage) {
            this.endPage = realEnd;
        }

        this.prev = this.startPage > 1;     // 1 보다 크다는 얘기는, 11페이지 이상
        this.next = this.endPage < realEnd;     // 끝 페이지 번호가 진짜 끝 페이지 번호보다 작다면, next 가 존재 한다는 뜻
    }

}

