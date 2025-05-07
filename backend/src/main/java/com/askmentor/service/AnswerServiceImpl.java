package com.askmentor.service;

import com.askmentor.model.Answer;
import com.askmentor.controller.AnswerController.AnswerRequest;
import com.askmentor.controller.AnswerController.SatisfactionRequest;
import com.askmentor.repository.AnswerRepository;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class AnswerServiceImpl implements AnswerService {
    
    private final AnswerRepository answerRepository;
    
    public AnswerServiceImpl(AnswerRepository answerRepository) {
        this.answerRepository = answerRepository;
    }
    
    @Override
    public List<Answer> getUserAnswers(int user_id) {
        return answerRepository.findByUserId(user_id);
    }
    
    @Override
    public String createAnswer(int user_id, AnswerRequest request) {
        Answer answer = new Answer();
        answer.setQuestionId(request.getQuestion_id());
        answer.setUserId(user_id);
        answer.setAnswer(request.getAnswer());
        answer.setSatisfaction(request.getSatisfaction());
        answerRepository.save(answer);
        return "답변 등록 성공";
    }
    
    @Override
    public Answer getAnswerDetail(int answer_id) {
        return answerRepository.findById(answer_id).orElseThrow();
    }
    
    @Override
    public String updateSatisfaction(int answer_id, SatisfactionRequest request) {
        Answer answer = answerRepository.findById(answer_id).orElseThrow();
        answer.setSatisfaction(request.getSatisfaction());
        answerRepository.save(answer);
        return "평점 등록/수정 성공";
    }
}