package mx.effects.effectClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class RemoveChildActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _startIndex:Number;
      
      private var _startParent:DisplayObjectContainer;
      
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
         if(!playReversed)
         {
            if(Boolean(doRemove) && Boolean(target) && targetDisplayObject.parent != null)
            {
               targetDisplayObject.parent.removeChild(targetDisplayObject);
            }
         }
         else if(Boolean(this._startParent) && !isNaN(this._startIndex))
         {
            this._startParent.addChildAt(targetDisplayObject,this._startIndex);
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         var targetDisplayObject:DisplayObject = DisplayObject(target);
         if(Boolean(target) && targetDisplayObject.parent != null)
         {
            this._startIndex = targetDisplayObject.parent.getChildIndex(targetDisplayObject);
            this._startParent = targetDisplayObject.parent;
         }
      }
   }
}

