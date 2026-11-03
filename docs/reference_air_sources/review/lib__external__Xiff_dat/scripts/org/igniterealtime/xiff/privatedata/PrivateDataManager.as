package org.igniterealtime.xiff.privatedata
{
   import flash.events.EventDispatcher;
   import org.igniterealtime.xiff.core.XMPPConnection;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.privatedata.PrivateDataExtension;
   import org.igniterealtime.xiff.filter.CallbackPacketFilter;
   import org.igniterealtime.xiff.filter.IPacketFilter;
   import org.igniterealtime.xiff.util.Callback;
   
   public class PrivateDataManager extends EventDispatcher
   {
      
      private static var privateDataManagerConstructed:Boolean = privateDataManagerStaticConstructor();
      
      private var _connection:XMPPConnection;
      
      public function PrivateDataManager(param1:XMPPConnection)
      {
         super();
         this._connection = param1;
      }
      
      private static function privateDataManagerStaticConstructor() : Boolean
      {
         ExtensionClassRegistry.register(PrivateDataExtension);
         return true;
      }
      
      public function getPrivateData(param1:String, param2:String, param3:Callback) : void
      {
         var _loc4_:IPacketFilter = new CallbackPacketFilter(param3);
         var _loc5_:IQ = new IQ(null,IQ.GET_TYPE,null,"accept",_loc4_);
         _loc5_.addExtension(new PrivateDataExtension(param1,param2));
         this._connection.send(_loc5_);
      }
      
      public function setPrivateData(param1:String, param2:String, param3:IPrivatePayload) : void
      {
         var _loc4_:IQ = new IQ(null,IQ.SET_TYPE);
         _loc4_.addExtension(new PrivateDataExtension(param1,param2,param3));
         this._connection.send(_loc4_);
      }
   }
}

