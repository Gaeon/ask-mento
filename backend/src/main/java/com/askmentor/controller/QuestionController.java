package com.askmentor.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.bind.annotation.*;
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
    
    @GetMapping("/detail/{question_id}")
    public Question getQuestionDetail(@PathVariable int question_id) {
        // 특정 질문 상세 조회 로직 구현
        return new Question();
    }
    
    public static class QuestionRequest {
        private int user_id;
        private String question;
        private Integer status;
        
        public int getUser_id() {
            return user_id;
        }

        public void setUser_id(int user_id) {
            this.user_id = user_id;
        }

        public String getQuestion() {
            return question;
        }

        public void setQuestion(String question) {
            this.question = question;
        }

        public Integer getStatus() {
            return status;
        }

        public void setStatus(Integer status) {
            this.status = status;
        }
    }
}