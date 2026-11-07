package flash.events
{
   import flash.net.drm.*;
   
   [API("661")]
   internal class DRMCustomProperties
   {
      
      public function DRMCustomProperties()
      {
         super();
      }
      
      private static function createObj() : Object
      {
         return new Object();
      }
      
      private static function setCustomProp(obj:Object, key:String, value:String) : void
      {
         obj[key] = value;
      }
      
      private static function setCustomProp15(obj:Object, key:String, value:String) : void
      {
         obj[unescape(key.replace(/\+/g," "))] = unescape(value.replace(/\+/g," "));
      }
   }
}

