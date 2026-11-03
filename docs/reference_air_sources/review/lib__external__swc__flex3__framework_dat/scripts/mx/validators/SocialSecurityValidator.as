package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class SocialSecurityValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var zeroStartErrorOverride:String;
      
      private var _wrongFormatError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var wrongFormatErrorOverride:String;
      
      private var _zeroStartError:String;
      
      private var _invalidCharError:String;
      
      private var _allowedFormatChars:String;
      
      public function SocialSecurityValidator()
      {
         super();
      }
      
      public static function validateSocialSecurity(validator:SocialSecurityValidator, value:Object, baseField:String) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var message:String = null;
         var allowedChars:String = null;
         var results:Array = [];
         var allowedFormatChars:String = validator.allowedFormatChars;
         var resourceManager:IResourceManager = ResourceManager.getInstance();
         var hyphencount:int = 0;
         var len:int = int(value.toString().length);
         var checkForFormatChars:Boolean = false;
         if(len != 9 && len != 11)
         {
            results.push(new ValidationResult(true,baseField,"wrongFormat",validator.wrongFormatError));
            return results;
         }
         n = allowedFormatChars.length;
         for(i = 0; i < n; i++)
         {
            if(DECIMAL_DIGITS.indexOf(allowedFormatChars.charAt(i)) != -1)
            {
               message = resourceManager.getString("validators","invalidFormatChars");
               throw new Error(message);
            }
         }
         if(len == 11)
         {
            checkForFormatChars = true;
         }
         for(i = 0; i < len; i++)
         {
            if(checkForFormatChars && (i == 3 || i == 6))
            {
               allowedChars = allowedFormatChars;
            }
            else
            {
               allowedChars = DECIMAL_DIGITS;
            }
            if(allowedChars.indexOf(value.charAt(i)) == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
         }
         if(value.substring(0,3) == "000")
         {
            results.push(new ValidationResult(true,baseField,"zeroStart",validator.zeroStartError));
            return results;
         }
         return results;
      }
      
      public function set wrongFormatError(value:String) : void
      {
         wrongFormatErrorOverride = value;
         _wrongFormatError = value != null ? value : resourceManager.getString("validators","wrongFormatError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         allowedFormatChars = allowedFormatChars;
         invalidCharError = invalidCharErrorOverride;
         wrongFormatError = wrongFormatErrorOverride;
         zeroStartError = zeroStartErrorOverride;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get zeroStartError() : String
      {
         return _zeroStartError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
      }
      
      public function set zeroStartError(value:String) : void
      {
         zeroStartErrorOverride = value;
         _zeroStartError = value != null ? value : resourceManager.getString("validators","zeroStartError");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowedFormatChars() : String
      {
         return _allowedFormatChars;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongFormatError() : String
      {
         return _wrongFormatError;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return SocialSecurityValidator.validateSocialSecurity(this,value,null);
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorSSV");
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
         _allowedFormatChars = value != null ? value : resourceManager.getString("validators","socialSecurityValidatorAllowedFormatChars");
      }
   }
}

