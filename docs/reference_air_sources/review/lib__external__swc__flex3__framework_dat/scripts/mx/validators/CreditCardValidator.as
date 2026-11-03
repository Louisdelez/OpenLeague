package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class CreditCardValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var invalidCharErrorOverride:String;
      
      private var noTypeErrorOverride:String;
      
      private var _cardTypeListener:IValidatorListener;
      
      private var _noNumError:String;
      
      private var invalidNumberErrorOverride:String;
      
      private var _wrongLengthError:String;
      
      private var wrongLengthErrorOverride:String;
      
      private var _cardTypeSource:Object;
      
      private var allowedFormatCharsOverride:String;
      
      private var wrongTypeErrorOverride:String;
      
      private var _cardNumberSource:Object;
      
      [Inspectable(category="General")]
      public var cardTypeProperty:String;
      
      private var _wrongTypeError:String;
      
      private var _invalidNumberError:String;
      
      private var _cardNumberListener:IValidatorListener;
      
      private var _noTypeError:String;
      
      [Inspectable(category="General")]
      public var cardNumberProperty:String;
      
      private var noNumErrorOverride:String;
      
      private var _invalidCharError:String;
      
      private var _allowedFormatChars:String;
      
      public function CreditCardValidator()
      {
         super();
         subFields = ["cardNumber","cardType"];
      }
      
      public static function validateCreditCard(validator:CreditCardValidator, value:Object, baseField:String) : Array
      {
         var doubledigit:Boolean;
         var correctLen:Number;
         var cardNumLen:int;
         var checkdigit:int;
         var correctLen2:Number;
         var correctPrefixArray:Array;
         var foundPrefix:Boolean;
         var resourceManager:IResourceManager = null;
         var message:String = null;
         var n:int = 0;
         var i:int = 0;
         var tempdigit:int = 0;
         var temp:String = null;
         var results:Array = [];
         var allowedFormatChars:String = validator.allowedFormatChars;
         resourceManager = ResourceManager.getInstance();
         var baseFieldDot:String = Boolean(baseField) ? baseField + "." : "";
         var valid:String = DECIMAL_DIGITS + allowedFormatChars;
         var cardType:String = null;
         var cardNum:String = null;
         var digitsOnlyCardNum:String = "";
         try
         {
            cardType = String(value.cardType);
         }
         catch(e:Error)
         {
            message = resourceManager.getString("validators","missingCardType");
            throw new Error(message);
         }
         try
         {
            cardNum = value.cardNumber;
         }
         catch(f:Error)
         {
            message = resourceManager.getString("validators","missingCardNumber");
            throw new Error(message);
         }
         if(validator.required)
         {
            if(cardType.length == 0)
            {
               results.push(new ValidationResult(true,baseFieldDot + "cardType","requiredField",validator.requiredFieldError));
            }
            if(!cardNum)
            {
               results.push(new ValidationResult(true,baseFieldDot + "cardNumber","requiredField",validator.requiredFieldError));
            }
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
         if(!cardType)
         {
            results.push(new ValidationResult(true,baseFieldDot + "cardType","noType",validator.noTypeError));
         }
         else if(cardType != CreditCardValidatorCardType.MASTER_CARD && cardType != CreditCardValidatorCardType.VISA && cardType != CreditCardValidatorCardType.AMERICAN_EXPRESS && cardType != CreditCardValidatorCardType.DISCOVER && cardType != CreditCardValidatorCardType.DINERS_CLUB)
         {
            results.push(new ValidationResult(true,baseFieldDot + "cardType","wrongType",validator.wrongTypeError));
         }
         if(!cardNum)
         {
            results.push(new ValidationResult(true,baseFieldDot + "cardNumber","noNum",validator.noNumError));
         }
         if(Boolean(cardNum))
         {
            n = cardNum.length;
            for(i = 0; i < n; i++)
            {
               temp = "" + cardNum.substring(i,i + 1);
               if(valid.indexOf(temp) == -1)
               {
                  results.push(new ValidationResult(true,baseFieldDot + "cardNumber","invalidChar",validator.invalidCharError));
               }
               if(DECIMAL_DIGITS.indexOf(temp) != -1)
               {
                  digitsOnlyCardNum += temp;
               }
            }
         }
         if(results.length > 0)
         {
            return results;
         }
         cardNumLen = digitsOnlyCardNum.toString().length;
         correctLen = -1;
         correctLen2 = -1;
         correctPrefixArray = [];
         if(cardType == CreditCardValidatorCardType.DINERS_CLUB && digitsOnlyCardNum.charAt(0) == "5")
         {
            cardType = CreditCardValidatorCardType.MASTER_CARD;
         }
         switch(cardType)
         {
            case CreditCardValidatorCardType.MASTER_CARD:
               correctLen = 16;
               correctPrefixArray.push("51");
               correctPrefixArray.push("52");
               correctPrefixArray.push("53");
               correctPrefixArray.push("54");
               correctPrefixArray.push("55");
               break;
            case CreditCardValidatorCardType.VISA:
               correctLen = 13;
               correctLen2 = 16;
               correctPrefixArray.push("4");
               break;
            case CreditCardValidatorCardType.AMERICAN_EXPRESS:
               correctLen = 15;
               correctPrefixArray.push("34");
               correctPrefixArray.push("37");
               break;
            case CreditCardValidatorCardType.DISCOVER:
               correctLen = 16;
               correctPrefixArray.push("6011");
               break;
            case CreditCardValidatorCardType.DINERS_CLUB:
               correctLen = 14;
               correctPrefixArray.push("300");
               correctPrefixArray.push("301");
               correctPrefixArray.push("302");
               correctPrefixArray.push("303");
               correctPrefixArray.push("304");
               correctPrefixArray.push("305");
               correctPrefixArray.push("36");
               correctPrefixArray.push("38");
               break;
            default:
               results.push(new ValidationResult(true,baseFieldDot + "cardType","wrongType",validator.wrongTypeError));
               return results;
         }
         if(cardNumLen != correctLen && cardNumLen != correctLen2)
         {
            results.push(new ValidationResult(true,baseFieldDot + "cardNumber","wrongLength",validator.wrongLengthError));
            return results;
         }
         foundPrefix = false;
         for(i = correctPrefixArray.length - 1; i >= 0; i--)
         {
            if(digitsOnlyCardNum.indexOf(correctPrefixArray[i]) == 0)
            {
               foundPrefix = true;
               break;
            }
         }
         if(!foundPrefix)
         {
            results.push(new ValidationResult(true,baseFieldDot + "cardNumber","invalidNumber",validator.invalidNumberError));
            return results;
         }
         doubledigit = false;
         checkdigit = 0;
         for(i = cardNumLen - 1; i >= 0; i--)
         {
            tempdigit = Number(digitsOnlyCardNum.charAt(i));
            if(doubledigit)
            {
               tempdigit *= 2;
               checkdigit += tempdigit % 10;
               if(tempdigit / 10 >= 1)
               {
                  checkdigit++;
               }
               doubledigit = false;
            }
            else
            {
               checkdigit += tempdigit;
               doubledigit = true;
            }
         }
         if(checkdigit % 10 != 0)
         {
            results.push(new ValidationResult(true,baseFieldDot + "cardNumber","invalidNumber",validator.invalidNumberError));
            return results;
         }
         return results;
      }
      
      override protected function getValueFromSource() : Object
      {
         var useValue:Boolean = false;
         var value:Object = {};
         if(Boolean(cardTypeSource) && Boolean(cardTypeProperty))
         {
            value.cardType = cardTypeSource[cardTypeProperty];
            useValue = true;
         }
         if(Boolean(cardNumberSource) && Boolean(cardNumberProperty))
         {
            value.cardNumber = cardNumberSource[cardNumberProperty];
            useValue = true;
         }
         if(useValue)
         {
            return value;
         }
         return super.getValueFromSource();
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noNumError() : String
      {
         return _noNumError;
      }
      
      public function set noNumError(value:String) : void
      {
         noNumErrorOverride = value;
         _noNumError = value != null ? value : resourceManager.getString("validators","noNumError");
      }
      
      public function set wrongTypeError(value:String) : void
      {
         wrongTypeErrorOverride = value;
         _wrongTypeError = value != null ? value : resourceManager.getString("validators","wrongTypeError");
      }
      
      public function set invalidNumberError(value:String) : void
      {
         invalidNumberErrorOverride = value;
         _invalidNumberError = value != null ? value : resourceManager.getString("validators","invalidNumberError");
      }
      
      public function set cardNumberListener(value:IValidatorListener) : void
      {
         if(_cardNumberListener == value)
         {
            return;
         }
         removeListenerHandler();
         _cardNumberListener = value;
         addListenerHandler();
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
      }
      
      [Inspectable(category="General")]
      public function get cardTypeSource() : Object
      {
         return _cardTypeSource;
      }
      
      public function set wrongLengthError(value:String) : void
      {
         wrongLengthErrorOverride = value;
         _wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorCCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noTypeError() : String
      {
         return _noTypeError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorCCV");
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
         _allowedFormatChars = value != null ? value : resourceManager.getString("validators","creditCardValidatorAllowedFormatChars");
      }
      
      [Inspectable(category="General")]
      public function get cardTypeListener() : IValidatorListener
      {
         return _cardTypeListener;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidNumberError() : String
      {
         return _invalidNumberError;
      }
      
      [Inspectable(category="General")]
      public function get cardNumberListener() : IValidatorListener
      {
         return _cardNumberListener;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongTypeError() : String
      {
         return _wrongTypeError;
      }
      
      override protected function get actualListeners() : Array
      {
         var typeResult:Object = null;
         var numResult:Object = null;
         var results:Array = [];
         if(Boolean(_cardTypeListener))
         {
            typeResult = _cardTypeListener;
         }
         else if(Boolean(_cardTypeSource))
         {
            typeResult = _cardTypeSource;
         }
         results.push(typeResult);
         if(typeResult is IValidatorListener)
         {
            IValidatorListener(typeResult).validationSubField = "cardType";
         }
         if(Boolean(_cardNumberListener))
         {
            numResult = _cardNumberListener;
         }
         else if(Boolean(_cardNumberSource))
         {
            numResult = _cardNumberSource;
         }
         results.push(numResult);
         if(numResult is IValidatorListener)
         {
            IValidatorListener(numResult).validationSubField = "cardNumber";
         }
         if(results.length > 0 && Boolean(listener))
         {
            results.push(listener);
         }
         return results;
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
         invalidCharError = invalidCharErrorOverride;
         invalidNumberError = invalidNumberErrorOverride;
         noNumError = noNumErrorOverride;
         noTypeError = noTypeErrorOverride;
         wrongLengthError = wrongLengthErrorOverride;
         wrongTypeError = wrongTypeErrorOverride;
      }
      
      public function set cardTypeSource(value:Object) : void
      {
         var message:String = null;
         if(_cardTypeSource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","CTSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         _cardTypeSource = value;
         addListenerHandler();
      }
      
      public function set noTypeError(value:String) : void
      {
         noTypeErrorOverride = value;
         _noTypeError = value != null ? value : resourceManager.getString("validators","noTypeError");
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
         return CreditCardValidator.validateCreditCard(this,value,null);
      }
      
      public function set cardNumberSource(value:Object) : void
      {
         var message:String = null;
         if(_cardNumberSource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","CNSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         _cardNumberSource = value;
         addListenerHandler();
      }
      
      [Inspectable(category="General")]
      public function get cardNumberSource() : Object
      {
         return _cardNumberSource;
      }
      
      public function set cardTypeListener(value:IValidatorListener) : void
      {
         if(_cardTypeListener == value)
         {
            return;
         }
         removeListenerHandler();
         _cardTypeListener = value;
         addListenerHandler();
      }
   }
}

