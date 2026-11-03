package org.igniterealtime.xiff.data.id
{
   public class IncrementalGenerator implements IIDGenerator
   {
      
      private static var instance:IIDGenerator;
      
      private var myCounter:Number;
      
      public function IncrementalGenerator()
      {
         super();
         this.myCounter = 0;
      }
      
      public static function getInstance() : IIDGenerator
      {
         if(instance == null)
         {
            instance = new IncrementalGenerator();
         }
         return instance;
      }
      
      public function getID(param1:String) : String
      {
         var _loc2_:String = null;
         ++this.myCounter;
         if(param1 != null)
         {
            _loc2_ = param1 + this.myCounter;
         }
         else
         {
            _loc2_ = this.myCounter.toString();
         }
         return _loc2_;
      }
   }
}

