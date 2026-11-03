package spark.validators
{
   import mx.validators.ValidationResult;
   import spark.formatters.NumberFormatter;
   import spark.globalization.LastOperationStatus;
   import spark.validators.supportClasses.GlobalizationUtils;
   import spark.validators.supportClasses.NumberValidatorBase;
   
   [ResourceBundle("validators")]
   public class NumberValidator extends NumberValidatorBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const NEGATIVE_NUMBER_FORMAT:String = "negativeNumberFormat";
      
      private var _negativeNumberFormatError:String;
      
      private var negativeNumberFormatErrorOverride:String;
      
      public function NumberValidator()
      {
         super();
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         return getActualLocaleIDName(NUMBER_VALIDATOR_TYPE);
      }
      
      [Bindable("change")]
      public function get negativeNumberFormat() : uint
      {
         return getBasicProperty(properties,NEGATIVE_NUMBER_FORMAT);
      }
      
      public function set negativeNumberFormat(value:uint) : void
      {
         if(!g11nWorkingInstance)
         {
            if(4 < value)
            {
               throw new TypeError();
            }
         }
         setBasicProperty(properties,NEGATIVE_NUMBER_FORMAT,value);
      }
      
      [Bindable("change")]
      [Inspectable(category="Errors",defaultValue="null")]
      public function get negativeNumberFormatError() : String
      {
         return this._negativeNumberFormatError;
      }
      
      public function set negativeNumberFormatError(value:String) : void
      {
         if(Boolean(this.negativeNumberFormatErrorOverride) && this.negativeNumberFormatErrorOverride == value)
         {
            return;
         }
         this.negativeNumberFormatErrorOverride = value;
         this._negativeNumberFormatError = Boolean(value) ? value : resourceManager.getString("validators","negativeNumberFormatError");
         update();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstance() : void
      {
         createWorkingInstanceCore(NUMBER_VALIDATOR_TYPE);
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return this.validateNumber(value,null);
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         loadChangedResources();
         this.negativeNumberFormatError = this.negativeNumberFormatErrorOverride;
      }
      
      [Bindable("change")]
      public function validateNumber(value:Object, baseField:String) : Array
      {
         var input:String = null;
         var nf:NumberFormatter = null;
         var dindex:int = 0;
         var maxValue:Number = Number(maxValue);
         var minValue:Number = Number(minValue);
         var inputStr:String = String(value);
         var results:Array = [];
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
         if(!validateNumberFormat(input,results,baseField))
         {
            return results;
         }
         nf = g11nWorkingInstance as NumberFormatter;
         var inputNum:Number = nf.parseNumber(input);
         if(nf.lastOperationStatus == LastOperationStatus.PARSE_ERROR)
         {
            if(!this.detectAndReportProblem(input,baseField,results))
            {
               return results;
            }
            results.push(new ValidationResult(true,baseField,"parseError",parseError));
            return results;
         }
         if(!validateNumberNegativity(inputNum,baseField,results))
         {
            return results;
         }
         if(this.negativeNumberFormat <= 2)
         {
            dindex = input.lastIndexOf(decimalSeparator);
         }
         else
         {
            dindex = input.indexOf(decimalSeparator);
         }
         if(!validateFractionPart(input,dindex,baseField,results))
         {
            return results;
         }
         if(!validateNumberRange(inputNum,baseField,results))
         {
            return results;
         }
         return results;
      }
      
      private function detectAndReportProblem(input:String, baseField:String, results:Array) : Boolean
      {
         var len:int = input.length;
         var validChars:String = VALID_CHARS + decimalSeparator + groupingSeparator;
         if(validateInputCharacters(input,len,validChars))
         {
            results.push(new ValidationResult(true,baseField,"invalidChar",invalidCharError));
            return false;
         }
         if(decimalSeparator != negativeSymbol && input.indexOf(decimalSeparator) != input.lastIndexOf(decimalSeparator))
         {
            results.push(new ValidationResult(true,baseField,"decimalPointCount",decimalPointCountError));
            return false;
         }
         var negPosLeft:Boolean = false;
         if(this.negativeNumberFormat <= 2)
         {
            negPosLeft = true;
         }
         else
         {
            if(!validateDecimalString(input,baseField,results,negPosLeft))
            {
               return false;
            }
            if(inputHasNegativeSymbol(input) || input.charAt(0) == "(" && input.charAt(len - 1) == ")")
            {
               results.push(new ValidationResult(true,baseField,"negativeNumberFormat",this.negativeNumberFormatError));
               return false;
            }
         }
         return true;
      }
   }
}

