package mx.skins.halo
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class DataGridHeaderBackgroundSkin extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function DataGridHeaderBackgroundSkin()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var g:Graphics = graphics;
         g.clear();
         var colors:Array = getStyle("headerColors");
         StyleManager.getColorNames(colors);
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(w,h + 1,Math.PI / 2,0,0);
         colors = [colors[0],colors[0],colors[1]];
         var ratios:Array = [0,60,255];
         var alphas:Array = [1,1,1];
         g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
         g.lineStyle(0,0,0);
         g.moveTo(0,0);
         g.lineTo(w,0);
         g.lineTo(w,h - 0.5);
         g.lineStyle(0,getStyle("borderColor"),100);
         g.lineTo(0,h - 0.5);
         g.lineStyle(0,0,0);
         g.endFill();
      }
   }
}

