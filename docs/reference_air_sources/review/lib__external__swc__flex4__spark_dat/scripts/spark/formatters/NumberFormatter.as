package spark.formatters
{
   import flash.globalization.NationalDigitsType;
   import flash.globalization.NumberFormatter;
   import flash.globalization.NumberParseResult;
   import flash.utils.getDefinitionByName;
   import mx.formatters.IFormatter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.formatters.supportClasses.NumberFormatterBase;
   import spark.globalization.LastOperationStatus;
   
   [ResourceBundle("core")]
   public class NumberFormatter extends NumberFormatterBase implements IFormatter
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const NEGATIVE_NUMBER_FORMAT:String = "negativeNumberFormat";
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function NumberFormatter()
      {
         super();
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var locales:Vector.<String> = flash.globalization.NumberFormatter.getAvailableLocaleIDNames();
         return Boolean(locales) ? locales : new Vector.<String>["en-US"]();
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         if(Boolean(g11nWorkingInstance))
         {
            return (g11nWorkingInstance as flash.globalization.NumberFormatter).actualLocaleIDName;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return "en-US";
      }
      
      [Inspectable(category="General",enumeration="0,1,2,3,4")]
      [Bindable("change")]
      public function get negativeNumberFormat() : uint
      {
         return getBasicProperty(properties,NEGATIVE_NUMBER_FORMAT);
      }
      
      public function set negativeNumberFormat(value:uint) : void
      {
         var message:String = null;
         if(!g11nWorkingInstance)
         {
            if(4 < value)
            {
               message = this.resourceManager.getString("core","badIndex",[this.negativeNumberFormat]);
               throw new ArgumentError(message);
            }
         }
         setBasicProperty(properties,NEGATIVE_NUMBER_FORMAT,value);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createWorkingInstance() : void
      {
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            g11nWorkingInstance = null;
            properties = null;
            return;
         }
         if(enforceFallback)
         {
            this.fallbackInstantiate();
            g11nWorkingInstance = null;
            return;
         }
         g11nWorkingInstance = new flash.globalization.NumberFormatter(localeStyle);
         if(Boolean(g11nWorkingInstance) && g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            properties = g11nWorkingInstance;
            propagateBasicProperties(g11nWorkingInstance);
            return;
         }
         this.fallbackInstantiate();
         g11nWorkingInstance = null;
         if(fallbackLastOperationStatus == LastOperationStatus.NO_ERROR)
         {
            fallbackLastOperationStatus = LastOperationStatus.USING_FALLBACK_WARNING;
         }
      }
      
      [Bindable("change")]
      public function format(value:Object) : String
      {
         var g11nFormatter:flash.globalization.NumberFormatter = null;
         var retVal:String = null;
         if(value == null)
         {
            return null;
         }
         var number:Number = Number(value);
         if(isNaN(number))
         {
            if(Boolean(g11nWorkingInstance))
            {
               (g11nWorkingInstance as flash.globalization.NumberFormatter).fractionalDigits = -1;
            }
            else
            {
               fallbackLastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
            }
            return errorText;
         }
         if(Boolean(g11nWorkingInstance))
         {
            g11nFormatter = g11nWorkingInstance as flash.globalization.NumberFormatter;
            retVal = g11nFormatter.formatNumber(number);
            return Boolean(errorText) && LastOperationStatus.isError(g11nFormatter.lastOperationStatus) ? errorText : retVal;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return errorText;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return number.toFixed(properties.fractionalDigits);
      }
      
      [Bindable("change")]
      public function parse(inputString:String) : NumberParseResult
      {
         if(Boolean(g11nWorkingInstance))
         {
            return (g11nWorkingInstance as flash.globalization.NumberFormatter).parse(inputString);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return this.fallbackParse(inputString);
      }
      
      [Bindable("change")]
      public function parseNumber(parseString:String) : Number
      {
         if(Boolean(g11nWorkingInstance))
         {
            return (g11nWorkingInstance as flash.globalization.NumberFormatter).parseNumber(parseString);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         var number:Number = this.fallbackParseNumber(parseString);
         fallbackLastOperationStatus = isNaN(number) ? LastOperationStatus.PARSE_ERROR : LastOperationStatus.NO_ERROR;
         return number;
      }
      
      private function fallbackParse(parseString:String) : NumberParseResult
      {
         return parseToNumberParseResult(parseString);
      }
      
      private function fallbackParseNumber(value:String) : Number
      {
         var res:NumberParseResult = parseToNumberParseResult(value);
         if(!res.startIndex && res.endIndex == value.length)
         {
            return res.value;
         }
         return NaN;
      }
      
      private function fallbackInstantiate() : void
      {
         properties = {
            "fractionalDigits":0,
            "useGrouping":false,
            "groupingPattern":"3",
            "digitsType":NationalDigitsType.EUROPEAN,
            "decimalSeparator":".",
            "groupingSeparator":",",
            "negativeSymbol":"-",
            "negativeNumberFormat":0,
            "leadingZero":true,
            "trailingZeros":false
         };
         propagateBasicProperties(properties);
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
      }
   }
}

