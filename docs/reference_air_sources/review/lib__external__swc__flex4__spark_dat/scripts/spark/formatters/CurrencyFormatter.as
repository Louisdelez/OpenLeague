package spark.formatters
{
   import flash.globalization.CurrencyFormatter;
   import flash.globalization.CurrencyParseResult;
   import flash.globalization.NationalDigitsType;
   import flash.utils.getDefinitionByName;
   import mx.formatters.IFormatter;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import spark.formatters.supportClasses.NumberFormatterBase;
   import spark.globalization.LastOperationStatus;
   
   [ResourceBundle("core")]
   public class CurrencyFormatter extends NumberFormatterBase implements IFormatter
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const CURRENCY_ISOCODE:String = "currencyISOCode";
      
      private static const CURRENCY_SYMBOL:String = "currencySymbol";
      
      private static const NEGATIVE_CURRENCY_FORMAT:String = "negativeCurrencyFormat";
      
      private static const POSITIVE_CURRENCY_FORMAT:String = "positiveCurrencyFormat";
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var currencySymbolOverride:String = null;
      
      private var currencyISOCodeOverride:String = null;
      
      private var _useCurrencySymbol:Boolean = false;
      
      private var defaultCurrencyISOCode:String = null;
      
      public function CurrencyFormatter()
      {
         super();
      }
      
      public static function getAvailableLocaleIDNames() : Vector.<String>
      {
         var locales:Vector.<String> = flash.globalization.CurrencyFormatter.getAvailableLocaleIDNames();
         return Boolean(locales) ? locales : new Vector.<String>["en-US"]();
      }
      
      [Bindable("change")]
      override public function get actualLocaleIDName() : String
      {
         if(Boolean(g11nWorkingInstance))
         {
            return (g11nWorkingInstance as flash.globalization.CurrencyFormatter).actualLocaleIDName;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return "en-US";
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
         var message:String = null;
         if(Boolean(this.currencyISOCodeOverride) && this.currencyISOCodeOverride == value)
         {
            return;
         }
         this.currencyISOCodeOverride = value;
         if(Boolean(g11nWorkingInstance))
         {
            g11nWorkingInstance.setCurrency(value,g11nWorkingInstance.currencySymbol);
         }
         else
         {
            if(!value)
            {
               message = this.resourceManager.getString("core","nullParameter",[this.currencyISOCode]);
               throw new TypeError(message);
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
         var message:String = null;
         if(Boolean(this.currencySymbolOverride) && this.currencySymbolOverride == value)
         {
            return;
         }
         this.currencySymbolOverride = value;
         if(Boolean(g11nWorkingInstance))
         {
            g11nWorkingInstance.setCurrency(g11nWorkingInstance.currencyISOCode,value);
         }
         else
         {
            if(!value)
            {
               message = this.resourceManager.getString("core","nullParameter",[this.currencySymbol]);
               throw new TypeError(message);
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
         var message:String = null;
         if(!g11nWorkingInstance)
         {
            if(value < 0 || 15 < value)
            {
               message = this.resourceManager.getString("core","badIndex");
               throw new ArgumentError(message);
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
         var message:String = null;
         if(!g11nWorkingInstance)
         {
            if(value < 0 || 4 < value)
            {
               message = this.resourceManager.getString("core","badIndex");
               throw new ArgumentError(message);
            }
         }
         setBasicProperty(properties,POSITIVE_CURRENCY_FORMAT,value);
      }
      
      [Bindable("change")]
      public function get useCurrencySymbol() : Boolean
      {
         return this._useCurrencySymbol;
      }
      
      public function set useCurrencySymbol(value:Boolean) : void
      {
         if(this._useCurrencySymbol == value)
         {
            return;
         }
         this._useCurrencySymbol = value;
         update();
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
         g11nWorkingInstance = new flash.globalization.CurrencyFormatter(localeStyle);
         if(Boolean(g11nWorkingInstance) && g11nWorkingInstance.lastOperationStatus != LastOperationStatus.UNSUPPORTED_ERROR)
         {
            properties = g11nWorkingInstance;
            this.defaultCurrencyISOCode = properties.currencyISOCode;
            propagateBasicProperties(g11nWorkingInstance);
            if(Boolean(this.currencySymbolOverride))
            {
               g11nWorkingInstance.setCurrency(g11nWorkingInstance.currencyISOCode,this.currencySymbolOverride);
            }
            if(Boolean(this.currencyISOCodeOverride))
            {
               g11nWorkingInstance.setCurrency(this.currencyISOCodeOverride,g11nWorkingInstance.currencySymbol);
            }
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
         var g11nFormatter:flash.globalization.CurrencyFormatter = null;
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
               (g11nWorkingInstance as flash.globalization.CurrencyFormatter).fractionalDigits = -1;
            }
            else
            {
               fallbackLastOperationStatus = LastOperationStatus.ILLEGAL_ARGUMENT_ERROR;
            }
            return errorText;
         }
         if(Boolean(g11nWorkingInstance))
         {
            g11nFormatter = g11nWorkingInstance as flash.globalization.CurrencyFormatter;
            retVal = g11nFormatter.format(number,this.useCurrencySymbol);
            return Boolean(errorText) && LastOperationStatus.isError(g11nFormatter.lastOperationStatus) ? errorText : retVal;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return errorText;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return (this.useCurrencySymbol ? this.currencySymbol : this.currencyISOCode) + number.toFixed(properties.fractionalDigits);
      }
      
      [Bindable("change")]
      public function formattingWithCurrencySymbolIsSafe(requestedISOCode:String) : Boolean
      {
         var message:String = null;
         if(!requestedISOCode)
         {
            message = this.resourceManager.getString("core","nullParameter",[requestedISOCode]);
            throw new TypeError(message);
         }
         if(Boolean(g11nWorkingInstance))
         {
            (g11nWorkingInstance as flash.globalization.CurrencyFormatter).fractionalDigits = g11nWorkingInstance.fractionalDigits;
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         return requestedISOCode == this.defaultCurrencyISOCode;
      }
      
      [Bindable("change")]
      public function parse(inputString:String) : CurrencyParseResult
      {
         if(Boolean(g11nWorkingInstance))
         {
            return g11nWorkingInstance.parse(inputString);
         }
         if(localeStyle === undefined || localeStyle === null)
         {
            fallbackLastOperationStatus = LastOperationStatus.LOCALE_UNDEFINED_ERROR;
            return undefined;
         }
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
         var currency:CurrencyParseResult = this.fallbackParseCurrency(inputString);
         fallbackLastOperationStatus = isNaN(currency.value) ? LastOperationStatus.PARSE_ERROR : LastOperationStatus.NO_ERROR;
         return currency;
      }
      
      private function fallbackParseCurrency(parseString:String) : CurrencyParseResult
      {
         return parseToCurrencyParseResult(parseString);
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
            "negativeCurrencyFormat":0,
            "positiveCurrencyFormat":0,
            "leadingZero":true,
            "trailingZeros":false,
            "currencyISOCode":"USD",
            "currencySymbol":"$"
         };
         this.defaultCurrencyISOCode = "USD";
         if(Boolean(this.currencySymbolOverride))
         {
            properties.currencySymbol = this.currencySymbolOverride;
         }
         if(Boolean(this.currencyISOCodeOverride))
         {
            properties.currencyISOCode = this.currencyISOCodeOverride;
         }
         propagateBasicProperties(properties);
         fallbackLastOperationStatus = LastOperationStatus.NO_ERROR;
      }
   }
}

