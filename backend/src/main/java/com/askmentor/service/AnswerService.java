package com.askmentor.service;

import java.util.List;

import com.askmentor.dto.AnswerRequest;
import com.askmentor.dto.SatisfactionRequest;
import com.askmentor.model.Answer;

public interface AnswerService {
    List<Answer> getUserAnswers(int user_id);
    String createAnswer(int user_id, AnswerRequest request);
    Answer getAnswerDetail(int answer_id);
    String updateSatisfaction(int answer_id, SatisfactionRequest request);
}