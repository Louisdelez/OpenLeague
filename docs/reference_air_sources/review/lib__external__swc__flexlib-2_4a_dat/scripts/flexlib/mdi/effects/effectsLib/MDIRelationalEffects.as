package flexlib.mdi.effects.effectsLib
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.mdi.containers.MDIWindow;
   import flexlib.mdi.managers.MDIManager;
   import mx.effects.Effect;
   import mx.effects.Move;
   import mx.effects.Parallel;
   import mx.events.EffectEvent;
   
   public class MDIRelationalEffects extends MDIVistaEffects
   {
      
      public function MDIRelationalEffects()
      {
         super();
      }
      
      override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle) : Effect
      {
         var parallel:Parallel = null;
         parallel = super.getWindowRestoreEffect(window,manager,restoreTo) as Parallel;
         parallel.addEventListener(EffectEvent.EFFECT_START,function():void
         {
            manager.tile(true,10);
         });
         return parallel;
      }
      
      override public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point) : Effect
      {
         var move:Move = null;
         move = super.reTileMinWindowsEffect(window,manager,moveTo) as Move;
         manager.bringToFront(window);
         return move;
      }
      
      override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point = null) : Effect
      {
         var parallel:Parallel = null;
         parallel = super.getWindowMinimizeEffect(window,manager,moveTo) as Parallel;
         parallel.addEventListener(EffectEvent.EFFECT_END,function():void
         {
            manager.tile(true,10);
         });
         return parallel;
      }
   }
}

