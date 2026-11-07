package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class ZipCodeValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const DOMAIN_US:uint = 1;
      
      private static const DOMAIN_US_OR_CANADA:uint = 2;
      
      private static const DOMAIN_CANADA:uint = 3;
      
      private var _allowedFormatChars:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var _domain:String;
      
      private var domainOverride:String;
      
      private var _invalidCharError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var _invalidDomainError:String;
      
      private var invalidDomainErrorOverride:String;
      
      private var _wrongCAFormatError:String;
      
      private var wrongCAFormatErrorOverride:String;
      
      private var _wrongLengthError:String;
      
      private var wrongLengthErrorOverride:String;
      
      private var _wrongUSFormatError:String;
      
      private var wrongUSFormatErrorOverride:String;
      
      public function ZipCodeValidator()
      {
         super();
      }
      
      public static function validateZipCode(validator:ZipCodeValidator, value:Object, baseField:String) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var c:String = null;
         var message:String = null;
         var valid:Boolean = false;
         var validationResult:ValidationResult = null;
         var results:Array = [];
         var allowedFormatChars:String = validator.allowedFormatChars;
         var domain:String = validator.domain;
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var zip:String = String(value);
         var len:int = zip.length;
         var domainType:uint = DOMAIN_US;
         switch(domain)
         {
            case ZipCodeValidatorDomainType.US_OR_CANADA:
               domainType = DOMAIN_US_OR_CANADA;
               break;
            case ZipCodeValidatorDomainType.US_ONLY:
               domainType = DOMAIN_US;
               break;
            case ZipCodeValidatorDomainType.CANADA_ONLY:
               domainType = DOMAIN_CANADA;
               break;
            default:
               results.push(new ValidationResult(true,baseField,"invalidDomain",validator.invalidDomainError));
               return results;
         }
         n = allowedFormatChars.length;
         for(i = 0; i < n; i++)
         {
            c = allowedFormatChars.charAt(i);
            if(DECIMAL_DIGITS.indexOf(c) != -1 || ROMAN_LETTERS.indexOf(c) != -1)
            {
               message = resourceManager.getString("validators","invalidFormatCharsZCV");
               throw new Error(message);
            }
         }
         for(i = 0; i < len; i++)
         {
            c = zip.charAt(i);
            if(ROMAN_LETTERS.indexOf(c) == -1 && DECIMAL_DIGITS.indexOf(c) == -1 && allowedFormatChars.indexOf(c) == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
         }
         var containsLetters:Boolean = false;
         for(i = 0; i < len; i++)
         {
            if(ROMAN_LETTERS.indexOf(zip.charAt(i)) != -1)
            {
               containsLetters = true;
               break;
            }
         }
         if(len < 5 || len > 10 || len == 8 || !containsLetters && (len == 6 || len == 7))
         {
            results.push(new ValidationResult(true,baseField,"wrongLength",validator.wrongLengthError));
            return results;
         }
         switch(domainType)
         {
            case DOMAIN_US:
               if(validator.validateUSCode(zip,containsLetters) == false)
               {
                  results.push(new ValidationResult(true,baseField,"wrongUSFormat",validator.wrongUSFormatError));
                  return results;
               }
               break;
            case DOMAIN_CANADA:
               if(validator.validateCACode(zip,containsLetters) == false)
               {
                  results.push(new ValidationResult(true,baseField,"wrongCAFormat",validator.wrongCAFormatError));
                  return results;
               }
               break;
            case DOMAIN_US_OR_CANADA:
               valid = true;
               if(len == 5 || len == 9 || len == 10)
               {
                  if(validator.validateUSCode(zip,containsLetters) == false)
                  {
                     validationResult = new ValidationResult(true,baseField,"wrongUSFormat",validator.wrongUSFormatError);
                     valid = false;
                  }
               }
               else if(validator.validateCACode(zip,containsLetters) == false)
               {
                  validationResult = new ValidationResult(true,baseField,"wrongCAFormat",validator.wrongCAFormatError);
                  valid = false;
               }
               if(!valid)
               {
                  results.push(validationResult);
                  return results;
               }
         }
         return results;
      }
      
      private function validateUSCode(zip:String, containsLetters:Boolean) : Boolean
      {
         var i:uint = 0;
         var len:int = zip.length;
         if(containsLetters)
         {
            return false;
         }
         for(i = 0; i < 5; i++)
         {
            if(DECIMAL_DIGITS.indexOf(zip.charAt(i)) == -1)
            {
               return false;
            }
         }
         if(len == 9 || len == 10)
         {
            if(len == 10)
            {
               if(this.allowedFormatChars.indexOf(zip.charAt(5)) == -1)
               {
                  return false;
               }
               i++;
            }
            while(i < len)
            {
               if(DECIMAL_DIGITS.indexOf(zip.charAt(i)) == -1)
               {
                  return false;
               }
               i++;
            }
         }
         return true;
      }
      
      private function validateCACode(zip:String, containsLetters:Boolean) : Boolean
      {
         var len:int = zip.length;
         if(!containsLetters)
         {
            return false;
         }
         var i:uint = 0;
         if(ROMAN_LETTERS.indexOf(zip.charAt(i++)) == -1 || DECIMAL_DIGITS.indexOf(zip.charAt(i++)) == -1 || ROMAN_LETTERS.indexOf(zip.charAt(i++)) == -1)
         {
            return false;
         }
         if(len == 7 && this.allowedFormatChars.indexOf(zip.charAt(i++)) == -1)
         {
            return false;
         }
         if(DECIMAL_DIGITS.indexOf(zip.charAt(i++)) == -1 || ROMAN_LETTERS.indexOf(zip.charAt(i++)) == -1 || DECIMAL_DIGITS.indexOf(zip.charAt(i++)) == -1)
         {
            return false;
         }
         return true;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowedFormatChars() : String
      {
         return this._allowedFormatChars;
      }
      
      public function set allowedFormatChars(value:String) : void
      {
         var i:int = 0;
         var c:String = null;
         var message:String = null;
         if(value != null)
         {
            for(i = 0; i < value.length; i++)
            {
               c = value.charAt(i);
               if(DECIMAL_DIGITS.indexOf(c) != -1 || ROMAN_LETTERS.indexOf(c) != -1)
               {
                  message = resourceManager.getString("validators","invalidFormatCharsZCV");
                  throw new Error(message);
               }
            }
         }
         this.allowedFormatCharsOverride = value;
         this._allowedFormatChars = value != null ? value : resourceManager.getString("validators","zipCodeValidatorAllowedFormatChars");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get domain() : String
      {
         return this._domain;
      }
      
      public function set domain(value:String) : void
      {
         this.domainOverride = value;
         this._domain = value != null ? value : resourceManager.getString("validators","zipCodeValidatorDomain");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return this._invalidCharError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         this.invalidCharErrorOverride = value;
         this._invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorZCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidDomainError() : String
      {
         return this._invalidDomainError;
      }
      
      public function set invalidDomainError(value:String) : void
      {
         this.invalidDomainErrorOverride = value;
         this._invalidDomainError = value != null ? value : resourceManager.getString("validators","invalidDomainErrorZCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongCAFormatError() : String
      {
         return this._wrongCAFormatError;
      }
      
      public function set wrongCAFormatError(value:String) : void
      {
         this.wrongCAFormatErrorOverride = value;
         this._wrongCAFormatError = value != null ? value : resourceManager.getString("validators","wrongCAFormatError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongLengthError() : String
      {
         return this._wrongLengthError;
      }
      
      public function set wrongLengthError(value:String) : void
      {
         this.wrongLengthErrorOverride = value;
         this._wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorZCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongUSFormatError() : String
      {
         return this._wrongUSFormatError;
      }
      
      public function set wrongUSFormatError(value:String) : void
      {
         this.wrongUSFormatErrorOverride = value;
         this._wrongUSFormatError = value != null ? value : resourceManager.getString("validators","wrongUSFormatError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.allowedFormatChars = this.allowedFormatCharsOverride;
         this.domain = this.domainOverride;
         this.invalidDomainError = this.invalidDomainErrorOverride;
         this.invalidCharError = this.invalidCharErrorOverride;
         this.wrongCAFormatError = this.wrongCAFormatErrorOverride;
         this.wrongLengthError = this.wrongLengthErrorOverride;
         this.wrongUSFormatError = this.wrongUSFormatErrorOverride;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return ZipCodeValidator.validateZipCode(this,value,null);
      }
   }
}

