package mx.resources
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Locale
   {
      
      private static var currentLocale:Locale;
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var localeString:String;
      
      private var _language:String;
      
      private var _country:String;
      
      private var _variant:String;
      
      public function Locale(localeString:String)
      {
         super();
         this.localeString = localeString;
         var parts:Array = localeString.split("_");
         if(parts.length > 0)
         {
            this._language = parts[0];
         }
         if(parts.length > 1)
         {
            this._country = parts[1];
         }
         if(parts.length > 2)
         {
            this._variant = parts.slice(2).join("_");
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get language() : String
      {
         return this._language;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get country() : String
      {
         return this._country;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get variant() : String
      {
         return this._variant;
      }
      
      public function toString() : String
      {
         return this.localeString;
      }
   }
}

