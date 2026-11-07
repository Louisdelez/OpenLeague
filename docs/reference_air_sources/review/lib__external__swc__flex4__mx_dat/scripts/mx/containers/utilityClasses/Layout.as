package mx.containers.utilityClasses
{
   import mx.core.Container;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ExcludeClass]
   public class Layout
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      protected var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _target:Container;
      
      public function Layout()
      {
         super();
      }
      
      public function get target() : Container
      {
         return this._target;
      }
      
      public function set target(value:Container) : void
      {
         this._target = value;
      }
      
      public function measure() : void
      {
      }
      
      public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
   }
}

