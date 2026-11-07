package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class SocialSecurityValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _allowedFormatChars:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var _invalidCharError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var _wrongFormatError:String;
      
      private var wrongFormatErrorOverride:String;
      
      private var _zeroStartError:String;
      
      private var zeroStartErrorOverride:String;
      
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
         this._allowedFormatChars = value != null ? value : resourceManager.getString("validators","socialSecurityValidatorAllowedFormatChars");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return this._invalidCharError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         this.invalidCharErrorOverride = value;
         this._invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorSSV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongFormatError() : String
      {
         return this._wrongFormatError;
      }
      
      public function set wrongFormatError(value:String) : void
      {
         this.wrongFormatErrorOverride = value;
         this._wrongFormatError = value != null ? value : resourceManager.getString("validators","wrongFormatError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get zeroStartError() : String
      {
         return this._zeroStartError;
      }
      
      public function set zeroStartError(value:String) : void
      {
         this.zeroStartErrorOverride = value;
         this._zeroStartError = value != null ? value : resourceManager.getString("validators","zeroStartError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.allowedFormatChars = this.allowedFormatChars;
         this.invalidCharError = this.invalidCharErrorOverride;
         this.wrongFormatError = this.wrongFormatErrorOverride;
         this.zeroStartError = this.zeroStartErrorOverride;
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
   }
}

