package com.thomas.controller;

import lombok.extern.log4j.Log4j;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
@Log4j
public class CommonController {

    @GetMapping("/accessError")
    public void accessDenied(Authentication auth, Model model) {

        // auth 파라미터를 통해서 사용자의 정보를 확인할 수 있다.

        log.info("access Denied : " + auth);
        model.addAttribute("msg" , "Access Denied");
    }

    // loginInput() 은 Get 방식으로 접근 , 에러 메시지와 로그아웃 메시지를 파라미터로 사용
    @GetMapping("customLogin")
    public void loginInput(String error, String logout, Model model) {

        log.info("error: " + error);
        log.info("logout: " + logout);

        if (error != null) { model.addAttribute("error", "Login Error Check Your Account"); }
        if (logout != null) {model.addAttribute("logout", "Logout !!"); }
    }
}
