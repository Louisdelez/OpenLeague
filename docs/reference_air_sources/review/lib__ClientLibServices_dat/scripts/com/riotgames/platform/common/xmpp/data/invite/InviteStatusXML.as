package com.riotgames.platform.common.xmpp.data.invite
{
   import blix.util.string.parseBool;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class InviteStatusXML extends XMLStanza
   {
      
      private static var ELEMENT:String = "body";
      
      private static var ENTRY_INVITE_LIST:String = "invitelist";
      
      private static var ENTRY_INVITEE:String = "invitee";
      
      private var invitelist:XMLNode;
      
      public function InviteStatusXML(param1:String = null)
      {
         var _loc2_:XMLDocument = null;
         super();
         if(param1 != null)
         {
            _loc2_ = new XMLDocument();
            _loc2_.ignoreWhite = true;
            _loc2_.parseXML(param1);
            setNode(_loc2_.firstChild);
            this.invitelist = this.getNodeByName(ENTRY_INVITE_LIST);
         }
         else
         {
            super.getNode().nodeName = ELEMENT;
            this.invitelist = ensureNode(null,ENTRY_INVITE_LIST);
         }
      }
      
      public function setInviteList(param1:Array) : void
      {
         var _loc2_:InviteParticipant = null;
         var _loc3_:XMLNode = null;
         for each(_loc2_ in param1)
         {
            _loc3_ = new XMLNode(1,ENTRY_INVITEE);
            _loc3_.attributes.jid = _loc2_.jid.escaped.toString();
            _loc3_.attributes.name = _loc2_.name;
            _loc3_.attributes.status = _loc2_.status;
            _loc3_.attributes.summonerId = _loc2_.summonerId;
            _loc3_.attributes.isOwner = _loc2_.isOwner.toString();
            _loc3_.attributes.isInvitor = _loc2_.isInvitor.toString();
            _loc3_.attributes.profileIconId = _loc2_.profileIconId.toString();
            this.invitelist.appendChild(_loc3_);
         }
      }
      
      private function getNodeByName(param1:String) : XMLNode
      {
         var _loc2_:XMLNode = null;
         if(getNode() != null)
         {
            for each(_loc2_ in getNode().childNodes)
            {
               if(_loc2_.nodeName == param1)
               {
                  return _loc2_;
               }
            }
         }
         return null;
      }
      
      public function getInviteList() : Array
      {
         var _loc2_:XMLNode = null;
         var _loc3_:InviteParticipant = null;
         if(!this.invitelist)
         {
            return null;
         }
         var _loc1_:Array = [];
         for each(_loc2_ in this.invitelist.childNodes)
         {
            _loc3_ = new InviteParticipant();
            _loc3_.name = _loc2_.attributes.name;
            _loc3_.summonerId = parseFloat(_loc2_.attributes.summonerId);
            _loc3_.status = _loc2_.attributes.status;
            _loc3_.jid = new UnescapedJID(_loc2_.attributes.jid);
            _loc3_.isOwner = parseBool(_loc2_.attributes.isOwner,false);
            _loc3_.isInvitor = parseBool(_loc2_.attributes.isInvitor,false);
            _loc3_.profileIconId = parseInt(_loc2_.attributes.profileIconId);
            _loc1_.push(_loc3_);
         }
         return _loc1_;
      }
   }
}

