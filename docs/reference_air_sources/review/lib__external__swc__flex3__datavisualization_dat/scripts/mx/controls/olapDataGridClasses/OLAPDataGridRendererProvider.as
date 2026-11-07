package mx.controls.olapDataGridClasses
{
   import mx.core.IFactory;
   
   public class OLAPDataGridRendererProvider
   {
      
      private var _renderer:IFactory;
      
      public var styleName:String;
      
      private var _type:int;
      
      private var _uniqueName:String;
      
      public function OLAPDataGridRendererProvider()
      {
         super();
      }
      
      public function get renderer() : IFactory
      {
         return _renderer;
      }
      
      public function set renderer(r:IFactory) : void
      {
         _renderer = r;
      }
      
      public function set type(name:int) : void
      {
         _type = name;
      }
      
      public function set uniqueName(name:String) : void
      {
         _uniqueName = name;
      }
      
      public function get type() : int
      {
         return _type;
      }
      
      public function get uniqueName() : String
      {
         return _uniqueName;
      }
   }
}

