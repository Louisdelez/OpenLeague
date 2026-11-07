package blix.assets.proxy.mappings
{
   public class InstanceMapping
   {
      
      protected var instanceName:String = "";
      
      protected var parent:InstanceMapping;
      
      private var _name:String;
      
      public function InstanceMapping(param1:String = "", param2:InstanceMapping = null)
      {
         super();
         this.instanceName = param1;
         this.parent = param2;
         this._name = param2 != null && param2.instanceName != null ? param2._name + "." + param1 : param1;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function toString() : String
      {
         return this._name;
      }
   }
}

