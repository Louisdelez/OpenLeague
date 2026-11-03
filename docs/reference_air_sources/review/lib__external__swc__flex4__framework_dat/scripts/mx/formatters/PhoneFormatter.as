package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ResourceBundle("formatters")]
   public class PhoneFormatter extends Formatter
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var _areaCode:Object;
      
      private var areaCodeOverride:Object;
      
      private var _areaCodeFormat:String;
      
      private var areaCodeFormatOverride:String;
      
      private var _formatString:String;
      
      private var formatStringOverride:String;
      
      private var _validPatternChars:String;
      
      private var validPatternCharsOverride:String;
      
      public function PhoneFormatter()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get areaCode() : Object
      {
         return this._areaCode;
      }
      
      public function set areaCode(value:Object) : void
      {
         this.areaCodeOverride = value;
         this._areaCode = value != null ? int(value) : resourceManager.getInt("formatters","areaCode");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get areaCodeFormat() : String
      {
         return this._areaCodeFormat;
      }
      
      public function set areaCodeFormat(value:String) : void
      {
         this.areaCodeFormatOverride = value;
         this._areaCodeFormat = value != null ? value : resourceManager.getString("formatters","areaCodeFormat");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get formatString() : String
      {
         return this._formatString;
      }
      
      public function set formatString(value:String) : void
      {
         this.formatStringOverride = value;
         this._formatString = value != null ? value : resourceManager.getString("formatters","phoneNumberFormat");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get validPatternChars() : String
      {
         return this._validPatternChars;
      }
      
      public function set validPatternChars(value:String) : void
      {
         this.validPatternCharsOverride = value;
         this._validPatternChars = value != null ? value : resourceManager.getString("formatters","validPatternChars");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         this.areaCode = this.areaCodeOverride;
         this.areaCodeFormat = this.areaCodeFormatOverride;
         this.formatString = this.formatStringOverride;
         this.validPatternChars = this.validPatternCharsOverride;
      }
      
      override public function format(value:Object) : String
      {
         var letter:String = null;
         var n:int = 0;
         var i:int = 0;
         var aCodeLen:int = 0;
         if(Boolean(error))
         {
            error = null;
         }
         if(!value || String(value).length == 0 || isNaN(Number(value)))
         {
            error = defaultInvalidValueError;
            return "";
         }
         var fStrLen:int = 0;
         n = this.formatString.length;
         for(i = 0; i < n; i++)
         {
            letter = this.formatString.charAt(i);
            if(letter == "#")
            {
               fStrLen++;
            }
            else if(this.validPatternChars.indexOf(letter) == -1)
            {
               error = defaultInvalidFormatError;
               return "";
            }
         }
         if(String(value).length != fStrLen)
         {
            error = defaultInvalidValueError;
            return "";
         }
         var fStr:String = this.formatString;
         if(fStrLen == 7 && this.areaCode != -1)
         {
            aCodeLen = 0;
            n = this.areaCodeFormat.length;
            for(i = 0; i < n; i++)
            {
               if(this.areaCodeFormat.charAt(i) == "#")
               {
                  aCodeLen++;
               }
            }
            if(aCodeLen == 3 && String(this.areaCode).length == 3)
            {
               fStr = String(this.areaCodeFormat).concat(fStr);
               value = String(this.areaCode).concat(value);
            }
         }
         var dataFormatter:SwitchSymbolFormatter = new SwitchSymbolFormatter();
         return dataFormatter.formatValue(fStr,value);
      }
   }
}

