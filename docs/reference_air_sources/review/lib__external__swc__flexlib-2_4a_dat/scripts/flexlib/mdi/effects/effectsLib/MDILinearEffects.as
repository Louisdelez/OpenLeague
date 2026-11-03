package flexlib.mdi.effects.effectsLib
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flexlib.mdi.containers.MDIWindow;
   import flexlib.mdi.effects.IMDIEffectsDescriptor;
   import flexlib.mdi.effects.MDIEffectsDescriptorBase;
   import flexlib.mdi.managers.MDIManager;
   import mx.effects.Effect;
   import mx.effects.Move;
   import mx.effects.Resize;
   import mx.effects.Sequence;
   
   public class MDILinearEffects extends MDIEffectsDescriptorBase implements IMDIEffectsDescriptor
   {
      
      public function MDILinearEffects()
      {
         super();
      }
      
      override public function getWindowMaximizeEffect(window:MDIWindow, manager:MDIManager, bottomOffset:Number = 0) : Effect
      {
         var seq:Sequence = null;
         var moveX:Move = null;
         var moveY:Move = null;
         var resizeW:Resize = null;
         var resizeH:Resize = null;
         seq = new Sequence(window);
         moveX = new Move(window);
         moveX.xTo = 0;
         moveX.duration = 100;
         seq.addChild(moveX);
         moveY = new Move(window);
         moveY.yTo = 0;
         moveY.duration = 100;
         seq.addChild(moveY);
         resizeW = new Resize(window);
         resizeW.widthTo = manager.container.width;
         resizeW.duration = 100;
         seq.addChild(resizeW);
         resizeH = new Resize(window);
         resizeH.heightTo = manager.container.height - bottomOffset;
         resizeH.duration = 100;
         seq.addChild(resizeH);
         seq.end();
         return seq;
      }
      
      override public function getWindowMinimizeEffect(window:MDIWindow, manager:MDIManager, moveTo:Point = null) : Effect
      {
         var seq:Sequence = null;
         var resizeW:Resize = null;
         var resizeH:Resize = null;
         var moveX:Move = null;
         var moveY:Move = null;
         seq = new Sequence();
         resizeW = new Resize(window);
         resizeW.widthTo = window.minWidth;
         resizeW.duration = 100;
         seq.addChild(resizeW);
         resizeH = new Resize(window);
         resizeH.heightTo = window.minimizeHeight;
         resizeH.duration = 100;
         seq.addChild(resizeH);
         moveX = new Move(window);
         moveX.xTo = moveTo.x;
         moveX.duration = 100;
         seq.addChild(moveX);
         moveY = new Move(window);
         moveY.yTo = moveTo.y;
         moveY.duration = 100;
         seq.addChild(moveY);
         seq.end();
         return seq;
      }
      
      override public function getWindowRestoreEffect(window:MDIWindow, manager:MDIManager, restoreTo:Rectangle) : Effect
      {
         var seq:Sequence = null;
         var moveY:Move = null;
         var moveX:Move = null;
         var resizeW:Resize = null;
         var resizeH:Resize = null;
         seq = new Sequence();
         moveY = new Move(window);
         moveY.yTo = restoreTo.y;
         moveY.duration = 100;
         seq.addChild(moveY);
         moveX = new Move(window);
         moveX.xTo = restoreTo.x;
         moveX.duration = 100;
         seq.addChild(moveX);
         resizeW = new Resize(window);
         resizeW.widthTo = restoreTo.width;
         resizeW.duration = 100;
         seq.addChild(resizeW);
         resizeH = new Resize(window);
         resizeH.heightTo = restoreTo.height;
         resizeH.duration = 100;
         seq.addChild(resizeH);
         seq.end();
         return seq;
      }
      
      override public function getWindowCloseEffect(window:MDIWindow, manager:MDIManager) : Effect
      {
         var resize:Resize = null;
         window.minWidth = window.minHeight = 1;
         resize = new Resize(window);
         resize.widthTo = resize.heightTo = 1;
         resize.duration = 100;
         return resize;
      }
   }
}

