package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyResponseDTO;
   
   public interface MicroFeedbackService
   {
      
      function processSurveyResponse(param1:SurveyResponseDTO, param2:Function = null, param3:Function = null) : void;
      
      function checkForAndSendSurveyQuestionToClient(param1:String, param2:Function = null, param3:Function = null) : void;
   }
}

