package com.riotgames.platform.gameclient.config
{
   import flash.utils.Dictionary;
   
   public class ModuleEntry
   {
      
      public var modulePath:String;
      
      public var name:String;
      
      public var providers:Vector.<ProviderEntry>;
      
      public var extraData:Dictionary;
      
      public function ModuleEntry()
      {
         super();
      }
      
      public function toString() : String
      {
         return "[ModuleEntry name=" + this.name + "]";
      }
   }
}

