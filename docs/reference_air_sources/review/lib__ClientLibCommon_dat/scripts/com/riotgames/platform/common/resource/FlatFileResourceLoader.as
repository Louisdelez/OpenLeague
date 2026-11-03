package com.riotgames.platform.common.resource
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.rust.resource.IRustResourceLoader;
   
   public class FlatFileResourceLoader implements IRustResourceLoader
   {
      
      private var bundleId:String;
      
      public function FlatFileResourceLoader()
      {
         super();
      }
      
      public function init(param1:String, param2:String, param3:String) : void
      {
         this.bundleId = param1;
         RiotResourceLoader.registerFlatFile(param1,param2 + param3);
      }
      
      public function getString(param1:String, param2:Array = null) : String
      {
         var _loc3_:String = RiotResourceLoader.getResourceString(this.bundleId,param1,"**" + param1,param2);
         return _loc3_.split("\\n").join("\n");
      }
   }
}

