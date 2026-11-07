package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   import mx.utils.ColorUtil;
   
   public class TitleBackground extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function TitleBackground()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var borderAlpha:Number = Number(getStyle("borderAlpha"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var headerColors:Array = getStyle("headerColors");
         var showChrome:Boolean = headerColors != null;
         styleManager.getColorNames(headerColors);
         var colorDark:Number = Number(ColorUtil.adjustBrightness2(Boolean(headerColors) ? uint(headerColors[1]) : 16777215,-20));
         var g:Graphics = graphics;
         g.clear();
         if(h < 3)
         {
            return;
         }
         if(showChrome)
         {
            g.lineStyle(0,colorDark,borderAlpha);
            g.moveTo(0,h);
            g.lineTo(w,h);
            g.lineStyle(0,0,0);
            drawRoundRect(0,0,w,h,{
               "tl":cornerRadius,
               "tr":cornerRadius,
               "bl":0,
               "br":0
            },headerColors,borderAlpha,verticalGradientMatrix(0,0,w,h));
            drawRoundRect(0,0,w,h / 2,{
               "tl":cornerRadius,
               "tr":cornerRadius,
               "bl":0,
               "br":0
            },[16777215,16777215],highlightAlphas,verticalGradientMatrix(0,0,w,h / 2));
            drawRoundRect(0,0,w,h,{
               "tl":cornerRadius,
               "tr":cornerRadius,
               "bl":0,
               "br":0
            },16777215,highlightAlphas[0],null,GradientType.LINEAR,null,{
               "x":0,
               "y":1,
               "w":w,
               "h":h - 1,
               "r":{
                  "tl":cornerRadius,
                  "tr":cornerRadius,
                  "bl":0,
                  "br":0
               }
            });
         }
      }
   }
}

