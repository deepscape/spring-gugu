package com.thomas.aop;

import lombok.extern.log4j.Log4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Aspect
@Log4j
@Component
public class LogAdvice {

    @Before("execution(* com.thomas.service.SampleService*.*(..))")
    public void logBefore() {
        log.info("==============================");
    }

    // Pointcut 설정에 doAdd 메서드 명시하고 파라미터 타입을 지정 / args 에서 변수명 지정
    // 아래 코드를 활용해서 파라미터 역시 파악할 수 있다.
    @Before("execution(* com.thomas.service.SampleService*.doAdd(String, String)) && args(str1, str2) ")
    public void logBeforeWithParam(String str1, String str2) {
        log.info("str1: " + str1);
        log.info("str2: " + str2);
    }

    // 예외가 발생한 후에 동작
    @AfterThrowing(pointcut = "execution(* com.thomas.service.SampleService*.*(..))", throwing = "exception")
    public void logException(Exception exception) {
        log.info("Exception......!!");
        log.info("exception: " + exception);
    }

    // @Around 는 직접 대상 메서드를 실행할 수 있는 권한을 가진다. (메서드 실행 전후로 처리 가능)
    // ProceedingJoinPoint 는 @Around 와 걸합해서 파라미터나 예외 처리
    @Around("execution(* com.thomas.service.SampleService*.*(..))")
    public Object logTime(ProceedingJoinPoint pjp) {

        long start = System.currentTimeMillis();

        // pjp 는 AOP 의 대상이 되는 Target(joinPoint) 이나 파라미터를 파악할 뿐 아니라
        // 직접 실행을 결정할 수도 있다.
        log.info("Target: " + pjp.getTarget());
        log.info("Param: " + Arrays.toString(pjp.getArgs()));

        // invoke method
        Object result = null;

        try {
            result = pjp.proceed();
        } catch (Throwable e) {
            e.printStackTrace();
        }

        long end = System.currentTimeMillis();
        log.info("TIME: " + (end-start));

        // @Around 가 적용되는 메서드는 void 아닌 타입으로 설정하고, 메서드의 실행 결과 역시 직접 반환하는 형태여야 한다.
        return result;
    }

}