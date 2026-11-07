package com.riotgames.platform.common.validators
{
   import flash.display.DisplayObject;
   import mx.validators.StringValidator;
   import mx.validators.ValidationResult;
   
   public class PropetyMatchValidator extends StringValidator
   {
      
      public var targetObject:DisplayObject;
      
      public var targetObjectProperty:String;
      
      public function PropetyMatchValidator()
      {
         super();
      }
      
      override protected function doValidation(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc2_:Array = super.doValidation(param1);
         if(this.targetObject != null)
         {
            _loc3_ = this.targetObject[this.targetObjectProperty];
            if(param1 != _loc3_)
            {
               _loc4_ = Boolean(requiredFieldError.length) ? requiredFieldError : resourceManager.getString("resources","validator_requiredErrorMessage");
               _loc2_.push(new ValidationResult(true,null,"invalid",_loc4_));
            }
         }
         return _loc2_;
      }
   }
}

