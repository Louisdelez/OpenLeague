package flexlib.mdi.effects
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.mdi.containers.MDIWindow;
   import flexlib.mdi.managers.MDIManager;
   import mx.effects.Effect;
   
   public interface IMDIEffectsDescriptor
   {
      
      function getWindowRestoreEffect(param1:MDIWindow, param2:MDIManager, param3:Rectangle) : Effect;
      
      function getWindowMaximizeEffect(param1:MDIWindow, param2:MDIManager, param3:Number = 0) : Effect;
      
      function getWindowFocusStartEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowCloseEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowDragEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowAddEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowResizeEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowResizeStartEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowDragEndEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowResizeEndEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowMinimizeEffect(param1:MDIWindow, param2:MDIManager, param3:Point = null) : Effect;
      
      function getCascadeEffect(param1:Array, param2:MDIManager) : Effect;
      
      function getWindowDragStartEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function getWindowFocusEndEffect(param1:MDIWindow, param2:MDIManager) : Effect;
      
      function reTileMinWindowsEffect(param1:MDIWindow, param2:MDIManager, param3:Point) : Effect;
      
      function getTileEffect(param1:Array, param2:MDIManager) : Effect;
   }
}

