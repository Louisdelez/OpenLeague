package flexlib.mdi.effects
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.mdi.containers.MDIWindow;
   import flexlib.mdi.effects.effectClasses.MDIGroupEffectItem;
   import flexlib.mdi.managers.MDIManager;
   import mx.effects.Effect;
   import mx.effects.Move;
   import mx.effects.Parallel;
   import mx.effects.Resize;
   
   public class MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
   {
      
      public var duration:Number = 10;
      
      public function MDIEffectsDescriptorBase()
      {
         super();
      }
      
      public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number = 0) : Effect
      {
         var parallel:Parallel = null;
         var resize:Resize = null;
         var move:Move = null;
         parallel = new Parallel();
         parallel.duration = this.duration;
         resize = new Resize(window);
         resize.widthTo = manager.container.width;
         resize.heightTo = manager.container.height - bottomOffset;
         resize.duration = this.duration;
         parallel.addChild(resize);
         move = new Move(window);
         move.xTo = 0;
         move.yTo = 0;
         move.duration = this.duration;
         parallel.addChild(move);
         return parallel;
      }
      
      public function getWindowResizeEndEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowDragStartEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowAddEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point = null) : Effect
      {
         var parallel:Parallel = null;
         var resize:Resize = null;
         var move:Move = null;
         parallel = new Parallel();
         parallel.duration = this.duration;
         resize = new Resize(window);
         resize.widthTo = window.minWidth;
         resize.duration = this.duration;
         resize.heightTo = window.minimizeHeight;
         parallel.addChild(resize);
         if(moveTo != null)
         {
            move = new Move(window);
            move.xTo = moveTo.x;
            move.yTo = moveTo.y;
            move.duration = this.duration;
            parallel.addChild(move);
         }
         return parallel;
      }
      
      public function getWindowResizeStartEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         var resize:Resize = null;
         resize = new Resize(window);
         resize.duration = this.duration;
         resize.widthTo = window.width;
         resize.heightTo = window.height;
         return resize;
      }
      
      public function getTileEffect(items:Array, manager:MDIManager) : Effect
      {
         var parallel:Parallel = null;
         var item:MDIGroupEffectItem = null;
         var move:Move = null;
         parallel = new Parallel();
         parallel.duration = this.duration;
         for each(item in items)
         {
            manager.bringToFront(item.window);
            move = new Move(item.window);
            move.xTo = item.moveTo.x;
            move.yTo = item.moveTo.y;
            move.duration = this.duration;
            parallel.addChild(move);
            item.setWindowSize();
         }
         return parallel;
      }
      
      public function getWindowFocusEndEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowDragEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getCascadeEffect(items:Array, manager:MDIManager) : Effect
      {
         var parallel:Parallel = null;
         var item:MDIGroupEffectItem = null;
         var move:Move = null;
         var resize:Resize = null;
         parallel = new Parallel();
         parallel.duration = this.duration;
         for each(item in items)
         {
            if(!item.isCorrectPosition)
            {
               move = new Move(item.window);
               move.xTo = item.moveTo.x;
               move.yTo = item.moveTo.y;
               move.duration = this.duration;
               parallel.addChild(move);
            }
            if(!item.isCorrectSize)
            {
               resize = new Resize(item.window);
               resize.widthTo = item.widthTo;
               resize.heightTo = item.heightTo;
               resize.duration = this.duration;
               parallel.addChild(resize);
            }
         }
         return parallel;
      }
      
      public function getWindowFocusStartEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowDragEndEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle) : Effect
      {
         var parallel:Parallel = null;
         var resize:Resize = null;
         var move:Move = null;
         parallel = new Parallel();
         parallel.duration = this.duration;
         resize = new Resize(window);
         resize.widthTo = restoreTo.width;
         resize.heightTo = restoreTo.height;
         resize.duration = this.duration;
         parallel.addChild(resize);
         move = new Move(window);
         move.xTo = restoreTo.x;
         move.yTo = restoreTo.y;
         move.duration = this.duration;
         parallel.addChild(move);
         return parallel;
      }
      
      public function getWindowResizeEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         return new Effect();
      }
      
      public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point) : Effect
      {
         var move:Move = null;
         move = new Move(window);
         move.duration = this.duration;
         move.xTo = moveTo.x;
         move.yTo = moveTo.y;
         return move;
      }
   }
}

