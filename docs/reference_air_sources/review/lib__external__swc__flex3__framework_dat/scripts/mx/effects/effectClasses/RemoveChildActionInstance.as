package mx.effects.effectClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RemoveChildActionInstance extends ActionEffectInstance
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _startParent:DisplayObjectContainer;
      
      private var _startIndex:Number;
      
      public function RemoveChildActionInstance(target:Object)
      {
         super(target);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
      }
      
      override public function play() : void
      {
         var targetDisplayObject:DisplayObject = DisplayObject(target);
         var doRemove:Boolean = true;
         super.play();
         if(Boolean(propertyChanges))
         {
            doRemove = propertyChanges.start.parent != null && propertyChanges.end.parent == null;
         }
         if(!mx_internal::playReversed)
         {
            if(Boolean(doRemove) && Boolean(target) && targetDisplayObject.parent != null)
            {
               targetDisplayObject.parent.removeChild(targetDisplayObject);
            }
         }
         else if(Boolean(_startParent) && !isNaN(_startIndex))
         {
            _startParent.addChildAt(targetDisplayObject,_startIndex);
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         var targetDisplayObject:DisplayObject = DisplayObject(target);
         if(Boolean(target) && targetDisplayObject.parent != null)
         {
            _startIndex = targetDisplayObject.parent.getChildIndex(targetDisplayObject);
            _startParent = targetDisplayObject.parent;
         }
      }
   }
}

