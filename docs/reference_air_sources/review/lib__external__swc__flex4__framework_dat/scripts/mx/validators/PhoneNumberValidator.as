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
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _allowedFormatChars:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var _minDigits:Object;
      
      private var minDigitsOverride:Object;
      
      private var _invalidCharError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var _wrongLengthError:String;
      
      private var wrongLengthErrorOverride:String;
      
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
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowedFormatChars() : String
      {
         return this._allowedFormatChars;
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
         this.allowedFormatCharsOverride = value;
         this._allowedFormatChars = value != null ? value : resourceManager.getString("validators","phoneNumberValidatorAllowedFormatChars");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minDigits() : Object
      {
         return this._minDigits;
      }
      
      public function set minDigits(value:Object) : void
      {
         this.minDigitsOverride = value;
         this._minDigits = value != null ? Number(value) : resourceManager.getNumber("validators","minDigitsPNV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return this._invalidCharError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         this.invalidCharErrorOverride = value;
         this._invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorPNV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongLengthError() : String
      {
         return this._wrongLengthError;
      }
      
      public function set wrongLengthError(value:String) : void
      {
         this.wrongLengthErrorOverride = value;
         this._wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorPNV");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.allowedFormatChars = this.allowedFormatCharsOverride;
         this.minDigits = this.minDigitsOverride;
         this.invalidCharError = this.invalidCharErrorOverride;
         this.wrongLengthError = this.wrongLengthErrorOverride;
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
   }
}

