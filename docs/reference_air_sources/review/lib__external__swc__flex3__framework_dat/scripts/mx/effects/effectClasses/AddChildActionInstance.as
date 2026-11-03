package mx.effects.effectClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AddChildActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var index:int = -1;
      
      public var relativeTo:DisplayObjectContainer;
      
      public var position:String;
      
      public function AddChildActionInstance(target:Object)
      {
         super(target);
      }
      
      override public function play() : void
      {
         var targetDisplayObject:DisplayObject = DisplayObject(target);
         super.play();
         if(!relativeTo && Boolean(propertyChanges))
         {
            if(propertyChanges.start.parent == null && propertyChanges.end.parent != null)
            {
               relativeTo = propertyChanges.end.parent;
               position = "index";
               index = propertyChanges.end.index;
            }
         }
         if(!mx_internal::playReversed)
         {
            if(Boolean(target) && Boolean(targetDisplayObject.parent == null) && Boolean(relativeTo))
            {
               switch(position)
               {
                  case "index":
                     if(index == -1)
                     {
                        relativeTo.addChild(targetDisplayObject);
                     }
                     else
                     {
                        relativeTo.addChildAt(targetDisplayObject,Math.min(index,relativeTo.numChildren));
                     }
                     break;
                  case "before":
                     relativeTo.parent.addChildAt(targetDisplayObject,relativeTo.parent.getChildIndex(relativeTo));
                     break;
                  case "after":
                     relativeTo.parent.addChildAt(targetDisplayObject,relativeTo.parent.getChildIndex(relativeTo) + 1);
                     break;
                  case "firstChild":
                     relativeTo.addChildAt(targetDisplayObject,0);
                  case "lastChild":
                     relativeTo.addChild(targetDisplayObject);
               }
            }
         }
         else if(Boolean(target) && Boolean(relativeTo) && targetDisplayObject.parent == relativeTo)
         {
            relativeTo.removeChild(targetDisplayObject);
         }
         finishRepeat();
      }
   }
}

