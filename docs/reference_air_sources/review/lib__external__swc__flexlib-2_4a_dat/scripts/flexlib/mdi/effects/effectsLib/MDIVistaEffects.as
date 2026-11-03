package flexlib.mdi.effects.effectsLib
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.mdi.containers.MDIWindow;
   import flexlib.mdi.effects.IMDIEffectsDescriptor;
   import flexlib.mdi.effects.MDIEffectsDescriptorBase;
   import flexlib.mdi.effects.effectClasses.MDIGroupEffectItem;
   import flexlib.mdi.managers.MDIManager;
   import mx.effects.Blur;
   import mx.effects.Effect;
   import mx.effects.Move;
   import mx.effects.Parallel;
   import mx.effects.Resize;
   import mx.effects.Sequence;
   
   public class MDIVistaEffects extends MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
   {
      
      public function MDIVistaEffects(duration:Number = 150)
      {
         super();
         this.duration = duration;
      }
      
      override public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number = 0) : Effect
      {
         var parallel:Parallel = null;
         var move:Move = null;
         var resize:Resize = null;
         parallel = new Parallel(window);
         move = new Move(window);
         move.xTo = 0;
         move.yTo = 0;
         move.duration = 300;
         parallel.addChild(move);
         resize = new Resize(window);
         resize.heightTo = manager.container.height - bottomOffset;
         resize.widthTo = manager.container.width;
         resize.duration = this.duration;
         parallel.addChild(resize);
         parallel.end();
         return parallel;
      }
      
      override public function reTileMinWindowsEffect(window:MDIWindow, manager:MDIManager, moveTo:Point) : Effect
      {
         var move:Move = null;
         move = new Move(window);
         move.xTo = moveTo.x;
         move.yTo = moveTo.y;
         move.duration = this.duration;
         move.end();
         return move;
      }
      
      override public function getWindowAddEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         var parallel:Parallel = null;
         var blurSequence:Sequence = null;
         var blurOut:Blur = null;
         var blurIn:Blur = null;
         parallel = new Parallel(window);
         blurSequence = new Sequence();
         blurOut = new Blur();
         blurOut.blurXFrom = 0;
         blurOut.blurYFrom = 0;
         blurOut.blurXTo = 10;
         blurOut.blurYTo = 10;
         blurSequence.addChild(blurOut);
         blurIn = new Blur();
         blurIn.blurXFrom = 10;
         blurIn.blurYFrom = 10;
         blurIn.blurXTo = 0;
         blurIn.blurYTo = 0;
         blurSequence.addChild(blurIn);
         parallel.addChild(blurSequence);
         parallel.duration = this.duration;
         return parallel;
      }
      
      override public function getTileEffect(items:Array, manager:MDIManager) : Effect
      {
         var effect:Parallel = null;
         var item:MDIGroupEffectItem = null;
         var move:Move = null;
         effect = new Parallel();
         for each(item in items)
         {
            if(!item.isCorrectPosition)
            {
               move = new Move(item.window);
               move.xTo = item.moveTo.x;
               move.yTo = item.moveTo.y;
               effect.addChild(move);
            }
            if(!item.isCorrectSize)
            {
               item.setWindowSize();
            }
         }
         effect.duration = this.duration;
         return effect;
      }
      
      override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point = null) : Effect
      {
         var sequence:Sequence = null;
         var parallel:Parallel = null;
         var resize:Resize = null;
         var blurOut:Blur = null;
         var move:Move = null;
         var blurIn:Blur = null;
         sequence = new Sequence(window);
         parallel = new Parallel();
         resize = new Resize(window);
         resize.widthTo = window.minWidth;
         resize.heightTo = window.minimizeHeight;
         resize.duration = this.duration;
         parallel.addChild(resize);
         blurOut = new Blur();
         blurOut.blurXFrom = 1;
         blurOut.blurXTo = 0.2;
         blurOut.blurYFrom = 1;
         blurOut.blurYTo = 0.2;
         sequence.addChild(parallel);
         move = new Move(window);
         move.xTo = moveTo.x;
         move.yTo = moveTo.y;
         move.duration = 150;
         sequence.addChild(move);
         blurIn = new Blur();
         blurOut.blurXFrom = 0.2;
         blurOut.blurXTo = 1;
         blurOut.blurYFrom = 0.2;
         blurOut.blurYTo = 1;
         return sequence;
      }
      
      override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle) : Effect
      {
         var parallel:Parallel = null;
         var move:Move = null;
         var resize:Resize = null;
         parallel = new Parallel(window);
         move = new Move(window);
         move.xTo = restoreTo.x;
         move.yTo = restoreTo.y;
         move.duration = 150;
         parallel.addChild(move);
         resize = new Resize(window);
         resize.widthTo = restoreTo.width;
         resize.heightTo = restoreTo.height;
         resize.duration = this.duration;
         parallel.addChild(resize);
         parallel.end();
         return parallel;
      }
      
      override public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         var blur:Blur = null;
         blur = new Blur(window);
         blur.blurXFrom = 0;
         blur.blurYFrom = 0;
         blur.blurXTo = 10;
         blur.blurYTo = 10;
         blur.duration = this.duration;
         return blur;
      }
      
      override public function getCascadeEffect(items:Array, manager:MDIManager) : Effect
      {
         var parallel:Parallel = null;
         var item:MDIGroupEffectItem = null;
         var move:Move = null;
         var resize:Resize = null;
         parallel = new Parallel();
         for each(item in items)
         {
            move = new Move(item.window);
            move.xTo = item.moveTo.x;
            move.yTo = item.moveTo.y;
            move.duration = this.duration;
            parallel.addChild(move);
            resize = new Resize(item.window);
            resize.widthTo = item.widthTo;
            resize.heightTo = item.heightTo;
            resize.duration = this.duration;
            parallel.addChild(resize);
         }
         return parallel;
      }
      
      private function minEasingFunction(t:Number, b:Number, c:Number, d:Number) : Number
      {
         var ts:Number = NaN;
         var tc:Number = NaN;
         t = t / d;
         ts = t * t;
         tc = ts * t;
         return b + c * (0 * tc * ts + -2 * ts * ts + 10 * tc + -15 * ts + 8 * t);
      }
      
      private function cascadeEasingFunction(t:Number, b:Number, c:Number, d:Number) : Number
      {
         var ts:Number = NaN;
         var tc:Number = NaN;
         t = t / d;
         ts = t * t;
         tc = ts * t;
         return b + c * (33 * tc * ts + -106 * ts * ts + 126 * tc + -67 * ts + 15 * t);
      }
   }
}

