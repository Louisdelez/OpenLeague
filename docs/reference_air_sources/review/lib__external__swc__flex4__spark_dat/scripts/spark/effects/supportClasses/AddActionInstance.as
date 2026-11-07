package spark.effects.supportClasses
{
   import flash.display.DisplayObjectContainer;
   import mx.core.IVisualElementContainer;
   import mx.effects.effectClasses.ActionEffectInstance;
   import spark.effects.AddAction;
   
   public class AddActionInstance extends ActionEffectInstance
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var index:int = -1;
      
      public var relativeTo:DisplayObjectContainer;
      
      public var position:String;
      
      public function AddActionInstance(target:Object)
      {
         super(target);
      }
      
      private function getContainer(child:*) : *
      {
         return child.parent;
      }
      
      private function getNumElements(container:*) : int
      {
         if(container is IVisualElementContainer)
         {
            return IVisualElementContainer(container).numElements;
         }
         return container.numChildren;
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
         super.play();
         if(!this.relativeTo && Boolean(propertyChanges))
         {
            if(this.getContainer(propertyChanges.start) == null && this.getContainer(propertyChanges.end) != null)
            {
               this.relativeTo = this.getContainer(propertyChanges.end);
               this.position = "index";
               this.index = propertyChanges.end.index;
            }
         }
         if(!playReversed)
         {
            if(Boolean(target) && Boolean(this.getContainer(target) == null) && Boolean(this.relativeTo))
            {
               switch(this.position)
               {
                  case AddAction.INDEX:
                     if(this.index == -1)
                     {
                        this.addChild(this.relativeTo,target);
                     }
                     else
                     {
                        this.addChildAt(this.relativeTo,target,Math.min(this.index,this.getNumElements(this.relativeTo)));
                     }
                     break;
                  case AddAction.BEFORE:
                     this.addChildAt(this.getContainer(this.relativeTo),target,this.getChildIndex(this.getContainer(this.relativeTo),this.relativeTo));
                     break;
                  case AddAction.AFTER:
                     this.addChildAt(this.getContainer(this.relativeTo),target,this.getChildIndex(this.getContainer(this.relativeTo),this.relativeTo) + 1);
                     break;
                  case AddAction.FIRST_CHILD:
                     this.addChildAt(this.relativeTo,target,0);
                  case AddAction.LAST_CHILD:
                     this.addChild(this.relativeTo,target);
               }
            }
         }
         else if(Boolean(target) && Boolean(this.relativeTo) && this.getContainer(target) == this.relativeTo)
         {
            this.removeChild(this.relativeTo,target);
         }
         finishRepeat();
      }
   }
}

