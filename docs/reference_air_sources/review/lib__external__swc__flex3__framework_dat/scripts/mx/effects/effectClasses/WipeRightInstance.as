package mx.effects.effectClasses
{
   import mx.controls.SWFLoader;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class WipeRightInstance extends MaskEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function WipeRightInstance(target:Object)
      {
         super(target);
      }
      
      override protected function initMaskEffect() : void
      {
         var angle:Number = NaN;
         super.initMaskEffect();
         var targetWidth:Number = target is SWFLoader && Boolean(target.content) ? SWFLoader(target).contentWidth : targetVisualBounds.width / Math.abs(target.scaleX);
         if(target.rotation != 0)
         {
            angle = target.rotation * Math.PI / 180;
            targetWidth = Math.abs(targetVisualBounds.width * Math.cos(angle) - targetVisualBounds.height * Math.sin(angle));
         }
         if(showTarget)
         {
            xFrom = -effectMask.width + targetVisualBounds.x;
            yFrom = targetVisualBounds.y;
            xTo = effectMask.width <= targetWidth ? targetWidth - effectMask.width + targetVisualBounds.x : targetVisualBounds.x;
            yTo = targetVisualBounds.y;
         }
         else
         {
            xFrom = effectMask.width <= targetWidth ? targetVisualBounds.x : targetWidth - effectMask.width + targetVisualBounds.x;
            yFrom = targetVisualBounds.y;
            xTo = targetWidth + targetVisualBounds.x;
            yTo = targetVisualBounds.y;
         }
      }
   }
}

