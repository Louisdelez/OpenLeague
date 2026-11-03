package mx.skins.halo
{
   import flash.display.Graphics;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.containers.BoxDirection;
   import mx.skins.ProgrammaticSkin;
   
   public class LinkSeparator extends ProgrammaticSkin
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var boxes:Object = {};
      
      public function LinkSeparator()
      {
         super();
      }
      
      private static function isBox(parent:Object) : Boolean
      {
         var xmllist:XMLList;
         var s:String = null;
         var x:XML = null;
         s = getQualifiedClassName(parent);
         if(boxes[s] == 1)
         {
            return true;
         }
         if(boxes[s] == 0)
         {
            return false;
         }
         if(s == "mx.containers::Box")
         {
            boxes[s] == 1;
            return true;
         }
         x = describeType(parent);
         xmllist = x.extendsClass.(@type == "mx.containers::Box");
         if(xmllist.length() == 0)
         {
            boxes[s] = 0;
            return false;
         }
         boxes[s] = 1;
         return true;
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         super.updateDisplayList(w,h);
         var separatorColor:uint = uint(getStyle("separatorColor"));
         var separatorWidth:Number = Number(getStyle("separatorWidth"));
         var isVertical:Boolean = false;
         var g:Graphics = graphics;
         g.clear();
         if(separatorWidth > 0)
         {
            if(isBox(parent))
            {
               isVertical = Object(parent).direction == BoxDirection.VERTICAL;
            }
            g.lineStyle(separatorWidth,separatorColor);
            if(isVertical)
            {
               g.moveTo(4,h / 2);
               g.lineTo(w - 4,h / 2);
            }
            else
            {
               g.moveTo(w / 2,6);
               g.lineTo(w / 2,h - 5);
            }
         }
      }
   }
}

