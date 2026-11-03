package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   
   public class ChatPresenceLayering
   {
      
      private var _basePresence:String;
      
      private var _presenceLayers:Vector.<String> = new Vector.<String>();
      
      private var _presenceController:PresenceController;
      
      public function ChatPresenceLayering(param1:PresenceController)
      {
         super();
         this._presenceController = param1;
      }
      
      public function get presenceWithPrecedence() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = this._basePresence;
         for each(_loc2_ in this._presenceLayers)
         {
            if(PresenceStatusXML.getStatusPrecedence(_loc2_) > PresenceStatusXML.getStatusPrecedence(_loc1_))
            {
               _loc1_ = _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function removePresenceLayer(param1:String, param2:Boolean) : void
      {
         var _loc3_:int = this._presenceLayers.indexOf(param1);
         if(_loc3_ >= 0)
         {
            this._presenceLayers.splice(_loc3_,1);
         }
         this._presenceController.setGameStatus(this.presenceWithPrecedence,PresenceStatusXML.getStatusShowMode(this.presenceWithPrecedence),param2,true);
      }
      
      public function changeBasePresence(param1:String) : void
      {
         this._basePresence = param1;
      }
      
      public function addPresenceLayer(param1:String, param2:Boolean) : void
      {
         this._presenceLayers.push(param1);
         this._presenceController.setGameStatus(this.presenceWithPrecedence,PresenceStatusXML.getStatusShowMode(this.presenceWithPrecedence),param2,true);
      }
   }
}

