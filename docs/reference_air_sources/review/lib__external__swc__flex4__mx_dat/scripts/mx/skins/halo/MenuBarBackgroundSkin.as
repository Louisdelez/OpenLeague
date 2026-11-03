package mx.skins.halo
{
   import flash.display.GradientType;
   import mx.core.EdgeMetrics;
   import mx.core.UIComponent;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class MenuBarBackgroundSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var cache:Object = {};
      
      private var _borderMetrics:EdgeMetrics = new EdgeMetrics(1,1,1,1);
      
      public function MenuBarBackgroundSkin()
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
      
      override public function get borderMetrics() : EdgeMetrics
      {
         return this._borderMetrics;
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
         super.updateDisplayList(w,h);
         var bevel:Boolean = Boolean(getStyle("bevel"));
         var borderColor:uint = uint(getStyle("borderColor"));
         var cornerRadius:Number = Number(getStyle("cornerRadius"));
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("fillColors");
         styleManager.getColorNames(fillColors);
         var themeColor:uint = uint(getStyle("themeColor"));
         var derStyles:Object = calcDerivedStyles(themeColor,fillColors[0],fillColors[1]);
         var borderColorDrk1:Number = Number(ColorUtil.adjustBrightness2(borderColor,-25));
         var cr:Number = Math.max(0,cornerRadius);
         var cr1:Number = Math.max(0,cornerRadius - 1);
         var upFillColors:Array = [fillColors[0],fillColors[1]];
         var upFillAlphas:Array = [fillAlphas[0],fillAlphas[1]];
         graphics.clear();
         drawRoundRect(0,0,w,h,cr,[borderColor,borderColorDrk1],1,verticalGradientMatrix(0,0,w,h),GradientType.LINEAR,null,{
            "x":1,
            "y":1,
            "w":w - 2,
            "h":h - 2,
            "r":cr1
         });
         drawRoundRect(1,1,w - 2,h - 2,cr1,upFillColors,upFillAlphas,verticalGradientMatrix(1,1,w - 2,h - 2));
      }
   }
}

