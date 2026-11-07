package mx.states
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.core.ContainerCreationPolicy;
   import mx.core.IDeferredInstance;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("states")]
   [DefaultProperty("targetFactory")]
   public class AddChild extends OverrideBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      mx_internal var added:Boolean = false;
      
      mx_internal var instanceCreated:Boolean = false;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _creationPolicy:String = "auto";
      
      [Inspectable(category="General")]
      public var position:String;
      
      [Inspectable(category="General")]
      public var relativeTo:Object;
      
      private var _target:DisplayObject;
      
      private var _targetFactory:IDeferredInstance;
      
      public function AddChild(relativeTo:UIComponent = null, target:DisplayObject = null, position:String = "lastChild")
      {
         super();
         this.relativeTo = relativeTo;
         this.target = target;
         this.position = position;
      }
      
      [Inspectable(category="General")]
      public function get creationPolicy() : String
      {
         return this._creationPolicy;
      }
      
      public function set creationPolicy(value:String) : void
      {
         this._creationPolicy = value;
         if(this._creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      [Inspectable(category="General")]
      public function get target() : DisplayObject
      {
         if(!this._target && this.creationPolicy != ContainerCreationPolicy.NONE)
         {
            this.createInstance();
         }
         return this._target;
      }
      
      public function set target(value:DisplayObject) : void
      {
         this._target = value;
      }
      
      [Inspectable(category="General")]
      public function get targetFactory() : IDeferredInstance
      {
         return this._targetFactory;
      }
      
      public function set targetFactory(value:IDeferredInstance) : void
      {
         this._targetFactory = value;
         if(this.creationPolicy == ContainerCreationPolicy.ALL)
         {
            this.createInstance();
         }
      }
      
      public function createInstance() : void
      {
         var instance:Object = null;
         if(!this.instanceCreated && !this._target && Boolean(this.targetFactory))
         {
            this.instanceCreated = true;
            instance = this.targetFactory.getInstance();
            if(instance is DisplayObject)
            {
               this._target = DisplayObject(instance);
            }
         }
      }
      
      override public function initialize() : void
      {
         if(this.creationPolicy == ContainerCreationPolicy.AUTO)
         {
            this.createInstance();
         }
      }
      
      override public function apply(parent:UIComponent) : void
      {
         var message:String = null;
         var obj:* = getOverrideContext(this.relativeTo,parent);
         parentContext = parent;
         this.added = false;
         if(!this.target || !(obj is DisplayObjectContainer))
         {
            if(this.relativeTo != null && !applied)
            {
               addContextListener(this.relativeTo);
            }
            applied = true;
            return;
         }
         applied = true;
         this.relativeTo = obj;
         if(Boolean(this.target.parent))
         {
            message = this.resourceManager.getString("states","alreadyParented");
            throw new Error(message);
         }
         switch(this.position)
         {
            case "before":
               obj.parent.addChildAt(this.target,obj.parent.getChildIndex(obj));
               break;
            case "after":
               obj.parent.addChildAt(this.target,obj.parent.getChildIndex(obj) + 1);
               break;
            case "firstChild":
               obj.addChildAt(this.target,0);
               break;
            case "lastChild":
            default:
               obj.addChild(this.target);
         }
         this.added = true;
      }
      
      override public function remove(parent:UIComponent) : void
      {
         var obj:* = getOverrideContext(this.relativeTo,parent);
         if(!this.added || !(obj is DisplayObjectContainer))
         {
            if(obj == null)
            {
               removeContextListener();
               applied = false;
               parentContext = null;
            }
            return;
         }
         switch(this.position)
         {
            case "before":
            case "after":
               obj.parent.removeChild(this.target);
               break;
            case "firstChild":
            case "lastChild":
            default:
               if(obj == this.target.parent)
               {
                  obj.removeChild(this.target);
               }
         }
         this.added = false;
         applied = false;
         parentContext = null;
      }
   }
}

