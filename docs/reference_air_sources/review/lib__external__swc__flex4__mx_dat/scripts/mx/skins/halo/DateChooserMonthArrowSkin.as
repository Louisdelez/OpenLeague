package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class DateChooserMonthArrowSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var cache:Object = {};
      
      public function DateChooserMonthArrowSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(themeColor:uint, fillColor0:uint, fillColor1:uint) : Object
      {
         var o:Object = null;
         var key:String = HaloColors.getCacheKey(themeColor,fillColor0,fillColor1);
         if(!cache[key])
         {
            o = cache[key] = {};
            HaloColors.addHaloColors(o,themeColor,fillColor0,fillColor1);
         }
         return cache[key];
      }
      
      override public function get measuredWidth() : Number
      {
         return 19;
      }
      
      override public function get measuredHeight() : Number
      {
         return 20;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var arrowColor:uint = uint(getStyle("iconColor"));
         var borderColor:uint = uint(getStyle("borderColor"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var fillColors:Array = getStyle("fillColors");
         styleManager.getColorNames(fillColors);
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var themeColor:uint = uint(getStyle("themeColor"));
         var derStyles:Object = calcDerivedStyles(themeColor,fillColors[0],fillColors[1]);
         var borderColorDrk1:Number = Number(ColorUtil.adjustBrightness2(borderColor,-50));
         var themeColorDrk1:Number = Number(ColorUtil.adjustBrightness2(themeColor,-25));
         var cr1:Number = Math.max(0,cornerRadius - 1);
         var cr2:Number = Math.max(0,cornerRadius - 2);
         var g:Graphics = graphics;
         g.clear();
         switch(name)
         {
            case "prevMonthUpSkin":
            case "nextMonthUpSkin":
               drawRoundRect(0,0,w,h,cr1,[borderColor,borderColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr2,[fillColors[0],fillColors[1]],1,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr2,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               break;
            case "prevMonthOverSkin":
            case "nextMonthOverSkin":
               drawRoundRect(0,0,w,h,cr1,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr2,[derStyles.fillColorBright1,derStyles.fillColorBright2],1,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr2,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               break;
            case "prevMonthDownSkin":
            case "nextMonthDownSkin":
               drawRoundRect(0,0,w,h,cr1,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr2,[derStyles.fillColorPress1,derStyles.fillColorPress2],1,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr2,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               break;
            case "prevMonthDisabledSkin":
            case "nextMonthDisabledSkin":
               drawRoundRect(0,0,w,h,cr1,[borderColor,borderColorDrk1],0.6,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr2,[fillColors[0],fillColors[1]],0.8,verticalGradientMatrix(1,1,w - 2,h - 2));
               arrowColor = uint(getStyle("disabledIconColor"));
         }
         g.beginFill(arrowColor);
         if(name.charAt(0) == "p")
         {
            g.moveTo(w - 8,h - 14);
            g.lineTo(w - 13,h / 2 + 0.5);
            g.lineTo(w - 8,h - 5);
            g.moveTo(w - 8,h - 14);
         }
         else
         {
            g.moveTo(w - 11,h - 14);
            g.lineTo(w - 6,h / 2 + 0.5);
            g.lineTo(w - 11,h - 5);
            g.moveTo(w - 11,h - 14);
         }
         g.endFill();
      }
   }
}

