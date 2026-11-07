package spark.effects.supportClasses
{
   import flash.events.Event;
   import mx.core.IVisualElementContainer;
   import mx.effects.effectClasses.ActionEffectInstance;
   
   public class RemoveActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _startIndex:Number;
      
      private var _startParent:*;
      
      public function RemoveActionInstance(target:Object)
      {
         super(target);
      }
      
      override public function initEffect(event:Event) : void
      {
         super.initEffect(event);
      }
      
      private function getContainer(child:*) : *
      {
         return child.parent;
      }
      
      private function addChild(container:*, child:*) : void
      {
         if(container is IVisualElementContainer)
         {
            IVisualElementContainer(container).addElement(child);
         }
         else
         {
            container.addChild(child);
         }
      }
      
      private function removeChild(container:*, child:*) : void
      {
         if(container is IVisualElementContainer)
         {
            IVisualElementContainer(container).removeElement(child);
         }
         else
         {
            container.removeChild(child);
         }
      }
      
      private function addChildAt(container:*, child:*, index:int) : void
      {
         if(container is IVisualElementContainer)
         {
            IVisualElementContainer(container).addElementAt(child,index);
         }
         else
         {
            container.addChildAt(child,index);
         }
      }
      
      private function getChildIndex(container:*, child:*) : int
      {
         if(container is IVisualElementContainer)
         {
            return IVisualElementContainer(container).getElementIndex(child);
         }
         return container.getChildIndex(child);
      }
      
      override public function play() : void
      {
         var doRemove:Boolean = true;
         super.play();
         if(Boolean(propertyChanges))
         {
            doRemove = this.getContainer(propertyChanges.start) != null && this.getContainer(propertyChanges.end) == null;
         }
         if(!playReversed)
         {
            if(Boolean(doRemove) && Boolean(target) && this.getContainer(target) != null)
            {
               this.removeChild(this.getContainer(target),target);
            }
         }
         else if(Boolean(this._startParent) && !isNaN(this._startIndex))
         {
            this.addChildAt(this._startParent,target,this._startIndex);
         }
         finishRepeat();
      }
      
      override protected function saveStartValue() : *
      {
         if(Boolean(target) && this.getContainer(target) != null)
         {
            this._startIndex = this.getChildIndex(this.getContainer(target),target);
            this._startParent = this.getContainer(target);
         }
      }
   }
}

