package blix.loader
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public function loadRequest(param1:URLRequest, param2:Function, param3:Function = null, param4:Function = null, param5:String = null) : URLLoader
   {
      var _loc6_:URLLoader = new URLLoader();
      _loc6_.dataFormat = param5;
      if(param2 != null)
      {
         _loc6_.addEventListener(Event.COMPLETE,param2);
      }
      if(param3 != null)
      {
         _loc6_.addEventListener(IOErrorEvent.IO_ERROR,param3);
         _loc6_.addEventListener(SecurityErrorEvent.SECURITY_ERROR,param3);
      }
      if(param4 != null)
      {
         _loc6_.addEventListener(ProgressEvent.PROGRESS,param4);
      }
      _loc6_.load(param1);
      return _loc6_;
   }
}

