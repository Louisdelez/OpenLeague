package spark.formatters.supportClasses
{
   import flash.globalization.CurrencyParseResult;
   import flash.globalization.NumberParseResult;
   import mx.utils.StringUtil;
   import spark.globalization.supportClasses.GlobalizationBase;
   
   public class NumberFormatterBase extends GlobalizationBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const DECIMAL_SEPARATOR:String = "decimalSeparator";
      
      private static const DIGITS_TYPE:String = "digitsType";
      
      private static const FRACTIONAL_DIGITS:String = "fractionalDigits";
      
      private static const GROUPING_PATTERN:String = "groupingPattern";
      
      private static const GROUPING_SEPARATOR:String = "groupingSeparator";
      
      private static const LEADING_ZERO:String = "leadingZero";
      
      private static const NEGATIVE_SYMBOL:String = "negativeSymbol";
      
      private static const TRAILING_ZEROS:String = "trailingZeros";
      
      private static const USE_GROUPING:String = "useGrouping";
      
      private var _g11nWorkingInstance:Object = null;
      
      private var _errorText:String;
      
      public function NumberFormatterBase()
      {
         super();
      }
      
      private static function internalParseNumber(inputString:String, decimalSymbol:String = ".", grouppingSymbol:String = ",") : Number
      {
         var result:Array = null;
         var i:int = 0;
         var numberPattern:RegExp = /^((\d+,?)*\d+)?\.?\d*$|^[-+]?\d+\.?\d*[eE]{1}[-+]?\d+$/;
         var negativePattern:RegExp = /^-[ ]?([0-9\.,]+)$|^([0-9\.,]+)[ ]?-$|^\([ ]?([0-9\.,]+)[ ]?\)$/;
         var neg:int = 1;
         inputString = inputString.split(decimalSymbol).join(".");
         inputString = inputString.split(grouppingSymbol).join(",");
         inputString = StringUtil.trim(inputString);
         if(Boolean(inputString) && negativePattern.test(inputString))
         {
            result = inputString.match(negativePattern);
            for(i = 1; i < result.length; i++)
            {
               if(result[i] != undefined)
               {
                  break;
               }
            }
            inputString = result[i];
            neg = -1;
         }
         if(!inputString || !numberPattern.test(inputString))
         {
            return NaN;
         }
         inputString = inputString.split(",").join("");
         return Number(inputString) * neg;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get g11nWorkingInstance() : Object
      {
         if(!this._g11nWorkingInstance)
         {
            ensureStyleSource();
         }
         return this._g11nWorkingInstance;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set g11nWorkingInstance(flashFormatter:Object) : void
      {
         this._g11nWorkingInstance = flashFormatter;
      }
      
      [Bindable("change")]
      override public function get lastOperationStatus() : String
      {
         return Boolean(this.g11nWorkingInstance) ? this.g11nWorkingInstance.lastOperationStatus : fallbackLastOperationStatus;
      }
      
      [Bindable("change")]
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get useFallback() : Boolean
      {
         return this.g11nWorkingInstance == null;
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
      public function get errorText() : String
      {
         return this._errorText;
      }
      
      public function set errorText(value:String) : void
      {
         if(this._errorText == value)
         {
            return;
         }
         this._errorText = value;
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
      public function get groupingPattern() : String
      {
         return getBasicProperty(properties,GROUPING_PATTERN);
      }
      
      public function set groupingPattern(value:String) : void
      {
         setBasicProperty(properties,GROUPING_PATTERN,value);
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
      public function get leadingZero() : Boolean
      {
         return getBasicProperty(properties,LEADING_ZERO);
      }
      
      public function set leadingZero(value:Boolean) : void
      {
         setBasicProperty(properties,LEADING_ZERO,value);
      }
      
      [Bindable("change")]
      public function get negativeSymbol() : String
      {
         return getBasicProperty(properties,NEGATIVE_SYMBOL);
      }
      
      public function set negativeSymbol(value:String) : void
      {
         setBasicProperty(properties,NEGATIVE_SYMBOL,value);
      }
      
      [Bindable("change")]
      public function get trailingZeros() : Boolean
      {
         return getBasicProperty(properties,TRAILING_ZEROS);
      }
      
      public function set trailingZeros(value:Boolean) : void
      {
         setBasicProperty(properties,TRAILING_ZEROS,value);
      }
      
      [Bindable("change")]
      public function get useGrouping() : Boolean
      {
         return getBasicProperty(properties,USE_GROUPING);
      }
      
      public function set useGrouping(value:Boolean) : void
      {
         setBasicProperty(properties,USE_GROUPING,value);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function parseToNumberParseResult(inputString:String) : NumberParseResult
      {
         var j:int = 0;
         var num:Number = NaN;
         loop0:
         for(var i:int = 0; i < inputString.length; )
         {
            j = inputString.length;
            while(true)
            {
               if(j <= i)
               {
                  i++;
                  continue loop0;
               }
               num = internalParseNumber(inputString.substring(i,j),this.decimalSeparator,this.groupingSeparator);
               if(!isNaN(num))
               {
                  break;
               }
               j--;
            }
            return new NumberParseResult(num,i,j);
         }
         return new NumberParseResult(NaN);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function parseToCurrencyParseResult(inputString:String) : CurrencyParseResult
      {
         var numres:NumberParseResult = null;
         var result:Array = null;
         var i:int = 0;
         var negativePattern:RegExp = /^-[ ]?(.+)$|^(.+)[ ]?-$|^\((.+)\)$/;
         var neg:int = 1;
         inputString = StringUtil.trim(inputString);
         if(negativePattern.test(inputString))
         {
            result = inputString.match(negativePattern);
            for(i = 1; i < result.length; i++)
            {
               if(result[i] != undefined)
               {
                  break;
               }
            }
            inputString = result[i];
            neg = -1;
         }
         numres = this.parseToNumberParseResult(inputString);
         var prefix:String = StringUtil.trim(inputString.substring(0,numres.startIndex));
         var suffix:String = StringUtil.trim(inputString.substring(numres.endIndex));
         if(isNaN(numres.value) || numres.value < 0 && neg == -1 || prefix.length > 0 && suffix.length > 0)
         {
            return new CurrencyParseResult(NaN);
         }
         var cur:String = prefix.length > 0 ? prefix : suffix;
         return new CurrencyParseResult(numres.value * neg,cur);
      }
   }
}

