package mx.skins.halo
{
   import flash.display.Graphics;
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import mx.containers.BoxDirection;
   import mx.core.mx_internal;
   import mx.skins.ProgrammaticSkin;
   
   use namespace mx_internal;
   
   public class LinkSeparator extends ProgrammaticSkin
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
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
         var separatorColor:uint = getStyle("separatorColor");
         var separatorWidth:Number = getStyle("separatorWidth");
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

