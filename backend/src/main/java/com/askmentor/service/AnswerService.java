package com.askmentor.service;

import com.askmentor.model.Answer;
import com.askmentor.controller.AnswerController.AnswerRequest;
import com.askmentor.controller.AnswerController.SatisfactionRequest;
import java.util.List;

public interface AnswerService {
    List<Answer> getUserAnswers(int user_id);
    String createAnswer(int user_id, AnswerRequest request);
    Answer getAnswerDetail(int answer_id);
    String updateSatisfaction(int answer_id, SatisfactionRequest request);
}