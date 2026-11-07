package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import mx.skins.Border;
   import mx.utils.ColorUtil;
   
   public class SliderThumbSkin extends Border
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var cache:Object = {};
      
      public function SliderThumbSkin()
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
         }
         return cache[key];
      }
      
      override public function get measuredWidth() : Number
      {
         return 12;
      }
      
      override public function get measuredHeight() : Number
      {
         return 12;
      }
      
      protected function drawThumbState(w:Number, h:Number, borderColors:Array, fillColors:Array, fillAlphas:Array, drawBacking:Boolean, drillHole:Boolean) : void
      {
         var g:Graphics = graphics;
         var down:Boolean = Boolean(getStyle("invertThumbDirection"));
         var h0:Number = down ? h : 0;
         var h1:Number = down ? h - 1 : 1;
         var h2:Number = down ? h - 2 : 2;
         var hhm2:Number = down ? 2 : h - 2;
         var hhm1:Number = down ? 1 : h - 1;
         var hh:Number = down ? 0 : h;
         if(down)
         {
            borderColors = [borderColors[1],borderColors[0]];
            fillColors = [fillColors[1],fillColors[0]];
            fillAlphas = [fillAlphas[1],fillAlphas[0]];
         }
         if(drawBacking)
         {
            g.beginGradientFill(GradientType.LINEAR,[16777215,16777215],[0.6,0.6],[0,255],verticalGradientMatrix(0,0,w,h));
            g.moveTo(w / 2,h0);
            g.curveTo(w / 2,h0,w / 2 - 2,h2);
            g.lineTo(0,hhm2);
            g.curveTo(0,hhm2,2,hh);
            g.lineTo(w - 2,hh);
            g.curveTo(w - 2,hh,w,hhm2);
            g.lineTo(w / 2 + 2,h2);
            g.curveTo(w / 2 + 2,h2,w / 2,h0);
            g.endFill();
         }
         g.beginGradientFill(GradientType.LINEAR,borderColors,[1,1],[0,255],verticalGradientMatrix(0,0,w,h));
         g.moveTo(w / 2,h0);
         g.curveTo(w / 2,h0,w / 2 - 2,h2);
         g.lineTo(0,hhm2);
         g.curveTo(0,hhm2,2,hh);
         g.lineTo(w - 2,hh);
         g.curveTo(w - 2,hh,w,hhm2);
         g.lineTo(w / 2 + 2,h2);
         g.curveTo(w / 2 + 2,h2,w / 2,h0);
         if(drillHole)
         {
            g.moveTo(w / 2,h1);
            g.curveTo(w / 2,h0,w / 2 - 1,h2);
            g.lineTo(1,hhm1);
            g.curveTo(1,hhm1,1,hhm1);
            g.lineTo(w - 1,hhm1);
            g.curveTo(w - 1,hhm1,w - 1,hhm2);
            g.lineTo(w / 2 + 1,h2);
            g.curveTo(w / 2 + 1,h2,w / 2,h1);
            g.endFill();
         }
         g.beginGradientFill(GradientType.LINEAR,fillColors,fillAlphas,[0,255],verticalGradientMatrix(0,0,w,h));
         g.moveTo(w / 2,h1);
         g.curveTo(w / 2,h0,w / 2 - 1,h2);
         g.lineTo(1,hhm1);
         g.curveTo(1,hhm1,1,hhm1);
         g.lineTo(w - 1,hhm1);
         g.curveTo(w - 1,hhm1,w - 1,hhm2);
         g.lineTo(w / 2 + 1,h2);
         g.curveTo(w / 2 + 1,h2,w / 2,h1);
         g.endFill();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var overFillColors:Array = null;
         var overFillAlphas:Array = null;
         super.updateDisplayList(w,h);
         var borderColor:uint = uint(getStyle("borderColor"));
         var fillAlphas:Array = getStyle("fillAlphas");
         var fillColors:Array = getStyle("fillColors");
         styleManager.getColorNames(fillColors);
         var themeColor:uint = uint(getStyle("themeColor"));
         var derStyles:Object = calcDerivedStyles(themeColor,borderColor,fillColors[0],fillColors[1]);
         var g:Graphics = graphics;
         g.clear();
         switch(name)
         {
            case "thumbUpSkin":
               this.drawThumbState(w,h,[borderColor,derStyles.borderColorDrk1],[fillColors[0],fillColors[1]],[fillAlphas[0],fillAlphas[1]],true,true);
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
               this.drawThumbState(w,h,[derStyles.themeColDrk2,derStyles.themeColDrk1],overFillColors,overFillAlphas,true,true);
               break;
            case "thumbDownSkin":
               this.drawThumbState(w,h,[derStyles.themeColDrk2,derStyles.themeColDrk1],[derStyles.fillColorPress1,derStyles.fillColorPress2],[1,1],true,false);
               break;
            case "thumbDisabledSkin":
               this.drawThumbState(w,h,[borderColor,derStyles.borderColorDrk1],[fillColors[0],fillColors[1]],[Math.max(0,fillAlphas[0] - 0.15),Math.max(0,fillAlphas[1] - 0.15)],false,false);
         }
      }
   }
}

