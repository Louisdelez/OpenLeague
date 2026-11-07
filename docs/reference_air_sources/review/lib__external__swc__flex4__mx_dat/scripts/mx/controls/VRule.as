package mx.controls
{
   import flash.display.Graphics;
   import mx.core.UIComponent;
   
   [Alternative(replacement="spark.primitives.Line",since="4.0")]
   [IconFile("VRule.png")]
   [Style(name="strokeWidth",type="Number",format="Length",inherit="yes")]
   [Style(name="strokeColor",type="uint",format="Color",inherit="yes")]
   [Style(name="shadowColor",type="uint",format="Color",inherit="yes")]
   public class VRule extends UIComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         var strokeColor:Number = Number(getStyle("strokeColor"));
         var shadowColor:Number = Number(getStyle("shadowColor"));
         var strokeWidth:Number = Number(getStyle("strokeWidth"));
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

