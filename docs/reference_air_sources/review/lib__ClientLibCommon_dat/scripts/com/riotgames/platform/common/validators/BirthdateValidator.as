package com.riotgames.platform.common.validators
{
   import mx.validators.DateValidator;
   import mx.validators.ValidationResult;
   
   public class BirthdateValidator extends DateValidator
   {
      
      public function BirthdateValidator()
      {
         super();
      }
      
      override protected function doValidation(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc2_:Array = super.doValidation(param1);
         if(param1 == null)
         {
            _loc3_ = "";
         }
         else
         {
            _loc3_ = String(param1);
         }
         if(_loc2_.length > 0 || _loc3_.length == 0 && !required)
         {
            return _loc2_;
         }
         if(param1 == "")
         {
            _loc2_.push(new ValidationResult(true,null,"invalid",resourceManager.getString("resources","validator_requiredErrorMessage")));
         }
         var _loc4_:Date = new Date();
         _loc4_.fullYear -= 13;
         var _loc5_:Date = new Date();
         _loc5_.setTime(Date.parse(param1));
         if(_loc5_ >= _loc4_)
         {
            _loc2_.push(new ValidationResult(true,null,"invalidBirthDate",resourceManager.getString("resources","birthdateValidator_invalidErrorMessage")));
         }
         return _loc2_;
      }
   }
}

