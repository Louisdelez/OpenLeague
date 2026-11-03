package mx.skins.halo
{
   import flash.display.Graphics;
   
   public class PopUpMenuIcon extends PopUpIcon
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function PopUpMenuIcon()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var g:Graphics = graphics;
         g.clear();
         g.lineStyle(1,arrowColor);
         g.moveTo(0,0);
         g.lineTo(w / 2,height);
         g.lineTo(w,0);
      }
   }
}

