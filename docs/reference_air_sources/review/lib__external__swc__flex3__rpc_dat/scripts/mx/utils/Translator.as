package mx.utils
{
   import flash.system.ApplicationDomain;
   import flash.utils.getQualifiedClassName;
   import mx.resources.ResourceBundle;
   
   [ExcludeClass]
   public class Translator
   {
      
      private static const TRANSLATORS:Object = {};
      
      [ResourceBundle("messaging")]
      private static var messagingBundle:ResourceBundle = ResourceBundle.getResourceBundle("messaging",ApplicationDomain.currentDomain);
      
      [ResourceBundle("rpc")]
      private static var rpcBundle:ResourceBundle = ResourceBundle.getResourceBundle("rpc",ApplicationDomain.currentDomain);
      
      private var bundle:ResourceBundle = null;
      
      private var bundleName:String;
      
      public function Translator(bundleName:String)
      {
         super();
         this.bundleName = bundleName;
      }
      
      public static function getDefaultInstanceFor(source:Class) : Translator
      {
         var qualifiedName:String = getQualifiedClassName(source);
         var firstSeparator:int = qualifiedName.indexOf(".");
         var startIndex:int = firstSeparator + 1;
         var secondSeparator:int = qualifiedName.indexOf(".",startIndex);
         if(secondSeparator < 0)
         {
            secondSeparator = qualifiedName.indexOf(":",startIndex);
         }
         var bundleName:String = qualifiedName.slice(startIndex,secondSeparator);
         return getInstanceFor(bundleName);
      }
      
      public static function getMessagingInstance() : Translator
      {
         return getInstanceFor("messaging");
      }
      
      public static function getInstanceFor(bundleName:String) : Translator
      {
         var result:Translator = TRANSLATORS[bundleName];
         if(!result)
         {
            result = new Translator(bundleName);
            TRANSLATORS[bundleName] = result;
         }
         return result;
      }
      
      public function textOf(key:String, ... rest) : String
      {
         if(!bundle)
         {
            if(bundleName == "messaging")
            {
               bundle = messagingBundle;
            }
            else if(bundleName == "rpc")
            {
               bundle = rpcBundle;
            }
         }
         return Boolean(bundle) ? StringUtil.substitute(bundle["getString"](key),rest) : "Key " + key + " was not found in resource bundle " + bundleName;
      }
   }
}

