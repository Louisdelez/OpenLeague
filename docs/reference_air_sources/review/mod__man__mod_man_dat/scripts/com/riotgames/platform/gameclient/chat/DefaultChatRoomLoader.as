package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.gameclient.chat.config.ChatConfig;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import mx.resources.IResourceManager;
   import mx.utils.StringUtil;
   
   public class DefaultChatRoomLoader
   {
      
      private static const RESOURCE_PREFIX:String = "chat_room_";
      
      private var _defaultChatRooms:Array;
      
      public function DefaultChatRoomLoader(param1:IResourceManager)
      {
         super();
         this._defaultChatRooms = this.getDefaultRoomsFromDynamicClientConfig(ClientConfig.instance.locale);
         if(this._defaultChatRooms == null)
         {
            this._defaultChatRooms = toLocalizedChatRooms(param1,this.createClassicDefaultMucRooms());
         }
      }
      
      public static function toLocalizedChatRooms(param1:IResourceManager, param2:Array) : Array
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param2)
         {
            _loc5_ = param1.getString("resources",_loc4_);
            if(_loc5_)
            {
               _loc3_.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      private static function parseChatRoomsFromString(param1:String) : Array
      {
         var delimitedChatRooms:String = param1;
         return StringUtil.trimArrayElements(delimitedChatRooms,",").split(",").filter(function(param1:String, param2:int, param3:Array):Boolean
         {
            return param1.length > 0;
         });
      }
      
      private function createClassicDefaultMucRooms() : Array
      {
         var rooms:Array = ["strategy","noob","lookingforgroup","public_chat"];
         if(Boolean(ClientConfig.instance.localeSpecificChatRoomsEnabled) && ClientConfig.instance.locale == "ko_KR")
         {
            rooms = rooms.concat(["beginner_1","beginner_2","beginner_3","beginner_4","intermediate_1","intermediate_2","intermediate_3","intermediate_4","advanced_1","advanced_2"]);
         }
         return rooms.map(function(param1:String, param2:int, param3:Array):String
         {
            return RESOURCE_PREFIX + param1;
         });
      }
      
      public function getLocalizedDefaultChatRooms() : Array
      {
         return this._defaultChatRooms;
      }
      
      private function getDefaultRoomsFromDynamicClientConfig(param1:String) : Array
      {
         var _loc2_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.DEFAULT_MUC_ROOMS + "-" + param1,null);
         var _loc3_:String = _loc2_.getString();
         if(_loc3_ != null)
         {
            return parseChatRoomsFromString(_loc3_);
         }
         var _loc4_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(ChatConfig.NAMESPACE,ChatConfig.DEFAULT_MUC_ROOMS,null);
         var _loc5_:String = _loc4_.getString();
         if(_loc5_ != null)
         {
            return parseChatRoomsFromString(_loc5_);
         }
         return null;
      }
   }
}

