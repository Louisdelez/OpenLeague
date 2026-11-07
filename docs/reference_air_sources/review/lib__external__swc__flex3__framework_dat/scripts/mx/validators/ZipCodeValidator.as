package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class ZipCodeValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const DOMAIN_US:uint = 1;
      
      private static const DOMAIN_US_OR_CANADA:uint = 2;
      
      private static const DOMAIN_CANADA:uint = 3;
      
      private var invalidCharErrorOverride:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var _invalidDomainError:String;
      
      private var wrongLengthErrorOverride:String;
      
      private var invalidDomainErrorOverride:String;
      
      private var wrongUSFormatErrorOverride:String;
      
      private var _domain:String;
      
      private var _wrongCAFormatError:String;
      
      private var _wrongUSFormatError:String;
      
      private var domainOverride:String;
      
      private var wrongCAFormatErrorOverride:String;
      
      private var _invalidCharError:String;
      
      private var _wrongLengthError:String;
      
      private var _allowedFormatChars:String;
      
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
         if(len == 7 && allowedFormatChars.indexOf(zip.charAt(i++)) == -1)
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
      public function get domain() : String
      {
         return _domain;
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
               if(allowedFormatChars.indexOf(zip.charAt(5)) == -1)
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
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongCAFormatError() : String
      {
         return _wrongCAFormatError;
      }
      
      public function set domain(value:String) : void
      {
         domainOverride = value;
         _domain = value != null ? value : resourceManager.getString("validators","zipCodeValidatorDomain");
      }
      
      public function set wrongCAFormatError(value:String) : void
      {
         wrongCAFormatErrorOverride = value;
         _wrongCAFormatError = value != null ? value : resourceManager.getString("validators","wrongCAFormatError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongLengthError() : String
      {
         return _wrongLengthError;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         allowedFormatChars = allowedFormatCharsOverride;
         domain = domainOverride;
         invalidDomainError = invalidDomainErrorOverride;
         invalidCharError = invalidCharErrorOverride;
         wrongCAFormatError = wrongCAFormatErrorOverride;
         wrongLengthError = wrongLengthErrorOverride;
         wrongUSFormatError = wrongUSFormatErrorOverride;
      }
      
      public function set invalidDomainError(value:String) : void
      {
         invalidDomainErrorOverride = value;
         _invalidDomainError = value != null ? value : resourceManager.getString("validators","invalidDomainErrorZCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
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
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowedFormatChars() : String
      {
         return _allowedFormatChars;
      }
      
      public function set wrongLengthError(value:String) : void
      {
         wrongLengthErrorOverride = value;
         _wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorZCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidDomainError() : String
      {
         return _invalidDomainError;
      }
      
      public function set wrongUSFormatError(value:String) : void
      {
         wrongUSFormatErrorOverride = value;
         _wrongUSFormatError = value != null ? value : resourceManager.getString("validators","wrongUSFormatError");
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorZCV");
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
         allowedFormatCharsOverride = value;
         _allowedFormatChars = value != null ? value : resourceManager.getString("validators","zipCodeValidatorAllowedFormatChars");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongUSFormatError() : String
      {
         return _wrongUSFormatError;
      }
   }
}

