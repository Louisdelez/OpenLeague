package spark.components
{
   import flash.events.Event;
   import mx.core.ContainerCreationPolicy;
   import mx.core.IDeferredContentOwner;
   import mx.core.INavigatorContent;
   
   public class NavigatorContent extends SkinnableContainer implements INavigatorContent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _skinParts:Object = {"contentGroup":false};
      
      private var _icon:Class = null;
      
      private var _label:String = "";
      
      public function NavigatorContent()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="",format="EmbeddedFile")]
      [Bindable("iconChanged")]
      public function get icon() : Class
      {
         return this._icon;
      }
      
      public function set icon(value:Class) : void
      {
         this._icon = value;
         dispatchEvent(new Event("iconChanged"));
      }
      
      [Inspectable(category="General",defaultValue="")]
      [Bindable("labelChanged")]
      public function get label() : String
      {
         return this._label;
      }
      
      public function set label(value:String) : void
      {
         this._label = value;
         dispatchEvent(new Event("labelChanged"));
      }
      
      override protected function createChildren() : void
      {
         var parentCreationPolicy:String = null;
         if(creationPolicy == ContainerCreationPolicy.AUTO)
         {
            if(parent is IDeferredContentOwner)
            {
               parentCreationPolicy = IDeferredContentOwner(parent).creationPolicy;
               creationPolicy = parentCreationPolicy == ContainerCreationPolicy.ALL ? ContainerCreationPolicy.ALL : ContainerCreationPolicy.NONE;
            }
         }
         super.createChildren();
      }
   }
}

