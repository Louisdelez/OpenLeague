package mx.effects.effectClasses
{
   import mx.controls.SWFLoader;
   
   public class WipeLeftInstance extends MaskEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function WipeLeftInstance(target:Object)
      {
         super(target);
      }
      
      override protected function initMaskEffect() : void
      {
         var angle:Number = NaN;
         super.initMaskEffect();
         var targetWidth:Number = target is SWFLoader && Boolean(target.content) ? Number(SWFLoader(target).contentWidth) : targetVisualBounds.width / Math.abs(target.scaleX);
         var targetHeight:Number = target is SWFLoader && Boolean(target.content) ? Number(SWFLoader(target).contentHeight) : targetVisualBounds.height / Math.abs(target.scaleY);
         if(target.rotation != 0)
         {
            angle = target.rotation * Math.PI / 180;
            targetWidth = Math.abs(targetWidth * Math.cos(angle) - targetHeight * Math.sin(angle));
         }
         if(showTarget)
         {
            xFrom = targetWidth + targetVisualBounds.x;
            yFrom = targetVisualBounds.y;
            xTo = effectMask.width <= targetWidth ? targetWidth - effectMask.width + targetVisualBounds.x : Number(targetVisualBounds.x);
            yTo = targetVisualBounds.y;
         }
         else
         {
            xFrom = effectMask.width <= targetWidth ? targetWidth - effectMask.width + targetVisualBounds.x : Number(targetVisualBounds.x);
            yFrom = targetVisualBounds.y;
            xTo = -effectMask.width + targetVisualBounds.x;
            yTo = targetVisualBounds.y;
         }
      }
   }
}

