package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class NumericStepperUpSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var cache:Object = {};
      
      public function NumericStepperUpSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(themeColor:uint, borderColor:uint, fillColor0:uint, fillColor1:uint) : Object
      {
         var o:Object = null;
         var key:String = HaloColors.getCacheKey(themeColor,borderColor,fillColor0,fillColor1);
         if(!cache[key])
         {
            o = cache[key] = {};
            HaloColors.addHaloColors(o,themeColor,fillColor0,fillColor1);
            o.borderColorDrk1 = ColorUtil.adjustBrightness2(borderColor,-50);
            o.borderColorDrk2 = ColorUtil.adjustBrightness2(borderColor,-25);
         }
         return cache[key];
      }
      
      override public function get measuredWidth() : Number
      {
         return 19;
      }
      
      override public function get measuredHeight() : Number
      {
         return 11;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var upFillColors:Array = null;
         var upFillAlphas:Array = null;
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         var disFillColors:Array = null;
         var disFillAlphas:Array = null;
         super.updateDisplayList(w,h);
         var arrowColor:uint = uint(getStyle("iconColor"));
         var borderColor:uint = uint(getStyle("borderColor"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("fillColors");
         styleManager.getColorNames(fillColors);
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var themeColor:uint = uint(getStyle("themeColor"));
         var derStyles:Object = calcDerivedStyles(themeColor,borderColor,fillColors[0],fillColors[1]);
         var cr:Object = {
            "tl":0,
            "tr":cornerRadius,
            "bl":0,
            "br":0
         };
         var cr1:Object = {
            "tl":0,
            "tr":Math.max(cornerRadius - 1,0),
            "bl":0,
            "br":0
         };
         var g:Graphics = graphics;
         g.clear();
         switch(name)
         {
            case "upArrowUpSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,cr,[borderColor,derStyles.borderColorDrk2],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cr1
               });
               drawRoundRect(1,1,w - 2,h - 2,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h * 2));
               drawRoundRect(1,1,w - 2,h - 3,cr1,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,h - 3));
               break;
            case "upArrowOverSkin":
               if(fillColors.length > 2)
               {
                  overFillColors = [fillColors[2],fillColors[3]];
               }
               else
               {
                  overFillColors = [fillColors[0],fillColors[1]];
               }
               if(fillAlphas.length > 2)
               {
                  overFillAlphas = [fillAlphas[2],fillAlphas[3]];
               }
               else
               {
                  overFillAlphas = [fillAlphas[0],fillAlphas[1]];
               }
               drawRoundRect(0,0,w,h,cr,[themeColor,derStyles.themeColDrk2],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cr1
               });
               drawRoundRect(1,1,w - 2,h - 2,cr1,[derStyles.fillColorBright1,derStyles.fillColorBright2],1,verticalGradientMatrix(1,1,w - 2,h * 2));
               drawRoundRect(1,1,w - 2,h - 2,cr1,[16777215,16777215],highlightAlphas,verticalGradientMatrix(0,0,w - 2,h * 2));
               break;
            case "upArrowDownSkin":
               drawRoundRect(0,0,w,h,cr,[themeColor,derStyles.themeColDrk2],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr1,[derStyles.fillColorPress1,derStyles.fillColorPress2],1,verticalGradientMatrix(1,1,w - 2,h * 2));
               drawRoundRect(1,1,w - 2,h - 3,cr1,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,h - 3));
               break;
            case "upArrowDisabledSkin":
               disFillColors = [fillColors[0],fillColors[1]];
               disFillAlphas = [Math.max(0,fillAlphas[0] - 0.15),Math.max(0,fillAlphas[1] - 0.15)];
               drawRoundRect(0,0,w,h,cr,[borderColor,derStyles.borderColorDrk2],0.5,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cr1
               });
               drawRoundRect(1,1,w - 2,h - 2,cr1,disFillColors,disFillAlphas,verticalGradientMatrix(1,1,w - 2,h * 2));
               arrowColor = uint(getStyle("disabledIconColor"));
         }
         g.beginFill(arrowColor);
         g.moveTo(w / 2,h / 2 - 2.5);
         g.lineTo(w / 2 - 3.5,h / 2 + 1.5);
         g.lineTo(w / 2 + 3.5,h / 2 + 1.5);
         g.lineTo(w / 2,h / 2 - 2.5);
         g.endFill();
      }
   }
}

