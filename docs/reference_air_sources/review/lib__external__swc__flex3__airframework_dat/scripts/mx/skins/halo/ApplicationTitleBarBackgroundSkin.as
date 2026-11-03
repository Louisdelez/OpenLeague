package mx.skins.halo
{
   import mx.skins.ProgrammaticSkin;
   import mx.styles.StyleManager;
   
   public class ApplicationTitleBarBackgroundSkin extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      public function ApplicationTitleBarBackgroundSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var titleBarColors:Array = getStyle("titleBarColors");
         StyleManager.getColorNames(titleBarColors);
         graphics.clear();
         drawRoundRect(0,0,unscaledWidth,unscaledHeight,{
            "tl":cornerRadius,
            "tr":cornerRadius,
            "bl":0,
            "br":0
         },titleBarColors,[1,1],verticalGradientMatrix(0,0,unscaledWidth,unscaledHeight));
         graphics.lineStyle(1,16777215,0.2);
         graphics.moveTo(0,unscaledHeight - 1);
         graphics.lineTo(0,cornerRadius);
         graphics.curveTo(0,0,cornerRadius,0);
         graphics.lineTo(unscaledWidth - 1 - cornerRadius,0);
         graphics.curveTo(unscaledWidth - 1,0,unscaledWidth - 1,cornerRadius);
         graphics.lineTo(unscaledWidth - 1,unscaledHeight - 1);
         graphics.moveTo(0,unscaledHeight - 1);
         graphics.lineStyle(1,0,0.35);
         graphics.lineTo(unscaledWidth,unscaledHeight - 1);
      }
   }
}

