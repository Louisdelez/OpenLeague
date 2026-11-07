package mx.containers.utilityClasses
{
   import mx.core.Container;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class Layout
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _target:Container;
      
      protected var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function Layout()
      {
         super();
      }
      
      public function get target() : Container
      {
         return _target;
      }
      
      public function set target(value:Container) : void
      {
         _target = value;
      }
      
      public function measure() : void
      {
      }
      
      public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
   }
}

