package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class PhoneNumberValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var wrongLengthErrorOverride:String;
      
      private var minDigitsOverride:Object;
      
      private var invalidCharErrorOverride:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var _minDigits:Object;
      
      private var _wrongLengthError:String;
      
      private var _invalidCharError:String;
      
      private var _allowedFormatChars:String;
      
      public function PhoneNumberValidator()
      {
         super();
      }
      
      public static function validatePhoneNumber(validator:PhoneNumberValidator, value:Object, baseField:String) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var message:String = null;
         var temp:String = null;
         var results:Array = [];
         var allowedFormatChars:String = validator.allowedFormatChars;
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var valid:String = DECIMAL_DIGITS + allowedFormatChars;
         var len:int = int(value.toString().length);
         var digitLen:int = 0;
         var minDigits:Number = Number(validator.minDigits);
         n = allowedFormatChars.length;
         for(i = 0; i < n; i++)
         {
            if(DECIMAL_DIGITS.indexOf(allowedFormatChars.charAt(i)) != -1)
            {
               message = resourceManager.getString("validators","invalidFormatChars");
               throw new Error(message);
            }
         }
         for(i = 0; i < len; i++)
         {
            temp = "" + value.toString().substring(i,i + 1);
            if(valid.indexOf(temp) == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
            if(valid.indexOf(temp) <= 9)
            {
               digitLen++;
            }
         }
         if(!isNaN(minDigits) && digitLen < minDigits)
         {
            results.push(new ValidationResult(true,baseField,"wrongLength",StringUtil.substitute(validator.wrongLengthError,minDigits)));
            return results;
         }
         return results;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         allowedFormatChars = allowedFormatCharsOverride;
         minDigits = minDigitsOverride;
         invalidCharError = invalidCharErrorOverride;
         wrongLengthError = wrongLengthErrorOverride;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongLengthError() : String
      {
         return _wrongLengthError;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minDigits() : Object
      {
         return _minDigits;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowedFormatChars() : String
      {
         return _allowedFormatChars;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return PhoneNumberValidator.validatePhoneNumber(this,value,null);
      }
      
      public function set wrongLengthError(value:String) : void
      {
         wrongLengthErrorOverride = value;
         _wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorPNV");
      }
      
      public function set minDigits(value:Object) : void
      {
         minDigitsOverride = value;
         _minDigits = value != null ? Number(value) : resourceManager.getNumber("validators","minDigitsPNV");
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorPNV");
      }
      
      public function set allowedFormatChars(value:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         var message:String = null;
         if(value != null)
         {
            n = value.length;
            for(i = 0; i < n; i++)
            {
               if(DECIMAL_DIGITS.indexOf(value.charAt(i)) != -1)
               {
                  message = resourceManager.getString("validators","invalidFormatChars");
                  throw new Error(message);
               }
            }
         }
         allowedFormatCharsOverride = value;
         _allowedFormatChars = value != null ? value : resourceManager.getString("validators","phoneNumberValidatorAllowedFormatChars");
      }
   }
}

