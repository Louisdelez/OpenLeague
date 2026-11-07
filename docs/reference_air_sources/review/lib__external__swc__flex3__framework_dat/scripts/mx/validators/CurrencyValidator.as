package mx.validators
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ResourceBundle("validators")]
   [ResourceBundle("SharedResources")]
   public class CurrencyValidator extends Validator
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const NEGATIVE_FORMATTING_CHARS:String = "-()";
      
      private var invalidCharErrorOverride:String;
      
      private var precisionErrorOverride:String;
      
      private var _separationError:String;
      
      private var lowerThanMinErrorOverride:String;
      
      private var _currencySymbol:String;
      
      private var _exceedsMaxError:String;
      
      private var minValueOverride:Object;
      
      private var decimalPointCountErrorOverride:String;
      
      private var _alignSymbol:String;
      
      private var _precisionError:String;
      
      private var separationErrorOverride:String;
      
      private var exceedsMaxErrorOverride:String;
      
      private var maxValueOverride:Object;
      
      private var _invalidFormatCharsError:String;
      
      private var precisionOverride:Object;
      
      private var currencySymbolErrorOverride:String;
      
      private var _decimalPointCountError:String;
      
      private var _invalidCharError:String;
      
      private var decimalSeparatorOverride:String;
      
      private var allowNegativeOverride:Object;
      
      private var invalidFormatCharsErrorOverride:String;
      
      private var _allowNegative:Object;
      
      private var _minValue:Object;
      
      private var _thousandsSeparator:String;
      
      private var _lowerThanMinError:String;
      
      private var negativeErrorOverride:String;
      
      private var _currencySymbolError:String;
      
      private var _maxValue:Object;
      
      private var _negativeError:String;
      
      private var alignSymbolOverride:String;
      
      private var _decimalSeparator:String;
      
      private var currencySymbolOverride:String;
      
      private var thousandsSeparatorOverride:String;
      
      private var _precision:Object;
      
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
      
      public function set precision(value:Object) : void
      {
         precisionOverride = value;
         _precision = value != null ? int(value) : resourceManager.getInt("validators","currencyValidatorPrecision");
      }
      
      public function set currencySymbolError(value:String) : void
      {
         currencySymbolErrorOverride = value;
         _currencySymbolError = value != null ? value : resourceManager.getString("validators","currencySymbolError");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get currencySymbol() : String
      {
         return _currencySymbol;
      }
      
      [Inspectable(category="General",defaultValue=",")]
      public function get thousandsSeparator() : String
      {
         return _thousandsSeparator;
      }
      
      public function set currencySymbol(value:String) : void
      {
         currencySymbolOverride = value;
         _currencySymbol = value != null ? value : resourceManager.getString("SharedResources","currencySymbol");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidCharError() : String
      {
         return _invalidCharError;
      }
      
      public function set thousandsSeparator(value:String) : void
      {
         thousandsSeparatorOverride = value;
         _thousandsSeparator = value != null ? value : resourceManager.getString("validators","thousandsSeparator");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get precisionError() : String
      {
         return _precisionError;
      }
      
      public function set decimalSeparator(value:String) : void
      {
         decimalSeparatorOverride = value;
         _decimalSeparator = value != null ? value : resourceManager.getString("validators","decimalSeparator");
      }
      
      public function set invalidCharError(value:String) : void
      {
         invalidCharErrorOverride = value;
         _invalidCharError = value != null ? value : resourceManager.getString("validators","invalidCharError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get lowerThanMinError() : String
      {
         return _lowerThanMinError;
      }
      
      public function set invalidFormatCharsError(value:String) : void
      {
         invalidFormatCharsErrorOverride = value;
         _invalidFormatCharsError = value != null ? value : resourceManager.getString("validators","invalidFormatCharsError");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minValue() : Object
      {
         return _minValue;
      }
      
      public function set allowNegative(value:Object) : void
      {
         allowNegativeOverride = value;
         _allowNegative = value != null ? Boolean(value) : resourceManager.getBoolean("validators","allowNegative");
      }
      
      public function set precisionError(value:String) : void
      {
         precisionErrorOverride = value;
         _precisionError = value != null ? value : resourceManager.getString("validators","precisionError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get decimalPointCountError() : String
      {
         return _decimalPointCountError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get separationError() : String
      {
         return _separationError;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get exceedsMaxError() : String
      {
         return _exceedsMaxError;
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
      
      [Inspectable(category="General",defaultValue="null")]
      public function get maxValue() : Object
      {
         return _maxValue;
      }
      
      public function set lowerThanMinError(value:String) : void
      {
         lowerThanMinErrorOverride = value;
         _lowerThanMinError = value != null ? value : resourceManager.getString("validators","lowerThanMinError");
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get currencySymbolError() : String
      {
         return _currencySymbolError;
      }
      
      public function set minValue(value:Object) : void
      {
         minValueOverride = value;
         _minValue = value != null ? Number(value) : resourceManager.getNumber("validators","minValue");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get precision() : Object
      {
         return _precision;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get decimalSeparator() : String
      {
         return _decimalSeparator;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get invalidFormatCharsError() : String
      {
         return _invalidFormatCharsError;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get allowNegative() : Object
      {
         return _allowNegative;
      }
      
      public function set negativeError(value:String) : void
      {
         negativeErrorOverride = value;
         _negativeError = value != null ? value : resourceManager.getString("validators","negativeError");
      }
      
      public function set decimalPointCountError(value:String) : void
      {
         decimalPointCountErrorOverride = value;
         _decimalPointCountError = value != null ? value : resourceManager.getString("validators","decimalPointCountError");
      }
      
      public function set separationError(value:String) : void
      {
         separationErrorOverride = value;
         _separationError = value != null ? value : resourceManager.getString("validators","separationError");
      }
      
      public function set exceedsMaxError(value:String) : void
      {
         exceedsMaxErrorOverride = value;
         _exceedsMaxError = value != null ? value : resourceManager.getString("validators","exceedsMaxErrorCV");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         alignSymbol = alignSymbolOverride;
         allowNegative = allowNegativeOverride;
         currencySymbol = currencySymbolOverride;
         decimalSeparator = decimalSeparatorOverride;
         maxValue = maxValueOverride;
         minValue = minValueOverride;
         precision = precisionOverride;
         thousandsSeparator = thousandsSeparatorOverride;
         currencySymbolError = currencySymbolErrorOverride;
         decimalPointCountError = decimalPointCountErrorOverride;
         exceedsMaxError = exceedsMaxErrorOverride;
         invalidCharError = invalidCharErrorOverride;
         invalidFormatCharsError = invalidFormatCharsErrorOverride;
         lowerThanMinError = lowerThanMinErrorOverride;
         negativeError = negativeErrorOverride;
         precisionError = precisionErrorOverride;
         separationError = separationErrorOverride;
      }
      
      [Inspectable(category="Errors",defaultValue="null")]
      public function get negativeError() : String
      {
         return _negativeError;
      }
      
      public function set maxValue(value:Object) : void
      {
         maxValueOverride = value;
         _maxValue = value != null ? Number(value) : resourceManager.getNumber("validators","maxValue");
      }
      
      public function set alignSymbol(value:String) : void
      {
         alignSymbolOverride = value;
         _alignSymbol = value != null ? value : resourceManager.getString("SharedResources","alignSymbol");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get alignSymbol() : String
      {
         return _alignSymbol;
      }
   }
}

