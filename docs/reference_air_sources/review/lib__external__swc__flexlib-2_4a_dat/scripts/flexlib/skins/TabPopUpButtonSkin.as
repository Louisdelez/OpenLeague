package flexlib.skins
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.GradientType;
   import mx.containers.TabNavigator;
   import mx.core.EdgeMetrics;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.skins.halo.HaloColors;
   import mx.skins.halo.PopUpIcon;
   import mx.styles.IStyleClient;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   
   public class TabPopUpButtonSkin extends UIComponent
   {
      
      private static var cache:Object = {};
      
      private var _borderMetrics:EdgeMetrics = new EdgeMetrics(1,1,1,1);
      
      public function TabPopUpButtonSkin()
      {
         super();
      }
      
      private static function calcDerivedStyles(themeColor:uint, borderColor:uint, falseFillColor0:uint, falseFillColor1:uint, fillColor0:uint, fillColor1:uint) : Object
      {
         var key:String = null;
         var o:Object = null;
         key = HaloColors.getCacheKey(themeColor,borderColor,falseFillColor0,falseFillColor1,fillColor0,fillColor1);
         if(!cache[key])
         {
            o = cache[key] = {};
            HaloColors.addHaloColors(o,themeColor,fillColor0,fillColor1);
            o.borderColorDrk1 = ColorUtil.adjustBrightness2(borderColor,10);
            o.falseFillColorBright1 = ColorUtil.adjustBrightness(falseFillColor0,15);
            o.falseFillColorBright2 = ColorUtil.adjustBrightness(falseFillColor1,15);
         }
         return cache[key];
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var backgroundAlpha:Number = NaN;
         var backgroundColor:Number = NaN;
         var borderColor:uint = 0;
         var cornerRadius:Number = NaN;
         var fillAlphas:Array = null;
         var fillColors:Array = null;
         var highlightAlphas:Array = null;
         var themeColor:uint = 0;
         var falseFillColors:Array = null;
         var derStyles:Object = null;
         var drawBottomLine:Boolean = false;
         var cornerRadius2:Number = NaN;
         var cr:Object = null;
         var cr2:Object = null;
         var popUpIcon:IFlexDisplayObject = null;
         var arrowButtonWidth:Number = NaN;
         var dividerPosX:Number = NaN;
         var arrowColor:uint = 0;
         var popUpIconClass:Class = null;
         var upFillColors:Array = null;
         var upFillAlphas:Array = null;
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         var disFillColors:Array = null;
         var disFillAlphas:Array = null;
         var p:DisplayObjectContainer = null;
         super.updateDisplayList(w,h);
         backgroundAlpha = Number(getStyle("backgroundAlpha"));
         backgroundColor = Number(getStyle("backgroundColor"));
         borderColor = uint(getStyle("borderColor"));
         cornerRadius = Number(getStyle("cornerRadius"));
         fillAlphas = getStyle("fillAlphas");
         fillColors = getStyle("fillColors");
         StyleManager.getColorNames(fillColors);
         highlightAlphas = getStyle("highlightAlphas");
         themeColor = uint(getStyle("themeColor"));
         falseFillColors = [];
         falseFillColors[0] = ColorUtil.adjustBrightness2(fillColors[0],-5);
         falseFillColors[1] = ColorUtil.adjustBrightness2(fillColors[1],-5);
         derStyles = calcDerivedStyles(themeColor,borderColor,falseFillColors[0],falseFillColors[1],fillColors[0],fillColors[1]);
         drawBottomLine = parent != null && parent.parent != null && parent.parent.parent != null && parent.parent.parent is TabNavigator && IStyleClient(parent.parent.parent).getStyle("borderStyle") != "none";
         cornerRadius2 = Math.max(cornerRadius - 2,0);
         cr = {
            "tl":cornerRadius,
            "tr":cornerRadius,
            "bl":0,
            "br":0
         };
         cr2 = {
            "tl":cornerRadius2,
            "tr":cornerRadius2,
            "bl":0,
            "br":0
         };
         popUpIcon = IFlexDisplayObject(getChildByName("popUpIcon"));
         if(!popUpIcon)
         {
            popUpIconClass = Class(getStyle("popUpIcon"));
            popUpIcon = new popUpIconClass();
            DisplayObject(popUpIcon).name = "popUpIcon";
            addChild(DisplayObject(popUpIcon));
            DisplayObject(popUpIcon).visible = true;
         }
         arrowButtonWidth = Math.max(getStyle("arrowButtonWidth"),popUpIcon.width + 3 + 1);
         dividerPosX = w - arrowButtonWidth;
         arrowColor = 1118481;
         popUpIcon.move(w - (arrowButtonWidth + popUpIcon.width) / 2,(h - popUpIcon.height) / 2);
         graphics.clear();
         switch(name)
         {
            case "upSkin":
               upFillColors = [falseFillColors[0],falseFillColors[1]];
               upFillAlphas = [fillAlphas[0],fillAlphas[1]];
               drawRoundRect(0,0,w,h - 1,cr,[derStyles.borderColorDrk1,borderColor],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cr2
               });
               drawRoundRect(1,1,w - 2,h - 2,cr2,upFillColors,upFillAlphas,verticalGradientMatrix(0,2,w - 2,h - 6));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,cr2,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               if(drawBottomLine)
               {
                  drawRoundRect(0,h - 1,w,1,0,borderColor,fillAlphas[1]);
               }
               drawRoundRect(0,h - 2,w,1,0,0,0.09);
               drawRoundRect(0,h - 3,w,1,0,0,0.03);
               break;
            case "popUpOverSkin":
            case "overSkin":
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
               drawRoundRect(0,0,w,h - 1,cr,[themeColor,derStyles.themeColDrk2],1,verticalGradientMatrix(0,0,w,h - 6),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cr2
               });
               drawRoundRect(1,1,w - 2,h - 2,cr2,[derStyles.falseFillColorBright1,derStyles.falseFillColorBright2],overFillAlphas,verticalGradientMatrix(2,2,w - 2,h - 2));
               drawRoundRect(1,1,w - 2,(h - 2) / 2,cr2,[16777215,16777215],highlightAlphas,verticalGradientMatrix(1,1,w - 2,(h - 2) / 2));
               if(drawBottomLine)
               {
                  drawRoundRect(0,h - 1,w,1,0,borderColor,fillAlphas[1]);
               }
               drawRoundRect(0,h - 2,w,1,0,0,0.09);
               drawRoundRect(0,h - 3,w,1,0,0,0.03);
               break;
            case "disabledSkin":
               disFillColors = [fillColors[0],fillColors[1]];
               disFillAlphas = [Math.max(0,fillAlphas[0] - 0.15),Math.max(0,fillAlphas[1] - 0.15)];
               drawRoundRect(0,0,w,h - 1,cr,[derStyles.borderColorDrk1,borderColor],0.5,verticalGradientMatrix(0,0,w,h - 6));
               drawRoundRect(1,1,w - 2,h - 2,cr2,disFillColors,disFillAlphas,verticalGradientMatrix(0,2,w - 2,h - 2));
               if(drawBottomLine)
               {
                  drawRoundRect(0,h - 1,w,1,0,borderColor,fillAlphas[1]);
               }
               drawRoundRect(0,h - 2,w,1,0,0,0.09);
               drawRoundRect(0,h - 3,w,1,0,0,0.03);
               break;
            case "popUpDownSkin":
            case "downSkin":
            case "selectedUpSkin":
            case "selectedDownSkin":
            case "selectedOverSkin":
            case "selectedDisabledSkin":
               if(isNaN(backgroundColor))
               {
                  p = parent;
                  while(Boolean(p))
                  {
                     if(p is IStyleClient)
                     {
                        backgroundColor = Number(IStyleClient(p).getStyle("backgroundColor"));
                     }
                     if(!isNaN(backgroundColor))
                     {
                        break;
                     }
                     p = p.parent;
                  }
                  if(isNaN(backgroundColor))
                  {
                     backgroundColor = 16777215;
                  }
               }
               drawRoundRect(0,0,w,h - 1,cr,[derStyles.borderColorDrk1,borderColor],1,verticalGradientMatrix(0,0,w,h - 2),GradientType.LINEAR,null,{
                  "x":1,
                  "y":1,
                  "w":w - 2,
                  "h":h - 2,
                  "r":cr2
               });
               drawRoundRect(1,1,w - 2,h - 2,cr2,backgroundColor,backgroundAlpha);
               if(drawBottomLine)
               {
                  drawRoundRect(1,h - 1,w - 2,1,0,backgroundColor,backgroundAlpha);
               }
         }
         if(popUpIcon is PopUpIcon)
         {
            PopUpIcon(popUpIcon).mx_internal::arrowColor = arrowColor;
         }
      }
   }
}

