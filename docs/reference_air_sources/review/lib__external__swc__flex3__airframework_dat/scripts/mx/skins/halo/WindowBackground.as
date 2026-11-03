package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class WindowBackground extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public function WindowBackground()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 8;
      }
      
      override public function get measuredHeight() : Number
      {
         return 8;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var bgColor:uint = 0;
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         var fillColors:Array = getStyle("backgroundGradientColors");
         var fillAlphas:Array = getStyle("backgroundGradientAlphas");
         if(!fillColors)
         {
            bgColor = uint(getStyle("backgroundColor"));
            if(isNaN(bgColor))
            {
               bgColor = 16777215;
            }
            fillColors = [bgColor,bgColor];
         }
         if(!fillAlphas)
         {
            fillAlphas = [1,1];
         }
         g.clear();
         drawRoundRect(0,0,w,h,0,fillColors,fillAlphas,verticalGradientMatrix(0,0,w,h));
      }
   }
}

