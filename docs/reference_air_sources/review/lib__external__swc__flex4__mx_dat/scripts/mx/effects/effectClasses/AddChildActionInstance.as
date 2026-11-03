package mx.effects.effectClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class AddChildActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
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
         if(!this.relativeTo && Boolean(propertyChanges))
         {
            if(propertyChanges.start.parent == null && propertyChanges.end.parent != null)
            {
               this.relativeTo = propertyChanges.end.parent;
               this.position = "index";
               this.index = propertyChanges.end.index;
            }
         }
         if(!playReversed)
         {
            if(Boolean(target) && Boolean(targetDisplayObject.parent == null) && Boolean(this.relativeTo))
            {
               switch(this.position)
               {
                  case "index":
                     if(this.index == -1)
                     {
                        this.relativeTo.addChild(targetDisplayObject);
                     }
                     else
                     {
                        this.relativeTo.addChildAt(targetDisplayObject,Math.min(this.index,this.relativeTo.numChildren));
                     }
                     break;
                  case "before":
                     this.relativeTo.parent.addChildAt(targetDisplayObject,this.relativeTo.parent.getChildIndex(this.relativeTo));
                     break;
                  case "after":
                     this.relativeTo.parent.addChildAt(targetDisplayObject,this.relativeTo.parent.getChildIndex(this.relativeTo) + 1);
                     break;
                  case "firstChild":
                     this.relativeTo.addChildAt(targetDisplayObject,0);
                  case "lastChild":
                     this.relativeTo.addChild(targetDisplayObject);
               }
            }
         }
         else if(Boolean(target) && Boolean(this.relativeTo) && targetDisplayObject.parent == this.relativeTo)
         {
            this.relativeTo.removeChild(targetDisplayObject);
         }
         finishRepeat();
      }
   }
}

