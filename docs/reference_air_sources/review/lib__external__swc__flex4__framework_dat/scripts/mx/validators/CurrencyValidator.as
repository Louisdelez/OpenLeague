package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.validators.CurrencyValidator",since="4.5")]
   [ResourceBundle("validators")]
   [ResourceBundle("SharedResources")]
   public class CurrencyValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private static const NEGATIVE_FORMATTING_CHARS:String = "-()";
      
      private var _alignSymbol:String;
      
      private var alignSymbolOverride:String;
      
      private var _allowNegative:Object;
      
      private var allowNegativeOverride:Object;
      
      private var _currencySymbol:String;
      
      private var currencySymbolOverride:String;
      
      private var _decimalSeparator:String;
      
      private var decimalSeparatorOverride:String;
      
      private var _maxValue:Object;
      
      private var maxValueOverride:Object;
      
      private var _minValue:Object;
      
      private var minValueOverride:Object;
      
      private var _precision:Object;
      
      private var precisionOverride:Object;
      
      private var _thousandsSeparator:String;
      
      private var thousandsSeparatorOverride:String;
      
      private var _currencySymbolError:String;
      
      private var currencySymbolErrorOverride:String;
      
      private var _decimalPointCountError:String;
      
      private var decimalPointCountErrorOverride:String;
      
      private var _exceedsMaxError:String;
      
      private var exceedsMaxErrorOverride:String;
      
      private var _invalidCharError:String;
      
      private var invalidCharErrorOverride:String;
      
      private var _invalidFormatCharsError:String;
      
      private var invalidFormatCharsErrorOverride:String;
      
      private var _lowerThanMinError:String;
      
      private var lowerThanMinErrorOverride:String;
      
      private var _negativeError:String;
      
      private var negativeErrorOverride:String;
      
      private var _precisionError:String;
      
      private var precisionErrorOverride:String;
      
      private var _separationError:String;
      
      private var separationErrorOverride:String;
      
      public function CurrencyValidator()
      {
         super();
      }
      
      public static function validateCurrency(validator:CurrencyValidator, value:Object, baseField:String) : Array
      {
         var i:int = 0;
         var c:String = null;
         var x:Number = NaN;
         var left:String = null;
         var right:String = null;
         var dIndex:int = 0;
         var dLeft:String = null;
         var dRight:String = null;
         var results:Array = [];
         var alignSymbol:String = validator.alignSymbol;
         var allowNegative:Boolean = Boolean(validator.allowNegative);
         var currencySymbol:String = validator.currencySymbol;
         var decimalSeparator:String = validator.decimalSeparator;
         var maxValue:Number = Number(validator.maxValue);
         var minValue:Number = Number(validator.minValue);
         var precision:int = int(validator.precision);
         var thousandsSeparator:String = validator.thousandsSeparator;
         var input:String = String(value);
         var len:int = input.length;
         var isNegative:Boolean = false;
         var invalidFormChars:String = DECIMAL_DIGITS + NEGATIVE_FORMATTING_CHARS;
         if(currencySymbol == thousandsSeparator || currencySymbol == decimalSeparator || decimalSeparator == thousandsSeparator || invalidFormChars.indexOf(currencySymbol) != -1 || invalidFormChars.indexOf(decimalSeparator) != -1 || invalidFormChars.indexOf(thousandsSeparator) != -1 || decimalSeparator.length != 1 || thousandsSeparator.length != 1)
         {
            results.push(new ValidationResult(true,baseField,"invalidFormatChar",validator.invalidFormatCharsError));
            return results;
         }
         var validChars:String = DECIMAL_DIGITS + NEGATIVE_FORMATTING_CHARS + currencySymbol + decimalSeparator + thousandsSeparator;
         for(i = 0; i < len; i++)
         {
            c = input.charAt(i);
            if(validChars.indexOf(c) == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
         }
         if(input.charAt(0) == "-")
         {
            if(!allowNegative)
            {
               results.push(new ValidationResult(true,baseField,"negative",validator.negativeError));
               return results;
            }
            input = input.substring(1);
            len--;
            isNegative = true;
         }
         else if(input.charAt(0) == "(")
         {
            if(input.charAt(len - 1) != ")")
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
            if(!allowNegative)
            {
               results.push(new ValidationResult(true,baseField,"negative",validator.negativeError));
               return results;
            }
            input = input.substring(1,len - 2);
            len -= 2;
            isNegative = true;
         }
         var currencySymbolLength:uint = uint(currencySymbol.length);
         if(input.substr(0,currencySymbolLength) == currencySymbol && alignSymbol == CurrencyValidatorAlignSymbol.RIGHT || input.substr(len - currencySymbolLength,currencySymbolLength) == currencySymbol && alignSymbol == CurrencyValidatorAlignSymbol.LEFT || len > 2 * currencySymbolLength && input.substring(currencySymbolLength,len - currencySymbolLength).indexOf(currencySymbol) != -1 || input.indexOf(currencySymbol) != input.lastIndexOf(currencySymbol))
         {
            results.push(new ValidationResult(true,baseField,"currencySymbol",validator.currencySymbolError));
            return results;
         }
         var currencySymbolIndex:int = input.indexOf(currencySymbol);
         if(currencySymbolIndex != -1)
         {
            if(Boolean(currencySymbolIndex))
            {
               input = input.substring(0,len - currencySymbolLength);
            }
            else
            {
               input = input.substring(currencySymbolLength);
            }
            len -= currencySymbolLength;
         }
         if(input.indexOf(decimalSeparator) != input.lastIndexOf(decimalSeparator))
         {
            results.push(new ValidationResult(true,baseField,"decimalPointCount",validator.decimalPointCountError));
            return results;
         }
         var decimalSeparatorIndex:int = input.indexOf(decimalSeparator);
         var numDigitsAfterDecimal:int = 0;
         if(decimalSeparatorIndex == -1)
         {
            decimalSeparatorIndex = len;
         }
         for(i = decimalSeparatorIndex + 1; i < len; i++)
         {
            if(DECIMAL_DIGITS.indexOf(input.charAt(i)) == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
            numDigitsAfterDecimal++;
            if(precision != -1 && numDigitsAfterDecimal > precision)
            {
               results.push(new ValidationResult(true,baseField,"precision",validator.precisionError));
               return results;
            }
         }
         if(DECIMAL_DIGITS.indexOf(input.charAt(0)) == -1 && input.charAt(0) != decimalSeparator)
         {
            results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
            return results;
         }
         var validGroupEnder:String = thousandsSeparator + decimalSeparator;
         for(i = 1; i < decimalSeparatorIndex; i++)
         {
            c = input.charAt(i);
            if(c == thousandsSeparator)
            {
               if(input.substring(i + 1,i + 4).length < 3 || DECIMAL_DIGITS.indexOf(input.charAt(i + 1)) == -1 || DECIMAL_DIGITS.indexOf(input.charAt(i + 2)) == -1 || DECIMAL_DIGITS.indexOf(input.charAt(i + 3)) == -1 || validGroupEnder.indexOf(input.charAt(i + 4)) == -1)
               {
                  results.push(new ValidationResult(true,baseField,"separation",validator.separationError));
                  return results;
               }
            }
            else if(DECIMAL_DIGITS.indexOf(c) == -1)
            {
               results.push(new ValidationResult(true,baseField,"invalidChar",validator.invalidCharError));
               return results;
            }
         }
         if(!isNaN(minValue) || !isNaN(maxValue))
         {
            for(i = 0; i < decimalSeparatorIndex; i++)
            {
               if(input.charAt(i) == thousandsSeparator)
               {
                  left = input.substring(0,i);
                  right = input.substring(i + 1);
                  input = left + right;
               }
            }
            if(validator.decimalSeparator != ".")
            {
               dIndex = input.indexOf(validator.decimalSeparator);
               if(dIndex != -1)
               {
                  dLeft = input.substring(0,dIndex);
                  dRight = input.substring(dIndex + 1);
                  input = dLeft + "." + dRight;
               }
            }
            x = Number(input);
            if(isNegative)
            {
               x = -x;
            }
            if(!isNaN(minValue) && x < minValue)
            {
               results.push(new ValidationResult(true,baseField,"lowerThanMin",validator.lowerThanMinError));
               return results;
            }
            if(!isNaN(maxValue) && x > maxValue)
            {
               results.push(new ValidationResult(true,baseField,"exceedsMax",validator.exceedsMaxError));
               return results;
            }
         }
         return results;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get alignSymbol() : String
      {
         return this._alignSymbol;
      }
      
      public function set alignSymbol(value:String) : void
      {
         this.alignSymbolOverride = value;
         this._alignSymbol = value != null ? value : resourceManager.getString("SharedResources","alignSymbol");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowNegative() : Object
      {
         return this._allowNegative;
      }
      
      public function set allowNegative(value:Object) : void
      {
         this.allowNegativeOverride = value;
         this._allowNegative = value != null ? Boolean(value) : resourceManager.getBoolean("validators","allowNegative");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get currencySymbol() : String
      {
         return this._currencySymbol;
      }
      
      public function set currencySymbol(value:String) : void
      {
         this.currencySymbolOverride = value;
         this._currencySymbol = value != null ? value : resourceManager.getString("SharedResources","currencySymbol");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get decimalSeparator() : String
      {
         return this._decimalSeparator;
      }
      
      public function set decimalSeparator(value:String) : void
      {
         this.decimalSeparatorOverride = value;
         this._decimalSeparator = value != null ? value : resourceManager.getString("validators","decimalSeparator");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get maxValue() : Object
      {
         return this._maxValue;
      }
      
      public function set maxValue(value:Object) : void
      {
         this.maxValueOverride = value;
         this._maxValue = value != null ? Number(value) : resourceManager.getNumber("validators","maxValue");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minValue() : Object
      {
         return this._minValue;
      }
      
      public function set minValue(value:Object) : void
      {
         this.minValueOverride = value;
         this._minValue = value != null ? Number(value) : resourceManager.getNumber("validators","minValue");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get precision() : Object
      {
         return this._precision;
      }
      
      public function set precision(value:Object) : void
      {
         this.precisionOverride = value;
         this._precision = value != null ? int(value) : resourceManager.getInt("validators","currencyValidatorPrecision");
      }
      
      [Inspectable(category="General",defaultValue=",")]
      public function get thousandsSeparator() : String
      {
         return this._thousandsSeparator;
      }
      
      public function set thousandsSeparator(value:String) : void
      {
         this.thousandsSeparatorOverride = value;
         this._thousandsSeparator = value != null ? value : resourceManager.getString("validators","thousandsSeparator");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get currencySymbolError() : String
      {
         return this._currencySymbolError;
      }
      
      public function set currencySymbolError(value:String) : void
      {
         this.currencySymbolErrorOverride = value;
         this._currencySymbolError = value != null ? value : resourceManager.getString("validators","currencySymbolError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get decimalPointCountError() : String
      {
         return this._decimalPointCountError;
      }
      
      public function set decimalPointCountError(value:String) : void
      {
         this.decimalPointCountErrorOverride = value;
         this._decimalPointCountError = value != null ? value : resourceManager.getString("validators","decimalPointCountError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get exceedsMaxError() : String
      {
         return this._exceedsMaxError;
      }
      
      public function set exceedsMaxError(value:String) : void
      {
         this.exceedsMaxErrorOverride = value;
         this._exceedsMaxError = value != null ? value : resourceManager.getString("validators","exceedsMaxErrorCV");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return this._invalidCharError;
      }
      
      public function set invalidCharError(value:String) : void
      {
         this.invalidCharErrorOverride = value;
         this._invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidFormatCharsError() : String
      {
         return this._invalidFormatCharsError;
      }
      
      public function set invalidFormatCharsError(value:String) : void
      {
         this.invalidFormatCharsErrorOverride = value;
         this._invalidFormatCharsError = value != null ? value : resourceManager.getString("validators","invalidFormatCharsError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get lowerThanMinError() : String
      {
         return this._lowerThanMinError;
      }
      
      public function set lowerThanMinError(value:String) : void
      {
         this.lowerThanMinErrorOverride = value;
         this._lowerThanMinError = value != null ? value : resourceManager.getString("validators","lowerThanMinError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get negativeError() : String
      {
         return this._negativeError;
      }
      
      public function set negativeError(value:String) : void
      {
         this.negativeErrorOverride = value;
         this._negativeError = value != null ? value : resourceManager.getString("validators","negativeError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get precisionError() : String
      {
         return this._precisionError;
      }
      
      public function set precisionError(value:String) : void
      {
         this.precisionErrorOverride = value;
         this._precisionError = value != null ? value : resourceManager.getString("validators","precisionError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get separationError() : String
      {
         return this._separationError;
      }
      
      public function set separationError(value:String) : void
      {
         this.separationErrorOverride = value;
         this._separationError = value != null ? value : resourceManager.getString("validators","separationError");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.alignSymbol = this.alignSymbolOverride;
         this.allowNegative = this.allowNegativeOverride;
         this.currencySymbol = this.currencySymbolOverride;
         this.decimalSeparator = this.decimalSeparatorOverride;
         this.maxValue = this.maxValueOverride;
         this.minValue = this.minValueOverride;
         this.precision = this.precisionOverride;
         this.thousandsSeparator = this.thousandsSeparatorOverride;
         this.currencySymbolError = this.currencySymbolErrorOverride;
         this.decimalPointCountError = this.decimalPointCountErrorOverride;
         this.exceedsMaxError = this.exceedsMaxErrorOverride;
         this.invalidCharError = this.invalidCharErrorOverride;
         this.invalidFormatCharsError = this.invalidFormatCharsErrorOverride;
         this.lowerThanMinError = this.lowerThanMinErrorOverride;
         this.negativeError = this.negativeErrorOverride;
         this.precisionError = this.precisionErrorOverride;
         this.separationError = this.separationErrorOverride;
      }
      
      override protected function doValidation(value:Object) : Array
      {
         var results:Array = super.doValidation(value);
         var val:String = Boolean(value) ? String(value) : "";
         if(results.length > 0 || val.length == 0 && !required)
         {
            return results;
         }
         return CurrencyValidator.validateCurrency(this,value,null);
      }
   }
}

