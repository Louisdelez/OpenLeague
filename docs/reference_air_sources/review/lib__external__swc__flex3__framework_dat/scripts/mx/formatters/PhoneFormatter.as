package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ResourceBundle("formatters")]
   public class PhoneFormatter extends Formatter
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var areaCodeOverride:Object;
      
      private var _formatString:String;
      
      private var _validPatternChars:String;
      
      private var _areaCodeFormat:String;
      
      private var formatStringOverride:String;
      
      private var areaCodeFormatOverride:String;
      
      private var validPatternCharsOverride:String;
      
      private var _areaCode:Object;
      
      public function PhoneFormatter()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get validPatternChars() : String
      {
         return _validPatternChars;
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         areaCode = areaCodeOverride;
         areaCodeFormat = areaCodeFormatOverride;
         formatString = formatStringOverride;
         validPatternChars = validPatternCharsOverride;
      }
      
      public function set validPatternChars(value:String) : void
      {
         validPatternCharsOverride = value;
         _validPatternChars = value != null ? value : resourceManager.getString("formatters","validPatternChars");
      }
      
      public function set formatString(value:String) : void
      {
         formatStringOverride = value;
         _formatString = value != null ? value : resourceManager.getString("formatters","phoneNumberFormat");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get areaCode() : Object
      {
         return _areaCode;
      }
      
      public function set areaCodeFormat(value:String) : void
      {
         areaCodeFormatOverride = value;
         _areaCodeFormat = value != null ? value : resourceManager.getString("formatters","areaCodeFormat");
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get formatString() : String
      {
         return _formatString;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get areaCodeFormat() : String
      {
         return _areaCodeFormat;
      }
      
      public function set areaCode(value:Object) : void
      {
         areaCodeOverride = value;
         _areaCode = value != null ? int(value) : resourceManager.getInt("formatters","areaCode");
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
         n = formatString.length;
         for(i = 0; i < n; i++)
         {
            letter = formatString.charAt(i);
            if(letter == "#")
            {
               fStrLen++;
            }
            else if(validPatternChars.indexOf(letter) == -1)
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
         var fStr:String = formatString;
         if(fStrLen == 7 && areaCode != -1)
         {
            aCodeLen = 0;
            n = areaCodeFormat.length;
            for(i = 0; i < n; i++)
            {
               if(areaCodeFormat.charAt(i) == "#")
               {
                  aCodeLen++;
               }
            }
            if(aCodeLen == 3 && String(areaCode).length == 3)
            {
               fStr = String(areaCodeFormat).concat(fStr);
               value = String(areaCode).concat(value);
            }
         }
         var dataFormatter:SwitchSymbolFormatter = new SwitchSymbolFormatter();
         return dataFormatter.formatValue(fStr,value);
      }
   }
}

