package blix.components.loader
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.context.Context;
   import blix.frame.getEnterFrame;
   import blix.util.math.clamp;
   import flash.display.DisplayObject;
   
   public class ProgressIndicator extends MovieClipProxy
   {
      
      protected var _percent:Number = -1;
      
      public function ProgressIndicator(param1:Context)
      {
         super(param1);
      }
      
      override protected function unconfigureAsset(param1:DisplayObject) : void
      {
         super.unconfigureAsset(param1);
         if(Boolean(param1))
         {
            getEnterFrame().remove(this.enterFrameHandler);
         }
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         if(Boolean(param1))
         {
            getEnterFrame().add(this.enterFrameHandler);
         }
      }
      
      public function setPercent(param1:Number) : void
      {
         if(this._percent == param1)
         {
            return;
         }
         this._percent = param1;
         if(Boolean(_asset))
         {
            getEnterFrame().add(this.enterFrameHandler);
         }
      }
      
      public function resetProgress() : void
      {
         gotoAndStop(1);
         getEnterFrame().remove(this.enterFrameHandler);
      }
      
      protected function enterFrameHandler() : void
      {
         var _loc1_:Number = Number(clamp(this._percent,0,1));
         var _loc2_:int = int(getCurrentFrame());
         var _loc3_:int = Math.floor(_loc1_ * (getTotalFrames() - 1)) + 1;
         if(_loc2_ == _loc3_)
         {
            stop();
            getEnterFrame().remove(this.enterFrameHandler);
         }
         else if(_loc3_ > _loc2_)
         {
            nextFrame();
         }
         else
         {
            prevFrame();
         }
      }
      
      override public function destroy() : void
      {
         super.destroy();
         getEnterFrame().remove(this.enterFrameHandler);
      }
   }
}

