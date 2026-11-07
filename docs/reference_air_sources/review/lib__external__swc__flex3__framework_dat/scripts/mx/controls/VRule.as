package mx.controls
{
   import flash.display.Graphics;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [IconFile("VRule.png")]
   [Style(name="strokeWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="strokeColor",type="uint",format="Color",inherit="yes")]
   [Style(name="shadowColor",type="uint",format="Color",inherit="yes")]
   public class VRule extends UIComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const DEFAULT_PREFERRED_HEIGHT:Number = 100;
      
      public function VRule()
      {
         super();
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredWidth = getStyle("strokeWidth");
         measuredHeight = DEFAULT_PREFERRED_HEIGHT;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var g:Graphics = graphics;
         g.clear();
         var strokeColor:Number = getStyle("strokeColor");
         var shadowColor:Number = getStyle("shadowColor");
         var strokeWidth:Number = getStyle("strokeWidth");
         if(strokeWidth > unscaledWidth)
         {
            strokeWidth = unscaledWidth;
         }
         var left:Number = (unscaledWidth - strokeWidth) / 2;
         var top:Number = 0;
         var right:Number = left + strokeWidth;
         var bottom:Number = unscaledHeight;
         if(strokeWidth == 1)
         {
            g.beginFill(strokeColor);
            g.drawRect(left,top,right - left,unscaledHeight);
            g.endFill();
         }
         else if(strokeWidth == 2)
         {
            g.beginFill(strokeColor);
            g.drawRect(left,top,1,unscaledHeight);
            g.endFill();
            g.beginFill(shadowColor);
            g.drawRect(right - 1,top,1,unscaledHeight);
            g.endFill();
         }
         else if(strokeWidth > 2)
         {
            g.beginFill(strokeColor);
            g.drawRect(left,top,right - left - 1,1);
            g.endFill();
            g.beginFill(shadowColor);
            g.drawRect(right - 1,top,1,unscaledHeight - 1);
            g.drawRect(left,bottom - 1,right - left,1);
            g.endFill();
            g.beginFill(strokeColor);
            g.drawRect(left,top + 1,1,unscaledHeight - 2);
            g.endFill();
         }
      }
   }
}

