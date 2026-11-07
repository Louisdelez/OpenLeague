package mx.controls
{
   import flash.display.Graphics;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("HRule.png")]
   [Style(name="strokeWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="strokeColor",type="uint",format="Color",inherit="yes")]
   [Style(name="shadowColor",type="uint",format="Color",inherit="yes")]
   public class HRule extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const DEFAULT_PREFERRED_WIDTH:Number = 100;
      
      public function HRule()
      {
         super();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = DEFAULT_PREFERRED_WIDTH;
         measuredHeight = getStyle("strokeWidth");
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = graphics;
         g.clear();
         var strokeColor:Number = getStyle("strokeColor");
         var shadowColor:Number = getStyle("shadowColor");
         var strokeWidth:Number = getStyle("strokeWidth");
         if(strokeWidth > unscaledHeight)
         {
            strokeWidth = unscaledHeight;
         }
         var left:Number = 0;
         var top:Number = (unscaledHeight - strokeWidth) / 2;
         var right:Number = unscaledWidth;
         var bottom:Number = top + strokeWidth;
         if(strokeWidth == 1)
         {
            g.beginFill(strokeColor);
            g.drawRect(left,top,unscaledWidth,bottom - top);
            g.endFill();
         }
         else if(strokeWidth == 2)
         {
            g.beginFill(strokeColor);
            g.drawRect(left,top,unscaledWidth,1);
            g.endFill();
            g.beginFill(shadowColor);
            g.drawRect(left,bottom - 1,unscaledWidth,1);
            g.endFill();
         }
         else if(strokeWidth > 2)
         {
            g.beginFill(strokeColor);
            g.drawRect(left,top,unscaledWidth - 1,1);
            g.endFill();
            g.beginFill(shadowColor);
            g.drawRect(right - 1,top,1,bottom - top - 1);
            g.drawRect(left,bottom - 1,unscaledWidth,1);
            g.endFill();
            g.beginFill(strokeColor);
            g.drawRect(left,top + 1,1,bottom - top - 2);
            g.endFill();
         }
      }
   }
}

