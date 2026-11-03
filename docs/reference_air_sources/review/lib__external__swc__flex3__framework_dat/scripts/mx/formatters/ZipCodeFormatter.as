package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ResourceBundle("formatters")]
   public class ZipCodeFormatter extends Formatter
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const VALID_LENGTHS:String = "9,5,6";
      
      private var formatStringOverride:String;
      
      private var _formatString:String;
      
      public function ZipCodeFormatter()
      {
         super();
      }
      
      public function set formatString(value:String) : void
      {
         formatStringOverride = value;
         _formatString = value != null ? value : resourceManager.getString("formatters","zipCodeFormat");
      }
      
      override protected function resourcesChanged() : void
      {
         super.resourcesChanged();
         formatString = formatStringOverride;
      }
      
      override public function format(value:Object) : String
      {
         var fStrLen:int = 0;
         var i:int = 0;
         if(Boolean(error))
         {
            error = null;
         }
         var uStrLen:int = String(value).length;
         if(VALID_LENGTHS.indexOf("" + uStrLen) == -1)
         {
            error = defaultInvalidValueError;
            return "";
         }
         if(formatString == "#####-####" || formatString == "##### ####")
         {
            if(uStrLen != 5 && uStrLen != 9)
            {
               error = defaultInvalidValueError;
               return "";
            }
            fStrLen = 9;
         }
         else if(formatString == "#####")
         {
            if(uStrLen != 5 && uStrLen != 9)
            {
               error = defaultInvalidValueError;
               return "";
            }
            fStrLen = 5;
         }
         else
         {
            if(!(formatString == "### ###" || formatString == "###-###"))
            {
               error = defaultInvalidFormatError;
               return "";
            }
            if(uStrLen != 6)
            {
               error = defaultInvalidValueError;
               return "";
            }
            fStrLen = 6;
         }
         if(fStrLen == 6 && uStrLen != 6)
         {
            error = defaultInvalidValueError;
            return "";
         }
         if(fStrLen == 6)
         {
            for(i = 0; i < uStrLen; i++)
            {
               if((value.charCodeAt(i) < 64 || value.charCodeAt(i) > 90) && (value.charCodeAt(i) < 48 || value.charCodeAt(i) > 57))
               {
                  error = defaultInvalidValueError;
                  return "";
               }
            }
         }
         else if(value === null || isNaN(Number(value)))
         {
            error = defaultInvalidValueError;
            return "";
         }
         if(fStrLen == 9 && uStrLen == 5)
         {
            value = String(value).concat("0000");
         }
         if(fStrLen == 5 && uStrLen == 9)
         {
            value = value.substr(0,5);
         }
         var dataFormatter:SwitchSymbolFormatter = new SwitchSymbolFormatter();
         return dataFormatter.formatValue(formatString,value);
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get formatString() : String
      {
         return _formatString;
      }
   }
}

