package com.riotgames.platform.common.validators
{
   import mx.validators.Validator;
   
   public class ValidatorFactory
   {
      
      public static const EMAIL_VALIDATOR:String = "email";
      
      public static const STRING_VALIDATOR:String = "string";
      
      public static const BIRTH_VALIDATOR:String = "birthday";
      
      public static const REGEXP_VALIDATOR:String = "regexp";
      
      public static const OBJECT_VALIDATOR:String = "object";
      
      public static const NUMBER_VALIDATOR:String = "number";
      
      public static var DEFAULT_ERROR_MESSAGE:String = "";
      
      public function ValidatorFactory()
      {
         super();
      }
      
      public function createValidator(param1:ValidationObject) : Validator
      {
         var _loc2_:* = undefined;
         switch(param1.type)
         {
            case EMAIL_VALIDATOR:
               _loc2_ = new EmailInputValidator();
               break;
            case NUMBER_VALIDATOR:
               _loc2_ = new EmailInputValidator();
               break;
            case BIRTH_VALIDATOR:
               _loc2_ = new BirthdateValidator();
               break;
            case REGEXP_VALIDATOR:
               _loc2_ = new RegExpInputValidator();
               _loc2_.expression = param1.expression;
               _loc2_.noMatchError = param1.errorMessage;
               break;
            case OBJECT_VALIDATOR:
               _loc2_ = new PropetyMatchValidator();
               _loc2_.targetObject = param1.objectToMatch;
               _loc2_.targetObjectProperty = param1.propertyToMatch;
               break;
            default:
               _loc2_ = new StringInputValidator();
         }
         _loc2_.required = true;
         _loc2_.source = param1.source;
         _loc2_.property = param1.property;
         _loc2_.requiredFieldError = param1.errorMessage;
         if(param1.type != REGEXP_VALIDATOR)
         {
            _loc2_.requiredFieldError = param1.errorMessage != null ? param1.errorMessage : DEFAULT_ERROR_MESSAGE;
         }
         return _loc2_;
      }
   }
}

