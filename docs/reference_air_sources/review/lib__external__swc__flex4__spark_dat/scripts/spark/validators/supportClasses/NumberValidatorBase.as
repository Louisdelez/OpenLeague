package spark.validators.supportClasses
{
   import mx.validators.NumberValidatorDomainType;
   import mx.validators.ValidationResult;
   import spark.formatters.CurrencyFormatter;
   import spark.formatters.NumberFormatter;
   import spark.globalization.LastOperationStatus;
   
   public class NumberValidatorBase extends GlobalizationValidatorBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const ALLOW_NEGATIVE:String = "allowNegative";
      
      private static const DECIMAL_SEPARATOR:String = "decimalSeparator";
      
      private static const DIGITS_TYPE:String = "digitsType";
      
      private static const FRACTIONAL_DIGITS:String = "fractionalDigits";
      
      private static const GROUPING_SEPARATOR:String = "groupingSeparator";
      
      private static const NEGATIVE_SYMBOL:String = "negativeSymbol";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const NUMBER_VALIDATOR_TYPE:int = 1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const CURRENCY_VALIDATOR_TYPE:int = 2;
      
      private static const NEGATIVE_SYMBOLS:String = "-" + String.fromCharCode(8722,65123,65293);
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VALID_CHARS:String = DECIMAL_DIGITS + "(" + ")" + NEGATIVE_SYMBOLS;
      
      private static const PATTERN_LENGTH_LIMIT:int = 10;
      
      private static const DECIMAL_SEP_STD:String = ".";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const DECIMAL_DIGITS:String = "0123456789";
      
      private var _g11nWorkingInstance:Object = null;
      
      private var _allowNegative:Boolean;
      
      protected var allowNegativeOverride:Boolean;
      
      private var _domain:String;
      
      protected var domainOverride:String = "real";
      
      private var _maxValue:Number;
      
      protected var maxValueOverride:Number;
      
      private var _minValue:Number;
      
      protected var minValueOverride:Number;
      
      private var _decimalPointCountError:String;
      
      protected var decimalPointCountErrorOverride:String;
      
      private var _fractionalDigitsError:String;
      
      protected var fractionalDigitsErrorOverride:String;
      
      private var _greaterThanMaxError:String;
      
      protected var greaterThanMaxErrorOverride:String;
      
      private var _invalidCharError:String;
      
      protected var invalidCharErrorOverride:String;
      
      private var _invalidFormatCharsError:String;
      
      protected var invalidFormatCharsErrorOverride:String;
      
      private var _lessThanMinError:String;
      
      protected var lessThanMinErrorOverride:String;
      
      private var _localeUndefinedError:String;
      
      protected var localeUndefinedErrorOverride:String;
      
      private var _negativeError:String;
      
      protected var negativeErrorOverride:String;
      
      private var _negativeSymbolError:String;
      
      protected var negativeSymbolErrorOverride:String;
      
      private var _notAnIntegerError:String;
      
      protected var notAnIntegerErrorOverride:String;
      
      private var _parseError:String;
      
      protected var parseErrorOverride:String;
      
      public function NumberValidatorBase()
      {
         super();
         this._allowNegative = this.allowNegativeOverride = resourceManager.getBoolean("validators","allowNegative");
         this._domain = NumberValidatorDomainType.REAL;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get g11nWorkingInstance() : Object
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set g11nWorkingInstance(sparkFormatter:Object) : void
      {
         this._g11nWorkingInstance = sparkFormatter;
      }
      
      [Bindable("change")]
      override public function get lastOperationStatus() : String
      {
         return Boolean(this.g11nWorkingInstance) ? this.g11nWorkingInstance.lastOperationStatus : fallbackLastOperationStatus;
      }
      
      [Bindable("change")]
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get useFallback() : Boolean
      {
         return this.g11nWorkingInstance.useFallback;
      }
      
      [Bindable("change")]
      [Inspectable(category="General",defaultValue="true")]
      public function get allowNegative() : Boolean
      {
         return this._allowNegative;
      }
      
      public function set allowNegative(value:Boolean) : void
      {
         this.allowNegativeOverride = value;
         this._allowNegative = value;
         update();
      }
      
      [Bindable("change")]
      public function get decimalSeparator() : String
      {
         return getBasicProperty(properties,DECIMAL_SEPARATOR);
      }
      
      public function set decimalSeparator(value:String) : void
      {
         setBasicProperty(properties,DECIMAL_SEPARATOR,value);
      }
      
      [Bindable("change")]
      public function get digitsType() : uint
      {
         return getBasicProperty(properties,DIGITS_TYPE);
      }
      
      public function set digitsType(value:uint) : void
      {
         setBasicProperty(properties,DIGITS_TYPE,value);
      }
      
      [Bindable("change")]
      [Inspectable(category="General",enumeration="int,real",defaultValue="real")]
      public function get domain() : String
      {
         return this._domain;
      }
      
      public function set domain(value:String) : void
      {
         this.domainOverride = value;
         if(!value)
         {
            this._domain = resourceManager.getString("validators","numberValidatorDomain");
         }
         else
         {
            if(value != NumberValidatorDomainType.INT && value != NumberValidatorDomainType.REAL)
            {
               throw new ArgumentError();
            }
            this._domain = value;
         }
         update();
      }
      
      [Inspectable(category="General",minValue="0")]
      [Bindable("change")]
      public function get fractionalDigits() : int
      {
         return getBasicProperty(properties,FRACTIONAL_DIGITS);
      }
      
      public function set fractionalDigits(value:int) : void
      {
         setBasicProperty(properties,FRACTIONAL_DIGITS,value);
      }
      
      [Bindable("change")]
      public function get groupingSeparator() : String
      {
         return getBasicProperty(properties,GROUPING_SEPARATOR);
      }
      
      public function set groupingSeparator(value:String) : void
      {
         setBasicProperty(properties,GROUPING_SEPARATOR,value);
      }
      
      [Bindable("change")]
      [Inspectable(category="General",defaultValue="null")]
      public function get maxValue() : Number
      {
         return this._maxValue;
      }
      
      public function set maxValue(value:Number) : void
      {
         this.maxValueOverride = value;
         this._maxValue = value;
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="General",defaultValue="null")]
      public function get minValue() : Number
      {
         return this._minValue;
      }
      
      public function set minValue(value:Number) : void
      {
         this.minValueOverride = value;
         this._minValue = value;
         update();
      }
      
      [Bindable("change")]
      public function get negativeSymbol() : String
      {
         return getBasicProperty(properties,NEGATIVE_SYMBOL);
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get decimalPointCountError() : String
      {
         return this._decimalPointCountError;
      }
      
      public function set decimalPointCountError(value:String) : void
      {
         if(Boolean(this.decimalPointCountErrorOverride) && this.decimalPointCountErrorOverride == value)
         {
            return;
         }
         this.decimalPointCountErrorOverride = value;
         this._decimalPointCountError = Boolean(value) ? value : resourceManager.getString("validators","decimalPointCountError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get fractionalDigitsError() : String
      {
         return this._fractionalDigitsError;
      }
      
      public function set fractionalDigitsError(value:String) : void
      {
         if(Boolean(this.fractionalDigitsErrorOverride) && this.fractionalDigitsErrorOverride == value)
         {
            return;
         }
         this.fractionalDigitsErrorOverride = value;
         this._fractionalDigitsError = Boolean(value) ? value : resourceManager.getString("validators","fractionalDigitsError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get greaterThanMaxError() : String
      {
         return this._greaterThanMaxError;
      }
      
      public function set greaterThanMaxError(value:String) : void
      {
         if(Boolean(this.greaterThanMaxErrorOverride) && this.greaterThanMaxErrorOverride == value)
         {
            return;
         }
         this.greaterThanMaxErrorOverride = value;
         this._greaterThanMaxError = Boolean(value) ? value : resourceManager.getString("validators","exceedsMaxErrorNV");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return this._invalidCharError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         if(Boolean(this.invalidCharErrorOverride) && this.invalidCharErrorOverride == value)
         {
            return;
         }
         this.invalidCharErrorOverride = value;
         this._invalidCharError = Boolean(value) ? value : resourceManager.getString("validators","invalidCharError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidFormatCharsError() : String
      {
         return this._invalidFormatCharsError;
      }
      
      public function set invalidFormatCharsError(value:String) : void
      {
         if(Boolean(this.invalidFormatCharsErrorOverride) && this.invalidFormatCharsErrorOverride == value)
         {
            return;
         }
         this.invalidFormatCharsErrorOverride = value;
         this._invalidFormatCharsError = Boolean(value) ? value : resourceManager.getString("validators","invalidFormatCharsError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get lessThanMinError() : String
      {
         return this._lessThanMinError;
      }
      
      public function set lessThanMinError(value:String) : void
      {
         if(Boolean(this.lessThanMinErrorOverride) && this.lessThanMinErrorOverride == value)
         {
            return;
         }
         this.lessThanMinErrorOverride = value;
         this._lessThanMinError = Boolean(value) ? value : resourceManager.getString("validators","lowerThanMinError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get localeUndefinedError() : String
      {
         return this._localeUndefinedError;
      }
      
      public function set localeUndefinedError(value:String) : void
      {
         if(Boolean(this.localeUndefinedErrorOverride) && this.localeUndefinedErrorOverride == value)
         {
            return;
         }
         this.localeUndefinedErrorOverride = value;
         this._localeUndefinedError = Boolean(value) ? value : resourceManager.getString("validators","localeUndefinedError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get negativeError() : String
      {
         return this._negativeError;
      }
      
      public function set negativeError(value:String) : void
      {
         if(Boolean(this.negativeErrorOverride) && this.negativeErrorOverride == value)
         {
            return;
         }
         this.negativeErrorOverride = value;
         this._negativeError = Boolean(value) ? value : resourceManager.getString("validators","negativeError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get negativeSymbolError() : String
      {
         return this._negativeSymbolError;
      }
      
      public function set negativeSymbolError(value:String) : void
      {
         if(Boolean(this.negativeSymbolErrorOverride) && this.negativeSymbolErrorOverride == value)
         {
            return;
         }
         this.negativeSymbolErrorOverride = value;
         this._negativeSymbolError = Boolean(value) ? value : resourceManager.getString("validators","negativeSymbolError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get notAnIntegerError() : String
      {
         return this._notAnIntegerError;
      }
      
      public function set notAnIntegerError(value:String) : void
      {
         if(Boolean(this.notAnIntegerErrorOverride) && this.notAnIntegerErrorOverride == value)
         {
            return;
         }
         this.notAnIntegerErrorOverride = value;
         this._notAnIntegerError = Boolean(value) ? value : resourceManager.getString("validators","integerError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get parseError() : String
      {
         return this._parseError;
      }
      
      public function set parseError(value:String) : void
      {
         if(Boolean(this.parseErrorOverride) && this.parseErrorOverride == value)
         {
            return;
         }
         this.parseErrorOverride = value;
         this._parseError = Boolean(value) ? value : resourceManager.getString("validators","parseError");
         update();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstanceCore(validatorType:int) : void
      {
         if(validatorType == NUMBER_VALIDATOR_TYPE)
         {
            this.g11nWorkingInstance = new NumberFormatter();
         }
         else if(validatorType == CURRENCY_VALIDATOR_TYPE)
         {
            this.g11nWorkingInstance = new CurrencyFormatter();
         }
         if(!this.g11nWorkingInstance)
         {
            throw new Error("Internal failure: " + "spark formatter creation failure.");
         }
         this.g11nWorkingInstance.enforceFallback = enforceFallback;
         this.g11nWorkingInstance.setStyle("locale",localeStyle);
         if(this.g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            properties = this.g11nWorkingInstance;
            propagateBasicProperties(this.g11nWorkingInstance);
            return;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getActualLocaleIDName(validatorType:int) : String
      {
         if(Boolean(this.g11nWorkingInstance))
         {
            return validatorType == NUMBER_VALIDATOR_TYPE ? (this.g11nWorkingInstance as NumberFormatter).actualLocaleIDName : (this.g11nWorkingInstance as CurrencyFormatter).actualLocaleIDName;
         }
         fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
         return undefined;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function indexOfFirstDigit(input:String, len:int, start:int = 0) : int
      {
         var c0:int = 0;
         var c32:int = 0;
         if(!input || !len)
         {
            return -1;
         }
         for(var i:int = start; i < len; i++)
         {
            c0 = input.charCodeAt(i);
            c32 = this.processSurrogates(input,c0,i,len);
            if(c32 == -1)
            {
               return -1;
            }
            if(this.isDigit(c32))
            {
               return i;
            }
            if(c0 != c32)
            {
               i++;
            }
         }
         return -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function indexOfLastDigit(input:String, len:int, end:int) : int
      {
         var c0:int = 0;
         var c32:int = 0;
         if(!input || !len)
         {
            return -1;
         }
         for(var i:int = end; i >= 0; i--)
         {
            c0 = input.charCodeAt(i);
            c32 = this.processSurrogates(input,c0,i,len);
            if(c32 == -1)
            {
               return -1;
            }
            if(c0 != c32)
            {
               i--;
            }
            if(this.isDigit(c32))
            {
               return i;
            }
         }
         return -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function inputHasMultipleNegativeSymbols(input:String) : Boolean
      {
         var c:String = null;
         if(!input)
         {
            return false;
         }
         var nflag:Boolean = false;
         var gflag:Boolean = false;
         var i:int = 0;
         if(this.negativeSymbol == this.decimalSeparator)
         {
            nflag = true;
         }
         else
         {
            for(i = 0; i < NEGATIVE_SYMBOLS.length; i++)
            {
               c = NEGATIVE_SYMBOLS.charAt(i);
               if(this.decimalSeparator == c)
               {
                  nflag = true;
                  break;
               }
            }
         }
         if(this.negativeSymbol == this.groupingSeparator)
         {
            gflag = true;
         }
         else
         {
            for(i = 0; i < NEGATIVE_SYMBOLS.length; i++)
            {
               c = NEGATIVE_SYMBOLS.charAt(i);
               if(this.groupingSeparator == c)
               {
                  gflag = true;
                  break;
               }
            }
         }
         if(!nflag && !gflag && input.indexOf(this.negativeSymbol) != input.lastIndexOf(this.negativeSymbol))
         {
            return true;
         }
         var nsymbols:String = NEGATIVE_SYMBOLS + this.negativeSymbol;
         var ncount:int = 0;
         for(i = 0; i < input.length; i++)
         {
            c = input.charAt(i);
            if(nsymbols.indexOf(c) != -1)
            {
               ncount++;
            }
         }
         if(!gflag)
         {
            if(!nflag)
            {
               if(ncount > 1)
               {
                  return true;
               }
            }
            else if(ncount > 2)
            {
               return true;
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function inputHasNegativeSymbol(input:String) : Boolean
      {
         var c:String = null;
         if(!input)
         {
            return false;
         }
         if(input.indexOf(this.negativeSymbol) != -1)
         {
            return true;
         }
         for(var i:int = 0; i < input.length; i++)
         {
            c = input.charAt(i);
            if(NEGATIVE_SYMBOLS.indexOf(c) != -1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function isDigit(codepoint:int) : Boolean
      {
         if(GlobalizationUtils.isDigit(codepoint))
         {
            return true;
         }
         if(codepoint >= this.digitsType && codepoint <= this.digitsType + 9)
         {
            return true;
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isNegativeSymbol(input:String) : Boolean
      {
         var c:String = null;
         if(!input)
         {
            return false;
         }
         if(input == this.negativeSymbol)
         {
            return true;
         }
         for(var i:int = 0; i < NEGATIVE_SYMBOLS.length; i++)
         {
            c = NEGATIVE_SYMBOLS.charAt(i);
            if(input == c)
            {
               return true;
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function loadChangedResources() : void
      {
         this.decimalPointCountError = this.decimalPointCountErrorOverride;
         this.greaterThanMaxError = this.greaterThanMaxErrorOverride;
         this.notAnIntegerError = this.notAnIntegerErrorOverride;
         this.invalidCharError = this.invalidCharErrorOverride;
         this.invalidFormatCharsError = this.invalidFormatCharsErrorOverride;
         this.lessThanMinError = this.lessThanMinErrorOverride;
         this.negativeError = this.negativeErrorOverride;
         this.negativeSymbolError = this.negativeSymbolErrorOverride;
         this.fractionalDigitsError = this.fractionalDigitsErrorOverride;
         this.parseError = this.parseErrorOverride;
         this.localeUndefinedError = this.localeUndefinedError;
      }
      
      private function inputHasNoDigits(input:String) : Boolean
      {
         var i:int = 0;
         var c0:int = 0;
         var c1:int = 0;
         if(!input)
         {
            return false;
         }
         while(i < input.length)
         {
            c0 = input.charCodeAt(i);
            c1 = this.processSurrogates(input,c0,i,input.length);
            if(c1 != -1)
            {
               if(c0 != c1)
               {
                  i++;
               }
               if(this.isDigit(c1))
               {
                  return false;
               }
            }
            i++;
         }
         return true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function processSurrogates(input:String, c0:int, index:int, len:int) : int
      {
         var c1:int = 0;
         var j:int = 0;
         if(GlobalizationUtils.isLeadingSurrogate(c0))
         {
            j = index + 1;
            if(j >= len)
            {
               return -1;
            }
            c1 = input.charCodeAt(j);
            if(!GlobalizationUtils.isTrailingSurrogate(c1))
            {
               return -1;
            }
            c0 = int(GlobalizationUtils.surrogateToUTF32(c0,c1));
         }
         else if(GlobalizationUtils.isTrailingSurrogate(c0))
         {
            j = index - 1;
            if(j < 0)
            {
               return -1;
            }
            c1 = input.charCodeAt(j);
            if(!GlobalizationUtils.isLeadingSurrogate(c1))
            {
               return -1;
            }
            c0 = int(GlobalizationUtils.surrogateToUTF32(c1,c0));
         }
         return c0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateDecimalString(input:String, baseField:String, results:Array, negPosLeft:Boolean) : Boolean
      {
         var dindex:int = 0;
         var c:String = null;
         var i:int = 0;
         var c0:int = 0;
         var c1:int = 0;
         var eindex:int = 0;
         if(!input)
         {
            return true;
         }
         if(negPosLeft)
         {
            dindex = input.lastIndexOf(this.decimalSeparator);
         }
         else
         {
            dindex = input.indexOf(this.decimalSeparator);
         }
         if(dindex == -1)
         {
            return true;
         }
         for(i = input.length; i > dindex; i--)
         {
            c0 = input.charCodeAt(i);
            c1 = this.processSurrogates(input,c0,i,eindex);
            if(c1 == -1)
            {
               return false;
            }
            if(this.isDigit(c1))
            {
               break;
            }
            if(c0 != c1)
            {
               i--;
            }
         }
         eindex = i;
         for(i = dindex + this.decimalSeparator.length; i < eindex; )
         {
            c0 = input.charCodeAt(i);
            c1 = this.processSurrogates(input,c0,i,eindex);
            if(!(c1 != -1 && this.isDigit(c1)))
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",this.invalidCharError));
               return false;
            }
            if(c0 != c1)
            {
               i++;
            }
            i++;
         }
         return true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateFractionPart(input:String, decimalSeparatorIndex:int, baseField:String, results:Array) : Boolean
      {
         var numDigitsAfterDecimal:Number = NaN;
         var i:int = 0;
         var c0:int = 0;
         var c32:int = 0;
         if(!input)
         {
            return true;
         }
         var len:int = input.length;
         if(decimalSeparatorIndex != -1)
         {
            numDigitsAfterDecimal = 0;
            if(input == this.decimalSeparator)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",this.invalidCharError));
               return false;
            }
            i = decimalSeparatorIndex + this.decimalSeparator.length;
            c0 = input.charCodeAt(i);
            c32 = this.processSurrogates(input,c0,i,len);
            if(c32 == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",this.invalidCharError));
               return false;
            }
            if(i < len && this.isDigit(c32))
            {
               if(this.domain == NumberValidatorDomainType.INT)
               {
                  results.push(new ValidationResult(true,baseField,"integer",this.notAnIntegerError));
                  return false;
               }
            }
            while(i < len)
            {
               c0 = input.charCodeAt(i);
               c32 = this.processSurrogates(input,c0,i,len);
               if(c32 == -1)
               {
                  results.push(new ValidationResult(true,baseField,"invalidChar",this.invalidCharError));
                  return false;
               }
               if(c0 != c32)
               {
                  i++;
               }
               numDigitsAfterDecimal++;
               if(!this.isDigit(c32))
               {
                  break;
               }
               if(this.fractionalDigits != -1 && numDigitsAfterDecimal > this.fractionalDigits)
               {
                  results.push(new ValidationResult(true,baseField,"fractionalDigits",this.fractionalDigitsError));
                  return false;
               }
               i++;
            }
         }
         return true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateInputCharacters(input:String, len:int, validChars:String) : Boolean
      {
         var c:String = null;
         var c0:int = 0;
         var c32:int = 0;
         if(!input)
         {
            return true;
         }
         for(var i:int = 0; i < len; i++)
         {
            c = input.charAt(i);
            if(validChars.indexOf(c) == -1)
            {
               c0 = c.charCodeAt(0);
               c32 = this.processSurrogates(input,c0,i,len);
               if(c32 == -1)
               {
                  return true;
               }
               if(c0 != c32)
               {
                  i++;
               }
               if(!this.isDigit(c0))
               {
                  if(!GlobalizationUtils.isWhiteSpace(c0))
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateNumberFormat(input:String, results:Array, baseField:String) : Boolean
      {
         var c:String = null;
         if(!input)
         {
            return true;
         }
         var len:int = input.length;
         if(input.charAt(0) == "(")
         {
            if(input.charAt(len - 1) != ")")
            {
               results.push(new ValidationResult(true,baseField,"invalidFormatChars",this.invalidFormatCharsError));
               return false;
            }
         }
         else if(input.charAt(len - 1) == ")")
         {
            if(input.charAt(0) != "(")
            {
               results.push(new ValidationResult(true,baseField,"invalidFormatCharsError",this.invalidFormatCharsError));
               return false;
            }
         }
         if(this.decimalSeparator == this.groupingSeparator)
         {
            results.push(new ValidationResult(true,baseField,"invalidFormatChars",this.invalidFormatCharsError));
            return false;
         }
         if(this.inputHasNoDigits(input))
         {
            results.push(new ValidationResult(true,baseField,"parseError",this.parseError));
            return false;
         }
         if(this.inputHasMultipleNegativeSymbols(input))
         {
            results.push(new ValidationResult(true,baseField,"negativeSymbol",this.negativeSymbolError));
            return false;
         }
         return true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateNumberNegativity(inputNum:Number, baseField:String, results:Array) : Boolean
      {
         if(inputNum < 0)
         {
            if(!this.allowNegative)
            {
               results.push(new ValidationResult(true,baseField,"negative",this.negativeError));
               return false;
            }
         }
         return true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function validateNumberRange(num:Number, baseField:String, results:Array) : Boolean
      {
         var maxValue:Number = Number(this.maxValue);
         var minValue:Number = Number(this.minValue);
         if(!isNaN(minValue) || !isNaN(maxValue))
         {
            if(!isNaN(minValue) && num < minValue)
            {
               results.push(new ValidationResult(true,baseField,"lowerThanMin",this.lessThanMinError));
               return false;
            }
            if(!isNaN(maxValue) && num > maxValue)
            {
               results.push(new ValidationResult(true,baseField,"exceedsMax",this.greaterThanMaxError));
               return false;
            }
         }
         return true;
      }
   }
}

