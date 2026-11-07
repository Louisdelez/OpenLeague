package mx.effects.effectClasses
{
   import mx.controls.SWFLoader;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class WipeDownInstance extends MaskEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function WipeDownInstance(target:Object)
      {
         super(target);
      }
      
      override protected function initMaskEffect() : void
      {
         var angle:Number = NaN;
         super.initMaskEffect();
         var targetHeight:Number = target is SWFLoader && Boolean(target.content) ? SWFLoader(target).contentHeight : targetVisualBounds.height / Math.abs(target.scaleY);
         if(target.rotation != 0)
         {
            angle = target.rotation * Math.PI / 180;
            targetHeight = Math.abs(targetVisualBounds.width * Math.sin(angle) + targetVisualBounds.height * Math.cos(angle));
         }
         if(showTarget)
         {
            xFrom = targetVisualBounds.x;
            yFrom = -effectMask.height + targetVisualBounds.y;
            xTo = targetVisualBounds.x;
            yTo = effectMask.height <= targetHeight ? targetHeight - effectMask.height + targetVisualBounds.y : targetVisualBounds.y;
         }
         else
         {
            xFrom = targetVisualBounds.x;
            yFrom = effectMask.height <= targetHeight ? targetVisualBounds.y : targetHeight - effectMask.height + targetVisualBounds.y;
            xTo = targetVisualBounds.x;
            yTo = targetHeight + targetVisualBounds.y;
         }
      }
   }
}

