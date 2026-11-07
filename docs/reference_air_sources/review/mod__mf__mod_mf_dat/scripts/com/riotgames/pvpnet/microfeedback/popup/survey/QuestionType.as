package com.riotgames.pvpnet.microfeedback.popup.survey
{
   public class QuestionType
   {
      
      public static const MULTIPLE_CHOICE:String = "MULTIPLE_CHOICE";
      
      public static const NUMBERED_SCALE:String = "NUMBERED_SCALE";
      
      public static const LIKERT_AGREE_X5:String = "LIKERT_AGREE_X5";
      
      public static const LIKERT_LIKE_X5:String = "LIKERT_LIKE_X5";
      
      public static const OPEN_RESPONSE:String = "OPEN_RESPONSE";
      
      public function QuestionType()
      {
         super();
         throw new Error("Cannot create an instance of this class.");
      }
      
      public static function isValidType(param1:String) : Boolean
      {
         return param1 == MULTIPLE_CHOICE || param1 == NUMBERED_SCALE || param1 == LIKERT_AGREE_X5 || param1 == LIKERT_LIKE_X5 || param1 == OPEN_RESPONSE;
      }
   }
}

