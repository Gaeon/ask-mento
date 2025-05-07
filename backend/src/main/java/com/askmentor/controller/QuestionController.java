package com.askmentor.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.askmentor.dto.QuestionRequest;
import com.askmentor.model.Question;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {
    
    @GetMapping("/{user_id}")
    public List<Question> getUserQuestions(@PathVariable int user_id) {
        // 사용자 질문 내역 조회 로직 구현
        return new ArrayList<>();
    }
    
    @PostMapping("/{user_id}")
    public String createQuestion(@PathVariable int user_id, @RequestBody QuestionRequest request) {
        // 질문 등록 로직 구현
        return "질문 등록 성공";
    }
    
    @GetMapping("/{question_id}")
    public Question getQuestionDetail(@PathVariable int question_id) {
        // 특정 질문 상세 조회 로직 구현
        return new Question();
    }
    

}