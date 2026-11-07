package flexlib.skins
{
   import flash.display.GradientType;
   import mx.controls.Button;
   import mx.core.UIComponent;
   import mx.skins.Border;
   import mx.skins.halo.HaloColors;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class EnhancedButtonSkin extends Border
   {
      
      private static var cache:Object = {};
      
      public function EnhancedButtonSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(themeColor:uint, fillColor0:uint, fillColor1:uint) : Object
      {
         var key:String = null;
         var o:Object = null;
         key = HaloColors.getCacheKey(themeColor,fillColor0,fillColor1);
         if(!cache[key])
         {
            o = cache[key] = {};
            HaloColors.addHaloColors(o,themeColor,fillColor0,fillColor1);
         }
         return cache[key];
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      private function radiiUtil(rads:Array, inset:Number) : Object
      {
         var newRads:Object = null;
         newRads = {};
         newRads.tl = Math.max(0,rads[0] - inset);
         newRads.tr = Math.max(0,rads[1] - inset);
         newRads.br = Math.max(0,rads[2] - inset);
         newRads.bl = Math.max(0,rads[3] - inset);
         return newRads;
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      private function getAlphas(styleAttributeName:String, numColors:Number) : Array
      {
         var alphas:Array = null;
         var i:int = 0;
         alphas = getStyle(styleAttributeName);
         if(alphas != null && alphas.length == numColors)
         {
            return alphas;
         }
         if(styleAttributeName != "fillAlphas")
         {
            return getAlphas("fillAlphas",numColors);
         }
         alphas = [];
         for(i = 0; i < numColors; i++)
         {
            alphas.push(0.5);
         }
         return alphas;
      }
      
      private function getColorRatios(styleAttributeName:String, numColors:Number) : Array
      {
         var ratios:Array = null;
         var chunkSize:Number = NaN;
         var i:int = 0;
         ratios = getStyle(styleAttributeName);
         if(ratios != null && ratios.length == numColors)
         {
            return ratios;
         }
         if(styleAttributeName != "fillColorRatios")
         {
            return getColorRatios("fillColorRatios",numColors);
         }
         chunkSize = 255 / (numColors - 1);
         ratios = [];
         for(i = 0; i < numColors; i++)
         {
            ratios[i] = Math.round(i * chunkSize);
         }
         return ratios;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var cornerRadii:Array = null;
         var cornerRadius:Number = NaN;
         var fillColors:Array = null;
         var upFillColors:Array = null;
         var selectedFillColors:Array = null;
         var overFillColors:Array = null;
         var disFillColors:Array = null;
         var downFillColors:Array = null;
         var upFillColorRatios:Array = null;
         var overFillColorRatios:Array = null;
         var selectedFillColorRatios:Array = null;
         var disFillColorRatios:Array = null;
         var fillAlphas:Array = null;
         var overFillAlphas:Array = null;
         var selectedFillAlphas:Array = null;
         var disFillAlphas:Array = null;
         var i:int = 0;
         var upFillAlphas:Array = null;
         var highlightAlphas:Array = null;
         var themeColor:uint = 0;
         var borderThickness:uint = 0;
         var borderColors:Array = null;
         var overBorderColors:Array = null;
         var selectedBorderColors:Array = null;
         var borderAlpha:Number = NaN;
         var disabledBorderAlpha:Number = NaN;
         var derStyles:Object = null;
         var emph:Boolean = false;
         var cr:Object = null;
         var cr1:Object = null;
         var cr2:Object = null;
         var bt:uint = 0;
         var tmp:Number = NaN;
         var downFillColorRatios:Array = null;
         var downFillAlphas:Array = null;
         var borderColor:Number = NaN;
         super.updateDisplayList(w,h);
         cornerRadii = getStyle("cornerRadii");
         cornerRadius = Number(getStyle("cornerRadius"));
         if(cornerRadii == null)
         {
            if(isNaN(cornerRadius))
            {
               cornerRadius = 0;
            }
            cornerRadii = [cornerRadius,cornerRadius,cornerRadius,cornerRadius];
         }
         fillColors = getStyle("fillColors");
         if(fillColors.length == 1)
         {
            fillColors.push(fillColors[0]);
         }
         upFillColors = fillColors;
         selectedFillColors = getStyle("selectedFillColors");
         if(selectedFillColors == null)
         {
            selectedFillColors = [fillColors[1],fillColors[1]];
         }
         overFillColors = getStyle("overFillColors");
         if(overFillColors == null)
         {
            overFillColors = selectedFillColors;
         }
         disFillColors = getStyle("disabledFillColors");
         if(disFillColors == null)
         {
            disFillColors = fillColors;
         }
         downFillColors = getStyle("downFillColors");
         if(downFillColors != null)
         {
            downFillColorRatios = getColorRatios("downFillColorRatios",downFillColors.length);
            downFillAlphas = getAlphas("downFillAlphas",downFillColors.length);
         }
         upFillColorRatios = getColorRatios("fillColorRatios",fillColors.length);
         overFillColorRatios = getColorRatios("overFillColorRatios",overFillColors.length);
         selectedFillColorRatios = getColorRatios("selectedFillColorRatios",selectedFillColors.length);
         disFillColorRatios = getColorRatios("disabledFillColorRatios",disFillColors.length);
         fillAlphas = getAlphas("fillAlphas",fillColors.length);
         overFillAlphas = getAlphas("overFillAlphas",overFillColors.length);
         selectedFillAlphas = getAlphas("selectedFillAlphas",selectedFillColors.length);
         disFillAlphas = [];
         for(i = 0; i < fillAlphas.length; i++)
         {
            disFillAlphas[i] = Math.max(0,fillAlphas[i] - 0.15);
         }
         for(i = int(fillAlphas.length); i < fillColors.length; i++)
         {
            fillAlphas.push(fillAlphas[i - 1]);
         }
         upFillAlphas = fillAlphas;
         StyleManager.getColorNames(fillColors);
         StyleManager.getColorNames(upFillColors);
         StyleManager.getColorNames(overFillColors);
         StyleManager.getColorNames(selectedFillColors);
         highlightAlphas = getStyle("highlightAlphas");
         themeColor = uint(getStyle("themeColor"));
         borderThickness = uint(getStyle("borderThickness"));
         borderColors = getStyle("borderColors");
         if(borderColors == null)
         {
            borderColor = Number(getStyle("borderColor"));
            borderColors = [borderColor,ColorUtil.adjustBrightness(borderColor,-50)];
         }
         overBorderColors = getStyle("overBorderColors");
         if(overBorderColors == null)
         {
            overBorderColors = [themeColor,ColorUtil.adjustBrightness2(themeColor,-25)];
         }
         selectedBorderColors = getStyle("selectedBorderColors");
         if(selectedBorderColors == null)
         {
            selectedBorderColors = overBorderColors;
         }
         borderAlpha = Number(getStyle("borderAlpha"));
         if(isNaN(borderAlpha))
         {
            borderAlpha = 1;
         }
         disabledBorderAlpha = Number(getStyle("disabledBorderAlpha"));
         if(isNaN(disabledBorderAlpha))
         {
            disabledBorderAlpha = borderAlpha / 0.5;
         }
         derStyles = calcDerivedStyles(themeColor,fillColors[0],fillColors[1]);
         emph = false;
         if(parent is Button)
         {
            emph = Boolean(Button(parent).emphasized);
         }
         cr = radiiUtil(cornerRadii,0);
         cr1 = radiiUtil(cornerRadii,1);
         cr2 = radiiUtil(cornerRadii,2);
         bt = borderThickness;
         graphics.clear();
         switch(name)
         {
            case "selectedUpSkin":
            case "selectedOverSkin":
               drawRoundRect(0,0,w,h,cr,selectedBorderColors,borderAlpha,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":bt + 1,
                  "y":bt + 1,
                  "w":w - 2 * bt - 2,
                  "h":h - 2 * bt - 2,
                  "r":cr2
               });
               drawRoundRect(bt,bt,w - 2 * bt,h - 2 * bt,cr1,selectedFillColors,selectedFillAlphas,verticalGradientMatrix(0,0,w - 2 * bt,h - 2 * bt),GradientType.LINEAR,selectedFillColorRatios);
               drawRoundRect(bt + 1,bt + 1,w - 2 * bt - 2,(h - 2 * bt - 2) / 2,{
                  "tl":cr2.tl,
                  "tr":cr2.tr,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,(h - 2 * bt) / 2));
               break;
            case "upSkin":
               if(emph)
               {
                  drawRoundRect(0,0,w,h,cr,borderColors,borderAlpha,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                     "x":bt + 1,
                     "y":bt + 1,
                     "w":w - 2 * bt - 2,
                     "h":h - 2 * bt - 2,
                     "r":cr2
                  });
                  drawRoundRect(bt + 1,bt + 1,w - 2 * bt - 2,h - 2 * bt - 2,cr2,upFillColors,upFillAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,h - 2 * bt),GradientType.LINEAR,upFillColorRatios);
                  drawRoundRect(bt + 1,bt + 1,w - 2 * bt - 2,(h - 2 * bt - 2) / 2,{
                     "tl":cr2.tl,
                     "tr":cr2.tr,
                     "bl":0,
                     "br":0
                  },[16777215,16777215],highlightAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,(h - 2 * bt) / 2));
               }
               else
               {
                  drawRoundRect(0,0,w,h,cr,borderColors,borderAlpha,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                     "x":bt,
                     "y":bt,
                     "w":w - 2 * bt,
                     "h":h - 2 * bt,
                     "r":cr1
                  });
                  drawRoundRect(bt,bt,w - 2 * bt,h - 2 * bt,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,h - 2 * bt),GradientType.LINEAR,upFillColorRatios);
                  drawRoundRect(bt,bt,w - 2 * bt,(h - 2 * bt) / 2,{
                     "tl":cr1.tl,
                     "tr":cr1.tr,
                     "bl":0,
                     "br":0
                  },[16777215,16777215],highlightAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,(h - 2 * bt) / 2));
               }
               break;
            case "overSkin":
               drawRoundRect(0,0,w,h,cr,overBorderColors,borderAlpha,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":bt,
                  "y":bt,
                  "w":w - 2 * bt,
                  "h":h - 2 * bt,
                  "r":cr1
               });
               drawRoundRect(bt,bt,w - 2 * bt,h - 2 * bt,cr1,overFillColors,overFillAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,h - 2 * bt),GradientType.LINEAR,overFillColorRatios);
               drawRoundRect(bt,bt,w - 2 * bt,(h - 2 * bt) / 2,{
                  "tl":cr1.tl,
                  "tr":cr1.tr,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,(h - 2 * bt) / 2));
               break;
            case "downSkin":
            case "selectedDownSkin":
               drawRoundRect(0,0,w,h,cr,overBorderColors,borderAlpha,verticalGradientMatrix(0,0,w,h));
               if(downFillColors != null)
               {
                  drawRoundRect(bt,bt,w - 2 * bt,h - 2 * bt,cr1,downFillColors,downFillAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,h - 2 * bt),GradientType.LINEAR,downFillColorRatios);
               }
               else
               {
                  drawRoundRect(bt,bt,w - 2 * bt,h - 2 * bt,cr1,[derStyles.fillColorPress1,derStyles.fillColorPress2],fillAlphas[0],verticalGradientMatrix(bt,bt,w - 2 * bt,h - 2 * bt));
               }
               drawRoundRect(bt + 1,bt + 1,w - 2 * bt - 2,(h - 2 * bt - 2) / 2,{
                  "tl":cr2.tl,
                  "tr":cr2.tr,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,(h - 2 * bt) / 2));
               break;
            case "disabledSkin":
            case "selectedDisabledSkin":
               drawRoundRect(0,0,w,h,cr,borderColors,disabledBorderAlpha,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":bt,
                  "y":bt,
                  "w":w - 2 * bt,
                  "h":h - 2 * bt,
                  "r":cr1
               });
               drawRoundRect(bt,bt,w - 2 * bt,h - 2 * bt,cr1,disFillColors,disFillAlphas,verticalGradientMatrix(bt,bt,w - 2 * bt,h - 2 * bt),GradientType.LINEAR,disFillColorRatios);
         }
      }
   }
}

