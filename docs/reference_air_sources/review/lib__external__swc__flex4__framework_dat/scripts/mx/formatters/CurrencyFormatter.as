package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [Alternative(replacement="spark.formatters.CurrencyFormatter",since="4.5")]
   [ResourceBundle("SharedResources")]
   [ResourceBundle("formatters")]
   public class CurrencyFormatter extends Formatter
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _alignSymbol:String;
      
      private var alignSymbolOverride:String;
      
      private var _currencySymbol:String;
      
      private var currencySymbolOverride:String;
      
      private var _decimalSeparatorFrom:String;
      
      private var decimalSeparatorFromOverride:String;
      
      private var _decimalSeparatorTo:String;
      
      private var decimalSeparatorToOverride:String;
      
      private var _precision:Object;
      
      private var precisionOverride:Object;
      
      private var _rounding:String;
      
      private var roundingOverride:String;
      
      private var _thousandsSeparatorFrom:String;
      
      private var thousandsSeparatorFromOverride:String;
      
      private var _thousandsSeparatorTo:String;
      
      private var thousandsSeparatorToOverride:String;
      
      private var _useNegativeSign:Object;
      
      private var useNegativeSignOverride:Object;
      
      private var _useThousandsSeparator:Object;
      
      private var useThousandsSeparatorOverride:Object;
      
      public function CurrencyFormatter()
      {
         super();
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
      public function get decimalSeparatorFrom() : String
      {
         return this._decimalSeparatorFrom;
      }
      
      public function set decimalSeparatorFrom(value:String) : void
      {
         this.decimalSeparatorFromOverride = value;
         this._decimalSeparatorFrom = value != null ? value : resourceManager.getString("SharedResources","decimalSeparatorFrom");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get decimalSeparatorTo() : String
      {
         return this._decimalSeparatorTo;
      }
      
      public function set decimalSeparatorTo(value:String) : void
      {
         this.decimalSeparatorToOverride = value;
         this._decimalSeparatorTo = value != null ? value : resourceManager.getString("SharedResources","decimalSeparatorTo");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get precision() : Object
      {
         return this._precision;
      }
      
      public function set precision(value:Object) : void
      {
         this.precisionOverride = value;
         this._precision = value != null ? int(value) : resourceManager.getInt("formatters","currencyFormatterPrecision");
      }
      
      [Inspectable(category="General",enumeration="none,up,down,nearest",defaultValue="null")]
      public function get rounding() : String
      {
         return this._rounding;
      }
      
      public function set rounding(value:String) : void
      {
         this.roundingOverride = value;
         this._rounding = value != null ? value : resourceManager.getString("formatters","rounding");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get thousandsSeparatorFrom() : String
      {
         return this._thousandsSeparatorFrom;
      }
      
      public function set thousandsSeparatorFrom(value:String) : void
      {
         this.thousandsSeparatorFromOverride = value;
         this._thousandsSeparatorFrom = value != null ? value : resourceManager.getString("SharedResources","thousandsSeparatorFrom");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get thousandsSeparatorTo() : String
      {
         return this._thousandsSeparatorTo;
      }
      
      public function set thousandsSeparatorTo(value:String) : void
      {
         this.thousandsSeparatorToOverride = value;
         this._thousandsSeparatorTo = value != null ? value : resourceManager.getString("SharedResources","thousandsSeparatorTo");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get useNegativeSign() : Object
      {
         return this._useNegativeSign;
      }
      
      public function set useNegativeSign(value:Object) : void
      {
         this.useNegativeSignOverride = value;
         this._useNegativeSign = value != null ? Boolean(value) : resourceManager.getBoolean("formatters","useNegativeSignInCurrency");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get useThousandsSeparator() : Object
      {
         return this._useThousandsSeparator;
      }
      
      public function set useThousandsSeparator(value:Object) : void
      {
         this.useThousandsSeparatorOverride = value;
         this._useThousandsSeparator = value != null ? Boolean(value) : resourceManager.getBoolean("formatters","useThousandsSeparator");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.alignSymbol = this.alignSymbolOverride;
         this.currencySymbol = this.currencySymbolOverride;
         this.decimalSeparatorFrom = this.decimalSeparatorFromOverride;
         this.decimalSeparatorTo = this.decimalSeparatorToOverride;
         this.precision = this.precisionOverride;
         this.rounding = this.roundingOverride;
         this.thousandsSeparatorFrom = this.thousandsSeparatorFromOverride;
         this.thousandsSeparatorTo = this.thousandsSeparatorToOverride;
         this.useNegativeSign = this.useNegativeSignOverride;
         this.useThousandsSeparator = this.useThousandsSeparatorOverride;
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
         if(Boolean(this.useThousandsSeparator) && (this.decimalSeparatorFrom == this.thousandsSeparatorFrom || this.decimalSeparatorTo == this.thousandsSeparatorTo))
         {
            error = defaultInvalidFormatError;
            return "";
         }
         if(this.decimalSeparatorTo == "")
         {
            error = defaultInvalidFormatError;
            return "";
         }
         var dataFormatter:NumberBase = new NumberBase(this.decimalSeparatorFrom,this.thousandsSeparatorFrom,this.decimalSeparatorTo,this.thousandsSeparatorTo);
         if(value is String)
         {
            temp_value = dataFormatter.parseNumberString(String(value));
            if(temp_value == "0")
            {
               valueArr = value.split(this.decimalSeparatorFrom);
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
         if(this.precision <= numFraction)
         {
            if(this.rounding != NumberBaseRoundType.NONE)
            {
               numStr = dataFormatter.formatRoundingWithPrecision(numStr,this.rounding,int(this.precision));
            }
         }
         var numValue:Number = Number(numStr);
         if(Math.abs(numValue) >= 1)
         {
            numArrTemp = numStr.split(".");
            front = Boolean(this.useThousandsSeparator) ? dataFormatter.formatThousands(String(numArrTemp[0])) : String(numArrTemp[0]);
            if(numArrTemp[1] != null && numArrTemp[1] != "")
            {
               numStr = front + this.decimalSeparatorTo + numArrTemp[1];
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
            numStr = leading + this.decimalSeparatorTo + numStr.substring(position + 1);
         }
         numStr = dataFormatter.formatPrecision(numStr,int(this.precision));
         if(Number(numStr) == 0)
         {
            isNegative = false;
         }
         if(isNegative)
         {
            numStr = dataFormatter.formatNegative(numStr,this.useNegativeSign);
         }
         if(!dataFormatter.isValid)
         {
            error = defaultInvalidFormatError;
            return "";
         }
         if(this.alignSymbol == "left")
         {
            if(isNegative)
            {
               nSign = numStr.charAt(0);
               baseVal = numStr.substr(1,numStr.length - 1);
               numStr = nSign + this.currencySymbol + baseVal;
            }
            else
            {
               numStr = this.currencySymbol + numStr;
            }
         }
         else
         {
            if(this.alignSymbol != "right")
            {
               error = defaultInvalidFormatError;
               return "";
            }
            lastChar = numStr.charAt(numStr.length - 1);
            if(isNegative && lastChar == ")")
            {
               baseVal = numStr.substr(0,numStr.length - 1);
               numStr = baseVal + this.currencySymbol + lastChar;
            }
            else
            {
               numStr += this.currencySymbol;
            }
         }
         return numStr;
      }
   }
}

