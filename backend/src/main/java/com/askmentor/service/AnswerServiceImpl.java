package com.askmentor.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.askmentor.dto.AnswerRequest;
import com.askmentor.dto.SatisfactionRequest;
import com.askmentor.model.Answer;
import com.askmentor.repository.AnswerRepository;

@Service
public class AnswerServiceImpl implements AnswerService {
    
    private final AnswerRepository answerRepository;

    // 생성자를 통해 AnswerRepository 의존성 주입
    public AnswerServiceImpl(AnswerRepository answerRepository) {
        this.answerRepository = answerRepository;
    }

    /**
     * 특정 사용자의 모든 답변을 조회합니다.
     * 
     * @param user_id 조회할 사용자의 ID
     * @return 해당 사용자가 작성한 모든 답변 리스트
     */
    @Override
    public List<Answer> getUserAnswers(int user_id) {
        return answerRepository.findByUserId(user_id);
    }

    /**
     * 새로운 답변을 생성하여 저장합니다.
     * 
     * @param user_id 답변을 작성하는 사용자 ID
     * @param request AnswerRequest 객체 (질문 ID, 답변 내용, 만족도 포함)
     * @return 성공 메시지
     */
    @Override
    public String createAnswer(int user_id, AnswerRequest request) {
        Answer answer = new Answer();
        answer.setQuestionId(request.getQuestion_id());        // 질문 ID 설정
        answer.setUserId(user_id);                             // 작성자 ID 설정
        answer.setAnswer(request.getAnswer());                 // 답변 내용 설정
        answer.setSatisfaction(request.getSatisfaction());     // 초기 만족도 설정 (선택 사항)
        answerRepository.save(answer);                         // DB에 저장
        return "답변 등록 성공";
    }

    /**
     * 특정 답변의 상세 정보를 조회합니다.
     * 
     * @param answer_id 조회할 답변의 ID
     * @return 해당 답변 객체 (없을 경우 예외 발생)
     */
    @Override
    public Answer getAnswerDetail(int answer_id) {
        return answerRepository.findById(answer_id).orElseThrow();  // 답변 없으면 예외 발생
    }

    /**
     * 특정 답변에 대한 만족도를 등록하거나 수정합니다.
     * 
     * @param answer_id 만족도를 갱신할 답변의 ID
     * @param request SatisfactionRequest 객체 (수정할 만족도 값 포함)
     * @return 성공 메시지
     */
    @Override
    public String updateSatisfaction(int answer_id, SatisfactionRequest request) {
        Answer answer = answerRepository.findById(answer_id).orElseThrow(); // 답변 조회
        answer.setSatisfaction(request.getSatisfaction());                  // 만족도 수정
        answerRepository.save(answer);                                      // DB에 저장
        return "평점 등록/수정 성공";
    }
}
