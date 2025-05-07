package com.askmentor.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.askmentor.dto.QuestionRequest;
import com.askmentor.model.Question;
import com.askmentor.repository.QuestionRepository;

@Service
public class QuestionServiceImpl implements QuestionService {
    
    private final QuestionRepository questionRepository;
    
    public QuestionServiceImpl(QuestionRepository questionRepository) {
        this.questionRepository = questionRepository;
    }
    
    @Override
    public List<Question> getUserQuestions(int user_id) {
        return questionRepository.findByUserId(user_id);
    }
    
    @Override
    public String createQuestion(int user_id, QuestionRequest request) {
        Question question = new Question();
        question.setUserId(user_id);
        question.setQuestion(request.getQuestion());
        question.setStatus(request.getStatus());
        questionRepository.save(question);
        return "질문 등록 성공";
    }
    
    @Override
    public Question getQuestionDetail(int question_id) {
        return questionRepository.findById(question_id).orElseThrow();
    }
}