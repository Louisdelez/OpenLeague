package flexlib.skins
{
   import flash.display.GradientType;
   import flash.geom.Matrix;
   import mx.skins.Border;
   import mx.skins.halo.HaloColors;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class SliderThumbHighlightSkin extends Border
   {
      
      private static var cache:Object = {};
      
      public function SliderThumbHighlightSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(themeColor:uint, borderColor:uint, fillColor0:uint, fillColor1:uint) : Object
      {
         var key:String = null;
         var o:Object = null;
         key = HaloColors.getCacheKey(themeColor,borderColor,fillColor0,fillColor1);
         if(!cache[key])
         {
            o = cache[key] = {};
            HaloColors.addHaloColors(o,themeColor,fillColor0,fillColor1);
            o.borderColorDrk1 = ColorUtil.adjustBrightness2(borderColor,-50);
         }
         return cache[key];
      }
      
      override public function get measuredHeight() : Number
      {
         return 11;
      }
      
      override public function get measuredWidth() : Number
      {
         return 15;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var backgroundColor:Number = NaN;
         var borderColor:uint = 0;
         var cornerRadius:Number = NaN;
         var fillAlphas:Array = null;
         var fillColors:Array = null;
         var highlightAlphas:Array = null;
         var themeColor:uint = 0;
         var gripColor:uint = 0;
         var derStyles:Object = null;
         var radius:Number = NaN;
         var cr:Object = null;
         var cr1:Object = null;
         var horizontal:Boolean = false;
         var gripW:Number = NaN;
         var upFillColors:Array = null;
         var upFillAlphas:Array = null;
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         var topY:Number = NaN;
         super.updateDisplayList(w,h);
         backgroundColor = Number(getStyle("backgroundColor"));
         borderColor = uint(getStyle("borderColor"));
         cornerRadius = Number(getStyle("cornerRadius"));
         fillAlphas = getStyle("fillAlphas");
         fillColors = getStyle("fillColors");
         StyleManager.getColorNames(fillColors);
         highlightAlphas = getStyle("highlightAlphas");
         themeColor = uint(getStyle("themeColor"));
         gripColor = 7305079;
         derStyles = calcDerivedStyles(themeColor,borderColor,fillColors[0],fillColors[1]);
         radius = Math.max(cornerRadius - 1,0);
         cr = {
            "tl":0,
            "tr":radius,
            "bl":0,
            "br":radius
         };
         radius = Math.max(radius - 1,0);
         cr1 = {
            "tl":0,
            "tr":radius,
            "bl":0,
            "br":radius
         };
         horizontal = Boolean(parent) && Boolean(parent.parent) && parent.parent.rotation != 0;
         if(isNaN(backgroundColor))
         {
            backgroundColor = 16777215;
         }
         graphics.clear();
         drawRoundRect(1,0,w - 3,h,cr,backgroundColor,1);
         switch(name)
         {
            default:
            case "thumbUpSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,0,16777215,0);
               drawRoundRect(1,0,w - 3,h,cr,[borderColor,derStyles.borderColorDrk1],1,horizontal ? horizontalGradientMatrix(0,0,w,h) : verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 4,
                  "h":h - 2,
                  "r":cr1
               });
               drawRoundRect(1,1,w - 4,h - 2,cr1,upFillColors,upFillAlphas,horizontal ? horizontalGradientMatrix(1,0,w - 2,h - 2) : verticalGradientMatrix(1,0,w - 2,h - 2));
               if(horizontal)
               {
                  drawRoundRect(1,0,(w - 4) / 2,h - 2,0,[16777215,16777215],highlightAlphas,horizontalGradientMatrix(1,1,w - 4,(h - 2) / 2));
               }
               else
               {
                  drawRoundRect(1,1,w - 4,(h - 2) / 2,cr1,[16777215,16777215],highlightAlphas,horizontal ? horizontalGradientMatrix(1,0,(w - 4) / 2,h - 2) : verticalGradientMatrix(1,1,w - 4,(h - 2) / 2));
               }
               break;
            case "thumbOverSkin":
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
               drawRoundRect(0,0,w,h,0,16777215,0);
               drawRoundRect(1,0,w - 3,h,cr,[themeColor,derStyles.themeColDrk1],1,horizontal ? horizontalGradientMatrix(1,0,w,h) : verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 4,
                  "h":h - 2,
                  "r":cr1
               });
               drawRoundRect(1,1,w - 4,h - 2,cr1,overFillColors,overFillAlphas,horizontal ? horizontalGradientMatrix(1,0,w,h) : verticalGradientMatrix(1,0,w,h));
               break;
            case "thumbDownSkin":
               drawRoundRect(1,0,w - 3,h,cr,[themeColor,derStyles.themeColDrk2],1,horizontal ? horizontalGradientMatrix(1,0,w,h) : verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 4,
                  "h":h - 2,
                  "r":cr1
               });
               drawRoundRect(1,1,w - 4,h - 2,cr1,[derStyles.fillColorPress1,derStyles.fillColorPress2],1,horizontal ? horizontalGradientMatrix(1,0,w,h) : verticalGradientMatrix(1,0,w,h));
               break;
            case "thumbDisabledSkin":
               drawRoundRect(0,0,w,h,0,16777215,0);
               drawRoundRect(1,0,w - 3,h,cr,10066329,0.5);
               drawRoundRect(1,1,w - 4,h - 2,cr1,16777215,0.5);
         }
         if(horizontal)
         {
            gripW = Math.floor(w / 2 - 4);
            drawRoundRect(gripW,Math.floor(h / 2 - 4),5,1,0,0,0.4);
            drawRoundRect(gripW,Math.floor(h / 2 - 2),5,1,0,0,0.4);
            drawRoundRect(gripW,Math.floor(h / 2),5,1,0,0,0.4);
            drawRoundRect(gripW,Math.floor(h / 2 + 2),5,1,0,0,0.4);
            drawRoundRect(gripW,Math.floor(h / 2 + 4),5,1,0,0,0.4);
         }
         else
         {
            gripW = Math.floor(w / 2 - 4);
            topY = Math.floor(h / 2 - 2.5);
            drawRoundRect(gripW,topY,1,5,0,0,0.4);
            drawRoundRect(gripW + 2,topY,1,5,0,0,0.4);
            drawRoundRect(gripW + 4,topY,1,5,0,0,0.4);
            drawRoundRect(gripW + 6,topY,1,5,0,0,0.4);
            drawRoundRect(gripW + 8,topY,1,5,0,0,0.4);
         }
      }
   }
}

