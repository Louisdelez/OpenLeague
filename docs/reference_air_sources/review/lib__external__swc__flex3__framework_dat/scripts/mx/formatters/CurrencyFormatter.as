package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ResourceBundle("SharedResources")]
   [ResourceBundle("formatters")]
   public class CurrencyFormatter extends Formatter
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var roundingOverride:String;
      
      private var _useNegativeSign:Object;
      
      private var _thousandsSeparatorTo:String;
      
      private var thousandsSeparatorToOverride:String;
      
      private var decimalSeparatorToOverride:String;
      
      private var useNegativeSignOverride:Object;
      
      private var _currencySymbol:String;
      
      private var _decimalSeparatorFrom:String;
      
      private var _alignSymbol:String;
      
      private var thousandsSeparatorFromOverride:String;
      
      private var decimalSeparatorFromOverride:String;
      
      private var _decimalSeparatorTo:String;
      
      private var useThousandsSeparatorOverride:Object;
      
      private var alignSymbolOverride:String;
      
      private var precisionOverride:Object;
      
      private var _rounding:String;
      
      private var currencySymbolOverride:String;
      
      private var _useThousandsSeparator:Object;
      
      private var _thousandsSeparatorFrom:String;
      
      private var _precision:Object;
      
      public function CurrencyFormatter()
      {
         super();
      }
      
      public function set precision(value:Object) : void
      {
         precisionOverride = value;
         _precision = value != null ? int(value) : resourceManager.getInt("formatters","currencyFormatterPrecision");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get precision() : Object
      {
         return _precision;
      }
      
      override public function format(value:Object) : String
      {
         var temp_value:String = null;
         var valueArr:Array = null;
         var front:String = null;
         var position:Number = NaN;
         var leading:String = null;
         var temp:Number = NaN;
         var nSign:String = null;
         var baseVal:String = null;
         var lastChar:String = null;
         if(Boolean(error))
         {
            error = null;
         }
         if(Boolean(useThousandsSeparator) && (decimalSeparatorFrom == thousandsSeparatorFrom || decimalSeparatorTo == thousandsSeparatorTo))
         {
            error = defaultInvalidFormatError;
            return "";
         }
         if(decimalSeparatorTo == "")
         {
            error = defaultInvalidFormatError;
            return "";
         }
         var dataFormatter:NumberBase = new NumberBase(decimalSeparatorFrom,thousandsSeparatorFrom,decimalSeparatorTo,thousandsSeparatorTo);
         if(value is String)
         {
            temp_value = dataFormatter.parseNumberString(String(value));
            if(temp_value == "0")
            {
               valueArr = value.split(decimalSeparatorFrom);
               value = valueArr[0];
               if(valueArr[1] != undefined)
               {
                  value += "." + valueArr[1];
               }
               else
               {
                  value = temp_value;
               }
            }
            else
            {
               value = temp_value;
            }
         }
         if(value === null || isNaN(Number(value)))
         {
            error = defaultInvalidValueError;
            return "";
         }
         var isNegative:Boolean = Number(value) < 0;
         var numStr:String = value.toString();
         var numArrTemp:Array = numStr.split(".");
         var numFraction:int = Boolean(numArrTemp[1]) ? String(numArrTemp[1]).length : 0;
         if(precision <= numFraction)
         {
            if(rounding != NumberBaseRoundType.NONE)
            {
               numStr = dataFormatter.formatRoundingWithPrecision(numStr,rounding,int(precision));
            }
         }
         var numValue:Number = Number(numStr);
         if(Math.abs(numValue) >= 1)
         {
            numArrTemp = numStr.split(".");
            front = Boolean(useThousandsSeparator) ? dataFormatter.formatThousands(String(numArrTemp[0])) : String(numArrTemp[0]);
            if(numArrTemp[1] != null && numArrTemp[1] != "")
            {
               numStr = front + decimalSeparatorTo + numArrTemp[1];
            }
            else
            {
               numStr = front;
            }
         }
         else if(Math.abs(numValue) >= 0)
         {
            if(numStr.indexOf("e") != -1)
            {
               temp = Math.abs(numValue) + 1;
               numStr = temp.toString();
            }
            position = numStr.indexOf(".");
            leading = position > 0 ? "0" : "";
            numStr = leading + decimalSeparatorTo + numStr.substring(position + 1);
         }
         numStr = dataFormatter.formatPrecision(numStr,int(precision));
         if(Number(numStr) == 0)
         {
            isNegative = false;
         }
         if(isNegative)
         {
            numStr = dataFormatter.formatNegative(numStr,useNegativeSign);
         }
         if(!dataFormatter.isValid)
         {
            error = defaultInvalidFormatError;
            return "";
         }
         if(alignSymbol == "left")
         {
            if(isNegative)
            {
               nSign = numStr.charAt(0);
               baseVal = numStr.substr(1,numStr.length - 1);
               numStr = nSign + currencySymbol + baseVal;
            }
            else
            {
               numStr = currencySymbol + numStr;
            }
         }
         else
         {
            if(alignSymbol != "right")
            {
               error = defaultInvalidFormatError;
               return "";
            }
            lastChar = numStr.charAt(numStr.length - 1);
            if(isNegative && lastChar == ")")
            {
               baseVal = numStr.substr(0,numStr.length - 1);
               numStr = baseVal + currencySymbol + lastChar;
            }
            else
            {
               numStr += currencySymbol;
            }
         }
         return numStr;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get currencySymbol() : String
      {
         return _currencySymbol;
      }
      
      public function set currencySymbol(value:String) : void
      {
         currencySymbolOverride = value;
         _currencySymbol = value != null ? value : resourceManager.getString("SharedResources","currencySymbol");
      }
      
      public function set useNegativeSign(value:Object) : void
      {
         useNegativeSignOverride = value;
         _useNegativeSign = value != null ? Boolean(value) : resourceManager.getBoolean("formatters","useNegativeSign");
      }
      
      [Inspectable(category="General",enumeration="none,up,down,nearest",defaultValue="null")]
      public function get rounding() : String
      {
         return _rounding;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get thousandsSeparatorTo() : String
      {
         return _thousandsSeparatorTo;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get decimalSeparatorTo() : String
      {
         return _decimalSeparatorTo;
      }
      
      public function set thousandsSeparatorFrom(value:String) : void
      {
         thousandsSeparatorFromOverride = value;
         _thousandsSeparatorFrom = value != null ? value : resourceManager.getString("SharedResources","thousandsSeparatorFrom");
      }
      
      public function set rounding(value:String) : void
      {
         roundingOverride = value;
         _rounding = value != null ? value : resourceManager.getString("formatters","rounding");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get useNegativeSign() : Object
      {
         return _useNegativeSign;
      }
      
      public function set decimalSeparatorFrom(value:String) : void
      {
         decimalSeparatorFromOverride = value;
         _decimalSeparatorFrom = value != null ? value : resourceManager.getString("SharedResources","decimalSeparatorFrom");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         alignSymbol = alignSymbolOverride;
         currencySymbol = currencySymbolOverride;
         decimalSeparatorFrom = decimalSeparatorFromOverride;
         decimalSeparatorTo = decimalSeparatorToOverride;
         precision = precisionOverride;
         rounding = roundingOverride;
         thousandsSeparatorFrom = thousandsSeparatorFromOverride;
         thousandsSeparatorTo = thousandsSeparatorToOverride;
         useNegativeSign = useNegativeSignOverride;
         useThousandsSeparator = useThousandsSeparatorOverride;
      }
      
      public function set thousandsSeparatorTo(value:String) : void
      {
         thousandsSeparatorToOverride = value;
         _thousandsSeparatorTo = value != null ? value : resourceManager.getString("SharedResources","thousandsSeparatorTo");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get thousandsSeparatorFrom() : String
      {
         return _thousandsSeparatorFrom;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get decimalSeparatorFrom() : String
      {
         return _decimalSeparatorFrom;
      }
      
      public function set decimalSeparatorTo(value:String) : void
      {
         decimalSeparatorToOverride = value;
         _decimalSeparatorTo = value != null ? value : resourceManager.getString("SharedResources","decimalSeparatorTo");
      }
      
      public function set useThousandsSeparator(value:Object) : void
      {
         useThousandsSeparatorOverride = value;
         _useThousandsSeparator = value != null ? Boolean(value) : resourceManager.getBoolean("formatters","useThousandsSeparator");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get useThousandsSeparator() : Object
      {
         return _useThousandsSeparator;
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

