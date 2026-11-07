package spark.validators
{
   import flash.globalization.CurrencyParseResult;
   import mx.validators.ValidationResult;
   import spark.formatters.CurrencyFormatter;
   import spark.globalization.LastOperationStatus;
   import spark.validators.supportClasses.GlobalizationUtils;
   import spark.validators.supportClasses.NumberValidatorBase;
   
   [ResourceBundle("validators")]
   public class CurrencyValidator extends NumberValidatorBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const CURRENCY_SPACE_SEP:String = " ";
      
      private static const CURRENCY_ISOCODE_LEN:uint = 3;
      
      private static const CURRENCY_ISOCODE:String = "currencyISOCode";
      
      private static const CURRENCY_SYMBOL:String = "currencySymbol";
      
      private static const NEGATIVE_CURRENCY_FORMAT:String = "negativeCurrencyFormat";
      
      private static const POSITIVE_CURRENCY_FORMAT:String = "positiveCurrencyFormat";
      
      private var currencySymbolOverride:String;
      
      private var currencyISOCodeOverride:String;
      
      private var _currencyStringError:String;
      
      private var currencyStringErrorOverride:String;
      
      private var _negativeCurrencyFormatError:String;
      
      private var negativeCurrencyFormatErrorOverride:String;
      
      private var _positiveCurrencyFormatError:String;
      
      private var positiveCurrencyFormatErrorOverride:String;
      
      public function CurrencyValidator()
      {
         super();
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         return getActualLocaleIDName(CURRENCY_VALIDATOR_TYPE);
      }
      
      [Bindable("change")]
      public function get currencyISOCode() : String
      {
         if(Boolean(g11nWorkingInstance))
         {
            return g11nWorkingInstance.currencyISOCode;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return properties.currencyISOCode;
      }
      
      public function set currencyISOCode(value:String) : void
      {
         if(Boolean(this.currencyISOCodeOverride) && this.currencyISOCodeOverride == value)
         {
            return;
         }
         this.currencyISOCodeOverride = value;
         if(Boolean(g11nWorkingInstance))
         {
            g11nWorkingInstance.currencyISOCode = value;
         }
         else
         {
            if(!value)
            {
               throw new ArgumentError();
            }
            if(Boolean(properties))
            {
               properties.currencyISOCode = value;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Bindable("change")]
      public function get currencySymbol() : String
      {
         if(Boolean(g11nWorkingInstance))
         {
            return g11nWorkingInstance.currencySymbol;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         return properties.currencySymbol;
      }
      
      public function set currencySymbol(value:String) : void
      {
         if(Boolean(this.currencySymbolOverride) && this.currencySymbolOverride == value)
         {
            return;
         }
         this.currencySymbolOverride = value;
         if(Boolean(g11nWorkingInstance))
         {
            g11nWorkingInstance.currencySymbol = value;
         }
         else
         {
            if(!value)
            {
               throw new ArgumentError();
            }
            if(Boolean(properties))
            {
               properties.currencySymbol = value;
            }
            fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         }
         update();
      }
      
      [Inspectable(category="General",enumeration="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15")]
      [Bindable("change")]
      public function get negativeCurrencyFormat() : uint
      {
         return getBasicProperty(properties,NEGATIVE_CURRENCY_FORMAT);
      }
      
      public function set negativeCurrencyFormat(value:uint) : void
      {
         if(!g11nWorkingInstance)
         {
            if(15 < value)
            {
               throw new TypeError();
            }
         }
         setBasicProperty(properties,NEGATIVE_CURRENCY_FORMAT,value);
      }
      
      [Inspectable(category="General",enumeration="0,1,2,3")]
      [Bindable("change")]
      public function get positiveCurrencyFormat() : uint
      {
         return getBasicProperty(properties,POSITIVE_CURRENCY_FORMAT);
      }
      
      public function set positiveCurrencyFormat(value:uint) : void
      {
         if(!g11nWorkingInstance)
         {
            if(4 < value)
            {
               throw new TypeError();
            }
         }
         setBasicProperty(properties,POSITIVE_CURRENCY_FORMAT,value);
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get currencyStringError() : String
      {
         return this._currencyStringError;
      }
      
      public function set currencyStringError(value:String) : void
      {
         if(Boolean(this.currencyStringErrorOverride) && this.currencyStringErrorOverride == value)
         {
            return;
         }
         this.currencyStringErrorOverride = value;
         this._currencyStringError = Boolean(value) ? value : resourceManager.getString("validators","currencyStringError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get negativeCurrencyFormatError() : String
      {
         return this._negativeCurrencyFormatError;
      }
      
      public function set negativeCurrencyFormatError(value:String) : void
      {
         if(Boolean(this.negativeCurrencyFormatErrorOverride) && this.negativeCurrencyFormatErrorOverride == value)
         {
            return;
         }
         this.negativeCurrencyFormatErrorOverride = value;
         this._negativeCurrencyFormatError = Boolean(value) ? value : resourceManager.getString("validators","negativeCurrencyFormatError");
         update();
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get positiveCurrencyFormatError() : String
      {
         return this._positiveCurrencyFormatError;
      }
      
      public function set positiveCurrencyFormatError(value:String) : void
      {
         if(Boolean(this.positiveCurrencyFormatErrorOverride) && this.positiveCurrencyFormatErrorOverride == value)
         {
            return;
         }
         this.positiveCurrencyFormatErrorOverride = value;
         this._positiveCurrencyFormatError = Boolean(value) ? value : resourceManager.getString("validators","positiveCurrencyFormatError");
         update();
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         loadChangedResources();
         this.negativeCurrencyFormatError = this.negativeCurrencyFormatErrorOverride;
         this.positiveCurrencyFormatError = this.positiveCurrencyFormatErrorOverride;
         this.currencyStringError = this.currencyStringErrorOverride;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return this.validateCurrency(value,null);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstance() : void
      {
         createWorkingInstanceCore(CURRENCY_VALIDATOR_TYPE);
         if(Boolean(g11nWorkingInstance))
         {
            if(Boolean(this.currencySymbolOverride))
            {
               g11nWorkingInstance.currencySymbol = this.currencySymbolOverride;
            }
            if(Boolean(this.currencyISOCodeOverride))
            {
               g11nWorkingInstance.currencyISOCode = this.currencyISOCodeOverride;
            }
         }
      }
      
      [Bindable("change")]
      public function validateCurrency(value:Object, baseField:String) : Array
      {
         var input:String = null;
         var cf:CurrencyFormatter = null;
         var numStart:int = 0;
         var results:Array = [];
         var inputStr:String = String(value);
         if(!inputStr)
         {
            return results;
         }
         if(!g11nWorkingInstance || !g11nWorkingInstance.actualLocaleIDName || g11nWorkingInstance.lastOperationStatus == LastOperationStatus.LOCALE_UNDEFINED_ERROR)
         {
            results.push(new ValidationResult(true,baseField,"localeUndefinedError",localeUndefinedError));
            return results;
         }
         input = GlobalizationUtils.trim(inputStr);
         var len:int = input.length;
         if(!this.validateCurrencyFormat(input,baseField,results))
         {
            return results;
         }
         cf = g11nWorkingInstance as CurrencyFormatter;
         var cpdata:CurrencyParseResult = cf.parse(input);
         if(cf.lastOperationStatus == LastOperationStatus.PARSE_ERROR)
         {
            if(this.detectAndReportProblem(input,cpdata,results,baseField) == false)
            {
               return results;
            }
            results.push(new ValidationResult(true,baseField,"parseError",parseError));
            return results;
         }
         if(!validateNumberNegativity(cpdata.value,baseField,results))
         {
            return results;
         }
         if(!this.validateCurrencyString(cpdata,baseField,results))
         {
            return results;
         }
         numStart = indexOfFirstDigit(input,len);
         var decimalSeparatorIndex:int = input.indexOf(decimalSeparator,numStart);
         if(!validateFractionPart(input,decimalSeparatorIndex,baseField,results))
         {
            return results;
         }
         if(!validateNumberRange(cpdata.value,baseField,results))
         {
            return results;
         }
         return results;
      }
      
      private function checkMultipleDecimals(input:String, results:Array, baseField:String) : Boolean
      {
         var digitIndex:int = 0;
         if(!input)
         {
            return true;
         }
         var len:int = input.length;
         if(!len)
         {
            return true;
         }
         var isoIndex:int = input.indexOf(this.currencySymbol);
         var startIndex:int = 0;
         var endIndex:int = len;
         var numStr:String = input;
         if(isoIndex != -1)
         {
            digitIndex = indexOfFirstDigit(input,len);
            if(digitIndex != -1)
            {
               if(digitIndex > isoIndex)
               {
                  startIndex = digitIndex;
               }
               else
               {
                  endIndex = isoIndex - 1;
               }
               if(startIndex >= 0 && endIndex <= len)
               {
                  numStr = input.substring(startIndex,endIndex);
               }
            }
         }
         var negPosLeft:Boolean = false;
         if(this.negativeCurrencyFormat <= 2 || this.negativeCurrencyFormat == 4 || this.negativeCurrencyFormat == 5 || this.negativeCurrencyFormat == 8 || this.negativeCurrencyFormat == 9 || this.negativeCurrencyFormat == 12 || this.negativeCurrencyFormat == 14 || this.negativeCurrencyFormat == 15)
         {
            negPosLeft = true;
         }
         if(decimalSeparator != negativeSymbol && numStr.indexOf(decimalSeparator) != numStr.lastIndexOf(decimalSeparator))
         {
            results.push(new ValidationResult(true,baseField,"decimalPointCount",decimalPointCountError));
            return false;
         }
         if(!validateDecimalString(numStr,baseField,results,negPosLeft))
         {
            return false;
         }
         return true;
      }
      
      private function detectAndReportProblem(input:String, cpdata:CurrencyParseResult, results:Array, baseField:String) : Boolean
      {
         var len:int = 0;
         len = input.length;
         var inputIsNegative:Boolean = inputHasNegativeSymbol(input) || input.charAt(0) == "(" && input.charAt(len - 1) == ")";
         var inputHasCurrencyStr:Boolean = input.indexOf(this.currencySymbol) != -1 || input.indexOf(this.currencyISOCode) != -1;
         var validChars:String = VALID_CHARS + decimalSeparator + groupingSeparator + this.currencySymbol + this.currencyISOCode;
         if(validateInputCharacters(input,len,validChars))
         {
            results.push(new ValidationResult(true,baseField,"invalidChar",invalidCharError));
            return false;
         }
         if(!this.checkMultipleDecimals(input,results,baseField))
         {
            return false;
         }
         if(input.indexOf(this.currencySymbol) != input.lastIndexOf(this.currencySymbol))
         {
            results.push(new ValidationResult(true,baseField,"currencyString",this.currencyStringError));
            return false;
         }
         if(input.indexOf(this.currencyISOCode) != input.lastIndexOf(this.currencyISOCode))
         {
            results.push(new ValidationResult(true,baseField,"currencyString",this.currencyStringError));
            return false;
         }
         if(inputIsNegative)
         {
            results.push(new ValidationResult(true,baseField,"negativeCurrencyFormat",this.negativeCurrencyFormatError));
            return false;
         }
         if(!inputIsNegative && inputHasCurrencyStr)
         {
            results.push(new ValidationResult(true,baseField,"positiveCurrencyFormat",this.positiveCurrencyFormatError));
            return false;
         }
         return true;
      }
      
      private function validateCurrencyFormat(input:String, baseField:String, results:Array) : Boolean
      {
         if(!validateNumberFormat(input,results,baseField))
         {
            return false;
         }
         if(this.currencyISOCode == decimalSeparator || this.currencyISOCode == groupingSeparator || isNegativeSymbol(this.currencyISOCode))
         {
            results.push(new ValidationResult(true,baseField,"invalidFormatCharsError",invalidFormatCharsError));
            return false;
         }
         if(this.currencySymbol == decimalSeparator || this.currencySymbol == groupingSeparator || isNegativeSymbol(this.currencySymbol))
         {
            results.push(new ValidationResult(true,baseField,"invalidFormatCharsError",invalidFormatCharsError));
            return false;
         }
         return true;
      }
      
      private function validateCurrencyString(cpdata:CurrencyParseResult, baseField:String, results:Array) : Boolean
      {
         if(!cpdata.currencyString)
         {
            return true;
         }
         var sCurString:String = cpdata.currencyString;
         if(sCurString.charCodeAt(sCurString.length - 1) == 8207)
         {
            sCurString = sCurString.substring(0,cpdata.currencyString.length - 1);
         }
         var sCurSym:String = this.currencySymbol;
         if(sCurSym.charCodeAt(sCurSym.length - 1) == 8207)
         {
            sCurSym = sCurSym.substring(0,this.currencySymbol.length - 1);
         }
         var sCurIso:String = this.currencyISOCode;
         if(sCurIso.charCodeAt(sCurIso.length - 1) == 8207)
         {
            sCurIso = sCurIso.substring(0,this.currencyISOCode.length - 1);
         }
         if(sCurIso == sCurString || sCurSym == sCurString)
         {
            return true;
         }
         results.push(new ValidationResult(true,baseField,"currencyString",this.currencyStringError));
         return false;
      }
   }
}

