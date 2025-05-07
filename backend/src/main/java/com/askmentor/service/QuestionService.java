package com.askmentor.service;

import com.askmentor.model.Question;
import com.askmentor.controller.QuestionController.QuestionRequest;
import java.util.List;

public interface QuestionService {
    List<Question> getUserQuestions(int user_id);
    String createQuestion(int user_id, QuestionRequest request);
    Question getQuestionDetail(int question_id);
}