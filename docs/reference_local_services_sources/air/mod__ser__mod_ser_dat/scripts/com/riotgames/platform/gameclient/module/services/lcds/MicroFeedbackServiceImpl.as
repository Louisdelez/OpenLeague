package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyResponseDTO;
   import com.riotgames.platform.gameclient.services.MicroFeedbackService;
   
   public class MicroFeedbackServiceImpl extends BaseLcdsService implements MicroFeedbackService
   {
      
      public function MicroFeedbackServiceImpl()
      {
         super();
      }
      
      public function processSurveyResponse(param1:SurveyResponseDTO, param2:Function = null, param3:Function = null) : void
      {
         invokeServiceWithoutSession("clientFacadeService","processMicroFeedbackSurveyResponse",[param1],param2,param3);
      }
      
      public function checkForAndSendSurveyQuestionToClient(param1:String, param2:Function = null, param3:Function = null) : void
      {
         invokeServiceWithoutSession("clientFacadeService","checkForAndSendSurveyQuestionToClient",[param1],param2,param3);
      }
   }
}

