package mx.formatters
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class SwitchSymbolFormatter
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var numberSymbol:String;
      
      private var isValid:Boolean;
      
      public function SwitchSymbolFormatter(numberSymbol:String = "#")
      {
         super();
         this.numberSymbol = numberSymbol;
         isValid = true;
      }
      
      public function formatValue(format:String, source:Object) : String
      {
         var letter:String = null;
         var numStr:String = "";
         var uStrIndx:int = 0;
         var n:int = format.length;
         for(var i:int = 0; i < n; i++)
         {
            letter = format.charAt(i);
            if(letter == numberSymbol)
            {
               numStr += String(source).charAt(uStrIndx++);
            }
            else
            {
               numStr += format.charAt(i);
            }
         }
         return numStr;
      }
   }
}

