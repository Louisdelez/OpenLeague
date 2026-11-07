package flash.data
{
   [API("661")]
   public class SQLTriggerSchema extends SQLSchema
   {
      
      private var _table:String;
      
      public function SQLTriggerSchema(database:String, name:String, sql:String, table:String)
      {
         super(database,name,sql);
         this._table = table;
      }
      
      public function get table() : String
      {
         return this._table;
      }
   }
}

