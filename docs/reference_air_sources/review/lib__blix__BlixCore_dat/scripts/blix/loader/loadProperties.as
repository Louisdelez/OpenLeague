package blix.loader
{
   import blix.util.string.strTrim;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public function loadProperties(param1:URLRequest, param2:Function, param3:Function = null, param4:Function = null) : URLLoader
   {
      var urlRequest:URLRequest = param1;
      var completedHandler:Function = param2;
      var erredHandler:Function = param3;
      var progressHandler:Function = param4;
      var urlLoader:URLLoader = loadRequest(urlRequest,function(param1:Event):void
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc2_:* = param1.currentTarget as URLLoader;
         var _loc3_:* = _loc2_.data;
         var _loc4_:* = _loc3_.split("\n");
         var _loc5_:* = {};
         for each(_loc6_ in _loc4_)
         {
            _loc7_ = _loc6_.indexOf("=");
            if(_loc7_ != -1)
            {
               _loc8_ = strTrim(_loc6_.substr(0,_loc7_));
               _loc9_ = strTrim(_loc6_.substr(_loc7_ + 1));
               _loc5_[_loc8_] = _loc9_;
            }
         }
         completedHandler(_loc5_);
      },erredHandler,progressHandler);
      return urlLoader;
   }
}

