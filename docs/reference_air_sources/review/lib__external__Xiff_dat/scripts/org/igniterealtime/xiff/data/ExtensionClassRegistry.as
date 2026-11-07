package org.igniterealtime.xiff.data
{
   public class ExtensionClassRegistry
   {
      
      private static var myClasses:Array = new Array();
      
      public function ExtensionClassRegistry()
      {
         super();
      }
      
      public static function register(param1:Class) : Boolean
      {
         var _loc2_:IExtension = new param1();
         if(_loc2_ is IExtension)
         {
            myClasses[_loc2_.getNS()] = param1;
            return true;
         }
         return false;
      }
      
      public static function lookup(param1:String) : Class
      {
         return myClasses[param1];
      }
   }
}

