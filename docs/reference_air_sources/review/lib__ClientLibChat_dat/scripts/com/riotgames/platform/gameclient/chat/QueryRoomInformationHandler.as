package com.riotgames.platform.gameclient.chat
{
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.common.xmpp.data.muc.QueryRoomInformationExtension;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import flash.utils.getQualifiedClassName;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.IQ;
   import org.igniterealtime.xiff.data.XMPPStanza;
   
   public class QueryRoomInformationHandler
   {
      
      public static const PVP_DOT_NET:String = "pvp.net";
      
      private var originalObfuscatedName:String;
      
      private var toJID:EscapedJID;
      
      public var queryCompletedSignal:Signal = new Signal();
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var fromJID:String;
      
      private var chatService:ChatService;
      
      private var extension:QueryRoomInformationExtension;
      
      public function QueryRoomInformationHandler()
      {
         super();
      }
      
      public function queryChatRoomInformationForJID(param1:String, param2:UnescapedJID, param3:ChatService) : void
      {
         var _loc6_:String = null;
         this.originalObfuscatedName = param1;
         if(param3 != null)
         {
            this.chatService = param3;
            this.toJID = param2.escaped;
            _loc6_ = param3.getConnection().resource;
            this.fromJID = param3.getConnection().username + "@" + PVP_DOT_NET + "/" + _loc6_;
         }
         var _loc4_:IQ = new IQ(this.toJID,IQ.GET_TYPE,XMPPStanza.generateID("disco_info_"),null,null,this.handleRoomInfoResult);
         var _loc5_:QueryRoomInformationExtension = new QueryRoomInformationExtension();
         _loc4_.addExtension(_loc5_);
         this.chatService.getConnection().send(_loc4_);
      }
      
      private function handleRoomInfoResult(param1:IQ) : void
      {
         var _loc2_:XMLNode = param1.getNode().firstChild;
         this.extension = new QueryRoomInformationExtension();
         this.extension.deserialize(_loc2_);
         this.queryCompletedSignal.dispatch(this.originalObfuscatedName,this.extension.getOccupantCount());
         this.queryCompletedSignal.removeAll();
      }
      
      public function queryChatRoomInformation(param1:ChatRoom, param2:ChatService) : void
      {
         this.queryChatRoomInformationForJID(param1.roomName,param1.getRoomJID(),param2);
      }
      
      public function getInternalRoomName() : String
      {
         var _loc1_:XMLNode = this.extension.getNode().parentNode;
         var _loc2_:String = _loc1_.attributes.from;
         var _loc3_:UnescapedJID = new UnescapedJID(_loc2_);
         return _loc3_.node;
      }
      
      public function getOccupantCount() : int
      {
         return this.extension.getOccupantCount();
      }
   }
}

