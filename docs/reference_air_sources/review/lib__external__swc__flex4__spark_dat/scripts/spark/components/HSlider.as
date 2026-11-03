package spark.components
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IDataRenderer;
   import mx.core.LayoutDirection;
   import mx.utils.PopUpUtil;
   import spark.components.supportClasses.SliderBase;
   
   [DefaultTriggerEvent("change")]
   [IconFile("HSlider.png")]
   public class HSlider extends SliderBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {
         "dataTip":false,
         "track":false,
         "thumb":false
      };
      
      public function HSlider()
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
         var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
         return minimum + (thumbRange != 0 ? x / thumbRange * range : 0);
      }
      
      override protected function updateSkinDisplayList() : void
      {
         if(!thumb || !track)
         {
            return;
         }
         var thumbRange:Number = track.getLayoutBoundsWidth() - thumb.getLayoutBoundsWidth();
         var range:Number = maximum - minimum;
         var thumbPosTrackX:Number = range > 0 ? (pendingValue - minimum) / range * thumbRange : 0;
         var thumbPos:Point = track.localToGlobal(new Point(thumbPosTrackX,0));
         var thumbPosParentX:Number = Number(thumb.parent.globalToLocal(thumbPos).x);
         thumb.setLayoutBoundsPosition(Math.round(thumbPosParentX),thumb.getLayoutBoundsY());
      }
      
      override protected function updateDataTip(dataTipInstance:IDataRenderer, initialPosition:Point) : void
      {
         var tipWidth:Number = NaN;
         var relX:Number = NaN;
         var tipBounds:Rectangle = null;
         var pt:Point = null;
         var tipAsDisplayObject:DisplayObject = dataTipInstance as DisplayObject;
         if(Boolean(tipAsDisplayObject) && Boolean(thumb))
         {
            tipWidth = tipAsDisplayObject.width;
            relX = thumb.getLayoutBoundsX() - (tipWidth - thumb.getLayoutBoundsWidth()) / 2;
            if(layoutDirection == LayoutDirection.RTL)
            {
               relX += tipAsDisplayObject.width;
            }
            tipBounds = tipAsDisplayObject.getBounds(tipAsDisplayObject.parent);
            pt = PopUpUtil.positionOverComponent(thumb.parent,systemManager,tipBounds.width,tipBounds.height,NaN,null,new Point(relX,initialPosition.y));
            pt = tipAsDisplayObject.parent.globalToLocal(systemManager.getSandboxRoot().localToGlobal(pt));
            tipAsDisplayObject.x = Math.floor(pt.x);
            tipAsDisplayObject.y = Math.floor(pt.y);
         }
      }
   }
}

