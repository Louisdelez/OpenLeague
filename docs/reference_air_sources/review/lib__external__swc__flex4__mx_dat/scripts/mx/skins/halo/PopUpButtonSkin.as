package mx.skins.halo
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import mx.core.IFlexDisplayObject;
   import mx.core.IProgrammaticSkin;
   import mx.core.UIComponent;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class PopUpButtonSkin extends UIComponent implements IProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var cache:Object = {};
      
      public function PopUpButtonSkin()
      {
         super();
         mouseEnabled = false;
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
         return DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      override public function get measuredHeight() : Number
      {
         return DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var upFillColors:Array = null;
         var upFillAlphas:Array = null;
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         var popUpIconClass:Class = null;
         var disFillColors:Array = null;
         var disFillAlphas:Array = null;
         super.updateDisplayList(w,h);
         var arrowColor:uint = uint(getStyle("iconColor"));
         var borderColor:uint = uint(getStyle("borderColor"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("fillColors");
         StyleManager.getStyleManager(moduleFactory).getColorNames(fillColors);
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var themeColor:uint = uint(getStyle("themeColor"));
         var derStyles:Object = calcDerivedStyles(themeColor,fillColors[0],fillColors[1]);
         var borderColorDrk1:Number = Number(ColorUtil.adjustBrightness2(borderColor,-50));
         var themeColorDrk1:Number = Number(ColorUtil.adjustBrightness2(themeColor,-25));
         var popUpIcon:IFlexDisplayObject = IFlexDisplayObject(getChildByName("popUpIcon"));
         if(!popUpIcon)
         {
            popUpIconClass = Class(getStyle("popUpIcon"));
            popUpIcon = new popUpIconClass();
            DisplayObject(popUpIcon).name = "popUpIcon";
            addChild(DisplayObject(popUpIcon));
            DisplayObject(popUpIcon).visible = true;
         }
         var arrowButtonWidth:Number = Math.max(getStyle("arrowButtonWidth"),popUpIcon.width + 3 + 1);
         var dividerPosX:Number = w - arrowButtonWidth;
         popUpIcon.move(w - (arrowButtonWidth + popUpIcon.width) / 2,(h - popUpIcon.height) / 2);
         var cr:Number = Math.max(0,cornerRadius);
         var cr1:Number = Math.max(0,cornerRadius - 1);
         graphics.clear();
         switch(name)
         {
            case "upSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,cr,[borderColor,borderColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cornerRadius - 1
               });
               drawRoundRect(dividerPosX,1,1,h - 2,0,[borderColor,borderColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":h - 2,
                  "r":0
               });
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr1,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":(h - 2) / 2,
                  "r":0
               });
               drawRoundRect(dividerPosX - 1,1,1,h - 2,0,borderColor,0);
               drawRoundRect(dividerPosX + 1,1,1,h - 2,0,borderColor,0);
               break;
            case "overSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
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
               drawRoundRect(0,0,w,h,cr,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cornerRadius - 1
               });
               drawRoundRect(dividerPosX,1,1,h - 2,0,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":h - 2,
                  "r":this.getRadius(cr1,true)
               });
               drawRoundRect(1,1,w - arrowButtonWidth - 2,h - 2,this.getRadius(cr1,true),overFillColors,overFillAlphas,verticalGradientMatrix(1,1,dividerPosX - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr1,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":(h - 2) / 2,
                  "r":0
               });
               drawRoundRect(dividerPosX - 1,1,1,h - 2,0,themeColor,0.35);
               break;
            case "popUpOverSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
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
               drawRoundRect(0,0,w,h,cr,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cornerRadius - 1
               });
               drawRoundRect(dividerPosX,1,1,h - 2,0,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,this.getRadius(cr1,true),upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":arrowButtonWidth - 1,
                  "h":h - 2,
                  "r":this.getRadius(cr1,true)
               });
               drawRoundRect(dividerPosX + 1,1,arrowButtonWidth - 2,h - 2,this.getRadius(cr1,false),overFillColors,overFillAlphas,verticalGradientMatrix(dividerPosX,0,arrowButtonWidth - 1,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr1,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":(h - 2) / 2,
                  "r":0
               });
               drawRoundRect(dividerPosX + 1,1,1,h - 2,0,themeColor,0.35);
               break;
            case "downSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,cr,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cornerRadius - 1
               });
               drawRoundRect(dividerPosX,1,1,h - 2,0,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":h - 2,
                  "r":0
               });
               drawRoundRect(1,1,w - arrowButtonWidth - 2,h - 2,this.getRadius(cr1,true),[derStyles.fillColorPress1,derStyles.fillColorPress2],1,verticalGradientMatrix(1,1,dividerPosX - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr1,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":(h - 2) / 2,
                  "r":0
               });
               drawRoundRect(dividerPosX - 1,1,1,h - 2,0,themeColorDrk1,0.3);
               drawRoundRect(dividerPosX + 1,1,1,h - 2,0,borderColor,0);
               break;
            case "popUpDownSkin":
               upFillColors = [fillColors[0],fillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h,cr,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cornerRadius - 1
               });
               drawRoundRect(dividerPosX,1,1,h - 2,0,[themeColor,themeColorDrk1],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(1,1,w - 2,h - 2,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":h - 2,
                  "r":0
               });
               drawRoundRect(dividerPosX + 1,1,arrowButtonWidth - 2,h - 2,this.getRadius(cr1,false),[derStyles.fillColorPress1,derStyles.fillColorPress2],1,verticalGradientMatrix(dividerPosX,0,arrowButtonWidth - 1,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,{
                  "tl":cr1,
                  "tr":cr1,
                  "bl":0,
                  "br":0
               },[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2),GradientType.LINEAR,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":(h - 2) / 2,
                  "r":0
               });
               drawRoundRect(dividerPosX - 1,1,1,h - 2,0,borderColor,0);
               drawRoundRect(dividerPosX + 1,1,1,h - 2,0,themeColorDrk1,0.3);
               break;
            case "disabledSkin":
               arrowColor = uint(getStyle("disabledIconColor"));
               disFillColors = [fillColors[0],fillColors[1]];
               disFillAlphas = [Math.max(0,fillAlphas[0] - 0.15),Math.max(0,fillAlphas[1] - 0.15)];
               drawRoundRect(0,0,w,h,cornerRadius,[borderColor,borderColorDrk1],0.5,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cornerRadius - 1
               });
               drawRoundRect(dividerPosX,1,1,h - 2,0,[borderColor,borderColorDrk1],0.5);
               drawRoundRect(1,1,w - 2,h - 2,cr1,disFillColors,disFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2),null,null,{
                  "x":dividerPosX,
                  "y":1,
                  "w":1,
                  "h":h - 2,
                  "r":0
               });
         }
         if(popUpIcon is PopUpIcon)
         {
            PopUpIcon(popUpIcon).arrowColor = arrowColor;
         }
      }
      
      private function getRadius(r:Number, left:Boolean) : Object
      {
         return left ? {
            "br":0,
            "bl":r,
            "tr":0,
            "tl":r
         } : {
            "br":r,
            "bl":0,
            "tr":r,
            "tl":0
         };
      }
   }
}

