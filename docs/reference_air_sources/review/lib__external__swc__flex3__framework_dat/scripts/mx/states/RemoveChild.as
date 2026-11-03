package mx.states
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class RemoveChild implements IOverride
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var removed:Boolean;
      
      private var oldIndex:int;
      
      private var oldParent:DisplayObjectContainer;
      
      [Inspectable(category="General")]
      public var target:DisplayObject;
      
      public function RemoveChild(target:DisplayObject = null)
      {
         super();
         this.target = target;
      }
      
      public function remove(parent:UIComponent) : void
      {
         if(removed)
         {
            oldParent.addChildAt(target,oldIndex);
            if(target is UIComponent)
            {
               UIComponent(target).mx_internal::updateCallbacks();
            }
            removed = false;
         }
      }
      
      public function apply(parent:UIComponent) : void
      {
         removed = false;
         if(Boolean(target.parent))
         {
            oldParent = target.parent;
            oldIndex = oldParent.getChildIndex(target);
            oldParent.removeChild(target);
            removed = true;
         }
      }
      
      public function initialize() : void
      {
      }
   }
}

