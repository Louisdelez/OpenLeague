package mx.skins.halo
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.filters.BlurFilter;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.core.FlexGlobals;
   import mx.skins.Border;
   import mx.styles.IStyleClient;
   import mx.utils.ColorUtil;
   
   public class ActivatorSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var cache:Object = {};
      
      private static var acbs:Object = {};
      
      public function ActivatorSkin()
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
      
      private static function isApplicationControlBar(parent:Object) : Boolean
      {
         var xmllist:XMLList;
         var s:String = null;
         var x:XML = null;
         s = getQualifiedClassName(parent);
         if(acbs[s] == 1)
         {
            return true;
         }
         if(acbs[s] == 0)
         {
            return false;
         }
         if(s == "mx.containers::ApplicationControlBar")
         {
            acbs[s] == 1;
            return true;
         }
         x = describeType(parent);
         xmllist = x.extendsClass.(@type == "mx.containers::ApplicationControlBar");
         if(xmllist.length() == 0)
         {
            acbs[s] = 0;
            return false;
         }
         acbs[s] = 1;
         return true;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         if(!getStyle("translucent"))
         {
            this.drawHaloRect(w,h);
         }
         else
         {
            this.drawTranslucentHaloRect(w,h);
         }
      }
      
      private function drawHaloRect(w:Number, h:Number) : void
      {
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("fillColors");
         var highlightAlphas:Array = getStyle("highlightAlphas");
         var themeColor:uint = uint(getStyle("themeColor"));
         var themeColorDrk1:Number = Number(ColorUtil.adjustBrightness2(themeColor,-25));
         var derStyles:Object = calcDerivedStyles(themeColor,fillColors[0],fillColors[1]);
         graphics.clear();
         switch(name)
         {
            case "itemUpSkin":
               drawRoundRect(x,y,w,h,0,16777215,0);
               break;
            case "itemDownSkin":
               drawRoundRect(x + 1,y + 1,w - 2,h - 2,0,[derStyles.fillColorPress1,derStyles.fillColorPress2],1,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(x + 1,y + 1,w - 2,h - 2 / 2,0,[16777215,16777215],highlightAlphas,verticalGradientMatrix(0,0,w - 2,h - 2));
               break;
            case "itemOverSkin":
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
               drawRoundRect(x + 1,y + 1,w - 2,h - 2,0,overFillColors,overFillAlphas,verticalGradientMatrix(0,0,w,h));
               drawRoundRect(x + 1,y + 1,w - 2,h - 2 / 2,0,[16777215,16777215],highlightAlphas,verticalGradientMatrix(0,0,w - 2,h - 2));
         }
         filters = [new BlurFilter(2,0)];
      }
      
      private function drawTranslucentHaloRect(w:Number, h:Number) : void
      {
         var pabc:Object = null;
         var p:IStyleClient = parent as IStyleClient;
         while(Boolean(p) && !isApplicationControlBar(p))
         {
            p = DisplayObject(p).parent as IStyleClient;
         }
         if(!p)
         {
            return;
         }
         var fillColor:Object = p.getStyle("fillColor");
         var backgroundColor:Object = p.getStyle("backgroundColor");
         var backgroundAlpha:Number = Number(p.getStyle("backgroundAlpha"));
         var radius:Number = Number(p.getStyle("cornerRadius"));
         var docked:Boolean = Boolean(p.getStyle("docked"));
         if(backgroundColor == "")
         {
            backgroundColor = null;
         }
         if(docked && !backgroundColor)
         {
            pabc = FlexGlobals.topLevelApplication.getStyle("backgroundColor");
            backgroundColor = Boolean(pabc) ? pabc : 9542041;
         }
         graphics.clear();
         switch(name)
         {
            case "itemUpSkin":
               drawRoundRect(1,1,w - 2,h - 1,0,0,0);
               filters = [];
               break;
            case "itemOverSkin":
               if(Boolean(backgroundColor))
               {
                  drawRoundRect(1,1,w - 2,h - 1,0,backgroundColor,backgroundAlpha);
               }
               drawRoundRect(1,1,w - 2,h - 1,0,[fillColor,fillColor,fillColor,fillColor,fillColor],[1,0.75,0.6,0.7,0.9],verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,[0,95,127,191,255]);
               filters = [new BlurFilter(0,4)];
               break;
            case "itemDownSkin":
               if(Boolean(backgroundColor))
               {
                  drawRoundRect(1,1,w - 2,h - 1,0,backgroundColor,backgroundAlpha);
               }
               drawRoundRect(1,1,w - 2,h - 1,0,[fillColor,fillColor,fillColor,fillColor,fillColor],[0.85,0.6,0.45,0.55,0.75],verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,[0,95,127,191,255]);
               filters = [new BlurFilter(0,4)];
         }
      }
   }
}

