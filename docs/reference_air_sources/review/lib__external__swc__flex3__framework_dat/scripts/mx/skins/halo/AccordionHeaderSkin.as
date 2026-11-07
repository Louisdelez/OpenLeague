package mx.skins.halo
{
   import flash.display.GradientType;
   import mx.core.EdgeMetrics;
   import mx.core.FlexVersion;
   import mx.core.mx_internal;
   import mx.skins.Border;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class AccordionHeaderSkin extends Border
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var cache:Object = {};
      
      private var _borderMetrics:EdgeMetrics = new EdgeMetrics(1,1,1,1);
      
      public function AccordionHeaderSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(themeColor:uint, borderColor:uint, falseFillColor0:uint, falseFillColor1:uint, fillColor0:uint, fillColor1:uint) : Object
      {
         var o:Object = null;
         var key:String = HaloColors.getCacheKey(themeColor,borderColor,falseFillColor0,falseFillColor1,fillColor0,fillColor1);
         if(!cache[key])
         {
            o = cache[key] = {};
            HaloColors.addHaloColors(o,themeColor,fillColor0,fillColor1);
         }
         return cache[key];
      }
      
      override public function get measuredWidth() : Number
      {
         return 10;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var upFillColors:Array = null;
         var upFillAlphas:Array = null;
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         var selectedFillAlphas:Array = null;
         super.updateDisplayList(w,h);
         var borderColor:uint = getStyle("borderColor");
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("fillColors");
         StyleManager.getColorNames(fillColors);
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var selectedFillColors:Array = getStyle("selectedFillColors");
         var themeColor:uint = getStyle("themeColor");
         var falseFillColors:Array = [];
         falseFillColors[0] = ColorUtil.adjustBrightness2(fillColors[0],-8);
         falseFillColors[1] = ColorUtil.adjustBrightness2(fillColors[1],-10);
         var borderColorDrk1:Number = ColorUtil.adjustBrightness2(borderColor,-15);
         var overFillColor1:Number = ColorUtil.adjustBrightness2(fillColors[0],-4);
         var overFillColor2:Number = ColorUtil.adjustBrightness2(fillColors[1],-6);
         if(!selectedFillColors)
         {
            selectedFillColors = [];
            selectedFillColors[0] = ColorUtil.adjustBrightness2(fillColors[0],5);
            selectedFillColors[1] = ColorUtil.adjustBrightness2(fillColors[1],15);
         }
         var derStyles:Object = calcDerivedStyles(themeColor,borderColor,falseFillColors[0],falseFillColors[1],fillColors[0],fillColors[1]);
         graphics.clear();
         switch(name)
         {
            case "upSkin":
            case "disabledSkin":
            case "selectedDisabledSkin":
               upFillColors = [falseFillColors[0],falseFillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,0,[borderColor,borderColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":0
               });
               drawRoundRect(1,1,w - 2,h - 2,0,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,0,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               drawRoundRect(1,h - 2,w - 2,1,0,borderColor,0.1);
               break;
            case "overSkin":
               if(fillColors.length > 2)
               {
                  overFillColors = [ColorUtil.adjustBrightness2(fillColors[2],-4),ColorUtil.adjustBrightness2(fillColors[3],-6)];
               }
               else
               {
                  overFillColors = [overFillColor1,overFillColor2];
               }
               if(fillAlphas.length > 2)
               {
                  overFillAlphas = [fillAlphas[2],fillAlphas[3]];
               }
               else
               {
                  overFillAlphas = [fillAlphas[0],fillAlphas[1]];
               }
               drawRoundRect(0,0,w,h,0,[themeColor,derStyles.themeColDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":0
               });
               drawRoundRect(1,1,w - 2,h - 2,0,overFillColors,overFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,0,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               drawRoundRect(1,h - 2,w - 2,1,0,borderColor,0.1);
               break;
            case "downSkin":
               drawRoundRect(0,0,w,h,0,[themeColor,derStyles.themeColDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,0,[derStyles.fillColorPress1,derStyles.fillColorPress2],1,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,0,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               break;
            case "selectedUpSkin":
            case "selectedOverSkin":
            case "selectedDownSkin":
               selectedFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,0,[borderColor,borderColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":0
               });
               drawRoundRect(1,1,w - 2,h - 2,0,[selectedFillColors[0],selectedFillColors[1]],selectedFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,0,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               drawRoundRect(1,h - 2,w - 2,1,0,borderColor,0.05);
         }
      }
      
      override public function get measuredHeight() : Number
      {
         return 22;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0 ? _borderMetrics : super.borderMetrics;
      }
   }
}

