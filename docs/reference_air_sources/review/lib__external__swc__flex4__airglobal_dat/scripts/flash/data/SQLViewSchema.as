package flash.data
{
   [API("661")]
   public class SQLViewSchema extends SQLTableSchema
   {
      
      public function SQLViewSchema(database:String, name:String, sql:String, columns:Array)
      {
         super(database,name,sql,columns);
      }
   }
}

