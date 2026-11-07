package blix.context
{
   import blix.logger.ArrayTarget;
   import flash.display.DisplayObject;
   import flash.events.IEventDispatcher;
   
   public interface IApplicationContext extends IApplicationLoadable
   {
      
      function getRoot() : DisplayObject;
      
      function getSharedEvents() : IEventDispatcher;
      
      function getAppWidth() : Number;
      
      function getAppHeight() : Number;
      
      function getArrayLogTarget() : ArrayTarget;
   }
}

