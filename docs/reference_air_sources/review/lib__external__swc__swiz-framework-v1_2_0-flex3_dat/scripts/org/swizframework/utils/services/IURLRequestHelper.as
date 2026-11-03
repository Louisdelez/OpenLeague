package org.swizframework.utils.services
{
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public interface IURLRequestHelper
   {
      
      function executeURLRequest(param1:URLRequest, param2:Function, param3:Function = null, param4:Function = null, param5:Function = null, param6:Array = null) : URLLoader;
   }
}

