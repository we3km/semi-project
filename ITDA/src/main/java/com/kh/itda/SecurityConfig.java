//package com.kh.itda;
//
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.web.SecurityFilterChain;
//
//import com.kh.itda.security.handler.CustomAuthenticationFailureHandler;
//import com.kh.itda.security.handler.CustomAuthenticationSuccessHandler;
//import com.kh.itda.security.provider.CustomAuthenticationProvider;
//import com.kh.itda.user.model.dao.UserDao;
//
//@Configuration
//@EnableWebSecurity
//public class SecurityConfig {
//
//    private final CustomAuthenticationSuccessHandler authenticationSuccessHandler;
//    private final CustomAuthenticationFailureHandler authenticationFailureHandler;
//    private final UserDao userDao;  // 직접 주입
//    private final PasswordEncoder passwordEncoder;
//
//    public SecurityConfig(
//        CustomAuthenticationSuccessHandler authenticationSuccessHandler,
//        CustomAuthenticationFailureHandler authenticationFailureHandler,
//        UserDao userDao,
//        PasswordEncoder passwordEncoder
//    ) {
//        this.authenticationSuccessHandler = authenticationSuccessHandler;
//        this.authenticationFailureHandler = authenticationFailureHandler;
//        this.userDao = userDao;
//        this.passwordEncoder = passwordEncoder;
//    }
//
//    @Bean
//    public CustomAuthenticationProvider customAuthenticationProvider() {
//        return new CustomAuthenticationProvider(userDao, passwordEncoder);
//    }
//
//    @Bean
//    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
//        http
//            .authenticationProvider(customAuthenticationProvider())
//            .authorizeRequests()
//                .antMatchers("/css/**", "/js/**", "/images/**").permitAll()
//                .antMatchers("/", "/user/insert", "/user/login").permitAll()
//                .antMatchers("/admin/**").hasRole("ADMIN")
//                .anyRequest().authenticated()
//            .and()
//            .formLogin()
//                .loginPage("/user/login")
//                .loginProcessingUrl("/user/loginprocess")
//                .usernameParameter("userId") 
//                .passwordParameter("userPwd")
//                .successHandler(authenticationSuccessHandler)
//                .failureHandler(authenticationFailureHandler)
//                .permitAll()
//            .and()
//            .logout()
//                .logoutUrl("/user/logout")
//                .logoutSuccessUrl("/")
//            .and()
//            .csrf().disable();
//
//        return http.build();
//    }
//
//    @Bean
//    public BCryptPasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }
//}