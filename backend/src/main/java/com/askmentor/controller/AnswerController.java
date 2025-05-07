package com.askmentor.controller;

import org.springframework.web.bind.annotation.*;
import com.askmentor.model.Answer;
import java.util.List;
import java.util.ArrayList;

@RestController
@RequestMapping("/api/answers")
public class AnswerController {
    
    @GetMapping("/{user_id}")
    public List<Answer> getUserAnswers(@PathVariable int user_id) {
        // 사용자 답변 내역 조회 로직 구현
        return new ArrayList<>();
    }
    
    @PostMapping("/{user_id}")
    public String createAnswer(@PathVariable int user_id, @RequestBody AnswerRequest request) {
        // 답변 등록 로직 구현
        return "답변 등록 성공";
    }
    
    @GetMapping("/detail/{answer_id}")
    public Answer getAnswerDetail(@PathVariable int answer_id) {
        // 특정 답변 상세 조회 로직 구현
        return new Answer();
    }
    
    @PatchMapping("/{answer_id}")
    public String updateSatisfaction(@PathVariable int answer_id, @RequestBody SatisfactionRequest request) {
        // 답변 평점 등록/수정 로직 구현
        return "평점 등록/수정 성공";
    }
    
    public static class AnswerRequest {
        private int question_id;
        private int user_id;
        private String answer;
        private Integer satisfaction;
        
        public int getQuestion_id() {
            return question_id;
        }
        
        public void setQuestion_id(int question_id) {
            this.question_id = question_id;
        }
        
        public int getUser_id() {
            return user_id;
        }
        
        public void setUser_id(int user_id) {
            this.user_id = user_id;
        }
        
        public String getAnswer() {
            return answer;
        }
        
        public void setAnswer(String answer) {
            this.answer = answer;
        }
        
        public Integer getSatisfaction() {
            return satisfaction;
        }
        
        public void setSatisfaction(Integer satisfaction) {
            this.satisfaction = satisfaction;
        }
    }
    
    public static class SatisfactionRequest {
        private Integer satisfaction;
        
        public Integer getSatisfaction() {
            return satisfaction;
        }
        
        public void setSatisfaction(Integer satisfaction) {
            this.satisfaction = satisfaction;
        }
    }
}