package mx.utils
{
   import flash.utils.getQualifiedClassName;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("rpc")]
   [ResourceBundle("messaging")]
   [ExcludeClass]
   public class Translator
   {
      
      private static const TRANSLATORS:Object = {};
      
      private var _resourceManager:IResourceManager = ResourceManager.getInstance();
      
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
      
      public static function getMessagingInstance() : Translator
      {
         return getInstanceFor("messaging");
      }
      
      public function textOf(key:String, ... rest) : String
      {
         return this._resourceManager.getString(this.bundleName,key,rest);
      }
   }
}

