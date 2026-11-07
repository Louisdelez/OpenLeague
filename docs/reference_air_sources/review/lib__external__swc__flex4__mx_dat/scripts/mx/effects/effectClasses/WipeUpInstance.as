package mx.effects.effectClasses
{
   import mx.controls.SWFLoader;
   
   public class WipeUpInstance extends MaskEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function WipeUpInstance(target:Object)
      {
         super(target);
      }
      
      override protected function initMaskEffect() : void
      {
         var angle:Number = NaN;
         super.initMaskEffect();
         var targetHeight:Number = target is SWFLoader && Boolean(target.content) ? Number(SWFLoader(target).contentHeight) : targetVisualBounds.height / Math.abs(target.scaleY);
         if(target.rotation != 0)
         {
            angle = target.rotation * Math.PI / 180;
            targetHeight = Math.abs(targetVisualBounds.width * Math.sin(angle) + targetVisualBounds.height * Math.cos(angle));
         }
         if(showTarget)
         {
            xFrom = targetVisualBounds.x;
            yFrom = targetHeight + targetVisualBounds.y;
            xTo = targetVisualBounds.x;
            yTo = effectMask.height <= targetHeight ? Number(targetVisualBounds.y) : targetHeight - effectMask.height + targetVisualBounds.y;
         }
         else
         {
            xFrom = targetVisualBounds.x;
            yFrom = effectMask.height <= targetHeight ? targetHeight - effectMask.height + targetVisualBounds.y : Number(targetVisualBounds.y);
            xTo = targetVisualBounds.x;
            yTo = -effectMask.height + targetVisualBounds.y;
         }
      }
   }
}

