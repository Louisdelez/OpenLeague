package flash.data
{
   [API("661")]
   public class SQLIndexSchema extends SQLSchema
   {
      
      private var _table:String;
      
      public function SQLIndexSchema(database:String, name:String, sql:String, table:String)
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

