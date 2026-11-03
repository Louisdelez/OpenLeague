package mx.rpc.events
{
   import flash.events.Event;
   import mx.rpc.xml.Schema;
   
   [ExcludeClass]
   public class SchemaLoadEvent extends XMLLoadEvent
   {
      
      public static const LOAD:String = "schemaLoad";
      
      public var schema:Schema;
      
      public function SchemaLoadEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = true, schema:Schema = null, location:String = null)
      {
         super(type == null ? LOAD : type,bubbles,cancelable,schema == null ? null : schema.xml,location);
         this.schema = schema;
      }
      
      public static function createEvent(schema:Schema, location:String = null) : SchemaLoadEvent
      {
         return new SchemaLoadEvent(LOAD,false,true,schema,location);
      }
      
      override public function toString() : String
      {
         return formatToString("SchemaLoadEvent","location","type","bubbles","cancelable","eventPhase");
      }
      
      override public function clone() : Event
      {
         return new SchemaLoadEvent(type,bubbles,cancelable,schema,location);
      }
   }
}

