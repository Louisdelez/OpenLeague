package com.riotgames.rust.components.list
{
   import blix.assets.proxy.DisplayObjectProxy;
   
   public interface IListLayoutHelper
   {
      
      function setPosition(param1:DisplayObjectProxy, param2:Number) : void;
      
      function getSpan(param1:DisplayObjectProxy) : Number;
      
      function getPosition(param1:DisplayObjectProxy) : Number;
   }
}

