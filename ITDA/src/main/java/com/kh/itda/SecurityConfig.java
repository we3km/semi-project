package com.kh.itda;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/css/**", "/js/**", "/images/**").permitAll() // 정적 리소스 허용
                .antMatchers("/", "/user/insert", "/user/login").permitAll() // 비회원 가능
                .anyRequest().authenticated() // 나머지는 인증 필요
            .and()
            .formLogin()
                .loginPage("/user/login")
                .loginProcessingUrl("/user/login")
                .defaultSuccessUrl("/", true)
                .permitAll()
            .and()
            .logout()
                .logoutUrl("/user/logout")
                .logoutSuccessUrl("/")
            .and()
            .csrf().disable(); // 개발 중에는 CSRF 끄는 경우도 많음

        return http.build();
    }

    @Bean
    public BCryptPasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
