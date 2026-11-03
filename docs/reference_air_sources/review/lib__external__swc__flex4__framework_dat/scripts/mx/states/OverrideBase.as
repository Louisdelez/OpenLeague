package mx.states
{
   import mx.binding.BindingManager;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.utils.OnDemandEventDispatcher;
   
   public class OverrideBase extends OnDemandEventDispatcher implements IOverride
   {
      
      protected var applied:Boolean = false;
      
      protected var parentContext:UIComponent;
      
      private var targetProperty:String;
      
      public var isBaseValueDataBound:Boolean;
      
      public function OverrideBase()
      {
         super();
      }
      
      public function initialize() : void
      {
      }
      
      public function apply(parent:UIComponent) : void
      {
      }
      
      public function remove(parent:UIComponent) : void
      {
      }
      
      public function initializeFromObject(properties:Object) : Object
      {
         var p:String = null;
         for(p in properties)
         {
            this[p] = properties[p];
         }
         return Object(this);
      }
      
      protected function getOverrideContext(target:Object, parent:UIComponent) : Object
      {
         if(target == null)
         {
            return parent;
         }
         if(target is String)
         {
            return parent[target];
         }
         return target;
      }
      
      protected function addContextListener(target:Object) : void
      {
         if(target is String && this.parentContext != null)
         {
            this.targetProperty = target as String;
            this.parentContext.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.context_propertyChangeHandler);
         }
      }
      
      protected function removeContextListener() : void
      {
         if(this.parentContext != null)
         {
            this.parentContext.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.context_propertyChangeHandler);
         }
      }
      
      protected function context_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         if(event.property == this.targetProperty && event.newValue != null)
         {
            this.apply(this.parentContext);
            this.removeContextListener();
         }
      }
      
      protected function enableBindings(target:Object, parent:UIComponent, property:String, enable:Boolean = true) : void
      {
         var document:Object = null;
         var name:String = null;
         var root:String = null;
         if(Boolean(this.isBaseValueDataBound && target) && Boolean(parent) && Boolean(property))
         {
            document = target.hasOwnProperty("document") ? target.document : null;
            document = !document && parent.hasOwnProperty("document") ? parent.document : document;
            name = target.hasOwnProperty("id") ? target.id : null;
            name = !name && target.hasOwnProperty("name") ? target.name : name;
            if(Boolean(document) && Boolean(name))
            {
               root = document == target ? "this" : name;
               BindingManager.enableBindings(document,root + "." + property,enable);
            }
         }
      }
   }
}

