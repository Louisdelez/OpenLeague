package spark.effects
{
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.effects.IEffectInstance;
   import spark.effects.supportClasses.FadeInstance;
   
   public class Fade extends Animate
   {
      
      [Inspectable(category="General",defaultValue="undefined",minValue="0.0",maxValue="1.0")]
      public var alphaFrom:Number;
      
      [Inspectable(category="General",defaultValue="NaN",minValue="0.0",maxValue="1.0")]
      public var alphaTo:Number;
      
      public function Fade(target:Object = null)
      {
         super(target);
         instanceClass = FadeInstance;
      }
      
      override protected function initInstance(instance:IEffectInstance) : void
      {
         super.initInstance(instance);
         var fadeInstance:FadeInstance = FadeInstance(instance);
         fadeInstance.alphaFrom = this.alphaFrom;
         fadeInstance.alphaTo = this.alphaTo;
      }
      
      override public function getAffectedProperties() : Array
      {
         return ["alpha","visible","parent","index"];
      }
      
      override protected function getValueFromTarget(target:Object, property:String) : *
      {
         var container:* = undefined;
         if(property == "index" && "parent" in target)
         {
            container = target.parent;
            if(container === undefined || container === null || "mask" in container && container.mask == target)
            {
               return undefined;
            }
            if(container is IVisualElementContainer)
            {
               return IVisualElementContainer(container).getElementIndex(target as IVisualElement);
            }
            if("getChildIndex" in container)
            {
               return container.getChildIndex(target);
            }
         }
         return super.getValueFromTarget(target,property);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function applyEndValues(propChanges:Array, targets:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var target:Object = null;
         super.applyEndValues(propChanges,targets);
         if(Boolean(transitionInterruption) && Boolean(propChanges))
         {
            n = int(propChanges.length);
            for(i = 0; i < n; i++)
            {
               target = propChanges[i].target;
               if(this.targets.indexOf(target) >= 0 && (propChanges[i].start["parent"] !== undefined && propChanges[i].end["parent"] !== undefined && propChanges[i].start["parent"] != propChanges[i].end["parent"]) || propChanges[i].start["visible"] !== undefined && propChanges[i].end["visible"] !== undefined && propChanges[i].start["visible"] != propChanges[i].end["visible"])
               {
                  target.alpha = propChanges[i].end["alpha"] !== undefined ? propChanges[i].end["alpha"] : 1;
               }
            }
         }
      }
      
      override protected function applyValueToTarget(target:Object, property:String, value:*, props:Object) : void
      {
         if(property == "parent" || property == "index")
         {
            return;
         }
         super.applyValueToTarget(target,property,value,props);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function captureValues(propChanges:Array, setStartValues:Boolean, targetsToCapture:Array = null) : Array
      {
         var propertyChanges:Array = super.captureValues(propChanges,setStartValues,targetsToCapture);
         var n:int = int(propertyChanges.length);
         for(var i:int = 0; i < n; i++)
         {
            if(propertyChanges[i].stripUnchangedValues != false)
            {
               if(Boolean(propertyChanges[i].start.hasOwnProperty("alpha")))
               {
                  if(propertyChanges[i].start["alpha"] == propertyChanges[i].end["alpha"] && this.alphaTo != propertyChanges[i].end["alpha"])
                  {
                     propertyChanges[i].stripUnchangedValues = false;
                  }
               }
            }
         }
         return propertyChanges;
      }
   }
}

