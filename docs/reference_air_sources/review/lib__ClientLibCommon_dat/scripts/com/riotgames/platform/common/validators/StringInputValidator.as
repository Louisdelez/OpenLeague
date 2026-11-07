package com.riotgames.platform.common.validators
{
   import mx.validators.StringValidator;
   import mx.validators.ValidationResult;
   
   public class StringInputValidator extends StringValidator
   {
      
      public function StringInputValidator()
      {
         super();
      }
      
      override protected function doValidation(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = super.doValidation(param1);
         if(param1 == null)
         {
            param1 = getValueFromSource();
         }
         if(param1 == "")
         {
            _loc3_ = Boolean(requiredFieldError.length) ? requiredFieldError : resourceManager.getString("resources","validator_requiredErrorMessage");
            _loc2_.push(new ValidationResult(true,null,"invalid",_loc3_));
         }
         return _loc2_;
      }
   }
}

