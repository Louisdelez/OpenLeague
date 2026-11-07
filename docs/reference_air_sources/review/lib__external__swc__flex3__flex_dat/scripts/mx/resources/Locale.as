package mx.resources
{
   import flash.utils.getDefinitionByName;
   import mx.core.mx_internal;
   import mx.managers.ISystemManager;
   
   use namespace mx_internal;
   
   public class Locale
   {
      
      private static var currentLocale:Locale;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
      
      private var _variant:String;
      
      private var localeString:String;
      
      private var _language:String;
      
      private var _country:String;
      
      public function Locale(localeString:String)
      {
         super();
         this.localeString = localeString;
         var parts:Array = localeString.split("_");
         if(parts.length > 0)
         {
            _language = parts[0];
         }
         if(parts.length > 1)
         {
            _country = parts[1];
         }
         if(parts.length > 2)
         {
            _variant = parts.slice(2).join("_");
         }
      }
      
      [Deprecated(replacement="ResourceManager.localeChain",since="3.0")]
      public static function getCurrent(sm:ISystemManager) : Locale
      {
         var compiledLocales:Array = null;
         if(!currentLocale)
         {
            compiledLocales = sm.info()["compiledLocales"];
            if(compiledLocales != null && compiledLocales.length == 1)
            {
               currentLocale = new Locale(compiledLocales[0]);
            }
         }
         return currentLocale;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get variant() : String
      {
         return _variant;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get language() : String
      {
         return _language;
      }
      
      public function toString() : String
      {
         return localeString;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get country() : String
      {
         return _country;
      }
   }
}

