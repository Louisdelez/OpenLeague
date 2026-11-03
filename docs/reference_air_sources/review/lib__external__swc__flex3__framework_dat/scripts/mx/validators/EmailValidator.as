package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class EmailValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const DISALLOWED_LOCALNAME_CHARS:String = "()<>,;:\\\"[] `~!#$%^&*={}|/?\'";
      
      private static const DISALLOWED_DOMAIN_CHARS:String = "()<>,;:\\\"[] `~!#$%^&*+={}|/?\'";
      
      private var _missingUsernameError:String;
      
      private var tooManyAtSignsErrorOverride:String;
      
      private var _invalidIPDomainError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var invalidPeriodsInDomainErrorOverride:String;
      
      private var invalidIPDomainErrorOverride:String;
      
      private var _invalidDomainError:String;
      
      private var _missingPeriodInDomainError:String;
      
      private var invalidDomainErrorOverride:String;
      
      private var missingPeriodInDomainErrorOverride:String;
      
      private var _invalidPeriodsInDomainError:String;
      
      private var _tooManyAtSignsError:String;
      
      private var _missingAtSignError:String;
      
      private var _invalidCharError:String;
      
      private var missingAtSignErrorOverride:String;
      
      private var missingUsernameErrorOverride:String;
      
      public function EmailValidator()
      {
         super();
      }
      
      public static function validateEmail(validator:EmailValidator, value:Object, baseField:String) : Array
      {
         var n:int = 0;
         var i:int = 0;
         var periodPos:int = 0;
         var nextPeriodPos:int = 0;
         var lastDomain:String = null;
         var results:Array = [];
         var emailStr:String = String(value);
         var username:String = "";
         var domain:String = "";
         var ampPos:int = emailStr.indexOf("@");
         if(ampPos == -1)
         {
            results.push(new ValidationResult(true,baseField,"missingAtSign",validator.missingAtSignError));
            return results;
         }
         if(emailStr.indexOf("@",ampPos + 1) != -1)
         {
            results.push(new ValidationResult(true,baseField,"tooManyAtSigns",validator.tooManyAtSignsError));
            return results;
         }
         username = emailStr.substring(0,ampPos);
         domain = emailStr.substring(ampPos + 1);
         var usernameLen:int = username.length;
         if(usernameLen == 0)
         {
            results.push(new ValidationResult(true,baseField,"missingUsername",validator.missingUsernameError));
            return results;
         }
         for(i = 0; i < usernameLen; i++)
         {
            if(DISALLOWED_LOCALNAME_CHARS.indexOf(username.charAt(i)) != -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
         }
         var domainLen:int = domain.length;
         if(domain.charAt(0) == "[" && domain.charAt(domainLen - 1) == "]")
         {
            if(!isValidIPAddress(domain.substring(1,domainLen - 1)))
            {
               results.push(new ValidationResult(true,baseField,"invalidIPDomain",validator.invalidIPDomainError));
               return results;
            }
         }
         else
         {
            periodPos = domain.indexOf(".");
            nextPeriodPos = 0;
            lastDomain = "";
            if(periodPos == -1)
            {
               results.push(new ValidationResult(true,baseField,"missingPeriodInDomain",validator.missingPeriodInDomainError));
               return results;
            }
            while(true)
            {
               nextPeriodPos = domain.indexOf(".",periodPos + 1);
               if(nextPeriodPos == -1)
               {
                  lastDomain = domain.substring(periodPos + 1);
                  if(lastDomain.length != 3 && lastDomain.length != 2 && lastDomain.length != 4 && lastDomain.length != 6)
                  {
                     results.push(new ValidationResult(true,baseField,"invalidDomain",validator.invalidDomainError));
                     return results;
                  }
                  break;
               }
               if(nextPeriodPos == periodPos + 1)
               {
                  results.push(new ValidationResult(true,baseField,"invalidPeriodsInDomain",validator.invalidPeriodsInDomainError));
                  return results;
               }
               periodPos = nextPeriodPos;
            }
            for(i = 0; i < domainLen; i++)
            {
               if(DISALLOWED_DOMAIN_CHARS.indexOf(domain.charAt(i)) != -1)
               {
                  results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
                  return results;
               }
            }
            if(domain.charAt(0) == ".")
            {
               results.push(new ValidationResult(true,baseField,"invalidDomain",validator.invalidDomainError));
               return results;
            }
         }
         return results;
      }
      
      private static function isValidIPAddress(ipAddr:String) : Boolean
      {
         var item:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var hasUnlimitedZeros:Boolean = false;
         var lastIsV4:Boolean = false;
         var ipArray:Array = [];
         var pos:int = 0;
         var newpos:int = 0;
         if(ipAddr.indexOf(":") != -1)
         {
            hasUnlimitedZeros = ipAddr.indexOf("::") != -1;
            if(hasUnlimitedZeros)
            {
               ipAddr = ipAddr.replace(/^::/,"");
               ipAddr = ipAddr.replace(/::/g,":");
            }
            while(true)
            {
               newpos = ipAddr.indexOf(":",pos);
               if(newpos == -1)
               {
                  ipArray.push(ipAddr.substring(pos));
                  break;
               }
               ipArray.push(ipAddr.substring(pos,newpos));
               pos = newpos + 1;
            }
            n = int(ipArray.length);
            lastIsV4 = ipArray[n - 1].indexOf(".") != -1;
            if(lastIsV4)
            {
               if(ipArray.length != 7 && !hasUnlimitedZeros || ipArray.length > 7)
               {
                  return false;
               }
               for(i = 0; i < n; i++)
               {
                  if(i == n - 1)
                  {
                     return isValidIPAddress(ipArray[i]);
                  }
                  item = parseInt(ipArray[i],16);
                  if(item != 0)
                  {
                     return false;
                  }
               }
            }
            else
            {
               if(ipArray.length != 8 && !hasUnlimitedZeros || ipArray.length > 8)
               {
                  return false;
               }
               for(i = 0; i < n; i++)
               {
                  item = parseInt(ipArray[i],16);
                  if(isNaN(item) || item < 0 || item > 65535)
                  {
                     return false;
                  }
               }
            }
            return true;
         }
         if(ipAddr.indexOf(".") != -1)
         {
            while(true)
            {
               newpos = ipAddr.indexOf(".",pos);
               if(newpos == -1)
               {
                  ipArray.push(ipAddr.substring(pos));
                  break;
               }
               ipArray.push(ipAddr.substring(pos,newpos));
               pos = newpos + 1;
            }
            if(ipArray.length != 4)
            {
               return false;
            }
            n = int(ipArray.length);
            for(i = 0; i < n; i++)
            {
               item = Number(ipArray[i]);
               if(isNaN(item) || item < 0 || item > 255)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      public function set missingAtSignError(value:String) : void
      {
         missingAtSignErrorOverride = value;
         _missingAtSignError = value != null ? value : resourceManager.getString("validators","missingAtSignError");
      }
      
      public function set invalidPeriodsInDomainError(value:String) : void
      {
         invalidPeriodsInDomainErrorOverride = value;
         _invalidPeriodsInDomainError = value != null ? value : resourceManager.getString("validators","invalidPeriodsInDomainError");
      }
      
      public function set invalidIPDomainError(value:String) : void
      {
         invalidIPDomainErrorOverride = value;
         _invalidIPDomainError = value != null ? value : resourceManager.getString("validators","invalidIPDomainError");
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return EmailValidator.validateEmail(this,value,null);
      }
      
      public function set invalidDomainError(value:String) : void
      {
         invalidDomainErrorOverride = value;
         _invalidDomainError = value != null ? value : resourceManager.getString("validators","invalidDomainErrorEV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         invalidCharError = invalidCharErrorOverride;
         invalidDomainError = invalidDomainErrorOverride;
         invalidIPDomainError = invalidIPDomainErrorOverride;
         invalidPeriodsInDomainError = invalidPeriodsInDomainErrorOverride;
         missingAtSignError = missingAtSignErrorOverride;
         missingPeriodInDomainError = missingPeriodInDomainErrorOverride;
         missingUsernameError = missingUsernameErrorOverride;
         tooManyAtSignsError = tooManyAtSignsErrorOverride;
      }
      
      public function set missingUsernameError(value:String) : void
      {
         missingUsernameErrorOverride = value;
         _missingUsernameError = value != null ? value : resourceManager.getString("validators","missingUsernameError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get missingAtSignError() : String
      {
         return _missingAtSignError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidIPDomainError() : String
      {
         return _invalidIPDomainError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get tooManyAtSignsError() : String
      {
         return _tooManyAtSignsError;
      }
      
      public function set tooManyAtSignsError(value:String) : void
      {
         tooManyAtSignsErrorOverride = value;
         _tooManyAtSignsError = value != null ? value : resourceManager.getString("validators","tooManyAtSignsError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidPeriodsInDomainError() : String
      {
         return _invalidPeriodsInDomainError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidDomainError() : String
      {
         return _invalidDomainError;
      }
      
      public function set missingPeriodInDomainError(value:String) : void
      {
         missingPeriodInDomainErrorOverride = value;
         _missingPeriodInDomainError = value != null ? value : resourceManager.getString("validators","missingPeriodInDomainError");
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorEV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get missingPeriodInDomainError() : String
      {
         return _missingPeriodInDomainError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get missingUsernameError() : String
      {
         return _missingUsernameError;
      }
   }
}

