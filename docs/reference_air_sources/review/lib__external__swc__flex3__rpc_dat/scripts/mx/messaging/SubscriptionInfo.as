package mx.messaging
{
   public class SubscriptionInfo
   {
      
      public var subtopic:String;
      
      public var maxFrequency:uint;
      
      public var selector:String;
      
      public function SubscriptionInfo(st:String, sel:String, mf:uint = 0)
      {
         super();
         subtopic = st;
         selector = sel;
         maxFrequency = mf;
      }
   }
}

