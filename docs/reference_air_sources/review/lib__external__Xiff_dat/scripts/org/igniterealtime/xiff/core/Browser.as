package org.igniterealtime.xiff.core
{
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.browse.BrowseExtension;
   import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
   import org.igniterealtime.xiff.data.disco.ItemDiscoExtension;
   
   public class Browser
   {
      
      private static var _staticDepends:Array = [ItemDiscoExtension,InfoDiscoExtension,BrowseExtension,ExtensionClassRegistry];
      
      private static var _isEventEnabled:Boolean = BrowserStaticConstructor();
      
      private var _connection:XMPPConnection;
      
      private var _pending:Object;
      
      public function Browser(param1:XMPPConnection)
      {
         super();
         this.connection = param1;
         this._pending = new Object();
      }
      
      private static function BrowserStaticConstructor() : Boolean
      {
         ItemDiscoExtension.enable();
         InfoDiscoExtension.enable();
         BrowseExtension.enable();
         return true;
      }
      
      public function getNodeInfo(param1:EscapedJID, param2:String, param3:String, param4:Object) : void
      {
         var _loc6_:InfoDiscoExtension = null;
         var _loc5_:IQ = new IQ(param1,IQ.GET_TYPE);
         _loc6_ = new InfoDiscoExtension(_loc5_.getNode());
         _loc6_.service = param1;
         _loc6_.serviceNode = param2;
         _loc5_.callbackName = param3;
         _loc5_.callbackScope = param4;
         _loc5_.addExtension(_loc6_);
         this.connection.send(_loc5_);
      }
      
      public function getNodeItems(param1:EscapedJID, param2:String, param3:String, param4:Object) : void
      {
         var _loc5_:IQ = new IQ(param1,IQ.GET_TYPE);
         var _loc6_:ItemDiscoExtension = new ItemDiscoExtension(_loc5_.getNode());
         _loc6_.service = param1;
         _loc6_.serviceNode = param2;
         _loc5_.callbackName = param3;
         _loc5_.callbackScope = param4;
         _loc5_.addExtension(_loc6_);
         this.connection.send(_loc5_);
      }
      
      public function getServiceInfo(param1:EscapedJID, param2:String, param3:Object) : void
      {
         var _loc4_:IQ = new IQ(param1,IQ.GET_TYPE);
         _loc4_.callbackName = param2;
         _loc4_.callbackScope = param3;
         _loc4_.addExtension(new InfoDiscoExtension(_loc4_.getNode()));
         this.connection.send(_loc4_);
      }
      
      public function getServiceItems(param1:EscapedJID, param2:String, param3:Object) : void
      {
         var _loc4_:IQ = new IQ(param1,IQ.GET_TYPE);
         _loc4_.callbackName = param2;
         _loc4_.callbackScope = param3;
         _loc4_.addExtension(new ItemDiscoExtension(_loc4_.getNode()));
         this.connection.send(_loc4_);
      }
      
      public function browseItem(param1:EscapedJID, param2:String, param3:Object) : void
      {
         var _loc4_:IQ = new IQ(param1,IQ.GET_TYPE);
         _loc4_.callbackName = param2;
         _loc4_.callbackScope = param3;
         _loc4_.addExtension(new BrowseExtension(_loc4_.getNode()));
         this.connection.send(_loc4_);
      }
      
      public function get connection() : XMPPConnection
      {
         return this._connection;
      }
      
      public function set connection(param1:XMPPConnection) : void
      {
         this._connection = param1;
      }
   }
}

