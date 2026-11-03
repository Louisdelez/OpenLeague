package mx.states
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RemoveChild extends OverrideBase
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var oldParent:DisplayObjectContainer;
      
      private var oldIndex:int;
      
      private var removed:Boolean;
      
      [Inspectable(category="General")]
      public var target:Object;
      
      public function RemoveChild(target:DisplayObject = null)
      {
         super();
         this.target = target;
      }
      
      override public function apply(parent:UIComponent) : void
      {
         parentContext = parent;
         this.removed = false;
         var obj:* = getOverrideContext(this.target,parent);
         if(obj is DisplayObject && Boolean(obj.parent))
         {
            this.oldParent = obj.parent;
            this.oldIndex = this.oldParent.getChildIndex(obj);
            this.oldParent.removeChild(obj);
            this.removed = true;
         }
         else if(obj == null && !applied)
         {
            addContextListener(this.target);
         }
         applied = true;
      }
      
      override public function remove(parent:UIComponent) : void
      {
         var obj:* = getOverrideContext(this.target,parent);
         if(this.removed && obj is DisplayObject)
         {
            this.oldParent.addChildAt(obj,this.oldIndex);
            if(obj is UIComponent)
            {
               UIComponent(this.target).updateCallbacks();
            }
            this.removed = false;
         }
         else if(obj == null)
         {
            removeContextListener();
         }
         applied = false;
         parentContext = null;
      }
   }
}

