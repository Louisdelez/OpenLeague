package flash.data
{
   [API("661")]
   public class SQLTableSchema extends SQLSchema
   {
      
      private var _columns:Array;
      
      public function SQLTableSchema(database:String, name:String, sql:String, columns:Array)
      {
         super(database,name,sql);
         this._columns = Boolean(columns) ? columns : [];
      }
      
      public function get columns() : Array
      {
         return this._columns;
      }
   }
}

