package spark.components
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IDataRenderer;
   import mx.core.LayoutDirection;
   import mx.utils.PopUpUtil;
   import spark.components.supportClasses.SliderBase;
   
   [DiscouragedForProfile("mobileDevice")]
   [DefaultTriggerEvent("change")]
   [IconFile("VSlider.png")]
   public class VSlider extends SliderBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "dataTip":false,
         "track":false,
         "thumb":false
      };
      
      public function VSlider()
      {
         super();
      }
      
      override protected function pointToValue(x:Number, y:Number) : Number
      {
         if(!thumb || !track)
         {
            return 0;
         }
         var range:Number = maximum - minimum;
         var thumbRange:Number = track.getLayoutBoundsHeight() - thumb.getLayoutBoundsHeight();
         return minimum + (thumbRange != 0 ? (thumbRange - y) / thumbRange * range : 0);
      }
      
      override protected function updateSkinDisplayList() : void
      {
         if(!thumb || !track)
         {
            return;
         }
         var thumbRange:Number = track.getLayoutBoundsHeight() - thumb.getLayoutBoundsHeight();
         var range:Number = maximum - minimum;
         var thumbPosTrackY:Number = range > 0 ? thumbRange - (pendingValue - minimum) / range * thumbRange : 0;
         var thumbPos:Point = track.localToGlobal(new Point(0,thumbPosTrackY));
         var thumbPosParentY:Number = Number(thumb.parent.globalToLocal(thumbPos).y);
         thumb.setLayoutBoundsPosition(thumb.getLayoutBoundsX(),Math.round(thumbPosParentY));
      }
      
      override protected function updateDataTip(dataTipInstance:IDataRenderer, initialPosition:Point) : void
      {
         var tipBounds:Rectangle = null;
         var relY:Number = NaN;
         var relX:Number = NaN;
         var pt:Point = null;
         var tipAsDisplayObject:DisplayObject = dataTipInstance as DisplayObject;
         if(Boolean(tipAsDisplayObject) && Boolean(thumb))
         {
            tipBounds = tipAsDisplayObject.getBounds(tipAsDisplayObject.parent);
            relY = thumb.getLayoutBoundsY() + (thumb.getLayoutBoundsHeight() - tipAsDisplayObject.height) / 2;
            relX = layoutDirection == LayoutDirection.RTL ? initialPosition.x + tipBounds.width : initialPosition.x;
            pt = PopUpUtil.positionOverComponent(thumb.parent,systemManager,tipBounds.width,tipBounds.height,NaN,null,new Point(relX,relY));
            pt = tipAsDisplayObject.parent.globalToLocal(systemManager.getSandboxRoot().localToGlobal(pt));
            tipAsDisplayObject.x = Math.floor(pt.x);
            tipAsDisplayObject.y = Math.floor(pt.y);
         }
      }
   }
}

