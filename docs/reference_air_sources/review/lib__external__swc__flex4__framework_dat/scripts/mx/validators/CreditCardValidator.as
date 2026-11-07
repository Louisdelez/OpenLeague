package mx.validators
{
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   public class CreditCardValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _allowedFormatChars:String;
      
      private var allowedFormatCharsOverride:String;
      
      private var _cardNumberListener:IValidatorListener;
      
      [Inspectable(category="General")]
      public var cardNumberProperty:String;
      
      private var _cardNumberSource:Object;
      
      private var _cardTypeListener:IValidatorListener;
      
      [Inspectable(category="General")]
      public var cardTypeProperty:String;
      
      private var _cardTypeSource:Object;
      
      private var _invalidCharError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var _invalidNumberError:String;
      
      private var invalidNumberErrorOverride:String;
      
      private var _noNumError:String;
      
      private var noNumErrorOverride:String;
      
      private var _noTypeError:String;
      
      private var noTypeErrorOverride:String;
      
      private var _wrongLengthError:String;
      
      private var wrongLengthErrorOverride:String;
      
      private var _wrongTypeError:String;
      
      private var wrongTypeErrorOverride:String;
      
      public function CreditCardValidator()
      {
         super();
         subFields = ["cardNumber","cardType"];
      }
      
      public static function validateCreditCard(validator:CreditCardValidator, value:Object, baseField:String) : Array
      {
         var cardNumLen:int;
         var correctLen:Number;
         var correctLen2:Number;
         var correctPrefixArray:Array;
         var foundPrefix:Boolean;
         var doubledigit:Boolean;
         var checkdigit:int;
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
      
      override protected function get actualListeners() : Array
      {
         var typeResult:Object = null;
         var numResult:Object = null;
         var results:Array = [];
         if(Boolean(this._cardTypeListener))
         {
            typeResult = this._cardTypeListener;
         }
         else if(Boolean(this._cardTypeSource))
         {
            typeResult = this._cardTypeSource;
         }
         results.push(typeResult);
         if(typeResult is IValidatorListener)
         {
            IValidatorListener(typeResult).validationSubField = "cardType";
         }
         if(Boolean(this._cardNumberListener))
         {
            numResult = this._cardNumberListener;
         }
         else if(Boolean(this._cardNumberSource))
         {
            numResult = this._cardNumberSource;
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
         this._allowedFormatChars = value != null ? value : resourceManager.getString("validators","creditCardValidatorAllowedFormatChars");
      }
      
      [Inspectable(category="General")]
      public function get cardNumberListener() : IValidatorListener
      {
         return this._cardNumberListener;
      }
      
      public function set cardNumberListener(value:IValidatorListener) : void
      {
         if(this._cardNumberListener == value)
         {
            return;
         }
         removeListenerHandler();
         this._cardNumberListener = value;
         addListenerHandler();
      }
      
      [Inspectable(category="General")]
      public function get cardNumberSource() : Object
      {
         return this._cardNumberSource;
      }
      
      public function set cardNumberSource(value:Object) : void
      {
         var message:String = null;
         if(this._cardNumberSource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","CNSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         this._cardNumberSource = value;
         addListenerHandler();
      }
      
      [Inspectable(category="General")]
      public function get cardTypeListener() : IValidatorListener
      {
         return this._cardTypeListener;
      }
      
      public function set cardTypeListener(value:IValidatorListener) : void
      {
         if(this._cardTypeListener == value)
         {
            return;
         }
         removeListenerHandler();
         this._cardTypeListener = value;
         addListenerHandler();
      }
      
      [Inspectable(category="General")]
      public function get cardTypeSource() : Object
      {
         return this._cardTypeSource;
      }
      
      public function set cardTypeSource(value:Object) : void
      {
         var message:String = null;
         if(this._cardTypeSource == value)
         {
            return;
         }
         if(value is String)
         {
            message = resourceManager.getString("validators","CTSAttribute",[value]);
            throw new Error(message);
         }
         removeListenerHandler();
         this._cardTypeSource = value;
         addListenerHandler();
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return this._invalidCharError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         this.invalidCharErrorOverride = value;
         this._invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharErrorCCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidNumberError() : String
      {
         return this._invalidNumberError;
      }
      
      public function set invalidNumberError(value:String) : void
      {
         this.invalidNumberErrorOverride = value;
         this._invalidNumberError = value != null ? value : resourceManager.getString("validators","invalidNumberError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noNumError() : String
      {
         return this._noNumError;
      }
      
      public function set noNumError(value:String) : void
      {
         this.noNumErrorOverride = value;
         this._noNumError = value != null ? value : resourceManager.getString("validators","noNumError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get noTypeError() : String
      {
         return this._noTypeError;
      }
      
      public function set noTypeError(value:String) : void
      {
         this.noTypeErrorOverride = value;
         this._noTypeError = value != null ? value : resourceManager.getString("validators","noTypeError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongLengthError() : String
      {
         return this._wrongLengthError;
      }
      
      public function set wrongLengthError(value:String) : void
      {
         this.wrongLengthErrorOverride = value;
         this._wrongLengthError = value != null ? value : resourceManager.getString("validators","wrongLengthErrorCCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get wrongTypeError() : String
      {
         return this._wrongTypeError;
      }
      
      public function set wrongTypeError(value:String) : void
      {
         this.wrongTypeErrorOverride = value;
         this._wrongTypeError = value != null ? value : resourceManager.getString("validators","wrongTypeError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.allowedFormatChars = this.allowedFormatCharsOverride;
         this.invalidCharError = this.invalidCharErrorOverride;
         this.invalidNumberError = this.invalidNumberErrorOverride;
         this.noNumError = this.noNumErrorOverride;
         this.noTypeError = this.noTypeErrorOverride;
         this.wrongLengthError = this.wrongLengthErrorOverride;
         this.wrongTypeError = this.wrongTypeErrorOverride;
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
      
      override protected function getValueFromSource() : Object
      {
         var useValue:Boolean = false;
         var value:Object = {};
         if(Boolean(this.cardTypeSource) && Boolean(this.cardTypeProperty))
         {
            value.cardType = this.cardTypeSource[this.cardTypeProperty];
            useValue = true;
         }
         if(Boolean(this.cardNumberSource) && Boolean(this.cardNumberProperty))
         {
            value.cardNumber = this.cardNumberSource[this.cardNumberProperty];
            useValue = true;
         }
         if(useValue)
         {
            return value;
         }
         return super.getValueFromSource();
      }
   }
}

