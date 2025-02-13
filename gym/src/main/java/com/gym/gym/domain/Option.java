package com.gym.gym.domain;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class Option {
        String keyword;
        int code;               // 검색 옵션 코드
        int orderCode;          // 순서 옵션 코드

        public Option(){
            this.keyword= "";
        }


}
