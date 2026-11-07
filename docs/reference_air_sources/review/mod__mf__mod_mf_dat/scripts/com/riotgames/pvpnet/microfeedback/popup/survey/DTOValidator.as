package com.riotgames.pvpnet.microfeedback.popup.survey
{
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyDTO;
   import com.riotgames.pvpnet.microfeedback.ClientModuleMicroFeedback;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class DTOValidator
   {
      
      private static const MICROFEEDBACK_RESOURCE_ID:String = ClientModuleMicroFeedback.MICROFEEDBACK_RESOURCE_ID;
      
      public function DTOValidator()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
      
      public static function validateAndPrepPrompt(param1:SurveyDTO) : Boolean
      {
         var _loc3_:String = null;
         if(!QuestionType.isValidType(param1.questionType))
         {
            return false;
         }
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         if(param1.questionContent == null || param1.questionContent == "")
         {
            _loc3_ = _loc2_.getString(MICROFEEDBACK_RESOURCE_ID,param1.questionType + "_question_" + param1.questionId);
            if(_loc3_ == "**" + param1.questionType + "_question_" + param1.questionId)
            {
               return false;
            }
            param1.questionContent = _loc3_;
         }
         return true;
      }
   }
}

