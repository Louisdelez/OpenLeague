package mx.effects.effectClasses
{
   import mx.controls.SWFLoader;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class IrisInstance extends MaskEffectInstance
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function IrisInstance(target:Object)
      {
         super(target);
      }
      
      override protected function initMaskEffect() : void
      {
         super.initMaskEffect();
         var targetHeight:Number = target is SWFLoader && Boolean(target.content) ? SWFLoader(target).contentHeight : targetVisualBounds.height / Math.abs(target.scaleY);
         var targetWidth:Number = target is SWFLoader && Boolean(target.content) ? SWFLoader(target).contentWidth : targetVisualBounds.width / Math.abs(target.scaleX);
         if(showTarget)
         {
            scaleXFrom = 0;
            scaleYFrom = 0;
            scaleXTo = 1;
            scaleYTo = 1;
            xFrom = targetWidth / 2 + targetVisualBounds.x;
            yFrom = targetHeight / 2 + targetVisualBounds.y;
            xTo = targetVisualBounds.x;
            yTo = targetVisualBounds.y;
         }
         else
         {
            scaleXFrom = 1;
            scaleYFrom = 1;
            scaleXTo = 0;
            scaleYTo = 0;
            xFrom = targetVisualBounds.x;
            yFrom = targetVisualBounds.y;
            xTo = targetWidth / 2 + targetVisualBounds.x;
            yTo = targetHeight / 2 + targetVisualBounds.y;
         }
      }
   }
}

