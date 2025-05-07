package com.askmentor.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.askmentor.dto.QuestionRequest;
import com.askmentor.model.Answer;
import com.askmentor.model.Question;
import com.askmentor.repository.AnswerRepository;
import com.askmentor.repository.QuestionRepository;

@Service
public class QuestionServiceImpl implements QuestionService {
    
    private final QuestionRepository questionRepository;
    private final AnswerRepository answerRepository;
    
    public QuestionServiceImpl(QuestionRepository questionRepository, AnswerRepository answerRepository) {
        this.questionRepository = questionRepository;
        this.answerRepository = answerRepository;
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
        question.setTimestamp(LocalDateTime.now());
        question.setStatus(request.getStatus());
        questionRepository.save(question);
        return "질문 등록 성공";
    }
    
    @Override
    public Question getQuestionDetail(int question_id) {
        return questionRepository.findById(question_id).orElseThrow();
    }
    
    @Override
    public List<Answer> getAnswersByQuestionId(int question_id) {
        return answerRepository.findByQuestionId(question_id);
    }
}