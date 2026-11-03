package blix.util.keyboard
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public function addKeyListener(param1:DisplayObjectProxy, param2:Function, param3:String = "keyDown") : void
   {
      var asset:DisplayObject = null;
      var addedToStageHandler:Function = null;
      var removedFromStageHandler:Function = null;
      var target:DisplayObjectProxy = param1;
      var handler:Function = param2;
      var keyEvent:String = param3;
      addedToStageHandler = function(param1:Event = null):void
      {
         asset = param1.currentTarget as DisplayObject;
         asset.stage.addEventListener(keyEvent,handler,false,0,true);
      };
      removedFromStageHandler = function(param1:Event):void
      {
         asset = param1.currentTarget as DisplayObject;
         asset.stage.removeEventListener(keyEvent,handler);
      };
      var assetChangedHandler:Function = function(param1:IDisplayChild, param2:DisplayObject, param3:DisplayObject):void
      {
         if(param2 != null)
         {
            param2.removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
            param2.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
         }
         if(param3 != null)
         {
            param3.addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler,false,0,true);
            param3.addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler,false,0,true);
            if(param3.stage != null)
            {
               param3.stage.addEventListener(keyEvent,handler,false,0,true);
            }
         }
      };
      target.getAssetChanged().add(assetChangedHandler);
      assetChangedHandler(target,null,target.getAsset());
   }
}

