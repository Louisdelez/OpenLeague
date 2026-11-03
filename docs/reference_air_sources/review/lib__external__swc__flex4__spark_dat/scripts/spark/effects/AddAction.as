package spark.effects
{
   import flash.display.DisplayObjectContainer;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.effects.Effect;
   import mx.effects.IEffectInstance;
   import mx.effects.effectClasses.PropertyChanges;
   import spark.effects.supportClasses.AddActionInstance;
   
   [Exclude(name="duration",kind="property")]
   public class AddAction extends Effect
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var AFFECTED_PROPERTIES:Array = ["parent","index"];
      
      public static const BEFORE:String = "before";
      
      public static const AFTER:String = "after";
      
      public static const FIRST_CHILD:String = "firstChild";
      
      public static const LAST_CHILD:String = "lastChild";
      
      public static const INDEX:String = "index";
      
      private var localPropertyChanges:Array;
      
      [Inspectable(category="General",minValue="-1")]
      public var index:int = -1;
      
      [Inspectable(category="General")]
      public var relativeTo:DisplayObjectContainer;
      
      [Inspectable(category="General")]
      public var position:String = "index";
      
      public function AddAction(target:Object = null)
      {
         super(target);
         duration = 0;
         instanceClass = AddActionInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      private function getPropertyChanges(target:Object) : PropertyChanges
      {
         for(var i:int = 0; i < this.localPropertyChanges.length; i++)
         {
            if(this.localPropertyChanges[i].target == target)
            {
               return this.localPropertyChanges[i];
            }
         }
         return null;
      }
      
      private function targetSortHandler(first:Object, second:Object) : Number
      {
         var p1:PropertyChanges = this.getPropertyChanges(first);
         var p2:PropertyChanges = this.getPropertyChanges(second);
         if(Boolean(p1) && Boolean(p2))
         {
            if(p1.start.index > p2.start.index)
            {
               return 1;
            }
            if(p1.start.index < p2.start.index)
            {
               return -1;
            }
         }
         return 0;
      }
      
      override public function createInstances(targets:Array = null) : Array
      {
         if(!targets)
         {
            targets = this.targets;
         }
         if(Boolean(targets) && Boolean(propertyChangesArray))
         {
            this.localPropertyChanges = propertyChangesArray;
            targets.sort(this.targetSortHandler);
         }
         return super.createInstances(targets);
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var actionInstance:AddActionInstance = AddActionInstance(instance);
         actionInstance.relativeTo = this.relativeTo;
         actionInstance.index = this.index;
         actionInstance.position = this.position;
      }
      
      override protected function getValueFromTarget(target:Object, property:String) : *
      {
         var container:* = target.parent;
         if(property == "index")
         {
            return Boolean(container) ? (container is IVisualElementContainer ? IVisualElementContainer(container).getElementIndex(target as IVisualElement) : container.getChildIndex(target)) : 0;
         }
         return super.getValueFromTarget(target,property);
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property == "parent" && value == undefined)
         {
            if(Boolean(target.parent))
            {
               if(target.parent is IVisualElementContainer)
               {
                  IVisualElementContainer(target.parent).removeElement(target as IVisualElement);
               }
               else
               {
                  target.parent.removeChild(target);
               }
            }
         }
      }
   }
}

