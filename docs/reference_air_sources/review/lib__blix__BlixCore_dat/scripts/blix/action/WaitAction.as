package blix.action
{
   import blix.frame.getEnterFrame;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   
   public class WaitAction extends BasicAction
   {
      
      private var duration:Number;
      
      private var useFrames:Boolean;
      
      private var intervalId:uint;
      
      public function WaitAction(param1:Number, param2:Boolean = false, param3:Boolean = false)
      {
         super(param3);
         this.duration = param1;
         this.useFrames = param2;
      }
      
      override protected function doInvocation() : void
      {
         if(this.duration < 0)
         {
            this.complete();
         }
         if(this.useFrames)
         {
            getEnterFrame().add(this.enterFrameHandler);
         }
         else
         {
            this.intervalId = setTimeout(this.complete,this.duration);
         }
      }
      
      private function enterFrameHandler() : void
      {
         --this.duration;
         if(this.duration <= 0)
         {
            this.complete();
         }
      }
      
      override public function complete() : void
      {
         this.clearIntervals();
         super.complete();
      }
      
      override public function abort() : void
      {
         this.clearIntervals();
         super.abort();
      }
      
      private function clearIntervals() : void
      {
         if(this.useFrames)
         {
            getEnterFrame().remove(this.enterFrameHandler);
         }
         if(this.intervalId != 0)
         {
            clearInterval(this.intervalId);
         }
      }
   }
}

