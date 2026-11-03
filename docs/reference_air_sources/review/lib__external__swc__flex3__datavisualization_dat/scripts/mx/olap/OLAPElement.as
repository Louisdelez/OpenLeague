package mx.olap
{
   import flash.utils.Proxy;
   
   public class OLAPElement extends Proxy implements IOLAPElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _dimension:IOLAPDimension;
      
      private var _name:String;
      
      private var _displayName:String;
      
      public function OLAPElement(name:String = null, displayName:String = null)
      {
         super();
         _name = name;
         _displayName = displayName;
      }
      
      public function get uniqueName() : String
      {
         if(Boolean(dimension))
         {
            return String("[" + dimension.name + "].[" + name + "]");
         }
         return name;
      }
      
      public function get displayName() : String
      {
         return Boolean(_displayName) ? _displayName : name;
      }
      
      public function get dimension() : IOLAPDimension
      {
         return _dimension;
      }
      
      public function get name() : String
      {
         return _name;
      }
      
      public function set dimension(value:IOLAPDimension) : void
      {
         _dimension = value;
      }
      
      public function set name(value:String) : void
      {
         OLAPTrace.traceMsg("Setting the name to: " + value,OLAPTrace.TRACE_LEVEL_3);
         _name = value;
      }
      
      public function set displayName(value:String) : void
      {
         _displayName = value;
      }
      
      public function toString() : String
      {
         return uniqueName;
      }
   }
}

