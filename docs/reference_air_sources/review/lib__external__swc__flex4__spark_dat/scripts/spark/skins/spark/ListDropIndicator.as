package spark.skins.spark
{
   import flash.display.Graphics;
   import mx.skins.ProgrammaticSkin;
   
   public class ListDropIndicator extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function ListDropIndicator()
      {
         super();
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var width:Number = Math.max(2,w);
         var height:Number = Math.max(2,h);
         if(width < height)
         {
            width = 2;
         }
         else
         {
            height = 2;
         }
         var x:Number = Math.round((w - width) / 2);
         var y:Number = Math.round((h - height) / 2);
         var g:Graphics = graphics;
         g.clear();
         g.beginFill(2831164);
         g.drawRect(x,y,width,height);
         g.endFill();
      }
   }
}

