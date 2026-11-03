package mx.skins.halo
{
   import flash.display.Graphics;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   import mx.utils.ColorUtil;
   
   use namespace mx_internal;
   
   public class DataGridColumnDropIndicator extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function DataGridColumnDropIndicator()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.lineStyle(1,getStyle("rollOverColor"));
         g.moveTo(0,0);
         g.lineTo(0,h);
         g.lineStyle(1,ColorUtil.adjustBrightness(getStyle("themeColor"),-75));
         g.moveTo(1,0);
         g.lineTo(1,h);
         g.lineStyle(1,getStyle("rollOverColor"));
         g.moveTo(2,0);
         g.lineTo(2,h);
      }
   }
}

