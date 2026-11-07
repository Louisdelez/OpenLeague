package com.riotgames.rust.resource
{
   public interface IRustResourceLoader
   {
      
      function init(param1:String, param2:String, param3:String) : void;
      
      function getString(param1:String, param2:Array = null) : String;
   }
}

